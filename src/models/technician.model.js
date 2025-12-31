const db = require('../config/db');

const findActiveByCity = async (city) => {
  const [rows] = await db.query(
    'SELECT id, name, role, zone, phone, rating, reviews_count FROM technicians WHERE city = ? AND active = 1 ORDER BY rating DESC, reviews_count DESC',
    [city]
  );
  return rows;
};

module.exports = {
  findActiveByCity
};
