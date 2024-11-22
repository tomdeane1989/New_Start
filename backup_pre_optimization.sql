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
-- Name: TaskAssignments; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public."TaskAssignments" (
    task_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public."TaskAssignments" OWNER TO thomasdeane;

--
-- Name: projectcollaborators; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.projectcollaborators (
    collaborator_id integer NOT NULL,
    project_id integer NOT NULL,
    user_id integer NOT NULL,
    role public.enum_projectcollaborators_role NOT NULL,
    assigned_at timestamp with time zone
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
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    status character varying(255) DEFAULT 'active'::character varying,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    owner_id integer DEFAULT 3 NOT NULL
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
-- Name: stages; Type: TABLE; Schema: public; Owner: thomasdeane
--

CREATE TABLE public.stages (
    stage_id integer NOT NULL,
    stage_name character varying(255) NOT NULL,
    stage_order integer NOT NULL,
    description character varying(255),
    is_custom boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    project_id integer NOT NULL
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
    collaborator_id integer NOT NULL,
    can_view boolean DEFAULT true,
    can_edit boolean DEFAULT false
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
    task_name character varying(255) NOT NULL,
    description text,
    due_date timestamp with time zone,
    priority character varying(255),
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    is_completed boolean DEFAULT false,
    owner_id integer NOT NULL
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
    password_hash text NOT NULL,
    role character varying(255),
    phone_number character varying(255),
    address text,
    date_of_birth timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    is_active boolean DEFAULT true,
    bio text,
    profile_picture_url text,
    preferences jsonb,
    first_name character varying(255),
    last_name character varying(255)
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
-- Name: projectcollaborators collaborator_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.projectcollaborators ALTER COLUMN collaborator_id SET DEFAULT nextval('public.projectcollaborators_collaborator_id_seq'::regclass);


--
-- Name: projects project_id; Type: DEFAULT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.projects ALTER COLUMN project_id SET DEFAULT nextval('public.projects_project_id_seq'::regclass);


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
-- Data for Name: SequelizeMeta; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public."SequelizeMeta" (name) FROM stdin;
20241029084151-update-projectcollaborators-role-enum.js
20241031103945-add-owner-id-to-projects.js
\.


--
-- Data for Name: TaskAssignments; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public."TaskAssignments" (task_id, user_id) FROM stdin;
\.


--
-- Data for Name: projectcollaborators; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.projectcollaborators (collaborator_id, project_id, user_id, role, assigned_at) FROM stdin;
1	2	3	Estate Agent	2024-10-29 08:34:32.273+00
2	6	3	Estate Agent	2024-10-29 08:39:12.42+00
3	6	4	Estate Agent	2024-10-29 08:40:06.61+00
4	6	5	Seller Solicitor	2024-10-29 09:00:31.719+00
5	2	5	Seller Solicitor	2024-10-29 09:10:52.852+00
8	7	5	Seller Solicitor	2024-10-29 14:41:05.487+00
10	12	6	Seller Solicitor	2024-10-29 20:36:27.881+00
11	13	6	Seller Solicitor	2024-10-30 12:20:40.054+00
12	7	6	Seller Solicitor	2024-10-30 12:30:15.28+00
15	29	14	Seller	2024-11-01 14:05:09.681+00
16	29	12	Mortgage Advisor	2024-11-01 14:12:51.532+00
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.projects (project_id, project_name, description, created_at, updated_at, status, start_date, end_date, owner_id) FROM stdin;
32	BUY A HOUSE	Details about the property project	2024-11-01 14:27:21.484+00	2024-11-01 14:27:21.484+00	active	2024-11-01 14:27:21.484+00	\N	15
1	New Property Project	Details about the property project	2024-10-28 17:26:04.943+00	2024-10-28 17:26:04.943+00	active	2024-10-28 00:00:00+00	\N	3
2	New Property Project 2	Details about the property project	2024-10-28 18:01:55.768+00	2024-10-28 18:01:55.768+00	active	2024-10-28 00:00:00+00	\N	3
6	Update later on 29/10/24	Updated description	2024-10-29 08:38:41.506+00	2024-10-29 08:38:41.506+00	active	2024-11-01 00:00:00+00	2025-01-31 00:00:00+00	3
7	IMF Mission 1	Details about the property project	2024-10-29 09:22:20.982+00	2024-10-29 09:22:20.982+00	active	2024-10-29 00:00:00+00	\N	3
8	IMF Mission 1	Details about the property project	2024-10-29 15:22:27.176+00	2024-10-29 15:22:27.176+00	active	2024-10-29 00:00:00+00	\N	3
9	IMF Mission 2	Details about the property project	2024-10-29 15:38:41.869+00	2024-10-29 15:38:41.869+00	active	2024-10-29 00:00:00+00	\N	3
10	IMF Mission 3	Details about the property project	2024-10-29 15:45:35.121+00	2024-10-29 15:45:35.121+00	active	2024-10-29 00:00:00+00	\N	3
12	IMF Mission 4	Details about the property project	2024-10-29 20:28:48.75+00	2024-10-29 20:28:48.75+00	active	2024-10-29 00:00:00+00	\N	3
13	IMF Mission 4	Details about the property project	2024-10-30 09:50:40.028+00	2024-10-30 09:50:40.028+00	active	2024-10-30 09:50:40.028+00	\N	3
14	IMF Mission 4	Details about the property project	2024-10-30 09:52:42.317+00	2024-10-30 09:52:42.317+00	active	2024-10-30 09:52:42.317+00	\N	3
15	IMF Mission 5	Details about the property project	2024-10-30 09:53:11.861+00	2024-10-30 09:53:11.861+00	active	2024-10-30 09:53:11.861+00	\N	3
16	IMF Mission 5	Details about the property project	2024-10-30 10:08:34.68+00	2024-10-30 10:08:34.68+00	active	2024-10-30 10:08:34.68+00	\N	3
18	IMF Mission 5	Details about the property project	2024-10-30 12:27:12.057+00	2024-10-30 12:27:12.057+00	active	2024-10-30 12:27:12.057+00	\N	3
19	IMF Mission 9	Details about the property project	2024-10-30 16:33:25.227+00	2024-10-30 16:33:25.227+00	active	2024-10-30 16:33:25.227+00	\N	3
22	IMF Mission 10	Details about the property project	2024-10-30 17:02:00.894+00	2024-10-30 17:02:00.894+00	active	2024-10-30 17:02:00.894+00	\N	3
23	IMF Mission 10	Details about the property project	2024-10-30 17:20:11.493+00	2024-10-30 17:20:11.493+00	active	2024-10-30 17:20:11.493+00	\N	3
24	IMF Mission 10	Details about the property project	2024-10-30 17:23:50.748+00	2024-10-30 17:23:50.748+00	active	2024-10-30 17:23:50.748+00	\N	3
25	IMF Mission 11	Details about the property project	2024-10-30 17:28:18.858+00	2024-10-30 17:28:18.858+00	active	2024-10-30 17:28:18.858+00	\N	3
26	IMF Mission 11	Details about the property project	2024-10-30 17:30:54.517+00	2024-10-30 17:30:54.517+00	active	2024-10-30 17:30:54.517+00	\N	3
27	IMF Mission 11	Details about the property project	2024-10-30 17:34:26.415+00	2024-10-30 17:34:26.415+00	active	2024-10-30 17:34:26.415+00	\N	3
29	IMF Mission 11	Details about the property project	2024-11-01 12:14:04.085+00	2024-11-01 12:14:04.085+00	active	2024-11-01 12:14:04.085+00	\N	15
\.


--
-- Data for Name: stages; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.stages (stage_id, stage_name, stage_order, description, is_custom, created_at, updated_at, project_id) FROM stdin;
1	Initial Inquiry	1	Initial client inquiry and overview	f	2024-10-29 15:22:27.199+00	2024-10-29 15:22:27.199+00	8
2	Viewing	2	Viewing of the property	f	2024-10-29 15:22:27.199+00	2024-10-29 15:22:27.199+00	8
3	Offer Accepted	3	Offer accepted by the seller	f	2024-10-29 15:22:27.199+00	2024-10-29 15:22:27.199+00	8
4	Survey and Valuation	4	Property survey and valuation process	f	2024-10-29 15:22:27.199+00	2024-10-29 15:22:27.199+00	8
5	Mortgage Approved	5	Buyer’s mortgage approved	f	2024-10-29 15:22:27.199+00	2024-10-29 15:22:27.199+00	8
6	Legal Checks	6	Legal checks and title searches	f	2024-10-29 15:22:27.199+00	2024-10-29 15:22:27.199+00	8
7	Contracts Exchanged	7	Exchange of contracts	f	2024-10-29 15:22:27.199+00	2024-10-29 15:22:27.199+00	8
8	Completion	8	Completion of the sale	f	2024-10-29 15:22:27.199+00	2024-10-29 15:22:27.199+00	8
9	Misc	9	For any tasks outside of the standard stages	t	2024-10-29 15:22:27.199+00	2024-10-29 15:22:27.199+00	8
10	Initial Inquiry	1	Initial client inquiry and overview	f	2024-10-29 15:38:41.884+00	2024-10-29 15:38:41.884+00	9
11	Viewing	2	Viewing of the property	f	2024-10-29 15:38:41.884+00	2024-10-29 15:38:41.884+00	9
12	Offer Accepted	3	Offer accepted by the seller	f	2024-10-29 15:38:41.884+00	2024-10-29 15:38:41.884+00	9
13	Survey and Valuation	4	Property survey and valuation process	f	2024-10-29 15:38:41.884+00	2024-10-29 15:38:41.884+00	9
14	Mortgage Approved	5	Buyer’s mortgage approved	f	2024-10-29 15:38:41.884+00	2024-10-29 15:38:41.884+00	9
15	Legal Checks	6	Legal checks and title searches	f	2024-10-29 15:38:41.884+00	2024-10-29 15:38:41.884+00	9
16	Contracts Exchanged	7	Exchange of contracts	f	2024-10-29 15:38:41.884+00	2024-10-29 15:38:41.884+00	9
17	Completion	8	Completion of the sale	f	2024-10-29 15:38:41.884+00	2024-10-29 15:38:41.884+00	9
18	Misc	9	For any tasks outside of the standard stages	t	2024-10-29 15:38:41.884+00	2024-10-29 15:38:41.884+00	9
19	Viewings	1	Initial viewings of the property	f	2024-10-29 15:45:35.149+00	2024-10-29 15:45:35.149+00	10
20	Offer Stage	2	Stage of making an offer on the property	f	2024-10-29 15:45:35.149+00	2024-10-29 15:45:35.149+00	10
21	Offer Accepted	3	Offer accepted by the seller	f	2024-10-29 15:45:35.149+00	2024-10-29 15:45:35.149+00	10
22	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-10-29 15:45:35.149+00	2024-10-29 15:45:35.149+00	10
23	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-10-29 15:45:35.149+00	2024-10-29 15:45:35.149+00	10
24	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-10-29 15:45:35.149+00	2024-10-29 15:45:35.149+00	10
25	Key Exchange	7	Final exchange of keys and property ownership	f	2024-10-29 15:45:35.149+00	2024-10-29 15:45:35.149+00	10
26	Misc	8	For any tasks outside of the standard stages	t	2024-10-29 15:45:35.149+00	2024-10-29 15:45:35.149+00	10
37	Custom Stage	9	This is a new custom stage	t	2024-10-29 20:27:13.319+00	2024-10-29 20:27:13.319+00	10
38	Viewings	1	Initial viewings of the property	f	2024-10-29 20:28:48.781+00	2024-10-29 20:28:48.781+00	12
39	Offer Stage	2	Stage of making an offer on the property	f	2024-10-29 20:28:48.781+00	2024-10-29 20:28:48.781+00	12
40	Offer Accepted	3	Offer accepted by the seller	f	2024-10-29 20:28:48.781+00	2024-10-29 20:28:48.781+00	12
41	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-10-29 20:28:48.781+00	2024-10-29 20:28:48.781+00	12
42	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-10-29 20:28:48.781+00	2024-10-29 20:28:48.781+00	12
43	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-10-29 20:28:48.781+00	2024-10-29 20:28:48.781+00	12
44	Key Exchange	7	Final exchange of keys and property ownership	f	2024-10-29 20:28:48.781+00	2024-10-29 20:28:48.781+00	12
45	Misc	8	For any tasks outside of the standard stages	t	2024-10-29 20:28:48.781+00	2024-10-29 20:28:48.781+00	12
46	Custom Stage	9	This is a new custom stage	t	2024-10-29 20:36:48.192+00	2024-10-29 20:36:48.192+00	10
47	Viewings	1	Initial viewings of the property	f	2024-10-30 10:08:34.691+00	2024-10-30 10:08:34.691+00	16
48	Offer Stage	2	Stage of making an offer on the property	f	2024-10-30 10:08:34.691+00	2024-10-30 10:08:34.691+00	16
49	Offer Accepted	3	Offer accepted by the seller	f	2024-10-30 10:08:34.691+00	2024-10-30 10:08:34.691+00	16
50	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-10-30 10:08:34.691+00	2024-10-30 10:08:34.691+00	16
51	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-10-30 10:08:34.691+00	2024-10-30 10:08:34.691+00	16
52	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-10-30 10:08:34.691+00	2024-10-30 10:08:34.691+00	16
53	Key Exchange	7	Final exchange of keys and property ownership	f	2024-10-30 10:08:34.691+00	2024-10-30 10:08:34.691+00	16
54	Misc	8	For any tasks outside of the standard stages	t	2024-10-30 10:08:34.691+00	2024-10-30 10:08:34.691+00	16
63	Viewings	1	Initial viewings of the property	f	2024-10-30 12:27:12.08+00	2024-10-30 12:27:12.08+00	18
64	Offer Stage	2	Stage of making an offer on the property	f	2024-10-30 12:27:12.08+00	2024-10-30 12:27:12.08+00	18
65	Offer Accepted	3	Offer accepted by the seller	f	2024-10-30 12:27:12.08+00	2024-10-30 12:27:12.08+00	18
66	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-10-30 12:27:12.08+00	2024-10-30 12:27:12.08+00	18
67	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-10-30 12:27:12.08+00	2024-10-30 12:27:12.08+00	18
68	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-10-30 12:27:12.08+00	2024-10-30 12:27:12.08+00	18
69	Key Exchange	7	Final exchange of keys and property ownership	f	2024-10-30 12:27:12.08+00	2024-10-30 12:27:12.08+00	18
70	Misc	8	For any tasks outside of the standard stages	t	2024-10-30 12:27:12.08+00	2024-10-30 12:27:12.08+00	18
72	Viewings	1	Initial viewings of the property	f	2024-10-30 16:33:25.262+00	2024-10-30 16:33:25.262+00	19
73	Offer Stage	2	Stage of making an offer on the property	f	2024-10-30 16:33:25.262+00	2024-10-30 16:33:25.262+00	19
74	Offer Accepted	3	Offer accepted by the seller	f	2024-10-30 16:33:25.262+00	2024-10-30 16:33:25.262+00	19
75	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-10-30 16:33:25.262+00	2024-10-30 16:33:25.262+00	19
76	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-10-30 16:33:25.262+00	2024-10-30 16:33:25.262+00	19
77	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-10-30 16:33:25.262+00	2024-10-30 16:33:25.262+00	19
78	Key Exchange	7	Final exchange of keys and property ownership	f	2024-10-30 16:33:25.262+00	2024-10-30 16:33:25.262+00	19
79	Misc	8	For any tasks outside of the standard stages	t	2024-10-30 16:33:25.262+00	2024-10-30 16:33:25.262+00	19
80	Viewings	1	Initial viewings of the property	f	2024-10-30 17:02:00.922+00	2024-10-30 17:02:00.922+00	22
81	Offer Stage	2	Stage of making an offer on the property	f	2024-10-30 17:02:00.922+00	2024-10-30 17:02:00.922+00	22
82	Offer Accepted	3	Offer accepted by the seller	f	2024-10-30 17:02:00.922+00	2024-10-30 17:02:00.922+00	22
83	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-10-30 17:02:00.922+00	2024-10-30 17:02:00.922+00	22
84	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-10-30 17:02:00.922+00	2024-10-30 17:02:00.922+00	22
85	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-10-30 17:02:00.922+00	2024-10-30 17:02:00.922+00	22
86	Key Exchange	7	Final exchange of keys and property ownership	f	2024-10-30 17:02:00.922+00	2024-10-30 17:02:00.922+00	22
87	Misc	8	For any tasks outside of the standard stages	t	2024-10-30 17:02:00.922+00	2024-10-30 17:02:00.922+00	22
88	Viewings	1	Initial viewings of the property	f	2024-10-30 17:20:11.515+00	2024-10-30 17:20:11.515+00	23
89	Offer Stage	2	Stage of making an offer on the property	f	2024-10-30 17:20:11.515+00	2024-10-30 17:20:11.515+00	23
90	Offer Accepted	3	Offer accepted by the seller	f	2024-10-30 17:20:11.515+00	2024-10-30 17:20:11.515+00	23
91	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-10-30 17:20:11.515+00	2024-10-30 17:20:11.515+00	23
92	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-10-30 17:20:11.515+00	2024-10-30 17:20:11.515+00	23
93	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-10-30 17:20:11.515+00	2024-10-30 17:20:11.515+00	23
94	Key Exchange	7	Final exchange of keys and property ownership	f	2024-10-30 17:20:11.515+00	2024-10-30 17:20:11.515+00	23
95	Misc	8	For any tasks outside of the standard stages	t	2024-10-30 17:20:11.515+00	2024-10-30 17:20:11.515+00	23
96	Viewings	1	Initial viewings of the property	f	2024-10-30 17:23:50.791+00	2024-10-30 17:23:50.791+00	24
97	Offer Stage	2	Stage of making an offer on the property	f	2024-10-30 17:23:50.791+00	2024-10-30 17:23:50.791+00	24
98	Offer Accepted	3	Offer accepted by the seller	f	2024-10-30 17:23:50.791+00	2024-10-30 17:23:50.791+00	24
99	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-10-30 17:23:50.791+00	2024-10-30 17:23:50.791+00	24
100	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-10-30 17:23:50.791+00	2024-10-30 17:23:50.791+00	24
101	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-10-30 17:23:50.791+00	2024-10-30 17:23:50.791+00	24
102	Key Exchange	7	Final exchange of keys and property ownership	f	2024-10-30 17:23:50.791+00	2024-10-30 17:23:50.791+00	24
103	Misc	8	For any tasks outside of the standard stages	t	2024-10-30 17:23:50.791+00	2024-10-30 17:23:50.791+00	24
104	Viewings	1	Initial viewings of the property	f	2024-10-30 17:28:18.893+00	2024-10-30 17:28:18.893+00	25
105	Offer Stage	2	Stage of making an offer on the property	f	2024-10-30 17:28:18.893+00	2024-10-30 17:28:18.893+00	25
106	Offer Accepted	3	Offer accepted by the seller	f	2024-10-30 17:28:18.893+00	2024-10-30 17:28:18.893+00	25
107	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-10-30 17:28:18.893+00	2024-10-30 17:28:18.893+00	25
108	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-10-30 17:28:18.893+00	2024-10-30 17:28:18.893+00	25
109	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-10-30 17:28:18.893+00	2024-10-30 17:28:18.893+00	25
110	Key Exchange	7	Final exchange of keys and property ownership	f	2024-10-30 17:28:18.893+00	2024-10-30 17:28:18.893+00	25
111	Misc	8	For any tasks outside of the standard stages	t	2024-10-30 17:28:18.893+00	2024-10-30 17:28:18.893+00	25
112	Viewings	1	Initial viewings of the property	f	2024-10-30 17:30:54.536+00	2024-10-30 17:30:54.536+00	26
113	Offer Stage	2	Stage of making an offer on the property	f	2024-10-30 17:30:54.536+00	2024-10-30 17:30:54.536+00	26
114	Offer Accepted	3	Offer accepted by the seller	f	2024-10-30 17:30:54.536+00	2024-10-30 17:30:54.536+00	26
115	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-10-30 17:30:54.536+00	2024-10-30 17:30:54.536+00	26
116	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-10-30 17:30:54.536+00	2024-10-30 17:30:54.536+00	26
117	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-10-30 17:30:54.536+00	2024-10-30 17:30:54.536+00	26
118	Key Exchange	7	Final exchange of keys and property ownership	f	2024-10-30 17:30:54.536+00	2024-10-30 17:30:54.536+00	26
119	Misc	8	For any tasks outside of the standard stages	t	2024-10-30 17:30:54.536+00	2024-10-30 17:30:54.536+00	26
120	Viewings	1	Initial viewings of the property	f	2024-10-30 17:34:26.427+00	2024-10-30 17:34:26.427+00	27
121	Offer Stage	2	Stage of making an offer on the property	f	2024-10-30 17:34:26.427+00	2024-10-30 17:34:26.427+00	27
122	Offer Accepted	3	Offer accepted by the seller	f	2024-10-30 17:34:26.427+00	2024-10-30 17:34:26.427+00	27
123	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-10-30 17:34:26.427+00	2024-10-30 17:34:26.427+00	27
124	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-10-30 17:34:26.427+00	2024-10-30 17:34:26.427+00	27
125	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-10-30 17:34:26.427+00	2024-10-30 17:34:26.427+00	27
126	Key Exchange	7	Final exchange of keys and property ownership	f	2024-10-30 17:34:26.427+00	2024-10-30 17:34:26.427+00	27
127	Misc	8	For any tasks outside of the standard stages	t	2024-10-30 17:34:26.427+00	2024-10-30 17:34:26.427+00	27
137	Viewings	1	Initial viewings of the property	f	2024-11-01 12:14:04.14+00	2024-11-01 12:14:04.14+00	29
138	Offer Stage	2	Stage of making an offer on the property	f	2024-11-01 12:14:04.14+00	2024-11-01 12:14:04.14+00	29
139	Offer Accepted	3	Offer accepted by the seller	f	2024-11-01 12:14:04.14+00	2024-11-01 12:14:04.14+00	29
140	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-11-01 12:14:04.14+00	2024-11-01 12:14:04.14+00	29
141	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-11-01 12:14:04.14+00	2024-11-01 12:14:04.14+00	29
142	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-11-01 12:14:04.14+00	2024-11-01 12:14:04.14+00	29
143	Key Exchange	7	Final exchange of keys and property ownership	f	2024-11-01 12:14:04.14+00	2024-11-01 12:14:04.14+00	29
144	Misc	8	For any tasks outside of the standard stages	t	2024-11-01 12:14:04.14+00	2024-11-01 12:14:04.14+00	29
162	Viewings	1	Initial viewings of the property	f	2024-11-01 14:27:21.534+00	2024-11-01 14:27:21.534+00	32
163	Offer Stage	2	Stage of making an offer on the property	f	2024-11-01 14:27:21.534+00	2024-11-01 14:27:21.534+00	32
164	Offer Accepted	3	Offer accepted by the seller	f	2024-11-01 14:27:21.534+00	2024-11-01 14:27:21.534+00	32
165	Legal, Surveys, & Compliance	4	Legal checks, surveys, and compliance checks	f	2024-11-01 14:27:21.534+00	2024-11-01 14:27:21.534+00	32
166	Mortgage Application	5	Processing of buyer’s mortgage application	f	2024-11-01 14:27:21.534+00	2024-11-01 14:27:21.534+00	32
167	Contract Exchange	6	Exchange of contracts between buyer and seller	f	2024-11-01 14:27:21.534+00	2024-11-01 14:27:21.534+00	32
168	Key Exchange	7	Final exchange of keys and property ownership	f	2024-11-01 14:27:21.534+00	2024-11-01 14:27:21.534+00	32
169	Misc	8	For any tasks outside of the standard stages	t	2024-11-01 14:27:21.534+00	2024-11-01 14:27:21.534+00	32
\.


--
-- Data for Name: taskassignments; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.taskassignments (assignment_id, task_id, collaborator_id, can_view, can_edit) FROM stdin;
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.tasks (task_id, project_id, stage_id, task_name, description, due_date, priority, created_at, updated_at, is_completed, owner_id) FROM stdin;
2	27	120	Call TSB	Gather all necessary documents for the project	2024-12-01 00:00:00+00	high	2024-10-31 13:29:47.589+00	2024-10-31 13:29:47.589+00	f	3
4	27	120	Call TSB	Gather all necessary documents for the project	2024-12-01 00:00:00+00	high	2024-10-31 14:53:51.613+00	2024-10-31 14:53:51.613+00	f	3
6	29	162	Viewing of Tymecross	Gather all necessary documents for the project	2024-12-01 00:00:00+00	high	2024-11-01 15:20:45.592+00	2024-11-01 15:20:45.592+00	f	15
8	29	162	Viewing of Davidsons Little Bowden	Gather all necessary documents for the project	\N	\N	2024-11-01 17:04:32.32+00	2024-11-01 17:04:32.32+00	f	15
5	29	162	2nd Viewing of Coleridge Way	Updated task description	2024-12-15 00:00:00+00	medium	2024-11-01 14:36:27.05+00	2024-11-01 14:36:27.051+00	f	15
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: thomasdeane
--

COPY public.users (user_id, username, email, password_hash, role, phone_number, address, date_of_birth, created_at, updated_at, is_active, bio, profile_picture_url, preferences, first_name, last_name) FROM stdin;
4	CIA	test2@test.com	$2b$10$jP2mzRzV3YkiySJ.GH7Icu4GQVlXU6dhr9muyEugGvZJCcKaViCIK	Private	\N	\N	\N	2024-10-29 07:57:01.305+00	2024-10-29 07:57:01.306+00	t	\N	\N	\N	Jason	Bourne
5	FBI	test3@test.com	$2b$10$rMb6pcF1IFiy.NqL3OKFZu27VUsYNwx8miGcUH2bpYKP9hN2IreFy	Private	\N	\N	\N	2024-10-29 09:00:01.475+00	2024-10-29 09:00:01.476+00	t	\N	\N	\N	Clarice	Starling
6	MET	test4@test.com	$2b$10$zCJOMy5iKfCnTFOmx.qApudTditiW9TwT8RIieqSALOYxfvC1QgGm	Private	\N	\N	\N	2024-10-29 09:16:11.424+00	2024-10-29 09:16:11.424+00	t	\N	\N	\N	Sherlock	Holmes
1	007	test@test.com	$2b$10$A4AXXNn/ZZUDfM2RMlPwaeoUGAwZYvf2jIF5RoCmSj9xdTTHdJWSK	Private	\N	\N	\N	2024-10-28 16:19:18.906+00	2024-10-28 16:19:18.906+00	t	\N	\N	\N	James	Bond
3	IMF	test1@test.com	$2b$10$4UOJFp6.eSfKkORxghka5.jUQvNXjhPbeH0iQRqNp9aMAB8nr4xYy	Private	\N	\N	\N	2024-10-28 18:02:33.701+00	2024-10-28 18:02:33.701+00	t	\N	\N	\N	Ethan	Hunt
12	NYPD	test9@test.com	$2b$10$IAcDcFQyApPmlT6qIu.pK.xhZZBkolqaKcr7yBrtFfskKKknYVgoa	Private	\N	\N	\N	2024-10-30 16:26:05.466+00	2024-10-30 16:26:05.466+00	t	\N	\N	\N	John	McClane
9	MP	test8@test.com	$2b$10$bOvx2FR5Q90J8/2uJ9BBTuKr4NlCTj9pDA4p/wXKQaWKysoBDWwvK	Professional	\N	\N	\N	2024-10-30 12:23:28.922+00	2024-10-30 12:23:28.922+00	t	\N	\N	\N	Jack	Reacher
14	MI6	test10@test.com	$2b$10$QMtvgi0AiHcqdUJNhaebz.6qjRrZFY5yYiapBanufaGkBMeU7hSvu	Private	\N	\N	\N	2024-11-01 12:11:14.838+00	2024-11-01 12:11:14.838+00	t	\N	\N	\N	Johnny	English
15	Brooklyn 99	test12@test.com	$2b$10$4pfGXMSIraSV5LOFKSfULO4qVwR5rKSC6BFsx44LINFOI3DkYFiOO	Private	\N	\N	\N	2024-11-01 12:11:55.879+00	2024-11-01 12:11:55.879+00	t	\N	\N	\N	Jake	Piralta
16	Moodler	rachaelmoodie@hotmail.co.uk	$2b$10$vU9OnURBCisoJQtaNSCZveWUjY/CpYUjrcwi32Ye5mMME.9L5QiVa	Private	\N	\N	\N	2024-11-03 12:21:26.452+00	2024-11-03 12:21:26.452+00	t	\N	\N	\N	Rach	Moodie
\.


--
-- Name: projectcollaborators_collaborator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.projectcollaborators_collaborator_id_seq', 16, true);


--
-- Name: projects_project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.projects_project_id_seq', 32, true);


--
-- Name: stages_stage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.stages_stage_id_seq', 169, true);


--
-- Name: taskassignments_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.taskassignments_assignment_id_seq', 1, false);


--
-- Name: tasks_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.tasks_task_id_seq', 8, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thomasdeane
--

SELECT pg_catalog.setval('public.users_user_id_seq', 16, true);


--
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- Name: TaskAssignments TaskAssignments_pkey; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public."TaskAssignments"
    ADD CONSTRAINT "TaskAssignments_pkey" PRIMARY KEY (task_id, user_id);


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
-- Name: taskassignments taskassignments_task_id_collaborator_id_key; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.taskassignments
    ADD CONSTRAINT taskassignments_task_id_collaborator_id_key UNIQUE (task_id, collaborator_id);


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
-- Name: users users_email_key5; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key5 UNIQUE (email);


--
-- Name: users users_email_key6; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key6 UNIQUE (email);


--
-- Name: users users_email_key7; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key7 UNIQUE (email);


--
-- Name: users users_email_key8; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key8 UNIQUE (email);


--
-- Name: users users_email_key9; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key9 UNIQUE (email);


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
-- Name: users users_username_key11; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key11 UNIQUE (username);


--
-- Name: users users_username_key12; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key12 UNIQUE (username);


--
-- Name: users users_username_key13; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key13 UNIQUE (username);


--
-- Name: users users_username_key14; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key14 UNIQUE (username);


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
-- Name: users users_username_key5; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key5 UNIQUE (username);


--
-- Name: users users_username_key6; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key6 UNIQUE (username);


--
-- Name: users users_username_key7; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key7 UNIQUE (username);


--
-- Name: users users_username_key8; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key8 UNIQUE (username);


--
-- Name: users users_username_key9; Type: CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key9 UNIQUE (username);


--
-- Name: TaskAssignments TaskAssignments_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public."TaskAssignments"
    ADD CONSTRAINT "TaskAssignments_task_id_fkey" FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TaskAssignments TaskAssignments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public."TaskAssignments"
    ADD CONSTRAINT "TaskAssignments_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: stages stages_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON DELETE CASCADE;


--
-- Name: taskassignments taskassignments_collaborator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.taskassignments
    ADD CONSTRAINT taskassignments_collaborator_id_fkey FOREIGN KEY (collaborator_id) REFERENCES public.projectcollaborators(collaborator_id) ON DELETE CASCADE;


--
-- Name: taskassignments taskassignments_collaborator_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.taskassignments
    ADD CONSTRAINT taskassignments_collaborator_id_fkey1 FOREIGN KEY (collaborator_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: taskassignments taskassignments_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.taskassignments
    ADD CONSTRAINT taskassignments_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tasks tasks_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(user_id) ON UPDATE CASCADE;


--
-- Name: tasks tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON UPDATE CASCADE;


--
-- Name: tasks tasks_stage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomasdeane
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.stages(stage_id) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--

