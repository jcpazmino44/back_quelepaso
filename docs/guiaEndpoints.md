# Endpoints para pantalla Guia de Soluciones

Este documento define los endpoints necesarios para que el front dibuje la pantalla de guia de soluciones.

## 1) GET /api/guides/{slug}
**Descripcion**: Retorna el detalle completo de una guia para renderizar la pantalla (cabecera, seguridad, herramientas y pasos).

**Entrada**:
- Path param: `slug` (string, requerido) Ej: `arreglando-la-gotera`
- Query params opcionales:
  - `include_steps` (bool, default true)
  - `include_tools` (bool, default true)

**Salida** (JSON):
```json
{
  "id": "uuid",
  "slug": "arreglando-la-gotera",
  "title": "Arreglando la gotera",
  "summary": "Guia rapida...",
  "duration_minutes": 20,
  "difficulty_level": "basico",
  "safety": {
    "title": "Ojo! Seguridad ante todo",
    "text": "Antes de empezar..."
  },
  "success": {
    "title": "Listo el pollo!",
    "text": "Vuelva a armar..."
  },
  "cover_image_url": null,
  "tools": [
    {
      "id": "uuid",
      "slug": "destornillador-estrella",
      "name": "Destornillador de estrella",
      "icon": "build",
      "is_required": true,
      "order_index": 1
    }
  ],
  "steps": [
    {
      "id": "uuid",
      "step_number": 1,
      "title": "Quite la tapa del grifo",
      "body": "Con el destornillador...",
      "image_url": "assets/images/step1.jpg",
      "estimated_minutes": 5
    }
  ]
}
```

Notas:
- Si `include_steps=false`, omitir `steps`.
- Si `include_tools=false`, omitir `tools`.
- Debe respetar el orden: `tools.order_index` y `steps.step_number`.

## 2) GET /api/guides/by-category/{slug}
**Descripcion**: Lista guias activas de una categoria para el listado y entry point.

**Entrada**:
- Path param: `slug` de categoria (string, requerido) Ej: `plomeria`
- Query params opcionales:
  - `limit` (int, default 20)
  - `offset` (int, default 0)

**Salida** (JSON):
```json
{
  "category": {
    "id": "uuid",
    "slug": "plomeria",
    "name": "Plomeria"
  },
  "items": [
    {
      "id": "uuid",
      "slug": "arreglando-la-gotera",
      "title": "Arreglando la gotera",
      "summary": "Guia rapida...",
      "duration_minutes": 20,
      "difficulty_level": "basico",
      "cover_image_url": null
    }
  ],
  "limit": 20,
  "offset": 0,
  "total": 1
}
```

## 3) GET /api/guides
**Descripcion**: Lista general de guias activas (busqueda y exploracion sin categoria).

**Entrada** (query params opcionales):
- `q` (string) busqueda por titulo/resumen
- `difficulty` (string: basico|intermedio|avanzado)
- `min_minutes` (int)
- `max_minutes` (int)
- `limit` (int, default 20)
- `offset` (int, default 0)

**Salida** (JSON):
```json
{
  "items": [
    {
      "id": "uuid",
      "slug": "arreglando-la-gotera",
      "title": "Arreglando la gotera",
      "summary": "Guia rapida...",
      "duration_minutes": 20,
      "difficulty_level": "basico",
      "cover_image_url": null
    }
  ],
  "limit": 20,
  "offset": 0,
  "total": 1
}
```

## 4) GET /api/tools
**Descripcion**: Catalogo completo de herramientas (opcional, por si el front desea precargar).

**Entrada**: sin parametros

**Salida** (JSON):
```json
{
  "items": [
    {
      "id": "uuid",
      "slug": "destornillador-estrella",
      "name": "Destornillador de estrella",
      "icon": "build"
    }
  ]
}
```

## 5) GET /api/categories/with-guides
**Descripcion**: Categorias con conteo de guias activas para menu/landing.

**Entrada**: sin parametros

**Salida** (JSON):
```json
{
  "items": [
    {
      "id": "uuid",
      "slug": "plomeria",
      "name": "Plomeria",
      "guides_count": 1
    }
  ]
}
```

## 6) POST /api/guides/{slug}/events
**Descripcion**: Telemetria simple para medir uso (opcional si ya existe events/metrics).

**Entrada** (JSON):
```json
{
  "event": "guide_opened",
  "device_id": "uuid",
  "meta": {
    "source": "category_list"
  }
}
```

**Salida** (JSON):
```json
{
  "ok": true
}
```

Notas:
- Si ya existe un endpoint de eventos, reutilizarlo con `event` = `guide_opened`, `guide_step_viewed`, `guide_completed`.

```
