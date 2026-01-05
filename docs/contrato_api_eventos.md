# Contrato API - Identidad y eventos (Iteracion 1)

Contrato minimo de backend para completar la instrumentacion en la app.

## 1) Registro / actualizacion de device

**POST** `/api/devices`

Request:
```json
{
  "device_uuid": "uuid-v4",
  "platform": "android",
  "app_version": "1.0.3",
  "city": "Bogota",
  "zone": "Chapinero"
}
```

Response:
```json
{
  "device_id": 123,
  "device_uuid": "uuid-v4",
  "last_seen_at": "2026-01-05T12:34:56Z"
}
```

Notas:
- Backend hace upsert por `device_uuid`.
- Actualiza `last_seen_at` en cada llamada.

## 2) Envio de eventos

**POST** `/api/events`

Request:
```json
{
  "device_id": 123,
  "user_id": 1,
  "diagnostic_id": 456,
  "event_name": "diagnostic_completed",
  "screen_name": "Diagnostico",
  "event_value": "alto",
  "meta_json": {
    "category": "plomeria",
    "risk_level": "alto",
    "session_id": "sess-abc"
  }
}
```

Response:
```json
{
  "event_id": 789
}
```

Notas:
- `event_name` debe ser uno de los enums definidos en BD.
- `meta_json` es JSON libre para atributos del evento.
- `user_id` y `diagnostic_id` son opcionales.

## 3) Alternativa sin device_id en cliente (opcional)

Permitir enviar `device_uuid` y resolverlo en backend.

Request:
```json
{
  "device_uuid": "uuid-v4",
  "event_name": "history_viewed",
  "screen_name": "Historial",
  "meta_json": {
    "session_id": "sess-abc"
  }
}
```

## 4) Eventos minimos

- diagnostic_started
- image_uploaded
- diagnostic_completed
- guide_opened
- guide_step_viewed
- guide_completed
- technicians_list_viewed
- technician_contact_clicked
- history_viewed
- session_started
- session_ended
