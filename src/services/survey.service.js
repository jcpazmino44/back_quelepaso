const deviceModel = require('../models/device.model');
const surveyModel = require('../models/survey.model');

const createSurveyResponse = async ({
  userId,
  deviceId,
  deviceUuid,
  diagnosticId,
  sessionId,
  appVersion,
  platform,
  screen,
  understoodRating,
  confidenceRating,
  decision,
  repeatRating,
  mostUseful
}) => {
  let resolvedDeviceId = deviceId || null;
  if (!resolvedDeviceId && deviceUuid) {
    const device = await deviceModel.upsertByUuid({
      device_uuid: deviceUuid,
      app_version: appVersion || null,
      platform: platform || null
    });
    resolvedDeviceId = device.id;
  }

  return surveyModel.create({
    user_id: userId || null,
    device_id: resolvedDeviceId,
    diagnostic_id: diagnosticId || null,
    session_id: sessionId || null,
    app_version: appVersion || null,
    platform: platform || null,
    screen: screen || null,
    understood_rating: understoodRating,
    confidence_rating: confidenceRating,
    decision,
    repeat_rating: repeatRating,
    most_useful: mostUseful || null
  });
};

module.exports = {
  createSurveyResponse
};
