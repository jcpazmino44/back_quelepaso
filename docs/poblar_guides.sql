
-- borrar información
/* BEGIN;

-- Primero tablas hijas (dependencias)
TRUNCATE TABLE
  guide_steps,
  guide_tools,
  guide_categories,
  history
RESTART IDENTITY CASCADE;

-- Luego tablas padre
TRUNCATE TABLE
  diagnostics,
  guides
RESTART IDENTITY CASCADE;

COMMIT; */

-- insertar información 

INSERT INTO guides (
  id, slug, title, summary, duration_minutes, difficulty_level,
  safety_title, safety_text,
  success_title, success_text,
  cover_image_url, is_active, version, created_at, updated_at
)
VALUES
-- ELECTRICIDAD
(gen_random_uuid(), 'toma-no-funciona', 'Toma corriente no funciona',
 'Guía rápida para identificar si el problema es de la toma, el breaker o un falso contacto.',
 12, 'intermedio',
 '⚠️ Seguridad primero',
 'Si hay chispa, olor a quemado o cables expuestos, NO intervengas. Desconecta y llama a un técnico.',
 '✅ Si funcionó',
 'Si la toma vuelve a funcionar sin calentarse, puedes usarla con normalidad. Si vuelve a fallar, contacta técnico.',
 NULL, true, 1, NOW(), NOW()),

(gen_random_uuid(), 'breaker-se-baja', 'Breaker se baja constantemente',
 'Pasos para revisar sobrecarga, equipos conectados y señales de corto de manera segura.',
 15, 'intermedio',
 '⚠️ Alto riesgo',
 'Si el breaker se baja inmediatamente y hay chispa/olor, es posible corto. No pruebes repetidamente.',
 '✅ Si funcionó',
 'Si el breaker se mantiene arriba sin conectar equipos, el problema podría ser la carga. Reconecta 1 a 1.',
 NULL, true, 1, NOW(), NOW()),

-- FONTANERÍA SIMPLE
(gen_random_uuid(), 'fuga-visible', 'Fuga visible de agua (bajo lavaplatos o baño)',
 'Detén la fuga temporalmente y verifica si es una unión suelta o un empaque deteriorado.',
 18, 'basico',
 '⚠️ Seguridad',
 'Cierra la llave de paso antes de manipular conexiones. Seca el área para evitar resbalones.',
 '✅ Si funcionó',
 'Si no hay goteo por 10 minutos y las uniones están secas, el ajuste fue exitoso.',
 NULL, true, 1, NOW(), NOW()),

-- GRIFERÍA Y SANITARIOS
(gen_random_uuid(), 'llave-gotea', 'Llave que gotea',
 'Guía para identificar si el goteo es por empaque, aireador o ajuste básico.',
 14, 'basico',
 '⚠️ Seguridad',
 'Cierra la llave de paso antes de desarmar. Si no tienes herramienta, no fuerces la pieza.',
 '✅ Si funcionó',
 'Si el goteo desaparece y no hay filtración en la base, quedó solucionado.',
 NULL, true, 1, NOW(), NOW()),

(gen_random_uuid(), 'inodoro-no-descarga', 'Inodoro no descarga',
 'Revisa el flotador, la cadena y el suministro de agua del tanque.',
 12, 'basico',
 '⚠️ Seguridad',
 'Si hay rebose o fuga mayor, cierra la llave del inodoro y usa balde para controlar el agua.',
 '✅ Si funcionó',
 'Si el tanque llena y descarga normalmente 2–3 veces seguidas, puedes darlo por resuelto.',
 NULL, true, 1, NOW(), NOW()),

-- NEVERA
(gen_random_uuid(), 'nevera-no-enfria', 'Nevera no enfría (básico)',
 'Diagnóstico inicial: temperatura, ventilación, hielo excesivo y sellos.',
 16, 'intermedio',
 '⚠️ Seguridad',
 'Desconecta la nevera antes de limpiar o mover. Si escuchas chispas o hay olor a quemado, llama técnico.',
 '✅ Si funcionó',
 'Si en 4–6 horas mejora el enfriamiento y no hay escarcha excesiva, el ajuste ayudó.',
 NULL, true, 1, NOW(), NOW()),

