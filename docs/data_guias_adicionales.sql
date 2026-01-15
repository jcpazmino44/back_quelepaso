-- ============================================================
-- SEEDS: 6 guías faltantes + tools + steps + categorías + tools por guía
-- Recomendado ejecutar en una transacción
-- ============================================================

BEGIN;

-- 0) UUID helper (si no tienes pgcrypto)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ------------------------------------------------------------
-- 1) TOOLS (agrega solo los que faltan)
-- Asumo que tools.slug es UNIQUE. Si no lo es, ajusta el ON CONFLICT.
-- ------------------------------------------------------------
INSERT INTO tools (id, slug, name, icon, created_at, updated_at)
VALUES
  (gen_random_uuid(), 'linterna', 'Linterna', 'flashlight_on', NOW(), NOW()),
  (gen_random_uuid(), 'celular-datos', 'Celular (datos móviles)', 'smartphone', NOW(), NOW()),
  (gen_random_uuid(), 'app-speedtest', 'App de prueba de velocidad (Speedtest)', 'speed', NOW(), NOW()),
  (gen_random_uuid(), 'clip-pin', 'Clip o pin (para botón reset)', 'push_pin', NOW(), NOW()),
  (gen_random_uuid(), 'cepillo-suave', 'Cepillo suave', 'cleaning_services', NOW(), NOW()),
  (gen_random_uuid(), 'trapo-seco', 'Trapo seco', 'cleaning_services', NOW(), NOW()),
  (gen_random_uuid(), 'recipiente-pequeno', 'Recipiente pequeño', 'local_drink', NOW(), NOW()),
  (gen_random_uuid(), 'lubricante-cerraduras', 'Lubricante para cerraduras (grafito/silicona)', 'opacity', NOW(), NOW())
ON CONFLICT (slug) DO UPDATE
SET name = EXCLUDED.name,
    icon = EXCLUDED.icon,
    updated_at = NOW();

