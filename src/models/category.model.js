const db = require('../config/db');

const baseSelect = `
  SELECT
    id,
    slug,
    name,
    description,
    icon,
    image_url,
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

const listWithGuideCounts = async ({ isQuick } = {}) => {
  const values = [];
  let whereClause = 'WHERE c.is_active = true';
  if (isQuick !== undefined) {
    values.push(Boolean(isQuick));
    whereClause += ` AND c.is_quick = $${values.length}`;
  }
  const result = await db.query(
    `
      SELECT
        c.id,
        c.slug,
        c.name,
        c.description,
        c.icon,
        c.image_url,
        c.tint_color,
        c.bg_color,
        c.is_quick,
        c.order_index,
        c.is_active,
        c.created_at,
        c.updated_at,
        COUNT(DISTINCT g.id)::int AS guides_count
      FROM categories c
      LEFT JOIN guide_categories gc ON gc.category_id = c.id
      LEFT JOIN guides g ON g.id = gc.guide_id AND g.is_active = true
      ${whereClause}
      GROUP BY c.id
      ORDER BY c.order_index ASC, c.name ASC
    `,
    values
  );
  return result.rows;
};

module.exports = {
  findById,
  findBySlug,
  listActive,
  listWithGuideCounts
};
