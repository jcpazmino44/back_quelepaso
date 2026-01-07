-- ============================================================
-- QueLePaso - Contenido de Guías (DIY)
-- Postgres SQL: crea tablas + seeds + ejemplo "Arreglando la gotera"
-- Requisitos:
--  - Ya existe tabla public.categories con slugs: plomeria, electricidad,
--    electrodomesticos, internet, otro (según tu BD).
-- ============================================================

BEGIN;

-- Para UUIDs (gen_random_uuid). Si ya lo tienes, no pasa nada.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ============================================================
-- 1) TABLAS
-- ============================================================

-- 1.1) Guías (pantalla completa)
CREATE TABLE IF NOT EXISTS public.guides (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug             varchar(80)  NOT NULL UNIQUE,
  title            varchar(120) NOT NULL,
  summary          text,
  duration_minutes int          NOT NULL DEFAULT 0 CHECK (duration_minutes >= 0),
  difficulty_level varchar(20)  NOT NULL DEFAULT 'basico'
    CHECK (difficulty_level IN ('basico','intermedio','avanzado')),

  safety_title     varchar(120),
  safety_text      text,

  success_title    varchar(120),
  success_text     text,

  cover_image_url  text,  -- opcional (URL o asset_key)
  is_active        boolean      NOT NULL DEFAULT true,
  version          int          NOT NULL DEFAULT 1 CHECK (version >= 1),

  created_at       timestamptz  NOT NULL DEFAULT now(),
  updated_at       timestamptz  NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_guides_active_slug
  ON public.guides (is_active, slug);

-- 1.2) Pasos de una guía
CREATE TABLE IF NOT EXISTS public.guide_steps (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  guide_id         uuid NOT NULL REFERENCES public.guides(id) ON DELETE CASCADE,
  step_number      int  NOT NULL CHECK (step_number >= 1),
  title            varchar(140) NOT NULL,
  body             text NOT NULL,
  image_url        text,        -- URL o asset_key
  estimated_minutes int CHECK (estimated_minutes IS NULL OR estimated_minutes >= 0),

  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT uq_guide_steps_guide_step UNIQUE (guide_id, step_number)
);

CREATE INDEX IF NOT EXISTS idx_guide_steps_guide_step
  ON public.guide_steps (guide_id, step_number);

-- 1.3) Catálogo de herramientas
CREATE TABLE IF NOT EXISTS public.tools (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug       varchar(80)  NOT NULL UNIQUE,
  name       varchar(120) NOT NULL,
  icon       varchar(50), -- opcional (MaterialIcons)
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- 1.4) Herramientas por guía (many-to-many)
CREATE TABLE IF NOT EXISTS public.guide_tools (
  guide_id    uuid NOT NULL REFERENCES public.guides(id) ON DELETE CASCADE,
  tool_id     uuid NOT NULL REFERENCES public.tools(id)  ON DELETE RESTRICT,
  is_required boolean NOT NULL DEFAULT true,
  order_index int     NOT NULL DEFAULT 0,

  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),

  PRIMARY KEY (guide_id, tool_id)
);

CREATE INDEX IF NOT EXISTS idx_guide_tools_guide_order
  ON public.guide_tools (guide_id, order_index);

-- 1.5) Relación guía ↔ categoría (many-to-many)
CREATE TABLE IF NOT EXISTS public.guide_categories (
  guide_id    uuid NOT NULL REFERENCES public.guides(id)     ON DELETE CASCADE,
  category_id uuid NOT NULL REFERENCES public.categories(id) ON DELETE RESTRICT,

  created_at  timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (guide_id, category_id)
);

CREATE INDEX IF NOT EXISTS idx_guide_categories_category
  ON public.guide_categories (category_id);

-- ============================================================
-- 2) SEED: HERRAMIENTAS BASE (coherentes con el ejemplo)
-- ============================================================

INSERT INTO public.tools (slug, name, icon)
VALUES
  ('destornillador-estrella', 'Destornillador de estrella', 'build'),
  ('cinta-teflon',            'Cinta de teflón',            'content_cut'),
  ('llave-inglesa',           'Llave de tubos (Inglesa)',   'build'),
  ('trapo',                   'Trapo o paño',               'cleaning_services'),
  ('balde',                   'Balde o recipiente',         'local_drink')
ON CONFLICT (slug) DO NOTHING;

-- ============================================================
-- 3) SEED: EJEMPLO DE GUÍA - "Arreglando la gotera"
-- ============================================================

-- 3.1) Crear guía
INSERT INTO public.guides (
  slug, title, summary,
  duration_minutes, difficulty_level,
  safety_title, safety_text,
  success_title, success_text,
  cover_image_url, is_active, version
)
VALUES (
  'arreglando-la-gotera',
  'Arreglando la gotera',
  'Guía rápida para detener una fuga leve en el grifo (cambio de empaque y ajuste básico).',
  20,
  'basico',
  '¡Ojo! Seguridad ante todo',
  'Antes de empezar, cierre la llave de paso del agua. Coloque un balde debajo y seque la zona para ver la fuga con claridad. Si hay cables cerca, apártelos y mantenga el área seca.',
  '¡Listo el pollo!',
  'Vuelva a armar todo al revés de como lo desarmó. Abra la llave de paso y pruebe. Si no gotea, ¡éxito! Si persiste, puede requerir cambio de pieza o apoyo de un técnico.',
  NULL,
  true,
  1
)
ON CONFLICT (slug) DO NOTHING;

