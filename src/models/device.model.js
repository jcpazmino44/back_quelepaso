const db = require('../config/db');

const upsertByUuid = async ({ device_uuid, platform, app_version, city, zone }) => {
  const result = await db.query(
    `INSERT INTO devices (device_uuid, platform, app_version, city, zone, last_seen_at)
     VALUES ($1, COALESCE($2::device_platform_enum, 'android'::device_platform_enum), $3, $4, $5, NOW())
     ON CONFLICT (device_uuid)
     DO UPDATE SET
       platform = COALESCE(EXCLUDED.platform, devices.platform),
       app_version = COALESCE(EXCLUDED.app_version, devices.app_version),
       city = COALESCE(EXCLUDED.city, devices.city),
       zone = COALESCE(EXCLUDED.zone, devices.zone),
       last_seen_at = NOW()
     RETURNING id, device_uuid, last_seen_at;`,
    [device_uuid, platform || null, app_version || null, city || null, zone || null]
  );

  return result.rows[0];
};

module.exports = {
  upsertByUuid
};
