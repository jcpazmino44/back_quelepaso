--
-- PostgreSQL database dump
--

\restrict qEe8jVivreoCfBqQozTKPKWoFkkb149FGdK0AB29BcmxhgluaKkYI9Q2wR9bFWH

-- Dumped from database version 18.1 (Debian 18.1-1.pgdg12+2)
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, slug, name, description, icon, tint_color, bg_color, is_quick, order_index, is_active, created_at, updated_at, image_url) FROM stdin;
5057f686-9faf-48ae-ba89-414e27799769	ventilador	Ventilador	Problemas sencillos de ventiladores como falta de giro o ruidos.	toys_fan	#FFFFFF	#00897B	t	5	t	2026-01-09 20:38:26.50974+00	2026-01-09 20:38:26.50974+00	\N
d8f79f83-7ce2-468f-a777-95ac4dc71f0c	griferia-sanitarios	Grifería y sanitarios	Llaves, duchas e inodoros con fallas básicas de funcionamiento.	plumbing	#FFFFFF	#6D4C41	t	6	t	2026-01-09 20:38:26.50974+00	2026-01-09 20:38:26.50974+00	\N
ef2031f2-1016-4bde-8573-6fe70ab77363	puertas-cerraduras	Puertas y cerraduras	Puertas que no cierran, manijas flojas o cerraduras duras.	lock	#FFFFFF	#546E7A	t	7	t	2026-01-09 20:38:26.50974+00	2026-01-09 20:38:26.50974+00	\N
f742ded4-049b-4359-923e-c82f4dc697d7	fontaneria-simple	Fontanería simple	Fugas visibles, llaves que gotean e inodoros con fallas simples.	water_drop	#FFFFFF	#1E88E5	t	2	t	2026-01-06 14:55:23.759767+00	2026-01-09 21:16:19.475142+00	BASE_URL/categories/category_plumbing.jpg
7f521992-116b-48a7-8388-4ac8c70db191	electricidad-basica	Electricidad básica	Problemas eléctricos comunes del hogar como tomas, interruptores y breakers.	bolt	#FFFFFF	#E53935	t	1	t	2026-01-06 14:55:23.759767+00	2026-01-09 21:16:19.566536+00	BASE_URL/categories/category_electric.jpg
14d38a9a-70b9-4986-8617-55712c3b38bc	nevera	Nevera	Fallas frecuentes de neveras como falta de enfriamiento, ruidos o goteos.	kitchen	#FFFFFF	#3949AB	t	4	t	2026-01-06 14:55:23.759767+00	2026-01-09 21:16:19.657087+00	BASE_URL/categories/category_electro.jpg
ebfc2a30-c3ad-42e1-92bd-12db7d320a1f	lavadora	Lavadora	Problemas comunes de lavadoras domésticas como ruido, vibración o fallas de encendido.	local_laundry_service	#FFFFFF	#43A047	t	3	t	2026-01-09 20:38:26.50974+00	2026-01-09 21:16:19.749768+00	\N
ddb961b3-1f08-499a-b59d-0c95c36aeb9b	internet	Internet	Wi‑Fi, router, señal y conectividad.	wifi	#388E3C	#E8F5E9	t	4	t	2026-01-06 14:55:23.759767+00	2026-01-10 12:14:11.145841+00	BASE_URL/categories/category_internet.jpg
fb805aa7-4c3d-4344-892e-8a9871344a75	otro	Otro	Problemas no clasificados en las categorías principales.	help	#546E7A	#ECEFF1	t	99	t	2026-01-06 15:01:48.798329+00	2026-01-10 12:14:11.231079+00	BASE_URL/categories/category_otro.jpg
\.


--
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.devices (id, device_uuid, platform, app_version, city, zone, created_at, last_seen_at) FROM stdin;
1	7aeeaaa0-2ea0-47c8-9da9-e64db16781e8	android	1.0.0	\N	\N	2026-01-05 21:37:21.68963+00	2026-01-05 21:37:21.68963+00
2	8c61bd99-8ab9-4b55-bafd-4c8600ecd6e2	android	1.0.0	\N	\N	2026-01-09 16:56:06.862996+00	2026-01-09 16:56:06.982383+00
4	7b6c27ae-8e75-42cd-93c7-755238cfe659	android	1.0.0	\N	\N	2026-01-09 19:18:54.797374+00	2026-01-09 19:18:54.820474+00
6	972c38a3-213c-40d0-9abe-c8ecde8e3300	android	1.0.0	\N	\N	2026-01-13 22:31:54.00693+00	2026-01-13 22:31:54.00693+00
\.


--
-- Data for Name: guides; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guides (id, slug, title, summary, duration_minutes, difficulty_level, safety_title, safety_text, success_title, success_text, cover_image_url, is_active, version, created_at, updated_at) FROM stdin;
5789d136-3b6a-4cd3-bc08-947a539719cd	toma-no-funciona	Toma corriente no funciona	Guía rápida para identificar si el problema es de la toma, el breaker o un falso contacto.	12	intermedio	⚠️ Seguridad primero	Si hay chispa, olor a quemado o cables expuestos, NO intervengas. Desconecta y llama a un técnico.	✅ Si funcionó	Si la toma vuelve a funcionar sin calentarse, puedes usarla con normalidad. Si vuelve a fallar, contacta técnico.	\N	t	1	2026-01-09 20:58:59.479061+00	2026-01-09 20:58:59.479061+00
cb5fe03d-49a5-4a44-817f-0d318b84cd3e	breaker-se-baja	Breaker se baja constantemente	Pasos para revisar sobrecarga, equipos conectados y señales de corto de manera segura.	15	intermedio	⚠️ Alto riesgo	Si el breaker se baja inmediatamente y hay chispa/olor, es posible corto. No pruebes repetidamente.	✅ Si funcionó	Si el breaker se mantiene arriba sin conectar equipos, el problema podría ser la carga. Reconecta 1 a 1.	\N	t	1	2026-01-09 20:58:59.479061+00	2026-01-09 20:58:59.479061+00
489a46e7-5873-4c46-aa22-c7eef3728b56	fuga-visible	Fuga visible de agua (bajo lavaplatos o baño)	Detén la fuga temporalmente y verifica si es una unión suelta o un empaque deteriorado.	18	basico	⚠️ Seguridad	Cierra la llave de paso antes de manipular conexiones. Seca el área para evitar resbalones.	✅ Si funcionó	Si no hay goteo por 10 minutos y las uniones están secas, el ajuste fue exitoso.	\N	t	1	2026-01-09 20:58:59.479061+00	2026-01-09 20:58:59.479061+00
2f0ea28f-b74c-472c-bd8f-86e6cb9d99a7	llave-gotea	Llave que gotea	Guía para identificar si el goteo es por empaque, aireador o ajuste básico.	14	basico	⚠️ Seguridad	Cierra la llave de paso antes de desarmar. Si no tienes herramienta, no fuerces la pieza.	✅ Si funcionó	Si el goteo desaparece y no hay filtración en la base, quedó solucionado.	\N	t	1	2026-01-09 20:58:59.479061+00	2026-01-09 20:58:59.479061+00
2cadb483-d65c-4e38-817f-1729034efff2	inodoro-no-descarga	Inodoro no descarga	Revisa el flotador, la cadena y el suministro de agua del tanque.	12	basico	⚠️ Seguridad	Si hay rebose o fuga mayor, cierra la llave del inodoro y usa balde para controlar el agua.	✅ Si funcionó	Si el tanque llena y descarga normalmente 2–3 veces seguidas, puedes darlo por resuelto.	\N	t	1	2026-01-09 20:58:59.479061+00	2026-01-09 20:58:59.479061+00
1feef65e-399c-4acc-b9da-d6a96573556e	nevera-no-enfria	Nevera no enfría (básico)	Diagnóstico inicial: temperatura, ventilación, hielo excesivo y sellos.	16	intermedio	⚠️ Seguridad	Desconecta la nevera antes de limpiar o mover. Si escuchas chispas o hay olor a quemado, llama técnico.	✅ Si funcionó	Si en 4–6 horas mejora el enfriamiento y no hay escarcha excesiva, el ajuste ayudó.	\N	t	1	2026-01-09 20:58:59.479061+00	2026-01-09 20:58:59.479061+00
0ed34b0f-4fe8-4bd0-9482-f3c1efff3d58	lavadora-no-desagua	Lavadora no desagua	Revisa manguera, filtro y drenaje para resolver el problema sin desmontajes complejos.	20	intermedio	⚠️ Seguridad	Desconecta la lavadora antes de revisar drenajes. Mantén el área seca para evitar caídas.	✅ Si funcionó	Si completa un ciclo corto y expulsa el agua sin dificultad, la falla fue resuelta.	\N	t	1	2026-01-09 20:58:59.479061+00	2026-01-09 20:58:59.479061+00
0f7ef71f-7351-425b-a8d4-19b78300e92b	ventilador-no-gira	Ventilador no gira / gira lento	Limpieza y revisión básica de aspas, eje y conexión eléctrica.	10	basico	⚠️ Seguridad	Desconecta el ventilador antes de abrir la rejilla. No uses líquidos en el motor.	✅ Si funcionó	Si gira a velocidad normal y sin ruidos extraños por 2 minutos, quedó correcto.	\N	t	1	2026-01-09 20:58:59.479061+00	2026-01-09 20:58:59.479061+00
8cc7ed5c-8a3b-4409-8b41-71e6ff38cd64	puerta-no-cierra	Puerta no cierra / roza	Ajusta tornillos y revisa bisagras para corregir desalineación leve.	15	basico	⚠️ Seguridad	Si la puerta es pesada, pide ayuda para sostenerla. Evita apretar tornillos con fuerza excesiva.	✅ Si funcionó	Si la puerta cierra sin roce 3 veces seguidas, el ajuste funcionó.	\N	t	1	2026-01-09 20:58:59.479061+00	2026-01-09 20:58:59.479061+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, full_name, phone, city, zone, created_at, updated_at, password_hash) FROM stdin;
1	Carlos Ruiz	3001112233	Bogota	Chapinero	2025-12-31 12:07:28+00	2025-12-31 12:07:28+00	$2b$10$hash_simulado_carlos
2	Ana Gomez	3002223344	Bogota	Suba	2025-12-31 12:07:28+00	2025-12-31 12:07:28+00	$2b$10$hash_simulado_ana
3	Juan Perez	3003334455	Medellin	Laureles	2025-12-31 12:07:28+00	2025-12-31 12:07:28+00	$2b$10$hash_simulado_juan
\.


