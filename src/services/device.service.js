const deviceModel = require('../models/device.model');

const upsertDevice = async ({ deviceUuid, platform, appVersion, city, zone }) => {
  return deviceModel.upsertByUuid({
    device_uuid: deviceUuid,
    platform,
    app_version: appVersion,
    city,
    zone
  });
};

module.exports = {
  upsertDevice
};
