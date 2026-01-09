const historyModel = require('../models/history.model');

const listHistory = async (userId) => {
  if (userId) {
    return historyModel.findByUserId(userId);
  }
  return historyModel.findAll();
};

const createHistory = async ({
  userId,
  diagnosticId,
  title,
  categoryId,
  deviceId
}) => {
  return historyModel.create({
    user_id: userId,
    diagnostic_id: diagnosticId,
    title,
    category_id: categoryId,
    device_id: deviceId
  });
};

const updateStatusByDiagnosticId = async ({ diagnosticId, status }) => {
  return historyModel.updateStatusByDiagnosticId({ diagnosticId, status });
};

module.exports = {
  listHistory,
  createHistory,
  updateStatusByDiagnosticId
};
