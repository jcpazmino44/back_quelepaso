-- Iteracion 1 (PostgreSQL): nuevas tablas, nuevos campos e indices recomendados.

-- 0) Tipos enum necesarios.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type WHERE typname = 'device_platform_enum'
  ) THEN
    CREATE TYPE device_platform_enum AS ENUM ('android', 'ios', 'web');
  END IF;
END
$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type WHERE typname = 'event_name_enum'
  ) THEN
    CREATE TYPE event_name_enum AS ENUM (
      'diagnostic_started',
      'image_uploaded',
      'diagnostic_completed',
      'guide_opened',
      'guide_step_viewed',
      'guide_completed',
      'funnel_step',
      'funnel_exit',
      'category_selected',
      'technicians_list_viewed',
      'technician_contact_clicked',
      'history_viewed',
      'session_started',
      'session_ended'
    );
  END IF;
END
$$;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_type WHERE typname = 'event_name_enum'
  ) THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_enum e
      JOIN pg_type t ON t.oid = e.enumtypid
      WHERE t.typname = 'event_name_enum' AND e.enumlabel = 'funnel_step'
    ) THEN
      ALTER TYPE event_name_enum ADD VALUE 'funnel_step';
    END IF;

    IF NOT EXISTS (
      SELECT 1
      FROM pg_enum e
      JOIN pg_type t ON t.oid = e.enumtypid
      WHERE t.typname = 'event_name_enum' AND e.enumlabel = 'funnel_exit'
    ) THEN
      ALTER TYPE event_name_enum ADD VALUE 'funnel_exit';
    END IF;

    IF NOT EXISTS (
      SELECT 1
      FROM pg_enum e
      JOIN pg_type t ON t.oid = e.enumtypid
      WHERE t.typname = 'event_name_enum' AND e.enumlabel = 'category_selected'
    ) THEN
      ALTER TYPE event_name_enum ADD VALUE 'category_selected';
    END IF;
  END IF;
END
$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type WHERE typname = 'diagnostic_resolution_action_enum'
  ) THEN
    CREATE TYPE diagnostic_resolution_action_enum AS ENUM (
      'diy',
      'contact_technician',
      'warning_only'
    );
  END IF;
END
$$;

-- 1) Tabla devices (identidad ligera).
CREATE TABLE IF NOT EXISTS devices (
  id           BIGSERIAL PRIMARY KEY,
  device_uuid  VARCHAR(36) NOT NULL,
  platform     device_platform_enum NOT NULL DEFAULT 'android',
  app_version  VARCHAR(30),
  city         VARCHAR(80),
  zone         VARCHAR(80),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_seen_at TIMESTAMPTZ,
  CONSTRAINT uk_devices_uuid UNIQUE (device_uuid)
);

CREATE INDEX IF NOT EXISTS idx_devices_city ON devices (city);

-- 2) Enlazar diagnostics y history con devices.
ALTER TABLE diagnostics
  ADD COLUMN IF NOT EXISTS device_id BIGINT;

ALTER TABLE history
  ADD COLUMN IF NOT EXISTS device_id BIGINT;

CREATE INDEX IF NOT EXISTS idx_diag_device_created ON diagnostics (device_id, created_at);
CREATE INDEX IF NOT EXISTS idx_history_device_created ON history (device_id, created_at);

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'fk_diagnostics_device'
  ) THEN
    ALTER TABLE diagnostics
      ADD CONSTRAINT fk_diagnostics_device
      FOREIGN KEY (device_id) REFERENCES devices(id)
      ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END
$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'fk_history_device'
  ) THEN
    ALTER TABLE history
      ADD CONSTRAINT fk_history_device
      FOREIGN KEY (device_id) REFERENCES devices(id)
      ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END
$$;

-- 3) Tabla events para instrumentacion de aprendizaje.
CREATE TABLE IF NOT EXISTS events (
  id            BIGSERIAL PRIMARY KEY,
  device_id     BIGINT,
  user_id       BIGINT,
  diagnostic_id BIGINT,
  event_name    event_name_enum NOT NULL,
  screen_name   VARCHAR(60),
  event_value   VARCHAR(120),
  meta_json     JSONB,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_events_name_time ON events (event_name, created_at);
CREATE INDEX IF NOT EXISTS idx_events_device_time ON events (device_id, created_at);
CREATE INDEX IF NOT EXISTS idx_events_diag_time ON events (diagnostic_id, created_at);

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'fk_events_device'
  ) THEN
    ALTER TABLE events
      ADD CONSTRAINT fk_events_device
      FOREIGN KEY (device_id) REFERENCES devices(id)
      ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END
$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'fk_events_user'
  ) THEN
    ALTER TABLE events
      ADD CONSTRAINT fk_events_user
      FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END
$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'fk_events_diagnostic'
  ) THEN
    ALTER TABLE events
      ADD CONSTRAINT fk_events_diagnostic
      FOREIGN KEY (diagnostic_id) REFERENCES diagnostics(id)
      ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END
$$;

-- 4) Campos opcionales para calidad de diagnostico y feedback.
ALTER TABLE diagnostics
  ADD COLUMN IF NOT EXISTS confidence NUMERIC(4,3),
  ADD COLUMN IF NOT EXISTS model_version VARCHAR(40),
  ADD COLUMN IF NOT EXISTS resolution_action diagnostic_resolution_action_enum,
  ADD COLUMN IF NOT EXISTS feedback_useful BOOLEAN,
  ADD COLUMN IF NOT EXISTS feedback_comment VARCHAR(300);

-- 5) Indices recomendados si se conserva metrics para eventos.
CREATE INDEX IF NOT EXISTS idx_metrics_event_created ON metrics (event, created_at);

