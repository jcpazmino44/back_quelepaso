const diagnosticService = require('../services/diagnostic.service');

const create = async (req, res, next) => {
  try {
    const { category, inputText, imageUrl, userId } = req.body;
    const record = await diagnosticService.createDiagnostic({
      category,
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