-- ------------------------------------------------------------
-- 2) GUIDES (6)
-- Asumo guides.slug es UNIQUE.
-- ------------------------------------------------------------
INSERT INTO guides (
  id, slug, title, summary, duration_minutes, difficulty_level,
  safety_title, safety_text, success_title, success_text,
  cover_image_url, is_active, version, created_at, updated_at
)
VALUES
  (
    gen_random_uuid(),
    'internet-caido',
    'No tengo internet / Wi-Fi caído',
    'Pasos rápidos para descartar fallas comunes en router, cableado y proveedor antes de pedir soporte.',
    15,
    'basico',
    '⚠️ Seguridad',
    'Si ves chispas, cables pelados o el equipo se calienta/olora raro, desconecta y no manipules el cableado.',
    '✅ Si funcionó',
    'Si recuperas conexión estable por 5–10 minutos y puedes navegar en 2 dispositivos, el problema quedó resuelto.',
    NULL,
    TRUE,
    1,
    NOW(),
    NOW()
  ),
  (
    gen_random_uuid(),
    'wifi-lento-intermitente',
    'Wi-Fi lento o intermitente',
    'Mejora la señal y descarta saturación o mala ubicación con pruebas simples y sin configuraciones complejas.',
    18,
    'basico',
    '⚠️ Seguridad',
    'No abras el router ni uses objetos metálicos en sus puertos. Evita ubicarlo cerca de agua o calor.',
    '✅ Si funcionó',
    'Si la velocidad mejora y la señal se mantiene estable en la misma zona de la casa, el ajuste fue exitoso.',
    NULL,
    TRUE,
    1,
    NOW(),
    NOW()
  ),
  (
    gen_random_uuid(),
    'lavadora-no-enciende',
    'Lavadora no enciende / no inicia',
    'Guía para revisar energía, tapa/seguro, enchufe y reinicio básico antes de llamar técnico.',
    14,
    'basico',
    '⚠️ Seguridad',
    'No manipules cables internos. Si hay olor a quemado o la lavadora calienta sin razón, desconecta y llama a técnico.',
    '✅ Si funcionó',
    'Si enciende, responde a los botones y completa un ciclo corto sin apagarse, el problema quedó resuelto.',
    NULL,
    TRUE,
    1,
    NOW(),
    NOW()
  ),
  (
    gen_random_uuid(),
    'nevera-bota-agua-escarcha',
    'Nevera bota agua / hace escarcha',
    'Revisa sellos, drenaje y acumulación de hielo; aplica soluciones seguras sin desmontajes complejos.',
    20,
    'intermedio',
    '⚠️ Seguridad',
    'Desconecta la nevera antes de limpiar o hacer deshielo. No uses cuchillos para quitar hielo: puedes dañar tuberías.',
    '✅ Si funcionó',
    'Si deja de gotear y la escarcha disminuye tras el deshielo/limpieza, y mantiene frío estable, quedó mejorado.',
    NULL,
    TRUE,
    1,
    NOW(),
    NOW()
  ),
  (
    gen_random_uuid(),
    'ventilador-no-prende',
    'Ventilador no prende',
    'Descarta problemas de toma, cable y controles. Incluye revisión básica sin abrir el motor.',
    12,
    'basico',
    '⚠️ Seguridad',
    'No abras el motor. Si el cable está pelado o huele a quemado, no lo uses. Prueba en otra toma segura.',
    '✅ Si funcionó',
    'Si enciende y se mantiene funcionando 2–3 minutos sin olor raro ni calentamiento, quedó correcto.',
    NULL,
    TRUE,
    1,
    NOW(),
    NOW()
  ),
  (
    gen_random_uuid(),
    'otro-ruta-rapida',
    'No encuentro mi problema (ruta rápida)',
    'Un camino corto para ubicar tu caso en la categoría correcta o dejarlo registrado para ayudarte mejor.',
    6,
    'basico',
    '⚠️ Importante',
    'Si hay riesgo (fuego, gas, chispas, inundación fuerte, lesión), detén la guía y busca ayuda profesional.',
    '✅ Si funcionó',
    'Si logras ubicar tu problema en una categoría y encuentras una guía útil, ya avanzaste al siguiente paso.',
    NULL,
    TRUE,
    1,
    NOW(),
    NOW()
  )
ON CONFLICT (slug) DO UPDATE
SET title = EXCLUDED.title,
    summary = EXCLUDED.summary,
    duration_minutes = EXCLUDED.duration_minutes,
    difficulty_level = EXCLUDED.difficulty_level,
    safety_title = EXCLUDED.safety_title,
    safety_text = EXCLUDED.safety_text,
    success_title = EXCLUDED.success_title,
    success_text = EXCLUDED.success_text,
    is_active = EXCLUDED.is_active,
    version = EXCLUDED.version,
    updated_at = NOW();

-- ------------------------------------------------------------
-- 3) GUIDE_CATEGORIES (mapeo por slug)
-- Ajusta los slugs si en tu tabla categories son distintos.
-- ------------------------------------------------------------
INSERT INTO guide_categories (guide_id, category_id, created_at)
SELECT g.id, c.id, NOW()
FROM guides g
JOIN categories c ON c.slug = 'internet'
WHERE g.slug IN ('internet-caido', 'wifi-lento-intermitente')
ON CONFLICT (guide_id, category_id) DO NOTHING;

INSERT INTO guide_categories (guide_id, category_id, created_at)
SELECT g.id, c.id, NOW()
FROM guides g
JOIN categories c ON c.slug = 'lavadora'
WHERE g.slug = 'lavadora-no-enciende'
ON CONFLICT (guide_id, category_id) DO NOTHING;

INSERT INTO guide_categories (guide_id, category_id, created_at)
SELECT g.id, c.id, NOW()
FROM guides g
JOIN categories c ON c.slug = 'nevera'
WHERE g.slug = 'nevera-bota-agua-escarcha'
ON CONFLICT (guide_id, category_id) DO NOTHING;

