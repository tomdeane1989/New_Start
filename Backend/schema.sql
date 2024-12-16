--
-- PostgreSQL database dump
--

-- Dumped from database version 14.13 (Homebrew)
-- Dumped by pg_dump version 14.13 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: enum_projectcollaborators_role; Type: TYPE; Schema: public; Owner: thomasdeane
--

CREATE TYPE public.enum_projectcollaborators_role AS ENUM (
    'Buyer',
    'Seller',
    'Mortgage Advisor',
    'Seller Solicitor',
    'Buyer Solicitor',
    'Estate Agent'
);


ALTER TYPE public.enum_projectcollaborators_role OWNER TO thomasdeane;

--
-- Name: enum_projects_status; Type: TYPE; Schema: public; Owner: thomasdeane
--

CREATE TYPE public.enum_projects_status AS ENUM (
    'active',
    'completed',
    'archived'
);


ALTER TYPE public.enum_projects_status OWNER TO thomasdeane;

--
-- Name: primary_party_enum; Type: TYPE; Schema: public; Owner: thomasdeane
--

CREATE TYPE public.primary_party_enum AS ENUM (
    'Buyer',
    'Seller'
);


ALTER TYPE public.primary_party_enum OWNER TO thomasdeane;

--
-- Name: role_name_enum; Type: TYPE; Schema: public; Owner: thomasdeane
--

CREATE TYPE public.role_name_enum AS ENUM (
    'Buyer',
    'Seller',
    'Agent',
    'Solicitor',
    'Owner',
    'Buyer Solicitor',
    'Seller Solicitor',
    'Estate Agent',
    'Mortgage Advisor'
);


ALTER TYPE public.role_name_enum OWNER TO thomasdeane;

--
-- Name: update_projects_timestamp(); Type: FUNCTION; Schema: public; Owner: thomasdeane
--

CREATE FUNCTION public.update_projects_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_projects_timestamp() OWNER TO thomasdeane;

--
-- Name: update_roles_timestamp(); Type: FUNCTION; Schema: public; Owner: thomasdeane
--

CREATE FUNCTION public.update_roles_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_roles_timestamp() OWNER TO thomasdeane;

--
-- Name: update_timestamp(); Type: FUNCTION; Schema: public; Owner: thomasdeane
--

CREATE FUNCTION public.update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_timestamp() OWNER TO thomasdeane;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: SequelizeMeta; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE public."SequelizeMeta" OWNER TO thomasdeane;

