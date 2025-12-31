const db = require('../config/db');

const findByPhone = async (phone) => {
  const result = await db.query('SELECT * FROM users WHERE phone = $1 LIMIT 1', [phone]);
  return result.rows[0] || null;
};

const findById = async (id) => {
  const result = await db.query('SELECT * FROM users WHERE id = $1 LIMIT 1', [id]);
  return result.rows[0] || null;
};

const create = async ({ full_name, phone, password_hash }) => {
  const result = await db.query(
    'INSERT INTO users (full_name, phone, password_hash) VALUES ($1, $2, $3) RETURNING id',
    [full_name || null, phone, password_hash]
  );
  return result.rows[0]?.id ?? null;
};

module.exports = {
  findByPhone,
  findById,
  create
};
