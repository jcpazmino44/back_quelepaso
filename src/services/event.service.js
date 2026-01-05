const deviceModel = require('../models/device.model');
const eventModel = require('../models/event.model');

const createEvent = async ({
  deviceId,
  deviceUuid,
  userId,
  diagnosticId,
  eventName,
  screenName,
  eventValue,
  metaJson
}) => {
  let resolvedDeviceId = deviceId || null;
  if (!resolvedDeviceId && deviceUuid) {
    const device = await deviceModel.upsertByUuid({ device_uuid: deviceUuid });
    resolvedDeviceId = device.id;
  }

  return eventModel.create({
    device_id: resolvedDeviceId,
    user_id: userId || null,
    diagnostic_id: diagnosticId || null,
    event_name: eventName,
    screen_name: screenName || null,
    event_value: eventValue || null,
    meta_json: metaJson || null
  });
};

module.exports = {
  createEvent
};
