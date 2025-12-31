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
    url: getEnv('DATABASE_URL', ''),
    ssl: getEnv('DB_SSL', 'true') === 'true' ? { rejectUnauthorized: false } : false
  },
  jwt: {
    secret: getEnv('JWT_SECRET', 'change_me'),
    expiresIn: getEnv('JWT_EXPIRES_IN', '1d')
  }
};
