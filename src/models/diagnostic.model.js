const db = require('../config/db');

const create = async ({
  user_id,
  category,
  input_text,
  image_url,
  possible_cause,
  risk_level
}) => {
  const [result] = await db.query(
    'INSERT INTO diagnostics (user_id, category, input_text, image_url, possible_cause, risk_level) VALUES (?, ?, ?, ?, ?, ?)',
    [
      user_id || null,
      category,
      input_text || null,
      image_url || null,
      possible_cause,
      risk_level
    ]
  );
  return result.insertId;
};

const findById = async (id) => {
  const [rows] = await db.query(
    'SELECT id, possible_cause, risk_level, created_at FROM diagnostics WHERE id = ? LIMIT 1',
    [id]
  );
  return rows[0] || null;
};

module.exports = {
  create,
  findById
};
