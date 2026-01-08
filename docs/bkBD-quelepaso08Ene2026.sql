--
-- PostgreSQL database dump
--

\restrict fMItqdaZwHbV6UAwdHIzO28HD80faD7W4FhpAR29b0K0ioDXLmzdKERSY0pLUfi

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: qulepaso_db_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO qulepaso_db_user;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: device_platform_enum; Type: TYPE; Schema: public; Owner: qulepaso_db_user
--

CREATE TYPE public.device_platform_enum AS ENUM (
    'android',
    'ios',
    'web'
);


ALTER TYPE public.device_platform_enum OWNER TO qulepaso_db_user;

--
-- Name: diagnostic_resolution_action_enum; Type: TYPE; Schema: public; Owner: qulepaso_db_user
--

CREATE TYPE public.diagnostic_resolution_action_enum AS ENUM (
    'diy',
    'contact_technician',
    'warning_only'
);


ALTER TYPE public.diagnostic_resolution_action_enum OWNER TO qulepaso_db_user;

--
-- Name: event_name_enum; Type: TYPE; Schema: public; Owner: qulepaso_db_user
--

CREATE TYPE public.event_name_enum AS ENUM (
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
);


ALTER TYPE public.event_name_enum OWNER TO qulepaso_db_user;

--
-- Name: history_status_enum; Type: TYPE; Schema: public; Owner: qulepaso_db_user
--

CREATE TYPE public.history_status_enum AS ENUM (
    'solucionado',
    'pendiente',
    'revisado',
    'cancelado'
);


ALTER TYPE public.history_status_enum OWNER TO qulepaso_db_user;

--
-- Name: risk_level_enum; Type: TYPE; Schema: public; Owner: qulepaso_db_user
--

CREATE TYPE public.risk_level_enum AS ENUM (
    'bajo',
    'medio',
    'alto'
);


ALTER TYPE public.risk_level_enum OWNER TO qulepaso_db_user;

--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: qulepaso_db_user
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO qulepaso_db_user;

--
-- Name: set_updated_at_categories(); Type: FUNCTION; Schema: public; Owner: qulepaso_db_user
--

CREATE FUNCTION public.set_updated_at_categories() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_updated_at_categories() OWNER TO qulepaso_db_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    slug character varying(50) NOT NULL,
    name character varying(80) NOT NULL,
    description character varying(255),
    icon character varying(50) NOT NULL,
    tint_color character(7) NOT NULL,
    bg_color character(7) NOT NULL,
    is_quick boolean DEFAULT false NOT NULL,
    order_index integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    image_url character varying(255),
    CONSTRAINT categories_bg_color_chk CHECK ((bg_color ~ '^#[0-9A-Fa-f]{6}$'::text)),
    CONSTRAINT categories_tint_color_chk CHECK ((tint_color ~ '^#[0-9A-Fa-f]{6}$'::text))
);


ALTER TABLE public.categories OWNER TO qulepaso_db_user;

--
-- Name: devices; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.devices (
    id bigint NOT NULL,
    device_uuid character varying(36) NOT NULL,
    platform public.device_platform_enum DEFAULT 'android'::public.device_platform_enum NOT NULL,
    app_version character varying(30),
    city character varying(80),
    zone character varying(80),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_seen_at timestamp with time zone
);


ALTER TABLE public.devices OWNER TO qulepaso_db_user;

--
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: qulepaso_db_user
--

CREATE SEQUENCE public.devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.devices_id_seq OWNER TO qulepaso_db_user;

--
-- Name: devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qulepaso_db_user
--

ALTER SEQUENCE public.devices_id_seq OWNED BY public.devices.id;


--
-- Name: diagnostics; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.diagnostics (
    id bigint NOT NULL,
    user_id bigint,
    input_text character varying(800),
    image_url character varying(600),
    possible_cause character varying(900) NOT NULL,
    risk_level public.risk_level_enum NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    device_id bigint,
    confidence numeric(4,3),
    model_version character varying(40),
    resolution_action public.diagnostic_resolution_action_enum,
    feedback_useful boolean,
    feedback_comment character varying(300),
    category_id uuid NOT NULL,
    guide_id uuid
);


ALTER TABLE public.diagnostics OWNER TO qulepaso_db_user;

--
-- Name: diagnostics_id_seq; Type: SEQUENCE; Schema: public; Owner: qulepaso_db_user
--

CREATE SEQUENCE public.diagnostics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.diagnostics_id_seq OWNER TO qulepaso_db_user;

--
-- Name: diagnostics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qulepaso_db_user
--

