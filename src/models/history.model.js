const db = require('../config/db');

const findByUserId = async (userId) => {
  const result = await db.query(
    'SELECT id, title, category, status, created_at FROM history WHERE user_id = $1 ORDER BY created_at DESC',
    [userId]
  );
  return result.rows;
};

const findAll = async () => {
  const result = await db.query(
    'SELECT id, title, category, status, created_at FROM history ORDER BY created_at DESC'
  );
  return result.rows;
};

module.exports = {
  findByUserId,
  findAll
};