INSERT INTO guide_categories (guide_id, category_id, created_at)
SELECT g.id, c.id, NOW()
FROM guides g
JOIN categories c ON c.slug = 'ventilador'
WHERE g.slug = 'ventilador-no-prende'
ON CONFLICT (guide_id, category_id) DO NOTHING;

INSERT INTO guide_categories (guide_id, category_id, created_at)
SELECT g.id, c.id, NOW()
FROM guides g
JOIN categories c ON c.slug = 'otro'
WHERE g.slug = 'otro-ruta-rapida'
ON CONFLICT (guide_id, category_id) DO NOTHING;

-- ------------------------------------------------------------
-- 4) GUIDE_TOOLS (relación guía -> herramientas)
-- Asumo guía_tools tiene UNIQUE(guide_id, tool_id) o similar.
-- ------------------------------------------------------------

-- Internet caído
INSERT INTO guide_tools (guide_id, tool_id, is_required, order_index, created_at, updated_at)
SELECT g.id, t.id, TRUE, 1, NOW(), NOW()
FROM guides g JOIN tools t ON t.slug = 'celular-datos'
WHERE g.slug = 'internet-caido'
ON CONFLICT (guide_id, tool_id) DO UPDATE
SET is_required = EXCLUDED.is_required, order_index = EXCLUDED.order_index, updated_at = NOW();

INSERT INTO guide_tools (guide_id, tool_id, is_required, order_index, created_at, updated_at)
SELECT g.id, t.id, FALSE, 2, NOW(), NOW()
FROM guides g JOIN tools t ON t.slug = 'linterna'
WHERE g.slug = 'internet-caido'
ON CONFLICT (guide_id, tool_id) DO UPDATE
SET is_required = EXCLUDED.is_required, order_index = EXCLUDED.order_index, updated_at = NOW();

INSERT INTO guide_tools (guide_id, tool_id, is_required, order_index, created_at, updated_at)
SELECT g.id, t.id, FALSE, 3, NOW(), NOW()
FROM guides g JOIN tools t ON t.slug = 'clip-pin'
WHERE g.slug = 'internet-caido'
ON CONFLICT (guide_id, tool_id) DO UPDATE
SET is_required = EXCLUDED.is_required, order_index = EXCLUDED.order_index, updated_at = NOW();

-- Wi-Fi lento
INSERT INTO guide_tools (guide_id, tool_id, is_required, order_index, created_at, updated_at)
SELECT g.id, t.id, FALSE, 1, NOW(), NOW()
FROM guides g JOIN tools t ON t.slug = 'app-speedtest'
WHERE g.slug = 'wifi-lento-intermitente'
ON CONFLICT (guide_id, tool_id) DO UPDATE
SET is_required = EXCLUDED.is_required, order_index = EXCLUDED.order_index, updated_at = NOW();

-- Lavadora no enciende
INSERT INTO guide_tools (guide_id, tool_id, is_required, order_index, created_at, updated_at)
SELECT g.id, t.id, FALSE, 1, NOW(), NOW()
FROM guides g JOIN tools t ON t.slug = 'trapo-seco'
WHERE g.slug = 'lavadora-no-enciende'
ON CONFLICT (guide_id, tool_id) DO UPDATE
SET is_required = EXCLUDED.is_required, order_index = EXCLUDED.order_index, updated_at = NOW();

-- Nevera bota agua / escarcha
INSERT INTO guide_tools (guide_id, tool_id, is_required, order_index, created_at, updated_at)
SELECT g.id, t.id, TRUE, 1, NOW(), NOW()
FROM guides g JOIN tools t ON t.slug = 'trapo-seco'
WHERE g.slug = 'nevera-bota-agua-escarcha'
ON CONFLICT (guide_id, tool_id) DO UPDATE
SET is_required = EXCLUDED.is_required, order_index = EXCLUDED.order_index, updated_at = NOW();

