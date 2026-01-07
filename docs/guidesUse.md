# guidesUse.md
## Sistema de Guías – Uso, Recomendación y Creación  
### App QueLePaso

Este documento define de forma integral cómo funciona el **sistema de guías** en QueLePaso, desde el contrato técnico del endpoint hasta la lógica de recomendación y el proceso interno de creación de guías.

El objetivo es que las guías sean:
- Útiles para el usuario
- Consistentes a nivel de datos
- Escalables a nuevas categorías
- Medibles para aprendizaje validado

---

## 1. Endpoint de consulta de guías

### Objetivo
Permitir al frontend obtener **toda la información necesaria** para renderizar una guía completa (como “Arreglando la gotera”) en una sola llamada.

---

### Endpoint
GET /guides/:slug
GET /guides/arreglando-la-gotera

---

### Parámetros
- `slug` (string): identificador único de la guía

---

### Respuesta esperada

```json
{
  "id": "uuid",
  "slug": "arreglando-la-gotera",
  "title": "Arreglando la gotera",
  "summary": "Soluciona una gotera básica en el grifo de tu cocina.",
  "duration_minutes": 20,
  "difficulty": "basico",
  "category": {
    "id": "uuid",
    "slug": "plomeria",
    "name": "Plomería",
    "icon": "plumbing",
    "tint_color": "#1976D2",
    "bg_color": "#E3F2FD"
  },
  "safety": {
    "title": "¡Ojo! Seguridad ante todo",
    "message": "Antes de empezar, cierre la llave de paso del agua..."
  },
  "tools": [
    { "id": "uuid", "name": "Destornillador de estrella", "required": true },
    { "id": "uuid", "name": "Cinta de teflón", "required": true }
  ],
  "steps": [
    {
      "step_number": 1,
      "title": "Quite la tapa del grifo",
      "description": "Con el destornillador retire el tornillo superior...",
      "image_url": "https://cdn.quelepaso.app/steps/grifo_1.jpg"
    },
    {
      "step_number": 2,
      "title": "Desenrosque el vástago",
      "description": "Use la llave inglesa y gire hacia la izquierda...",
      "image_url": "https://cdn.quelepaso.app/steps/grifo_2.jpg"
    }
  ],
  "success": {
    "title": "¡Listo el pollo!",
    "message": "Vuelva a armar todo y abra la llave de paso..."
  }
}

Estados de error

404: guía no encontrada o inactiva

410: guía deshabilitada

500: error interno

2. Decisión automática de qué guía sugerir
Objetivo

Determinar qué guía mostrar al usuario según su diagnóstico y contexto.

Entradas del sistema

Categoría del diagnóstico (diagnostics.category_id)

Nivel de riesgo (risk_level)

Texto ingresado por el usuario

Confianza del diagnóstico

Historial del usuario

Guías activas disponibles

Regla base (MVP)

Si el riesgo es alto → no mostrar guía, sugerir técnico

Buscar guías activas de la misma categoría

Priorizar:

is_quick = true

menor dificultad

mayor efectividad histórica

Si no hay coincidencias → usar categoría otro
Métricas asociadas

Guía sugerida

Guía abierta

Guía completada

Click en “contactar técnico”

Feedback útil / no útil

