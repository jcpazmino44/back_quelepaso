const db = require('../config/db');

const baseSelect = `
  SELECT
    id,
    slug,
    name,
    description,
    icon,
    tint_color,
    bg_color,
    is_quick,
    order_index,
    is_active,
    created_at,
    updated_at
  FROM categories
`;

const findById = async (id) => {
  const result = await db.query(`${baseSelect} WHERE id = $1 LIMIT 1`, [id]);
  return result.rows[0] || null;
};

const findBySlug = async (slug) => {
  const result = await db.query(`${baseSelect} WHERE lower(slug) = lower($1) LIMIT 1`, [slug]);
  return result.rows[0] || null;
};

const listActive = async ({ isQuick } = {}) => {
  const values = [];
  let whereClause = 'WHERE is_active = true';
  if (isQuick !== undefined) {
    values.push(Boolean(isQuick));
    whereClause += ` AND is_quick = $${values.length}`;
  }
  const result = await db.query(
    `${baseSelect} ${whereClause} ORDER BY order_index ASC, name ASC`,
    values
  );
  return result.rows;
};

module.exports = {
  findById,
  findBySlug,
  listActive
};