-- LAVADORA
(gen_random_uuid(), 'lavadora-no-desagua', 'Lavadora no desagua',
 'Revisa manguera, filtro y drenaje para resolver el problema sin desmontajes complejos.',
 20, 'intermedio',
 '⚠️ Seguridad',
 'Desconecta la lavadora antes de revisar drenajes. Mantén el área seca para evitar caídas.',
 '✅ Si funcionó',
 'Si completa un ciclo corto y expulsa el agua sin dificultad, la falla fue resuelta.',
 NULL, true, 1, NOW(), NOW()),

-- VENTILADOR
(gen_random_uuid(), 'ventilador-no-gira', 'Ventilador no gira / gira lento',
 'Limpieza y revisión básica de aspas, eje y conexión eléctrica.',
 10, 'basico',
 '⚠️ Seguridad',
 'Desconecta el ventilador antes de abrir la rejilla. No uses líquidos en el motor.',
 '✅ Si funcionó',
 'Si gira a velocidad normal y sin ruidos extraños por 2 minutos, quedó correcto.',
 NULL, true, 1, NOW(), NOW()),

-- PUERTAS Y CERRADURAS
(gen_random_uuid(), 'puerta-no-cierra', 'Puerta no cierra / roza',
 'Ajusta tornillos y revisa bisagras para corregir desalineación leve.',
 15, 'basico',
 '⚠️ Seguridad',
 'Si la puerta es pesada, pide ayuda para sostenerla. Evita apretar tornillos con fuerza excesiva.',
 '✅ Si funcionó',
 'Si la puerta cierra sin roce 3 veces seguidas, el ajuste funcionó.',
 NULL, true, 1, NOW(), NOW());

CREATE EXTENSION IF NOT EXISTS pgcrypto;

INSERT INTO guide_categories (guide_id, category_id, created_at)
SELECT g.id, c.id, NOW()
FROM guides g
JOIN categories c ON (
  (g.slug IN ('toma-no-funciona','breaker-se-baja') AND c.slug = 'electricidad-basica') OR
  (g.slug IN ('fuga-visible') AND c.slug = 'fontaneria-simple') OR
  (g.slug IN ('llave-gotea','inodoro-no-descarga') AND c.slug = 'griferia-sanitarios') OR
  (g.slug IN ('nevera-no-enfria') AND c.slug = 'nevera') OR
  (g.slug IN ('lavadora-no-desagua') AND c.slug = 'lavadora') OR
  (g.slug IN ('ventilador-no-gira') AND c.slug = 'ventilador') OR
  (g.slug IN ('puerta-no-cierra') AND c.slug = 'puertas-cerraduras')
)
WHERE g.slug IN (
  'toma-no-funciona','breaker-se-baja','fuga-visible','llave-gotea','inodoro-no-descarga',
  'nevera-no-enfria','lavadora-no-desagua','ventilador-no-gira','puerta-no-cierra'
)
AND NOT EXISTS (
  SELECT 1
  FROM guide_categories gc
  WHERE gc.guide_id = g.id AND gc.category_id = c.id
);

INSERT INTO guide_tools (guide_id, tool_id, is_required, order_index, created_at, updated_at)
SELECT g.id, t.id, x.is_required, x.order_index, NOW(), NOW()
FROM (
  VALUES
    ('toma-no-funciona',    'linterna',       true,  1),
    ('toma-no-funciona',    'guantes',        false, 2),

    ('breaker-se-baja',     'linterna',       true,  1),
    ('breaker-se-baja',     'guantes',        false, 2),
    ('breaker-se-baja',     'multimetro',     false, 3),

    ('fuga-visible',        'balde',          true,  1),
    ('fuga-visible',        'trapo',          true,  2),
    ('fuga-visible',        'llave_inglesa',  false, 3),
    ('fuga-visible',        'cinta_teflon',   false, 4),

    ('llave-gotea',         'trapo',          true,  1),
    ('llave-gotea',         'cepillo',        false, 2),
    ('llave-gotea',         'llave_inglesa',  false, 3),

    ('inodoro-no-descarga', 'balde',          true,  1),
    ('inodoro-no-descarga', 'guantes',        false, 2),

    ('nevera-no-enfria',    'cepillo',        true,  1),
    ('nevera-no-enfria',    'trapo',          true,  2),

    ('lavadora-no-desagua', 'balde',          true,  1),
    ('lavadora-no-desagua', 'trapo',          true,  2),

    ('ventilador-no-gira',  'cepillo',        true,  1),
    ('ventilador-no-gira',  'destornillador', false, 2),

    ('puerta-no-cierra',    'destornillador', true,  1),
    ('puerta-no-cierra',    'alicate',        false, 2)
) AS x(guide_slug, tool_slug, is_required, order_index)
JOIN guides g ON g.slug = x.guide_slug
JOIN tools  t ON t.slug = x.tool_slug
WHERE NOT EXISTS (
  SELECT 1 FROM guide_tools gt
  WHERE gt.guide_id = g.id AND gt.tool_id = t.id
);
INSERT INTO guide_steps (
  id, guide_id, step_number, title, body, image_url, estimated_minutes, created_at, updated_at
)
SELECT
  gen_random_uuid(),
  g.id,
  s.n,
  s.t,
  s.b,
  NULL,
  s.m,
  NOW(),
  NOW()