INSERT INTO guide_tools (guide_id, tool_id, is_required, order_index, created_at, updated_at)
SELECT g.id, t.id, FALSE, 2, NOW(), NOW()
FROM guides g JOIN tools t ON t.slug = 'recipiente-pequeno'
WHERE g.slug = 'nevera-bota-agua-escarcha'
ON CONFLICT (guide_id, tool_id) DO UPDATE
SET is_required = EXCLUDED.is_required, order_index = EXCLUDED.order_index, updated_at = NOW();

INSERT INTO guide_tools (guide_id, tool_id, is_required, order_index, created_at, updated_at)
SELECT g.id, t.id, FALSE, 3, NOW(), NOW()
FROM guides g JOIN tools t ON t.slug = 'cepillo-suave'
WHERE g.slug = 'nevera-bota-agua-escarcha'
ON CONFLICT (guide_id, tool_id) DO UPDATE
SET is_required = EXCLUDED.is_required, order_index = EXCLUDED.order_index, updated_at = NOW();

-- Ventilador no prende
INSERT INTO guide_tools (guide_id, tool_id, is_required, order_index, created_at, updated_at)
SELECT g.id, t.id, FALSE, 1, NOW(), NOW()
FROM guides g JOIN tools t ON t.slug = 'trapo-seco'
WHERE g.slug = 'ventilador-no-prende'
ON CONFLICT (guide_id, tool_id) DO UPDATE
SET is_required = EXCLUDED.is_required, order_index = EXCLUDED.order_index, updated_at = NOW();

-- Otro (ruta rápida) -> sin tools obligatorias por ahora

-- ------------------------------------------------------------
-- 5) GUIDE_STEPS (pasos por guía)
-- NOTA: si tienes UNIQUE(guide_id, step_number), puedes usar ON CONFLICT.
-- Aquí hago UPSERT por (guide_id, step_number) asumiendo esa restricción.
-- Si no existe, cambia ON CONFLICT por DO NOTHING y limpia antes.
-- ------------------------------------------------------------

-- Helper: función para insertar steps con menos repetición no la uso por compatibilidad,
-- así que inserto directo por guía.

-- ========== Guía: internet-caido ==========
INSERT INTO guide_steps (id, guide_id, step_number, title, body, image_url, estimated_minutes, created_at, updated_at)
SELECT
  gen_random_uuid(), g.id, s.step_number, s.title, s.body, NULL, s.estimated_minutes, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1, 'Verifica si el problema es general o solo un dispositivo',
      'Prueba con 2 dispositivos (celular y otro). Si solo falla uno, el problema suele estar en ese equipo (modo avión, red guardada, etc.).', 2),
  (2, 'Reinicia el router/módem correctamente',
      'Desconecta de la energía 30 segundos, vuelve a conectar y espera 2–3 minutos. No pulses reset aún.', 4),
  (3, 'Revisa cables y luces del equipo',
      'Verifica que el cable de energía esté firme y que el cable de internet (si aplica) esté conectado. Observa si las luces están normales (sin parpadeos extraños).', 3),
  (4, 'Descarta falla del proveedor',
      'Prueba navegar con datos móviles. Si los datos funcionan, puede ser tu red Wi-Fi o el servicio del proveedor. Si puedes, pregunta a un vecino si también está caído.', 3),
  (5, 'Último recurso: reset (solo si sabes la clave del Wi-Fi)',
      'Si nada funcionó y tienes la clave para reconfigurar, usa un clip y presiona RESET 10–15s. Luego vuelve a conectar tu red. Si no tienes la clave, omite este paso.', 3)
) AS s(step_number, title, body, estimated_minutes)
ON TRUE
WHERE g.slug = 'internet-caido'
ON CONFLICT (guide_id, step_number) DO UPDATE
SET title = EXCLUDED.title,
    body = EXCLUDED.body,
    estimated_minutes = EXCLUDED.estimated_minutes,
    updated_at = NOW();

