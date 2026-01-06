-- =========================================================
-- Archivo: categorias.sql
-- Proyecto: QueLePaso (PostgreSQL)
-- Objetivo: Normalización de categorías según DER actual
-- 1) Crear tabla categories
-- 2) Agregar category_id (FK) a diagnostics y history
-- 3) Seed de categorías
-- 4) Migración de datos desde diagnostics.category / history.category -> category_id
-- =========================================================
-- FIX: Si diagnostics.category o history.category son ENUM (ej: category_enum),
--      se debe castear a TEXT antes de usar trim/lower, para evitar:
--      "function pg_catalog.btrim(category_enum) does not exist"
-- =========================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

BEGIN;

-- =========================================================
-- 1) Tabla categories
-- =========================================================
CREATE TABLE IF NOT EXISTS categories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug        VARCHAR(50) NOT NULL UNIQUE,
  name        VARCHAR(80) NOT NULL,
  description VARCHAR(255),
  icon        VARCHAR(50) NOT NULL,
  tint_color  CHAR(7) NOT NULL,
  bg_color    CHAR(7) NOT NULL,
  is_quick    BOOLEAN NOT NULL DEFAULT FALSE,
  order_index INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'categories_tint_color_chk') THEN
    ALTER TABLE categories
      ADD CONSTRAINT categories_tint_color_chk
      CHECK (tint_color ~ '^#[0-9A-Fa-f]{6}$');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'categories_bg_color_chk') THEN
    ALTER TABLE categories
      ADD CONSTRAINT categories_bg_color_chk
      CHECK (bg_color ~ '^#[0-9A-Fa-f]{6}$');
  END IF;
END $$;

CREATE OR REPLACE FUNCTION set_updated_at_categories()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_categories_updated_at') THEN
    CREATE TRIGGER trg_categories_updated_at
    BEFORE UPDATE ON categories
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at_categories();
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_categories_active_order
  ON categories (is_active, order_index);

CREATE INDEX IF NOT EXISTS idx_categories_quick_order
  ON categories (is_quick, order_index);

-- =========================================================
-- 2) Agregar category_id a diagnostics y history
-- =========================================================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name='diagnostics' AND column_name='category_id'
  ) THEN
    ALTER TABLE diagnostics
      ADD COLUMN category_id UUID NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_diagnostics_category') THEN
    ALTER TABLE diagnostics
      ADD CONSTRAINT fk_diagnostics_category
      FOREIGN KEY (category_id) REFERENCES categories(id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_diagnostics_category_id_created
  ON diagnostics (category_id, created_at DESC);

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name='history' AND column_name='category_id'
  ) THEN
    ALTER TABLE history
      ADD COLUMN category_id UUID NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_history_category') THEN
    ALTER TABLE history
      ADD CONSTRAINT fk_history_category
      FOREIGN KEY (category_id) REFERENCES categories(id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_history_category_id_created
  ON history (category_id, created_at DESC);

-- =========================================================
-- 3) Seed categories
-- =========================================================
INSERT INTO categories
  (slug, name, description, icon, tint_color, bg_color, is_quick, order_index, is_active)
VALUES
  ('plomeria',         'Plomería',          'Fugas, goteos, baja presión y sanitarios.', 'plumbing', '#1976D2', '#E3F2FD', TRUE, 1, TRUE),
  ('electricidad',     'Electricidad',      'Tomacorrientes, breakers, cortos y fallas.', 'bolt',     '#F9A825', '#FFF8E1', TRUE, 2, TRUE),
  ('electrodomesticos','Electrodomésticos', 'Nevera, lavadora, microondas y otros.',     'kitchen',  '#7B1FA2', '#F3E5F5', TRUE, 3, TRUE),
  ('internet',         'Internet',          'Wi‑Fi, router, señal y conectividad.',      'wifi',     '#388E3C', '#E8F5E9', TRUE, 4, TRUE)
ON CONFLICT (slug) DO NOTHING;

-- =========================================================
-- 4) Migración: category (TEXT o ENUM) -> category_id
--    IMPORTANTE: casteo a TEXT para soportar ENUMs (category_enum)
-- =========================================================

-- diagnostics
UPDATE diagnostics d
SET category_id = c.id
FROM categories c
WHERE d.category_id IS NULL
  AND d.category IS NOT NULL
  AND lower(btrim(d.category::text)) = c.slug;

-- variantes de electrodomésticos (con tilde)
UPDATE diagnostics d
SET category_id = c.id
FROM categories c
WHERE d.category_id IS NULL
  AND d.category IS NOT NULL
  AND lower(btrim(d.category::text)) IN ('electrodomésticos','electrodomesticos')
  AND c.slug = 'electrodomesticos';

-- history
UPDATE history h
SET category_id = c.id
FROM categories c
WHERE h.category_id IS NULL
  AND h.category IS NOT NULL
  AND lower(btrim(h.category::text)) = c.slug;

UPDATE history h
SET category_id = c.id
FROM categories c
WHERE h.category_id IS NULL
  AND h.category IS NOT NULL
  AND lower(btrim(h.category::text)) IN ('electrodomésticos','electrodomesticos')
  AND c.slug = 'electrodomesticos';

-- =========================================================
-- 5) Verificaciones (ejecuta manualmente si quieres)
-- =========================================================
-- SELECT COUNT(*) FROM diagnostics WHERE category_id IS NULL;
-- SELECT COUNT(*) FROM history    WHERE category_id IS NULL;

-- =========================================================
-- 6) Opcional (solo si todo quedó migrado)
-- =========================================================
-- ALTER TABLE diagnostics ALTER COLUMN category_id SET NOT NULL;
-- ALTER TABLE history    ALTER COLUMN category_id SET NOT NULL;
-- ALTER TABLE diagnostics DROP COLUMN category;
-- ALTER TABLE history    DROP COLUMN category;

COMMIT;
