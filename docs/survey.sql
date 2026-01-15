DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type WHERE typname = 'survey_decision_enum'
  ) THEN
    CREATE TYPE survey_decision_enum AS ENUM (
      'tried_fix',
      'contacted_tech',
      'no_action'
    );
  END IF;
END
$$;

CREATE TABLE IF NOT EXISTS survey_responses (
  id                BIGSERIAL PRIMARY KEY,
  user_id           BIGINT,
  device_id         BIGINT,
  diagnostic_id     BIGINT,
  session_id        UUID,
  app_version       VARCHAR(30),
  platform          VARCHAR(20),
  screen            VARCHAR(60),

  understood_rating  SMALLINT NOT NULL CHECK (understood_rating BETWEEN 1 AND 5),
  confidence_rating  SMALLINT NOT NULL CHECK (confidence_rating BETWEEN 1 AND 5),
  decision           survey_decision_enum NOT NULL,
  repeat_rating      SMALLINT NOT NULL CHECK (repeat_rating BETWEEN 1 AND 5),
  most_useful        VARCHAR(250),

  created_at        TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_survey_responses_device_time
  ON survey_responses (device_id, created_at);

CREATE INDEX IF NOT EXISTS idx_survey_responses_session
  ON survey_responses (session_id);

CREATE INDEX IF NOT EXISTS idx_survey_responses_diagnostic
  ON survey_responses (diagnostic_id);
