const db = require('../config/db');

const create = async ({
  user_id,
  category_id,
  guide_id,
  input_text,
  image_url,
  possible_cause,
  risk_level
}) => {
  const result = await db.query(
    'INSERT INTO diagnostics (user_id, category_id, guide_id, input_text, image_url, possible_cause, risk_level) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id',
    [
      user_id || null,
      category_id,
      guide_id || null,
      input_text || null,
      image_url || null,
      possible_cause,
      risk_level
    ]
  );
  return result.rows[0]?.id ?? null;
};

const findById = async (id) => {
  const result = await db.query(
    `
      SELECT
        d.id,
        d.category_id,
        d.guide_id,
        d.possible_cause,
        d.risk_level,
        d.created_at,
        g.slug AS guide_slug
      FROM diagnostics d
      LEFT JOIN guides g ON g.id = d.guide_id
      WHERE d.id = $1
      LIMIT 1
    `,
    [id]
  );
  return result.rows[0] || null;
};

module.exports = {
  create,
  findById
};
