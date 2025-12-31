const db = require('../config/db');

const findByPhone = async (phone) => {
  const [rows] = await db.query('SELECT * FROM users WHERE phone = ? LIMIT 1', [phone]);
  return rows[0] || null;
};

const findById = async (id) => {
  const [rows] = await db.query('SELECT * FROM users WHERE id = ? LIMIT 1', [id]);
  return rows[0] || null;
};

const create = async ({ full_name, phone, password_hash }) => {
  const [result] = await db.query(
    'INSERT INTO users (full_name, phone, password_hash) VALUES (?, ?, ?)',
    [full_name || null, phone, password_hash]
  );
  return result.insertId;
};

module.exports = {
  findByPhone,
  findById,
  create
};