-- ========== Guía: wifi-lento-intermitente ==========
INSERT INTO guide_steps (id, guide_id, step_number, title, body, image_url, estimated_minutes, created_at, updated_at)
SELECT
  gen_random_uuid(), g.id, s.step_number, s.title, s.body, NULL, s.estimated_minutes, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1, 'Mide la velocidad cerca del router',
      'Ubícate a 1–2 metros del router y haz una prueba de velocidad. Así sabes si el problema es señal o servicio.', 3),
  (2, 'Mejora ubicación del router',
      'Pon el router en un lugar alto, abierto, lejos de paredes gruesas y electrodomésticos grandes. Evita esconderlo en muebles cerrados.', 4),
  (3, 'Reduce saturación de dispositivos',
      'Desconecta temporalmente dispositivos que no uses. Si mejora, el problema puede ser saturación de red.', 3),
  (4, 'Reinicia router y revisa interferencias',
      'Reinicia el router (apagado 30s). Si hay microcortes, prueba acercarte. Si mejora, es señal/interferencia.', 4),
  (5, 'Si continúa: reporta con evidencias',
      'Si la velocidad es baja incluso cerca del router, guarda un pantallazo del test y repórtalo al proveedor indicando hora y barrio.', 4)
) AS s(step_number, title, body, estimated_minutes)
ON TRUE
WHERE g.slug = 'wifi-lento-intermitente'
ON CONFLICT (guide_id, step_number) DO UPDATE
SET title = EXCLUDED.title,
    body = EXCLUDED.body,
    estimated_minutes = EXCLUDED.estimated_minutes,
    updated_at = NOW();

-- ========== Guía: lavadora-no-enciende ==========
INSERT INTO guide_steps (id, guide_id, step_number, title, body, image_url, estimated_minutes, created_at, updated_at)
SELECT
  gen_random_uuid(), g.id, s.step_number, s.title, s.body, NULL, s.estimated_minutes, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1, 'Verifica energía y toma',
      'Prueba la toma con otro aparato (cargador, lámpara). Si no funciona, revisa tu guía de toma/breaker.', 3),
  (2, 'Revisa tapa/puerta y seguro',
      'Asegúrate de cerrar bien la tapa/puerta. Algunas lavadoras no inician si el seguro no engancha.', 3),
  (3, 'Haz un reinicio simple',
      'Desconecta 1 minuto, vuelve a conectar y prueba un ciclo corto. Esto reinicia la electrónica básica.', 3),
  (4, 'Descarta sobrecarga',
      'Si está muy llena, reduce la carga. Algunas lavadoras se bloquean si detectan exceso de peso.', 3),
  (5, 'Si sigue igual: detener y pedir soporte',
      'Si no enciende nada o se apaga sola, evita insistir. Anota marca/modelo y busca técnico autorizado.', 2)
) AS s(step_number, title, body, estimated_minutes)
ON TRUE
WHERE g.slug = 'lavadora-no-enciende'
ON CONFLICT (guide_id, step_number) DO UPDATE
SET title = EXCLUDED.title,
    body = EXCLUDED.body,
    estimated_minutes = EXCLUDED.estimated_minutes,
    updated_at = NOW();

