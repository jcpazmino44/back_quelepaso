const { Pool } = require('pg');
const env = require('./env');

const pool = new Pool({
  connectionString: env.db.url,
  ssl: env.db.ssl
});

module.exports = pool;