ALTER SEQUENCE public.diagnostics_id_seq OWNED BY public.diagnostics.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    device_id bigint,
    user_id bigint,
    diagnostic_id bigint,
    event_name public.event_name_enum NOT NULL,
    screen_name character varying(60),
    event_value character varying(120),
    meta_json jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.events OWNER TO qulepaso_db_user;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: qulepaso_db_user
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.events_id_seq OWNER TO qulepaso_db_user;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qulepaso_db_user
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: guide_categories; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.guide_categories (
    guide_id uuid NOT NULL,
    category_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.guide_categories OWNER TO qulepaso_db_user;

--
-- Name: guide_steps; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.guide_steps (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    guide_id uuid NOT NULL,
    step_number integer NOT NULL,
    title character varying(140) NOT NULL,
    body text NOT NULL,
    image_url text,
    estimated_minutes integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT guide_steps_estimated_minutes_check CHECK (((estimated_minutes IS NULL) OR (estimated_minutes >= 0))),
    CONSTRAINT guide_steps_step_number_check CHECK ((step_number >= 1))
);


ALTER TABLE public.guide_steps OWNER TO qulepaso_db_user;

--
-- Name: guide_tools; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.guide_tools (
    guide_id uuid NOT NULL,
    tool_id uuid NOT NULL,
    is_required boolean DEFAULT true NOT NULL,
    order_index integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.guide_tools OWNER TO qulepaso_db_user;

--
-- Name: guides; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.guides (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    slug character varying(80) NOT NULL,
    title character varying(120) NOT NULL,
    summary text,
    duration_minutes integer DEFAULT 0 NOT NULL,
    difficulty_level character varying(20) DEFAULT 'basico'::character varying NOT NULL,
    safety_title character varying(120),
    safety_text text,
    success_title character varying(120),
    success_text text,
    cover_image_url text,
    is_active boolean DEFAULT true NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT guides_difficulty_level_check CHECK (((difficulty_level)::text = ANY ((ARRAY['basico'::character varying, 'intermedio'::character varying, 'avanzado'::character varying])::text[]))),
    CONSTRAINT guides_duration_minutes_check CHECK ((duration_minutes >= 0)),
    CONSTRAINT guides_version_check CHECK ((version >= 1))
);


ALTER TABLE public.guides OWNER TO qulepaso_db_user;

--
-- Name: history; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.history (
    id bigint NOT NULL,
    user_id bigint,
    diagnostic_id bigint,
    title character varying(140) NOT NULL,
    status public.history_status_enum DEFAULT 'pendiente'::public.history_status_enum NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    device_id bigint,
    category_id uuid NOT NULL
);


ALTER TABLE public.history OWNER TO qulepaso_db_user;

--
-- Name: history_id_seq; Type: SEQUENCE; Schema: public; Owner: qulepaso_db_user
--

CREATE SEQUENCE public.history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.history_id_seq OWNER TO qulepaso_db_user;

--
-- Name: history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qulepaso_db_user
--

ALTER SEQUENCE public.history_id_seq OWNED BY public.history.id;


--
-- Name: metrics; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.metrics (
    id bigint NOT NULL,
    user_id bigint,
    session_id uuid,
    platform character varying(10),
    event character varying(80) NOT NULL,
    data jsonb,
    device character varying(80),
    app_version character varying(20),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.metrics OWNER TO qulepaso_db_user;

--
-- Name: metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: qulepaso_db_user
--

CREATE SEQUENCE public.metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metrics_id_seq OWNER TO qulepaso_db_user;

--
-- Name: metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qulepaso_db_user
--

ALTER SEQUENCE public.metrics_id_seq OWNED BY public.metrics.id;


--
-- Name: technician_categories; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.technician_categories (
    technician_id bigint NOT NULL,
    category_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.technician_categories OWNER TO qulepaso_db_user;

--
-- Name: technician_reviews; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.technician_reviews (
    id bigint NOT NULL,
    technician_id bigint NOT NULL,
    user_id bigint,
    rating smallint NOT NULL,
    comment character varying(600),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.technician_reviews OWNER TO qulepaso_db_user;

--
-- Name: technician_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: qulepaso_db_user
--

CREATE SEQUENCE public.technician_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.technician_reviews_id_seq OWNER TO qulepaso_db_user;

--
-- Name: technician_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qulepaso_db_user
--

ALTER SEQUENCE public.technician_reviews_id_seq OWNED BY public.technician_reviews.id;


--
-- Name: technicians; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.technicians (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    role character varying(80) NOT NULL,
    city character varying(80) NOT NULL,
    zone character varying(80),
    phone character varying(30) NOT NULL,
    rating numeric(3,2) DEFAULT 0.00 NOT NULL,
    reviews_count integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.technicians OWNER TO qulepaso_db_user;

--
-- Name: technicians_id_seq; Type: SEQUENCE; Schema: public; Owner: qulepaso_db_user
--

CREATE SEQUENCE public.technicians_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.technicians_id_seq OWNER TO qulepaso_db_user;

--
-- Name: technicians_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qulepaso_db_user
--

ALTER SEQUENCE public.technicians_id_seq OWNED BY public.technicians.id;


--
-- Name: tools; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.tools (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    slug character varying(80) NOT NULL,
    name character varying(120) NOT NULL,
    icon character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tools OWNER TO qulepaso_db_user;

--
-- Name: users; Type: TABLE; Schema: public; Owner: qulepaso_db_user
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    full_name character varying(120),
    phone character varying(30),
    city character varying(80),
    zone character varying(80),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    password_hash character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO qulepaso_db_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: qulepaso_db_user
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO qulepaso_db_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qulepaso_db_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: devices id; Type: DEFAULT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.devices ALTER COLUMN id SET DEFAULT nextval('public.devices_id_seq'::regclass);


--
-- Name: diagnostics id; Type: DEFAULT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.diagnostics ALTER COLUMN id SET DEFAULT nextval('public.diagnostics_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: history id; Type: DEFAULT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.history ALTER COLUMN id SET DEFAULT nextval('public.history_id_seq'::regclass);


--
-- Name: metrics id; Type: DEFAULT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.metrics ALTER COLUMN id SET DEFAULT nextval('public.metrics_id_seq'::regclass);


--
-- Name: technician_reviews id; Type: DEFAULT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.technician_reviews ALTER COLUMN id SET DEFAULT nextval('public.technician_reviews_id_seq'::regclass);


--
-- Name: technicians id; Type: DEFAULT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.technicians ALTER COLUMN id SET DEFAULT nextval('public.technicians_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.categories VALUES ('f742ded4-049b-4359-923e-c82f4dc697d7', 'plomeria', 'Plomería', 'Fugas, goteos, baja presión y sanitarios.', 'plumbing', '#1976D2', '#E3F2FD', true, 1, true, '2026-01-06 14:55:23.759767+00', '2026-01-06 21:01:21.709738+00', 'BASE_URL/categories/category_plumbing.jpg');
INSERT INTO public.categories VALUES ('7f521992-116b-48a7-8388-4ac8c70db191', 'electricidad', 'Electricidad', 'Tomacorrientes, breakers, cortos y fallas.', 'bolt', '#F9A825', '#FFF8E1', true, 2, true, '2026-01-06 14:55:23.759767+00', '2026-01-06 21:01:21.709738+00', 'BASE_URL/categories/category_electric.jpg');
INSERT INTO public.categories VALUES ('14d38a9a-70b9-4986-8617-55712c3b38bc', 'electrodomesticos', 'Electrodomésticos', 'Nevera, lavadora, microondas y otros.', 'kitchen', '#7B1FA2', '#F3E5F5', true, 3, true, '2026-01-06 14:55:23.759767+00', '2026-01-06 21:01:21.709738+00', 'BASE_URL/categories/category_electro.jpg');
INSERT INTO public.categories VALUES ('ddb961b3-1f08-499a-b59d-0c95c36aeb9b', 'internet', 'Internet', 'Wi‑Fi, router, señal y conectividad.', 'wifi', '#388E3C', '#E8F5E9', true, 4, true, '2026-01-06 14:55:23.759767+00', '2026-01-06 21:01:21.709738+00', 'BASE_URL/categories/category_internet.jpg');
INSERT INTO public.categories VALUES ('fb805aa7-4c3d-4344-892e-8a9871344a75', 'otro', 'Otro', 'Problemas no clasificados en las categorías principales.', 'help', '#546E7A', '#ECEFF1', false, 99, true, '2026-01-06 15:01:48.798329+00', '2026-01-06 21:46:28.930736+00', 'BASE_URL/categories/category_otro.jpg');


--
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.devices VALUES (1, '7aeeaaa0-2ea0-47c8-9da9-e64db16781e8', 'android', '1.0.0', NULL, NULL, '2026-01-05 21:37:21.68963+00', '2026-01-05 21:37:21.68963+00');


--
-- Data for Name: diagnostics; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.diagnostics VALUES (46, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/4295ee5b-64d6-4e19-bfd3-452f92ec42ec.jpeg', 'Diagnostico preliminar para categoria: electricidad', 'medio', '2026-01-05 21:39:22.89231+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (45, 1, 'Rrr', 'file:///data/user/0/com.jcpazmino44.quelepasomobile/cache/ImagePicker/5b4d829b-f41a-4991-b5a3-35c0f5f18a5c.jpeg', 'Diagnostico preliminar para categoria: electricidad', 'medio', '2026-01-02 21:36:58.113637+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (44, 1, NULL, 'file:///data/user/0/com.jcpazmino44.quelepasomobile/cache/ImagePicker/450e4bb7-e6a5-482f-9e1c-e71409d56549.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 18:16:22.339926+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (43, 1, 'Prueba', 'file:///data/user/0/com.jcpazmino44.quelepasomobile/cache/ImagePicker/265efd52-63bf-4805-ab39-715bd27e8fce.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 17:19:56.291919+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (42, 1, 'Prueba', 'file:///data/user/0/com.jcpazmino44.quelepasomobile/cache/ImagePicker/265efd52-63bf-4805-ab39-715bd27e8fce.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 17:19:37.842726+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (41, 1, 'Prueba inicial', 'file:///data/user/0/com.jcpazmino44.quelepasomobile/cache/ImagePicker/679d698f-5b96-44a8-a4f3-64462fe03a33.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 17:01:10.201879+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (40, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/9aecc96c-adee-405c-bfa9-91f3a67f914d.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 16:15:31.685618+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (39, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/065fe0e0-272f-4014-8626-e869916304b2.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 16:05:07.282015+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (38, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/076530eb-91d1-4c25-994a-85d6a0127e59.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 15:58:18.576917+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (37, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/329f761a-e7a3-4ee2-a359-51004c06cc5a.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 15:54:28.424673+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (36, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/2a1dcc7a-5add-435b-aaf5-ea5760400d74.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 15:46:34.559006+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (35, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/fa1e29a6-e608-49a1-ad8d-07d30a78a69a.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 15:14:27.017804+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (34, 1, 'prueba', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/2eb48c70-29ed-41ce-a5d4-057a21ff3726.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 15:07:08.528773+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (33, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/552cae21-9756-4886-aca5-86e53a3d2e56.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 14:20:37.587209+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (32, 1, 'sin luz en casa', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/203bf599-5334-46e6-9e7d-1b19e7a64307.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 14:10:35.785835+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (31, 1, 'sin luz en casa', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/203bf599-5334-46e6-9e7d-1b19e7a64307.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 14:09:30.168324+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (30, 1, 'fuga leve', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/47dc66e0-a226-4218-b38f-5116f0a4a249.jpeg', 'Fuga en union o empaque deteriorado.', 'medio', '2026-01-02 13:59:40.508511+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (29, 1, 'fuga leve', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/85aff44f-b390-448f-8d67-f9a2873ebf8e.jpeg', 'Fuga en union o empaque deteriorado.', 'medio', '2026-01-02 13:58:57.240325+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (28, 1, 'fuga leve', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/85aff44f-b390-448f-8d67-f9a2873ebf8e.jpeg', 'Fuga en union o empaque deteriorado.', 'medio', '2026-01-02 13:54:33.682885+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (27, 1, 'baja presión', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/85aff44f-b390-448f-8d67-f9a2873ebf8e.jpeg', 'Obstruccion parcial o valvula cerrada.', 'medio', '2026-01-02 13:53:57.431996+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (26, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/85aff44f-b390-448f-8d67-f9a2873ebf8e.jpeg', 'Diagnostico preliminar para categoria: electricidad', 'medio', '2026-01-02 13:52:40.747049+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (25, 1, 'prueba de P3', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/85aff44f-b390-448f-8d67-f9a2873ebf8e.jpeg', 'Diagnostico preliminar para categoria: electricidad', 'medio', '2026-01-02 13:52:17.454801+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (24, 1, 'prueba de P3 chispa', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/85aff44f-b390-448f-8d67-f9a2873ebf8e.jpeg', 'Posible cortocircuito o cable expuesto.', 'alto', '2026-01-02 13:14:01.760605+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (23, 1, 'prueba de P3', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/85aff44f-b390-448f-8d67-f9a2873ebf8e.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-02 13:12:26.929712+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (22, 1, 'prueba de P3', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/85aff44f-b390-448f-8d67-f9a2873ebf8e.jpeg', 'Diagnostico preliminar para categoria: plomeria', 'medio', '2026-01-02 13:12:06.709407+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (21, 1, 'prueba de P3', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/85aff44f-b390-448f-8d67-f9a2873ebf8e.jpeg', 'Diagnostico preliminar para categoria: electricidad', 'medio', '2026-01-02 13:10:04.261687+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (20, 1, 'preuba inject key app.config.js', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/5e7d92ee-fe66-4cbe-adba-8882f80f223c.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'bajo', '2026-01-02 12:51:00.862002+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (19, 1, 'prueba viernes', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/df30389d-7820-4487-9c00-93ebb99ff413.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'bajo', '2026-01-02 12:43:04.742566+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (18, 1, 'preuba', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/ff083479-0e79-47d0-b523-02148ba3bd1e.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'bajo', '2026-01-01 20:40:03.871133+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (17, 1, 'prueba 2', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/3d2349dd-d094-462d-920e-032d6a52f9e3.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'bajo', '2026-01-01 20:33:01.742617+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (16, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/5f4d2a99-a926-4ff7-914d-5352fd5884e9.jpeg', 'Diagnostico preliminar para categoria: electricidad', 'bajo', '2026-01-01 20:26:59.161837+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (15, 1, 'electrodo metricas', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/4578de31-da5e-42c0-8f9a-d00357140d2a.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'bajo', '2026-01-01 20:17:47.172483+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (14, 1, 'electricidad métricas', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/5645bca3-755d-4b3b-b844-5a228619b4cd.jpeg', 'Diagnostico preliminar para categoria: electricidad', 'bajo', '2026-01-01 20:14:45.836347+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (13, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/2f69ccd5-688c-4387-b4a1-b556d460052e.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'bajo', '2026-01-01 17:00:02.453744+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (12, 1, 'prueba, guardar en BD', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/acf26561-c0f4-4ae8-98c6-6eaadfc5f7e1.jpeg', 'Diagnostico preliminar para categoria: electricidad', 'bajo', '2026-01-01 16:47:50.150122+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (11, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/cb538253-12cb-4c47-a185-0a3762fb5a16.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'bajo', '2026-01-01 16:26:41.942074+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (10, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/18a9ec32-d540-4fba-ba68-b1f4784fb333.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'bajo', '2026-01-01 16:24:08.03957+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (9, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/8677e0a2-7326-4863-9ef2-338de5287a1c.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'bajo', '2025-12-31 21:42:57.506282+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (8, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/1215f6cb-091f-48b8-b614-a032bc47e48a.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'bajo', '2025-12-31 21:40:00.96581+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (7, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/fe7d9c10-8d87-44ff-ac2a-059800d56f8d.jpeg', 'Diagnostico preliminar para categoria: electro', 'bajo', '2025-12-31 14:35:22+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (6, NULL, 'pierde agua', 'https://example.com/img.jpg', 'Diagnostico preliminar para categoria: plomeria', 'bajo', '2025-12-31 12:50:12+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (5, NULL, 'pierde agua', 'https://example.com/img.jpg', 'Diagnostico preliminar para categoria: plomeria', 'bajo', '2025-12-31 12:49:29+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (1, 1, 'La llave gotea constantemente', 'https://cdn.quelepaso.app/img/diag_001.jpg', 'Desgaste del empaque interno del grifo', 'bajo', '2025-12-31 12:07:28+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (2, 2, 'El tomacorriente chispea al conectar algo', 'https://cdn.quelepaso.app/img/diag_002.jpg', 'Conexion floja o cableado deteriorado', 'alto', '2025-12-31 12:07:28+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (3, 3, 'La nevera no enfria bien', 'https://cdn.quelepaso.app/img/diag_003.jpg', 'Acumulacion de suciedad en el condensador', 'medio', '2025-12-31 12:07:28+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (4, NULL, 'El inodoro no descarga', 'https://cdn.quelepaso.app/img/diag_004.jpg', 'Problema en la valvula de descarga', 'medio', '2025-12-31 12:07:28+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (47, 1, 'chispas', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/291596b3-1adc-4a37-b5ca-268b86ad03f4.jpeg', 'Posible cortocircuito o cable expuesto.', 'alto', '2026-01-06 16:33:26.736224+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (48, 1, 'no tengo señal', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/4b8e65a6-d6ad-4c08-9ac4-b22ade778f14.jpeg', 'Diagnostico preliminar para categoria: internet', 'medio', '2026-01-07 15:36:58.470604+00', NULL, NULL, NULL, NULL, NULL, NULL, 'ddb961b3-1f08-499a-b59d-0c95c36aeb9b', NULL);
INSERT INTO public.diagnostics VALUES (49, 1, 'no tendo señal', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/162eec24-388d-4bff-a984-f3637442d56c.jpeg', 'Diagnostico preliminar para categoria: internet', 'medio', '2026-01-07 15:52:47.605682+00', NULL, NULL, NULL, NULL, NULL, NULL, 'ddb961b3-1f08-499a-b59d-0c95c36aeb9b', NULL);
INSERT INTO public.diagnostics VALUES (50, 1, 'tengo una gotera', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/11771d7e-8375-44f4-a4e3-c956a124a2e7.jpeg', 'Fuga en union o empaque deteriorado.', 'medio', '2026-01-07 15:59:10.239326+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (51, 1, 'goteras', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/ceaa006a-1231-437c-8372-22ea9afdfb08.jpeg', 'Diagnostico preliminar para categoria: electrodomesticos', 'medio', '2026-01-07 19:54:25.34533+00', NULL, NULL, NULL, NULL, NULL, NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc', NULL);
INSERT INTO public.diagnostics VALUES (52, 1, 'goteras', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/ceaa006a-1231-437c-8372-22ea9afdfb08.jpeg', 'Fuga en union o empaque deteriorado.', 'medio', '2026-01-07 20:40:53.943909+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (53, 1, 'goteras', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/ceaa006a-1231-437c-8372-22ea9afdfb08.jpeg', 'Fuga en union o empaque deteriorado.', 'medio', '2026-01-07 20:59:04.680395+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (54, 1, 'goteras', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/e711b9b4-dafe-433b-b2dc-f7a2454f5abe.jpeg', 'Fuga en union o empaque deteriorado.', 'medio', '2026-01-07 21:27:58.488127+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', NULL);
INSERT INTO public.diagnostics VALUES (55, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/8e055aa5-9261-4d36-8fcc-be3b928994bd.jpeg', 'Diagnostico preliminar para categoria: plomeria', 'medio', '2026-01-07 22:23:33.226907+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', '1b4b416d-07f9-480d-ad51-73c63168db5b');
INSERT INTO public.diagnostics VALUES (56, 1, NULL, 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/dccb2a52-eaf0-4f9d-8216-d4655b10b282.jpeg', 'Diagnostico preliminar para categoria: plomeria', 'medio', '2026-01-08 15:21:56.550457+00', NULL, NULL, NULL, NULL, NULL, NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7', '1b4b416d-07f9-480d-ad51-73c63168db5b');
INSERT INTO public.diagnostics VALUES (57, 1, 'chispas', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/8cc3a6af-96fe-4fcc-ac11-0ce78452d465.jpeg', 'Posible cortocircuito o cable expuesto.', 'alto', '2026-01-08 15:55:59.334711+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (58, 1, 'chispas', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/5bbff6d9-13d6-4ecd-87d8-b98da12f49ce.jpeg', 'Posible cortocircuito o cable expuesto.', 'alto', '2026-01-08 16:01:42.870449+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (59, 1, 'chispas', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/4ec39760-f9d5-48f1-b1ad-ee5f1d68e127.jpeg', 'Posible cortocircuito o cable expuesto.', 'alto', '2026-01-08 16:05:04.448629+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (60, 1, 'chispas', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/0bc3b391-cff6-4568-a8de-262f470102c7.jpeg', 'Posible cortocircuito o cable expuesto.', 'alto', '2026-01-08 16:10:05.104688+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (61, 1, 'chispas', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/befea64d-8209-4dd4-a34a-3912b2eb2882.jpeg', 'Posible cortocircuito o cable expuesto.', 'alto', '2026-01-08 16:13:21.833623+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (62, 1, 'chispas', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/e99ce126-4174-479e-a4e8-3b7b85773fad.jpeg', 'Posible cortocircuito o cable expuesto.', 'alto', '2026-01-08 16:15:46.602517+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (63, 1, 'chispas', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/2712810f-037e-404d-98c1-7eba3dfa5b5d.jpeg', 'Posible cortocircuito o cable expuesto.', 'alto', '2026-01-08 16:21:02.075396+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (64, 1, 'chispas', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/b6baffee-afca-4c02-9c75-5651bcac9793.jpeg', 'Posible cortocircuito o cable expuesto.', 'alto', '2026-01-08 16:23:34.666829+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);
INSERT INTO public.diagnostics VALUES (65, 1, 'chispas', 'file:///data/user/0/host.exp.exponent/cache/ImagePicker/fce42b64-2c8c-4ad5-938e-9378845da346.jpeg', 'Posible cortocircuito o cable expuesto.', 'alto', '2026-01-08 16:30:00.207193+00', NULL, NULL, NULL, NULL, NULL, NULL, '7f521992-116b-48a7-8388-4ac8c70db191', NULL);


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.events VALUES (1, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-05 21:37:21.931888+00');
INSERT INTO public.events VALUES (2, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-05 21:39:19.483936+00');
INSERT INTO public.events VALUES (3, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'electricidad', '{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-05 21:39:22.700492+00');
INSERT INTO public.events VALUES (4, 1, NULL, 46, 'diagnostic_completed', 'Diagnostico', 'medio', '{"category": "electricidad", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-05 21:39:23.051625+00');
INSERT INTO public.events VALUES (5, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'electricidad', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-05 21:39:28.003523+00');
INSERT INTO public.events VALUES (6, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-05 21:39:28.069363+00');
INSERT INTO public.events VALUES (7, 1, NULL, NULL, 'history_viewed', 'Historial', NULL, '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-05 21:39:33.748536+00');
INSERT INTO public.events VALUES (8, 1, NULL, NULL, 'history_viewed', 'Historial', NULL, '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-05 21:39:38.359034+00');
INSERT INTO public.events VALUES (9, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-06 16:14:01.35002+00');
INSERT INTO public.events VALUES (10, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-06 16:32:43.788668+00');
INSERT INTO public.events VALUES (11, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'electricidad', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-06 16:33:26.560686+00');
INSERT INTO public.events VALUES (12, 1, NULL, 47, 'diagnostic_completed', 'Diagnostico', 'alto', '{"category": "electricidad", "risk_level": "alto", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-06 16:33:26.886671+00');
INSERT INTO public.events VALUES (13, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogotá", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-06 16:34:12.691266+00');
INSERT INTO public.events VALUES (14, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Cali", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-06 16:34:14.292784+00');
INSERT INTO public.events VALUES (15, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:36:41.057436+00');
INSERT INTO public.events VALUES (16, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'internet', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:36:58.273212+00');
INSERT INTO public.events VALUES (17, 1, NULL, 48, 'diagnostic_completed', 'Diagnostico', 'medio', '{"category": "internet", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:36:58.643161+00');
INSERT INTO public.events VALUES (18, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:37:59.384718+00');
INSERT INTO public.events VALUES (19, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'internet', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:37:59.76205+00');
INSERT INTO public.events VALUES (20, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:52:36.663858+00');
INSERT INTO public.events VALUES (21, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'internet', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:52:47.434679+00');
INSERT INTO public.events VALUES (22, 1, NULL, 49, 'diagnostic_completed', 'Diagnostico', 'medio', '{"category": "internet", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:52:47.774729+00');
INSERT INTO public.events VALUES (23, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'internet', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:53:09.311558+00');
INSERT INTO public.events VALUES (24, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:53:09.634453+00');
INSERT INTO public.events VALUES (25, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:54:41.661285+00');
INSERT INTO public.events VALUES (26, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:56:12.775254+00');
INSERT INTO public.events VALUES (27, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogotá", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:56:37.614914+00');
INSERT INTO public.events VALUES (28, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Medellín", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:56:39.670771+00');
INSERT INTO public.events VALUES (29, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Cali", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:56:40.425479+00');
INSERT INTO public.events VALUES (30, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Barranquilla", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:56:44.979709+00');
INSERT INTO public.events VALUES (31, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Cali", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:56:46.086701+00');
INSERT INTO public.events VALUES (32, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Medellín", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:56:46.991855+00');
INSERT INTO public.events VALUES (33, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogotá", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:56:47.907257+00');
INSERT INTO public.events VALUES (34, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Medellín", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:56:49.021887+00');
INSERT INTO public.events VALUES (35, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Cali", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:56:49.690297+00');
INSERT INTO public.events VALUES (36, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Barranquilla", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:56:50.819377+00');
INSERT INTO public.events VALUES (37, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:58:58.534298+00');
INSERT INTO public.events VALUES (38, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'plomeria', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:59:10.061965+00');
INSERT INTO public.events VALUES (39, 1, NULL, 50, 'diagnostic_completed', 'Diagnostico', 'medio', '{"category": "plomeria", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:59:10.37718+00');
INSERT INTO public.events VALUES (40, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:59:51.357773+00');
INSERT INTO public.events VALUES (41, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'plomeria', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 15:59:51.361217+00');
INSERT INTO public.events VALUES (42, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 19:54:10.179322+00');
INSERT INTO public.events VALUES (43, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'electrodomesticos', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 19:54:25.165382+00');
INSERT INTO public.events VALUES (44, 1, NULL, 51, 'diagnostic_completed', 'Diagnostico', 'medio', '{"category": "electrodomesticos", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 19:54:25.507418+00');
INSERT INTO public.events VALUES (45, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'electrodomesticos', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 19:54:34.255077+00');
INSERT INTO public.events VALUES (46, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 19:54:34.285287+00');
INSERT INTO public.events VALUES (47, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'plomeria', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 20:40:53.73664+00');
INSERT INTO public.events VALUES (48, 1, NULL, 52, 'diagnostic_completed', 'Diagnostico', 'medio', '{"category": "plomeria", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 20:40:54.208748+00');
INSERT INTO public.events VALUES (49, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 20:40:57.47764+00');
INSERT INTO public.events VALUES (50, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'plomeria', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 20:40:57.479525+00');
INSERT INTO public.events VALUES (51, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'plomeria', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 20:58:59.894676+00');
INSERT INTO public.events VALUES (52, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 20:59:04.683434+00');
INSERT INTO public.events VALUES (53, 1, NULL, 53, 'diagnostic_completed', 'Diagnostico', 'medio', '{"category": "plomeria", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 20:59:05.028197+00');
INSERT INTO public.events VALUES (54, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 21:01:13.959648+00');
INSERT INTO public.events VALUES (55, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'plomeria', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 21:01:14.057362+00');
INSERT INTO public.events VALUES (56, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'plomeria', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 21:27:58.278462+00');
INSERT INTO public.events VALUES (57, 1, NULL, 54, 'diagnostic_completed', 'Diagnostico', 'medio', '{"category": "plomeria", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 21:27:58.660476+00');
INSERT INTO public.events VALUES (58, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 21:52:03.085645+00');
INSERT INTO public.events VALUES (59, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 22:14:01.605593+00');
INSERT INTO public.events VALUES (60, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "plomeria", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 22:23:30.16529+00');
INSERT INTO public.events VALUES (61, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'plomeria', '{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 22:23:32.974646+00');
INSERT INTO public.events VALUES (62, 1, NULL, 55, 'diagnostic_completed', 'Diagnostico', 'medio', '{"category": "plomeria", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 22:23:33.457813+00');
INSERT INTO public.events VALUES (63, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'plomeria', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 22:23:38.171868+00');
INSERT INTO public.events VALUES (64, 1, NULL, NULL, 'guide_step_viewed', 'Guia', 'arreglando-la-gotera', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 22:23:38.272262+00');
INSERT INTO public.events VALUES (65, 1, NULL, 55, 'guide_completed', 'Guia', 'arreglando-la-gotera', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 22:26:19.852888+00');
INSERT INTO public.events VALUES (66, 1, NULL, NULL, 'history_viewed', 'Historial', NULL, '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-07 22:28:44.253907+00');
INSERT INTO public.events VALUES (67, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:21:43.063177+00');
INSERT INTO public.events VALUES (68, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'plomeria', '{"hasText": false, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:21:56.075668+00');
INSERT INTO public.events VALUES (69, 1, NULL, 56, 'diagnostic_completed', 'Diagnostico', 'medio', '{"category": "plomeria", "risk_level": "medio", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:21:56.738079+00');
INSERT INTO public.events VALUES (70, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'plomeria', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:22:13.757983+00');
INSERT INTO public.events VALUES (71, 1, NULL, NULL, 'guide_step_viewed', 'Guia', 'arreglando-la-gotera', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:22:13.799619+00');
INSERT INTO public.events VALUES (72, 1, NULL, NULL, 'history_viewed', 'Historial', NULL, '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:22:56.551338+00');
INSERT INTO public.events VALUES (73, 1, NULL, NULL, 'history_viewed', 'Historial', NULL, '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:23:10.23191+00');
INSERT INTO public.events VALUES (74, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:55:58.501677+00');
INSERT INTO public.events VALUES (75, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'electricidad', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:55:58.970247+00');
INSERT INTO public.events VALUES (76, 1, NULL, 57, 'diagnostic_completed', 'Diagnostico', 'alto', '{"category": "electricidad", "risk_level": "alto", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:55:59.497697+00');
INSERT INTO public.events VALUES (77, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:58:29.02769+00');
INSERT INTO public.events VALUES (78, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Cali", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:58:31.57573+00');
INSERT INTO public.events VALUES (79, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Medellin", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:58:33.373806+00');
INSERT INTO public.events VALUES (80, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Medellin", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 15:58:34.693853+00');
INSERT INTO public.events VALUES (81, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:01:26.525103+00');
INSERT INTO public.events VALUES (82, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'electricidad', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:01:42.674611+00');
INSERT INTO public.events VALUES (83, 1, NULL, 58, 'diagnostic_completed', 'Diagnostico', 'alto', '{"category": "electricidad", "risk_level": "alto", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:01:43.03581+00');
INSERT INTO public.events VALUES (84, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:01:50.777644+00');
INSERT INTO public.events VALUES (85, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Cali", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:01:53.663764+00');
INSERT INTO public.events VALUES (86, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Medellin", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:02:06.432639+00');
INSERT INTO public.events VALUES (87, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:02:16.154513+00');
INSERT INTO public.events VALUES (88, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:04:54.646607+00');
INSERT INTO public.events VALUES (89, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'electricidad', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:05:04.258639+00');
INSERT INTO public.events VALUES (90, 1, NULL, 59, 'diagnostic_completed', 'Diagnostico', 'alto', '{"category": "electricidad", "risk_level": "alto", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:05:04.615657+00');
INSERT INTO public.events VALUES (91, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:05:12.260706+00');
INSERT INTO public.events VALUES (92, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Cali", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:05:22.27537+00');
INSERT INTO public.events VALUES (93, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Medellin", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:05:31.339369+00');
INSERT INTO public.events VALUES (94, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:09:39.033246+00');
INSERT INTO public.events VALUES (95, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'electricidad', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:10:04.905499+00');
INSERT INTO public.events VALUES (96, 1, NULL, 60, 'diagnostic_completed', 'Diagnostico', 'alto', '{"category": "electricidad", "risk_level": "alto", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:10:05.303013+00');
INSERT INTO public.events VALUES (97, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'electricidad', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:10:08.726659+00');
INSERT INTO public.events VALUES (98, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:10:08.884291+00');
INSERT INTO public.events VALUES (99, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:10:31.163618+00');
INSERT INTO public.events VALUES (100, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electricidad", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:13:15.913655+00');
INSERT INTO public.events VALUES (101, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'electricidad', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:13:21.599824+00');
INSERT INTO public.events VALUES (102, 1, NULL, 61, 'diagnostic_completed', 'Diagnostico', 'alto', '{"category": "electricidad", "risk_level": "alto", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:13:22.005698+00');
INSERT INTO public.events VALUES (103, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'electricidad', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:13:25.546936+00');
INSERT INTO public.events VALUES (104, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:13:25.577189+00');
INSERT INTO public.events VALUES (105, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:13:28.66668+00');
INSERT INTO public.events VALUES (106, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:15:38.526421+00');
INSERT INTO public.events VALUES (107, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'electricidad', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:15:46.428699+00');
INSERT INTO public.events VALUES (108, 1, NULL, 62, 'diagnostic_completed', 'Diagnostico', 'alto', '{"category": "electricidad", "risk_level": "alto", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:15:46.75694+00');
INSERT INTO public.events VALUES (109, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:15:49.735011+00');
INSERT INTO public.events VALUES (110, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'electricidad', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:15:49.797662+00');
INSERT INTO public.events VALUES (111, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:15:51.244314+00');
INSERT INTO public.events VALUES (112, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:16:06.815613+00');
INSERT INTO public.events VALUES (113, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:16:09.749624+00');
INSERT INTO public.events VALUES (114, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:16:26.478031+00');
INSERT INTO public.events VALUES (115, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'electricidad', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:16:26.803257+00');
INSERT INTO public.events VALUES (116, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:16:28.972724+00');
INSERT INTO public.events VALUES (117, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:19:51.445126+00');
INSERT INTO public.events VALUES (118, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:20:54.859108+00');
INSERT INTO public.events VALUES (119, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'electricidad', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:21:01.866127+00');
INSERT INTO public.events VALUES (120, 1, NULL, 63, 'diagnostic_completed', 'Diagnostico', 'alto', '{"category": "electricidad", "risk_level": "alto", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:21:02.270019+00');
INSERT INTO public.events VALUES (121, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'electricidad', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:21:06.485852+00');
INSERT INTO public.events VALUES (122, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:21:06.497758+00');
INSERT INTO public.events VALUES (123, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:21:09.074768+00');
INSERT INTO public.events VALUES (124, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:21:31.533245+00');
INSERT INTO public.events VALUES (125, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:23:26.638251+00');
INSERT INTO public.events VALUES (126, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'electricidad', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:23:34.483634+00');
INSERT INTO public.events VALUES (127, 1, NULL, 64, 'diagnostic_completed', 'Diagnostico', 'alto', '{"category": "electricidad", "risk_level": "alto", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:23:34.833814+00');
INSERT INTO public.events VALUES (128, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:23:37.620723+00');
INSERT INTO public.events VALUES (129, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'electricidad', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:23:37.621284+00');
INSERT INTO public.events VALUES (130, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:23:39.161225+00');
INSERT INTO public.events VALUES (131, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:23:55.019462+00');
INSERT INTO public.events VALUES (132, 1, NULL, NULL, 'image_uploaded', 'Captura', 'camera', '{"category": "electrodomesticos", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:29:51.514908+00');
INSERT INTO public.events VALUES (133, 1, NULL, NULL, 'diagnostic_started', 'Captura', 'electricidad', '{"hasText": true, "hasImage": true, "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:30:00.009488+00');
INSERT INTO public.events VALUES (134, 1, NULL, 65, 'diagnostic_completed', 'Diagnostico', 'alto', '{"category": "electricidad", "risk_level": "alto", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:30:00.381407+00');
INSERT INTO public.events VALUES (135, 1, NULL, NULL, 'guide_step_viewed', 'Guia', '1', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:30:03.694044+00');
INSERT INTO public.events VALUES (136, 1, NULL, NULL, 'guide_opened', 'Diagnostico', 'electricidad', '{"session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:30:03.798859+00');
INSERT INTO public.events VALUES (137, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:30:05.655798+00');
INSERT INTO public.events VALUES (138, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Cali", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:30:07.776288+00');
INSERT INTO public.events VALUES (139, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Medellin", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:30:09.297707+00');
INSERT INTO public.events VALUES (140, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:30:11.350094+00');
INSERT INTO public.events VALUES (141, 1, NULL, NULL, 'technicians_list_viewed', 'Contacto', NULL, '{"city": "Bogota", "session_id": "787e0a82-cb60-4ce1-b953-8c3192682caf"}', '2026-01-08 16:30:43.470273+00');


--
-- Data for Name: guide_categories; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.guide_categories VALUES ('1b4b416d-07f9-480d-ad51-73c63168db5b', 'f742ded4-049b-4359-923e-c82f4dc697d7', '2026-01-07 14:51:28.034991+00');
INSERT INTO public.guide_categories VALUES ('1b4b416d-07f9-480d-ad51-73c63168db5b', 'fb805aa7-4c3d-4344-892e-8a9871344a75', '2026-01-07 14:51:28.034991+00');


--
-- Data for Name: guide_steps; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.guide_steps VALUES ('ea22fe1e-d84a-4ad2-b150-89184319f157', '1b4b416d-07f9-480d-ad51-73c63168db5b', 1, 'Quite la tapa del grifo', 'Con el destornillador, retire el tornillo de la parte superior o frontal. A veces está oculto bajo un tapón plástico (hágale palanca suave con la uña o una punta plástica).', 'assets/images/step1.jpg', 5, '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');
INSERT INTO public.guide_steps VALUES ('366fc653-c198-4420-bcdd-284129b15a05', '1b4b416d-07f9-480d-ad51-73c63168db5b', 2, 'Desenrosque el vástago', 'Use la llave inglesa. Gire hacia la izquierda (como abriendo la llave) hasta que salga la pieza. No haga fuerza bruta: si está duro, aplique movimiento corto y constante.', 'assets/images/step2.jpg', 7, '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');
INSERT INTO public.guide_steps VALUES ('cde9c2c5-62d6-480d-aafe-2d771b06f0c9', '1b4b416d-07f9-480d-ad51-73c63168db5b', 3, 'Cambie el empaque', 'La gomita negra de abajo es el empaque. Reemplácela por una nueva. Si la rosca se ve gastada, dé unas vueltas con cinta de teflón antes de volver a armar.', 'assets/images/step3.jpg', 8, '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');


--
-- Data for Name: guide_tools; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.guide_tools VALUES ('1b4b416d-07f9-480d-ad51-73c63168db5b', '3e98697b-ca26-43d8-9e78-79aff57aa64e', true, 1, '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');
INSERT INTO public.guide_tools VALUES ('1b4b416d-07f9-480d-ad51-73c63168db5b', '3c4eee30-948f-4f04-b3aa-3dfbeaa2eef6', true, 2, '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');
INSERT INTO public.guide_tools VALUES ('1b4b416d-07f9-480d-ad51-73c63168db5b', '947830e8-525f-499c-a93b-ff5e780e6c31', true, 3, '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');
INSERT INTO public.guide_tools VALUES ('1b4b416d-07f9-480d-ad51-73c63168db5b', '381da3b9-1f1c-4180-87ab-feab81abf9b5', true, 4, '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');
INSERT INTO public.guide_tools VALUES ('1b4b416d-07f9-480d-ad51-73c63168db5b', '554ab62a-8421-4ac9-92b3-9a112b6015a0', true, 5, '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');


--
-- Data for Name: guides; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.guides VALUES ('1b4b416d-07f9-480d-ad51-73c63168db5b', 'arreglando-la-gotera', 'Arreglando la gotera', 'Guía rápida para detener una fuga leve en el grifo (cambio de empaque y ajuste básico).', 20, 'basico', '¡Ojo! Seguridad ante todo', 'Antes de empezar, cierre la llave de paso del agua. Coloque un balde debajo y seque la zona para ver la fuga con claridad. Si hay cables cerca, apártelos y mantenga el área seca.', '¡Listo el pollo!', 'Vuelva a armar todo al revés de como lo desarmó. Abra la llave de paso y pruebe. Si no gotea, ¡éxito! Si persiste, puede requerir cambio de pieza o apoyo de un técnico.', NULL, true, 1, '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');


--
-- Data for Name: history; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.history VALUES (1, 1, NULL, 'Fuga en lavamanos', 'solucionado', '2025-12-31 12:07:28+00', NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7');
INSERT INTO public.history VALUES (2, 2, NULL, 'Tomacorriente con chispa', 'pendiente', '2025-12-31 12:07:28+00', NULL, '7f521992-116b-48a7-8388-4ac8c70db191');
INSERT INTO public.history VALUES (3, 3, NULL, 'Nevera no enfria', 'revisado', '2025-12-31 12:07:28+00', NULL, '14d38a9a-70b9-4986-8617-55712c3b38bc');
INSERT INTO public.history VALUES (4, NULL, NULL, 'Inodoro no descarga', 'pendiente', '2025-12-31 12:07:28+00', NULL, 'f742ded4-049b-4359-923e-c82f4dc697d7');


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.metrics VALUES (1, 1, 'b7a1f1e0-3a2b-4e5f-9a6f-1f2c3d4e5f60', 'android', 'view_inicio', '{}', 'Pixel 7 Pro', '1.0.0', '2026-01-01 19:30:04.513995+00');
INSERT INTO public.metrics VALUES (2, 1, 'b7a1f1e0-3a2b-4e5f-9a6f-1f2c3d4e5f60', 'android', 'start_diagnostic_click', '{"source": "inicio"}', 'Pixel 7 Pro', '1.0.0', '2026-01-01 19:31:04.513995+00');
INSERT INTO public.metrics VALUES (3, 1, 'b7a1f1e0-3a2b-4e5f-9a6f-1f2c3d4e5f60', 'android', 'submit_diagnostic', '{"hasText": true, "category": "electro", "hasImage": true}', 'Pixel 7 Pro', '1.0.0', '2026-01-01 19:32:04.513995+00');
INSERT INTO public.metrics VALUES (4, 1, 'b7a1f1e0-3a2b-4e5f-9a6f-1f2c3d4e5f60', 'android', 'view_diagnostico', '{"category": "electro", "riskLevel": "bajo"}', 'Pixel 7 Pro', '1.0.0', '2026-01-01 19:33:04.513995+00');
INSERT INTO public.metrics VALUES (5, 1, 'b7a1f1e0-3a2b-4e5f-9a6f-1f2c3d4e5f60', 'android', 'open_guide_click', '{"source": "diagnostico"}', 'Pixel 7 Pro', '1.0.0', '2026-01-01 19:34:04.513995+00');
INSERT INTO public.metrics VALUES (6, 2, 'f3c7b8a2-1c4d-4e7a-9b6a-2d1c0f9e8a77', 'ios', 'view_contacto', '{"city": "Bogota"}', 'iPhone 14', '1.0.1', '2026-01-01 19:35:04.513995+00');
INSERT INTO public.metrics VALUES (7, 2, 'f3c7b8a2-1c4d-4e7a-9b6a-2d1c0f9e8a77', 'ios', 'contact_whatsapp_click', '{"city": "Bogota"}', 'iPhone 14', '1.0.1', '2026-01-01 19:36:04.513995+00');
INSERT INTO public.metrics VALUES (8, 2, 'f3c7b8a2-1c4d-4e7a-9b6a-2d1c0f9e8a77', 'ios', 'view_historial', '{}', 'iPhone 14', '1.0.1', '2026-01-01 19:37:04.513995+00');
INSERT INTO public.metrics VALUES (9, 1, '547d6f8c-adb0-4259-84b8-4268e184f185', 'android', 'view_inicio', '{}', 'sdk_gphone64_x86_64', '1.0.0', '2026-01-02 16:14:32.901+00');
INSERT INTO public.metrics VALUES (10, 1, '547d6f8c-adb0-4259-84b8-4268e184f185', 'android', 'view_captura', '{}', 'sdk_gphone64_x86_64', '1.0.0', '2026-01-02 16:15:01.107+00');
INSERT INTO public.metrics VALUES (11, 1, '547d6f8c-adb0-4259-84b8-4268e184f185', 'android', 'submit_diagnostic', '{"hasText": false, "category": "electrodomesticos", "hasImage": true}', 'sdk_gphone64_x86_64', '1.0.0', '2026-01-02 16:15:18.252+00');
INSERT INTO public.metrics VALUES (12, 1, '547d6f8c-adb0-4259-84b8-4268e184f185', 'android', 'view_diagnostico', '{"category": "electrodomesticos", "riskLevel": "medio"}', 'sdk_gphone64_x86_64', '1.0.0', '2026-01-02 16:15:19.293+00');
INSERT INTO public.metrics VALUES (13, 1, '547d6f8c-adb0-4259-84b8-4268e184f185', 'android', 'view_guia', '{}', 'sdk_gphone64_x86_64', '1.0.0', '2026-01-02 16:15:22.496+00');
INSERT INTO public.metrics VALUES (14, 1, '547d6f8c-adb0-4259-84b8-4268e184f185', 'android', 'view_diagnostico', '{"category": "electrodomesticos", "riskLevel": "medio"}', 'sdk_gphone64_x86_64', '1.0.0', '2026-01-02 16:15:28.921+00');
INSERT INTO public.metrics VALUES (15, 1, '547d6f8c-adb0-4259-84b8-4268e184f185', 'android', 'view_inicio', '{}', 'sdk_gphone64_x86_64', '1.0.0', '2026-01-02 16:15:32.339+00');
INSERT INTO public.metrics VALUES (16, 1, '547d6f8c-adb0-4259-84b8-4268e184f185', 'android', 'view_inicio', '{}', 'sdk_gphone64_x86_64', '1.0.0', '2026-01-02 16:16:21.399+00');
INSERT INTO public.metrics VALUES (17, 1, '547d6f8c-adb0-4259-84b8-4268e184f185', 'android', 'view_inicio', '{}', 'sdk_gphone64_x86_64', '1.0.0', '2026-01-02 16:24:49.208+00');


--
-- Data for Name: technician_categories; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.technician_categories VALUES (1, 'f742ded4-049b-4359-923e-c82f4dc697d7', '2026-01-08 10:45:24.674913');
INSERT INTO public.technician_categories VALUES (4, 'f742ded4-049b-4359-923e-c82f4dc697d7', '2026-01-08 10:45:24.674913');
INSERT INTO public.technician_categories VALUES (7, 'f742ded4-049b-4359-923e-c82f4dc697d7', '2026-01-08 10:45:24.674913');
INSERT INTO public.technician_categories VALUES (2, '7f521992-116b-48a7-8388-4ac8c70db191', '2026-01-08 10:45:24.674913');
INSERT INTO public.technician_categories VALUES (5, '7f521992-116b-48a7-8388-4ac8c70db191', '2026-01-08 10:45:24.674913');
INSERT INTO public.technician_categories VALUES (8, '7f521992-116b-48a7-8388-4ac8c70db191', '2026-01-08 10:45:24.674913');
INSERT INTO public.technician_categories VALUES (3, '14d38a9a-70b9-4986-8617-55712c3b38bc', '2026-01-08 10:45:24.674913');
INSERT INTO public.technician_categories VALUES (6, '14d38a9a-70b9-4986-8617-55712c3b38bc', '2026-01-08 10:45:24.674913');
INSERT INTO public.technician_categories VALUES (3, 'fb805aa7-4c3d-4344-892e-8a9871344a75', '2026-01-08 10:45:24.674913');
INSERT INTO public.technician_categories VALUES (6, 'fb805aa7-4c3d-4344-892e-8a9871344a75', '2026-01-08 10:45:24.674913');


--
-- Data for Name: technician_reviews; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.technician_reviews VALUES (1, 1, 1, 5, 'Llego rapido y soluciono la fuga sin problemas.', '2025-12-31 12:07:28+00');
INSERT INTO public.technician_reviews VALUES (2, 1, 2, 4, 'Buen servicio, aunque llego un poco tarde.', '2025-12-31 12:07:28+00');
INSERT INTO public.technician_reviews VALUES (3, 2, 1, 5, 'Excelente electricista, muy profesional.', '2025-12-31 12:07:28+00');
INSERT INTO public.technician_reviews VALUES (4, 3, 3, 4, 'Arreglo la nevera, pero tardo mas de lo esperado.', '2025-12-31 12:07:28+00');
INSERT INTO public.technician_reviews VALUES (5, 4, 3, 5, 'Muy recomendado, dejo todo funcionando perfecto.', '2025-12-31 12:07:28+00');


--
-- Data for Name: technicians; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.technicians VALUES (1, 'Juan Perez', 'Plomero', 'Bogota', 'Chapinero', '3001112233', 4.80, 120, true, '2025-12-30 23:14:31+00', '2025-12-30 23:14:31+00');
INSERT INTO public.technicians VALUES (2, 'Carlos Ruiz', 'Electricista', 'Bogota', 'Usaquen', '3002223344', 4.60, 55, true, '2025-12-30 23:14:31+00', '2025-12-30 23:14:31+00');
INSERT INTO public.technicians VALUES (3, 'Maria Diaz', 'Tecnico de Electrodomesticos', 'Medellin', 'Laureles', '3003334455', 4.70, 80, true, '2025-12-30 23:14:31+00', '2025-12-30 23:14:31+00');
INSERT INTO public.technicians VALUES (4, 'Luis Martinez', 'Plomero', 'Bogota', 'Chapinero', '3105551111', 4.80, 124, true, '2025-12-31 12:07:28+00', '2025-12-31 12:07:28+00');
INSERT INTO public.technicians VALUES (5, 'Jorge Ramirez', 'Electricista', 'Bogota', 'Usaquen', '3105552222', 4.60, 89, true, '2025-12-31 12:07:28+00', '2025-12-31 12:07:28+00');
INSERT INTO public.technicians VALUES (7, 'Carlos Restrepo', 'Plomero', 'Medellin', 'Belen', '3105554444', 4.90, 76, true, '2025-12-31 12:07:28+00', '2025-12-31 12:07:28+00');
INSERT INTO public.technicians VALUES (8, 'Andres Lopez', 'Electricista', 'Medellin', 'Laureles', '3105555555', 4.50, 61, true, '2025-12-31 12:07:28+00', '2025-12-31 12:07:28+00');
INSERT INTO public.technicians VALUES (6, 'Maria Diaz cambio', 'Tecnico de Electrodomesticos', 'Cali', 'Campina', '3105553333', 4.70, 102, true, '2025-12-31 12:07:28+00', '2025-12-31 14:43:49+00');


--
-- Data for Name: tools; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.tools VALUES ('3e98697b-ca26-43d8-9e78-79aff57aa64e', 'destornillador-estrella', 'Destornillador de estrella', 'build', '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');
INSERT INTO public.tools VALUES ('3c4eee30-948f-4f04-b3aa-3dfbeaa2eef6', 'cinta-teflon', 'Cinta de teflón', 'content_cut', '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');
INSERT INTO public.tools VALUES ('947830e8-525f-499c-a93b-ff5e780e6c31', 'llave-inglesa', 'Llave de tubos (Inglesa)', 'build', '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');
INSERT INTO public.tools VALUES ('381da3b9-1f1c-4180-87ab-feab81abf9b5', 'trapo', 'Trapo o paño', 'cleaning_services', '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');
INSERT INTO public.tools VALUES ('554ab62a-8421-4ac9-92b3-9a112b6015a0', 'balde', 'Balde o recipiente', 'local_drink', '2026-01-07 14:51:28.034991+00', '2026-01-07 14:51:28.034991+00');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: qulepaso_db_user
--

INSERT INTO public.users VALUES (1, 'Carlos Ruiz', '3001112233', 'Bogota', 'Chapinero', '2025-12-31 12:07:28+00', '2025-12-31 12:07:28+00', '$2b$10$hash_simulado_carlos');
INSERT INTO public.users VALUES (2, 'Ana Gomez', '3002223344', 'Bogota', 'Suba', '2025-12-31 12:07:28+00', '2025-12-31 12:07:28+00', '$2b$10$hash_simulado_ana');
INSERT INTO public.users VALUES (3, 'Juan Perez', '3003334455', 'Medellin', 'Laureles', '2025-12-31 12:07:28+00', '2025-12-31 12:07:28+00', '$2b$10$hash_simulado_juan');


--
-- Name: devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qulepaso_db_user
--

SELECT pg_catalog.setval('public.devices_id_seq', 1, true);


--
-- Name: diagnostics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qulepaso_db_user
--

SELECT pg_catalog.setval('public.diagnostics_id_seq', 65, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qulepaso_db_user
--

SELECT pg_catalog.setval('public.events_id_seq', 141, true);


--
-- Name: history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qulepaso_db_user
--

SELECT pg_catalog.setval('public.history_id_seq', 4, true);


--
-- Name: metrics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qulepaso_db_user
--

SELECT pg_catalog.setval('public.metrics_id_seq', 17, true);


--
-- Name: technician_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qulepaso_db_user
--

SELECT pg_catalog.setval('public.technician_reviews_id_seq', 5, true);


--
-- Name: technicians_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qulepaso_db_user
--

SELECT pg_catalog.setval('public.technicians_id_seq', 8, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qulepaso_db_user
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: diagnostics diagnostics_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT diagnostics_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: guide_categories guide_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.guide_categories
    ADD CONSTRAINT guide_categories_pkey PRIMARY KEY (guide_id, category_id);


--
-- Name: guide_steps guide_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.guide_steps
    ADD CONSTRAINT guide_steps_pkey PRIMARY KEY (id);


--
-- Name: guide_tools guide_tools_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.guide_tools
    ADD CONSTRAINT guide_tools_pkey PRIMARY KEY (guide_id, tool_id);


--
-- Name: guides guides_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.guides
    ADD CONSTRAINT guides_pkey PRIMARY KEY (id);


--
-- Name: guides guides_slug_key; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.guides
    ADD CONSTRAINT guides_slug_key UNIQUE (slug);


--
-- Name: history history_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- Name: metrics metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_pkey PRIMARY KEY (id);


--
-- Name: technician_categories technician_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.technician_categories
    ADD CONSTRAINT technician_categories_pkey PRIMARY KEY (technician_id, category_id);


--
-- Name: technician_reviews technician_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.technician_reviews
    ADD CONSTRAINT technician_reviews_pkey PRIMARY KEY (id);


--
-- Name: technicians technicians_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.technicians
    ADD CONSTRAINT technicians_pkey PRIMARY KEY (id);


--
-- Name: tools tools_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (id);


--
-- Name: tools tools_slug_key; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_slug_key UNIQUE (slug);


--
-- Name: devices uk_devices_uuid; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT uk_devices_uuid UNIQUE (device_uuid);


--
-- Name: guide_steps uq_guide_steps_guide_step; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.guide_steps
    ADD CONSTRAINT uq_guide_steps_guide_step UNIQUE (guide_id, step_number);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_categories_active_order; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_categories_active_order ON public.categories USING btree (is_active, order_index);


--
-- Name: idx_categories_quick_order; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_categories_quick_order ON public.categories USING btree (is_quick, order_index);


--
-- Name: idx_devices_city; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_devices_city ON public.devices USING btree (city);


--
-- Name: idx_diag_device_created; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_diag_device_created ON public.diagnostics USING btree (device_id, created_at);


--
-- Name: idx_diag_user_created; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_diag_user_created ON public.diagnostics USING btree (user_id, created_at);


--
-- Name: idx_diagnostics_category_id_created; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_diagnostics_category_id_created ON public.diagnostics USING btree (category_id, created_at DESC);


--
-- Name: idx_diagnostics_guide_id_created; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_diagnostics_guide_id_created ON public.diagnostics USING btree (guide_id, created_at DESC);


--
-- Name: idx_events_device_time; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_events_device_time ON public.events USING btree (device_id, created_at);


--
-- Name: idx_events_diag_time; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_events_diag_time ON public.events USING btree (diagnostic_id, created_at);


--
-- Name: idx_events_name_time; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_events_name_time ON public.events USING btree (event_name, created_at);


--
-- Name: idx_guide_categories_category; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_guide_categories_category ON public.guide_categories USING btree (category_id);


--
-- Name: idx_guide_steps_guide_step; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_guide_steps_guide_step ON public.guide_steps USING btree (guide_id, step_number);


--
-- Name: idx_guide_tools_guide_order; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_guide_tools_guide_order ON public.guide_tools USING btree (guide_id, order_index);


--
-- Name: idx_guides_active_slug; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_guides_active_slug ON public.guides USING btree (is_active, slug);


--
-- Name: idx_history_category_id_created; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_history_category_id_created ON public.history USING btree (category_id, created_at DESC);


--
-- Name: idx_history_device_created; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_history_device_created ON public.history USING btree (device_id, created_at);


--
-- Name: idx_history_diag; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_history_diag ON public.history USING btree (diagnostic_id);


--
-- Name: idx_history_status_created; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_history_status_created ON public.history USING btree (status, created_at);


--
-- Name: idx_history_user_created; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_history_user_created ON public.history USING btree (user_id, created_at);


--
-- Name: idx_metrics_created_at; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_metrics_created_at ON public.metrics USING btree (created_at);


--
-- Name: idx_metrics_event; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_metrics_event ON public.metrics USING btree (event);


--
-- Name: idx_metrics_event_created; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_metrics_event_created ON public.metrics USING btree (event, created_at);


--
-- Name: idx_metrics_platform; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_metrics_platform ON public.metrics USING btree (platform);


--
-- Name: idx_metrics_session_id; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_metrics_session_id ON public.metrics USING btree (session_id);


--
-- Name: idx_metrics_user_id; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_metrics_user_id ON public.metrics USING btree (user_id);


--
-- Name: idx_technicians_city_active; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_technicians_city_active ON public.technicians USING btree (city, active);


--
-- Name: idx_technicians_role_city; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_technicians_role_city ON public.technicians USING btree (role, city);


--
-- Name: idx_tr_technician; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_tr_technician ON public.technician_reviews USING btree (technician_id);


--
-- Name: idx_tr_user; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX idx_tr_user ON public.technician_reviews USING btree (user_id);


--
-- Name: technician_categories_category_idx; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX technician_categories_category_idx ON public.technician_categories USING btree (category_id);


--
-- Name: technician_categories_technician_idx; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE INDEX technician_categories_technician_idx ON public.technician_categories USING btree (technician_id);


--
-- Name: uk_technicians_phone; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE UNIQUE INDEX uk_technicians_phone ON public.technicians USING btree (phone);


--
-- Name: uk_users_phone; Type: INDEX; Schema: public; Owner: qulepaso_db_user
--

CREATE UNIQUE INDEX uk_users_phone ON public.users USING btree (phone);


--
-- Name: categories trg_categories_updated_at; Type: TRIGGER; Schema: public; Owner: qulepaso_db_user
--

CREATE TRIGGER trg_categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.set_updated_at_categories();


--
-- Name: guide_steps trg_guide_steps_updated_at; Type: TRIGGER; Schema: public; Owner: qulepaso_db_user
--

CREATE TRIGGER trg_guide_steps_updated_at BEFORE UPDATE ON public.guide_steps FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: guide_tools trg_guide_tools_updated_at; Type: TRIGGER; Schema: public; Owner: qulepaso_db_user
--

CREATE TRIGGER trg_guide_tools_updated_at BEFORE UPDATE ON public.guide_tools FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: guides trg_guides_updated_at; Type: TRIGGER; Schema: public; Owner: qulepaso_db_user
--

CREATE TRIGGER trg_guides_updated_at BEFORE UPDATE ON public.guides FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: tools trg_tools_updated_at; Type: TRIGGER; Schema: public; Owner: qulepaso_db_user
--

CREATE TRIGGER trg_tools_updated_at BEFORE UPDATE ON public.tools FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: diagnostics diagnostics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT diagnostics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: diagnostics fk_diagnostics_category; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT fk_diagnostics_category FOREIGN KEY (category_id) REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: diagnostics fk_diagnostics_device; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT fk_diagnostics_device FOREIGN KEY (device_id) REFERENCES public.devices(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: diagnostics fk_diagnostics_guide; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT fk_diagnostics_guide FOREIGN KEY (guide_id) REFERENCES public.guides(id) ON DELETE SET NULL;


--
-- Name: events fk_events_device; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_events_device FOREIGN KEY (device_id) REFERENCES public.devices(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: events fk_events_diagnostic; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_events_diagnostic FOREIGN KEY (diagnostic_id) REFERENCES public.diagnostics(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: events fk_events_user; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_events_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: history fk_history_category; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT fk_history_category FOREIGN KEY (category_id) REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: history fk_history_device; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT fk_history_device FOREIGN KEY (device_id) REFERENCES public.devices(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: guide_categories guide_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.guide_categories
    ADD CONSTRAINT guide_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- Name: guide_categories guide_categories_guide_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.guide_categories
    ADD CONSTRAINT guide_categories_guide_id_fkey FOREIGN KEY (guide_id) REFERENCES public.guides(id) ON DELETE CASCADE;


--
-- Name: guide_steps guide_steps_guide_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.guide_steps
    ADD CONSTRAINT guide_steps_guide_id_fkey FOREIGN KEY (guide_id) REFERENCES public.guides(id) ON DELETE CASCADE;


--
-- Name: guide_tools guide_tools_guide_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.guide_tools
    ADD CONSTRAINT guide_tools_guide_id_fkey FOREIGN KEY (guide_id) REFERENCES public.guides(id) ON DELETE CASCADE;


--
-- Name: guide_tools guide_tools_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.guide_tools
    ADD CONSTRAINT guide_tools_tool_id_fkey FOREIGN KEY (tool_id) REFERENCES public.tools(id) ON DELETE RESTRICT;


--
-- Name: history history_diagnostic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_diagnostic_id_fkey FOREIGN KEY (diagnostic_id) REFERENCES public.diagnostics(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: history history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: metrics metrics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: technician_categories technician_categories_category_fk; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.technician_categories
    ADD CONSTRAINT technician_categories_category_fk FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: technician_categories technician_categories_technician_fk; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.technician_categories
    ADD CONSTRAINT technician_categories_technician_fk FOREIGN KEY (technician_id) REFERENCES public.technicians(id) ON DELETE CASCADE;


--
-- Name: technician_reviews technician_reviews_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.technician_reviews
    ADD CONSTRAINT technician_reviews_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: technician_reviews technician_reviews_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: qulepaso_db_user
--

ALTER TABLE ONLY public.technician_reviews
    ADD CONSTRAINT technician_reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict fMItqdaZwHbV6UAwdHIzO28HD80faD7W4FhpAR29b0K0ioDXLmzdKERSY0pLUfi
