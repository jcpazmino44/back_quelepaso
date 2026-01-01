const metricsService = require('../services/metrics.service');

const create = async (req, res, next) => {
  try {
    const { userId, sessionId, platform, event, data, device, appVersion, createdAt } = req.body;

    await metricsService.createMetric({
      userId,
      sessionId,
      platform,
      event,
      data,
      device,
      appVersion,
      createdAt
    });

    res.status(201).json({ ok: true });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  create
};
