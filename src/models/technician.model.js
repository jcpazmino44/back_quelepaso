const db = require('../config/db');

const findActiveByCity = async (city, categorySlug) => {
  const params = [city];
  let query = `
    SELECT t.id, t.name, t.role, t.zone, t.phone, t.rating, t.reviews_count
    FROM technicians t
  `;

  if (categorySlug) {
    query += `
      INNER JOIN technician_categories tc ON tc.technician_id = t.id
      INNER JOIN categories c ON c.id = tc.category_id
      WHERE t.city = $1 AND t.active = true AND c.slug = $2
    `;
    params.push(categorySlug);
  } else {
    query += `
      WHERE t.city = $1 AND t.active = true
    `;
  }

  query += ' ORDER BY t.rating DESC, t.reviews_count DESC';

  const result = await db.query(query, params);
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
