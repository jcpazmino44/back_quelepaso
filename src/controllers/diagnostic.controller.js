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
      categoryId: record.category_id,
      categorySlug: record.category_slug,
      categoryInfo: record.category_info
        ? {
          id: record.category_info.id,
          slug: record.category_info.slug,
          name: record.category_info.name,
          icon: record.category_info.icon,
          tintColor: record.category_info.tint_color,
          bgColor: record.category_info.bg_color,
          imageUrl: record.category_info.image_url
        }
        : null,
      possibleCause: record.possible_cause,
      riskLevel: record.risk_level,
      riskLabel: record.risk_label,
      riskDetail: record.risk_detail,
      summaryTitle: record.summary_title,
      summaryTag: record.summary_tag,
      summaryImageUrl: record.summary_image_url,
      note: record.note,
      createdAt: record.created_at
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  create
};
