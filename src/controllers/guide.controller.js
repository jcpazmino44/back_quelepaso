const guideService = require('../services/guide.service');

const BOOLEAN_TRUE = new Set(['true', '1', true]);
const BOOLEAN_FALSE = new Set(['false', '0', false]);
const MAX_LIMIT = 100;

const parseBoolean = (value, defaultValue) => {
  if (value === undefined) {
    return defaultValue;
  }
  if (BOOLEAN_TRUE.has(value)) {
    return true;
  }
  if (BOOLEAN_FALSE.has(value)) {
    return false;
  }
  return defaultValue;
};

const parseInteger = (value, defaultValue) => {
  if (value === undefined || value === null || value === '') {
    return defaultValue;
  }
  const parsed = Number(value);
  if (!Number.isInteger(parsed)) {
    return defaultValue;
  }
  return parsed;
};

const parseLimit = (value) => {
  const parsed = parseInteger(value, 20);
  if (parsed < 1) return 1;
  if (parsed > MAX_LIMIT) return MAX_LIMIT;
  return parsed;
};

const parseOffset = (value) => {
  const parsed = parseInteger(value, 0);
  return parsed < 0 ? 0 : parsed;
};

const getBySlug = async (req, res, next) => {
  try {
    const { slug } = req.params;
    const includeSteps = parseBoolean(req.query.include_steps, true);
    const includeTools = parseBoolean(req.query.include_tools, true);

    const { guide, steps, tools } = await guideService.getGuideDetail({
      slug,
      includeSteps,
      includeTools
    });

    const response = {
      id: guide.id,
      slug: guide.slug,
      title: guide.title,
      summary: guide.summary,
      durationMinutes: guide.duration_minutes,
      difficultyLevel: guide.difficulty_level,
      safety: {
        title: guide.safety_title,
        text: guide.safety_text
      },
      success: {
        title: guide.success_title,
        text: guide.success_text
      },
      coverImageUrl: guide.cover_image_url
    };

    if (includeTools) {
      response.tools = tools.map((tool) => ({
        id: tool.id,
        slug: tool.slug,
        name: tool.name,
        icon: tool.icon,
        isRequired: tool.is_required,
        orderIndex: tool.order_index
      }));
    }

    if (includeSteps) {
      response.steps = steps.map((step) => ({
        id: step.id,
        stepNumber: step.step_number,
        title: step.title,
        body: step.body,
        imageUrl: step.image_url,
        estimatedMinutes: step.estimated_minutes
      }));
    }

    res.json(response);
  } catch (error) {
    next(error);
  }
};

const list = async (req, res, next) => {
  try {
    const { q, difficulty, min_minutes, max_minutes } = req.query;
    if (difficulty && !['basico', 'intermedio', 'avanzado'].includes(difficulty)) {
      return res.status(400).json({ message: 'difficulty must be basico, intermedio, or avanzado' });
    }

    const limit = parseLimit(req.query.limit);
    const offset = parseOffset(req.query.offset);
    const minMinutes = parseInteger(min_minutes, undefined);
    const maxMinutes = parseInteger(max_minutes, undefined);

    const { items, total } = await guideService.listGuides({
      q,
      difficulty,
      minMinutes,
      maxMinutes,
      limit,
      offset
    });

    res.json({
      items: items.map((guide) => ({
        id: guide.id,
        slug: guide.slug,
        title: guide.title,
        summary: guide.summary,
        durationMinutes: guide.duration_minutes,
        difficultyLevel: guide.difficulty_level,
        coverImageUrl: guide.cover_image_url
      })),
      limit,
      offset,
      total
    });
  } catch (error) {
    next(error);
  }
};

const listByCategory = async (req, res, next) => {
  try {
    const { slug } = req.params;
    const limit = parseLimit(req.query.limit);
    const offset = parseOffset(req.query.offset);

    const { category, items, total } = await guideService.listGuidesByCategorySlug({
      categorySlug: slug,
      limit,
      offset
    });

    res.json({
      category: {
        id: category.id,
        slug: category.slug,
        name: category.name
      },
      items: items.map((guide) => ({
        id: guide.id,
        slug: guide.slug,
        title: guide.title,
        summary: guide.summary,
        durationMinutes: guide.duration_minutes,
        difficultyLevel: guide.difficulty_level,
        coverImageUrl: guide.cover_image_url
      })),
      limit,
      offset,
      total
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getBySlug,
  list,
  listByCategory
};
