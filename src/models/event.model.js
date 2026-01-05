const db = require('../config/db');

const create = async ({
  device_id,
  user_id,
  diagnostic_id,
  event_name,
  screen_name,
  event_value,
  meta_json
}) => {
  const result = await db.query(
    `INSERT INTO events (device_id, user_id, diagnostic_id, event_name, screen_name, event_value, meta_json)
     VALUES ($1, $2, $3, $4, $5, $6, $7)
     RETURNING id;`,
    [
      device_id || null,
      user_id || null,
      diagnostic_id || null,
      event_name,
      screen_name || null,
      event_value || null,
      meta_json || null
    ]
  );

  return result.rows[0];
};

module.exports = {
  create
};
