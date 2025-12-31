const jwt = require('jsonwebtoken');
const env = require('../config/env');

const authMiddleware = (req, res, next) => {
  const header = req.headers.authorization;
  if (!header) {
    return res.status(401).json({ message: 'missing authorization header' });
  }

  const [type, token] = header.split(' ');
  if (type !== 'Bearer' || !token) {
    return res.status(401).json({ message: 'invalid authorization header' });
  }

  try {
    const payload = jwt.verify(token, env.jwt.secret);
    req.user = { id: payload.sub };
    return next();
  } catch (error) {
    return res.status(401).json({ message: 'invalid token' });
  }
};

module.exports = authMiddleware;
