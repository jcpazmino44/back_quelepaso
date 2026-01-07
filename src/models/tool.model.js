const db = require('../config/db');

const listAll = async () => {
  const result = await db.query(
    `
      SELECT
        id,
        slug,
        name,
        icon,
        created_at,
        updated_at
      FROM tools
      ORDER BY name ASC
    `
  );
  return result.rows;
};

module.exports = {
  listAll
};
