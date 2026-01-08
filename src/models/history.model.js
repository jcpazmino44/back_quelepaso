const db = require('../config/db');

const findByUserId = async (userId) => {
  const result = await db.query(
    `
      SELECT
        h.id,
        h.diagnostic_id,
        h.title,
        h.status,
        h.created_at,
        h.category_id,
        c.slug AS category_slug,
        c.name AS category_name,
        c.icon AS category_icon,
        c.tint_color AS category_tint_color,
        c.bg_color AS category_bg_color
      FROM history h
      LEFT JOIN categories c ON c.id = h.category_id
      WHERE h.user_id = $1
      ORDER BY h.created_at DESC
    `,
    [userId]
  );
  return result.rows;
};

const findAll = async () => {
  const result = await db.query(
    `
      SELECT
        h.id,
        h.diagnostic_id,
        h.title,
        h.status,
        h.created_at,
        h.category_id,
        c.slug AS category_slug,
        c.name AS category_name,
        c.icon AS category_icon,
        c.tint_color AS category_tint_color,
        c.bg_color AS category_bg_color
      FROM history h
      LEFT JOIN categories c ON c.id = h.category_id
      ORDER BY h.created_at DESC
    `
  );
  return result.rows;
};

const updateStatusByDiagnosticId = async ({ diagnosticId, status }) => {
  const result = await db.query(
    `
      UPDATE history
      SET status = $1
      WHERE diagnostic_id = $2
      RETURNING id, diagnostic_id, status, created_at
    `,
    [status, diagnosticId]
  );
  return result.rows[0] || null;
};

module.exports = {
  findByUserId,
  findAll,
  updateStatusByDiagnosticId
};