-- 3.2) Vincular guía a categoría "plomeria" (y opcionalmente "otro")
--     (usa los IDs reales desde categories por slug)
INSERT INTO public.guide_categories (guide_id, category_id)
SELECT g.id, c.id
FROM public.guides g
JOIN public.categories c ON c.slug = 'plomeria'
WHERE g.slug = 'arreglando-la-gotera'
ON CONFLICT DO NOTHING;

-- (Opcional) también aparece en "otro" para casos no clasificados
INSERT INTO public.guide_categories (guide_id, category_id)
SELECT g.id, c.id
FROM public.guides g
JOIN public.categories c ON c.slug = 'otro'
WHERE g.slug = 'arreglando-la-gotera'
ON CONFLICT DO NOTHING;

-- 3.3) Herramientas requeridas (checklist "Lo que necesita")
INSERT INTO public.guide_tools (guide_id, tool_id, is_required, order_index)
SELECT g.id, t.id, true, x.order_index
FROM public.guides g
JOIN (
  VALUES
    ('destornillador-estrella', 1),
    ('cinta-teflon',            2),
    ('llave-inglesa',           3),
    ('trapo',                   4),
    ('balde',                   5)
) AS x(tool_slug, order_index) ON true
JOIN public.tools t ON t.slug = x.tool_slug
WHERE g.slug = 'arreglando-la-gotera'
ON CONFLICT (guide_id, tool_id) DO UPDATE
SET is_required = EXCLUDED.is_required,
    order_index = EXCLUDED.order_index,
    updated_at = now();

-- 3.4) Pasos (Manos a la obra)
-- Nota: image_url puede ser un asset local o URL remota. Aquí dejo ejemplo con rutas tipo assets.
-- Ajusta a tu proyecto: "assets/images/step1.jpg", etc.
INSERT INTO public.guide_steps (guide_id, step_number, title, body, image_url, estimated_minutes)
SELECT g.id, s.step_number, s.title, s.body, s.image_url, s.estimated_minutes
FROM public.guides g
JOIN (
  VALUES
    (1,
     'Quite la tapa del grifo',
     'Con el destornillador, retire el tornillo de la parte superior o frontal. A veces está oculto bajo un tapón plástico (hágale palanca suave con la uña o una punta plástica).',
     'assets/images/step1.jpg',
     5),
    (2,
     'Desenrosque el vástago',
     'Use la llave inglesa. Gire hacia la izquierda (como abriendo la llave) hasta que salga la pieza. No haga fuerza bruta: si está duro, aplique movimiento corto y constante.',
     'assets/images/step2.jpg',
     7),
    (3,
     'Cambie el empaque',
     'La gomita negra de abajo es el empaque. Reemplácela por una nueva. Si la rosca se ve gastada, dé unas vueltas con cinta de teflón antes de volver a armar.',
     'assets/images/step3.jpg',
     8)
) AS s(step_number, title, body, image_url, estimated_minutes) ON true
WHERE g.slug = 'arreglando-la-gotera'
ON CONFLICT (guide_id, step_number) DO UPDATE
SET title = EXCLUDED.title,
    body  = EXCLUDED.body,
    image_url = EXCLUDED.image_url,
    estimated_minutes = EXCLUDED.estimated_minutes,
    updated_at = now();

-- ============================================================
-- 4) CONSULTAS DE VALIDACIÓN (opcional)
-- ============================================================
-- Ver guía completa:
-- SELECT * FROM public.guides WHERE slug='arreglando-la-gotera';
--
-- Ver herramientas:
-- SELECT t.name, gt.order_index
-- FROM public.guides g
-- JOIN public.guide_tools gt ON gt.guide_id = g.id
-- JOIN public.tools t ON t.id = gt.tool_id
-- WHERE g.slug='arreglando-la-gotera'
-- ORDER BY gt.order_index;
--
-- Ver pasos:
-- SELECT step_number, title, body, image_url
-- FROM public.guides g
-- JOIN public.guide_steps s ON s.guide_id = g.id
-- WHERE g.slug='arreglando-la-gotera'
-- ORDER BY step_number;

COMMIT;

-- ============================================================
-- (OPCIONAL / RECOMENDADO PARA EL FUTURO)
-- Relacionar diagnósticos con guía (si quieres “guía sugerida” por diagnóstico):
--   ALTER TABLE public.diagnostics ADD COLUMN guide_id uuid NULL;
--   ALTER TABLE public.diagnostics
--     ADD CONSTRAINT fk_diagnostics_guide
--     FOREIGN KEY (guide_id) REFERENCES public.guides(id)
--     ON DELETE SET NULL;
--
--   CREATE INDEX idx_diagnostics_guide_id_created
--     ON public.diagnostics (guide_id, created_at DESC);
-- ============================================================


-- trigger común para updates en guides, guide_steps, tools, guide_tools
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2) Triggers por tabla
DROP TRIGGER IF EXISTS trg_guides_updated_at ON public.guides;
CREATE TRIGGER trg_guides_updated_at
BEFORE UPDATE ON public.guides
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS trg_guide_steps_updated_at ON public.guide_steps;
CREATE TRIGGER trg_guide_steps_updated_at
BEFORE UPDATE ON public.guide_steps
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS trg_tools_updated_at ON public.tools;
CREATE TRIGGER trg_tools_updated_at
BEFORE UPDATE ON public.tools
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS trg_guide_tools_updated_at ON public.guide_tools;
CREATE TRIGGER trg_guide_tools_updated_at
BEFORE UPDATE ON public.guide_tools
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();