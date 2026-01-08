BEGIN;

INSERT INTO guides (
  id,
  slug,
  title,
  summary,
  duration_minutes,
  difficulty_level,
  safety_title,
  safety_text,
  success_title,
  success_text,
  cover_image_url,
  is_active,
  version
)
VALUES
  (gen_random_uuid(), 'plomeria-fuga-grifo', 'Fuga en grifo', 'Como detener una fuga leve en un grifo.', 20, 'basico', 'Cierra la llave', 'Cierra la llave de paso antes de iniciar.', 'Prueba final', 'Abre la llave y verifica que no gotee.', NULL, true, 1),
  (gen_random_uuid(), 'plomeria-desague-lento', 'Desague lento', 'Limpieza basica para mejorar el flujo del desague.', 25, 'basico', 'Protege tus manos', 'Usa guantes y evita quimicos fuertes.', 'Flujo normal', 'Verifica que el agua baje sin acumulacion.', NULL, true, 1),
  (gen_random_uuid(), 'electricidad-tomacorriente', 'Tomacorriente sin energia', 'Diagnostico basico de un toma sin energia.', 30, 'intermedio', 'Corta la energia', 'Baja el breaker antes de revisar.', 'Restablecido', 'Prueba con otro dispositivo.', NULL, true, 1),
  (gen_random_uuid(), 'electricidad-breaker', 'Breaker se baja', 'Identificar sobrecarga en el circuito.', 25, 'intermedio', 'Seguridad', 'No manipules cables energizados.', 'Circuito estable', 'Verifica consumo y vuelve a activar.', NULL, true, 1),
  (gen_random_uuid(), 'electrodomesticos-nevera', 'Nevera no enfria', 'Pasos basicos para diagnosticar refrigeracion.', 35, 'intermedio', 'Desconecta', 'Desconecta antes de revisar bobinas.', 'Mejora de frio', 'Vuelve a conectar y espera 30 min.', NULL, true, 1),
  (gen_random_uuid(), 'electrodomesticos-lavadora', 'Lavadora no drena', 'Solucion rapida de drenaje.', 30, 'basico', 'Evita agua', 'Ten un balde listo.', 'Drenaje normal', 'Haz una prueba de enjuague.', NULL, true, 1),
  (gen_random_uuid(), 'internet-wifi-lento', 'Wi-Fi lento', 'Mejorar senal y rendimiento.', 20, 'basico', 'Reinicio seguro', 'Reinicia modem y router.', 'Conexion estable', 'Prueba velocidad nuevamente.', NULL, true, 1),
  (gen_random_uuid(), 'internet-sin-senal', 'Sin senal de internet', 'Verifica conexion y cableado.', 15, 'basico', 'Cuidado', 'No dobles cables con fuerza.', 'Restablecido', 'Verifica LEDs del modem.', NULL, true, 1),
  (gen_random_uuid(), 'otro-general', 'Problema no identificado', 'Checklist general de revision.', 15, 'basico', 'Precaucion', 'Si hay riesgo, deten el proceso.', 'Definido', 'Contacta un tecnico si persiste.', NULL, true, 1)
ON CONFLICT (slug) DO NOTHING;

WITH target_guides AS (
  SELECT id, slug
  FROM guides
  WHERE slug IN (
    'plomeria-fuga-grifo',
    'plomeria-desague-lento',
    'electricidad-tomacorriente',
    'electricidad-breaker',
    'electrodomesticos-nevera',
    'electrodomesticos-lavadora',
    'internet-wifi-lento',
    'internet-sin-senal',
    'otro-general'
  )
),
category_map AS (
  SELECT g.id, c.id AS category_id
  FROM target_guides g
  JOIN categories c ON
    (g.slug LIKE 'plomeria-%' AND c.slug = 'plomeria') OR
    (g.slug LIKE 'electricidad-%' AND c.slug = 'electricidad') OR
    (g.slug LIKE 'electrodomesticos-%' AND c.slug = 'electrodomesticos') OR
    (g.slug LIKE 'internet-%' AND c.slug = 'internet') OR
    (g.slug = 'otro-general' AND c.slug = 'otro')
)
INSERT INTO guide_categories (guide_id, category_id)
SELECT id, category_id FROM category_map
ON CONFLICT (guide_id, category_id) DO NOTHING;

WITH target_guides AS (
  SELECT id
  FROM guides
  WHERE slug IN (
    'plomeria-fuga-grifo',
    'plomeria-desague-lento',
    'electricidad-tomacorriente',
    'electricidad-breaker',
    'electrodomesticos-nevera',
    'electrodomesticos-lavadora',
    'internet-wifi-lento',
    'internet-sin-senal',
    'otro-general'
  )
)
INSERT INTO guide_steps (id, guide_id, step_number, title, body, image_url, estimated_minutes)
SELECT gen_random_uuid(), g.id, 1, 'Revision inicial', 'Identifica el sintoma principal y asegura el area.', NULL, 5
FROM target_guides g
ON CONFLICT (guide_id, step_number) DO NOTHING;

WITH target_guides AS (
  SELECT id
  FROM guides
  WHERE slug IN (
    'plomeria-fuga-grifo',
    'plomeria-desague-lento',
    'electricidad-tomacorriente',
    'electricidad-breaker',
    'electrodomesticos-nevera',
    'electrodomesticos-lavadora',
    'internet-wifi-lento',
    'internet-sin-senal',
    'otro-general'
  )
)
INSERT INTO guide_steps (id, guide_id, step_number, title, body, image_url, estimated_minutes)
SELECT gen_random_uuid(), g.id, 2, 'Accion principal', 'Aplica la accion sugerida en la guia para resolver el problema.', NULL, 10
FROM target_guides g
ON CONFLICT (guide_id, step_number) DO NOTHING;

WITH target_guides AS (
  SELECT id
  FROM guides
  WHERE slug IN (
    'plomeria-fuga-grifo',
    'plomeria-desague-lento',
    'electricidad-tomacorriente',
    'electricidad-breaker',
    'electrodomesticos-nevera',
    'electrodomesticos-lavadora',
    'internet-wifi-lento',
    'internet-sin-senal',
    'otro-general'
  )
)
INSERT INTO guide_tools (guide_id, tool_id, is_required, order_index)
SELECT g.id, t.id, true, 1
FROM target_guides g
JOIN tools t ON t.slug = 'cinta-teflon'
ON CONFLICT (guide_id, tool_id) DO NOTHING;

WITH target_guides AS (
  SELECT id
  FROM guides
  WHERE slug IN (
    'plomeria-fuga-grifo',
    'plomeria-desague-lento',
    'electricidad-tomacorriente',
    'electricidad-breaker',
    'electrodomesticos-nevera',
    'electrodomesticos-lavadora',
    'internet-wifi-lento',
    'internet-sin-senal',
    'otro-general'
  )
)
INSERT INTO guide_tools (guide_id, tool_id, is_required, order_index)
SELECT g.id, t.id, false, 2
FROM target_guides g
JOIN tools t ON t.slug = 'trapo'
ON CONFLICT (guide_id, tool_id) DO NOTHING;

COMMIT;