--
-- Data for Name: diagnostics; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.diagnostics (id, user_id, input_text, image_url, possible_cause, risk_level, created_at, device_id, confidence, model_version, resolution_action, feedback_useful, feedback_comment, category_id, guide_id) FROM stdin;
1	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/ae1049ff-61b6-4332-87bc-13795cfac5f5.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-13 13:51:27.052637+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	5789d136-3b6a-4cd3-bc08-947a539719cd
2	1	chispas	file:///data/user/0/host.exp.exponent/cache/ImagePicker/ae1049ff-61b6-4332-87bc-13795cfac5f5.jpeg	Posible cortocircuito o cable expuesto.	alto	2026-01-13 13:51:36.915028+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	\N
3	1	prueba de oto	file:///data/user/0/host.exp.exponent/cache/ImagePicker/ae1049ff-61b6-4332-87bc-13795cfac5f5.jpeg	Diagnostico preliminar para categoria: general	medio	2026-01-13 13:52:00.688626+00	\N	\N	\N	\N	\N	\N	fb805aa7-4c3d-4344-892e-8a9871344a75	\N
4	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/90554100-9bca-4dd5-bd48-9b5f34950974.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-13 13:56:16.241933+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	\N
5	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/90554100-9bca-4dd5-bd48-9b5f34950974.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-13 13:57:07.259804+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	\N
6	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/5879fe6a-444a-40b5-b3f8-f4438de5b3ca.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-13 13:59:37.38332+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	5789d136-3b6a-4cd3-bc08-947a539719cd
7	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/46a04072-8b0f-4640-a223-a01dc3b0b4eb.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-13 15:08:10.72827+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	\N
8	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/46a04072-8b0f-4640-a223-a01dc3b0b4eb.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-13 15:10:48.344098+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	\N
9	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/36fc0dd6-dc50-465d-ac3e-9d901ff3d75e.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-13 15:11:20.483718+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	\N
10	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/36fc0dd6-dc50-465d-ac3e-9d901ff3d75e.jpeg	Diagnostico preliminar para categoria: plomeria	medio	2026-01-13 15:12:04.80103+00	\N	\N	\N	\N	\N	\N	f742ded4-049b-4359-923e-c82f4dc697d7	\N
11	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/aaac1e01-73b4-4119-ab65-f763acb1cdf0.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-13 15:12:40.16962+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	\N
12	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/0ba66c13-3f3f-4692-b137-3b03606237a7.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-13 15:15:37.58129+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	\N
13	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/0ba66c13-3f3f-4692-b137-3b03606237a7.jpeg	Diagnostico preliminar para categoria: plomeria	medio	2026-01-13 15:17:15.450847+00	\N	\N	\N	\N	\N	\N	f742ded4-049b-4359-923e-c82f4dc697d7	\N
14	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/9cc14592-fd7d-4f3f-9586-b3d27a28f79a.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-13 16:19:49.941092+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	\N
15	1	\N	file:///data/user/0/host.exp.exponent/cache/ImagePicker/74e3f863-d8b7-4bf6-bd69-5799b086fb7b.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-13 16:24:47.587066+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	5789d136-3b6a-4cd3-bc08-947a539719cd
16	1	\N	file:///data/user/0/com.jcpazmino44.quelepasomobile/cache/ImagePicker/decc9bd9-75c6-438c-bade-0eb3e1b0735f.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-13 22:39:17.70463+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	5789d136-3b6a-4cd3-bc08-947a539719cd
17	1	\N	file:///data/user/0/com.jcpazmino44.quelepasomobile/cache/ImagePicker/1a1a7ddc-0d07-4900-a9f0-52c31dc6e79f.jpeg	Diagnostico preliminar para categoria: plomeria	medio	2026-01-13 22:41:17.668071+00	\N	\N	\N	\N	\N	\N	f742ded4-049b-4359-923e-c82f4dc697d7	489a46e7-5873-4c46-aa22-c7eef3728b56
18	1	\N	file:///data/user/0/com.jcpazmino44.quelepasomobile/cache/ImagePicker/bd64c929-14db-46c0-a449-3ee3297f6a4f.jpeg	Diagnostico preliminar para categoria: plomeria	medio	2026-01-13 22:48:24.160087+00	\N	\N	\N	\N	\N	\N	f742ded4-049b-4359-923e-c82f4dc697d7	489a46e7-5873-4c46-aa22-c7eef3728b56
19	1	\N	file:///data/user/0/com.jcpazmino44.quelepasomobile/cache/ImagePicker/8862f5e7-cbe2-427c-809e-7acee656da6d.jpeg	Diagnostico preliminar para categoria: plomeria	medio	2026-01-13 22:59:10.620732+00	\N	\N	\N	\N	\N	\N	d8f79f83-7ce2-468f-a777-95ac4dc71f0c	2cadb483-d65c-4e38-817f-1729034efff2
20	1	\N	file:///data/user/0/com.jcpazmino44.quelepasomobile/cache/ImagePicker/cf0389c6-1385-4525-9d82-b8d7294754aa.jpeg	Diagnostico preliminar para categoria: plomeria	medio	2026-01-13 23:14:41.713513+00	\N	\N	\N	\N	\N	\N	f742ded4-049b-4359-923e-c82f4dc697d7	489a46e7-5873-4c46-aa22-c7eef3728b56
21	1	\N	file:///data/user/0/com.jcpazmino44.quelepasomobile/cache/ImagePicker/1bd49bfe-e665-499d-a676-7d86c4cc2886.jpeg	Diagnostico preliminar para categoria: electricidad	medio	2026-01-14 16:13:16.916273+00	\N	\N	\N	\N	\N	\N	7f521992-116b-48a7-8388-4ac8c70db191	cb5fe03d-49a5-4a44-817f-0d318b84cd3e
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.events (id, device_id, user_id, diagnostic_id, event_name, screen_name, event_value, meta_json, created_at) FROM stdin;
1	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "nevera", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:08:18.275407+00
2	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "nevera", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:08:23.55989+00
3	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "nevera", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:08:24.331186+00
4	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "nevera", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:08:25.208713+00
5	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:18:05.723396+00
6	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:18:07.74935+00
7	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:18:08.777639+00
8	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:18:11.346646+00
9	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:18:12.898637+00
10	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:18:53.895862+00
11	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:21:03.463885+00
12	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:21:07.716317+00
13	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:21:09.496805+00
14	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:21:14.763238+00
15	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:21:17.659643+00
16	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:21:19.38765+00
17	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:21:44.80283+00
18	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:22:04.08007+00
19	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:22:08.033821+00
20	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:22:09.984093+00
21	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:22:16.515043+00
22	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "lavadora", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:22:38.830025+00
23	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "lavadora", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:22:41.06065+00
24	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "lavadora", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:22:42.123449+00
25	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:23:09.670421+00
26	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:24:29.479719+00
27	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:24:36.77462+00
28	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:24:41.746657+00
29	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:24:44.312672+00
30	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:24:50.037635+00
31	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "ventilador", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:24:55.05598+00
32	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "ventilador", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:24:56.833117+00
33	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "ventilador", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:24:57.634917+00
34	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:25:03.804453+00
35	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:25:23.557673+00
36	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:26:14.260736+00
37	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:26:14.420063+00
38	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:26:33.357772+00
39	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:26:36.034757+00
40	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "ventilador", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:26:41.25673+00
41	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "ventilador", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:26:43.151625+00
42	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "ventilador", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:26:43.815336+00
43	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "nevera", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:26:45.807538+00
44	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "nevera", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:26:49.668164+00
45	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "nevera", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-10 12:26:50.822124+00
46	1	\N	\N	history_viewed	Historial	\N	{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:20:15.104623+00
47	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:51:43.563067+00
48	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:51:57.374373+00
49	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:51:57.535499+00
50	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:52:14.064208+00
51	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:52:14.466322+00
52	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:52:16.344245+00
53	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:53:45.061766+00
54	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:54:07.97331+00
55	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:54:08.449739+00
56	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:54:16.053067+00
57	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "internet", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:54:21.516011+00
58	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "lavadora", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:54:27.814648+00
59	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:54:51.432073+00
60	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:56:12.784039+00
61	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "nevera", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:56:41.337249+00
62	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "puertas-cerraduras", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:56:43.935135+00
63	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:56:47.83222+00
64	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:56:50.29792+00
65	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:56:51.379116+00
66	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:57:01.014708+00
67	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:57:05.793018+00
68	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:57:07.850519+00
69	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:57:28.517442+00
70	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:57:28.855458+00
71	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:58:14.532511+00
72	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:58:14.703779+00
73	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:58:26.039947+00
74	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:59:36.882507+00
75	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 12:59:47.458773+00
76	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:00:00.092792+00
77	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:00:01.724204+00
78	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:00:24.889072+00
79	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:00:38.433425+00
80	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:00:42.096702+00
81	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:01:22.416804+00
82	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:06:51.844769+00
83	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:06:57.319296+00
84	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:08:33.779911+00
85	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:26:13.139363+00
86	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:26:15.322743+00
87	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:26:18.606614+00
88	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:26:56.09276+00
89	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:27:04.357024+00
90	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:28:11.057643+00
91	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:28:14.373922+00
92	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:29:45.257244+00
93	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:29:46.900003+00
94	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:35:15.568828+00
95	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:35:17.742183+00
96	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:51:09.423825+00
97	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:51:26.877364+00
98	1	\N	1	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:51:27.210467+00
99	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:51:36.730754+00
100	1	\N	2	diagnostic_completed	Diagnostico	alto	{"category": "electricidad-basica", "risk_level": "alto", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:51:37.066702+00
101	1	\N	\N	diagnostic_started	Captura	otro	{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:52:00.509349+00
102	1	\N	3	diagnostic_completed	Diagnostico	medio	{"category": "otro", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:52:00.861736+00
103	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:56:11.367752+00
104	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:56:16.048936+00
105	1	\N	4	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:56:16.403787+00
106	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:57:07.090127+00
107	1	\N	5	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:57:07.432974+00
108	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:59:29.591337+00
109	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:59:37.184575+00
110	1	\N	6	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 13:59:37.555273+00
111	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:08:09.59689+00
112	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:08:10.505052+00
113	1	\N	7	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:08:10.894289+00
114	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:10:48.169774+00
115	1	\N	8	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:10:48.510874+00
116	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:11:18.300284+00
117	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:11:20.309285+00
118	1	\N	9	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:11:20.634816+00
119	1	\N	\N	diagnostic_started	Captura	fontaneria-simple	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:12:04.617231+00
120	1	\N	10	diagnostic_completed	Diagnostico	medio	{"category": "fontaneria-simple", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:12:04.950445+00
121	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:12:38.6577+00
122	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:12:39.926224+00
123	1	\N	11	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:12:40.33084+00
124	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:15:36.010654+00
125	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:15:37.376545+00
126	1	\N	12	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:15:37.74171+00
127	1	\N	\N	diagnostic_started	Captura	fontaneria-simple	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:17:15.2557+00
128	1	\N	13	diagnostic_completed	Diagnostico	medio	{"category": "fontaneria-simple", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:17:15.627727+00
129	1	\N	13	guide_step_viewed	Guia	1	{"source": "diagnostico", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:17:32.457793+00
130	1	\N	\N	guide_opened	Diagnostico	fontaneria-simple	{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:17:32.464395+00
131	1	\N	13	guide_opened	Guia	\N	{"source": "diagnostico", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 15:17:32.840736+00
132	1	\N	13	guide_opened	Guia	\N	{"source": "diagnostico", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:13:27.575933+00
133	1	\N	\N	guide_opened	Diagnostico	fontaneria-simple	{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:13:27.763017+00
134	1	\N	13	guide_step_viewed	Guia	1	{"source": "diagnostico", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:13:27.958197+00
135	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:19:34.688781+00
136	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:19:49.738936+00
137	1	\N	14	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:19:50.105681+00
138	1	\N	14	guide_step_viewed	Guia	1	{"source": "diagnostico", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:20:14.656822+00
139	1	\N	\N	guide_opened	Diagnostico	electricidad-basica	{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:20:14.706562+00
140	1	\N	14	guide_opened	Guia	\N	{"source": "diagnostico", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:20:14.770052+00
141	1	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:24:38.456997+00
142	1	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:24:47.382834+00
143	1	\N	15	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:24:47.741843+00
144	1	\N	\N	guide_opened	Diagnostico	electricidad-basica	{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:25:02.557391+00
145	1	\N	15	guide_opened	Guia	toma-no-funciona	{"source": "diagnostico", "guide_slug": "toma-no-funciona", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:25:02.578408+00
146	1	\N	15	guide_step_viewed	Guia	toma-no-funciona	{"source": "diagnostico", "guide_slug": "toma-no-funciona", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:25:02.699888+00
147	1	\N	15	guide_step_viewed	Guia	toma-no-funciona	{"source": "diagnostico", "guide_slug": "toma-no-funciona", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:26:48.573625+00
148	1	\N	15	guide_opened	Guia	toma-no-funciona	{"source": "diagnostico", "guide_slug": "toma-no-funciona", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:26:48.601316+00
149	1	\N	\N	history_viewed	Historial	\N	{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:28:09.886644+00
150	1	\N	\N	history_viewed	Historial	\N	{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:29:00.993714+00
151	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:36:20.977282+00
152	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:36:24.580661+00
153	1	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "otro", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:36:27.119874+00
154	1	\N	\N	history_viewed	Historial	\N	{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:39:03.867081+00
155	1	\N	\N	history_viewed	Historial	\N	{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}	2026-01-13 16:52:50.507698+00
156	6	\N	\N	session_started	Inicio	\N	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:31:54.225548+00
157	6	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:39:13.465142+00
158	6	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "hasImage": true, "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:39:17.46815+00
159	6	\N	16	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:39:17.930832+00
160	6	\N	\N	guide_opened	Diagnostico	electricidad-basica	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:39:22.12767+00
161	6	\N	16	guide_opened	Guia	toma-no-funciona	{"source": "diagnostico", "guide_slug": "toma-no-funciona", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:39:22.155658+00
162	6	\N	16	guide_step_viewed	Guia	toma-no-funciona	{"source": "diagnostico", "guide_slug": "toma-no-funciona", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:39:22.163385+00
163	6	\N	16	guide_completed	Guia	toma-no-funciona	{"source": "diagnostico", "guide_slug": "toma-no-funciona", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:05.388751+00
164	6	\N	\N	history_viewed	Historial	\N	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:05.635073+00
165	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "electricidad-basica", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:20.945128+00
166	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "lavadora", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:22.838128+00
167	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "lavadora", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:25.226995+00
168	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "lavadora", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:25.941171+00
169	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "lavadora", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:26.759574+00
170	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "otro", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:28.032983+00
171	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "otro", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:30.26678+00
172	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "otro", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:32.511833+00
173	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "lavadora", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:41.941149+00
174	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "lavadora", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:43.511973+00
175	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "lavadora", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:44.535218+00
176	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "nevera", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:51.840796+00
177	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "nevera", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:53.359635+00
178	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "nevera", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:54.226657+00
179	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "category": "internet", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:40:57.608558+00
180	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "category": "internet", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:41:00.509262+00
181	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "category": "internet", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:41:01.50262+00
182	6	\N	\N	image_uploaded	Captura	camera	{"category": "fontaneria-simple", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:41:13.80046+00
183	6	\N	\N	diagnostic_started	Captura	fontaneria-simple	{"hasText": false, "hasImage": true, "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:41:17.435394+00
184	6	\N	17	diagnostic_completed	Diagnostico	medio	{"category": "fontaneria-simple", "risk_level": "medio", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:41:17.864136+00
185	6	\N	\N	guide_opened	Diagnostico	fontaneria-simple	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:41:27.217942+00
186	6	\N	17	guide_opened	Guia	fuga-visible	{"source": "diagnostico", "guide_slug": "fuga-visible", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:41:27.225693+00
187	6	\N	17	guide_step_viewed	Guia	fuga-visible	{"source": "diagnostico", "guide_slug": "fuga-visible", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:41:27.764732+00
188	6	\N	17	guide_completed	Guia	fuga-visible	{"source": "diagnostico", "guide_slug": "fuga-visible", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:41:35.135493+00
189	6	\N	\N	history_viewed	Historial	\N	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:41:35.560647+00
190	6	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:48:16.209886+00
191	6	\N	\N	diagnostic_started	Captura	fontaneria-simple	{"hasText": false, "hasImage": true, "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:48:23.878771+00
192	6	\N	18	diagnostic_completed	Diagnostico	medio	{"category": "fontaneria-simple", "risk_level": "medio", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:48:24.357659+00
193	6	\N	\N	guide_opened	Diagnostico	fontaneria-simple	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:48:31.25027+00
194	6	\N	18	guide_step_viewed	Guia	fuga-visible	{"source": "diagnostico", "guide_slug": "fuga-visible", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:48:31.326086+00
195	6	\N	18	guide_opened	Guia	fuga-visible	{"source": "diagnostico", "guide_slug": "fuga-visible", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:48:31.333477+00
196	6	\N	18	guide_completed	Guia	fuga-visible	{"source": "diagnostico", "guide_slug": "fuga-visible", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:48:46.516504+00
197	6	\N	\N	history_viewed	Historial	\N	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:48:46.693072+00
198	6	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:03.212259+00
199	6	\N	\N	diagnostic_started	Captura	griferia-sanitarios	{"hasText": false, "category": "griferia-sanitarios", "hasImage": true, "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:10.348933+00
200	6	\N	19	diagnostic_completed	Diagnostico	medio	{"category": "griferia-sanitarios", "risk_level": "medio", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:10.835801+00
201	6	\N	19	guide_opened	Diagnostico	inodoro-no-descarga	{"source": "diagnostico", "category": "griferia-sanitarios", "guide_slug": "inodoro-no-descarga", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:19.317565+00
202	6	\N	19	guide_step_viewed	Guia	inodoro-no-descarga	{"source": "diagnostico", "category": "griferia-sanitarios", "guide_slug": "inodoro-no-descarga", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:19.344892+00
203	6	\N	19	guide_opened	Guia	inodoro-no-descarga	{"source": "diagnostico", "category": "griferia-sanitarios", "guide_slug": "inodoro-no-descarga", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:19.402765+00
204	6	\N	19	guide_completed	Guia	inodoro-no-descarga	{"source": "diagnostico", "category": "griferia-sanitarios", "guide_slug": "inodoro-no-descarga", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:25.442753+00
205	6	\N	\N	history_viewed	Historial	\N	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:25.934765+00
206	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "source": "inicio", "category": "griferia-sanitarios", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:35.445645+00
207	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "source": "inicio", "category": "griferia-sanitarios", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:37.063624+00
208	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "source": "inicio", "category": "griferia-sanitarios", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:38.165355+00
209	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "source": "inicio", "category": "otro", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:40.115323+00
210	6	\N	\N	technician_contact_clicked	Contacto	whatsapp	{"city": "Medellin", "phone": "3105554444", "source": "inicio", "category": "otro", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 22:59:47.297689+00
211	6	\N	\N	history_viewed	Historial	\N	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:00:01.739877+00
212	6	\N	\N	history_viewed	Historial	\N	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:06:23.649395+00
213	6	\N	\N	history_viewed	Historial	\N	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:13:02.990099+00
214	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "source": "inicio", "category": "electricidad-basica", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:14:18.371657+00
215	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "source": "inicio", "category": "electricidad-basica", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:14:21.304841+00
216	6	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:14:36.392401+00
217	6	\N	\N	diagnostic_started	Captura	fontaneria-simple	{"hasText": false, "category": "fontaneria-simple", "hasImage": true, "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:14:41.478181+00
218	6	\N	20	diagnostic_completed	Diagnostico	medio	{"category": "fontaneria-simple", "risk_level": "medio", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:14:41.920966+00
219	6	\N	20	guide_opened	Diagnostico	fuga-visible	{"source": "diagnostico", "category": "fontaneria-simple", "guide_slug": "fuga-visible", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:14:46.794677+00
220	6	\N	20	guide_opened	Guia	fuga-visible	{"source": "diagnostico", "category": "fontaneria-simple", "guide_slug": "fuga-visible", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:14:47.283778+00
221	6	\N	20	guide_step_viewed	Guia	fuga-visible	{"source": "diagnostico", "category": "fontaneria-simple", "guide_slug": "fuga-visible", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:14:47.295642+00
222	6	\N	20	guide_completed	Guia	fuga-visible	{"source": "diagnostico", "category": "fontaneria-simple", "guide_slug": "fuga-visible", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:14:51.28569+00
223	6	\N	\N	history_viewed	Historial	\N	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:14:51.841141+00
224	6	\N	\N	history_viewed	Historial	\N	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-13 23:14:59.698822+00
225	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "source": "inicio", "category": "otro", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 15:31:43.81376+00
226	6	\N	\N	technician_contact_clicked	Contacto	whatsapp	{"city": "Bogota", "phone": "3105551111", "source": "inicio", "category": "otro", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 15:31:55.316095+00
227	6	\N	\N	image_uploaded	Captura	camera	{"category": "electricidad-basica", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:09.828703+00
228	6	\N	\N	diagnostic_started	Captura	electricidad-basica	{"hasText": false, "category": "electricidad-basica", "hasImage": true, "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:16.698452+00
229	6	\N	21	diagnostic_completed	Diagnostico	medio	{"category": "electricidad-basica", "risk_level": "medio", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:17.111102+00
230	6	\N	21	guide_opened	Guia	breaker-se-baja	{"source": "diagnostico", "category": "electricidad-basica", "guide_slug": "breaker-se-baja", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:21.348206+00
231	6	\N	21	guide_opened	Diagnostico	breaker-se-baja	{"source": "diagnostico", "category": "electricidad-basica", "guide_slug": "breaker-se-baja", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:21.375434+00
232	6	\N	21	guide_step_viewed	Guia	breaker-se-baja	{"source": "diagnostico", "category": "electricidad-basica", "guide_slug": "breaker-se-baja", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:21.38516+00
233	6	\N	21	guide_completed	Guia	breaker-se-baja	{"source": "diagnostico", "category": "electricidad-basica", "guide_slug": "breaker-se-baja", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:29.90826+00
234	6	\N	\N	history_viewed	Historial	\N	{"session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:30.384313+00
235	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "source": "inicio", "category": "fontaneria-simple", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:45.410123+00
236	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "source": "inicio", "category": "ventilador", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:47.178958+00
237	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "source": "inicio", "category": "ventilador", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:49.033725+00
238	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "source": "inicio", "category": "ventilador", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:49.931568+00
239	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Medellin", "source": "inicio", "category": "otro", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:51.535548+00
240	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Cali", "source": "inicio", "category": "otro", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:53.360111+00
241	6	\N	\N	technicians_list_viewed	Contacto	\N	{"city": "Bogota", "source": "inicio", "category": "otro", "session_id": "6663ba6d-1db5-462c-95ca-c1330b6d0cde"}	2026-01-14 16:13:54.822779+00
\.


--
-- Data for Name: guide_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guide_categories (guide_id, category_id, created_at) FROM stdin;
5789d136-3b6a-4cd3-bc08-947a539719cd	7f521992-116b-48a7-8388-4ac8c70db191	2026-01-09 21:02:16.59575+00
cb5fe03d-49a5-4a44-817f-0d318b84cd3e	7f521992-116b-48a7-8388-4ac8c70db191	2026-01-09 21:02:16.59575+00
489a46e7-5873-4c46-aa22-c7eef3728b56	f742ded4-049b-4359-923e-c82f4dc697d7	2026-01-09 21:02:16.59575+00
2f0ea28f-b74c-472c-bd8f-86e6cb9d99a7	d8f79f83-7ce2-468f-a777-95ac4dc71f0c	2026-01-09 21:02:16.59575+00
2cadb483-d65c-4e38-817f-1729034efff2	d8f79f83-7ce2-468f-a777-95ac4dc71f0c	2026-01-09 21:02:16.59575+00
1feef65e-399c-4acc-b9da-d6a96573556e	14d38a9a-70b9-4986-8617-55712c3b38bc	2026-01-09 21:02:16.59575+00
0ed34b0f-4fe8-4bd0-9482-f3c1efff3d58	ebfc2a30-c3ad-42e1-92bd-12db7d320a1f	2026-01-09 21:02:16.59575+00
0f7ef71f-7351-425b-a8d4-19b78300e92b	5057f686-9faf-48ae-ba89-414e27799769	2026-01-09 21:02:16.59575+00
8cc7ed5c-8a3b-4409-8b41-71e6ff38cd64	ef2031f2-1016-4bde-8573-6fe70ab77363	2026-01-09 21:02:16.59575+00
\.


--
-- Data for Name: guide_steps; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guide_steps (id, guide_id, step_number, title, body, image_url, estimated_minutes, created_at, updated_at) FROM stdin;
3fdd0ec7-849f-4014-83c6-d0b0876dc656	5789d136-3b6a-4cd3-bc08-947a539719cd	1	Apaga y desconecta	Desconecta cualquier equipo de la toma. Si el área está húmeda, sécala antes de tocar.	\N	2	2026-01-09 21:04:43.814764+00	2026-01-09 21:04:43.814764+00
ea533fd9-d644-4a1b-9b0a-593bdc7b71f3	5789d136-3b6a-4cd3-bc08-947a539719cd	2	Revisa el breaker	Mira si algún breaker está abajo. Si está abajo, súbelo una sola vez.	\N	3	2026-01-09 21:04:43.814764+00	2026-01-09 21:04:43.814764+00
a0e011dd-6a20-472d-92ee-4f37a0a213a2	5789d136-3b6a-4cd3-bc08-947a539719cd	3	Prueba otra toma	Conecta el mismo equipo en otra toma para validar si el problema es la toma o el equipo.	\N	3	2026-01-09 21:04:43.814764+00	2026-01-09 21:04:43.814764+00
82c8783c-99d3-4a37-b536-15e6fb8bff95	5789d136-3b6a-4cd3-bc08-947a539719cd	4	Señales de riesgo	Si hay chispa, olor a quemado o la toma está caliente: NO uses esa toma. Contacta técnico.	\N	2	2026-01-09 21:04:43.814764+00	2026-01-09 21:04:43.814764+00
10fb4e50-12db-4ae4-bd30-4f743774fdb5	5789d136-3b6a-4cd3-bc08-947a539719cd	5	Decisión	Si no hay riesgo y vuelve a fallar, contacta técnico. Si queda estable, úsala con precaución.	\N	2	2026-01-09 21:04:43.814764+00	2026-01-09 21:04:43.814764+00
bfc3abb9-ed7b-47cf-97d4-e6c8c7c36d28	cb5fe03d-49a5-4a44-817f-0d318b84cd3e	1	Desconecta todo	Desconecta equipos de alto consumo (planchas, microondas, calentadores).	\N	3	2026-01-09 21:08:34.24464+00	2026-01-09 21:08:34.24464+00
ab16d521-0270-4445-81d4-24cd9f1a7a12	cb5fe03d-49a5-4a44-817f-0d318b84cd3e	2	Sube el breaker	Súbelo una sola vez. Si se baja de inmediato, hay riesgo de corto.	\N	3	2026-01-09 21:08:34.24464+00	2026-01-09 21:08:34.24464+00
8fc7b468-fe49-40dc-851b-ca2444cc3bb6	cb5fe03d-49a5-4a44-817f-0d318b84cd3e	3	Reconecta uno a uno	Conecta un equipo a la vez para identificar el causante.	\N	5	2026-01-09 21:08:34.24464+00	2026-01-09 21:08:34.24464+00
02e3480e-71eb-4a38-8649-bc0cb6d94044	cb5fe03d-49a5-4a44-817f-0d318b84cd3e	4	No insistas	No subas repetidamente el breaker.	\N	2	2026-01-09 21:08:34.24464+00	2026-01-09 21:08:34.24464+00
077a7c9b-16b9-403d-89b6-d63422750391	cb5fe03d-49a5-4a44-817f-0d318b84cd3e	5	Decisión	Si no identificas la causa, contacta técnico.	\N	2	2026-01-09 21:08:34.24464+00	2026-01-09 21:08:34.24464+00
380eeaf5-e407-4528-846a-d8460f90d9d6	489a46e7-5873-4c46-aa22-c7eef3728b56	1	Cierra el agua	Cierra la llave de paso local o general.	\N	3	2026-01-09 21:09:00.313933+00	2026-01-09 21:09:00.313933+00
f49c8996-a100-438d-b068-0f95005293bb	489a46e7-5873-4c46-aa22-c7eef3728b56	2	Seca y ubica	Seca la zona y ubica exactamente la fuga.	\N	4	2026-01-09 21:09:00.313933+00	2026-01-09 21:09:00.313933+00
1b3fa670-0e51-4df5-ba4f-5396043ad7b0	489a46e7-5873-4c46-aa22-c7eef3728b56	3	Ajusta unión	Ajusta suavemente la unión o usa cinta teflón.	\N	6	2026-01-09 21:09:00.313933+00	2026-01-09 21:09:00.313933+00
d5121beb-c030-4419-a6a7-fb220f9d747f	489a46e7-5873-4c46-aa22-c7eef3728b56	4	Prueba	Abre el paso y observa si continúa el goteo.	\N	3	2026-01-09 21:09:00.313933+00	2026-01-09 21:09:00.313933+00
aefd6a66-3029-4839-a830-e38c00efd930	489a46e7-5873-4c46-aa22-c7eef3728b56	5	Decisión	Si persiste, contacta técnico.	\N	2	2026-01-09 21:09:00.313933+00	2026-01-09 21:09:00.313933+00
27c13785-91af-4622-9617-0c2a5686f4a4	2f0ea28f-b74c-472c-bd8f-86e6cb9d99a7	1	Cierra el paso	Cierra la llave inferior.	\N	2	2026-01-09 21:09:18.754238+00	2026-01-09 21:09:18.754238+00
ec8d6dcb-e78a-4123-b2d5-68ae14abaa3d	2f0ea28f-b74c-472c-bd8f-86e6cb9d99a7	2	Identifica el goteo	Revisa si sale por la base o la boquilla.	\N	3	2026-01-09 21:09:18.754238+00	2026-01-09 21:09:18.754238+00
ac2d88f1-7ba0-4612-afe4-e7da28de93f1	2f0ea28f-b74c-472c-bd8f-86e6cb9d99a7	3	Limpia aireador	Limpia la boquilla con cepillo.	\N	4	2026-01-09 21:09:18.754238+00	2026-01-09 21:09:18.754238+00
45e47ed1-f326-4730-9381-9d7f8965f273	2f0ea28f-b74c-472c-bd8f-86e6cb9d99a7	4	Evalúa empaque	Si es por la base, puede requerir empaque.	\N	3	2026-01-09 21:09:18.754238+00	2026-01-09 21:09:18.754238+00
edce456c-f1d2-4e88-8a14-16791a5234c8	2f0ea28f-b74c-472c-bd8f-86e6cb9d99a7	5	Decisión	Si persiste, técnico o repuesto.	\N	2	2026-01-09 21:09:18.754238+00	2026-01-09 21:09:18.754238+00
9090a25e-cb15-42f2-baf1-69523c40ae37	2cadb483-d65c-4e38-817f-1729034efff2	1	Revisa tanque	Levanta la tapa y verifica nivel de agua.	\N	3	2026-01-09 21:09:40.386469+00	2026-01-09 21:09:40.386469+00
5a01c7e6-467a-41ff-8c4a-9c21a040da3b	2cadb483-d65c-4e38-817f-1729034efff2	2	Cadena y flotador	Asegura cadena y flotador libres.	\N	4	2026-01-09 21:09:40.386469+00	2026-01-09 21:09:40.386469+00
4ddd16c6-111b-4fc5-9a02-d39842b33b32	2cadb483-d65c-4e38-817f-1729034efff2	3	Prueba descarga	Observa apertura y cierre.	\N	2	2026-01-09 21:09:40.386469+00	2026-01-09 21:09:40.386469+00
29623f7f-622a-4ad6-9ee6-224683c5d5d8	2cadb483-d65c-4e38-817f-1729034efff2	4	Ajuste básico	Ajusta cadena o flotador.	\N	2	2026-01-09 21:09:40.386469+00	2026-01-09 21:09:40.386469+00
dcf68fe1-a66c-4f1f-837b-45439a1a2a02	2cadb483-d65c-4e38-817f-1729034efff2	5	Decisión	Si no funciona, técnico.	\N	1	2026-01-09 21:09:40.386469+00	2026-01-09 21:09:40.386469+00
7c036402-a73b-4bc2-b231-e3a5cb1182f3	1feef65e-399c-4acc-b9da-d6a96573556e	1	Revisa temperatura	Ajusta a nivel medio.	\N	2	2026-01-09 21:09:59.232704+00	2026-01-09 21:09:59.232704+00
752939e1-78c4-463e-844f-4849a6d64857	1feef65e-399c-4acc-b9da-d6a96573556e	2	Ventilación	Deja espacio detrás.	\N	3	2026-01-09 21:09:59.232704+00	2026-01-09 21:09:59.232704+00
08d7ace6-7528-4244-afa1-8e122217d831	1feef65e-399c-4acc-b9da-d6a96573556e	3	Limpia rejilla	Limpia polvo con cepillo.	\N	6	2026-01-09 21:09:59.232704+00	2026-01-09 21:09:59.232704+00
821491fd-6e26-4f6d-a0a6-66c7f783111f	1feef65e-399c-4acc-b9da-d6a96573556e	4	Revisa sellos	Limpia sellos de la puerta.	\N	3	2026-01-09 21:09:59.232704+00	2026-01-09 21:09:59.232704+00
633ac72c-cce5-4b6d-a373-0c3f10bc211e	1feef65e-399c-4acc-b9da-d6a96573556e	5	Decisión	Si no mejora, técnico.	\N	2	2026-01-09 21:09:59.232704+00	2026-01-09 21:09:59.232704+00
9d6a4ac0-a3f3-4aa2-bcd6-073515741fc1	0ed34b0f-4fe8-4bd0-9482-f3c1efff3d58	1	Desconecta	Desconecta y prepara balde.	\N	3	2026-01-09 21:10:22.48641+00	2026-01-09 21:10:22.48641+00
c6059067-1d88-4ff6-b557-1115a46b611e	0ed34b0f-4fe8-4bd0-9482-f3c1efff3d58	2	Revisa manguera	Endereza o destapa.	\N	5	2026-01-09 21:10:22.48641+00	2026-01-09 21:10:22.48641+00
f9c5aa96-ee03-4fbd-9736-bfc767d50f8e	0ed34b0f-4fe8-4bd0-9482-f3c1efff3d58	3	Limpia filtro	Retira residuos.	\N	7	2026-01-09 21:10:22.48641+00	2026-01-09 21:10:22.48641+00
f18dd7a1-d3cd-47d6-8aa1-011d5f88d1a3	0ed34b0f-4fe8-4bd0-9482-f3c1efff3d58	4	Prueba ciclo	Ejecuta ciclo corto.	\N	4	2026-01-09 21:10:22.48641+00	2026-01-09 21:10:22.48641+00
ea7a6088-a3f2-44e0-8fc9-7335e00dabaf	0ed34b0f-4fe8-4bd0-9482-f3c1efff3d58	5	Decisión	Si falla, técnico.	\N	1	2026-01-09 21:10:22.48641+00	2026-01-09 21:10:22.48641+00
c401f5fc-e61a-4982-9090-1ea0eb706ab4	0f7ef71f-7351-425b-a8d4-19b78300e92b	1	Desconecta	Desconecta antes de abrir.	\N	1	2026-01-09 21:10:50.81777+00	2026-01-09 21:10:50.81777+00
0b6d4b56-b64e-4830-aa93-e592886ca125	0f7ef71f-7351-425b-a8d4-19b78300e92b	2	Limpia	Limpia aspas y rejilla.	\N	4	2026-01-09 21:10:50.81777+00	2026-01-09 21:10:50.81777+00
3b7eb0cf-ac43-412e-bc90-07b24f3fac2a	0f7ef71f-7351-425b-a8d4-19b78300e92b	3	Revisa giro	Gira a mano para ver roces.	\N	3	2026-01-09 21:10:50.81777+00	2026-01-09 21:10:50.81777+00
ecefee70-04cf-435f-9a4c-cece892f24c9	0f7ef71f-7351-425b-a8d4-19b78300e92b	4	Decisión	Si huele a quemado, técnico.	\N	2	2026-01-09 21:10:50.81777+00	2026-01-09 21:10:50.81777+00
dcdb8e7b-8bb0-45aa-9dd4-3a19b9eacce1	8cc7ed5c-8a3b-4409-8b41-71e6ff38cd64	1	Identifica roce	Cierra lento y mira dónde roza.	\N	3	2026-01-09 21:11:19.284436+00	2026-01-09 21:11:19.284436+00
46f1ffff-3d27-47a8-98a2-0ce989c3436b	8cc7ed5c-8a3b-4409-8b41-71e6ff38cd64	2	Ajusta bisagras	Aprieta tornillos.	\N	5	2026-01-09 21:11:19.284436+00	2026-01-09 21:11:19.284436+00
101605c5-9e3e-4570-a5b6-dfdfd83100fe	8cc7ed5c-8a3b-4409-8b41-71e6ff38cd64	3	Revisa cerradura	Verifica alineación del pestillo.	\N	5	2026-01-09 21:11:19.284436+00	2026-01-09 21:11:19.284436+00
672487b1-e899-4b2f-a042-d7d4c1b57b5b	8cc7ed5c-8a3b-4409-8b41-71e6ff38cd64	4	Decisión	Si no mejora, carpintero.	\N	2	2026-01-09 21:11:19.284436+00	2026-01-09 21:11:19.284436+00
\.


--
-- Data for Name: tools; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tools (id, slug, name, icon, created_at, updated_at) FROM stdin;
3e98697b-ca26-43d8-9e78-79aff57aa64e	destornillador-estrella	Destornillador de estrella	build	2026-01-07 14:51:28.034991+00	2026-01-07 14:51:28.034991+00
3c4eee30-948f-4f04-b3aa-3dfbeaa2eef6	cinta-teflon	Cinta de teflón	content_cut	2026-01-07 14:51:28.034991+00	2026-01-07 14:51:28.034991+00
947830e8-525f-499c-a93b-ff5e780e6c31	llave-inglesa	Llave de tubos (Inglesa)	build	2026-01-07 14:51:28.034991+00	2026-01-07 14:51:28.034991+00
381da3b9-1f1c-4180-87ab-feab81abf9b5	trapo	Trapo o paño	cleaning_services	2026-01-07 14:51:28.034991+00	2026-01-07 14:51:28.034991+00
554ab62a-8421-4ac9-92b3-9a112b6015a0	balde	Balde o recipiente	local_drink	2026-01-07 14:51:28.034991+00	2026-01-07 14:51:28.034991+00
\.


--
-- Data for Name: guide_tools; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guide_tools (guide_id, tool_id, is_required, order_index, created_at, updated_at) FROM stdin;
0ed34b0f-4fe8-4bd0-9482-f3c1efff3d58	381da3b9-1f1c-4180-87ab-feab81abf9b5	t	2	2026-01-09 21:03:56.132678+00	2026-01-09 21:03:56.132678+00
1feef65e-399c-4acc-b9da-d6a96573556e	381da3b9-1f1c-4180-87ab-feab81abf9b5	t	2	2026-01-09 21:03:56.132678+00	2026-01-09 21:03:56.132678+00
2f0ea28f-b74c-472c-bd8f-86e6cb9d99a7	381da3b9-1f1c-4180-87ab-feab81abf9b5	t	1	2026-01-09 21:03:56.132678+00	2026-01-09 21:03:56.132678+00
489a46e7-5873-4c46-aa22-c7eef3728b56	381da3b9-1f1c-4180-87ab-feab81abf9b5	t	2	2026-01-09 21:03:56.132678+00	2026-01-09 21:03:56.132678+00
0ed34b0f-4fe8-4bd0-9482-f3c1efff3d58	554ab62a-8421-4ac9-92b3-9a112b6015a0	t	1	2026-01-09 21:03:56.132678+00	2026-01-09 21:03:56.132678+00
2cadb483-d65c-4e38-817f-1729034efff2	554ab62a-8421-4ac9-92b3-9a112b6015a0	t	1	2026-01-09 21:03:56.132678+00	2026-01-09 21:03:56.132678+00
489a46e7-5873-4c46-aa22-c7eef3728b56	554ab62a-8421-4ac9-92b3-9a112b6015a0	t	1	2026-01-09 21:03:56.132678+00	2026-01-09 21:03:56.132678+00
\.


--
-- Data for Name: history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.history (id, user_id, diagnostic_id, title, status, created_at, device_id, category_id) FROM stdin;
7	1	7	Problema de Electricidad básica	pendiente	2026-01-13 15:08:10.739749+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
8	1	8	Problema de Electricidad básica	pendiente	2026-01-13 15:10:48.355647+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
9	1	9	Problema de Electricidad básica	pendiente	2026-01-13 15:11:20.489708+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
10	1	10	Problema de Fontanería simple	pendiente	2026-01-13 15:12:04.807418+00	\N	f742ded4-049b-4359-923e-c82f4dc697d7
11	1	11	Problema de Electricidad básica	pendiente	2026-01-13 15:12:40.177624+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
12	1	12	Problema de Electricidad básica	pendiente	2026-01-13 15:15:37.587149+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
15	1	15	Problema de Electricidad básica	solucionado	2026-01-13 16:24:47.595771+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
14	1	14	Problema de Electricidad básica	solucionado	2026-01-13 16:19:49.948074+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
13	1	13	Problema de Fontanería simple	solucionado	2026-01-13 15:17:15.462435+00	\N	f742ded4-049b-4359-923e-c82f4dc697d7
16	1	16	Problema de Electricidad básica	solucionado	2026-01-13 22:39:17.723641+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
2	1	2	chispas	solucionado	2026-01-13 13:51:36.921337+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
3	1	3	prueba de oto	solucionado	2026-01-13 13:52:00.710913+00	\N	fb805aa7-4c3d-4344-892e-8a9871344a75
4	1	4	Problema de Electricidad básica	solucionado	2026-01-13 13:56:16.249215+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
1	1	1	Problema de Electricidad básica	solucionado	2026-01-13 13:51:27.061207+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
17	1	17	Problema de Fontanería simple	solucionado	2026-01-13 22:41:17.675766+00	\N	f742ded4-049b-4359-923e-c82f4dc697d7
18	1	18	Problema de Fontanería simple	solucionado	2026-01-13 22:48:24.166804+00	\N	f742ded4-049b-4359-923e-c82f4dc697d7
19	1	19	Problema de Grifería y sanitarios	solucionado	2026-01-13 22:59:10.633627+00	\N	d8f79f83-7ce2-468f-a777-95ac4dc71f0c
6	1	6	Problema de Electricidad básica	solucionado	2026-01-13 13:59:37.394106+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
5	1	5	Problema de Electricidad básica	solucionado	2026-01-13 13:57:07.267499+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
20	1	20	Problema de Fontanería simple	solucionado	2026-01-13 23:14:41.721192+00	\N	f742ded4-049b-4359-923e-c82f4dc697d7
21	1	21	Problema de Electricidad básica	solucionado	2026-01-14 16:13:16.925225+00	\N	7f521992-116b-48a7-8388-4ac8c70db191
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.metrics (id, user_id, session_id, platform, event, data, device, app_version, created_at) FROM stdin;
1	1	b7a1f1e0-3a2b-4e5f-9a6f-1f2c3d4e5f60	android	view_inicio	{}	Pixel 7 Pro	1.0.0	2026-01-01 19:30:04.513995+00
2	1	b7a1f1e0-3a2b-4e5f-9a6f-1f2c3d4e5f60	android	start_diagnostic_click	{"source": "inicio"}	Pixel 7 Pro	1.0.0	2026-01-01 19:31:04.513995+00
3	1	b7a1f1e0-3a2b-4e5f-9a6f-1f2c3d4e5f60	android	submit_diagnostic	{"hasText": true, "category": "electro", "hasImage": true}	Pixel 7 Pro	1.0.0	2026-01-01 19:32:04.513995+00
4	1	b7a1f1e0-3a2b-4e5f-9a6f-1f2c3d4e5f60	android	view_diagnostico	{"category": "electro", "riskLevel": "bajo"}	Pixel 7 Pro	1.0.0	2026-01-01 19:33:04.513995+00
5	1	b7a1f1e0-3a2b-4e5f-9a6f-1f2c3d4e5f60	android	open_guide_click	{"source": "diagnostico"}	Pixel 7 Pro	1.0.0	2026-01-01 19:34:04.513995+00
6	2	f3c7b8a2-1c4d-4e7a-9b6a-2d1c0f9e8a77	ios	view_contacto	{"city": "Bogota"}	iPhone 14	1.0.1	2026-01-01 19:35:04.513995+00
7	2	f3c7b8a2-1c4d-4e7a-9b6a-2d1c0f9e8a77	ios	contact_whatsapp_click	{"city": "Bogota"}	iPhone 14	1.0.1	2026-01-01 19:36:04.513995+00
8	2	f3c7b8a2-1c4d-4e7a-9b6a-2d1c0f9e8a77	ios	view_historial	{}	iPhone 14	1.0.1	2026-01-01 19:37:04.513995+00
9	1	547d6f8c-adb0-4259-84b8-4268e184f185	android	view_inicio	{}	sdk_gphone64_x86_64	1.0.0	2026-01-02 16:14:32.901+00
10	1	547d6f8c-adb0-4259-84b8-4268e184f185	android	view_captura	{}	sdk_gphone64_x86_64	1.0.0	2026-01-02 16:15:01.107+00
11	1	547d6f8c-adb0-4259-84b8-4268e184f185	android	submit_diagnostic	{"hasText": false, "category": "electrodomesticos", "hasImage": true}	sdk_gphone64_x86_64	1.0.0	2026-01-02 16:15:18.252+00
12	1	547d6f8c-adb0-4259-84b8-4268e184f185	android	view_diagnostico	{"category": "electrodomesticos", "riskLevel": "medio"}	sdk_gphone64_x86_64	1.0.0	2026-01-02 16:15:19.293+00
13	1	547d6f8c-adb0-4259-84b8-4268e184f185	android	view_guia	{}	sdk_gphone64_x86_64	1.0.0	2026-01-02 16:15:22.496+00
14	1	547d6f8c-adb0-4259-84b8-4268e184f185	android	view_diagnostico	{"category": "electrodomesticos", "riskLevel": "medio"}	sdk_gphone64_x86_64	1.0.0	2026-01-02 16:15:28.921+00
15	1	547d6f8c-adb0-4259-84b8-4268e184f185	android	view_inicio	{}	sdk_gphone64_x86_64	1.0.0	2026-01-02 16:15:32.339+00
16	1	547d6f8c-adb0-4259-84b8-4268e184f185	android	view_inicio	{}	sdk_gphone64_x86_64	1.0.0	2026-01-02 16:16:21.399+00
17	1	547d6f8c-adb0-4259-84b8-4268e184f185	android	view_inicio	{}	sdk_gphone64_x86_64	1.0.0	2026-01-02 16:24:49.208+00
\.


--
-- Data for Name: technicians; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.technicians (id, name, role, city, zone, phone, rating, reviews_count, active, created_at, updated_at) FROM stdin;
1	Juan Perez	Plomero	Bogota	Chapinero	3001112233	4.80	120	t	2025-12-30 23:14:31+00	2025-12-30 23:14:31+00
2	Carlos Ruiz	Electricista	Bogota	Usaquen	3002223344	4.60	55	t	2025-12-30 23:14:31+00	2025-12-30 23:14:31+00
3	Maria Diaz	Tecnico de Electrodomesticos	Medellin	Laureles	3003334455	4.70	80	t	2025-12-30 23:14:31+00	2025-12-30 23:14:31+00
4	Luis Martinez	Plomero	Bogota	Chapinero	3105551111	4.80	124	t	2025-12-31 12:07:28+00	2025-12-31 12:07:28+00
5	Jorge Ramirez	Electricista	Bogota	Usaquen	3105552222	4.60	89	t	2025-12-31 12:07:28+00	2025-12-31 12:07:28+00
7	Carlos Restrepo	Plomero	Medellin	Belen	3105554444	4.90	76	t	2025-12-31 12:07:28+00	2025-12-31 12:07:28+00
8	Andres Lopez	Electricista	Medellin	Laureles	3105555555	4.50	61	t	2025-12-31 12:07:28+00	2025-12-31 12:07:28+00
6	Maria Diaz cambio	Tecnico de Electrodomesticos	Cali	Campina	3155318244	4.70	102	t	2025-12-31 12:07:28+00	2025-12-31 14:43:49+00
\.


--
-- Data for Name: technician_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.technician_categories (technician_id, category_id, created_at) FROM stdin;
1	f742ded4-049b-4359-923e-c82f4dc697d7	2026-01-08 10:45:24.674913
4	f742ded4-049b-4359-923e-c82f4dc697d7	2026-01-08 10:45:24.674913
7	f742ded4-049b-4359-923e-c82f4dc697d7	2026-01-08 10:45:24.674913
2	7f521992-116b-48a7-8388-4ac8c70db191	2026-01-08 10:45:24.674913
5	7f521992-116b-48a7-8388-4ac8c70db191	2026-01-08 10:45:24.674913
8	7f521992-116b-48a7-8388-4ac8c70db191	2026-01-08 10:45:24.674913
3	14d38a9a-70b9-4986-8617-55712c3b38bc	2026-01-08 10:45:24.674913
6	14d38a9a-70b9-4986-8617-55712c3b38bc	2026-01-08 10:45:24.674913
3	fb805aa7-4c3d-4344-892e-8a9871344a75	2026-01-08 10:45:24.674913
6	fb805aa7-4c3d-4344-892e-8a9871344a75	2026-01-08 10:45:24.674913
\.


--
-- Data for Name: technician_reviews; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.technician_reviews (id, technician_id, user_id, rating, comment, created_at) FROM stdin;
1	1	1	5	Llego rapido y soluciono la fuga sin problemas.	2025-12-31 12:07:28+00
2	1	2	4	Buen servicio, aunque llego un poco tarde.	2025-12-31 12:07:28+00
3	2	1	5	Excelente electricista, muy profesional.	2025-12-31 12:07:28+00
4	3	3	4	Arreglo la nevera, pero tardo mas de lo esperado.	2025-12-31 12:07:28+00
5	4	3	5	Muy recomendado, dejo todo funcionando perfecto.	2025-12-31 12:07:28+00
\.


--
-- Name: devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.devices_id_seq', 6, true);


--
-- Name: diagnostics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.diagnostics_id_seq', 21, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.events_id_seq', 241, true);


--
-- Name: history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.history_id_seq', 21, true);


--
-- Name: metrics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.metrics_id_seq', 17, true);


--
-- Name: technician_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.technician_reviews_id_seq', 5, true);


--
-- Name: technicians_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.technicians_id_seq', 8, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- PostgreSQL database dump complete
--

\unrestrict qEe8jVivreoCfBqQozTKPKWoFkkb149FGdK0AB29BcmxhgluaKkYI9Q2wR9bFWH

