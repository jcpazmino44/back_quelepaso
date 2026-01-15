# Backend QueLePaso

Backend Node.js + Postgres para la app QueLePaso. Arquitectura por capas (controllers, services, models, routes, middlewares, config).

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

## Endpoints principales
- `POST /api/auth/register` { full_name?, phone, password }
- `POST /api/auth/login` { phone, password }
- `GET /api/health`
- `GET /api/categories` -> `[{ id, slug, name, ... }]`
- `GET /api/categories/with-guides` -> `[{ id, slug, guidesCount, ... }]`
- `GET /api/technicians?city=&categorySlug=` -> `[{ id, name, role, zone, phone, rating, reviewsCount }]`
- `GET /api/technicians/cities` -> `["Bogota", "Medellin", ...]`
- `GET /api/guides` -> `[{ id, slug, title, summary, durationMinutes, difficultyLevel, coverImageUrl }]`
- `GET /api/guides/by-category/:slug` -> `{ category, items, limit, offset, total }`
- `GET /api/guides/:slug` -> `{ id, slug, title, summary, steps?, tools? }`
- `POST /api/diagnostics` -> `{ id, categorySlug, categoryInfo, possibleCause, riskLevel, riskLabel, riskDetail, summaryTitle, summaryImageUrl, createdAt }`
- `PATCH /api/diagnostics/:id/status` { status } -> `{ diagnosticId, status }`
- `GET /api/history?userId=` -> `[{ id, diagnosticId, title, category, status, createdAt }]`

## Uso desde el front

Base URL configurable, ej. `http://10.0.2.2:3000`.

Diagnostico:
- `POST /api/diagnostics`
  - Body JSON o `multipart/form-data` (solo campos, sin archivo).
  - Campos aceptados:
    - `categoryId` o `categorySlug` (tambien acepta `category` como alias de slug).
    - `guideId` o `guideSlug` (opcional).
    - `inputText`, `imageUrl`, `userId` (opcionales).

Guia sugerida por categoria:
- `GET /api/guides/by-category/electricidad-basica`

Detalle de guia:
- `GET /api/guides/breaker-se-baja?include_steps=true&include_tools=true`

Notas rapidas:
- `imageUrl` se guarda como string en `diagnostics.image_url` (sin procesamiento en backend). Ver `docs/uso_imagen.md`.
- `userId` es opcional; si no se manda, el backend guarda `user_id` como `NULL`.

## Migracion a Postgres para usar Render
Tareas realizadas:
- Cambiar el driver MySQL -> PostgreSQL (`mysql2` por `pg`).
- Ajustar la conexion para usar `DATABASE_URL` y SSL.
- Actualizar consultas para usar placeholders `$1`.
- Ajustar inserts para usar `RETURNING id` en lugar de `insertId`.
- Actualizar variables de entorno locales para Postgres.
