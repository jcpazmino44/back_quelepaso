const diagnosticService = require('../services/diagnostic.service');

const create = async (req, res, next) => {
  try {
    const {
      category,
      categoryId,
      category_id,
      categorySlug,
      category_slug,
      inputText,
      imageUrl,
      userId
    } = req.body;
    const resolvedCategoryId = categoryId || category_id || null;
    const resolvedCategorySlug = categorySlug || category_slug || category || null;
    const record = await diagnosticService.createDiagnostic({
      categoryId: resolvedCategoryId,
      categorySlug: resolvedCategorySlug,
      inputText,
      imageUrl,
      userId
    });

    res.status(201).json({
      id: record.id,
      possibleCause: record.possible_cause,
      riskLevel: record.risk_level,
      createdAt: record.created_at
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  create
};
