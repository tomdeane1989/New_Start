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
-- Name: documents; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.documents (
    document_id integer NOT NULL,
    owner_id integer NOT NULL,
    file_name character varying(255) NOT NULL,
    file_url character varying(255),
    tags character varying(255)[] DEFAULT (ARRAY[]::character varying[])::character varying(255)[],
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    original_filename character varying(255),
    uploaded_by character varying(255),
    uploaded_date timestamp with time zone
);


ALTER TABLE public.documents OWNER TO thomasdeane;

--
-- Name: documents_document_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.documents_document_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.documents_document_id_seq OWNER TO thomasdeane;

--
-- Name: documents_document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.documents_document_id_seq OWNED BY public.documents.document_id;


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
    awaiting_approval boolean DEFAULT false,
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
    can_view boolean DEFAULT true,
    awaiting_approval boolean DEFAULT false
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
-- Name: taskdocuments; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.taskdocuments (
    id integer NOT NULL,
    task_id integer NOT NULL,
    document_id integer NOT NULL
);


ALTER TABLE public.taskdocuments OWNER TO thomasdeane;

--
-- Name: taskdocuments_id_seq; Type: SEQUENCE; Schema: public; Owner: thomasdeane
--

CREATE SEQUENCE public.taskdocuments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taskdocuments_id_seq OWNER TO thomasdeane;

--
-- Name: taskdocuments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thomasdeane
--

ALTER SEQUENCE public.taskdocuments_id_seq OWNED BY public.taskdocuments.id;


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
    is_active boolean DEFAULT true NOT NULL,
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
-- Name: documents document_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.documents ALTER COLUMN document_id SET DEFAULT nextval('public.documents_document_id_seq'::regclass);


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
-- Name: taskdocuments id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.taskdocuments ALTER COLUMN id SET DEFAULT nextval('public.taskdocuments_id_seq'::regclass);


