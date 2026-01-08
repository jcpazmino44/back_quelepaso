const historyModel = require('../models/history.model');

const listHistory = async (userId) => {
  if (userId) {
    return historyModel.findByUserId(userId);
  }
  return historyModel.findAll();
};

const updateStatusByDiagnosticId = async ({ diagnosticId, status }) => {
  return historyModel.updateStatusByDiagnosticId({ diagnosticId, status });
};

module.exports = {
  listHistory,
  updateStatusByDiagnosticId
};
