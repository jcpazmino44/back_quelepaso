const guideModel = require('../models/guide.model');
const categoryService = require('./category.service');

const getGuideDetail = async ({ slug, includeSteps = true, includeTools = true }) => {
  if (!slug) {
    const error = new Error('slug is required');
    error.status = 400;
    throw error;
  }

  const guide = await guideModel.findBySlug({ slug, isActive: true });
  if (!guide) {
    const error = new Error('guide not found');
    error.status = 404;
    throw error;
  }

  const steps = includeSteps ? await guideModel.listStepsByGuideId(guide.id) : [];
  const tools = includeTools ? await guideModel.listToolsByGuideId(guide.id) : [];

  return { guide, steps, tools };
};

const listGuides = async ({
  q,
  difficulty,
  minMinutes,
  maxMinutes,
  limit,
  offset
} = {}) => {
  const [items, total] = await Promise.all([
    guideModel.listActive({
      q,
      difficulty,
      minMinutes,
      maxMinutes,
      limit,
      offset
    }),
    guideModel.countActive({
      q,
      difficulty,
      minMinutes,
      maxMinutes
    })
  ]);

  return { items, total };
};

const listGuidesByCategorySlug = async ({ categorySlug, limit, offset } = {}) => {
  if (!categorySlug) {
    const error = new Error('categorySlug is required');
    error.status = 400;
    throw error;
  }

  const category = await categoryService.getCategoryBySlug(categorySlug);
  if (!category) {
    const error = new Error('category not found');
    error.status = 404;
    throw error;
  }
  if (category.is_active === false) {
    const error = new Error('category is inactive');
    error.status = 400;
    throw error;
  }

  const [items, total] = await Promise.all([
    guideModel.listByCategorySlug({ categorySlug, limit, offset }),
    guideModel.countByCategorySlug({ categorySlug })
  ]);

  return { category, items, total };
};

module.exports = {
  getGuideDetail,
  listGuides,
  listGuidesByCategorySlug
};
