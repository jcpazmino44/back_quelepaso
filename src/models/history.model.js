const db = require('../config/db');

const findByUserId = async (userId) => {
  const [rows] = await db.query(
    'SELECT id, title, category, status, created_at FROM history WHERE user_id = ? ORDER BY created_at DESC',
    [userId]
  );
  return rows;
};

const findAll = async () => {
  const [rows] = await db.query(
    'SELECT id, title, category, status, created_at FROM history ORDER BY created_at DESC'
  );
  return rows;
};

module.exports = {
  findByUserId,
  findAll
};
