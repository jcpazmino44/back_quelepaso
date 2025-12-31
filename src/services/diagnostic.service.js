const diagnosticModel = require('../models/diagnostic.model');

const normalizeCategory = (value) => {
  const key = String(value || '').toLowerCase().trim();
  if (key === 'electro') return 'electrodomesticos';
  return key;
};

const createDiagnostic = async ({ userId, category, inputText, imageUrl }) => {
  const normalizedCategory = normalizeCategory(category);
  if (!normalizedCategory) {
    const error = new Error('category is required');
    error.status = 400;
    throw error;
  }

  const possibleCause = `Diagnostico preliminar para categoria: ${normalizedCategory}`;
  const riskLevel = 'bajo';

  const id = await diagnosticModel.create({
    user_id: userId || null,
    category: normalizedCategory,
    input_text: inputText || null,
    image_url: imageUrl || null,
    possible_cause: possibleCause,
    risk_level: riskLevel
  });

  const record = await diagnosticModel.findById(id);
  if (!record) {
    const error = new Error('diagnostic not found after create');
    error.status = 500;
    throw error;
  }

  return record;
};

module.exports = {
  createDiagnostic
};
