const crypto = require('crypto');
const eventService = require('../services/event.service');

const EVENT_NAMES = new Set([
  'diagnostic_started',
  'image_uploaded',
  'diagnostic_completed',
  'guide_opened',
  'guide_step_viewed',
  'guide_completed',
  'technicians_list_viewed',
  'technician_contact_clicked',
  'history_viewed',
  'session_started',
  'session_ended'
]);

const MAX_META_JSON_BYTES = 10000;
const MAX_SCREEN_NAME_LENGTH = 60;
const MAX_EVENT_VALUE_LENGTH = 120;
const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const isPlainObject = (value) => Object.prototype.toString.call(value) === '[object Object]';

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

const resolveSessionId = (reqBody, metaJson) => {
  const sessionId = reqBody.session_id || reqBody.sessionId || (metaJson && metaJson.session_id);
  if (sessionId && !UUID_REGEX.test(sessionId)) {
    return { error: 'session_id must be a valid UUID' };
  }
  if (sessionId) {
    return { sessionId };
  }
  if (!metaJson || isPlainObject(metaJson)) {
    return { sessionId: crypto.randomUUID(), shouldAttach: true };
  }
  return { sessionId: null };
};

const create = async (req, res, next) => {
  try {
    const {
      device_id,
      deviceId,
      device_uuid,
      deviceUuid,
      user_id,
      userId,
      diagnostic_id,
      diagnosticId,
      event_name,
      eventName,
      screen_name,
      screenName,
      event_value,
      eventValue,
      meta_json,
      metaJson
    } = req.body;

    const resolvedEventName = event_name || eventName;
    const resolvedDeviceUuid = device_uuid || deviceUuid;
    const rawDeviceId = device_id || deviceId;
    const resolvedDeviceId = parseInteger(rawDeviceId);
    if (rawDeviceId !== undefined && rawDeviceId !== null && rawDeviceId !== '' && resolvedDeviceId === null) {
      return res.status(400).json({ error: 'device_id must be an integer' });
    }

    if (!resolvedEventName || !EVENT_NAMES.has(resolvedEventName)) {
      return res.status(400).json({ error: 'event_name must be a valid enum value' });
    }

    if (!resolvedDeviceId && !resolvedDeviceUuid) {
      return res.status(400).json({ error: 'device_id or device_uuid is required' });
    }

    if (resolvedDeviceUuid && !UUID_REGEX.test(resolvedDeviceUuid)) {
      return res.status(400).json({ error: 'device_uuid must be a valid UUID' });
    }

    const resolvedScreenName = screen_name || screenName || null;
    if (resolvedScreenName && resolvedScreenName.length > MAX_SCREEN_NAME_LENGTH) {
      return res.status(400).json({ error: 'screen_name exceeds max length' });
    }

    const resolvedEventValue = event_value || eventValue || null;
    if (resolvedEventValue && resolvedEventValue.length > MAX_EVENT_VALUE_LENGTH) {
      return res.status(400).json({ error: 'event_value exceeds max length' });
    }

    const resolvedMetaJson = meta_json !== undefined ? meta_json : metaJson;
    const sessionResolution = resolveSessionId(req.body, resolvedMetaJson);
    if (sessionResolution.error) {
      return res.status(400).json({ error: sessionResolution.error });
    }

    let payloadMetaJson = resolvedMetaJson === undefined ? null : resolvedMetaJson;
    if (sessionResolution.sessionId && sessionResolution.shouldAttach) {
      if (!payloadMetaJson) {
        payloadMetaJson = { session_id: sessionResolution.sessionId };
      } else if (isPlainObject(payloadMetaJson)) {
        payloadMetaJson = { ...payloadMetaJson, session_id: sessionResolution.sessionId };
      }
    }

    if (payloadMetaJson !== null) {
      const metaSize = Buffer.byteLength(JSON.stringify(payloadMetaJson), 'utf8');
      if (metaSize > MAX_META_JSON_BYTES) {
        return res.status(400).json({ error: 'meta_json exceeds size limit' });
      }
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

    const record = await eventService.createEvent({
      deviceId: resolvedDeviceId,
      deviceUuid: resolvedDeviceUuid,
      userId: resolvedUserId,
      diagnosticId: resolvedDiagnosticId,
      eventName: resolvedEventName,
      screenName: resolvedScreenName,
      eventValue: resolvedEventValue,
      metaJson: payloadMetaJson
    });

    const response = { event_id: record.id };
    if (sessionResolution.sessionId) {
      response.session_id = sessionResolution.sessionId;
    }

    res.status(201).json(response);
  } catch (error) {
    next(error);
  }
};

module.exports = {
  create
};