--
-- Name: tasks task_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.tasks ALTER COLUMN task_id SET DEFAULT nextval('public.tasks_task_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: SequelizeMeta; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public."SequelizeMeta" (name) FROM stdin;
20241029084151-update-projectcollaborators-role-enum.js
20241031103945-add-owner-id-to-projects.js
20241031110443-align_db_taskassignmentTaskAssignment_tables.js
20241202091341-add-owner-id-to-companies.js
20241208121524-remove_duplicate_constraints.js
20241208122032-add_created_updated_by_fields.js
202311010001-create-documents.js
202311010002-create-taskdocuments.js
202311010003-update-documents-add-fields.js
20250102171536-add-awaiting-approval.js.js
\.


--
-- Data for Name: collaborator_audit; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.collaborator_audit (audit_id, collaborator_id, change_type, old_value, new_value, changed_at) FROM stdin;
\.


--
-- Data for Name: collaborator_role_attributes; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.collaborator_role_attributes (id, collaborator_id, attribute_key, attribute_value, created_at) FROM stdin;
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.companies (company_id, company_name, company_email, created_at, updated_at, owner_id) FROM stdin;
1	Estate Agency A	contact@estateagencya.com	2024-11-24 22:08:49.106721+00	2024-11-24 22:08:49.106721+00	1
2	Mortgage Advisors Ltd	info@mortgageadvisors.com	2024-11-24 22:08:49.106721+00	2024-11-24 22:08:49.106721+00	1
7	James Sellicks	twats@twats.com	2024-11-29 16:59:22.918+00	2024-11-29 16:59:22.918+00	1
3	Example Company	info@example.com	2024-11-24 22:08:49.106721+00	2024-11-29 17:29:37.133+00	1
9	Connells	connells@test.com	2024-11-29 18:15:41.478+00	2024-11-29 18:15:41.478+00	1
10	Tech Corp	contact@techcorp.com	2024-12-01 11:51:32.5+00	2024-12-01 11:51:32.5+00	1
12	Tech Solutions	info@techsolutions.com	2024-12-02 16:48:47.051399+00	2024-12-02 16:48:47.051399+00	1
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.documents (document_id, owner_id, file_name, file_url, tags, created_at, updated_at, original_filename, uploaded_by, uploaded_date) FROM stdin;
8	23	38e3510a3c6f6e801a45bcd14bb4c346.pdf	http://localhost:5001/uploads/38e3510a3c6f6e801a45bcd14bb4c346.pdf	{"Proof of Employment"}	2025-01-02 16:05:34.656+00	2025-01-02 16:05:34.656+00	Travel Receipt - UYJWUZ.pdf	Tom Test	2025-01-02 16:05:34.655+00
9	23	a3beaa06bd4452147f3bd6895b54f580.png	http://localhost:5001/uploads/a3beaa06bd4452147f3bd6895b54f580.png	{"Bank Statement"}	2025-01-02 16:06:17.57+00	2025-01-02 16:06:17.57+00	Screenshot 2024-12-30 at 12.30.43.png	Tom Test	2025-01-02 16:06:17.569+00
10	23	2a3bf0cffffdef0277b5de6059f1a4af.png	http://localhost:5001/uploads/2a3bf0cffffdef0277b5de6059f1a4af.png	{"Bank Statement","Proof of Employment"}	2025-01-02 16:07:36.04+00	2025-01-02 16:07:36.04+00	Screenshot 2024-12-30 at 12.12.44.png	Tom Test	2025-01-02 16:07:36.04+00
11	23	348cd0c23fac04bf41211835b5bfa35b.png	http://localhost:5001/uploads/348cd0c23fac04bf41211835b5bfa35b.png	{}	2025-01-02 17:35:17.547+00	2025-01-02 17:35:17.547+00	Screenshot 2024-11-27 at 20.06.02.png	Tom Test	2025-01-02 17:35:17.546+00
12	61	0b1491d69cdbce60a6635fe9485dc407.png	http://localhost:5001/uploads/0b1491d69cdbce60a6635fe9485dc407.png	{}	2025-01-02 17:49:37.306+00	2025-01-02 17:49:37.306+00	Screenshot 2024-12-30 at 12.12.44.png	paul deane	2025-01-02 17:49:37.305+00
\.


--
-- Data for Name: project_status_history; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.project_status_history (history_id, project_id, old_status, new_status, changed_at) FROM stdin;
\.


--
-- Data for Name: projectcollaborators; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.projectcollaborators (collaborator_id, project_id, user_id, created_at, updated_at, role, assigned_at, awaiting_approval) FROM stdin;
1	1	1	2024-11-24 21:02:00.317234+00	2024-12-07 21:08:24.279289+00	0	\N	f
2	1	2	2024-11-24 21:02:00.317234+00	2024-12-07 21:08:24.279289+00	0	\N	f
3	2	3	2024-11-24 21:02:00.317234+00	2024-12-07 21:08:24.279289+00	0	\N	f
4	2	4	2024-11-24 21:02:00.317234+00	2024-12-07 21:08:24.279289+00	0	\N	f
6	13	25	2024-12-07 23:10:29.071+00	2024-12-07 23:10:29.071+00	0	2024-12-07 23:10:29.071+00	f
12	18	47	2024-12-11 15:57:19.248+00	2024-12-11 15:57:19.248+00	0	2024-12-11 15:57:19.248+00	f
13	19	51	2024-12-12 11:05:04.013+00	2024-12-12 11:05:04.013+00	1	2024-12-12 11:05:04.013+00	f
19	23	52	2024-12-16 17:26:03.468+00	2024-12-16 17:26:03.468+00	0	2024-12-16 17:26:03.468+00	f
20	23	3	2024-12-16 17:26:21.644+00	2024-12-16 17:26:21.644+00	0	2024-12-16 17:26:21.644+00	f
21	23	53	2024-12-16 17:28:24.742+00	2024-12-16 17:28:24.742+00	1	2024-12-16 17:28:24.742+00	f
22	24	56	2024-12-16 17:32:35.162+00	2024-12-16 17:32:35.162+00	0	2024-12-16 17:32:35.162+00	f
23	24	54	2024-12-16 17:34:18.557+00	2024-12-16 17:34:18.557+00	5	2024-12-16 17:34:18.557+00	f
33	28	61	2025-01-02 17:48:38.613+00	2025-01-02 17:48:38.613+00	0	2025-01-02 17:48:38.613+00	f
34	28	23	2025-01-02 17:48:50.728+00	2025-01-02 17:48:53.427162+00	1	2025-01-02 17:48:50.728+00	f
35	28	52	2025-01-03 16:22:05.826+00	2025-01-03 16:22:26.702954+00	5	2025-01-03 16:22:05.826+00	f
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.projects (project_id, project_name, description, created_at, updated_at, status, owner_id) FROM stdin;
1	Project A	A project involving Buyer and Seller	2024-11-24 20:59:17.168394+00	2024-12-01 15:30:07.633801+00	active	1
2	Project B	A project with additional stakeholders	2024-11-24 20:59:17.168394+00	2024-12-01 15:30:07.633801+00	active	1
3	BUY A HOUSE	Details about the property project	2024-12-01 11:57:49.666+00	2024-12-01 15:30:07.633801+00	active	1
4	BUY A HOUSE	Details about the property project	2024-12-01 12:21:45.095+00	2024-12-01 15:30:07.633801+00	active	1
5	BUY A HOUSE	Details about the property project	2024-12-01 15:46:59.238+00	2024-12-01 15:46:59.238+00	active	14
6	BUY A HOUSE2	Details about the property project	2024-12-01 15:47:06.211+00	2024-12-01 15:47:06.211+00	active	14
7	Test_with_stages_with_tasks	Details about the property project	2024-12-01 18:51:27.639+00	2024-12-01 18:51:27.639+00	active	14
8	Test_with_stages_with_tasks	Details about the property project	2024-12-01 18:55:29.445+00	2024-12-01 18:55:29.445+00	active	14
9	Updated by PUT test	Updated description	2024-12-01 18:56:25.307+00	2024-12-01 19:38:28.940189+00	active	14
12	test	test desc	2024-12-07 22:49:03.917+00	2024-12-07 22:49:03.917+00	active	25
13	Buy test	testststs	2024-12-07 23:10:29.013+00	2024-12-07 23:10:29.013+00	active	25
18	Test project	testing after backend login/reg issue	2024-12-11 15:57:19.179+00	2024-12-11 15:57:19.179+00	active	47
19	2Test_with_stages_with_tasks2	Details about the property project	2024-12-12 11:05:03.952+00	2024-12-12 11:05:03.952+00	active	51
23	Buy our first house	Find a house in MH	2024-12-16 17:26:03.362+00	2024-12-16 17:26:03.362+00	active	52
24	Buy a house in Market Habrorough	Little bowden maybe?	2024-12-16 17:32:35.124+00	2024-12-16 17:32:35.124+00	active	56
28	Paul Test Test		2025-01-02 17:48:38.552+00	2025-01-02 17:48:38.552+00	active	61
\.


--
-- Data for Name: role_attributes; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.role_attributes (attribute_id, role_id, attribute_key, attribute_value, created_at) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.roles (role_id, role_name, created_at, updated_at, description) FROM stdin;
1	Buyer	2024-11-24 15:53:26.398881	2024-11-24 15:53:26.402709	\N
2	Seller	2024-11-24 15:53:26.398881	2024-11-24 15:53:26.402709	\N
12	Buyer Solicitor	2024-11-24 17:04:24.22514	2024-11-24 17:04:24.22514	\N
13	Seller Solicitor	2024-11-24 17:04:24.22514	2024-11-24 17:04:24.22514	\N
3	Estate Agent	2024-11-24 15:53:26.398881	2024-11-24 20:49:38.401729	Handles transactions for the buyer or seller
18	Mortgage Advisor	2024-11-24 20:49:48.936943	2024-11-24 20:49:48.936943	Support in the preparation of mortgage
\.


--
-- Data for Name: stages; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.stages (stage_id, stage_name, created_at, updated_at, project_id, stage_order, is_custom) FROM stdin;
11	Initial Inquiry	2024-11-24 21:27:08.762078+00	2024-12-01 15:14:22.643208+00	1	1	f
12	Offer Accepted	2024-11-24 21:27:08.762078+00	2024-12-01 15:14:22.643208+00	1	2	f
13	Secure Mortgage in Principal	2024-11-24 21:27:08.762078+00	2024-12-01 15:14:22.643208+00	1	3	f
14	Inspections & Conveyancing	2024-11-24 21:27:08.762078+00	2024-12-01 15:14:22.643208+00	1	4	f
15	Completion	2024-11-24 21:27:08.762078+00	2024-12-01 15:14:22.643208+00	1	5	f
16	Initial Inquiry	2024-11-24 21:27:08.762078+00	2024-12-01 15:14:22.643208+00	2	6	f
17	Offer Accepted	2024-11-24 21:27:08.762078+00	2024-12-01 15:14:22.643208+00	2	7	f
18	Secure Mortgage in Principal	2024-11-24 21:27:08.762078+00	2024-12-01 15:14:22.643208+00	2	8	f
19	Inspections & Conveyancing	2024-11-24 21:27:08.762078+00	2024-12-01 15:14:22.643208+00	2	9	f
20	Completion	2024-11-24 21:27:08.762078+00	2024-12-01 15:14:22.643208+00	2	10	f
21	Viewings	2024-12-01 11:57:49.724+00	2024-12-01 15:14:22.643208+00	3	11	f
22	Offer Stage	2024-12-01 11:57:49.724+00	2024-12-01 15:14:22.643208+00	3	12	f
23	Offer Accepted	2024-12-01 11:57:49.724+00	2024-12-01 15:14:22.643208+00	3	13	f
24	Legal, Surveys, & Compliance	2024-12-01 11:57:49.724+00	2024-12-01 15:14:22.643208+00	3	14	f
25	Mortgage Application	2024-12-01 11:57:49.724+00	2024-12-01 15:14:22.643208+00	3	15	f
26	Contract Exchange	2024-12-01 11:57:49.724+00	2024-12-01 15:14:22.643208+00	3	16	f
27	Key Exchange	2024-12-01 11:57:49.724+00	2024-12-01 15:14:22.643208+00	3	17	f
28	Misc	2024-12-01 11:57:49.724+00	2024-12-01 15:14:22.643208+00	3	18	f
29	Viewings	2024-12-01 12:21:45.179+00	2024-12-01 15:14:22.643208+00	4	19	f
30	Offer Stage	2024-12-01 12:21:45.179+00	2024-12-01 15:14:22.643208+00	4	20	f
31	Offer Accepted	2024-12-01 12:21:45.179+00	2024-12-01 15:14:22.643208+00	4	21	f
32	Legal, Surveys, & Compliance	2024-12-01 12:21:45.179+00	2024-12-01 15:14:22.643208+00	4	22	f
33	Mortgage Application	2024-12-01 12:21:45.179+00	2024-12-01 15:14:22.643208+00	4	23	f
34	Contract Exchange	2024-12-01 12:21:45.179+00	2024-12-01 15:14:22.643208+00	4	24	f
35	Key Exchange	2024-12-01 12:21:45.179+00	2024-12-01 15:14:22.643208+00	4	25	f
36	Misc	2024-12-01 12:21:45.179+00	2024-12-01 15:14:22.643208+00	4	26	f
37	Viewings	2024-12-01 15:46:59.3+00	2024-12-01 15:46:59.3+00	5	1	f
38	Offer Stage	2024-12-01 15:46:59.3+00	2024-12-01 15:46:59.3+00	5	2	f
39	Offer Accepted	2024-12-01 15:46:59.3+00	2024-12-01 15:46:59.3+00	5	3	f
40	Legal, Surveys, & Compliance	2024-12-01 15:46:59.3+00	2024-12-01 15:46:59.3+00	5	4	f
41	Mortgage Application	2024-12-01 15:46:59.3+00	2024-12-01 15:46:59.3+00	5	5	f
42	Contract Exchange	2024-12-01 15:46:59.3+00	2024-12-01 15:46:59.3+00	5	6	f
43	Key Exchange	2024-12-01 15:46:59.3+00	2024-12-01 15:46:59.3+00	5	7	f
44	Misc	2024-12-01 15:46:59.3+00	2024-12-01 15:46:59.3+00	5	8	t
45	Viewings	2024-12-01 15:47:06.215+00	2024-12-01 15:47:06.215+00	6	1	f
46	Offer Stage	2024-12-01 15:47:06.215+00	2024-12-01 15:47:06.215+00	6	2	f
47	Offer Accepted	2024-12-01 15:47:06.215+00	2024-12-01 15:47:06.215+00	6	3	f
48	Legal, Surveys, & Compliance	2024-12-01 15:47:06.215+00	2024-12-01 15:47:06.215+00	6	4	f
49	Mortgage Application	2024-12-01 15:47:06.215+00	2024-12-01 15:47:06.215+00	6	5	f
50	Contract Exchange	2024-12-01 15:47:06.215+00	2024-12-01 15:47:06.215+00	6	6	f
51	Key Exchange	2024-12-01 15:47:06.215+00	2024-12-01 15:47:06.215+00	6	7	f
52	Misc	2024-12-01 15:47:06.215+00	2024-12-01 15:47:06.215+00	6	8	t
53	Viewings	2024-12-01 18:51:27.798+00	2024-12-01 18:51:27.798+00	7	1	f
54	Offer Stage	2024-12-01 18:51:27.798+00	2024-12-01 18:51:27.798+00	7	2	f
55	Offer Accepted	2024-12-01 18:51:27.798+00	2024-12-01 18:51:27.798+00	7	3	f
56	Legal, Surveys, & Compliance	2024-12-01 18:51:27.798+00	2024-12-01 18:51:27.798+00	7	4	f
57	Mortgage Application	2024-12-01 18:51:27.798+00	2024-12-01 18:51:27.798+00	7	5	f
58	Contract Exchange	2024-12-01 18:51:27.798+00	2024-12-01 18:51:27.798+00	7	6	f
59	Key Exchange	2024-12-01 18:51:27.798+00	2024-12-01 18:51:27.798+00	7	7	f
60	Misc	2024-12-01 18:51:27.798+00	2024-12-01 18:51:27.798+00	7	8	t
61	Viewings	2024-12-01 18:55:29.455+00	2024-12-01 18:55:29.455+00	8	1	f
62	Offer Stage	2024-12-01 18:55:29.455+00	2024-12-01 18:55:29.455+00	8	2	f
63	Offer Accepted	2024-12-01 18:55:29.455+00	2024-12-01 18:55:29.455+00	8	3	f
64	Legal, Surveys, & Compliance	2024-12-01 18:55:29.455+00	2024-12-01 18:55:29.455+00	8	4	f
65	Mortgage Application	2024-12-01 18:55:29.455+00	2024-12-01 18:55:29.455+00	8	5	f
66	Contract Exchange	2024-12-01 18:55:29.455+00	2024-12-01 18:55:29.455+00	8	6	f
67	Key Exchange	2024-12-01 18:55:29.455+00	2024-12-01 18:55:29.455+00	8	7	f
68	Misc	2024-12-01 18:55:29.455+00	2024-12-01 18:55:29.455+00	8	8	t
69	Viewings	2024-12-01 18:56:25.327+00	2024-12-01 18:56:25.327+00	9	1	f
70	Offer Stage	2024-12-01 18:56:25.327+00	2024-12-01 18:56:25.327+00	9	2	f
71	Offer Accepted	2024-12-01 18:56:25.327+00	2024-12-01 18:56:25.327+00	9	3	f
72	Legal, Surveys, & Compliance	2024-12-01 18:56:25.327+00	2024-12-01 18:56:25.327+00	9	4	f
73	Mortgage Application	2024-12-01 18:56:25.327+00	2024-12-01 18:56:25.327+00	9	5	f
74	Contract Exchange	2024-12-01 18:56:25.327+00	2024-12-01 18:56:25.327+00	9	6	f
75	Key Exchange	2024-12-01 18:56:25.327+00	2024-12-01 18:56:25.327+00	9	7	f
76	Misc	2024-12-01 18:56:25.327+00	2024-12-01 18:56:25.327+00	9	8	t
93	Viewings	2024-12-07 22:49:03.948+00	2024-12-07 22:49:03.948+00	12	1	f
94	Offer Stage	2024-12-07 22:49:03.948+00	2024-12-07 22:49:03.948+00	12	2	f
95	Offer Accepted	2024-12-07 22:49:03.948+00	2024-12-07 22:49:03.948+00	12	3	f
96	Legal, Surveys, & Compliance	2024-12-07 22:49:03.948+00	2024-12-07 22:49:03.948+00	12	4	f
97	Mortgage Application	2024-12-07 22:49:03.948+00	2024-12-07 22:49:03.948+00	12	5	f
98	Contract Exchange	2024-12-07 22:49:03.948+00	2024-12-07 22:49:03.948+00	12	6	f
99	Key Exchange	2024-12-07 22:49:03.948+00	2024-12-07 22:49:03.948+00	12	7	f
100	Misc	2024-12-07 22:49:03.948+00	2024-12-07 22:49:03.948+00	12	8	t
101	Viewings	2024-12-07 23:10:29.088+00	2024-12-07 23:10:29.088+00	13	1	f
102	Offer Stage	2024-12-07 23:10:29.088+00	2024-12-07 23:10:29.088+00	13	2	f
103	Offer Accepted	2024-12-07 23:10:29.088+00	2024-12-07 23:10:29.088+00	13	3	f
104	Legal, Surveys, & Compliance	2024-12-07 23:10:29.088+00	2024-12-07 23:10:29.088+00	13	4	f
105	Mortgage Application	2024-12-07 23:10:29.088+00	2024-12-07 23:10:29.088+00	13	5	f
106	Contract Exchange	2024-12-07 23:10:29.088+00	2024-12-07 23:10:29.088+00	13	6	f
107	Key Exchange	2024-12-07 23:10:29.088+00	2024-12-07 23:10:29.088+00	13	7	f
108	Misc	2024-12-07 23:10:29.088+00	2024-12-07 23:10:29.088+00	13	8	t
142	Viewings	2024-12-11 15:57:19.253+00	2024-12-11 15:57:19.253+00	18	1	f
143	Offer Stage	2024-12-11 15:57:19.253+00	2024-12-11 15:57:19.253+00	18	2	f
144	Offer Accepted	2024-12-11 15:57:19.253+00	2024-12-11 15:57:19.253+00	18	3	f
145	Legal, Surveys, & Compliance	2024-12-11 15:57:19.253+00	2024-12-11 15:57:19.253+00	18	4	f
146	Mortgage Application	2024-12-11 15:57:19.253+00	2024-12-11 15:57:19.253+00	18	5	f
147	Contract Exchange	2024-12-11 15:57:19.253+00	2024-12-11 15:57:19.253+00	18	6	f
148	Key Exchange	2024-12-11 15:57:19.253+00	2024-12-11 15:57:19.253+00	18	7	f
149	Misc	2024-12-11 15:57:19.253+00	2024-12-11 15:57:19.253+00	18	8	t
150	Viewings	2024-12-12 11:05:04.019+00	2024-12-12 11:05:04.019+00	19	1	f
151	Offer Stage	2024-12-12 11:05:04.019+00	2024-12-12 11:05:04.019+00	19	2	f
152	Offer Accepted	2024-12-12 11:05:04.019+00	2024-12-12 11:05:04.019+00	19	3	f
153	Legal, Surveys, & Compliance	2024-12-12 11:05:04.019+00	2024-12-12 11:05:04.019+00	19	4	f
154	Mortgage Application	2024-12-12 11:05:04.019+00	2024-12-12 11:05:04.019+00	19	5	f
155	Contract Exchange	2024-12-12 11:05:04.019+00	2024-12-12 11:05:04.019+00	19	6	f
156	Key Exchange	2024-12-12 11:05:04.019+00	2024-12-12 11:05:04.019+00	19	7	f
157	Misc	2024-12-12 11:05:04.019+00	2024-12-12 11:05:04.019+00	19	8	t
182	Viewings	2024-12-16 17:26:03.481+00	2024-12-16 17:26:03.481+00	23	1	f
183	Offer Stage	2024-12-16 17:26:03.481+00	2024-12-16 17:26:03.481+00	23	2	f
184	Offer Accepted	2024-12-16 17:26:03.481+00	2024-12-16 17:26:03.481+00	23	3	f
185	Legal, Surveys, & Compliance	2024-12-16 17:26:03.481+00	2024-12-16 17:26:03.481+00	23	4	f
186	Mortgage Application	2024-12-16 17:26:03.481+00	2024-12-16 17:26:03.481+00	23	5	f
187	Contract Exchange	2024-12-16 17:26:03.481+00	2024-12-16 17:26:03.481+00	23	6	f
188	Key Exchange	2024-12-16 17:26:03.481+00	2024-12-16 17:26:03.481+00	23	7	f
189	Misc	2024-12-16 17:26:03.481+00	2024-12-16 17:26:03.481+00	23	8	t
190	Viewings	2024-12-16 17:32:35.183+00	2024-12-16 17:32:35.183+00	24	1	f
191	Offer Stage	2024-12-16 17:32:35.183+00	2024-12-16 17:32:35.183+00	24	2	f
192	Offer Accepted	2024-12-16 17:32:35.183+00	2024-12-16 17:32:35.183+00	24	3	f
193	Legal, Surveys, & Compliance	2024-12-16 17:32:35.183+00	2024-12-16 17:32:35.183+00	24	4	f
194	Mortgage Application	2024-12-16 17:32:35.183+00	2024-12-16 17:32:35.183+00	24	5	f
195	Contract Exchange	2024-12-16 17:32:35.183+00	2024-12-16 17:32:35.183+00	24	6	f
196	Key Exchange	2024-12-16 17:32:35.183+00	2024-12-16 17:32:35.183+00	24	7	f
197	Misc	2024-12-16 17:32:35.183+00	2024-12-16 17:32:35.183+00	24	8	t
222	Viewings	2025-01-02 17:48:38.628+00	2025-01-02 17:48:38.628+00	28	1	f
223	Offer Stage	2025-01-02 17:48:38.628+00	2025-01-02 17:48:38.628+00	28	2	f
224	Offer Accepted	2025-01-02 17:48:38.628+00	2025-01-02 17:48:38.628+00	28	3	f
225	Legal, Surveys, & Compliance	2025-01-02 17:48:38.628+00	2025-01-02 17:48:38.628+00	28	4	f
226	Mortgage Application	2025-01-02 17:48:38.628+00	2025-01-02 17:48:38.628+00	28	5	f
227	Contract Exchange	2025-01-02 17:48:38.628+00	2025-01-02 17:48:38.628+00	28	6	f
228	Key Exchange	2025-01-02 17:48:38.628+00	2025-01-02 17:48:38.628+00	28	7	f
229	Misc	2025-01-02 17:48:38.628+00	2025-01-02 17:48:38.628+00	28	8	t
\.


--
-- Data for Name: taskassignments; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.taskassignments (assignment_id, task_id, user_id, can_edit, can_view, awaiting_approval) FROM stdin;
14	434	3	t	t	f
15	440	54	t	t	f
16	440	56	t	t	f
33	555	23	t	t	f
\.


--
-- Data for Name: taskdocuments; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.taskdocuments (id, task_id, document_id) FROM stdin;
23	555	12
24	555	8
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.tasks (task_id, project_id, stage_id, created_at, updated_at, task_name, is_completed, owner_id, description, due_date, priority) FROM stdin;
101	13	101	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Set criteria for your housing search	f	25	\N	\N	\N
102	13	101	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Determine your financial position - salary/savings/existing equity	f	25	\N	\N	\N
103	13	101	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Find appropriate properties through Rightmove etc.	f	25	\N	\N	\N
104	13	101	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Contact Estate Agents for further information	f	25	\N	\N	\N
105	13	101	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Book viewings	f	25	\N	\N	\N
106	13	101	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Invite your Mortgage Advisor (if you have one) to collaborate on A.I.P	f	25	\N	\N	\N
107	13	102	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Agreement in Principal with mortgage provider	f	25	\N	\N	\N
108	13	102	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Offer	f	25	\N	\N	\N
109	13	102	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Seller's response to offer	f	25	\N	\N	\N
110	13	102	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Counter offer 1	f	25	\N	\N	\N
111	13	102	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Seller's response to counter offer 1	f	25	\N	\N	\N
112	13	102	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Counter offer 2	f	25	\N	\N	\N
113	13	102	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Seller's response to counter offer 2	f	25	\N	\N	\N
114	13	103	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Invite solicitor to collaborate on Conveyancing	f	25	\N	\N	\N
115	13	103	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Provide solicitor contact information to seller's estate agent for Memorandum of Sale	f	25	\N	\N	\N
116	13	104	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Review and agree on costs with solicitor	f	25	\N	\N	\N
117	13	104	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Decide on your need for extensive or basic surveys	f	25	\N	\N	\N
118	13	104	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Confirm identity	f	25	\N	\N	\N
119	13	104	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Gifted deposit administration	f	25	\N	\N	\N
120	13	105	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Provide bank statements	f	25	\N	\N	\N
121	13	105	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Provide payslips	f	25	\N	\N	\N
122	13	105	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Provide proof of address	f	25	\N	\N	\N
123	13	105	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Provide proof of identity	f	25	\N	\N	\N
124	13	105	2024-12-07 23:10:29.095+00	2024-12-07 23:10:29.095+00	Review affordability of mortgage payments	f	25	\N	\N	\N
125	13	105	2024-12-07 23:10:29.096+00	2024-12-07 23:10:29.096+00	Confirm mortgage offer	f	25	\N	\N	\N
126	13	106	2024-12-07 23:10:29.096+00	2024-12-07 23:10:29.096+00	Sign Mortgage offer	f	25	\N	\N	\N
248	18	142	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Set criteria for your housing search	f	47	\N	\N	\N
249	18	142	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Determine your financial position - salary/savings/existing equity	f	47	\N	\N	\N
250	18	142	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Find appropriate properties through Rightmove etc.	f	47	\N	\N	\N
251	18	142	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Contact Estate Agents for further information	f	47	\N	\N	\N
252	18	142	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Book viewings	f	47	\N	\N	\N
127	13	106	2024-12-07 23:10:29.096+00	2024-12-07 23:10:29.096+00	Sign Deed of Covenant	f	25	\N	\N	\N
128	13	106	2024-12-07 23:10:29.096+00	2024-12-07 23:10:29.096+00	Agree on Chattels	f	25	\N	\N	\N
129	13	106	2024-12-07 23:10:29.096+00	2024-12-07 23:10:29.096+00	Agree completion date	f	25	\N	\N	\N
253	18	142	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Invite your Mortgage Advisor (if you have one) to collaborate on A.I.P	f	47	\N	\N	\N
254	18	143	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Agreement in Principal with mortgage provider	f	47	\N	\N	\N
255	18	143	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Offer	f	47	\N	\N	\N
256	18	143	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Seller's response to offer	f	47	\N	\N	\N
257	18	143	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Counter offer 1	f	47	\N	\N	\N
258	18	143	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Seller's response to counter offer 1	f	47	\N	\N	\N
259	18	143	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Counter offer 2	f	47	\N	\N	\N
260	18	143	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Seller's response to counter offer 2	f	47	\N	\N	\N
261	18	144	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Invite solicitor to collaborate on Conveyancing	f	47	\N	\N	\N
262	18	144	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Provide solicitor contact information to seller's estate agent for Memorandum of Sale	f	47	\N	\N	\N
263	18	145	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Review and agree on costs with solicitor	f	47	\N	\N	\N
264	18	145	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Decide on your need for extensive or basic surveys	f	47	\N	\N	\N
1	1	11	2024-11-24 21:29:33.046206+00	2024-12-07 23:03:38.884426+00	Default Task Name	f	1	\N	\N	\N
2	1	12	2024-11-24 21:29:33.046206+00	2024-12-07 23:03:38.884426+00	Default Task Name	f	1	\N	\N	\N
3	1	13	2024-11-24 21:29:33.046206+00	2024-12-07 23:03:38.884426+00	Default Task Name	f	1	\N	\N	\N
4	1	14	2024-11-24 21:29:33.046206+00	2024-12-07 23:03:38.884426+00	Default Task Name	f	1	\N	\N	\N
5	1	15	2024-11-24 21:29:33.046206+00	2024-12-07 23:03:38.884426+00	Default Task Name	f	1	\N	\N	\N
6	2	16	2024-11-24 21:29:44.948664+00	2024-12-07 23:03:38.884426+00	Default Task Name	f	1	\N	\N	\N
7	2	17	2024-11-24 21:29:44.948664+00	2024-12-07 23:03:38.884426+00	Default Task Name	f	1	\N	\N	\N
8	2	18	2024-11-24 21:29:44.948664+00	2024-12-07 23:03:38.884426+00	Default Task Name	f	1	\N	\N	\N
9	2	19	2024-11-24 21:29:44.948664+00	2024-12-07 23:03:38.884426+00	Default Task Name	f	1	\N	\N	\N
10	2	20	2024-11-24 21:29:44.948664+00	2024-12-07 23:03:38.884426+00	Default Task Name	f	1	\N	\N	\N
11	9	71	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Invite solicitor to collaborate on Conveyancing	f	1	\N	\N	\N
12	9	71	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Provide solicitor contact information to seller's estate agent for Memorandum of Sale	f	1	\N	\N	\N
13	9	72	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Review and agree on costs with solicitor	f	1	\N	\N	\N
14	9	72	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Decide on your need for extensive or basic surveys	f	1	\N	\N	\N
15	9	72	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Confirm identity	f	1	\N	\N	\N
16	9	72	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Gifted deposit administration	f	1	\N	\N	\N
17	9	73	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Provide bank statements	f	1	\N	\N	\N
18	9	73	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Provide payslips	f	1	\N	\N	\N
19	9	73	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Provide proof of address	f	1	\N	\N	\N
20	9	73	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Provide proof of identity	f	1	\N	\N	\N
21	9	73	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Review affordability of mortgage payments	f	1	\N	\N	\N
22	9	73	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Confirm mortgage offer	f	1	\N	\N	\N
23	9	74	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Sign Mortgage offer	f	1	\N	\N	\N
24	9	74	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Sign Deed of Covenant	f	1	\N	\N	\N
25	9	74	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Agree on Chattels	f	1	\N	\N	\N
26	9	74	2024-12-01 18:56:25.334+00	2024-12-07 23:03:38.884426+00	Agree completion date	f	1	\N	\N	\N
265	18	145	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Confirm identity	f	47	\N	\N	\N
266	18	145	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Gifted deposit administration	f	47	\N	\N	\N
267	18	146	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Provide bank statements	f	47	\N	\N	\N
268	18	146	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Provide payslips	f	47	\N	\N	\N
269	18	146	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Provide proof of address	f	47	\N	\N	\N
270	18	146	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Provide proof of identity	f	47	\N	\N	\N
271	18	146	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Review affordability of mortgage payments	f	47	\N	\N	\N
272	18	146	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Confirm mortgage offer	f	47	\N	\N	\N
273	18	147	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Sign Mortgage offer	f	47	\N	\N	\N
274	18	147	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Sign Deed of Covenant	f	47	\N	\N	\N
275	18	147	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Agree on Chattels	f	47	\N	\N	\N
276	18	147	2024-12-11 15:57:19.26+00	2024-12-11 15:57:19.26+00	Agree completion date	f	47	\N	\N	\N
306	19	150	2024-12-12 11:06:28.51+00	2024-12-12 11:06:28.51+00	Test Task	f	51	This is a test task.	2024-12-31 00:00:00+00	High
307	19	150	2024-12-12 11:12:21.209+00	2024-12-12 11:13:02.992292+00	Test Task 2 PUT	f	51	This is a test task.	2024-12-31 00:00:00+00	High
561	28	223	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Agreement in Principal with mortgage provider	f	61	\N	2025-02-01 17:48:38.634+00	Medium
562	28	223	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Offer	f	61	\N	2025-02-01 17:48:38.634+00	Medium
563	28	223	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Seller's response to offer	f	61	\N	2025-02-01 17:48:38.634+00	Medium
564	28	223	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Counter offer 1	f	61	\N	2025-02-01 17:48:38.634+00	Medium
72	12	93	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Set criteria for your housing search	f	1	\N	\N	\N
73	12	93	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Determine your financial position - salary/savings/existing equity	f	1	\N	\N	\N
74	12	93	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Find appropriate properties through Rightmove etc.	f	1	\N	\N	\N
75	12	93	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Contact Estate Agents for further information	f	1	\N	\N	\N
76	12	93	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Book viewings	f	1	\N	\N	\N
77	12	93	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Invite your Mortgage Advisor (if you have one) to collaborate on A.I.P	f	1	\N	\N	\N
78	12	94	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Agreement in Principal with mortgage provider	f	1	\N	\N	\N
79	12	94	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Offer	f	1	\N	\N	\N
80	12	94	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Seller's response to offer	f	1	\N	\N	\N
81	12	94	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Counter offer 1	f	1	\N	\N	\N
82	12	94	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Seller's response to counter offer 1	f	1	\N	\N	\N
83	12	94	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Counter offer 2	f	1	\N	\N	\N
84	12	94	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Seller's response to counter offer 2	f	1	\N	\N	\N
85	12	95	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Invite solicitor to collaborate on Conveyancing	f	1	\N	\N	\N
565	28	223	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Seller's response to counter offer 1	f	61	\N	2025-02-01 17:48:38.634+00	Medium
566	28	223	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Counter offer 2	f	61	\N	2025-02-01 17:48:38.634+00	Medium
567	28	223	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Seller's response to counter offer 2	f	61	\N	2025-02-01 17:48:38.634+00	Medium
568	28	224	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Invite solicitor to collaborate on Conveyancing	f	61	\N	2025-02-01 17:48:38.634+00	Medium
569	28	224	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Provide solicitor contact information to seller's estate agent for Memorandum of Sale	f	61	\N	2025-02-01 17:48:38.634+00	Medium
570	28	225	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Review and agree on costs with solicitor	f	61	\N	2025-02-01 17:48:38.634+00	Medium
86	12	95	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Provide solicitor contact information to seller's estate agent for Memorandum of Sale	f	1	\N	\N	\N
87	12	96	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Review and agree on costs with solicitor	f	1	\N	\N	\N
88	12	96	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Decide on your need for extensive or basic surveys	f	1	\N	\N	\N
89	12	96	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Confirm identity	f	1	\N	\N	\N
90	12	96	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Gifted deposit administration	f	1	\N	\N	\N
91	12	97	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Provide bank statements	f	1	\N	\N	\N
92	12	97	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Provide payslips	f	1	\N	\N	\N
93	12	97	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Provide proof of address	f	1	\N	\N	\N
94	12	97	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Provide proof of identity	f	1	\N	\N	\N
95	12	97	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Review affordability of mortgage payments	f	1	\N	\N	\N
96	12	97	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Confirm mortgage offer	f	1	\N	\N	\N
97	12	98	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Sign Mortgage offer	f	1	\N	\N	\N
98	12	98	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Sign Deed of Covenant	f	1	\N	\N	\N
99	12	98	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Agree on Chattels	f	1	\N	\N	\N
100	12	98	2024-12-07 22:49:03.956+00	2024-12-07 23:03:38.884426+00	Agree completion date	f	1	\N	\N	\N
277	19	150	2024-12-12 11:05:04.024+00	2024-12-12 11:05:04.024+00	Set criteria for your housing search	f	51	\N	\N	\N
278	19	150	2024-12-12 11:05:04.024+00	2024-12-12 11:05:04.024+00	Determine your financial position - salary/savings/existing equity	f	51	\N	\N	\N
279	19	150	2024-12-12 11:05:04.024+00	2024-12-12 11:05:04.024+00	Find appropriate properties through Rightmove etc.	f	51	\N	\N	\N
280	19	150	2024-12-12 11:05:04.024+00	2024-12-12 11:05:04.024+00	Contact Estate Agents for further information	f	51	\N	\N	\N
281	19	150	2024-12-12 11:05:04.024+00	2024-12-12 11:05:04.024+00	Book viewings	f	51	\N	\N	\N
282	19	150	2024-12-12 11:05:04.024+00	2024-12-12 11:05:04.024+00	Invite your Mortgage Advisor (if you have one) to collaborate on A.I.P	f	51	\N	\N	\N
283	19	151	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Agreement in Principal with mortgage provider	f	51	\N	\N	\N
284	19	151	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Offer	f	51	\N	\N	\N
285	19	151	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Seller's response to offer	f	51	\N	\N	\N
286	19	151	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Counter offer 1	f	51	\N	\N	\N
287	19	151	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Seller's response to counter offer 1	f	51	\N	\N	\N
288	19	151	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Counter offer 2	f	51	\N	\N	\N
289	19	151	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Seller's response to counter offer 2	f	51	\N	\N	\N
290	19	152	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Invite solicitor to collaborate on Conveyancing	f	51	\N	\N	\N
291	19	152	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Provide solicitor contact information to seller's estate agent for Memorandum of Sale	f	51	\N	\N	\N
292	19	153	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Review and agree on costs with solicitor	f	51	\N	\N	\N
293	19	153	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Decide on your need for extensive or basic surveys	f	51	\N	\N	\N
294	19	153	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Confirm identity	f	51	\N	\N	\N
295	19	153	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Gifted deposit administration	f	51	\N	\N	\N
296	19	154	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Provide bank statements	f	51	\N	\N	\N
297	19	154	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Provide payslips	f	51	\N	\N	\N
298	19	154	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Provide proof of address	f	51	\N	\N	\N
299	19	154	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Provide proof of identity	f	51	\N	\N	\N
300	19	154	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Review affordability of mortgage payments	f	51	\N	\N	\N
301	19	154	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Confirm mortgage offer	f	51	\N	\N	\N
302	19	155	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Sign Mortgage offer	f	51	\N	\N	\N
303	19	155	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Sign Deed of Covenant	f	51	\N	\N	\N
304	19	155	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Agree on Chattels	f	51	\N	\N	\N
305	19	155	2024-12-12 11:05:04.025+00	2024-12-12 11:05:04.025+00	Agree completion date	f	51	\N	\N	\N
571	28	225	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Decide on your need for extensive or basic surveys	f	61	\N	2025-02-01 17:48:38.634+00	Medium
572	28	225	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Confirm identity	f	61	\N	2025-02-01 17:48:38.634+00	Medium
573	28	225	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Gifted deposit administration	f	61	\N	2025-02-01 17:48:38.634+00	Medium
574	28	226	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Provide bank statements	f	61	\N	2025-02-01 17:48:38.634+00	Medium
575	28	226	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Provide payslips	f	61	\N	2025-02-01 17:48:38.634+00	Medium
576	28	226	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Provide proof of address	f	61	\N	2025-02-01 17:48:38.634+00	Medium
577	28	226	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Provide proof of identity	f	61	\N	2025-02-01 17:48:38.634+00	Medium
578	28	226	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Review affordability of mortgage payments	f	61	\N	2025-02-01 17:48:38.634+00	Medium
579	28	226	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Confirm mortgage offer	f	61	\N	2025-02-01 17:48:38.634+00	Medium
580	28	227	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Sign Mortgage offer	f	61	\N	2025-02-01 17:48:38.634+00	Medium
581	28	227	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Sign Deed of Covenant	f	61	\N	2025-02-01 17:48:38.634+00	Medium
582	28	227	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Agree on Chattels	f	61	\N	2025-02-01 17:48:38.634+00	Medium
583	28	227	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Agree completion date	f	61	\N	2025-02-01 17:48:38.634+00	Medium
405	23	182	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Set criteria for your housing search	f	52	\N	2025-01-15 17:26:03.485+00	Medium
406	23	182	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Determine your financial position - salary/savings/existing equity	f	52	\N	2025-01-15 17:26:03.485+00	Medium
407	23	182	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Find appropriate properties through Rightmove etc.	f	52	\N	2025-01-15 17:26:03.485+00	Medium
408	23	182	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Contact Estate Agents for further information	f	52	\N	2025-01-15 17:26:03.485+00	Medium
409	23	182	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Book viewings	f	52	\N	2025-01-15 17:26:03.485+00	Medium
410	23	182	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Invite your Mortgage Advisor (if you have one) to collaborate on A.I.P	f	52	\N	2025-01-15 17:26:03.485+00	Medium
411	23	183	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Agreement in Principal with mortgage provider	f	52	\N	2025-01-15 17:26:03.485+00	Medium
412	23	183	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Offer	f	52	\N	2025-01-15 17:26:03.485+00	Medium
413	23	183	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Seller's response to offer	f	52	\N	2025-01-15 17:26:03.485+00	Medium
414	23	183	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Counter offer 1	f	52	\N	2025-01-15 17:26:03.485+00	Medium
415	23	183	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Seller's response to counter offer 1	f	52	\N	2025-01-15 17:26:03.485+00	Medium
416	23	183	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Counter offer 2	f	52	\N	2025-01-15 17:26:03.485+00	Medium
417	23	183	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Seller's response to counter offer 2	f	52	\N	2025-01-15 17:26:03.485+00	Medium
418	23	184	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Invite solicitor to collaborate on Conveyancing	f	52	\N	2025-01-15 17:26:03.485+00	Medium
419	23	184	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Provide solicitor contact information to seller's estate agent for Memorandum of Sale	f	52	\N	2025-01-15 17:26:03.485+00	Medium
420	23	185	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Review and agree on costs with solicitor	f	52	\N	2025-01-15 17:26:03.485+00	Medium
421	23	185	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Decide on your need for extensive or basic surveys	f	52	\N	2025-01-15 17:26:03.485+00	Medium
422	23	185	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Confirm identity	f	52	\N	2025-01-15 17:26:03.485+00	Medium
423	23	185	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Gifted deposit administration	f	52	\N	2025-01-15 17:26:03.485+00	Medium
424	23	186	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Provide bank statements	f	52	\N	2025-01-15 17:26:03.485+00	Medium
425	23	186	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Provide payslips	f	52	\N	2025-01-15 17:26:03.485+00	Medium
426	23	186	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Provide proof of address	f	52	\N	2025-01-15 17:26:03.485+00	Medium
427	23	186	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Provide proof of identity	f	52	\N	2025-01-15 17:26:03.485+00	Medium
428	23	186	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Review affordability of mortgage payments	f	52	\N	2025-01-15 17:26:03.485+00	Medium
429	23	186	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Confirm mortgage offer	f	52	\N	2025-01-15 17:26:03.485+00	Medium
430	23	187	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Sign Mortgage offer	f	52	\N	2025-01-15 17:26:03.485+00	Medium
431	23	187	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Sign Deed of Covenant	f	52	\N	2025-01-15 17:26:03.485+00	Medium
432	23	187	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Agree on Chattels	f	52	\N	2025-01-15 17:26:03.485+00	Medium
433	23	187	2024-12-16 17:26:03.485+00	2024-12-16 17:26:03.485+00	Agree completion date	f	52	\N	2025-01-15 17:26:03.485+00	Medium
434	23	182	2024-12-16 17:29:26.28+00	2024-12-16 17:29:37.642462+00	Viewing of Dunmore Road	t	52	viewing of 43 dunmore road	2024-12-17 00:00:00+00	High
435	24	190	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Set criteria for your housing search	f	56	\N	2025-01-15 17:32:35.192+00	Medium
436	24	190	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Determine your financial position - salary/savings/existing equity	f	56	\N	2025-01-15 17:32:35.192+00	Medium
437	24	190	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Find appropriate properties through Rightmove etc.	f	56	\N	2025-01-15 17:32:35.192+00	Medium
438	24	190	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Contact Estate Agents for further information	f	56	\N	2025-01-15 17:32:35.192+00	Medium
439	24	190	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Book viewings	f	56	\N	2025-01-15 17:32:35.192+00	Medium
441	24	191	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Agreement in Principal with mortgage provider	f	56	\N	2025-01-15 17:32:35.192+00	Medium
442	24	191	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Offer	f	56	\N	2025-01-15 17:32:35.192+00	Medium
443	24	191	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Seller's response to offer	f	56	\N	2025-01-15 17:32:35.192+00	Medium
444	24	191	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Counter offer 1	f	56	\N	2025-01-15 17:32:35.192+00	Medium
445	24	191	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Seller's response to counter offer 1	f	56	\N	2025-01-15 17:32:35.192+00	Medium
446	24	191	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Counter offer 2	f	56	\N	2025-01-15 17:32:35.192+00	Medium
447	24	191	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Seller's response to counter offer 2	f	56	\N	2025-01-15 17:32:35.192+00	Medium
448	24	192	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Invite solicitor to collaborate on Conveyancing	f	56	\N	2025-01-15 17:32:35.192+00	Medium
449	24	192	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Provide solicitor contact information to seller's estate agent for Memorandum of Sale	f	56	\N	2025-01-15 17:32:35.192+00	Medium
450	24	193	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Review and agree on costs with solicitor	f	56	\N	2025-01-15 17:32:35.192+00	Medium
451	24	193	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Decide on your need for extensive or basic surveys	f	56	\N	2025-01-15 17:32:35.192+00	Medium
452	24	193	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Confirm identity	f	56	\N	2025-01-15 17:32:35.192+00	Medium
453	24	193	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Gifted deposit administration	f	56	\N	2025-01-15 17:32:35.192+00	Medium
454	24	194	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Provide bank statements	f	56	\N	2025-01-15 17:32:35.192+00	Medium
455	24	194	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Provide payslips	f	56	\N	2025-01-15 17:32:35.192+00	Medium
456	24	194	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Provide proof of address	f	56	\N	2025-01-15 17:32:35.192+00	Medium
457	24	194	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Provide proof of identity	f	56	\N	2025-01-15 17:32:35.192+00	Medium
458	24	194	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Review affordability of mortgage payments	f	56	\N	2025-01-15 17:32:35.192+00	Medium
459	24	194	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Confirm mortgage offer	f	56	\N	2025-01-15 17:32:35.192+00	Medium
460	24	195	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Sign Mortgage offer	f	56	\N	2025-01-15 17:32:35.192+00	Medium
461	24	195	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Sign Deed of Covenant	f	56	\N	2025-01-15 17:32:35.192+00	Medium
462	24	195	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Agree on Chattels	f	56	\N	2025-01-15 17:32:35.192+00	Medium
463	24	195	2024-12-16 17:32:35.192+00	2024-12-16 17:32:35.192+00	Agree completion date	f	56	\N	2025-01-15 17:32:35.192+00	Medium
440	24	190	2024-12-16 17:32:35.192+00	2024-12-16 17:34:39.715724+00	Invite your Mortgage Advisor (if you have one) to collaborate on A.I.P	f	56	invite jeremy	2025-01-15 00:00:00+00	Medium
555	28	222	2025-01-02 17:48:38.634+00	2025-01-03 16:21:22.567495+00	Set criteria for your housing search	f	61	Test script	2025-02-01 00:00:00+00	Medium
556	28	222	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Determine your financial position - salary/savings/existing equity	f	61	\N	2025-02-01 17:48:38.634+00	Medium
557	28	222	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Find appropriate properties through Rightmove etc.	f	61	\N	2025-02-01 17:48:38.634+00	Medium
558	28	222	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Contact Estate Agents for further information	f	61	\N	2025-02-01 17:48:38.634+00	Medium
560	28	222	2025-01-02 17:48:38.634+00	2025-01-02 17:48:38.634+00	Invite your Mortgage Advisor (if you have one) to collaborate on A.I.P	f	61	\N	2025-02-01 17:48:38.634+00	Medium
559	28	222	2025-01-02 17:48:38.634+00	2025-01-02 17:49:21.589318+00	Book viewings	f	61	\N	2025-02-01 00:00:00+00	Medium
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.users (user_id, username, email, password_hash, created_at, updated_at, is_active, first_name, last_name, company_id) FROM stdin;
1	buyer_user	buyer@example.com	hashed_password	2024-11-24 20:59:00.563113+00	2024-11-24 20:59:00.563113+00	t	\N	\N	\N
3	estate_agent_user	agent@example.com	hashed_password	2024-11-24 20:59:00.563113+00	2024-11-24 20:59:00.563113+00	t	\N	\N	1
4	mortgage_advisor_user	advisor@example.com	hashed_password	2024-11-24 20:59:00.563113+00	2024-11-24 20:59:00.563113+00	t	\N	\N	2
2	PUTTEST	test8test.com	hashed_password	2024-11-24 20:59:00.563113+00	2024-11-28 08:14:08.98+00	t	PUT	TEST	\N
12	Test_aUser	testuserxrso@example.com	$2b$10$HDXmuNg5q7IkrONiPYKsC.UGkrSQBNnKSM9lQFZtxODWFM5sN3sK.	2024-11-28 08:26:39.321+00	2024-11-28 08:26:39.321+00	t	Test	User	\N
13	buyer_solicitor	bs@example.com	$2b$10$syKBkt4n120hRYJ3RqiFGOLgYKEMYueH3fumyfohOO24jAhqk17ZK	2024-11-28 08:34:26.972+00	2024-11-28 08:34:26.972+00	t	buyer	solicitor	\N
43	test16	test16@test.test	$2b$10$u8WWZ5Yxh946GfJziAHIleTF/0pwjJtuZ5y1wlSQz88Nw08Vka3Va	2024-12-11 14:16:44.325+00	2024-12-11 14:16:44.326+00	t	\N	\N	\N
14	corp_bro	corp@hotmail.co.uk	$2b$10$9puDO0yVTK/ZAjccaN1WTeSNuMxUbK06hZ/VWsCej5cE4KDUtx0vO	2024-11-29 17:17:38.323+00	2024-12-01 11:51:32.54+00	t	Corp	Bro	10
44	test18	test18@test.test	$2b$10$JVPl0O2rTRCSRgJZnE8DHeOIIdZQwZ.LOX8asXlB9fg3AA7bqxvu.	2024-12-11 14:31:43.251+00	2024-12-11 14:31:43.252+00	t	\N	\N	\N
16	corp_nat	corpnat@hotmail.co.uk	$2b$10$jg8i1CUcvWwOjtzlyiMTQea6FAyBruxKtef1Owwk4LW85tHRAN6fm	2024-12-02 17:33:30.841+00	2024-12-02 17:33:30.841+00	t	Corp	Nat	\N
18	corp_nate	corpnate@hotmail.co.uk	$2b$10$E6uRwamVXqcRgP1Ux4lJoOuK3UgYs9ZfaCqk4IFvbLOabkJdW9Gl6	2024-12-02 17:51:07.148+00	2024-12-02 17:51:07.148+00	t	Corp	Nat	\N
19	corp_nate1	corpnate1@hotmail.co.uk	$2b$10$Bil6Lypm9Q3HINij3kRmJO3bFI5tVTcu7Fv6YtKqg0lNDc/BzRZ0K	2024-12-02 18:01:06.683+00	2024-12-02 18:01:06.683+00	t	Corp	Nat	\N
20	scrunch	scrunch@scrunch.com	$2b$10$T5srjDfcLdDU7M/4cXyXd.SBayKy6u5WEh9GKX/oh8zLAiWKW2AyS	2024-12-02 18:13:03.392+00	2024-12-02 18:13:03.392+00	t	scrunch	scrunch	\N
21	floof	floof@floof.co	$2b$10$zgH99KQmKbPzkRcVqlrPmOVbtEMHZft6Q6XpBAZYPN0cFQybIezGS	2024-12-02 18:45:26.787+00	2024-12-02 18:45:26.787+00	t	floof	floof	\N
22	tom	tom@test.com	$2b$10$Vcgi3UaggEcggxnv7Qg9zezUarzpgAUr/QATVYX1zwkuuU7FTZ0Wm	2024-12-02 20:08:13.65+00	2024-12-02 20:08:13.65+00	t	tom	deane	\N
24	Rach	test2@test.test	$2b$10$KEFGXZd5zBgYnIZF8ULg9OPlNsaiFaNkqOMVXgON3x0KlovjDYv6S	2024-12-07 18:30:04.404+00	2024-12-07 18:30:04.404+00	t	Rach	Scrunch	\N
25	trial	trial@trial.com	$2b$10$PLpOp4Nym2t/CY79F5uz/.S4z..qVkVEyUYaR9tkvojsfuiEwvZFO	2024-12-07 22:48:13.635+00	2024-12-07 22:48:13.635+00	t	trial	trial	\N
23	Tom TEST	test@test.test	$2b$10$zYQiD.3GQHg..ldRuYa0JOpn7uL03bl6T/.WUxbtn/IDmEKBFRt/e	2024-12-07 16:31:21.184+00	2024-12-09 21:04:28.786+00	t	Tom	Test	\N
26	Test	test3@test.test	$2b$10$0o7WToJZm1CZXISKuGv4jeEhP/o3AHGf5LNZnsdkBZ7AUp9t1RZ/.	2024-12-09 21:07:08.287+00	2024-12-09 21:07:08.287+00	t	test	test	\N
27	test	test4@test.test	$2b$10$CKa16ooE.5Ib/I2HAGaRMOn3tQ8GKDNaI3aQJtl/Dlwfef96ZbEbK	2024-12-09 21:08:17.32+00	2024-12-09 21:08:17.32+00	t	test	test	\N
29	test6	test6@test.test	$2b$10$OFyRkdfr9ktcQ2DjqtlMcOaiCaAM0Vv9gDjhduwaH1P9VJB13xxh6	2024-12-09 21:19:16.148+00	2024-12-09 21:19:16.148+00	t	test	test	\N
30	test7	test7@test.test	$2b$10$rzck2uQto0cVKVeG.hUDfO495PjU6P8DC0G2lIZz.1bTDxcr3h08q	2024-12-09 21:24:30.92+00	2024-12-09 21:24:30.921+00	t	test	test	\N
31	testy	test8@test.com	$2b$10$m3BNT2dbLs3n2n2YEpECRefUXPihpTHqtQXe90mHWJN2yt5hFVL.m	2024-12-11 13:20:44.254+00	2024-12-11 13:20:44.255+00	t	tom	test	\N
32	tester	test9@test.test	$2b$10$nwwIdTFZb3RzJn5Xr5FtIOEggNUeUh9f1B2c8eZ3BsS/IpIzKESsS	2024-12-11 13:41:23.401+00	2024-12-11 13:41:23.402+00	t	test	wtst	\N
33	test10	test10@test.test	$2b$10$cMT73al/MUxv98dtx7I1CuoYCEOLot.BLMdnerbGzNvMmZdMYXcWS	2024-12-11 13:42:18.136+00	2024-12-11 13:42:18.137+00	t	buyer	solicitor	\N
35	test11	test11@test.test	$2b$10$T/s/8yhSPpoZhaO/hSbkaO9q4X.EZh4FGz/dwVkNghWFcbz33mvbO	2024-12-11 13:47:30.037+00	2024-12-11 13:47:30.037+00	t	buyer	solicitor	\N
36	test12	test12@test.test	$2b$10$YzPOWMr7XGAYB28yuwB5xuizP0yJjjVk0pbw2/wOItIFBVUkNO82O	2024-12-11 13:59:01.477+00	2024-12-11 13:59:01.478+00	t	buyer	solicitor	\N
37	test13	test13@test.test	$2b$10$yIUCtJ5SgZie0UnjSsBZBu1Hzi716sgUmehLZM2kUSFA4DfFJ3QxG	2024-12-11 14:01:38.066+00	2024-12-11 14:01:38.067+00	t	\N	\N	\N
38	test14	test14@test.test	$2b$10$RIRIQcxwnCfXhYVzP3tSGeftquKIe5gIIR2Kk9y3H1uODFBUWW4ta	2024-12-11 14:08:18.325+00	2024-12-11 14:08:18.326+00	t	\N	\N	\N
39	testuser	testuser@example.com	testpassword123	2024-12-11 14:10:44.313275+00	2024-12-11 14:10:44.313275+00	t	Test	User	\N
41	testuser2	testuser2@example.com	testpassword123	2024-12-11 14:13:22.556525+00	2024-12-11 14:13:22.556525+00	t	Test	User	\N
42	test15	test15@test.test	$2b$10$wTCpPJ3jUf.h5u0ff0cBxeNOuisXnz49X01MANJiMJKeSj4RNTftG	2024-12-11 14:15:16.569+00	2024-12-11 14:15:16.57+00	t	\N	\N	\N
45	test19	test19@test.test	$2b$10$byPmErd7/ce0L.RkxvKINul2eqQ8ve7utxDNQCqKhek1oLJ.PAogu	2024-12-11 14:33:02.977+00	2024-12-11 14:33:02.978+00	t	\N	\N	\N
46	test20	test20@test.test	$2b$10$CWIVg21UAZjC.MpSj1CATupJe44bgquVJs7n18pyrrMtXImzUj7fS	2024-12-11 14:38:22.575+00	2024-12-11 14:38:22.576+00	t	\N	\N	\N
47	test21	test21@test.test	$2b$10$zZB9Ca4DC0fmV.Gn6SFiOuxdvPiICsFxQT39HoA4hgATujOk6S2W6	2024-12-11 15:56:49.665+00	2024-12-11 15:56:49.667+00	t	\N	\N	\N
49	test22	test22@test.test	$2b$10$.psbVMU2AtF/qgFZ/ADMQetLRPbcbCKX8N9F3a1Nl4w.XBnPONbOe	2024-12-11 16:11:15.763+00	2024-12-11 16:11:15.764+00	t	\N	\N	\N
50	test23	test23@test.test	$2b$10$H5H3mbBxmu6hRVyYLSd.y.LyWYd82Dsoxn2Cz4in9RVSS0kc9fQVO	2024-12-11 16:17:22.359+00	2024-12-11 16:17:22.36+00	t	\N	\N	\N
51	test24	test24@test.test	$2b$10$oIaHw2XUzqIQxp0gUpzGruB1/xV8a/L80HKjh9NSKMoe/4x9lSmCm	2024-12-11 16:20:34.658+00	2024-12-11 16:20:34.659+00	t	\N	\N	\N
52	RachMoodle	rach@rach.rach	$2b$10$.SbdaJYmIU9Vn.dS5JJ7.eGEqM4HZz2io4/XuydNTQc.HojDQ/Npu	2024-12-16 17:25:07.067+00	2024-12-16 17:25:07.067+00	t	\N	\N	\N
53	TomDeane	tom@test.test	$2b$10$Xp6gTbg8b8SJSg8BEoy9zOcWyikabWp3/OYyTj5bvN.CmkNuzJpdG	2024-12-16 17:27:36.434+00	2024-12-16 17:27:36.434+00	t	\N	\N	\N
54	JeremyCollins	Jez@test.test	$2b$10$frEjxIQ2feSXrnF.mcJvgusxZVxmUSgtjgu73Venmu/5SmZtb8RTm	2024-12-16 17:28:02.479+00	2024-12-16 17:28:02.482+00	t	\N	\N	\N
55	RachaelMoodler	REM@test.test	$2b$10$U8g3UrkjEEc5KVFtJ0fjb.DPfEux0xOtxSAgEKtaSdwgMUeRFBZCm	2024-12-16 17:31:22.365+00	2024-12-16 17:31:22.367+00	t	\N	\N	\N
58	Testing account	test1@test.test	$2b$10$iVqHMtYbfrXaL1mFzztSf.9.Gjayu/deAahwldzEQZSUI5kqXWNpW	2024-12-19 16:19:31.55+00	2024-12-19 16:19:31.551+00	t	\N	\N	\N
56	Rachaelmoodie	rem@test.test	$2b$10$.uX.fu5MQjVSUlUmExiKYubh9nCuV8by38A5psS3bYAEQDKxS7/PO	2024-12-16 17:31:58.358+00	2024-12-16 17:31:58.358+00	t	FirstName	LastName	\N
59	RachTest	rach1@test.test	$2b$10$PuZjZHImBJiCeLPhqW4ZgOkCdbJjcxfcNpOtgO3PJ5pXIZjJdH4GK	2024-12-19 16:29:50.509+00	2024-12-19 16:29:50.509+00	t	\N	\N	\N
60	RachTest2	rach2@test.test	$2b$10$oRtXfzI.Ob.Zh54lNbkZuuKj9TxMbeESRY3OCfc7ikytxzFxa7J0W	2024-12-19 16:35:10.558+00	2024-12-19 16:35:10.559+00	t	Rach	Test	\N
61	paul	paul@test.test	$2b$10$JNNQ.Z7aAHKZglLCyQOM7.LKNfpm0JS7mEG6BidwjIUOCHkWzr6Ge	2025-01-02 17:31:50.378+00	2025-01-02 17:31:50.384+00	t	paul	deane	\N
\.


--
-- Name: collaborator_audit_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.collaborator_audit_audit_id_seq', 1, false);


--
-- Name: collaborator_role_attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.collaborator_role_attributes_id_seq', 1, false);


--
-- Name: companies_company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.companies_company_id_seq', 14, true);


--
-- Name: documents_document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.documents_document_id_seq', 12, true);


--
-- Name: project_status_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.project_status_history_history_id_seq', 1, false);


--
-- Name: projectcollaborators_collaborator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.projectcollaborators_collaborator_id_seq', 35, true);


--
-- Name: projects_project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.projects_project_id_seq', 28, true);


--
-- Name: role_attributes_attribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.role_attributes_attribute_id_seq', 1, false);


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 18, true);


