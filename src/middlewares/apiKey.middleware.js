const env = require('../config/env');

const apiKeyAuth = (req, res, next) => {
  const apiKey = req.header('x-api-key');
  if (!apiKey || apiKey !== env.metricsApiKey) {
    return res.status(401).json({ error: 'invalid api key' });
  }
  return next();
};

module.exports = apiKeyAuth;