FROM guides g
JOIN (
  VALUES
    (1,'Apaga y desconecta','Desconecta cualquier equipo de la toma. Si el área está húmeda, sécala antes de tocar.',2),
    (2,'Revisa el breaker','Mira si algún breaker está abajo. Si está abajo, súbelo una sola vez.',3),
    (3,'Prueba otra toma','Conecta el mismo equipo en otra toma para validar si el problema es la toma o el equipo.',3),
    (4,'Señales de riesgo','Si hay chispa, olor a quemado o la toma está caliente: NO uses esa toma. Contacta técnico.',2),
    (5,'Decisión','Si no hay riesgo y vuelve a fallar, contacta técnico. Si queda estable, úsala con precaución.',2)
) AS s(n,t,b,m)
  ON g.slug = 'toma-no-funciona'
WHERE NOT EXISTS (
  SELECT 1
  FROM guide_steps gs
  WHERE gs.guide_id = g.id
    AND gs.step_number = s.n
);

INSERT INTO guide_steps (id, guide_id, step_number, title, body, estimated_minutes, created_at, updated_at)
SELECT gen_random_uuid(), g.id, s.n, s.t, s.b, s.m, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1,'Desconecta todo','Desconecta equipos de alto consumo (planchas, microondas, calentadores).',3),
  (2,'Sube el breaker','Súbelo una sola vez. Si se baja de inmediato, hay riesgo de corto.',3),
  (3,'Reconecta uno a uno','Conecta un equipo a la vez para identificar el causante.',5),
  (4,'No insistas','No subas repetidamente el breaker.',2),
  (5,'Decisión','Si no identificas la causa, contacta técnico.',2)
) s(n,t,b,m)
ON g.slug = 'breaker-se-baja'
WHERE NOT EXISTS (SELECT 1 FROM guide_steps WHERE guide_id = g.id);

INSERT INTO guide_steps (id, guide_id, step_number, title, body, estimated_minutes, created_at, updated_at)
SELECT gen_random_uuid(), g.id, s.n, s.t, s.b, s.m, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1,'Cierra el agua','Cierra la llave de paso local o general.',3),
  (2,'Seca y ubica','Seca la zona y ubica exactamente la fuga.',4),
  (3,'Ajusta unión','Ajusta suavemente la unión o usa cinta teflón.',6),
  (4,'Prueba','Abre el paso y observa si continúa el goteo.',3),
  (5,'Decisión','Si persiste, contacta técnico.',2)
) s(n,t,b,m)
ON g.slug = 'fuga-visible'
WHERE NOT EXISTS (SELECT 1 FROM guide_steps WHERE guide_id = g.id);

INSERT INTO guide_steps (id, guide_id, step_number, title, body, estimated_minutes, created_at, updated_at)
SELECT gen_random_uuid(), g.id, s.n, s.t, s.b, s.m, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1,'Cierra el paso','Cierra la llave inferior.',2),
  (2,'Identifica el goteo','Revisa si sale por la base o la boquilla.',3),
  (3,'Limpia aireador','Limpia la boquilla con cepillo.',4),
  (4,'Evalúa empaque','Si es por la base, puede requerir empaque.',3),
  (5,'Decisión','Si persiste, técnico o repuesto.',2)
) s(n,t,b,m)
ON g.slug = 'llave-gotea'
WHERE NOT EXISTS (SELECT 1 FROM guide_steps WHERE guide_id = g.id);

