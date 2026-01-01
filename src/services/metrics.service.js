const metricsModel = require('../models/metrics.model');

const createMetric = async ({
  userId,
  sessionId,
  platform,
  event,
  data,
  device,
  appVersion,
  createdAt
}) => {
  await metricsModel.create({
    user_id: userId || null,
    session_id: sessionId || null,
    platform,
    event,
    data,
    device,
    app_version: appVersion,
    created_at: createdAt || null
  });
};

module.exports = {
  createMetric
};
