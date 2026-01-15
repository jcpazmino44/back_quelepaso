const surveyService = require('../services/survey.service');

const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const MAX_SCREEN_LENGTH = 60;
const MAX_APP_VERSION_LENGTH = 30;
const MAX_PLATFORM_LENGTH = 20;
const MAX_MOST_USEFUL_LENGTH = 250;

const DECISION_MAP = new Map([
  ['tried_fix', 'tried_fix'],
  ['contacted_tech', 'contacted_tech'],
  ['no_action', 'no_action'],
  ['intentado', 'tried_fix'],
  ['contacto_tecnico', 'contacted_tech'],
  ['nada', 'no_action']
]);

const parseInteger = (value) => {
  if (value === undefined || value === null || value === '') {
    return null;
  }
  const parsed = Number(value);
  if (!Number.isInteger(parsed)) {
    return null;
  }
  return parsed;
};

const parseRating = (value) => {
  const parsed = parseInteger(value);
  if (parsed === null) {
    return null;
  }
  if (parsed < 1 || parsed > 5) {
    return null;
  }
  return parsed;
};

const normalizeDecision = (value) => {
  if (!value) {
    return null;
  }
  const normalized = String(value).trim().toLowerCase();
  return DECISION_MAP.get(normalized) || null;
};

const create = async (req, res, next) => {
  try {
    const {
      user_id,
      userId,
      device_id,
      deviceId,
      device_uuid,
      deviceUuid,
      diagnostic_id,
      diagnosticId,
      session_id,
      sessionId,
      app_version,
      appVersion,
      platform,
      screen,
      understood_rating,
      understoodRating,
      confidence_rating,
      confidenceRating,
      decision,
      repeat_rating,
      repeatRating,
      most_useful,
      mostUseful
    } = req.body;

    const resolvedDeviceUuid = device_uuid || deviceUuid || null;
    if (resolvedDeviceUuid && !UUID_REGEX.test(resolvedDeviceUuid)) {
      return res.status(400).json({ error: 'device_uuid must be a valid UUID' });
    }

    const rawDeviceId = device_id || deviceId;
    const resolvedDeviceId = parseInteger(rawDeviceId);
    if (rawDeviceId !== undefined && rawDeviceId !== null && rawDeviceId !== '' && resolvedDeviceId === null) {
      return res.status(400).json({ error: 'device_id must be an integer' });
    }

    const resolvedSessionId = session_id || sessionId || null;
    if (resolvedSessionId && !UUID_REGEX.test(resolvedSessionId)) {
      return res.status(400).json({ error: 'session_id must be a valid UUID' });
    }

    if (!resolvedDeviceId && !resolvedDeviceUuid && !resolvedSessionId) {
      return res.status(400).json({ error: 'device_id, device_uuid, or session_id is required' });
    }

    const rawUserId = user_id || userId;
    const resolvedUserId = parseInteger(rawUserId);
    if (rawUserId !== undefined && rawUserId !== null && rawUserId !== '' && resolvedUserId === null) {
      return res.status(400).json({ error: 'user_id must be an integer' });
    }

    const rawDiagnosticId = diagnostic_id || diagnosticId;
    const resolvedDiagnosticId = parseInteger(rawDiagnosticId);
    if (rawDiagnosticId !== undefined && rawDiagnosticId !== null && rawDiagnosticId !== '' && resolvedDiagnosticId === null) {
      return res.status(400).json({ error: 'diagnostic_id must be an integer' });
    }

    const resolvedScreen = screen || null;
    if (resolvedScreen && resolvedScreen.length > MAX_SCREEN_LENGTH) {
      return res.status(400).json({ error: 'screen exceeds max length' });
    }

    const resolvedAppVersion = app_version || appVersion || null;
    if (resolvedAppVersion && resolvedAppVersion.length > MAX_APP_VERSION_LENGTH) {
      return res.status(400).json({ error: 'app_version exceeds max length' });
    }

    const resolvedPlatform = platform || null;
    if (resolvedPlatform && resolvedPlatform.length > MAX_PLATFORM_LENGTH) {
      return res.status(400).json({ error: 'platform exceeds max length' });
    }

    const resolvedUnderstood = parseRating(understood_rating || understoodRating);
    if (resolvedUnderstood === null) {
      return res.status(400).json({ error: 'understood_rating must be an integer between 1 and 5' });
    }

    const resolvedConfidence = parseRating(confidence_rating || confidenceRating);
    if (resolvedConfidence === null) {
      return res.status(400).json({ error: 'confidence_rating must be an integer between 1 and 5' });
    }

    const resolvedRepeat = parseRating(repeat_rating || repeatRating);
    if (resolvedRepeat === null) {
      return res.status(400).json({ error: 'repeat_rating must be an integer between 1 and 5' });
    }

    const resolvedDecision = normalizeDecision(decision);
    if (!resolvedDecision) {
      return res.status(400).json({ error: 'decision must be a valid enum value' });
    }

    const resolvedMostUseful = most_useful || mostUseful || null;
    if (resolvedMostUseful && resolvedMostUseful.length > MAX_MOST_USEFUL_LENGTH) {
      return res.status(400).json({ error: 'most_useful exceeds max length' });
    }

    const record = await surveyService.createSurveyResponse({
      userId: resolvedUserId,
      deviceId: resolvedDeviceId,
      deviceUuid: resolvedDeviceUuid,
      diagnosticId: resolvedDiagnosticId,
      sessionId: resolvedSessionId,
      appVersion: resolvedAppVersion,
      platform: resolvedPlatform,
      screen: resolvedScreen,
      understoodRating: resolvedUnderstood,
      confidenceRating: resolvedConfidence,
      decision: resolvedDecision,
      repeatRating: resolvedRepeat,
      mostUseful: resolvedMostUseful
    });

    res.status(201).json({
      id: record.id,
      createdAt: record.created_at
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  create
};