-- ========== Guía: nevera-bota-agua-escarcha ==========
INSERT INTO guide_steps (id, guide_id, step_number, title, body, image_url, estimated_minutes, created_at, updated_at)
SELECT
  gen_random_uuid(), g.id, s.step_number, s.title, s.body, NULL, s.estimated_minutes, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1, 'Identifica de dónde viene el agua',
      'Mira si el agua viene por dentro (bandejas/cajones) o por debajo. Seca y observa 5 minutos.', 3),
  (2, 'Revisa el sello de la puerta',
      'Si la puerta no sella bien, entra humedad y se forma escarcha. Limpia el empaque y verifica que cierre sin esfuerzo.', 4),
  (3, 'Deshielo seguro (si hay mucha escarcha)',
      'Desconecta 2–4 horas (o hasta que baje el hielo). Coloca trapos y un recipiente. No rasques con cuchillos.', 6),
  (4, 'Limpia drenaje/bandeja accesible',
      'Si ves una canaleta o salida de agua accesible, límpiala con un cepillo suave y trapo. Sin desmontar piezas internas.', 4),
  (5, 'Reajusta temperatura y carga',
      'Evita llenar demasiado y deja espacio para circulación. Ajusta a un nivel medio y espera 6–8 horas.', 3)
) AS s(step_number, title, body, estimated_minutes)
ON TRUE
WHERE g.slug = 'nevera-bota-agua-escarcha'
ON CONFLICT (guide_id, step_number) DO UPDATE
SET title = EXCLUDED.title,
    body = EXCLUDED.body,
    estimated_minutes = EXCLUDED.estimated_minutes,
    updated_at = NOW();

-- ========== Guía: ventilador-no-prende ==========
INSERT INTO guide_steps (id, guide_id, step_number, title, body, image_url, estimated_minutes, created_at, updated_at)
SELECT
  gen_random_uuid(), g.id, s.step_number, s.title, s.body, NULL, s.estimated_minutes, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1, 'Prueba en otra toma segura',
      'Conéctalo en otra toma que sí funcione. Si enciende, el problema era la toma original.', 2),
  (2, 'Revisa cable y enchufe',
      'Observa si el cable está pelado o suelto. Si hay daño visible, no lo uses.', 2),
  (3, 'Revisa controles (perillas/botones)',
      'Ponlo en velocidad 1 y luego 2. A veces el selector queda a medias. Si tiene control, revisa batería/pila.', 3),
  (4, 'Limpieza básica exterior',
      'Con el ventilador desconectado, limpia rejilla y aspas. El polvo excesivo puede afectar el arranque en algunos modelos.', 3),
  (5, 'Si no enciende: no insistas',
      'Si no responde nada, evita seguir probando. Puede ser fallo interno. Busca técnico o garantía.', 2)
) AS s(step_number, title, body, estimated_minutes)
ON TRUE
WHERE g.slug = 'ventilador-no-prende'
ON CONFLICT (guide_id, step_number) DO UPDATE
SET title = EXCLUDED.title,
    body = EXCLUDED.body,
    estimated_minutes = EXCLUDED.estimated_minutes,
    updated_at = NOW();

-- ========== Guía: otro-ruta-rapida ==========
INSERT INTO guide_steps (id, guide_id, step_number, title, body, image_url, estimated_minutes, created_at, updated_at)
SELECT
  gen_random_uuid(), g.id, s.step_number, s.title, s.body, NULL, s.estimated_minutes, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1, '¿Es un problema de Internet o señal?',
      'Si es Wi-Fi, router, señal o “no carga nada”, entra a la categoría Internet.', 1),
  (2, '¿Es agua, fuga o sanitarios?',
      'Si es goteo, fuga, inodoro o lavaplatos, entra a Plomería.', 1),
  (3, '¿Es electricidad o energía?',
      'Si es toma, breaker, chispa o “no enciende”, entra a Electricidad básica.', 1),
  (4, '¿Es un electrodoméstico?',
      'Si es nevera, lavadora o ventilador, entra a su categoría.', 1),
  (5, 'Si no aplica: deja tu caso',
      'Escribe qué pasó (qué pasó, desde cuándo, qué intentaste). Con eso mejoraremos guías para ti y otros usuarios.', 2)
) AS s(step_number, title, body, estimated_minutes)
ON TRUE
WHERE g.slug = 'otro-ruta-rapida'
ON CONFLICT (guide_id, step_number) DO UPDATE
SET title = EXCLUDED.title,
    body = EXCLUDED.body,
    estimated_minutes = EXCLUDED.estimated_minutes,
    updated_at = NOW();

COMMIT;
