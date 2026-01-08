const db = require('../config/db');

const findActiveByCity = async (city) => {
  const result = await db.query(
    'SELECT id, name, role, zone, phone, rating, reviews_count FROM technicians WHERE city = $1 AND active = true ORDER BY rating DESC, reviews_count DESC',
    [city]
  );
  return result.rows;
};

const listActiveCities = async () => {
  const result = await db.query(
    `
      SELECT DISTINCT city
      FROM technicians
      WHERE active = true
        AND city IS NOT NULL
      ORDER BY city ASC
    `
  );
  return result.rows;
};

module.exports = {
  findActiveByCity,
  listActiveCities
};
