const deviceService = require('../services/device.service');

const DEVICE_PLATFORMS = new Set(['android', 'ios', 'web']);
const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const upsert = async (req, res, next) => {
  try {
    const { device_uuid, deviceUuid, platform, app_version, appVersion, city, zone } = req.body;
    const resolvedUuid = device_uuid || deviceUuid;

    if (!resolvedUuid || !UUID_REGEX.test(resolvedUuid)) {
      return res.status(400).json({ error: 'device_uuid must be a valid UUID' });
    }

    if (platform && !DEVICE_PLATFORMS.has(platform)) {
      return res.status(400).json({ error: 'platform must be one of android, ios, web' });
    }

    const record = await deviceService.upsertDevice({
      deviceUuid: resolvedUuid,
      platform: platform || null,
      appVersion: app_version || appVersion || null,
      city: city || null,
      zone: zone || null
    });

    res.status(200).json({
      device_id: record.id,
      device_uuid: record.device_uuid,
      last_seen_at: record.last_seen_at
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  upsert
};
