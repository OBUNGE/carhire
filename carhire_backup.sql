--
-- PostgreSQL database dump
--

\restrict qyI4d3H7EjmmYHKiC7KCrK00lvfBLnow2275HZ3vu2IZsxkHrRpQFXhKSXQ5eMQ

-- Dumped from database version 16.10 (Debian 16.10-1.pgdg12+1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: carhire_db_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO carhire_db_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: carhire_db_user
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO carhire_db_user;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: carhire_db_user
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_attachments_id_seq OWNER TO carhire_db_user;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: carhire_db_user
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: carhire_db_user
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO carhire_db_user;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: carhire_db_user
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_blobs_id_seq OWNER TO carhire_db_user;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: carhire_db_user
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: carhire_db_user
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


ALTER TABLE public.active_storage_variant_records OWNER TO carhire_db_user;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: carhire_db_user
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNER TO carhire_db_user;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: carhire_db_user
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: carhire_db_user
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO carhire_db_user;

--
-- Name: bookings; Type: TABLE; Schema: public; Owner: carhire_db_user
--

CREATE TABLE public.bookings (
    id bigint NOT NULL,
    car_id bigint NOT NULL,
    user_id bigint NOT NULL,
    start_time timestamp(6) without time zone,
    planned_return_at timestamp(6) without time zone,
    planned_days integer,
    id_number character varying,
    owner_contact character varying,
    request_type character varying,
    timer_start timestamp(6) without time zone,
    timer_end timestamp(6) without time zone,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    purpose character varying,
    nationality character varying,
    delivery_method character varying,
    pickup_location character varying,
    has_driver boolean,
    renter_email character varying,
    renter_phone character varying,
    rental_start_time timestamp(6) without time zone,
    rental_end_time timestamp(6) without time zone,
    deposit_amount numeric(10,2),
    invoice_finalized_at timestamp(6) without time zone,
    total_price numeric,
    car_wash_fee numeric,
    damage_fee numeric(10,2) DEFAULT 0.0,
    custom_adjustment numeric(10,2) DEFAULT 0.0,
    overtime_fee_override numeric(10,2) DEFAULT 0.0,
    custom_fee numeric(10,2) DEFAULT 0.0,
    platform_commission numeric(10,2),
    deposit_paid_at timestamp(6) without time zone,
    deposit_transaction_id character varying,
    paid_at timestamp(6) without time zone,
    payment_transaction_id character varying,
    full_name character varying,
    contact_number character varying,
    special_requests text,
    terms boolean,
    mpesa_receipt character varying,
    mpesa_receipt_number character varying,
    final_paid_at timestamp(6) without time zone,
    final_receipt_number character varying,
    merchant_request_id character varying,
    checkout_request_id character varying
);


ALTER TABLE public.bookings OWNER TO carhire_db_user;

--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: carhire_db_user
--

CREATE SEQUENCE public.bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bookings_id_seq OWNER TO carhire_db_user;

--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: carhire_db_user
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: cars; Type: TABLE; Schema: public; Owner: carhire_db_user
--

CREATE TABLE public.cars (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    owner_id bigint NOT NULL,
    make character varying,
    model character varying,
    year integer,
    price numeric,
    description text,
    listing_type character varying,
    name character varying,
    deposit_amount numeric(10,2) DEFAULT 0.0 NOT NULL,
    latitude double precision,
    longitude double precision,
    pickup_address character varying,
    category character varying,
    status character varying,
    transmission_type character varying,
    fuel_type character varying,
    insurance_status character varying,
    seats integer
);


ALTER TABLE public.cars OWNER TO carhire_db_user;

--
-- Name: cars_id_seq; Type: SEQUENCE; Schema: public; Owner: carhire_db_user
--

CREATE SEQUENCE public.cars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cars_id_seq OWNER TO carhire_db_user;

--
-- Name: cars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: carhire_db_user
--

ALTER SEQUENCE public.cars_id_seq OWNED BY public.cars.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: carhire_db_user
--

CREATE TABLE public.favorites (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    car_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.favorites OWNER TO carhire_db_user;

--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: carhire_db_user
--

CREATE SEQUENCE public.favorites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.favorites_id_seq OWNER TO carhire_db_user;

--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: carhire_db_user
--

ALTER SEQUENCE public.favorites_id_seq OWNED BY public.favorites.id;


--
-- Name: purchases; Type: TABLE; Schema: public; Owner: carhire_db_user
--

CREATE TABLE public.purchases (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    car_id bigint NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.purchases OWNER TO carhire_db_user;

--
-- Name: purchases_id_seq; Type: SEQUENCE; Schema: public; Owner: carhire_db_user
--

CREATE SEQUENCE public.purchases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchases_id_seq OWNER TO carhire_db_user;

--
-- Name: purchases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: carhire_db_user
--

ALTER SEQUENCE public.purchases_id_seq OWNED BY public.purchases.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: carhire_db_user
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    car_id bigint NOT NULL,
    rating integer,
    comment text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.reviews OWNER TO carhire_db_user;

--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: carhire_db_user
--

CREATE SEQUENCE public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO carhire_db_user;

--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: carhire_db_user
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: carhire_db_user
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO carhire_db_user;

--
-- Name: users; Type: TABLE; Schema: public; Owner: carhire_db_user
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    role character varying,
    phone character varying,
    phone_number character varying,
    first_name character varying,
    last_name character varying,
    admin boolean DEFAULT false
);


ALTER TABLE public.users OWNER TO carhire_db_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: carhire_db_user
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO carhire_db_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: carhire_db_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: viewings; Type: TABLE; Schema: public; Owner: carhire_db_user
--

CREATE TABLE public.viewings (
    id bigint NOT NULL,
    booking_id bigint NOT NULL,
    scheduled_date timestamp(6) without time zone,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.viewings OWNER TO carhire_db_user;

--
-- Name: viewings_id_seq; Type: SEQUENCE; Schema: public; Owner: carhire_db_user
--

CREATE SEQUENCE public.viewings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.viewings_id_seq OWNER TO carhire_db_user;

--
-- Name: viewings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: carhire_db_user
--

ALTER SEQUENCE public.viewings_id_seq OWNED BY public.viewings.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: cars id; Type: DEFAULT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.cars ALTER COLUMN id SET DEFAULT nextval('public.cars_id_seq'::regclass);


--
-- Name: favorites id; Type: DEFAULT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.favorites ALTER COLUMN id SET DEFAULT nextval('public.favorites_id_seq'::regclass);


--
-- Name: purchases id; Type: DEFAULT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.purchases ALTER COLUMN id SET DEFAULT nextval('public.purchases_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: viewings id; Type: DEFAULT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.viewings ALTER COLUMN id SET DEFAULT nextval('public.viewings_id_seq'::regclass);


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: carhire_db_user
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
8	images	Car	7	8	2025-10-07 20:22:07.170343
9	images	Car	8	9	2025-10-07 20:29:25.158205
10	images	Car	9	10	2025-10-07 20:31:47.627251
11	images	Car	10	11	2025-10-07 21:07:21.549523
12	images	Car	11	12	2025-10-07 21:34:49.898278
13	image	ActiveStorage::VariantRecord	5	13	2025-10-07 21:34:56.173927
14	images	Car	12	14	2025-10-07 21:41:16.61944
15	image	ActiveStorage::VariantRecord	6	15	2025-10-07 21:41:21.255168
16	images	Car	13	16	2025-10-08 13:08:51.851275
17	image	ActiveStorage::VariantRecord	7	17	2025-10-08 13:08:57.14317
18	images	Car	14	18	2025-10-08 17:41:54.218348
19	image	ActiveStorage::VariantRecord	8	19	2025-10-08 17:41:58.732508
20	images	Car	15	20	2025-10-08 17:54:22.953136
21	image	ActiveStorage::VariantRecord	9	21	2025-10-08 17:54:29.419007
22	images	Car	16	22	2025-10-08 18:12:00.92863
23	image	ActiveStorage::VariantRecord	10	23	2025-10-08 18:12:04.788717
24	images	Car	17	24	2025-10-08 19:14:01.258966
25	image	ActiveStorage::VariantRecord	11	25	2025-10-08 19:14:06.939141
26	images	Car	18	26	2025-10-08 19:17:32.45436
27	image	ActiveStorage::VariantRecord	12	27	2025-10-08 19:17:39.005719
28	images	Car	19	28	2025-10-08 19:37:54.127566
29	image	ActiveStorage::VariantRecord	13	29	2025-10-08 19:37:59.59547
30	images	Car	20	30	2025-10-08 19:51:52.686423
31	image	ActiveStorage::VariantRecord	14	31	2025-10-08 19:51:58.202126
32	images	Car	21	32	2025-10-08 21:55:50.660005
33	image	ActiveStorage::VariantRecord	15	33	2025-10-08 21:55:55.810576
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: carhire_db_user
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
33	o9m5j9hxhe8b5jn1baxl774lab7e	applied-software-engineering-fundamentals.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	supabase	16426	FAtac9Ar6szD5bR6R9JDqQ==	2025-10-08 21:55:55.774534
8	g4frp5ohk9d47l23hq9qwenuzkt4	Fauget.png	image/png	{"identified":true}	supabase	33805	w9YFn/xLXZMxQTyFpTSIGw==	2025-10-07 20:22:07.106265
9	zkn67q6heqrzx0no2nysy91vd13t	Fauget.png	image/png	{"identified":true}	supabase	33805	w9YFn/xLXZMxQTyFpTSIGw==	2025-10-07 20:29:25.120923
10	7i6q7h43dpsh8sbcsqiwtp87a6uh	Fauget.png	image/png	{"identified":true}	supabase	33805	w9YFn/xLXZMxQTyFpTSIGw==	2025-10-07 20:31:47.461862
11	fa1ooh9yez8qcq2dvz7fwwewwv57	Fauget.png	image/png	{"identified":true}	supabase	33805	w9YFn/xLXZMxQTyFpTSIGw==	2025-10-07 21:07:21.500407
12	ddz7z5lhv0nrjchmbnogho05zroq	Fauget.png	image/png	{"identified":true,"width":500,"height":500,"analyzed":true}	supabase	33805	w9YFn/xLXZMxQTyFpTSIGw==	2025-10-07 21:34:49.858903
13	rvkauoxvsn8az2eq2uyo521ym59e	Fauget.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	supabase	6449	+LXqiOLaP1UZV+bmrUylhQ==	2025-10-07 21:34:56.140817
14	b9i8w23w2fbyxvee2xvxy013jafi	www.reallygreatsite.com +123-456-7890 flaviagidah@gmail.com (5).png	image/png	{"identified":true,"width":1587,"height":2245,"analyzed":true}	supabase	1489193	4ZJ3Fw89ndhz00OIfSBmcw==	2025-10-07 21:41:16.579424
15	b1ged0w6ucjsv2rvdxr835aiw8b0	www.reallygreatsite.com +123-456-7890 flaviagidah@gmail.com (5).png	image/png	{"identified":true,"width":71,"height":100,"analyzed":true}	supabase	13975	cVJ7tCvG6smkZYV5wyA5JQ==	2025-10-07 21:41:21.186531
16	6ma7qvnq7seuwih5armywm3tds62	Fauget.png	image/png	{"identified":true,"width":500,"height":500,"analyzed":true}	supabase	33805	w9YFn/xLXZMxQTyFpTSIGw==	2025-10-08 13:08:51.817087
17	eoyrvglp75j5453p6kr0czekw15c	Fauget.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	supabase	6449	+LXqiOLaP1UZV+bmrUylhQ==	2025-10-08 13:08:57.114899
18	1fk7o6lnfch5rydnfozpbghmywda	Fauget.png	image/png	{"identified":true,"width":500,"height":500,"analyzed":true}	supabase	33805	w9YFn/xLXZMxQTyFpTSIGw==	2025-10-08 17:41:54.182718
19	h8rvwm3711ohk4jbiwrrxvv879h4	Fauget.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	supabase	6449	+LXqiOLaP1UZV+bmrUylhQ==	2025-10-08 17:41:58.703636
20	uoz7eoc8ns34367w8n0hjuhrl0fw	Fauget.png	image/png	{"identified":true,"width":500,"height":500,"analyzed":true}	supabase	33805	w9YFn/xLXZMxQTyFpTSIGw==	2025-10-08 17:54:22.913918
21	drksxmkl7zvpljgbi63fzfp0r45m	Fauget.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	supabase	6449	+LXqiOLaP1UZV+bmrUylhQ==	2025-10-08 17:54:29.389426
22	60ta2gq1j0ja0gelok22tu758xq5	Fauget.png	image/png	{"identified":true,"width":500,"height":500,"analyzed":true}	supabase	33805	w9YFn/xLXZMxQTyFpTSIGw==	2025-10-08 18:12:00.898511
23	8vc2ioua2v2brb52nzve31amjald	Fauget.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	supabase	6449	+LXqiOLaP1UZV+bmrUylhQ==	2025-10-08 18:12:04.757853
24	gew1xv1wh2sobfmf9jlegqx2aawv	applied-software-engineering-fundamentals.png	image/png	{"identified":true,"width":1080,"height":1080,"analyzed":true}	supabase	280402	gwmrwOmiRlJBNWjSfxEKkw==	2025-10-08 19:14:01.228157
25	jhgua78qey0sjst50kg3qb6byzh0	applied-software-engineering-fundamentals.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	supabase	16426	FAtac9Ar6szD5bR6R9JDqQ==	2025-10-08 19:14:06.911913
26	vtkh3f51a9ocyr6wykolclct6dnf	applied-software-engineering-fundamentals.png	image/png	{"identified":true,"width":1080,"height":1080,"analyzed":true}	supabase	280402	gwmrwOmiRlJBNWjSfxEKkw==	2025-10-08 19:17:32.419376
27	6ygkj5dpsgkd301iyj7u4l6ft5qc	applied-software-engineering-fundamentals.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	supabase	16426	FAtac9Ar6szD5bR6R9JDqQ==	2025-10-08 19:17:38.978049
28	n86w2rrilombnj32rx2noxlnp9ht	applied-software-engineering-fundamentals.png	image/png	{"identified":true,"width":1080,"height":1080,"analyzed":true}	supabase	280402	gwmrwOmiRlJBNWjSfxEKkw==	2025-10-08 19:37:54.087913
29	5sz367tbvdb0s8sv7mo1037csak7	applied-software-engineering-fundamentals.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	supabase	16426	FAtac9Ar6szD5bR6R9JDqQ==	2025-10-08 19:37:59.566431
30	dtit6z5kh72azia4vprsn4iq5r66	applied-software-engineering-fundamentals.png	image/png	{"identified":true,"width":1080,"height":1080,"analyzed":true}	supabase	280402	gwmrwOmiRlJBNWjSfxEKkw==	2025-10-08 19:51:52.657141
31	agv1nfu3uqjcqqd5pwhdxy0t6f53	applied-software-engineering-fundamentals.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	supabase	16426	FAtac9Ar6szD5bR6R9JDqQ==	2025-10-08 19:51:58.174145
32	44wzfdglvff2hp0r3hw9148uwn8a	applied-software-engineering-fundamentals.png	image/png	{"identified":true,"width":1080,"height":1080,"analyzed":true}	supabase	280402	gwmrwOmiRlJBNWjSfxEKkw==	2025-10-08 21:55:50.61838
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: carhire_db_user
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
5	12	LdxohMICjg1eAfRceKi3M1hJ4U8=
6	14	LdxohMICjg1eAfRceKi3M1hJ4U8=
7	16	LdxohMICjg1eAfRceKi3M1hJ4U8=
8	18	LdxohMICjg1eAfRceKi3M1hJ4U8=
9	20	LdxohMICjg1eAfRceKi3M1hJ4U8=
10	22	LdxohMICjg1eAfRceKi3M1hJ4U8=
11	24	LdxohMICjg1eAfRceKi3M1hJ4U8=
12	26	LdxohMICjg1eAfRceKi3M1hJ4U8=
13	28	LdxohMICjg1eAfRceKi3M1hJ4U8=
14	30	LdxohMICjg1eAfRceKi3M1hJ4U8=
15	32	LdxohMICjg1eAfRceKi3M1hJ4U8=
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: carhire_db_user
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	production	2025-09-16 11:44:25.7845	2025-09-16 11:44:25.784502
schema_sha1	9de74c7e8621fc11ad327e51caa7642cd7fbe6b0	2025-09-16 11:44:25.802512	2025-09-16 11:44:25.802513
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: carhire_db_user
--

COPY public.bookings (id, car_id, user_id, start_time, planned_return_at, planned_days, id_number, owner_contact, request_type, timer_start, timer_end, status, created_at, updated_at, purpose, nationality, delivery_method, pickup_location, has_driver, renter_email, renter_phone, rental_start_time, rental_end_time, deposit_amount, invoice_finalized_at, total_price, car_wash_fee, damage_fee, custom_adjustment, overtime_fee_override, custom_fee, platform_commission, deposit_paid_at, deposit_transaction_id, paid_at, payment_transaction_id, full_name, contact_number, special_requests, terms, mpesa_receipt, mpesa_receipt_number, final_paid_at, final_receipt_number, merchant_request_id, checkout_request_id) FROM stdin;
1	1	2	2025-09-17 18:26:00	2025-09-18 18:26:00	\N	38698501	\N	\N	\N	\N	4	2025-09-16 18:27:20.088133	2025-09-24 17:24:07.228183	Leisure	kenyan	Owner delivers to you		t	hassankoskei@gmail.com	+254714063624	2025-09-24 17:24:07.134836	2025-09-24 17:24:11.449702	100.00	\N	800.0	\N	0.00	0.00	0.00	0.00	10.00	\N	\N	\N	\N	felix omondi	0726565342		t	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: cars; Type: TABLE DATA; Schema: public; Owner: carhire_db_user
--

COPY public.cars (id, created_at, updated_at, owner_id, make, model, year, price, description, listing_type, name, deposit_amount, latitude, longitude, pickup_address, category, status, transmission_type, fuel_type, insurance_status, seats) FROM stdin;
2	2025-10-07 09:11:52.167237	2025-10-07 09:11:52.167237	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
3	2025-10-07 15:32:08.020957	2025-10-07 15:32:08.020957	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
4	2025-10-07 15:35:22.080676	2025-10-07 15:35:22.080676	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
7	2025-10-07 20:22:06.847457	2025-10-07 20:22:07.207877	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
8	2025-10-07 20:29:24.976211	2025-10-07 20:29:25.19568	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
9	2025-10-07 20:31:47.239905	2025-10-07 20:31:47.660332	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
10	2025-10-07 21:07:21.165647	2025-10-07 21:07:21.598265	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
11	2025-10-07 21:34:49.64615	2025-10-07 21:34:54.342748	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
12	2025-10-07 21:41:16.444545	2025-10-07 21:41:19.338539	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
13	2025-10-08 13:08:51.595301	2025-10-08 13:08:55.986914	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
14	2025-10-08 17:41:53.893621	2025-10-08 17:41:57.541339	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
15	2025-10-08 17:54:22.608917	2025-10-08 17:54:26.921874	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
16	2025-10-08 18:12:00.802357	2025-10-08 18:12:02.77627	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
17	2025-10-08 19:14:01.000032	2025-10-08 19:14:04.864933	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
18	2025-10-08 19:17:32.334532	2025-10-08 19:17:34.302586	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
19	2025-10-08 19:37:53.903094	2025-10-08 19:37:57.179972	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
20	2025-10-08 19:51:52.534449	2025-10-08 19:51:54.383143	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
1	2025-09-16 15:39:09.147973	2025-10-09 00:24:48.409681	1	Toyota 	vitz 	2018	100.0	This is a very nice car to have sir	rent	\N	100.00	-1.2921	36.8219	Nairobi	SUV	published	Automatic	Diesel	Fully insured	5
5	2025-10-07 16:20:50.26695	2025-10-09 00:25:04.810438	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
6	2025-10-07 17:53:54.604453	2025-10-09 00:25:12.854933	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
21	2025-10-08 21:55:50.393332	2025-10-08 21:55:53.31417	1			\N	\N		\N	\N	0.00	\N	\N			published				\N
\.


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: carhire_db_user
--

COPY public.favorites (id, user_id, car_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: carhire_db_user
--

COPY public.purchases (id, user_id, car_id, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: carhire_db_user
--

COPY public.reviews (id, user_id, car_id, rating, comment, created_at, updated_at) FROM stdin;
1	1	4	4	hello	2025-10-07 17:28:31.257314	2025-10-07 17:28:31.257314
2	1	3	1	nice car to have	2025-10-07 17:30:05.251716	2025-10-07 17:30:05.251716
3	1	6	2	hello	2025-10-07 17:54:11.694166	2025-10-07 17:54:11.694166
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: carhire_db_user
--

COPY public.schema_migrations (version) FROM stdin;
20250911085329
20250909143229
20250909124624
20250909053005
20250908055428
20250904083723
20250902211257
20250902165336
20250901131623
20250831175140
20250830195806
20250830170537
20250830165006
20250830134352
20250830122304
20250830085920
20250829212047
20250829211131
20250829210612
20250829192614
20250829160142
20250828092330
20250828085720
20250826145917
20250826114541
20250826113231
20250826110236
20250826090203
20250826080542
20250822053504
20250821094757
20250814000000
20250813185253
20250813105729
20250813102316
20250812141315
20250812132735
20250812121734
20250812121254
20250810101411
20250921085944
20251006100019
20251007155329
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: carhire_db_user
--

COPY public.users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, created_at, updated_at, role, phone, phone_number, first_name, last_name, admin) FROM stdin;
1	felixokiya10@gmail.com	$2a$12$ciTEG3ehz0rdlBoeClulzOViysIlr4wQ/0dGgazeHTgQQnkjL60OS	\N	\N	\N	2025-09-16 15:35:40.745858	2025-09-16 15:35:40.745858	owner	\N	+254726565342	Felix	Odhiambo	f
2	hassankoskei@gmail.com	$2a$12$pXhUNH6boIDepV.FQVuhGuMjWf41m0scCahGD0pcUu4lTVjE4N4hW	\N	\N	\N	2025-09-16 18:25:36.38837	2025-09-16 18:25:36.38837	owner	\N	+254714063624	Edwin	Okiya	f
3	vincentmalla206@gmail.com	$2a$12$3.Pm96tHmEET.Pr5ZfvmZ..zI/ftRukUtUap4fOP5ISJvRAf9eKNG	\N	\N	\N	2025-09-17 06:31:47.849529	2025-09-17 06:31:47.849529	user	\N	+25477133689	Vincent	Malla	f
\.


--
-- Data for Name: viewings; Type: TABLE DATA; Schema: public; Owner: carhire_db_user
--

COPY public.viewings (id, booking_id, scheduled_date, notes, created_at, updated_at) FROM stdin;
\.


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: carhire_db_user
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 33, true);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: carhire_db_user
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 33, true);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: carhire_db_user
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 15, true);


--
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: carhire_db_user
--

SELECT pg_catalog.setval('public.bookings_id_seq', 1, true);


--
-- Name: cars_id_seq; Type: SEQUENCE SET; Schema: public; Owner: carhire_db_user
--

SELECT pg_catalog.setval('public.cars_id_seq', 21, true);


--
-- Name: favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: carhire_db_user
--

SELECT pg_catalog.setval('public.favorites_id_seq', 1, false);


--
-- Name: purchases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: carhire_db_user
--

SELECT pg_catalog.setval('public.purchases_id_seq', 1, false);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: carhire_db_user
--

SELECT pg_catalog.setval('public.reviews_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: carhire_db_user
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: viewings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: carhire_db_user
--

SELECT pg_catalog.setval('public.viewings_id_seq', 1, false);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: cars cars_pkey; Type: CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (id);


--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: purchases purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: viewings viewings_pkey; Type: CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.viewings
    ADD CONSTRAINT viewings_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_bookings_on_car_id; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE INDEX index_bookings_on_car_id ON public.bookings USING btree (car_id);


--
-- Name: index_bookings_on_user_id; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE INDEX index_bookings_on_user_id ON public.bookings USING btree (user_id);


--
-- Name: index_cars_on_owner_id; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE INDEX index_cars_on_owner_id ON public.cars USING btree (owner_id);


--
-- Name: index_favorites_on_car_id; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE INDEX index_favorites_on_car_id ON public.favorites USING btree (car_id);


--
-- Name: index_favorites_on_user_id; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE INDEX index_favorites_on_user_id ON public.favorites USING btree (user_id);


--
-- Name: index_purchases_on_car_id; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE INDEX index_purchases_on_car_id ON public.purchases USING btree (car_id);


--
-- Name: index_purchases_on_user_id; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE INDEX index_purchases_on_user_id ON public.purchases USING btree (user_id);


--
-- Name: index_reviews_on_car_id; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE INDEX index_reviews_on_car_id ON public.reviews USING btree (car_id);


--
-- Name: index_reviews_on_user_id; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE INDEX index_reviews_on_user_id ON public.reviews USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_viewings_on_booking_id; Type: INDEX; Schema: public; Owner: carhire_db_user
--

CREATE INDEX index_viewings_on_booking_id ON public.viewings USING btree (booking_id);


--
-- Name: viewings fk_rails_10b17efeb8; Type: FK CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.viewings
    ADD CONSTRAINT fk_rails_10b17efeb8 FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: purchases fk_rails_2888c5cba9; Type: FK CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT fk_rails_2888c5cba9 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: cars fk_rails_41e03c1fe5; Type: FK CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT fk_rails_41e03c1fe5 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: bookings fk_rails_5e4e81d007; Type: FK CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_rails_5e4e81d007 FOREIGN KEY (car_id) REFERENCES public.cars(id);


--
-- Name: reviews fk_rails_74a66bd6c5; Type: FK CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_rails_74a66bd6c5 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: reviews fk_rails_858a4e68e2; Type: FK CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_rails_858a4e68e2 FOREIGN KEY (car_id) REFERENCES public.cars(id);


--
-- Name: favorites fk_rails_9396eb4f36; Type: FK CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT fk_rails_9396eb4f36 FOREIGN KEY (car_id) REFERENCES public.cars(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: purchases fk_rails_a70955d54c; Type: FK CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT fk_rails_a70955d54c FOREIGN KEY (car_id) REFERENCES public.cars(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: favorites fk_rails_d15744e438; Type: FK CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT fk_rails_d15744e438 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: bookings fk_rails_ef0571f117; Type: FK CONSTRAINT; Schema: public; Owner: carhire_db_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_rails_ef0571f117 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO carhire_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO carhire_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO carhire_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO carhire_db_user;


--
-- PostgreSQL database dump complete
--

\unrestrict qyI4d3H7EjmmYHKiC7KCrK00lvfBLnow2275HZ3vu2IZsxkHrRpQFXhKSXQ5eMQ

