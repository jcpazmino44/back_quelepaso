const metricsService = require('../services/metrics.service');

const isUuid = (value) => /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(value);

const create = async (req, res, next) => {
  try {
    const { userId, sessionId, platform, event, data, device, appVersion, createdAt } = req.body;
    if (!event) {
      return res.status(400).json({ error: 'event is required' });
    }
    if (sessionId && !isUuid(sessionId)) {
      return res.status(400).json({ error: 'sessionId must be a valid UUID' });
    }

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
