--
-- PostgreSQL database dump
--

\restrict IeE96CRjJ62ildEcNTNJikP7jyCQkYxhWU0k8to1vP5mbNLZnznbQxm1XxTsF5E

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: device_platform_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.device_platform_enum AS ENUM (
    'android',
    'ios',
    'web'
);


--
-- Name: diagnostic_resolution_action_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.diagnostic_resolution_action_enum AS ENUM (
    'diy',
    'contact_technician',
    'warning_only'
);


--
-- Name: event_name_enum; Type: TYPE; Schema: public; Owner: -
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


--
-- Name: history_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.history_status_enum AS ENUM (
    'solucionado',
    'pendiente',
    'revisado',
    'cancelado'
);


--
-- Name: risk_level_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.risk_level_enum AS ENUM (
    'bajo',
    'medio',
    'alto'
);


--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--
-- Name: set_updated_at_categories(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_updated_at_categories() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: devices; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devices_id_seq OWNED BY public.devices.id;


--
-- Name: diagnostics; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: diagnostics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.diagnostics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diagnostics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.diagnostics_id_seq OWNED BY public.diagnostics.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: guide_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guide_categories (
    guide_id uuid NOT NULL,
    category_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: guide_steps; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: guide_tools; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guide_tools (
    guide_id uuid NOT NULL,
    tool_id uuid NOT NULL,
    is_required boolean DEFAULT true NOT NULL,
    order_index integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: guides; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: history; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.history_id_seq OWNED BY public.history.id;


--
-- Name: metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metrics (
    id bigint NOT NULL,
    user_id integer,
    session_id uuid,
    platform character varying(10),
    event character varying(80) NOT NULL,
    data jsonb,
    device character varying(80),
    app_version character varying(20),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metrics_id_seq OWNED BY public.metrics.id;


--
-- Name: technician_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.technician_categories (
    technician_id integer NOT NULL,
    category_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: technician_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.technician_reviews (
    id bigint NOT NULL,
    technician_id bigint NOT NULL,
    user_id bigint,
    rating smallint NOT NULL,
    comment character varying(600),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: technician_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.technician_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: technician_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.technician_reviews_id_seq OWNED BY public.technician_reviews.id;


--
-- Name: technicians; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: technicians_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.technicians_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: technicians_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.technicians_id_seq OWNED BY public.technicians.id;


--
-- Name: tools; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tools (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    slug character varying(80) NOT NULL,
    name character varying(120) NOT NULL,
    icon character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: devices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices ALTER COLUMN id SET DEFAULT nextval('public.devices_id_seq'::regclass);


--
-- Name: diagnostics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnostics ALTER COLUMN id SET DEFAULT nextval('public.diagnostics_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.history ALTER COLUMN id SET DEFAULT nextval('public.history_id_seq'::regclass);


--
-- Name: metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics ALTER COLUMN id SET DEFAULT nextval('public.metrics_id_seq'::regclass);


--
-- Name: technician_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technician_reviews ALTER COLUMN id SET DEFAULT nextval('public.technician_reviews_id_seq'::regclass);


--
-- Name: technicians id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technicians ALTER COLUMN id SET DEFAULT nextval('public.technicians_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: diagnostics diagnostics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT diagnostics_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: guide_categories guide_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guide_categories
    ADD CONSTRAINT guide_categories_pkey PRIMARY KEY (guide_id, category_id);


--
-- Name: guide_steps guide_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guide_steps
    ADD CONSTRAINT guide_steps_pkey PRIMARY KEY (id);


--
-- Name: guide_tools guide_tools_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guide_tools
    ADD CONSTRAINT guide_tools_pkey PRIMARY KEY (guide_id, tool_id);


--
-- Name: guides guides_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guides
    ADD CONSTRAINT guides_pkey PRIMARY KEY (id);


--
-- Name: guides guides_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guides
    ADD CONSTRAINT guides_slug_key UNIQUE (slug);


--
-- Name: history history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- Name: metrics metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_pkey PRIMARY KEY (id);


--
-- Name: technician_categories technician_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technician_categories
    ADD CONSTRAINT technician_categories_pkey PRIMARY KEY (technician_id, category_id);


--
-- Name: technician_reviews technician_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technician_reviews
    ADD CONSTRAINT technician_reviews_pkey PRIMARY KEY (id);


--
-- Name: technicians technicians_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technicians
    ADD CONSTRAINT technicians_pkey PRIMARY KEY (id);


--
-- Name: tools tools_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (id);


--
-- Name: tools tools_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_slug_key UNIQUE (slug);


--
-- Name: devices uk_devices_uuid; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT uk_devices_uuid UNIQUE (device_uuid);


--
-- Name: guide_steps uq_guide_steps_guide_step; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guide_steps
    ADD CONSTRAINT uq_guide_steps_guide_step UNIQUE (guide_id, step_number);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_categories_active_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_categories_active_order ON public.categories USING btree (is_active, order_index);


--
-- Name: idx_categories_quick_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_categories_quick_order ON public.categories USING btree (is_quick, order_index);


--
-- Name: idx_devices_city; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_devices_city ON public.devices USING btree (city);


--
-- Name: idx_diag_device_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_diag_device_created ON public.diagnostics USING btree (device_id, created_at);


--
-- Name: idx_diag_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_diag_user_created ON public.diagnostics USING btree (user_id, created_at);


--
-- Name: idx_diagnostics_category_id_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_diagnostics_category_id_created ON public.diagnostics USING btree (category_id, created_at DESC);


--
-- Name: idx_diagnostics_guide_id_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_diagnostics_guide_id_created ON public.diagnostics USING btree (guide_id, created_at DESC);


--
-- Name: idx_events_device_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_device_time ON public.events USING btree (device_id, created_at);


--
-- Name: idx_events_diag_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_diag_time ON public.events USING btree (diagnostic_id, created_at);


--
-- Name: idx_events_name_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_name_time ON public.events USING btree (event_name, created_at);


--
-- Name: idx_guide_categories_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guide_categories_category ON public.guide_categories USING btree (category_id);


--
-- Name: idx_guide_steps_guide_step; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guide_steps_guide_step ON public.guide_steps USING btree (guide_id, step_number);


--
-- Name: idx_guide_tools_guide_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guide_tools_guide_order ON public.guide_tools USING btree (guide_id, order_index);


--
-- Name: idx_guides_active_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guides_active_slug ON public.guides USING btree (is_active, slug);


--
-- Name: idx_history_category_id_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_history_category_id_created ON public.history USING btree (category_id, created_at DESC);


--
-- Name: idx_history_device_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_history_device_created ON public.history USING btree (device_id, created_at);


--
-- Name: idx_history_diag; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_history_diag ON public.history USING btree (diagnostic_id);


--
-- Name: idx_history_status_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_history_status_created ON public.history USING btree (status, created_at);


--
-- Name: idx_history_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_history_user_created ON public.history USING btree (user_id, created_at);


--
-- Name: idx_metrics_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_metrics_created_at ON public.metrics USING btree (created_at);


--
-- Name: idx_metrics_event; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_metrics_event ON public.metrics USING btree (event);


--
-- Name: idx_metrics_event_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_metrics_event_created ON public.metrics USING btree (event, created_at);


--
-- Name: idx_metrics_platform; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_metrics_platform ON public.metrics USING btree (platform);


--
-- Name: idx_metrics_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_metrics_session_id ON public.metrics USING btree (session_id);


--
-- Name: idx_metrics_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_metrics_user_id ON public.metrics USING btree (user_id);


--
-- Name: idx_technicians_city_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_technicians_city_active ON public.technicians USING btree (city, active);


--
-- Name: idx_technicians_role_city; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_technicians_role_city ON public.technicians USING btree (role, city);


--
-- Name: idx_tr_technician; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tr_technician ON public.technician_reviews USING btree (technician_id);


--
-- Name: idx_tr_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tr_user ON public.technician_reviews USING btree (user_id);


--
-- Name: technician_categories_category_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX technician_categories_category_idx ON public.technician_categories USING btree (category_id);


--
-- Name: technician_categories_technician_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX technician_categories_technician_idx ON public.technician_categories USING btree (technician_id);


--
-- Name: uk_technicians_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_technicians_phone ON public.technicians USING btree (phone);


--
-- Name: uk_users_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_users_phone ON public.users USING btree (phone);


--
-- Name: categories trg_categories_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.set_updated_at_categories();


--
-- Name: guide_steps trg_guide_steps_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_guide_steps_updated_at BEFORE UPDATE ON public.guide_steps FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: guide_tools trg_guide_tools_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_guide_tools_updated_at BEFORE UPDATE ON public.guide_tools FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: guides trg_guides_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_guides_updated_at BEFORE UPDATE ON public.guides FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: tools trg_tools_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_tools_updated_at BEFORE UPDATE ON public.tools FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: diagnostics diagnostics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT diagnostics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: diagnostics fk_diagnostics_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT fk_diagnostics_category FOREIGN KEY (category_id) REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: diagnostics fk_diagnostics_device; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT fk_diagnostics_device FOREIGN KEY (device_id) REFERENCES public.devices(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: diagnostics fk_diagnostics_guide; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT fk_diagnostics_guide FOREIGN KEY (guide_id) REFERENCES public.guides(id) ON DELETE SET NULL;


--
-- Name: events fk_events_device; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_events_device FOREIGN KEY (device_id) REFERENCES public.devices(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: events fk_events_diagnostic; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_events_diagnostic FOREIGN KEY (diagnostic_id) REFERENCES public.diagnostics(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: events fk_events_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_events_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: history fk_history_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT fk_history_category FOREIGN KEY (category_id) REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: history fk_history_device; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT fk_history_device FOREIGN KEY (device_id) REFERENCES public.devices(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: guide_categories guide_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guide_categories
    ADD CONSTRAINT guide_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- Name: guide_categories guide_categories_guide_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guide_categories
    ADD CONSTRAINT guide_categories_guide_id_fkey FOREIGN KEY (guide_id) REFERENCES public.guides(id) ON DELETE CASCADE;


--
-- Name: guide_steps guide_steps_guide_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guide_steps
    ADD CONSTRAINT guide_steps_guide_id_fkey FOREIGN KEY (guide_id) REFERENCES public.guides(id) ON DELETE CASCADE;


--
-- Name: guide_tools guide_tools_guide_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guide_tools
    ADD CONSTRAINT guide_tools_guide_id_fkey FOREIGN KEY (guide_id) REFERENCES public.guides(id) ON DELETE CASCADE;


--
-- Name: guide_tools guide_tools_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guide_tools
    ADD CONSTRAINT guide_tools_tool_id_fkey FOREIGN KEY (tool_id) REFERENCES public.tools(id) ON DELETE RESTRICT;


--
-- Name: history history_diagnostic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_diagnostic_id_fkey FOREIGN KEY (diagnostic_id) REFERENCES public.diagnostics(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: history history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: metrics metrics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: technician_categories technician_categories_category_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technician_categories
    ADD CONSTRAINT technician_categories_category_fk FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: technician_categories technician_categories_technician_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technician_categories
    ADD CONSTRAINT technician_categories_technician_fk FOREIGN KEY (technician_id) REFERENCES public.technicians(id) ON DELETE CASCADE;


--
-- Name: technician_reviews technician_reviews_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technician_reviews
    ADD CONSTRAINT technician_reviews_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: technician_reviews technician_reviews_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technician_reviews
    ADD CONSTRAINT technician_reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict IeE96CRjJ62ildEcNTNJikP7jyCQkYxhWU0k8to1vP5mbNLZnznbQxm1XxTsF5E

