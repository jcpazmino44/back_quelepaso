const db = require('../config/db');

const baseSelect = `
  SELECT
    id,
    slug,
    title,
    summary,
    duration_minutes,
    difficulty_level,
    safety_title,
    safety_text,
    success_title,
    success_text,
    cover_image_url,
    is_active,
    version,
    created_at,
    updated_at
  FROM guides
`;

const findBySlug = async ({ slug, isActive = true } = {}) => {
  if (!slug) {
    return null;
  }
  const values = [slug];
  let whereClause = 'WHERE lower(slug) = lower($1)';
  if (isActive) {
    whereClause += ' AND is_active = true';
  }
  const result = await db.query(`${baseSelect} ${whereClause} LIMIT 1`, values);
  return result.rows[0] || null;
};

const buildGuideFilters = ({ q, difficulty, minMinutes, maxMinutes } = {}) => {
  const values = [];
  const clauses = ['is_active = true'];

  if (q) {
    values.push(`%${q}%`);
    clauses.push(`(title ILIKE $${values.length} OR summary ILIKE $${values.length})`);
  }

  if (difficulty) {
    values.push(difficulty);
    clauses.push(`difficulty_level = $${values.length}`);
  }

  if (minMinutes !== null && minMinutes !== undefined) {
    values.push(minMinutes);
    clauses.push(`duration_minutes >= $${values.length}`);
  }

  if (maxMinutes !== null && maxMinutes !== undefined) {
    values.push(maxMinutes);
    clauses.push(`duration_minutes <= $${values.length}`);
  }

  return {
    whereClause: `WHERE ${clauses.join(' AND ')}`,
    values
  };
};

const listActive = async ({
  q,
  difficulty,
  minMinutes,
  maxMinutes,
  limit = 20,
  offset = 0
} = {}) => {
  const { whereClause, values } = buildGuideFilters({
    q,
    difficulty,
    minMinutes,
    maxMinutes
  });
  values.push(limit);
  values.push(offset);

  const result = await db.query(
    `
      ${baseSelect}
      ${whereClause}
      ORDER BY created_at DESC
      LIMIT $${values.length - 1} OFFSET $${values.length}
    `,
    values
  );
  return result.rows;
};

const countActive = async ({ q, difficulty, minMinutes, maxMinutes } = {}) => {
  const { whereClause, values } = buildGuideFilters({
    q,
    difficulty,
    minMinutes,
    maxMinutes
  });
  const result = await db.query(
    `
      SELECT COUNT(*)::int AS total
      FROM guides
      ${whereClause}
    `,
    values
  );
  return result.rows[0]?.total ?? 0;
};

const listByCategorySlug = async ({ categorySlug, limit = 20, offset = 0 } = {}) => {
  const values = [categorySlug, limit, offset];
  const result = await db.query(
    `
      ${baseSelect}
      INNER JOIN guide_categories gc ON gc.guide_id = guides.id
      INNER JOIN categories c ON c.id = gc.category_id
      WHERE guides.is_active = true AND lower(c.slug) = lower($1)
      ORDER BY guides.created_at DESC
      LIMIT $2 OFFSET $3
    `,
    values
  );
  return result.rows;
};

const countByCategorySlug = async ({ categorySlug } = {}) => {
  const values = [categorySlug];
  const result = await db.query(
    `
      SELECT COUNT(*)::int AS total
      FROM guides g
      INNER JOIN guide_categories gc ON gc.guide_id = g.id
      INNER JOIN categories c ON c.id = gc.category_id
      WHERE g.is_active = true AND lower(c.slug) = lower($1)
    `,
    values
  );
  return result.rows[0]?.total ?? 0;
};

const listStepsByGuideId = async (guideId) => {
  const result = await db.query(
    `
      SELECT
        id,
        guide_id,
        step_number,
        title,
        body,
        image_url,
        estimated_minutes,
        created_at,
        updated_at
      FROM guide_steps
      WHERE guide_id = $1
      ORDER BY step_number ASC
    `,
    [guideId]
  );
  return result.rows;
};

const listToolsByGuideId = async (guideId) => {
  const result = await db.query(
    `
      SELECT
        t.id,
        t.slug,
        t.name,
        t.icon,
        gt.is_required,
        gt.order_index
      FROM guide_tools gt
      INNER JOIN tools t ON t.id = gt.tool_id
      WHERE gt.guide_id = $1
      ORDER BY gt.order_index ASC
    `,
    [guideId]
  );
  return result.rows;
};

module.exports = {
  findBySlug,
  listActive,
  countActive,
  listByCategorySlug,
  countByCategorySlug,
  listStepsByGuideId,
  listToolsByGuideId
};
