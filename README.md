# Backend QueLePaso

Backend Node.js + Postgres para la app QueLePaso. Estructura basada en la arquitectura solicitada (controllers, services, models, routes, middlewares, config).

## Requisitos
- Node.js 18+
- Postgres 13+

## Setup rapido
1. Copia variables de entorno:
   - `copy .env.example .env`
2. Instala dependencias:
   - `npm install`
3. Levanta el servidor:
   - `npm run dev`

## Notas de base de datos
- El esquema base esta en `docs/bd_quelepaso.sql`.
- Para autenticacion, se requiere una columna `password_hash` en `users`.
- Para filtrar tecnicos por categoria se requiere la tabla puente `technician_categories` (relacion muchos a muchos con `technicians` y `categories`).

Ejemplo:
```
ALTER TABLE users
  ADD COLUMN password_hash VARCHAR(255) NOT NULL;
```

## Endpoints iniciales
- `POST /api/auth/register` { full_name?, phone, password }
- `POST /api/auth/login` { phone, password }
- `GET /api/health`
- `GET /api/technicians?city=&categorySlug=` -> `[{ id, name, role, zone, phone, rating, reviewsCount }]`
- `GET /api/technicians/cities` -> `["Bogota", "Medellin", ...]`
- `POST /api/diagnostics` { category, inputText?, imageUrl?, userId? } -> `{ id, possibleCause, riskLevel, createdAt }`
- `GET /api/history?userId=` -> `[{ id, title, category, status, createdAt }]`

## utilizar endpoints en el  front

Puedes decirle al front que use estos endpoints (base URL configurable, ej. `http://10.0.2.2:3000`):

- `GET /api/technicians?city=Bogota`
  - Respuesta: `[{ id, name, role, zone, phone, rating, reviewsCount }]`
- `GET /api/technicians?city=Bogota&categorySlug=plomeria`
  - Respuesta: `[{ id, name, role, zone, phone, rating, reviewsCount }]`
- `GET /api/technicians/cities`
  - Respuesta: `["Bogota", "Medellin", ...]`
- `POST /api/diagnostics`
  - Body JSON: `{ category, inputText?, imageUrl?, userId? }`
  - Respuesta: `{ id, possibleCause, riskLevel, createdAt }`
- `GET /api/history?userId=1` (o sin `userId` para general)
  - Respuesta: `[{ id, title, category, status, createdAt }]`

Notas rapidas para front:
- Content-Type: `application/json` en POST.
- Si usan `userId`, es opcional; si no lo mandan, el backend devuelve historial general y en diagnostics guarda `user_id` como `NULL`.
- `imageUrl` se guarda como string en `diagnostics.image_url` (sin procesamiento en backend). Ver `docs/uso_imagen.md`.

la URL correcta del backend es:
http://10.0.2.2:3000

## Migracion a Postgres para utilizar Render
Tareas realizadas:
- Cambiar el driver MySQL → PostgreSQL (`mysql2` por `pg`).
- Ajustar la conexion para usar `DATABASE_URL` y SSL (requerido por Render).
- Actualizar consultas para usar placeholders `$1` y `active = true`.
- Ajustar inserts para usar `RETURNING id` en lugar de `insertId`.
- Actualizar variables de entorno locales para Postgres.