--
-- Name: stages_stage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.stages_stage_id_seq', 229, true);


--
-- Name: taskassignments_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.taskassignments_assignment_id_seq', 33, true);


--
-- Name: taskdocuments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.taskdocuments_id_seq', 24, true);


--
-- Name: tasks_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.tasks_task_id_seq', 583, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.users_user_id_seq', 61, true);


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
-- Name: companies companies_company_email_key100; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key100 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key101; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key101 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key102; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key102 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key103; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key103 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key104; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key104 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key105; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key105 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key106; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key106 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key107; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key107 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key108; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key108 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key109; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key109 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key11; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key11 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key110; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key110 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key111; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key111 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key112; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key112 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key113; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key113 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key114; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key114 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key115; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key115 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key116; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key116 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key117; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key117 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key118; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key118 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key119; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key119 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key12; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key12 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key120; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key120 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key121; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key121 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key122; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key122 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key123; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key123 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key124; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key124 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key125; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key125 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key126; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key126 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key127; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key127 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key128; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key128 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key129; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key129 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key13; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key13 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key130; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key130 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key131; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key131 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key132; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key132 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key133; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key133 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key134; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key134 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key135; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key135 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key136; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key136 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key137; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key137 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key138; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key138 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key139; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key139 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key14; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key14 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key140; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key140 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key141; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key141 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key142; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key142 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key143; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key143 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key144; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key144 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key145; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key145 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key146; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key146 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key147; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key147 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key148; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key148 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key149; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key149 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key15; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key15 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key150; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key150 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key151; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key151 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key152; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key152 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key153; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key153 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key154; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key154 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key155; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key155 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key156; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key156 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key157; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key157 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key158; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key158 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key159; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key159 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key16; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key16 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key160; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key160 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key161; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key161 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key162; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key162 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key163; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key163 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key164; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key164 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key165; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key165 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key166; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key166 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key167; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key167 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key168; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key168 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key169; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key169 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key17; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key17 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key170; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key170 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key171; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key171 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key172; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key172 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key173; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key173 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key174; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key174 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key175; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key175 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key176; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key176 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key177; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key177 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key178; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key178 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key179; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key179 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key18; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key18 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key180; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key180 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key181; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key181 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key182; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key182 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key183; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key183 UNIQUE (company_email);


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
-- Name: companies companies_company_email_key98; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key98 UNIQUE (company_email);


