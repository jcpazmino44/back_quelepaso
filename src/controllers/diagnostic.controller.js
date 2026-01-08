const diagnosticService = require('../services/diagnostic.service');
const historyService = require('../services/history.service');

const STATUS_VALUES = new Set([
  'solucionado',
  'pendiente',
  'revisado',
  'cancelado'
]);

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
      userId,
      guideId,
      guide_id,
      guideSlug,
      guide_slug
    } = req.body;
    const resolvedCategoryId = categoryId || category_id || null;
    const resolvedCategorySlug = categorySlug || category_slug || category || null;
    const resolvedGuideId = guideId || guide_id || null;
    const resolvedGuideSlug = guideSlug || guide_slug || null;
    const record = await diagnosticService.createDiagnostic({
      categoryId: resolvedCategoryId,
      categorySlug: resolvedCategorySlug,
      inputText,
      imageUrl,
      userId,
      guideId: resolvedGuideId,
      guideSlug: resolvedGuideSlug
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
      guideSlug: record.guide_slug || null,
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

const updateStatus = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    const diagnosticId = Number(id);

    if (!Number.isInteger(diagnosticId)) {
      return res.status(400).json({ error: 'diagnostic_id must be an integer' });
    }

    if (!status || !STATUS_VALUES.has(status)) {
      return res.status(400).json({ error: 'status must be a valid enum value' });
    }

    const updated = await historyService.updateStatusByDiagnosticId({
      diagnosticId,
      status
    });

    if (!updated) {
      return res.status(404).json({ error: 'diagnostic not found in history' });
    }

    res.json({
      diagnosticId: updated.diagnostic_id,
      status: updated.status
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  create,
  updateStatus
};
