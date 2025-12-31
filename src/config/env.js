const dotenv = require('dotenv');

dotenv.config();

const getEnv = (key, fallback) => {
  const value = process.env[key];
  if (value === undefined || value === '') {
    return fallback;
  }
  return value;
};

module.exports = {
  nodeEnv: getEnv('NODE_ENV', 'development'),
  port: parseInt(getEnv('PORT', '3000'), 10),
  db: {
    host: getEnv('DB_HOST', 'localhost'),
    port: parseInt(getEnv('DB_PORT', '3306'), 10),
    user: getEnv('DB_USER', 'root'),
    password: getEnv('DB_PASSWORD', ''),
    name: getEnv('DB_NAME', 'quelepaso')
  },
  jwt: {
    secret: getEnv('JWT_SECRET', 'change_me'),
    expiresIn: getEnv('JWT_EXPIRES_IN', '1d')
  }
};