INSERT INTO guide_steps (id, guide_id, step_number, title, body, estimated_minutes, created_at, updated_at)
SELECT gen_random_uuid(), g.id, s.n, s.t, s.b, s.m, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1,'Revisa tanque','Levanta la tapa y verifica nivel de agua.',3),
  (2,'Cadena y flotador','Asegura cadena y flotador libres.',4),
  (3,'Prueba descarga','Observa apertura y cierre.',2),
  (4,'Ajuste básico','Ajusta cadena o flotador.',2),
  (5,'Decisión','Si no funciona, técnico.',1)
) s(n,t,b,m)
ON g.slug = 'inodoro-no-descarga'
WHERE NOT EXISTS (SELECT 1 FROM guide_steps WHERE guide_id = g.id);

INSERT INTO guide_steps (id, guide_id, step_number, title, body, estimated_minutes, created_at, updated_at)
SELECT gen_random_uuid(), g.id, s.n, s.t, s.b, s.m, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1,'Revisa temperatura','Ajusta a nivel medio.',2),
  (2,'Ventilación','Deja espacio detrás.',3),
  (3,'Limpia rejilla','Limpia polvo con cepillo.',6),
  (4,'Revisa sellos','Limpia sellos de la puerta.',3),
  (5,'Decisión','Si no mejora, técnico.',2)
) s(n,t,b,m)
ON g.slug = 'nevera-no-enfria'
WHERE NOT EXISTS (SELECT 1 FROM guide_steps WHERE guide_id = g.id);

INSERT INTO guide_steps (id, guide_id, step_number, title, body, estimated_minutes, created_at, updated_at)
SELECT gen_random_uuid(), g.id, s.n, s.t, s.b, s.m, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1,'Desconecta','Desconecta y prepara balde.',3),
  (2,'Revisa manguera','Endereza o destapa.',5),
  (3,'Limpia filtro','Retira residuos.',7),
  (4,'Prueba ciclo','Ejecuta ciclo corto.',4),
  (5,'Decisión','Si falla, técnico.',1)
) s(n,t,b,m)
ON g.slug = 'lavadora-no-desagua'
WHERE NOT EXISTS (SELECT 1 FROM guide_steps WHERE guide_id = g.id);

INSERT INTO guide_steps (id, guide_id, step_number, title, body, estimated_minutes, created_at, updated_at)
SELECT gen_random_uuid(), g.id, s.n, s.t, s.b, s.m, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1,'Desconecta','Desconecta antes de abrir.',1),
  (2,'Limpia','Limpia aspas y rejilla.',4),
  (3,'Revisa giro','Gira a mano para ver roces.',3),
  (4,'Decisión','Si huele a quemado, técnico.',2)
) s(n,t,b,m)
ON g.slug = 'ventilador-no-gira'
WHERE NOT EXISTS (SELECT 1 FROM guide_steps WHERE guide_id = g.id);

INSERT INTO guide_steps (id, guide_id, step_number, title, body, estimated_minutes, created_at, updated_at)
SELECT gen_random_uuid(), g.id, s.n, s.t, s.b, s.m, NOW(), NOW()
FROM guides g
JOIN (VALUES
  (1,'Identifica roce','Cierra lento y mira dónde roza.',3),
  (2,'Ajusta bisagras','Aprieta tornillos.',5),
  (3,'Revisa cerradura','Verifica alineación del pestillo.',5),
  (4,'Decisión','Si no mejora, carpintero.',2)
) s(n,t,b,m)
ON g.slug = 'puerta-no-cierra'
WHERE NOT EXISTS (SELECT 1 FROM guide_steps WHERE guide_id = g.id);



-- comprobar que quedó bien
/* 
SELECT
  g.slug        AS guide_slug,
  g.title       AS guide_title,
  gs.step_number,
  gs.title      AS step_title,
  gs.estimated_minutes
FROM guides g
JOIN guide_steps gs ON gs.guide_id = g.id
ORDER BY g.slug, gs.step_number;
 */