--
-- Name: collaborator_audit; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.collaborator_audit (
    audit_id integer NOT NULL,
    collaborator_id integer,
    change_type character varying(50),
    old_value character varying(255),
    new_value character varying(255),
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.collaborator_audit OWNER TO thomasdeane;

--
-- Name: collaborator_audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.collaborator_audit_audit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collaborator_audit_audit_id_seq OWNER TO thomasdeane;

--
-- Name: collaborator_audit_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.collaborator_audit_audit_id_seq OWNED BY public.collaborator_audit.audit_id;


--
-- Name: collaborator_role_attributes; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.collaborator_role_attributes (
    id integer NOT NULL,
    collaborator_id integer,
    attribute_key character varying(255),
    attribute_value character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.collaborator_role_attributes OWNER TO thomasdeane;

--
-- Name: collaborator_role_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.collaborator_role_attributes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collaborator_role_attributes_id_seq OWNER TO thomasdeane;

--
-- Name: collaborator_role_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.collaborator_role_attributes_id_seq OWNED BY public.collaborator_role_attributes.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.companies (
    company_id integer NOT NULL,
    company_name character varying(255) NOT NULL,
    company_email character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    owner_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.companies OWNER TO thomasdeane;

--
-- Name: companies_company_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.companies_company_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.companies_company_id_seq OWNER TO thomasdeane;

--
-- Name: companies_company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.companies_company_id_seq OWNED BY public.companies.company_id;


--
-- Name: project_status_history; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.project_status_history (
    history_id integer NOT NULL,
    project_id integer,
    old_status character varying(255) NOT NULL,
    new_status character varying(255) NOT NULL,
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.project_status_history OWNER TO thomasdeane;

--
-- Name: project_status_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.project_status_history_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_status_history_history_id_seq OWNER TO thomasdeane;

--
-- Name: project_status_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.project_status_history_history_id_seq OWNED BY public.project_status_history.history_id;


--
-- Name: projectcollaborators; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.projectcollaborators (
    collaborator_id integer NOT NULL,
    project_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    role integer DEFAULT 0 NOT NULL,
    assigned_at timestamp with time zone,
    CONSTRAINT role_check CHECK (((role >= 0) AND (role <= 7)))
);


ALTER TABLE public.projectcollaborators OWNER TO thomasdeane;

--
-- Name: projectcollaborators_collaborator_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.projectcollaborators_collaborator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projectcollaborators_collaborator_id_seq OWNER TO thomasdeane;

--
-- Name: projectcollaborators_collaborator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.projectcollaborators_collaborator_id_seq OWNED BY public.projectcollaborators.collaborator_id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.projects (
    project_id integer NOT NULL,
    project_name character varying(255) NOT NULL,
    description text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    status public.enum_projects_status DEFAULT 'active'::public.enum_projects_status,
    owner_id integer NOT NULL
);


ALTER TABLE public.projects OWNER TO thomasdeane;

--
-- Name: projects_project_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.projects_project_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_project_id_seq OWNER TO thomasdeane;

--
-- Name: projects_project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.projects_project_id_seq OWNED BY public.projects.project_id;


--
-- Name: role_attributes; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.role_attributes (
    attribute_id integer NOT NULL,
    role_id integer,
    attribute_key character varying(255),
    attribute_value character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.role_attributes OWNER TO thomasdeane;

--
-- Name: role_attributes_attribute_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.role_attributes_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_attributes_attribute_id_seq OWNER TO thomasdeane;

--
-- Name: role_attributes_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.role_attributes_attribute_id_seq OWNED BY public.role_attributes.attribute_id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.roles (
    role_id integer NOT NULL,
    role_name public.role_name_enum NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    description text
);


ALTER TABLE public.roles OWNER TO thomasdeane;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_role_id_seq OWNER TO thomasdeane;

--
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;


--
-- Name: stages; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.stages (
    stage_id integer NOT NULL,
    stage_name character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    project_id integer NOT NULL,
    stage_order integer NOT NULL,
    is_custom boolean DEFAULT false
);


ALTER TABLE public.stages OWNER TO thomasdeane;

--
-- Name: stages_stage_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.stages_stage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stages_stage_id_seq OWNER TO thomasdeane;

--
-- Name: stages_stage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.stages_stage_id_seq OWNED BY public.stages.stage_id;


--
-- Name: taskassignments; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.taskassignments (
    assignment_id integer NOT NULL,
    task_id integer NOT NULL,
    user_id integer NOT NULL,
    can_edit boolean DEFAULT false,
    can_view boolean DEFAULT true
);


ALTER TABLE public.taskassignments OWNER TO thomasdeane;

--
-- Name: taskassignments_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.taskassignments_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taskassignments_assignment_id_seq OWNER TO thomasdeane;

--
-- Name: taskassignments_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.taskassignments_assignment_id_seq OWNED BY public.taskassignments.assignment_id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.tasks (
    task_id integer NOT NULL,
    project_id integer NOT NULL,
    stage_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    task_name character varying(255) NOT NULL,
    is_completed boolean DEFAULT false,
    owner_id integer,
    description character varying(255),
    due_date timestamp with time zone,
    priority character varying(255)
);


ALTER TABLE public.tasks OWNER TO thomasdeane;

--
-- Name: tasks_task_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.tasks_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasks_task_id_seq OWNER TO thomasdeane;

--
-- Name: tasks_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.tasks_task_id_seq OWNED BY public.tasks.task_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    is_active boolean DEFAULT true,
    first_name character varying(255),
    last_name character varying(255),
    company_id integer
);


ALTER TABLE public.users OWNER TO thomasdeane;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO thomasdeane;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: collaborator_audit audit_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.collaborator_audit ALTER COLUMN audit_id SET DEFAULT nextval('public.collaborator_audit_audit_id_seq'::regclass);


--
-- Name: collaborator_role_attributes id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.collaborator_role_attributes ALTER COLUMN id SET DEFAULT nextval('public.collaborator_role_attributes_id_seq'::regclass);


--
-- Name: companies company_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies ALTER COLUMN company_id SET DEFAULT nextval('public.companies_company_id_seq'::regclass);


--
-- Name: project_status_history history_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.project_status_history ALTER COLUMN history_id SET DEFAULT nextval('public.project_status_history_history_id_seq'::regclass);


--
-- Name: projectcollaborators collaborator_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.projectcollaborators ALTER COLUMN collaborator_id SET DEFAULT nextval('public.projectcollaborators_collaborator_id_seq'::regclass);


--
-- Name: projects project_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.projects ALTER COLUMN project_id SET DEFAULT nextval('public.projects_project_id_seq'::regclass);


--
-- Name: role_attributes attribute_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.role_attributes ALTER COLUMN attribute_id SET DEFAULT nextval('public.role_attributes_attribute_id_seq'::regclass);


--
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);


--
-- Name: stages stage_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.stages ALTER COLUMN stage_id SET DEFAULT nextval('public.stages_stage_id_seq'::regclass);


--
-- Name: taskassignments assignment_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.taskassignments ALTER COLUMN assignment_id SET DEFAULT nextval('public.taskassignments_assignment_id_seq'::regclass);


--
-- Name: tasks task_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.tasks ALTER COLUMN task_id SET DEFAULT nextval('public.tasks_task_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- Name: collaborator_audit collaborator_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.collaborator_audit
    ADD CONSTRAINT collaborator_audit_pkey PRIMARY KEY (audit_id);


--
-- Name: collaborator_role_attributes collaborator_role_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.collaborator_role_attributes
    ADD CONSTRAINT collaborator_role_attributes_pkey PRIMARY KEY (id);


--
-- Name: companies companies_company_email_key; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key UNIQUE (company_email);


--
-- Name: companies companies_company_email_key1; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key1 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key10; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key10 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key11; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key11 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key12; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key12 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key13; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key13 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key14; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key14 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key15; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key15 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key16; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key16 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key17; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key17 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key18; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key18 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key19; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key19 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key2; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key2 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key20; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key20 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key21; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key21 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key22; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key22 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key23; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key23 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key24; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key24 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key25; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key25 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key26; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key26 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key27; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key27 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key28; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key28 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key29; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key29 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key3; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key3 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key30; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key30 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key31; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key31 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key32; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key32 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key33; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key33 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key34; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key34 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key35; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key35 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key36; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key36 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key37; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key37 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key38; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key38 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key39; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key39 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key4; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key4 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key40; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key40 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key41; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key41 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key42; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key42 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key43; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key43 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key44; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key44 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key45; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key45 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key46; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key46 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key47; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key47 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key48; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key48 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key49; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key49 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key5; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key5 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key50; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key50 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key51; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key51 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key52; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key52 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key53; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key53 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key54; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key54 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key55; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key55 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key56; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key56 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key57; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key57 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key58; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key58 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key59; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key59 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key6; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key6 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key60; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key60 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key61; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key61 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key62; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key62 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key63; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key63 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key64; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key64 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key65; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key65 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key66; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key66 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key67; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key67 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key68; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key68 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key69; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key69 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key7; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key7 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key70; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key70 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key71; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key71 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key72; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key72 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key73; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key73 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key74; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key74 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key75; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key75 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key76; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key76 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key77; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key77 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key78; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key78 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key79; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key79 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key8; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key8 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key80; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key80 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key81; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key81 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key82; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key82 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key83; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key83 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key84; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key84 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key85; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key85 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key86; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key86 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key87; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key87 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key88; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key88 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key89; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key89 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key9; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key9 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key90; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key90 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key91; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key91 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key92; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key92 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key93; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key93 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key94; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key94 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key95; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key95 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key96; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key96 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key97; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key97 UNIQUE (company_email);


--
-- Name: companies companies_company_name_key; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key UNIQUE (company_name);


--
-- Name: companies companies_company_name_key1; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key1 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key10; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key10 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key11; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key11 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key12; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key12 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key13; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key13 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key14; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key14 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key15; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key15 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key16; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key16 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key17; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key17 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key18; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key18 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key19; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key19 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key2; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key2 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key20; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key20 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key21; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key21 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key22; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key22 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key23; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key23 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key24; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key24 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key25; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key25 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key26; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key26 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key27; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key27 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key28; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key28 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key29; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key29 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key3; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key3 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key30; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key30 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key31; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key31 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key32; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key32 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key33; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key33 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key34; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key34 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key35; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key35 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key36; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key36 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key37; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key37 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key38; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key38 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key39; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key39 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key4; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key4 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key40; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key40 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key41; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key41 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key42; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key42 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key43; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key43 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key44; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key44 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key45; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key45 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key46; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key46 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key47; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key47 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key48; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key48 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key49; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key49 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key5; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key5 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key50; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key50 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key51; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key51 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key52; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key52 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key53; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key53 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key54; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key54 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key55; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key55 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key56; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key56 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key57; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key57 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key58; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key58 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key59; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key59 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key6; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key6 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key60; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key60 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key61; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key61 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key62; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key62 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key63; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key63 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key64; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key64 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key65; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key65 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key66; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key66 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key67; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key67 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key68; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key68 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key69; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key69 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key7; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key7 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key70; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key70 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key71; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key71 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key72; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key72 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key73; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key73 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key74; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key74 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key75; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key75 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key76; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key76 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key77; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key77 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key78; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key78 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key79; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key79 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key8; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key8 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key80; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key80 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key81; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key81 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key82; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key82 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key83; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key83 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key84; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key84 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key85; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key85 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key86; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key86 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key87; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key87 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key88; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key88 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key89; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key89 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key9; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key9 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key90; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key90 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key91; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key91 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key92; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key92 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key93; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key93 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key94; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key94 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key95; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key95 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key96; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key96 UNIQUE (company_name);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (company_id);


--
-- Name: project_status_history project_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.project_status_history
    ADD CONSTRAINT project_status_history_pkey PRIMARY KEY (history_id);


--
-- Name: projectcollaborators projectcollaborators_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.projectcollaborators
    ADD CONSTRAINT projectcollaborators_pkey PRIMARY KEY (collaborator_id);


--
-- Name: projectcollaborators projectcollaborators_project_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.projectcollaborators
    ADD CONSTRAINT projectcollaborators_project_id_user_id_key UNIQUE (project_id, user_id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project_id);


--
-- Name: role_attributes role_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.role_attributes
    ADD CONSTRAINT role_attributes_pkey PRIMARY KEY (attribute_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: stages stages_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (stage_id);


--
-- Name: taskassignments taskassignments_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.taskassignments
    ADD CONSTRAINT taskassignments_pkey PRIMARY KEY (assignment_id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (task_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_email_key1; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key1 UNIQUE (email);


--
-- Name: users users_email_key10; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key10 UNIQUE (email);


--
-- Name: users users_email_key11; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key11 UNIQUE (email);


--
-- Name: users users_email_key12; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key12 UNIQUE (email);


--
-- Name: users users_email_key13; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key13 UNIQUE (email);


--
-- Name: users users_email_key14; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key14 UNIQUE (email);


--
-- Name: users users_email_key15; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key15 UNIQUE (email);


--
-- Name: users users_email_key16; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key16 UNIQUE (email);


--
-- Name: users users_email_key17; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key17 UNIQUE (email);


--
-- Name: users users_email_key18; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key18 UNIQUE (email);


--
-- Name: users users_email_key19; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key19 UNIQUE (email);


--
-- Name: users users_email_key2; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key2 UNIQUE (email);


--
-- Name: users users_email_key20; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key20 UNIQUE (email);


--
-- Name: users users_email_key21; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key21 UNIQUE (email);


--
-- Name: users users_email_key22; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key22 UNIQUE (email);


--
-- Name: users users_email_key23; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key23 UNIQUE (email);


--
-- Name: users users_email_key24; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key24 UNIQUE (email);


--
-- Name: users users_email_key25; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key25 UNIQUE (email);


--
-- Name: users users_email_key26; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key26 UNIQUE (email);


--
-- Name: users users_email_key27; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key27 UNIQUE (email);


--
-- Name: users users_email_key28; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key28 UNIQUE (email);


--
-- Name: users users_email_key29; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key29 UNIQUE (email);


--
-- Name: users users_email_key3; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key3 UNIQUE (email);


--
-- Name: users users_email_key30; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key30 UNIQUE (email);


--
-- Name: users users_email_key31; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key31 UNIQUE (email);


--
-- Name: users users_email_key32; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key32 UNIQUE (email);


--
-- Name: users users_email_key33; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key33 UNIQUE (email);


--
-- Name: users users_email_key34; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key34 UNIQUE (email);


--
-- Name: users users_email_key35; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key35 UNIQUE (email);


--
-- Name: users users_email_key36; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key36 UNIQUE (email);


--
-- Name: users users_email_key37; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key37 UNIQUE (email);


--
-- Name: users users_email_key38; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key38 UNIQUE (email);


--
-- Name: users users_email_key39; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key39 UNIQUE (email);


--
-- Name: users users_email_key4; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key4 UNIQUE (email);


--
-- Name: users users_email_key40; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key40 UNIQUE (email);


--
-- Name: users users_email_key41; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key41 UNIQUE (email);


--
-- Name: users users_email_key42; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key42 UNIQUE (email);


--
-- Name: users users_email_key43; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key43 UNIQUE (email);


--
-- Name: users users_email_key44; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key44 UNIQUE (email);


--
-- Name: users users_email_key45; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key45 UNIQUE (email);


--
-- Name: users users_email_key46; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key46 UNIQUE (email);


--
-- Name: users users_email_key47; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key47 UNIQUE (email);


--
-- Name: users users_email_key48; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key48 UNIQUE (email);


--
-- Name: users users_email_key49; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key49 UNIQUE (email);


--
-- Name: users users_email_key5; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key5 UNIQUE (email);


--
-- Name: users users_email_key50; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key50 UNIQUE (email);


--
-- Name: users users_email_key51; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key51 UNIQUE (email);


--
-- Name: users users_email_key52; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key52 UNIQUE (email);


--
-- Name: users users_email_key53; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key53 UNIQUE (email);


--
-- Name: users users_email_key54; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key54 UNIQUE (email);


--
-- Name: users users_email_key55; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key55 UNIQUE (email);


--
-- Name: users users_email_key56; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key56 UNIQUE (email);


--
-- Name: users users_email_key57; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key57 UNIQUE (email);


--
-- Name: users users_email_key58; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key58 UNIQUE (email);


--
-- Name: users users_email_key59; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key59 UNIQUE (email);


--
-- Name: users users_email_key6; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key6 UNIQUE (email);


--
-- Name: users users_email_key60; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key60 UNIQUE (email);


--
-- Name: users users_email_key61; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key61 UNIQUE (email);


--
-- Name: users users_email_key62; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key62 UNIQUE (email);


--
-- Name: users users_email_key63; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key63 UNIQUE (email);


--
-- Name: users users_email_key64; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key64 UNIQUE (email);


--
-- Name: users users_email_key65; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key65 UNIQUE (email);


--
-- Name: users users_email_key66; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key66 UNIQUE (email);


--
-- Name: users users_email_key67; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key67 UNIQUE (email);


--
-- Name: users users_email_key68; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key68 UNIQUE (email);


--
-- Name: users users_email_key69; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key69 UNIQUE (email);


--
-- Name: users users_email_key7; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key7 UNIQUE (email);


--
-- Name: users users_email_key70; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key70 UNIQUE (email);


--
-- Name: users users_email_key71; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key71 UNIQUE (email);


--
-- Name: users users_email_key72; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key72 UNIQUE (email);


--
-- Name: users users_email_key73; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key73 UNIQUE (email);


--
-- Name: users users_email_key74; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key74 UNIQUE (email);


--
-- Name: users users_email_key75; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key75 UNIQUE (email);


--
-- Name: users users_email_key76; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key76 UNIQUE (email);


--
-- Name: users users_email_key77; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key77 UNIQUE (email);


--
-- Name: users users_email_key78; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key78 UNIQUE (email);


--
-- Name: users users_email_key79; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key79 UNIQUE (email);


--
-- Name: users users_email_key8; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key8 UNIQUE (email);


--
-- Name: users users_email_key80; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key80 UNIQUE (email);


--
-- Name: users users_email_key81; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key81 UNIQUE (email);


--
-- Name: users users_email_key82; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key82 UNIQUE (email);


--
-- Name: users users_email_key83; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key83 UNIQUE (email);


--
-- Name: users users_email_key84; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key84 UNIQUE (email);


--
-- Name: users users_email_key85; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key85 UNIQUE (email);


--
-- Name: users users_email_key86; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key86 UNIQUE (email);


--
-- Name: users users_email_key87; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key87 UNIQUE (email);


--
-- Name: users users_email_key88; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key88 UNIQUE (email);


--
-- Name: users users_email_key89; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key89 UNIQUE (email);


--
-- Name: users users_email_key9; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key9 UNIQUE (email);


--
-- Name: users users_email_key90; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key90 UNIQUE (email);


--
-- Name: users users_email_key91; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key91 UNIQUE (email);


--
-- Name: users users_email_key92; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key92 UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: users users_username_key1; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key1 UNIQUE (username);


--
-- Name: users users_username_key10; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key10 UNIQUE (username);


--
-- Name: users users_username_key100; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key100 UNIQUE (username);


--
-- Name: users users_username_key101; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key101 UNIQUE (username);


--
-- Name: users users_username_key102; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key102 UNIQUE (username);


--
-- Name: users users_username_key103; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key103 UNIQUE (username);


--
-- Name: users users_username_key104; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key104 UNIQUE (username);


--
-- Name: users users_username_key105; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key105 UNIQUE (username);


--
-- Name: users users_username_key106; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key106 UNIQUE (username);


--
-- Name: users users_username_key107; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key107 UNIQUE (username);


--
-- Name: users users_username_key108; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key108 UNIQUE (username);


--
-- Name: users users_username_key109; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key109 UNIQUE (username);


--
-- Name: users users_username_key11; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key11 UNIQUE (username);


--
-- Name: users users_username_key110; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key110 UNIQUE (username);


--
-- Name: users users_username_key111; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key111 UNIQUE (username);


--
-- Name: users users_username_key112; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key112 UNIQUE (username);


--
-- Name: users users_username_key113; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key113 UNIQUE (username);


--
-- Name: users users_username_key114; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key114 UNIQUE (username);


--
-- Name: users users_username_key115; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key115 UNIQUE (username);


--
-- Name: users users_username_key116; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key116 UNIQUE (username);


--
-- Name: users users_username_key117; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key117 UNIQUE (username);


--
-- Name: users users_username_key118; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key118 UNIQUE (username);


--
-- Name: users users_username_key119; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key119 UNIQUE (username);


--
-- Name: users users_username_key12; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key12 UNIQUE (username);


--
-- Name: users users_username_key120; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key120 UNIQUE (username);


--
-- Name: users users_username_key121; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key121 UNIQUE (username);


--
-- Name: users users_username_key122; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key122 UNIQUE (username);


--
-- Name: users users_username_key123; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key123 UNIQUE (username);


--
-- Name: users users_username_key124; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key124 UNIQUE (username);


--
-- Name: users users_username_key125; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key125 UNIQUE (username);


--
-- Name: users users_username_key126; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key126 UNIQUE (username);


--
-- Name: users users_username_key127; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key127 UNIQUE (username);


--
-- Name: users users_username_key128; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key128 UNIQUE (username);


--
-- Name: users users_username_key129; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key129 UNIQUE (username);


--
-- Name: users users_username_key13; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key13 UNIQUE (username);


--
-- Name: users users_username_key130; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key130 UNIQUE (username);


--
-- Name: users users_username_key131; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key131 UNIQUE (username);


--
-- Name: users users_username_key132; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key132 UNIQUE (username);


--
-- Name: users users_username_key133; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key133 UNIQUE (username);


--
-- Name: users users_username_key134; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key134 UNIQUE (username);


--
-- Name: users users_username_key135; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key135 UNIQUE (username);


--
-- Name: users users_username_key136; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key136 UNIQUE (username);


--
-- Name: users users_username_key137; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key137 UNIQUE (username);


--
-- Name: users users_username_key138; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key138 UNIQUE (username);


--
-- Name: users users_username_key139; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key139 UNIQUE (username);


--
-- Name: users users_username_key14; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key14 UNIQUE (username);


--
-- Name: users users_username_key140; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key140 UNIQUE (username);


--
-- Name: users users_username_key141; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key141 UNIQUE (username);


--
-- Name: users users_username_key15; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key15 UNIQUE (username);


--
-- Name: users users_username_key16; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key16 UNIQUE (username);


--
-- Name: users users_username_key17; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key17 UNIQUE (username);


--
-- Name: users users_username_key18; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key18 UNIQUE (username);


--
-- Name: users users_username_key19; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key19 UNIQUE (username);


--
-- Name: users users_username_key2; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key2 UNIQUE (username);


--
-- Name: users users_username_key20; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key20 UNIQUE (username);


--
-- Name: users users_username_key21; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key21 UNIQUE (username);


--
-- Name: users users_username_key22; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key22 UNIQUE (username);


--
-- Name: users users_username_key23; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key23 UNIQUE (username);


--
-- Name: users users_username_key24; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key24 UNIQUE (username);


--
-- Name: users users_username_key25; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key25 UNIQUE (username);


--
-- Name: users users_username_key26; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key26 UNIQUE (username);


--
-- Name: users users_username_key27; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key27 UNIQUE (username);


--
-- Name: users users_username_key28; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key28 UNIQUE (username);


--
-- Name: users users_username_key29; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key29 UNIQUE (username);


--
-- Name: users users_username_key3; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key3 UNIQUE (username);


--
-- Name: users users_username_key30; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key30 UNIQUE (username);


--
-- Name: users users_username_key31; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key31 UNIQUE (username);


--
-- Name: users users_username_key32; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key32 UNIQUE (username);


--
-- Name: users users_username_key33; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key33 UNIQUE (username);


--
-- Name: users users_username_key34; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key34 UNIQUE (username);


--
-- Name: users users_username_key35; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key35 UNIQUE (username);


--
-- Name: users users_username_key36; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key36 UNIQUE (username);


--
-- Name: users users_username_key37; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key37 UNIQUE (username);


--
-- Name: users users_username_key38; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key38 UNIQUE (username);


--
-- Name: users users_username_key39; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key39 UNIQUE (username);


--
-- Name: users users_username_key4; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key4 UNIQUE (username);


--
-- Name: users users_username_key40; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key40 UNIQUE (username);


--
-- Name: users users_username_key41; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key41 UNIQUE (username);


--
-- Name: users users_username_key42; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key42 UNIQUE (username);


--
-- Name: users users_username_key43; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key43 UNIQUE (username);


--
-- Name: users users_username_key44; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key44 UNIQUE (username);


--
-- Name: users users_username_key45; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key45 UNIQUE (username);


--
-- Name: users users_username_key46; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key46 UNIQUE (username);


--
-- Name: users users_username_key47; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key47 UNIQUE (username);


--
-- Name: users users_username_key48; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key48 UNIQUE (username);


--
-- Name: users users_username_key49; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key49 UNIQUE (username);


--
-- Name: users users_username_key5; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key5 UNIQUE (username);


--
-- Name: users users_username_key50; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key50 UNIQUE (username);


--
-- Name: users users_username_key51; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key51 UNIQUE (username);


--
-- Name: users users_username_key52; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key52 UNIQUE (username);


--
-- Name: users users_username_key53; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key53 UNIQUE (username);


--
-- Name: users users_username_key54; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key54 UNIQUE (username);


--
-- Name: users users_username_key55; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key55 UNIQUE (username);


--
-- Name: users users_username_key56; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key56 UNIQUE (username);


--
-- Name: users users_username_key57; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key57 UNIQUE (username);


--
-- Name: users users_username_key58; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key58 UNIQUE (username);


--
-- Name: users users_username_key59; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key59 UNIQUE (username);


--
-- Name: users users_username_key6; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key6 UNIQUE (username);


--
-- Name: users users_username_key60; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key60 UNIQUE (username);


--
-- Name: users users_username_key61; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key61 UNIQUE (username);


--
-- Name: users users_username_key62; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key62 UNIQUE (username);


--
-- Name: users users_username_key63; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key63 UNIQUE (username);


--
-- Name: users users_username_key64; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key64 UNIQUE (username);


--
-- Name: users users_username_key65; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key65 UNIQUE (username);


--
-- Name: users users_username_key66; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key66 UNIQUE (username);


--
-- Name: users users_username_key67; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key67 UNIQUE (username);


--
-- Name: users users_username_key68; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key68 UNIQUE (username);


--
-- Name: users users_username_key69; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key69 UNIQUE (username);


--
-- Name: users users_username_key7; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key7 UNIQUE (username);


--
-- Name: users users_username_key70; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key70 UNIQUE (username);


--
-- Name: users users_username_key71; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key71 UNIQUE (username);


--
-- Name: users users_username_key72; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key72 UNIQUE (username);


--
-- Name: users users_username_key73; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key73 UNIQUE (username);


--
-- Name: users users_username_key74; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key74 UNIQUE (username);


--
-- Name: users users_username_key75; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key75 UNIQUE (username);


--
-- Name: users users_username_key76; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key76 UNIQUE (username);


--
-- Name: users users_username_key77; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key77 UNIQUE (username);


--
-- Name: users users_username_key78; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key78 UNIQUE (username);


--
-- Name: users users_username_key79; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key79 UNIQUE (username);


--
-- Name: users users_username_key8; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key8 UNIQUE (username);


--
-- Name: users users_username_key80; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key80 UNIQUE (username);


--
-- Name: users users_username_key81; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key81 UNIQUE (username);


--
-- Name: users users_username_key82; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key82 UNIQUE (username);


--
-- Name: users users_username_key83; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key83 UNIQUE (username);


--
-- Name: users users_username_key84; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key84 UNIQUE (username);


--
-- Name: users users_username_key85; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key85 UNIQUE (username);


--
-- Name: users users_username_key86; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key86 UNIQUE (username);


--
-- Name: users users_username_key87; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key87 UNIQUE (username);


--
-- Name: users users_username_key88; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key88 UNIQUE (username);


--
-- Name: users users_username_key89; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key89 UNIQUE (username);


--
-- Name: users users_username_key9; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key9 UNIQUE (username);


--
-- Name: users users_username_key90; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key90 UNIQUE (username);


--
-- Name: users users_username_key91; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key91 UNIQUE (username);


--
-- Name: users users_username_key92; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key92 UNIQUE (username);


--
-- Name: users users_username_key93; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key93 UNIQUE (username);


--
-- Name: users users_username_key94; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key94 UNIQUE (username);


--
-- Name: users users_username_key95; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key95 UNIQUE (username);


--
-- Name: users users_username_key96; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key96 UNIQUE (username);


--
-- Name: users users_username_key97; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key97 UNIQUE (username);


--
-- Name: users users_username_key98; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key98 UNIQUE (username);


--
-- Name: users users_username_key99; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key99 UNIQUE (username);


--
-- Name: idx_project_user_collaborators; Type: INDEX; Schema: public; Owner: thomasdeane
--

CREATE INDEX idx_project_user_collaborators ON public.projectcollaborators USING btree (project_id, user_id);


--
-- Name: idx_projectcollaborators_project_id; Type: INDEX; Schema: public; Owner: thomasdeane
--

CREATE INDEX idx_projectcollaborators_project_id ON public.projectcollaborators USING btree (project_id);


--
-- Name: idx_projectcollaborators_user_id; Type: INDEX; Schema: public; Owner: thomasdeane
--

CREATE INDEX idx_projectcollaborators_user_id ON public.projectcollaborators USING btree (user_id);


--
-- Name: idx_stages_project_id; Type: INDEX; Schema: public; Owner: thomasdeane
--

CREATE INDEX idx_stages_project_id ON public.stages USING btree (project_id);


--
-- Name: idx_tasks_project_id; Type: INDEX; Schema: public; Owner: thomasdeane
--

CREATE INDEX idx_tasks_project_id ON public.tasks USING btree (project_id);


--
-- Name: idx_tasks_stage_id; Type: INDEX; Schema: public; Owner: thomasdeane
--

CREATE INDEX idx_tasks_stage_id ON public.tasks USING btree (stage_id);


--
-- Name: idx_unique_company_name; Type: INDEX; Schema: public; Owner: thomasdeane
--

CREATE UNIQUE INDEX idx_unique_company_name ON public.companies USING btree (company_name);


--
-- Name: projects set_projects_updated_at; Type: TRIGGER; Schema: public; Owner: thomasdeane
--

CREATE TRIGGER set_projects_updated_at BEFORE UPDATE ON public.projects FOR EACH ROW EXECUTE FUNCTION public.update_projects_timestamp();


--
-- Name: roles set_roles_updated_at; Type: TRIGGER; Schema: public; Owner: thomasdeane
--

CREATE TRIGGER set_roles_updated_at BEFORE UPDATE ON public.roles FOR EACH ROW EXECUTE FUNCTION public.update_roles_timestamp();


--
-- Name: stages set_stages_updated_at; Type: TRIGGER; Schema: public; Owner: thomasdeane
--

CREATE TRIGGER set_stages_updated_at BEFORE UPDATE ON public.stages FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- Name: tasks set_tasks_updated_at; Type: TRIGGER; Schema: public; Owner: thomasdeane
--

CREATE TRIGGER set_tasks_updated_at BEFORE UPDATE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- Name: projectcollaborators set_updated_at; Type: TRIGGER; Schema: public; Owner: thomasdeane
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.projectcollaborators FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- Name: stages set_updated_at; Type: TRIGGER; Schema: public; Owner: thomasdeane
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.stages FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- Name: tasks set_updated_at; Type: TRIGGER; Schema: public; Owner: thomasdeane
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- Name: collaborator_audit collaborator_audit_collaborator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.collaborator_audit
    ADD CONSTRAINT collaborator_audit_collaborator_id_fkey FOREIGN KEY (collaborator_id) REFERENCES public.projectcollaborators(collaborator_id);


--
-- Name: collaborator_role_attributes collaborator_role_attributes_collaborator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.collaborator_role_attributes
    ADD CONSTRAINT collaborator_role_attributes_collaborator_id_fkey FOREIGN KEY (collaborator_id) REFERENCES public.projectcollaborators(collaborator_id);


--
-- Name: companies companies_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: project_status_history project_status_history_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.project_status_history
    ADD CONSTRAINT project_status_history_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id);


--
-- Name: projectcollaborators projectcollaborators_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.projectcollaborators
    ADD CONSTRAINT projectcollaborators_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: projectcollaborators projectcollaborators_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.projectcollaborators
    ADD CONSTRAINT projectcollaborators_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE;


--
-- Name: projects projects_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(user_id);


--
-- Name: role_attributes role_attributes_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.role_attributes
    ADD CONSTRAINT role_attributes_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


--
-- Name: stages stages_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: taskassignments taskassignments_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.taskassignments
    ADD CONSTRAINT taskassignments_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: taskassignments taskassignments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.taskassignments
    ADD CONSTRAINT taskassignments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE;


--
-- Name: tasks tasks_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: tasks tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: tasks tasks_stage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.stages(stage_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: users users_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(company_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

