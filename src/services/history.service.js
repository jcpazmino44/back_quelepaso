const historyModel = require('../models/history.model');

const listHistory = async (userId) => {
  if (userId) {
    return historyModel.findByUserId(userId);
  }
  return historyModel.findAll();
};

module.exports = {
  listHistory
};
