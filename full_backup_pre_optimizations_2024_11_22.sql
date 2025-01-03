PGDMP                      
    |         
   project_db    14.13 (Homebrew)    14.13 (Homebrew) �    Z           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            [           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            \           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            ]           1262    16384 
   project_db    DATABASE     _   CREATE DATABASE project_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';
    DROP DATABASE project_db;
                thomasdeane    false            X           1247    16543    enum_projectcollaborators_role    TYPE     �   CREATE TYPE public.enum_projectcollaborators_role AS ENUM (
    'Buyer',
    'Seller',
    'Mortgage Advisor',
    'Seller Solicitor',
    'Buyer Solicitor',
    'Estate Agent'
);
 1   DROP TYPE public.enum_projectcollaborators_role;
       public          thomasdeane    false            �            1259    16505    SequelizeMeta    TABLE     R   CREATE TABLE public."SequelizeMeta" (
    name character varying(255) NOT NULL
);
 #   DROP TABLE public."SequelizeMeta";
       public         heap    thomasdeane    false            �            1259    17420    TaskAssignments    TABLE     f   CREATE TABLE public."TaskAssignments" (
    task_id integer NOT NULL,
    user_id integer NOT NULL
);
 %   DROP TABLE public."TaskAssignments";
       public         heap    thomasdeane    false            �            1259    16436    projectcollaborators    TABLE     �   CREATE TABLE public.projectcollaborators (
    collaborator_id integer NOT NULL,
    project_id integer NOT NULL,
    user_id integer NOT NULL,
    role public.enum_projectcollaborators_role NOT NULL,
    assigned_at timestamp with time zone
);
 (   DROP TABLE public.projectcollaborators;
       public         heap    thomasdeane    false    856            �            1259    16435 (   projectcollaborators_collaborator_id_seq    SEQUENCE     �   CREATE SEQUENCE public.projectcollaborators_collaborator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.projectcollaborators_collaborator_id_seq;
       public          thomasdeane    false    216            ^           0    0 (   projectcollaborators_collaborator_id_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.projectcollaborators_collaborator_id_seq OWNED BY public.projectcollaborators.collaborator_id;
          public          thomasdeane    false    215            �            1259    16402    projects    TABLE     �  CREATE TABLE public.projects (
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
    DROP TABLE public.projects;
       public         heap    thomasdeane    false            �            1259    16401    projects_project_id_seq    SEQUENCE     �   CREATE SEQUENCE public.projects_project_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.projects_project_id_seq;
       public          thomasdeane    false    212            _           0    0    projects_project_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.projects_project_id_seq OWNED BY public.projects.project_id;
          public          thomasdeane    false    211            �            1259    16419    stages    TABLE     k  CREATE TABLE public.stages (
    stage_id integer NOT NULL,
    stage_name character varying(255) NOT NULL,
    stage_order integer NOT NULL,
    description character varying(255),
    is_custom boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    project_id integer NOT NULL
);
    DROP TABLE public.stages;
       public         heap    thomasdeane    false            �            1259    16418    stages_stage_id_seq    SEQUENCE     �   CREATE SEQUENCE public.stages_stage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.stages_stage_id_seq;
       public          thomasdeane    false    214            `           0    0    stages_stage_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.stages_stage_id_seq OWNED BY public.stages.stage_id;
          public          thomasdeane    false    213            �            1259    16478    taskassignments    TABLE     �   CREATE TABLE public.taskassignments (
    assignment_id integer NOT NULL,
    task_id integer NOT NULL,
    collaborator_id integer NOT NULL,
    can_view boolean DEFAULT true,
    can_edit boolean DEFAULT false
);
 #   DROP TABLE public.taskassignments;
       public         heap    thomasdeane    false            �            1259    16477 !   taskassignments_assignment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.taskassignments_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.taskassignments_assignment_id_seq;
       public          thomasdeane    false    220            a           0    0 !   taskassignments_assignment_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.taskassignments_assignment_id_seq OWNED BY public.taskassignments.assignment_id;
          public          thomasdeane    false    219            �            1259    16456    tasks    TABLE     �  CREATE TABLE public.tasks (
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
    DROP TABLE public.tasks;
       public         heap    thomasdeane    false            �            1259    16455    tasks_task_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tasks_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.tasks_task_id_seq;
       public          thomasdeane    false    218            b           0    0    tasks_task_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.tasks_task_id_seq OWNED BY public.tasks.task_id;
          public          thomasdeane    false    217            �            1259    16386    users    TABLE     D  CREATE TABLE public.users (
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
    DROP TABLE public.users;
       public         heap    thomasdeane    false            �            1259    16385    users_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          thomasdeane    false    210            c           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          thomasdeane    false    209            �           2604    16439 $   projectcollaborators collaborator_id    DEFAULT     �   ALTER TABLE ONLY public.projectcollaborators ALTER COLUMN collaborator_id SET DEFAULT nextval('public.projectcollaborators_collaborator_id_seq'::regclass);
 S   ALTER TABLE public.projectcollaborators ALTER COLUMN collaborator_id DROP DEFAULT;
       public          thomasdeane    false    216    215    216            �           2604    16405    projects project_id    DEFAULT     z   ALTER TABLE ONLY public.projects ALTER COLUMN project_id SET DEFAULT nextval('public.projects_project_id_seq'::regclass);
 B   ALTER TABLE public.projects ALTER COLUMN project_id DROP DEFAULT;
       public          thomasdeane    false    211    212    212            �           2604    16422    stages stage_id    DEFAULT     r   ALTER TABLE ONLY public.stages ALTER COLUMN stage_id SET DEFAULT nextval('public.stages_stage_id_seq'::regclass);
 >   ALTER TABLE public.stages ALTER COLUMN stage_id DROP DEFAULT;
       public          thomasdeane    false    213    214    214            �           2604    16481    taskassignments assignment_id    DEFAULT     �   ALTER TABLE ONLY public.taskassignments ALTER COLUMN assignment_id SET DEFAULT nextval('public.taskassignments_assignment_id_seq'::regclass);
 L   ALTER TABLE public.taskassignments ALTER COLUMN assignment_id DROP DEFAULT;
       public          thomasdeane    false    220    219    220            �           2604    16459    tasks task_id    DEFAULT     n   ALTER TABLE ONLY public.tasks ALTER COLUMN task_id SET DEFAULT nextval('public.tasks_task_id_seq'::regclass);
 <   ALTER TABLE public.tasks ALTER COLUMN task_id DROP DEFAULT;
       public          thomasdeane    false    218    217    218            �           2604    16389    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          thomasdeane    false    209    210    210            V          0    16505    SequelizeMeta 
   TABLE DATA           /   COPY public."SequelizeMeta" (name) FROM stdin;
    public          thomasdeane    false    221   {�       W          0    17420    TaskAssignments 
   TABLE DATA           =   COPY public."TaskAssignments" (task_id, user_id) FROM stdin;
    public          thomasdeane    false    222   ��       Q          0    16436    projectcollaborators 
   TABLE DATA           g   COPY public.projectcollaborators (collaborator_id, project_id, user_id, role, assigned_at) FROM stdin;
    public          thomasdeane    false    216   �       M          0    16402    projects 
   TABLE DATA           �   COPY public.projects (project_id, project_name, description, created_at, updated_at, status, start_date, end_date, owner_id) FROM stdin;
    public          thomasdeane    false    212   ��       O          0    16419    stages 
   TABLE DATA              COPY public.stages (stage_id, stage_name, stage_order, description, is_custom, created_at, updated_at, project_id) FROM stdin;
    public          thomasdeane    false    214   S�       U          0    16478    taskassignments 
   TABLE DATA           f   COPY public.taskassignments (assignment_id, task_id, collaborator_id, can_view, can_edit) FROM stdin;
    public          thomasdeane    false    220   e�       S          0    16456    tasks 
   TABLE DATA           �   COPY public.tasks (task_id, project_id, stage_id, task_name, description, due_date, priority, created_at, updated_at, is_completed, owner_id) FROM stdin;
    public          thomasdeane    false    218   ��       K          0    16386    users 
   TABLE DATA           �   COPY public.users (user_id, username, email, password_hash, role, phone_number, address, date_of_birth, created_at, updated_at, is_active, bio, profile_picture_url, preferences, first_name, last_name) FROM stdin;
    public          thomasdeane    false    210   ��       d           0    0 (   projectcollaborators_collaborator_id_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public.projectcollaborators_collaborator_id_seq', 16, true);
          public          thomasdeane    false    215            e           0    0    projects_project_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.projects_project_id_seq', 32, true);
          public          thomasdeane    false    211            f           0    0    stages_stage_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.stages_stage_id_seq', 169, true);
          public          thomasdeane    false    213            g           0    0 !   taskassignments_assignment_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.taskassignments_assignment_id_seq', 1, false);
          public          thomasdeane    false    219            h           0    0    tasks_task_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.tasks_task_id_seq', 8, true);
          public          thomasdeane    false    217            i           0    0    users_user_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_user_id_seq', 16, true);
          public          thomasdeane    false    209            �           2606    16509     SequelizeMeta SequelizeMeta_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);
 N   ALTER TABLE ONLY public."SequelizeMeta" DROP CONSTRAINT "SequelizeMeta_pkey";
       public            thomasdeane    false    221            �           2606    17424 $   TaskAssignments TaskAssignments_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."TaskAssignments"
    ADD CONSTRAINT "TaskAssignments_pkey" PRIMARY KEY (task_id, user_id);
 R   ALTER TABLE ONLY public."TaskAssignments" DROP CONSTRAINT "TaskAssignments_pkey";
       public            thomasdeane    false    222    222            �           2606    16442 .   projectcollaborators projectcollaborators_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public.projectcollaborators
    ADD CONSTRAINT projectcollaborators_pkey PRIMARY KEY (collaborator_id);
 X   ALTER TABLE ONLY public.projectcollaborators DROP CONSTRAINT projectcollaborators_pkey;
       public            thomasdeane    false    216            �           2606    18129 @   projectcollaborators projectcollaborators_project_id_user_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.projectcollaborators
    ADD CONSTRAINT projectcollaborators_project_id_user_id_key UNIQUE (project_id, user_id);
 j   ALTER TABLE ONLY public.projectcollaborators DROP CONSTRAINT projectcollaborators_project_id_user_id_key;
       public            thomasdeane    false    216    216            �           2606    16412    projects projects_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project_id);
 @   ALTER TABLE ONLY public.projects DROP CONSTRAINT projects_pkey;
       public            thomasdeane    false    212            �           2606    16429    stages stages_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (stage_id);
 <   ALTER TABLE ONLY public.stages DROP CONSTRAINT stages_pkey;
       public            thomasdeane    false    214            �           2606    16485 $   taskassignments taskassignments_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.taskassignments
    ADD CONSTRAINT taskassignments_pkey PRIMARY KEY (assignment_id);
 N   ALTER TABLE ONLY public.taskassignments DROP CONSTRAINT taskassignments_pkey;
       public            thomasdeane    false    220            �           2606    16487 ;   taskassignments taskassignments_task_id_collaborator_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.taskassignments
    ADD CONSTRAINT taskassignments_task_id_collaborator_id_key UNIQUE (task_id, collaborator_id);
 e   ALTER TABLE ONLY public.taskassignments DROP CONSTRAINT taskassignments_task_id_collaborator_id_key;
       public            thomasdeane    false    220    220            �           2606    16466    tasks tasks_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (task_id);
 :   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pkey;
       public            thomasdeane    false    218            �           2606    23654    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            thomasdeane    false    210            �           2606    23656    users users_email_key1 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key1 UNIQUE (email);
 @   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key1;
       public            thomasdeane    false    210            �           2606    23674    users users_email_key10 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key10 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key10;
       public            thomasdeane    false    210            �           2606    23676    users users_email_key11 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key11 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key11;
       public            thomasdeane    false    210            �           2606    23678    users users_email_key12 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key12 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key12;
       public            thomasdeane    false    210            �           2606    23680    users users_email_key13 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key13 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key13;
       public            thomasdeane    false    210            �           2606    23682    users users_email_key14 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key14 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key14;
       public            thomasdeane    false    210            �           2606    23684    users users_email_key15 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key15 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key15;
       public            thomasdeane    false    210            �           2606    23686    users users_email_key16 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key16 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key16;
       public            thomasdeane    false    210            �           2606    23688    users users_email_key17 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key17 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key17;
       public            thomasdeane    false    210            �           2606    23690    users users_email_key18 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key18 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key18;
       public            thomasdeane    false    210            �           2606    23692    users users_email_key19 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key19 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key19;
       public            thomasdeane    false    210            �           2606    23658    users users_email_key2 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key2 UNIQUE (email);
 @   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key2;
       public            thomasdeane    false    210            �           2606    23694    users users_email_key20 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key20 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key20;
       public            thomasdeane    false    210            �           2606    23652    users users_email_key21 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key21 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key21;
       public            thomasdeane    false    210            �           2606    23696    users users_email_key22 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key22 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key22;
       public            thomasdeane    false    210            �           2606    23698    users users_email_key23 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key23 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key23;
       public            thomasdeane    false    210            �           2606    23700    users users_email_key24 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key24 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key24;
       public            thomasdeane    false    210                        2606    23702    users users_email_key25 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key25 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key25;
       public            thomasdeane    false    210                       2606    23704    users users_email_key26 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key26 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key26;
       public            thomasdeane    false    210                       2606    23650    users users_email_key27 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key27 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key27;
       public            thomasdeane    false    210                       2606    23706    users users_email_key28 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key28 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key28;
       public            thomasdeane    false    210                       2606    23708    users users_email_key29 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key29 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key29;
       public            thomasdeane    false    210            
           2606    23660    users users_email_key3 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key3 UNIQUE (email);
 @   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key3;
       public            thomasdeane    false    210                       2606    23648    users users_email_key30 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key30 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key30;
       public            thomasdeane    false    210                       2606    23710    users users_email_key31 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key31 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key31;
       public            thomasdeane    false    210                       2606    23646    users users_email_key32 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key32 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key32;
       public            thomasdeane    false    210                       2606    23644    users users_email_key33 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key33 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key33;
       public            thomasdeane    false    210                       2606    23712    users users_email_key34 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key34 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key34;
       public            thomasdeane    false    210                       2606    23714    users users_email_key35 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key35 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key35;
       public            thomasdeane    false    210                       2606    23716    users users_email_key36 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key36 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key36;
       public            thomasdeane    false    210                       2606    23642    users users_email_key37 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key37 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key37;
       public            thomasdeane    false    210                       2606    23718    users users_email_key38 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key38 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key38;
       public            thomasdeane    false    210                       2606    23640    users users_email_key39 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key39 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key39;
       public            thomasdeane    false    210                        2606    23662    users users_email_key4 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key4 UNIQUE (email);
 @   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key4;
       public            thomasdeane    false    210            "           2606    23720    users users_email_key40 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key40 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key40;
       public            thomasdeane    false    210            $           2606    23638    users users_email_key41 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key41 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key41;
       public            thomasdeane    false    210            &           2606    23722    users users_email_key42 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key42 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key42;
       public            thomasdeane    false    210            (           2606    23724    users users_email_key43 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key43 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key43;
       public            thomasdeane    false    210            *           2606    23726    users users_email_key44 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key44 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key44;
       public            thomasdeane    false    210            ,           2606    23636    users users_email_key45 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key45 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key45;
       public            thomasdeane    false    210            .           2606    23728    users users_email_key46 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key46 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key46;
       public            thomasdeane    false    210            0           2606    23634    users users_email_key47 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key47 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key47;
       public            thomasdeane    false    210            2           2606    23730    users users_email_key48 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key48 UNIQUE (email);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key48;
       public            thomasdeane    false    210            4           2606    23664    users users_email_key5 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key5 UNIQUE (email);
 @   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key5;
       public            thomasdeane    false    210            6           2606    23666    users users_email_key6 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key6 UNIQUE (email);
 @   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key6;
       public            thomasdeane    false    210            8           2606    23668    users users_email_key7 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key7 UNIQUE (email);
 @   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key7;
       public            thomasdeane    false    210            :           2606    23670    users users_email_key8 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key8 UNIQUE (email);
 @   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key8;
       public            thomasdeane    false    210            <           2606    23672    users users_email_key9 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key9 UNIQUE (email);
 @   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key9;
       public            thomasdeane    false    210            >           2606    16396    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            thomasdeane    false    210            @           2606    23558    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public            thomasdeane    false    210            B           2606    23560    users users_username_key1 
   CONSTRAINT     X   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key1 UNIQUE (username);
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key1;
       public            thomasdeane    false    210            D           2606    23578    users users_username_key10 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key10 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key10;
       public            thomasdeane    false    210            F           2606    23580    users users_username_key11 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key11 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key11;
       public            thomasdeane    false    210            H           2606    23582    users users_username_key12 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key12 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key12;
       public            thomasdeane    false    210            J           2606    23584    users users_username_key13 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key13 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key13;
       public            thomasdeane    false    210            L           2606    23586    users users_username_key14 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key14 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key14;
       public            thomasdeane    false    210            N           2606    23588    users users_username_key15 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key15 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key15;
       public            thomasdeane    false    210            P           2606    23590    users users_username_key16 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key16 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key16;
       public            thomasdeane    false    210            R           2606    23592    users users_username_key17 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key17 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key17;
       public            thomasdeane    false    210            T           2606    23594    users users_username_key18 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key18 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key18;
       public            thomasdeane    false    210            V           2606    23596    users users_username_key19 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key19 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key19;
       public            thomasdeane    false    210            X           2606    23562    users users_username_key2 
   CONSTRAINT     X   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key2 UNIQUE (username);
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key2;
       public            thomasdeane    false    210            Z           2606    23598    users users_username_key20 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key20 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key20;
       public            thomasdeane    false    210            \           2606    23556    users users_username_key21 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key21 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key21;
       public            thomasdeane    false    210            ^           2606    23600    users users_username_key22 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key22 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key22;
       public            thomasdeane    false    210            `           2606    23602    users users_username_key23 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key23 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key23;
       public            thomasdeane    false    210            b           2606    23604    users users_username_key24 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key24 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key24;
       public            thomasdeane    false    210            d           2606    23606    users users_username_key25 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key25 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key25;
       public            thomasdeane    false    210            f           2606    23608    users users_username_key26 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key26 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key26;
       public            thomasdeane    false    210            h           2606    23554    users users_username_key27 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key27 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key27;
       public            thomasdeane    false    210            j           2606    23610    users users_username_key28 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key28 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key28;
       public            thomasdeane    false    210            l           2606    23612    users users_username_key29 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key29 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key29;
       public            thomasdeane    false    210            n           2606    23564    users users_username_key3 
   CONSTRAINT     X   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key3 UNIQUE (username);
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key3;
       public            thomasdeane    false    210            p           2606    23552    users users_username_key30 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key30 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key30;
       public            thomasdeane    false    210            r           2606    23614    users users_username_key31 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key31 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key31;
       public            thomasdeane    false    210            t           2606    23550    users users_username_key32 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key32 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key32;
       public            thomasdeane    false    210            v           2606    23548    users users_username_key33 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key33 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key33;
       public            thomasdeane    false    210            x           2606    23616    users users_username_key34 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key34 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key34;
       public            thomasdeane    false    210            z           2606    23618    users users_username_key35 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key35 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key35;
       public            thomasdeane    false    210            |           2606    23620    users users_username_key36 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key36 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key36;
       public            thomasdeane    false    210            ~           2606    23546    users users_username_key37 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key37 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key37;
       public            thomasdeane    false    210            �           2606    23622    users users_username_key38 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key38 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key38;
       public            thomasdeane    false    210            �           2606    23544    users users_username_key39 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key39 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key39;
       public            thomasdeane    false    210            �           2606    23566    users users_username_key4 
   CONSTRAINT     X   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key4 UNIQUE (username);
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key4;
       public            thomasdeane    false    210            �           2606    23624    users users_username_key40 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key40 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key40;
       public            thomasdeane    false    210            �           2606    23542    users users_username_key41 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key41 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key41;
       public            thomasdeane    false    210            �           2606    23626    users users_username_key42 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key42 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key42;
       public            thomasdeane    false    210            �           2606    23628    users users_username_key43 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key43 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key43;
       public            thomasdeane    false    210            �           2606    23534    users users_username_key44 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key44 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key44;
       public            thomasdeane    false    210            �           2606    23540    users users_username_key45 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key45 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key45;
       public            thomasdeane    false    210            �           2606    23536    users users_username_key46 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key46 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key46;
       public            thomasdeane    false    210            �           2606    23538    users users_username_key47 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key47 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key47;
       public            thomasdeane    false    210            �           2606    23630    users users_username_key48 
   CONSTRAINT     Y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key48 UNIQUE (username);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key48;
       public            thomasdeane    false    210            �           2606    23568    users users_username_key5 
   CONSTRAINT     X   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key5 UNIQUE (username);
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key5;
       public            thomasdeane    false    210            �           2606    23570    users users_username_key6 
   CONSTRAINT     X   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key6 UNIQUE (username);
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key6;
       public            thomasdeane    false    210            �           2606    23572    users users_username_key7 
   CONSTRAINT     X   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key7 UNIQUE (username);
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key7;
       public            thomasdeane    false    210            �           2606    23574    users users_username_key8 
   CONSTRAINT     X   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key8 UNIQUE (username);
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key8;
       public            thomasdeane    false    210            �           2606    23576    users users_username_key9 
   CONSTRAINT     X   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key9 UNIQUE (username);
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key9;
       public            thomasdeane    false    210            �           2606    17425 ,   TaskAssignments TaskAssignments_task_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."TaskAssignments"
    ADD CONSTRAINT "TaskAssignments_task_id_fkey" FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON UPDATE CASCADE ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public."TaskAssignments" DROP CONSTRAINT "TaskAssignments_task_id_fkey";
       public          thomasdeane    false    3754    218    222            �           2606    17430 ,   TaskAssignments TaskAssignments_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."TaskAssignments"
    ADD CONSTRAINT "TaskAssignments_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public."TaskAssignments" DROP CONSTRAINT "TaskAssignments_user_id_fkey";
       public          thomasdeane    false    3646    222    210            �           2606    23740 9   projectcollaborators projectcollaborators_project_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.projectcollaborators
    ADD CONSTRAINT projectcollaborators_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON UPDATE CASCADE ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.projectcollaborators DROP CONSTRAINT projectcollaborators_project_id_fkey;
       public          thomasdeane    false    3746    216    212            �           2606    23745 6   projectcollaborators projectcollaborators_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.projectcollaborators
    ADD CONSTRAINT projectcollaborators_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE;
 `   ALTER TABLE ONLY public.projectcollaborators DROP CONSTRAINT projectcollaborators_user_id_fkey;
       public          thomasdeane    false    3646    216    210            �           2606    23735    projects projects_owner_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(user_id);
 I   ALTER TABLE ONLY public.projects DROP CONSTRAINT projects_owner_id_fkey;
       public          thomasdeane    false    3646    212    210            �           2606    23752    stages stages_project_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.stages DROP CONSTRAINT stages_project_id_fkey;
       public          thomasdeane    false    214    212    3746            �           2606    16493 4   taskassignments taskassignments_collaborator_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.taskassignments
    ADD CONSTRAINT taskassignments_collaborator_id_fkey FOREIGN KEY (collaborator_id) REFERENCES public.projectcollaborators(collaborator_id) ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.taskassignments DROP CONSTRAINT taskassignments_collaborator_id_fkey;
       public          thomasdeane    false    3750    216    220            �           2606    23779 5   taskassignments taskassignments_collaborator_id_fkey1    FK CONSTRAINT     �   ALTER TABLE ONLY public.taskassignments
    ADD CONSTRAINT taskassignments_collaborator_id_fkey1 FOREIGN KEY (collaborator_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.taskassignments DROP CONSTRAINT taskassignments_collaborator_id_fkey1;
       public          thomasdeane    false    220    3646    210            �           2606    23774 ,   taskassignments taskassignments_task_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.taskassignments
    ADD CONSTRAINT taskassignments_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON UPDATE CASCADE ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.taskassignments DROP CONSTRAINT taskassignments_task_id_fkey;
       public          thomasdeane    false    218    220    3754            �           2606    23769    tasks tasks_owner_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(user_id) ON UPDATE CASCADE;
 C   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_owner_id_fkey;
       public          thomasdeane    false    210    218    3646            �           2606    23757    tasks tasks_project_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON UPDATE CASCADE;
 E   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_project_id_fkey;
       public          thomasdeane    false    212    218    3746            �           2606    23762    tasks tasks_stage_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.stages(stage_id) ON UPDATE CASCADE;
 C   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_stage_id_fkey;
       public          thomasdeane    false    218    214    3748            V   ^   x�5�9�  {�����d�����t3c��Z�V����R�)c�J	;q��
�y�܅��E?x� �tUd8��U7)���� �      W      x������ � �      Q   �   x���1o�0����
�
�v��x���N�v9�!�"qQ���`�908���3O�m��3�L����95'(�{#��E��Uj�J�g��Q��5�{xL�:��c[��%o�����ȩ
_�_
&�ѷA��j�F5�U0כό�Q�d��%����8�Y�0%$��H�vI{��D9?�a���zy���Z*��y~��g|�,��?*_��޵�����~�}�      M   K  x����k�0��W�^���$ْn���
#�A/YbXJiB�m쿟eTzŎ!�����D�,E���w�N|�����������Q�~�~���ى�a����ӏ�n�W��@��S�	����h���*�+45V����ӇK��]� +0<�����U�2׹��?���H4e=�7F���(�@5�r�Y��x_�{�nnI_���t��a�ﷻ��G9�+�5JM�F�IK�ل��ʛU�V_�>�����8i��y"O �%�c'7';˂��a+��cţ�Y���s�qrl㆖,aA�0j:F�N�D�!&��`(��O��[�fa������Bx(�䅈a
�g��k�
�(�ʠ�"�L2W����Z�(�ʠ�"��Y ��=->c,rXA��y�ә�$>_<*xXE�ǎ�
j�R��$�XT ���>�w{8�&�Z���Ns�
"VEj�(�4aYj���,*���(��E*�&�ՃU͢�(���|��W��֣�֔DiT�Q��)�FK38yTeQ���[q#5��(�ʢ�"��բxI'���6���U��������"�      O     x����n�6���Sp�M�7I�v�A���bV�(
cqdW��f�����IJɗZ�љCb��~1�N�q�m��Zя�ۦ{#�t�^5�h�/Ъ}���v�}%OD0��9����Eʍ����+�D�/n��]��+�~����M���nxX]�_��lG�յ���T���mb�v��] I���ng���Zm��Y�D�_gA���c}<���} 8#��ݰ���۸�v�,3����v���wO_���X�g��g�p������{r|[Oo�3�a5�fչ�!�U���v�z���˪]��9�/���� �v����N?��7ǫ��V6`}C>5}M��vW]뮶�w{��}�hO��m^�=�/n�ogH
K]*�j�����I8�p�������*Xc ,��ʃD�
/� ��2 h�6�g���j�rf)W7zƬ�Y"����cfg��}$�Tϣ�ո���n�Ay����_�wt�wG����Tmm����,w/F�����$r&����-&[��D�������$P'#OB�p�G�`�Wk�}�i7~�ɵ�� ��m�=K��v��4�~mm�/�M:�;���kK�~X��2�e�S�U�־�z_�@s�`�{�e*�%�4r���s�G���7H�%.iP��XH� �x�fL"�0�Do� 
�Y �Yx� �f!�q1n�5gVr�B��B2�Y�t)U����(�<Q:�Y��ƻY�Y��,�I8r��'��@b58Z601���B�L_����\�(AfACHyD}!9��B�_]�`� A[OH��R�"KE..A%n�B�h�� qa�,���$yya	
|}a4��0�APD�,@�d�d,5�tY��8à�w8KF��DE�� × ǔ�.$�}f���_՜�ϮI�L4��5�38+���{`O�<0�@��ѡ381�X�K�뿶/K*1�� ���2q%��$�}�b1$��1$�@�8"C�*�d]r�j#o�f�̡24�!�<�e��+3$��#3$��"3 g�2C�Gf2d�U����J3�_��ܡ��\@j؜�9�F�1�F�0�&@�u��.R�M��*E�*Q�@�J�C���@��yw��g��e�J�<��q�^��{��3>�7������=�z�2>I������8J�y��#�SP���#=��A{���n��˩�_т���W���|[�E�����Ź����{[����+�m�;���{�$ɿ��Q	      U      x������ � �      S   "  x���MK1��s�W�]��c��ͱ���^z	��6���$����-�/� �0���a8�a����:�=NȝNK0<6�[0�Y��R���}�U��$�)/F��(J�~n(%K�X~6:�P�VE��q=�RKDV��PR(��K�EX%�5a%'�7�-��0������ИT��B��G���&���~�&z�ަ�!L�Ơ��x�0�)�R�P������e�KƝ���w�Y ��-yZ��@���&�U�����ٽz4vݟ��-.�r*/U���y�e��ə      K   z  x���Ko�Z�1��:;)��Eq��"
b������*7����=;��v����7!���8B�$�DE	~]��#�<2��a�7�m�z!n�	5�4��F�e�r�m��qռT�Q��(��X�tb�����m�wpO���7�{��X�������KT~�`�4!��D�*kW0���F�|��T�P�q�Z���@o��y:�c<��1�d�>h9R���…/*��D�`%�9��0�p�'�xY\�\��L,�᱾S��j�g�(e�v��%~�E��0::���λZa��Q�74#�V�.�&��v�G��4�QA2M���Y���L��kw�3�mD�D�;�Nk�ށ���v���A<o��v���T��������~�?D7�h�m1�-���^�L�˹�D�
9;=���>!O�ym��l��4��G3�!��$���O�hM�,K�h�{}⾔L�q��$ӛ�`��$��F�fq��ZEe:u�k9L�#�����y��P���[�S�=��/K�)N�������AB~[���	cv��;ލU��j�s����A5eyQ�9gF�� fC�˞O+}_��H��멾�!ݡ��i���` �hO�{�]tS���6�~�g��C�{Aw�s�������?n݉@�y�����ת�7���jG�l �8u�ݞ�'���f�pT��������4�K��p�O�y��Q�<��;��w��he8Z�%?�T�ٹS�;.O6��"�jq温f���COŖ�?�<O�{����f�!"f8�Q	I��ӥ�6B9��' Q���
�2�8j�����+Z�k�
.�ɼ����k���g%��C�0<�ǆ�B�S~�����u��^0m�)�7#t�O#�-��ƈ�M�$�/?P�B     