const db = require('../config/db');

const baseSelect = `
  SELECT
    g.id,
    g.slug,
    g.title,
    g.summary,
    g.duration_minutes,
    g.difficulty_level,
    g.safety_title,
    g.safety_text,
    g.success_title,
    g.success_text,
    g.cover_image_url,
    g.is_active,
    g.version,
    g.created_at,
    g.updated_at
  FROM guides g
`;

const findBySlug = async ({ slug, isActive = true } = {}) => {
  if (!slug) {
    return null;
  }
  const values = [slug];
  let whereClause = 'WHERE lower(g.slug) = lower($1)';
  if (isActive) {
    whereClause += ' AND g.is_active = true';
  }
  const result = await db.query(`${baseSelect} ${whereClause} LIMIT 1`, values);
  return result.rows[0] || null;
};

const buildGuideFilters = ({ q, difficulty, minMinutes, maxMinutes } = {}) => {
  const values = [];
  const clauses = ['g.is_active = true'];

  if (q) {
    values.push(`%${q}%`);
    clauses.push(`(g.title ILIKE $${values.length} OR g.summary ILIKE $${values.length})`);
  }

  if (difficulty) {
    values.push(difficulty);
    clauses.push(`g.difficulty_level = $${values.length}`);
  }

  if (minMinutes !== null && minMinutes !== undefined) {
    values.push(minMinutes);
    clauses.push(`g.duration_minutes >= $${values.length}`);
  }

  if (maxMinutes !== null && maxMinutes !== undefined) {
    values.push(maxMinutes);
    clauses.push(`g.duration_minutes <= $${values.length}`);
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
      ORDER BY g.created_at DESC
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
      FROM guides g
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
      INNER JOIN guide_categories gc ON gc.guide_id = g.id
      INNER JOIN categories c ON c.id = gc.category_id
      WHERE g.is_active = true AND lower(c.slug) = lower($1)
      ORDER BY g.created_at DESC
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

const findMostCompleteByCategorySlug = async (categorySlug) => {
  const result = await db.query(
    `
      SELECT
        g.id,
        g.slug,
        COUNT(gs.id)::int AS steps_count
      FROM guides g
      INNER JOIN guide_categories gc ON gc.guide_id = g.id
      INNER JOIN categories c ON c.id = gc.category_id
      LEFT JOIN guide_steps gs ON gs.guide_id = g.id
      WHERE g.is_active = true AND lower(c.slug) = lower($1)
      GROUP BY g.id
      ORDER BY steps_count DESC, g.created_at DESC
      LIMIT 1
    `,
    [categorySlug]
  );
  return result.rows[0] || null;
};

module.exports = {
  findBySlug,
  listActive,
  countActive,
  listByCategorySlug,
  countByCategorySlug,
  listStepsByGuideId,
  listToolsByGuideId,
  findMostCompleteByCategorySlug
};
