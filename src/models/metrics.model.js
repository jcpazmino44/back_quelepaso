const db = require('../config/db');

const create = async ({
  user_id,
  session_id,
  platform,
  event,
  data,
  device,
  app_version,
  created_at
}) => {
  await db.query(
    'INSERT INTO metrics (user_id, session_id, platform, event, data, device, app_version, created_at) VALUES ($1, $2, $3, $4, $5, $6, $7, COALESCE($8, NOW()))',
    [
      user_id || null,
      session_id || null,
      platform || null,
      event || null,
      data || null,
      device || null,
      app_version || null,
      created_at || null
    ]
  );
};

module.exports = {
  create
};
