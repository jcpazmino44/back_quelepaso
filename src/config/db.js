const { Pool } = require('pg');
const env = require('./env');

//conexión para render
/* const pool = new Pool({
  connectionString: env.db.url,
  ssl: env.db.ssl
}); */


//conexión para Railway
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production'
    ? { rejectUnauthorized: false }
    : false,
});


module.exports = pool;
