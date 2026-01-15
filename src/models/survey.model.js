const db = require('../config/db');

const create = async ({
  user_id,
  device_id,
  diagnostic_id,
  session_id,
  app_version,
  platform,
  screen,
  understood_rating,
  confidence_rating,
  decision,
  repeat_rating,
  most_useful
}) => {
  const result = await db.query(
    `
      INSERT INTO survey_responses (
        user_id,
        device_id,
        diagnostic_id,
        session_id,
        app_version,
        platform,
        screen,
        understood_rating,
        confidence_rating,
        decision,
        repeat_rating,
        most_useful
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
      RETURNING id, created_at
    `,
    [
      user_id || null,
      device_id || null,
      diagnostic_id || null,
      session_id || null,
      app_version || null,
      platform || null,
      screen || null,
      understood_rating,
      confidence_rating,
      decision,
      repeat_rating,
      most_useful || null
    ]
  );

  return result.rows[0];
};

module.exports = {
  create
};