--
-- Name: companies companies_company_email_key99; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_email_key99 UNIQUE (company_email);


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
-- Name: companies companies_company_name_key100; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key100 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key101; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key101 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key102; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key102 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key103; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key103 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key104; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key104 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key105; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key105 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key106; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key106 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key107; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key107 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key108; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key108 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key109; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key109 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key11; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key11 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key110; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key110 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key111; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key111 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key112; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key112 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key113; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key113 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key114; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key114 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key115; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key115 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key116; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key116 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key117; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key117 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key118; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key118 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key119; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key119 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key12; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key12 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key120; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key120 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key121; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key121 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key122; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key122 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key123; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key123 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key124; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key124 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key125; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key125 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key126; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key126 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key127; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key127 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key128; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key128 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key129; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key129 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key13; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key13 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key130; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key130 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key131; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key131 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key132; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key132 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key133; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key133 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key134; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key134 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key135; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key135 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key136; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key136 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key137; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key137 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key138; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key138 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key139; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key139 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key14; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key14 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key140; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key140 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key141; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key141 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key142; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key142 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key143; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key143 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key144; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key144 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key145; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key145 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key146; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key146 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key147; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key147 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key148; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key148 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key149; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key149 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key15; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key15 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key150; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key150 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key151; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key151 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key152; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key152 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key153; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key153 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key154; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key154 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key155; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key155 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key156; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key156 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key157; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key157 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key158; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key158 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key159; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key159 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key16; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key16 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key160; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key160 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key161; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key161 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key162; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key162 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key163; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key163 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key164; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key164 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key165; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key165 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key166; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key166 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key167; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key167 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key168; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key168 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key169; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key169 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key17; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key17 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key170; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key170 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key171; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key171 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key172; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key172 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key173; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key173 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key174; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key174 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key175; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key175 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key176; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key176 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key177; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key177 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key178; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key178 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key179; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key179 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key18; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key18 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key180; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key180 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key181; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key181 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key182; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key182 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key183; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key183 UNIQUE (company_name);


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
-- Name: companies companies_company_name_key97; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key97 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key98; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key98 UNIQUE (company_name);


--
-- Name: companies companies_company_name_key99; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_company_name_key99 UNIQUE (company_name);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (company_id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (document_id);


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
-- Name: taskdocuments taskdocuments_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.taskdocuments
    ADD CONSTRAINT taskdocuments_pkey PRIMARY KEY (id);


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
-- Name: documents documents_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(user_id) ON UPDATE CASCADE;


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
    ADD CONSTRAINT projects_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(user_id) ON UPDATE CASCADE;


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
-- Name: taskdocuments taskdocuments_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.taskdocuments
    ADD CONSTRAINT taskdocuments_document_id_fkey FOREIGN KEY (document_id) REFERENCES public.documents(document_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: taskdocuments taskdocuments_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.taskdocuments
    ADD CONSTRAINT taskdocuments_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tasks tasks_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: tasks tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON UPDATE CASCADE ON DELETE CASCADE;


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

