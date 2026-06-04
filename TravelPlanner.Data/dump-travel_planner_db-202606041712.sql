--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2026-06-04 17:12:52

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
-- TOC entry 4992 (class 1262 OID 425697)
-- Name: travel_planner_db; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE travel_planner_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


\connect travel_planner_db

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
-- TOC entry 2 (class 3079 OID 425874)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 425759)
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cities (
    id bigint NOT NULL,
    country_id bigint NOT NULL,
    name text NOT NULL,
    guid uuid DEFAULT gen_random_uuid() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    additional_data text
);


--
-- TOC entry 222 (class 1259 OID 425758)
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.cities ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 425751)
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(10) NOT NULL,
    guid uuid DEFAULT gen_random_uuid() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    exchange_code text
);


--
-- TOC entry 220 (class 1259 OID 425750)
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.countries ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 425770)
-- Name: exchange_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exchange_rates (
    id bigint NOT NULL,
    country_id bigint NOT NULL,
    base_currency character varying(10) NOT NULL,
    target_currency character varying(10) NOT NULL,
    rate numeric(18,6) NOT NULL,
    date_recorded date NOT NULL,
    guid uuid DEFAULT gen_random_uuid() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 425769)
-- Name: exchange_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.exchange_rates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.exchange_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 425803)
-- Name: forecasts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.forecasts (
    id bigint NOT NULL,
    city_id bigint,
    country_id bigint,
    metric_type character varying(50) NOT NULL,
    forecast_date date NOT NULL,
    predicted_value numeric(18,6) NOT NULL,
    model_used character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    guid uuid DEFAULT gen_random_uuid() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


--
-- TOC entry 230 (class 1259 OID 425802)
-- Name: forecasts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.forecasts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.forecasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 425781)
-- Name: inflation_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inflation_rates (
    id bigint NOT NULL,
    country_id bigint NOT NULL,
    rate numeric(8,4) NOT NULL,
    date_recorded date NOT NULL,
    guid uuid DEFAULT gen_random_uuid() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 425780)
-- Name: inflation_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.inflation_rates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.inflation_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 217 (class 1259 OID 425726)
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    guid uuid DEFAULT gen_random_uuid() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


--
-- TOC entry 216 (class 1259 OID 425725)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 425792)
-- Name: tourism_metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tourism_metrics (
    id bigint NOT NULL,
    city_id bigint NOT NULL,
    tourist_count integer,
    avg_accommodation_price numeric(18,2),
    currency_used character varying(10),
    date_recorded date NOT NULL,
    guid uuid DEFAULT gen_random_uuid() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    country_id bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 228 (class 1259 OID 425791)
-- Name: tourism_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.tourism_metrics ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tourism_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 425734)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    email character varying(100) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    guid uuid DEFAULT gen_random_uuid() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 425733)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4978 (class 0 OID 425759)
-- Dependencies: 223
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (3, 1, 'İzmir', '0efe3d54-69a3-4e4b-9588-f4e240aa520e', false, NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (4, 1, 'Kapadokya', 'c386db35-ab6a-404d-a1f6-d80fb0902d46', false, NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (11, 4, 'Moskova', '0480a277-d605-4163-9266-30bde29dbb98', false, NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (12, 4, 'St. Petersburg', '834211e4-ef36-4c63-983c-0085c98dcabe', false, NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (13, 4, 'Soçi', '9ea9cccc-55ad-4e58-b7bc-8f084eab13ae', false, NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (8, 6, 'Oslo', '3581b4a6-a8a4-41a6-9034-d5ad16baa659', false, '03101 03');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (9, 6, 'Bergen', 'dbb71da3-86ec-478d-b589-a54ec6f78003', false, '46101 46');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (10, 6, 'Tromsø', '8298edad-3de3-46db-b5ac-837e35cad87f', false, '54101 55');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (5, 2, 'Madrid', '8067d55f-9402-44a9-a1bf-560a6705fcd3', false, '29 9009');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (6, 2, 'Barselona', '6f3aad50-d922-4221-a9a6-6ca356931181', false, '9 9005');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (7, 2, 'İbiza', 'b6f3f0cd-3050-40e6-b247-0506ac4d7fc6', false, '8 9000');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1, 1, 'İstanbul', '04ea0dae-61e7-4c2c-aeb1-1e3945b9aae7', false, 'TR10');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (2, 1, 'Antalya', '9df051f7-e65a-4378-9f38-d50d9696ef87', false, 'TR61');


--
-- TOC entry 4976 (class 0 OID 425751)
-- Dependencies: 221
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (1, 'Türkiye', 'TR', '2f8889f6-6040-4194-89e6-e701e58d2f38', false, 'TRY');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (4, 'Rusya', 'RU', 'b7ef62ee-1881-4243-aadd-49658459f22a', false, 'RUB');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (6, 'Norveç', 'NO', '588c1e92-bc17-40c2-8ffb-c7b4fd487e13', false, 'NOK');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (2, 'İspanya', 'ES', '8cd05f16-cb90-4275-bbf1-57b4e4bb353a', false, 'EUR');


--
-- TOC entry 4980 (class 0 OID 425770)
-- Dependencies: 225
-- Data for Name: exchange_rates; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (1, 1, 'EUR', 'TRY', 52.959800, '2026-05-15', '00000000-0000-0000-0000-000000000000', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (3, 6, 'EUR', 'NOK', 10.845000, '2026-05-15', 'dc740165-c992-468a-9d36-02f3f0bedcfe', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (4, 1, 'EUR', 'TRY', 53.091500, '2026-05-18', 'a7bd914a-73dc-4fc3-8a15-d018ec81fbe7', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (5, 6, 'EUR', 'NOK', 10.800500, '2026-05-18', '6aa7e6b4-8273-42a2-994e-43b7805ecf96', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (6, 4, 'EUR', 'RUB', 0.000000, '2026-05-18', '6435255b-b864-4d30-a2ec-65a12ed17488', true);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (7, 1, 'EUR', 'TRY', 34.675231, '2026-04-19', '21ed06eb-d770-44ac-bda1-e344fc9ccc05', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (8, 4, 'EUR', 'RUB', 87.995862, '2026-04-19', '7a9c88ae-e4c1-4da7-8626-6e3dd70473ee', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (9, 6, 'EUR', 'NOK', 10.291607, '2026-04-19', 'a97187f5-45d5-4e32-a765-ebdf8d215285', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (10, 1, 'EUR', 'TRY', 28.125145, '2026-03-19', 'f359be45-eb96-4a90-aba5-6f35b7af939a', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (11, 4, 'EUR', 'RUB', 84.551850, '2026-03-19', 'b7b4a0e4-f4ed-4b8b-8acf-e4f1bd0d82d9', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (12, 6, 'EUR', 'NOK', 10.514350, '2026-03-19', '71294917-23b8-4371-b525-f97973cb389c', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (13, 1, 'EUR', 'TRY', 30.165495, '2026-02-19', 'c33834f7-25ba-4662-8d2f-ec6091d7fc35', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (14, 4, 'EUR', 'RUB', 87.254001, '2026-02-19', 'ece285cc-8ff9-4056-8e50-553338949a5e', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (15, 6, 'EUR', 'NOK', 10.667759, '2026-02-19', '38ce9321-230e-45f6-b906-121d6a351539', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (16, 1, 'EUR', 'TRY', 29.123667, '2026-01-19', '8b4c2ec8-0b8d-48b3-8dda-cce2da69df4a', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (17, 4, 'EUR', 'RUB', 94.459657, '2026-01-19', '7e59cec5-26bb-49ee-b8b2-78ad25a2353a', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (18, 6, 'EUR', 'NOK', 10.500691, '2026-01-19', '43641561-8ec3-4a68-922a-12f68a6567c0', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (19, 1, 'EUR', 'TRY', 26.429594, '2025-12-19', '18f9ab38-8bdf-46de-9951-c2931f2c5cf2', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (20, 4, 'EUR', 'RUB', 90.300156, '2025-12-19', 'be12d51c-8cc5-4c47-bb7a-55de43900d61', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (21, 6, 'EUR', 'NOK', 10.188951, '2025-12-19', 'fc0ab453-7920-4128-b7f1-8a134e9f667a', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (22, 1, 'EUR', 'TRY', 34.044902, '2025-11-19', '600f8a33-bd11-4c0c-b600-7446204a7e2f', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (23, 4, 'EUR', 'RUB', 93.458592, '2025-11-19', '1fdb4fa6-1219-4bce-b746-377f90e12a91', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (24, 6, 'EUR', 'NOK', 11.805724, '2025-11-19', 'ccd5d57c-3115-49b3-a9b2-64c2b4744ea8', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (25, 1, 'EUR', 'TRY', 27.547287, '2025-10-19', '29fed884-6792-49ed-a56f-97a9fa032f6c', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (26, 4, 'EUR', 'RUB', 89.365205, '2025-10-19', 'e1c8831e-255e-4f93-9d20-c64d5f26f6b0', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (27, 6, 'EUR', 'NOK', 11.862517, '2025-10-19', '0bec881f-cc69-4fd8-b9be-2de36b875922', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (28, 1, 'EUR', 'TRY', 29.293321, '2025-09-19', '92f0e5c5-7398-4f4b-8bf3-02a70a4b0ace', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (29, 4, 'EUR', 'RUB', 89.257500, '2025-09-19', 'bb4d387c-108c-43d4-a670-93cb40ffc723', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (30, 6, 'EUR', 'NOK', 11.055776, '2025-09-19', '54b2d40f-a423-4bde-95b2-4be05c9375fd', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (31, 1, 'EUR', 'TRY', 32.083713, '2025-08-19', '9939f5b6-6f92-46b1-b748-ab6266a3cd5a', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (32, 4, 'EUR', 'RUB', 83.542589, '2025-08-19', '71b6ebac-3304-425e-a3a0-10cad52d6ba7', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (33, 6, 'EUR', 'NOK', 10.425543, '2025-08-19', 'f1502f6b-fc6c-4082-bef4-0e1391477b34', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (34, 1, 'EUR', 'TRY', 31.657336, '2025-07-19', '63a0e5cb-7489-429a-85b8-cccfefb9af1f', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (35, 4, 'EUR', 'RUB', 81.464360, '2025-07-19', '8e333726-3b24-4832-97a1-968953584c9a', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (36, 6, 'EUR', 'NOK', 10.700626, '2025-07-19', '93e144a7-b34e-4733-b1da-521afd4ada48', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (37, 1, 'EUR', 'TRY', 32.367409, '2025-06-19', 'eeddf5b5-aa2d-4fe6-924c-273c24ddb345', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (38, 4, 'EUR', 'RUB', 92.175067, '2025-06-19', 'abe77873-78dd-4d06-a975-12dfbe5ea72d', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (39, 6, 'EUR', 'NOK', 10.531166, '2025-06-19', '22076594-d1c0-44bb-873f-9a9ab3909da5', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (40, 1, 'EUR', 'TRY', 31.138577, '2025-05-19', 'bd3cf20e-7ff5-4a50-8a17-4ec553c1efd0', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (41, 4, 'EUR', 'RUB', 97.014636, '2025-05-19', 'ac1743e9-1fef-4ea4-baca-8200d2903798', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (42, 6, 'EUR', 'NOK', 10.716903, '2025-05-19', '5f233fed-7b72-4c89-bc0d-c9d776d0dafc', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (43, 1, 'EUR', 'TRY', 34.865641, '2025-04-19', 'fef92ad2-046e-492b-b294-89f9e629faa7', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (44, 4, 'EUR', 'RUB', 94.529162, '2025-04-19', '54a5fc21-a82a-43ef-862d-9327132338bf', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (45, 6, 'EUR', 'NOK', 11.540810, '2025-04-19', 'ac5d994a-c199-4c39-ab17-244fe3e83e9f', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (46, 1, 'EUR', 'TRY', 30.182859, '2025-03-19', 'c2fb8cd3-8928-45fe-a102-7d16781dd765', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (47, 4, 'EUR', 'RUB', 80.260068, '2025-03-19', '72cc1d7a-8e25-4442-9191-df43b1a0732e', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (48, 6, 'EUR', 'NOK', 10.580933, '2025-03-19', '22610338-71a3-44f4-895a-2d6771c35d26', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (49, 1, 'EUR', 'TRY', 33.672868, '2025-02-19', '212e54d5-729f-4862-89b2-1a3ac9a61214', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (50, 4, 'EUR', 'RUB', 87.072645, '2025-02-19', 'e9ecf56d-caa5-4607-9a99-c34bc9850960', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (51, 6, 'EUR', 'NOK', 11.790449, '2025-02-19', '3fa96c1c-8581-41d6-a462-87ae9860ee76', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (52, 1, 'EUR', 'TRY', 28.786102, '2025-01-19', '8e196be0-7d37-48d2-ace3-e89c2f6a2378', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (53, 4, 'EUR', 'RUB', 90.894533, '2025-01-19', '387720d1-3b85-4fa1-847c-a4ac50ab4e7a', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (54, 6, 'EUR', 'NOK', 10.526387, '2025-01-19', '07374040-a384-4ef0-b942-ef60c94027e9', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (55, 1, 'EUR', 'TRY', 28.114202, '2024-12-19', '5373ab27-9ff8-4de6-aacc-925d7f90258a', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (56, 4, 'EUR', 'RUB', 91.414565, '2024-12-19', '5f1a95e7-d38e-4a66-b757-872fb02334e3', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (57, 6, 'EUR', 'NOK', 10.225004, '2024-12-19', 'f98ad1ee-4d1f-4d52-93d4-4f4813599aee', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (58, 1, 'EUR', 'TRY', 28.001331, '2024-11-19', 'c4ceba5c-71c4-4e55-b8f4-9ad033a44495', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (59, 4, 'EUR', 'RUB', 86.314178, '2024-11-19', '3ffd1fe3-834e-4984-8ea3-b462e8a314f7', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (60, 6, 'EUR', 'NOK', 11.612445, '2024-11-19', 'bb188199-0d32-4870-9ad5-44a4f6e99af9', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (61, 1, 'EUR', 'TRY', 33.450780, '2024-10-19', 'af9b7257-f4ea-40ba-b8c1-0e0b82b4519a', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (62, 4, 'EUR', 'RUB', 89.771931, '2024-10-19', '38d142c0-6169-4969-97e4-e21376e8ba88', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (63, 6, 'EUR', 'NOK', 10.894483, '2024-10-19', '30d2ae98-8dff-411e-a058-8702cb7ea196', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (64, 1, 'EUR', 'TRY', 34.227898, '2024-09-19', 'f271c2d4-f343-4d09-a1f5-f4e9d4b224d0', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (65, 4, 'EUR', 'RUB', 85.865303, '2024-09-19', 'ef3bdd94-b669-4169-98a6-5f9c63653df1', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (66, 6, 'EUR', 'NOK', 10.219877, '2024-09-19', '3d602741-db1d-45b9-93df-9c76415340c1', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (67, 1, 'EUR', 'TRY', 29.985035, '2024-08-19', 'fb7b363a-5dbe-4e71-ab6c-44e767111882', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (68, 4, 'EUR', 'RUB', 92.856192, '2024-08-19', '8b1cb351-9f90-42f0-a05e-ab1259127f01', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (69, 6, 'EUR', 'NOK', 10.547962, '2024-08-19', '9c66a229-55ff-4d6b-9fa6-e84f72483ac8', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (70, 1, 'EUR', 'TRY', 34.210341, '2024-07-19', '9842d69c-e4f8-43e7-bc7a-cd60a957fd9c', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (71, 4, 'EUR', 'RUB', 88.176160, '2024-07-19', '98321ea1-a73e-47e7-af35-2915b67b1e86', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (72, 6, 'EUR', 'NOK', 10.452642, '2024-07-19', 'b5372e43-5add-4c6b-86c7-066dea5b5685', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (73, 1, 'EUR', 'TRY', 31.432285, '2024-06-19', '143df626-d9ca-4b46-b0bf-de52d9478982', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (74, 4, 'EUR', 'RUB', 91.072785, '2024-06-19', '936c898f-1fa4-4bc6-ab42-03610bf9b33e', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (75, 6, 'EUR', 'NOK', 10.062416, '2024-06-19', '19b39f31-17e4-4e6a-8cea-ff2401cb0f58', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (76, 1, 'EUR', 'TRY', 25.582190, '2024-05-19', 'aed49450-0fb6-4ff5-9ec2-489490df7047', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (77, 4, 'EUR', 'RUB', 93.735003, '2024-05-19', 'beac8d51-6f0d-4aaf-b996-78c0ce067c77', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (78, 6, 'EUR', 'NOK', 11.672333, '2024-05-19', '4c6e410d-f288-4be7-916f-88d404fd5781', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (79, 1, 'EUR', 'TRY', 52.956500, '2026-05-19', '0c630c5c-fd1c-4045-b273-beec967e39de', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (80, 6, 'EUR', 'NOK', 10.763500, '2026-05-19', '35d923cc-2dcc-4560-ae9d-e3f94a7263dd', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (81, 2, 'EUR', 'EUR', 1.000000, '2026-05-19', '00cee9ac-ed37-4b2c-beef-b7951cc6f4e3', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (83, 2, 'EUR', 'EUR', 1.000000, '2026-05-18', '5ebe5c1a-f407-498b-968a-74a94843236b', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (84, 2, 'EUR', 'EUR', 1.000000, '2026-05-17', '2611c108-1182-4bbe-81c3-de5b1c077fb7', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (85, 2, 'EUR', 'EUR', 1.000000, '2026-05-16', '91e07bbb-9788-4be9-a95b-2a3b05b3fb63', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (86, 2, 'EUR', 'EUR', 1.000000, '2026-05-15', '818296c8-4326-4464-ae94-e3115d87dfc0', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (87, 2, 'EUR', 'EUR', 1.000000, '2026-05-14', '0bdd945f-d83f-4150-8115-5224892b8834', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (88, 2, 'EUR', 'EUR', 1.000000, '2026-05-13', '20c2b1e5-5c83-4154-a7a4-2e5339f46b51', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (89, 2, 'EUR', 'EUR', 1.000000, '2026-05-12', 'da0b1c06-30e2-4f10-b43d-8bc61d0ad3f6', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (90, 2, 'EUR', 'EUR', 1.000000, '2026-05-11', '5a4aea7c-0101-4091-ae8b-91372baa5615', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (91, 2, 'EUR', 'EUR', 1.000000, '2026-05-10', '99b5837f-cf4c-4f05-a556-541600bf88bb', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (92, 2, 'EUR', 'EUR', 1.000000, '2026-05-09', '3e5a5f2e-26c2-4333-8597-1498362ad974', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (93, 2, 'EUR', 'EUR', 1.000000, '2026-05-08', '8d68ed83-236b-4fa6-b076-2487bc8320f6', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (94, 2, 'EUR', 'EUR', 1.000000, '2026-05-07', '7e43c33e-d326-4a33-a200-0446caf43c9f', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (95, 2, 'EUR', 'EUR', 1.000000, '2026-05-06', '18289ca3-c5dc-4cba-a9b7-3064ee2bcc19', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (96, 1, 'EUR', 'TRY', 52.880300, '2026-05-20', '8440d134-e0ab-43c8-b3ce-1d5fe82cdbfe', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (97, 6, 'EUR', 'NOK', 10.764000, '2026-05-20', 'cc058302-a6aa-43db-835f-d7a1ce83074d', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (98, 2, 'EUR', 'EUR', 1.000000, '2026-05-20', '8adcd03f-992d-4a87-b941-0d3214dc0340', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (99, 1, 'EUR', 'TRY', 52.905500, '2026-05-21', '3dcf4e6f-0813-4fb1-bd25-7709c2a90fe6', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (100, 6, 'EUR', 'NOK', 10.707500, '2026-05-21', '2faffd1d-d42c-4bd9-b3b5-6be89ccea39d', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (101, 2, 'EUR', 'EUR', 1.000000, '2026-05-21', 'e1346946-5345-4dbe-bd64-2719eafeb6d9', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (102, 1, 'EUR', 'TRY', 53.225000, '2026-05-25', '783d5c2c-d4cf-4732-b760-7b84690b5c4c', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (103, 6, 'EUR', 'NOK', 10.766000, '2026-05-25', 'd562ecb9-10ba-4d3f-9fc8-6b78c67d393b', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (104, 2, 'EUR', 'EUR', 1.000000, '2026-05-25', '576ff8e0-de92-4f97-85c1-f176a48f99c7', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (105, 1, 'EUR', 'TRY', 53.321300, '2026-05-28', '53da9d78-c77a-45c8-b94a-083b072540cf', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (106, 6, 'EUR', 'NOK', 10.794000, '2026-05-28', '6e40dfb7-7888-490d-be84-8d7c7c446971', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (107, 2, 'EUR', 'EUR', 1.000000, '2026-05-28', 'f5891d3c-294b-47f9-94bb-452878ad7970', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (108, 1, 'EUR', 'TRY', 53.429700, '2026-05-29', 'ec1f8f52-321d-4147-a3a7-f98e214a78d2', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (109, 6, 'EUR', 'NOK', 10.773500, '2026-05-29', 'bb46ea01-e8d0-4996-9637-ac7cb8574d98', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (110, 2, 'EUR', 'EUR', 1.000000, '2026-05-29', '971e957c-e9a6-4300-9f83-727f6f279168', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (111, 1, 'EUR', 'TRY', 53.374900, '2026-06-03', '0bef708d-68b4-4e34-930e-828496644c67', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (112, 6, 'EUR', 'NOK', 10.793500, '2026-06-03', '61a160f4-74a7-4faa-bd89-5237f73bb268', false);
INSERT INTO public.exchange_rates OVERRIDING SYSTEM VALUE VALUES (113, 2, 'EUR', 'EUR', 1.000000, '2026-06-03', 'e914cf32-d754-4149-92aa-a55f925df4d0', false);


--
-- TOC entry 4986 (class 0 OID 425803)
-- Dependencies: 231
-- Data for Name: forecasts; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9397, NULL, 1, 'ExchangeRate', '2026-06-28', 55.120000, 'ARIMA+LSTM', '2026-05-29 14:36:31.924872', 'b3c4eb67-c2bb-442d-8795-985ebd6e798d', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9398, NULL, 1, 'ExchangeRate', '2026-07-28', 54.640000, 'ARIMA+LSTM', '2026-05-29 14:36:31.927834', '0076e9ab-964f-4013-aec7-0b3fd7a1e495', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9399, NULL, 1, 'ExchangeRate', '2026-08-28', 54.800000, 'ARIMA+LSTM', '2026-05-29 14:36:31.928632', 'e3903e7a-4f02-4176-af09-80dd7b74e2fc', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9400, NULL, 1, 'ExchangeRate', '2026-09-28', 54.990000, 'ARIMA+LSTM', '2026-05-29 14:36:31.92937', 'b6810349-49dc-4b0a-a15e-3118e25071e6', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9401, NULL, 1, 'ExchangeRate', '2026-10-28', 54.940000, 'ARIMA+LSTM', '2026-05-29 14:36:31.930105', 'cda3c158-d06f-4927-a589-c62dcfa4a66c', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9402, NULL, 1, 'ExchangeRate', '2026-11-28', 54.960000, 'ARIMA+LSTM', '2026-05-29 14:36:31.930847', '65fb34d6-8f74-4b32-a239-75cdcd55a388', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9403, NULL, 4, 'ExchangeRate', '2026-06-18', 15.400000, 'ARIMA+LSTM', '2026-05-29 14:36:36.866003', 'e2257c65-48b8-4464-a52e-852b2a037d85', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9404, NULL, 4, 'ExchangeRate', '2026-07-18', 0.010000, 'ARIMA+LSTM', '2026-05-29 14:36:36.868335', '998866f3-7f99-4e8d-a74f-9a50db871e4e', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9405, NULL, 4, 'ExchangeRate', '2026-08-18', 0.010000, 'ARIMA+LSTM', '2026-05-29 14:36:36.869572', 'c85ca119-eead-4347-bca4-a559745f0813', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9406, NULL, 4, 'ExchangeRate', '2026-09-18', 0.010000, 'ARIMA+LSTM', '2026-05-29 14:36:36.870379', '6ee968c3-d6d4-4965-8075-90a148768f69', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9407, NULL, 4, 'ExchangeRate', '2026-10-18', 0.010000, 'ARIMA+LSTM', '2026-05-29 14:36:36.871144', 'fcd34f91-b0ed-4253-8ebc-6e659a1050ba', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9408, NULL, 4, 'ExchangeRate', '2026-11-18', 0.010000, 'ARIMA+LSTM', '2026-05-29 14:36:36.871921', '510d52d3-9c5b-4de0-aca1-2051433fd521', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9409, NULL, 6, 'ExchangeRate', '2026-06-28', 10.940000, 'ARIMA+LSTM', '2026-05-29 14:36:42.385266', 'c039b7a4-ab44-4bd2-99da-6ab198b896a0', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9410, NULL, 6, 'ExchangeRate', '2026-07-28', 10.890000, 'ARIMA+LSTM', '2026-05-29 14:36:42.388146', '8ce31211-67b0-42be-92bb-d54390af7053', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9411, NULL, 6, 'ExchangeRate', '2026-08-28', 10.920000, 'ARIMA+LSTM', '2026-05-29 14:36:42.388954', '6ec355f4-8de2-40f3-bfc2-baa2dcf09cc0', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9412, NULL, 6, 'ExchangeRate', '2026-09-28', 10.830000, 'ARIMA+LSTM', '2026-05-29 14:36:42.389691', 'cdb50a8e-8e2b-45d2-bd37-8e83aa1c29c2', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9413, NULL, 6, 'ExchangeRate', '2026-10-28', 10.900000, 'ARIMA+LSTM', '2026-05-29 14:36:42.390438', 'f9ba02af-9f86-40b9-85fc-1c6cfbbddb60', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9414, NULL, 6, 'ExchangeRate', '2026-11-28', 10.890000, 'ARIMA+LSTM', '2026-05-29 14:36:42.391185', '5ae7aaee-7192-46bb-8d34-9da330fd5a8c', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9415, NULL, 2, 'ExchangeRate', '2026-06-28', 1.000000, 'ARIMA+LSTM', '2026-05-29 14:36:47.137318', '9c140e69-7e44-4de9-8ad2-7bc70bfdacc0', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9416, NULL, 2, 'ExchangeRate', '2026-07-28', 1.000000, 'ARIMA+LSTM', '2026-05-29 14:36:47.13997', '9fbf0273-7cd7-40fe-95ae-b6a859363840', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9417, NULL, 2, 'ExchangeRate', '2026-08-28', 1.000000, 'ARIMA+LSTM', '2026-05-29 14:36:47.140794', '8e3a00b5-3fc5-4961-9159-72307e1b3f13', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9418, NULL, 2, 'ExchangeRate', '2026-09-28', 1.000000, 'ARIMA+LSTM', '2026-05-29 14:36:47.141565', '9e00bcba-faab-4d44-a439-f75ca5190fad', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9419, NULL, 2, 'ExchangeRate', '2026-10-28', 1.000000, 'ARIMA+LSTM', '2026-05-29 14:36:47.142324', '5137493c-8d7e-4424-9544-7014518caf0d', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9420, NULL, 2, 'ExchangeRate', '2026-11-28', 1.000000, 'ARIMA+LSTM', '2026-05-29 14:36:47.143101', 'be435db4-b5de-4072-a606-afb6f31a9d24', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10903, 12, 4, 'AccommodationPrice', '2026-07-01', 222.180000, 'ARIMA+LSTM', '2026-06-04 16:45:27.446691', '82db7abb-8979-4f35-aeaf-13791665291a', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10904, 12, 4, 'AccommodationPrice', '2026-08-01', 282.380000, 'ARIMA+LSTM', '2026-06-04 16:45:27.449923', '1e007463-b8d9-41d8-a4bb-d5a747d744f7', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10905, 12, 4, 'AccommodationPrice', '2026-09-01', 88.030000, 'ARIMA+LSTM', '2026-06-04 16:45:27.45096', '63b38f28-5219-41b1-9017-e22b3db267f4', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10906, 12, 4, 'AccommodationPrice', '2026-10-01', 109.000000, 'ARIMA+LSTM', '2026-06-04 16:45:27.451817', '2bd62540-a01d-4e05-b746-0355416c5288', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10907, 12, 4, 'AccommodationPrice', '2026-11-01', 106.690000, 'ARIMA+LSTM', '2026-06-04 16:45:27.45247', 'b8b047c2-1aa2-4df3-9689-43409add8e87', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10908, 12, 4, 'AccommodationPrice', '2026-12-01', 250.690000, 'ARIMA+LSTM', '2026-06-04 16:45:27.45305', '0bf135d8-9476-4f3e-8b88-3628066d9d7c', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10909, 13, 4, 'TouristCount', '2026-07-01', 167520.640000, 'ARIMA+LSTM', '2026-06-04 16:45:33.121516', 'f4412617-0295-4ab5-83bd-f249f12e6983', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10910, 13, 4, 'TouristCount', '2026-08-01', 142340.110000, 'ARIMA+LSTM', '2026-06-04 16:45:33.124138', '63a79be7-2098-44d7-a48d-26f3ba8e2448', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10911, 13, 4, 'TouristCount', '2026-09-01', 89206.860000, 'ARIMA+LSTM', '2026-06-04 16:45:33.124906', 'e5f04485-20d5-4f30-a101-a21d43b33783', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10912, 13, 4, 'TouristCount', '2026-10-01', 68275.550000, 'ARIMA+LSTM', '2026-06-04 16:45:33.125515', '51407008-f4a5-4426-8d6a-4c9ff19b486f', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10913, 13, 4, 'TouristCount', '2026-11-01', 80346.880000, 'ARIMA+LSTM', '2026-06-04 16:45:33.126163', 'ff92c4d6-1969-4a1b-9d0b-e851a4c71ef4', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10914, 13, 4, 'TouristCount', '2026-12-01', 106350.250000, 'ARIMA+LSTM', '2026-06-04 16:45:33.12666', 'fb1556d0-e471-4d98-bbeb-c80189e32a01', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10915, 13, 4, 'AccommodationPrice', '2026-07-01', 266.270000, 'ARIMA+LSTM', '2026-06-04 16:45:39.714927', '804b3f74-ed30-4fbb-abfb-7dfc6e839dca', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10916, 13, 4, 'AccommodationPrice', '2026-08-01', 243.910000, 'ARIMA+LSTM', '2026-06-04 16:45:39.716706', '34fbfacd-f8a5-42b0-9b33-6983d650c3a5', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10917, 13, 4, 'AccommodationPrice', '2026-09-01', 57.800000, 'ARIMA+LSTM', '2026-06-04 16:45:39.717261', '5c52ca4c-eef9-43c9-9977-b35dc9578040', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10918, 13, 4, 'AccommodationPrice', '2026-10-01', 133.880000, 'ARIMA+LSTM', '2026-06-04 16:45:39.718075', '72bd47d1-829f-478b-bb5c-bb673ef78139', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10919, 13, 4, 'AccommodationPrice', '2026-11-01', 147.420000, 'ARIMA+LSTM', '2026-06-04 16:45:39.718978', 'cc1d8bd2-0206-4239-992a-7a1b9d8480b6', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10920, 13, 4, 'AccommodationPrice', '2026-12-01', 251.820000, 'ARIMA+LSTM', '2026-06-04 16:45:39.719776', '9d06118a-d5fa-4290-8c85-bf26df82f9a8', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10165, 7, 2, 'TouristCount', '2026-06-01', 120882.120000, 'ARIMA+LSTM', '2026-05-29 16:29:20.414656', '52ec62c9-4093-4b01-8694-23c64df9656a', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10166, 7, 2, 'TouristCount', '2026-07-01', 114618.660000, 'ARIMA+LSTM', '2026-05-29 16:29:20.415929', 'd42af134-71ab-4496-a4c4-ed983ed58a0b', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10167, 7, 2, 'TouristCount', '2026-08-01', 113907.680000, 'ARIMA+LSTM', '2026-05-29 16:29:20.416815', 'abc8640f-91e9-49e7-9bc1-e7e55939f774', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10168, 7, 2, 'TouristCount', '2026-09-01', 75734.830000, 'ARIMA+LSTM', '2026-05-29 16:29:20.417467', '3867ac7b-d43c-47cb-b1b5-2d9054f92657', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10169, 7, 2, 'TouristCount', '2026-10-01', 80226.360000, 'ARIMA+LSTM', '2026-05-29 16:29:20.418125', 'd2af8f75-d012-4f73-9c92-c7363de374e1', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10170, 7, 2, 'TouristCount', '2026-11-01', 91731.370000, 'ARIMA+LSTM', '2026-05-29 16:29:20.418942', '1f9f0b3d-8e90-4daa-995f-59faeb46e6dd', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10171, 7, 2, 'AccommodationPrice', '2026-06-01', 111.020000, 'ARIMA+LSTM', '2026-05-29 16:29:25.951326', '08ae880b-ba00-44b2-aa38-3ede5fb44abe', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10172, 7, 2, 'AccommodationPrice', '2026-07-01', 111.940000, 'ARIMA+LSTM', '2026-05-29 16:29:25.95402', '34472584-71d1-4d5e-b703-414586d35c13', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10173, 7, 2, 'AccommodationPrice', '2026-08-01', 131.340000, 'ARIMA+LSTM', '2026-05-29 16:29:25.954842', '9b8dc866-579c-49fe-9f94-667f32fbe993', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10174, 7, 2, 'AccommodationPrice', '2026-09-01', 111.500000, 'ARIMA+LSTM', '2026-05-29 16:29:25.955624', '8f708f11-2d87-4423-9dfb-721f8f90e0bf', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10175, 7, 2, 'AccommodationPrice', '2026-10-01', 105.300000, 'ARIMA+LSTM', '2026-05-29 16:29:25.956401', '51a76f3c-773e-48f6-8931-15b42a651b27', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10176, 7, 2, 'AccommodationPrice', '2026-11-01', 93.180000, 'ARIMA+LSTM', '2026-05-29 16:29:25.957196', 'bd3e2d70-3318-45a6-ac4a-497558adc972', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10297, 1, 1, 'TouristCount', '2026-06-01', 121827.080000, 'ARIMA+LSTM', '2026-05-29 16:51:47.295115', 'd1d4efed-56f4-4f8e-8aa4-68ea001ef813', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10298, 1, 1, 'TouristCount', '2026-07-01', 117776.480000, 'ARIMA+LSTM', '2026-05-29 16:51:47.310043', '1d383b7a-a038-41be-bb09-9533555f3d40', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10299, 1, 1, 'TouristCount', '2026-08-01', 103974.780000, 'ARIMA+LSTM', '2026-05-29 16:51:47.310985', '2755363d-6643-4a50-b22b-bad30b737265', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10300, 1, 1, 'TouristCount', '2026-09-01', 103810.550000, 'ARIMA+LSTM', '2026-05-29 16:51:47.311633', '745a85c9-15ad-4781-88e3-6581e1120e06', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10301, 1, 1, 'TouristCount', '2026-10-01', 103326.830000, 'ARIMA+LSTM', '2026-05-29 16:51:47.312192', '1a3e070e-345b-4339-a967-5009cb021781', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10302, 1, 1, 'TouristCount', '2026-11-01', 108348.330000, 'ARIMA+LSTM', '2026-05-29 16:51:47.312746', '4df74baa-f25d-4f34-8f61-c9f584e9ad6f', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10303, 1, 1, 'AccommodationPrice', '2026-06-01', 162.770000, 'ARIMA+LSTM', '2026-05-29 16:52:01.055343', '1e072b3d-d732-4405-b76c-790b4cd7e8c3', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10304, 1, 1, 'AccommodationPrice', '2026-07-01', 159.010000, 'ARIMA+LSTM', '2026-05-29 16:52:01.058037', 'adccbf8b-4e5e-49c0-9548-f1f985537c9b', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10305, 1, 1, 'AccommodationPrice', '2026-08-01', 138.020000, 'ARIMA+LSTM', '2026-05-29 16:52:01.058827', '40020589-8207-48cd-8604-abc6ecb24cf8', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10306, 1, 1, 'AccommodationPrice', '2026-09-01', 113.620000, 'ARIMA+LSTM', '2026-05-29 16:52:01.059444', 'ad63cce6-6f56-4ebb-b38e-3d5a21c04c19', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10307, 1, 1, 'AccommodationPrice', '2026-10-01', 108.650000, 'ARIMA+LSTM', '2026-05-29 16:52:01.060032', '0f20ce64-6bed-419a-8e5a-fb0414f54d47', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10308, 1, 1, 'AccommodationPrice', '2026-11-01', 119.540000, 'ARIMA+LSTM', '2026-05-29 16:52:01.060572', 'fc367af4-5208-4652-a65f-43b919f92185', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10309, 2, 1, 'TouristCount', '2026-06-01', 77117.250000, 'ARIMA+LSTM', '2026-05-29 16:52:06.300059', '8360d0d3-0159-4ddb-9003-3fa68f44578c', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10310, 2, 1, 'TouristCount', '2026-07-01', 89582.300000, 'ARIMA+LSTM', '2026-05-29 16:52:06.301908', '5c13cc51-d3ca-4116-a5d5-51e4cdc46f73', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10311, 2, 1, 'TouristCount', '2026-08-01', 87796.040000, 'ARIMA+LSTM', '2026-05-29 16:52:06.302866', 'd50fcee1-663f-488f-b35d-bc53ca11f792', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10312, 2, 1, 'TouristCount', '2026-09-01', 91767.280000, 'ARIMA+LSTM', '2026-05-29 16:52:06.303727', '643a5984-4040-4b86-84b1-d24c9c4eb396', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10313, 2, 1, 'TouristCount', '2026-10-01', 86547.960000, 'ARIMA+LSTM', '2026-05-29 16:52:06.304964', '8aabac0c-6e2c-499a-9e50-a5cd5aa22cff', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10314, 2, 1, 'TouristCount', '2026-11-01', 82998.080000, 'ARIMA+LSTM', '2026-05-29 16:52:06.305861', '5bb663f1-7c33-4453-a428-68bdabc6aa88', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10315, 2, 1, 'AccommodationPrice', '2026-06-01', 144.440000, 'ARIMA+LSTM', '2026-05-29 16:52:11.592659', '0f93298a-4684-40db-ac15-2547d5a22f23', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10316, 2, 1, 'AccommodationPrice', '2026-07-01', 146.930000, 'ARIMA+LSTM', '2026-05-29 16:52:11.595186', '6921df5a-77ff-4703-9557-e2794861ab67', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10317, 2, 1, 'AccommodationPrice', '2026-08-01', 143.060000, 'ARIMA+LSTM', '2026-05-29 16:52:11.595776', '52118177-fecb-4515-976f-19e54303f0dc', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10318, 2, 1, 'AccommodationPrice', '2026-09-01', 126.090000, 'ARIMA+LSTM', '2026-05-29 16:52:11.596324', '76d82f15-acf5-424a-8fef-fd484c9217ca', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10319, 2, 1, 'AccommodationPrice', '2026-10-01', 123.230000, 'ARIMA+LSTM', '2026-05-29 16:52:11.596847', '0221c1c7-381a-4110-aad6-1cca4412adf4', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10320, 2, 1, 'AccommodationPrice', '2026-11-01', 106.440000, 'ARIMA+LSTM', '2026-05-29 16:52:11.597379', '8d2af6e6-a282-4426-bc4b-9fe25c35e9de', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10861, 3, 1, 'TouristCount', '2026-07-01', 203795.520000, 'ARIMA+LSTM', '2026-06-04 16:44:48.313755', 'd395a383-cc3b-49d6-8c44-d6c9c6ad92fb', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10862, 3, 1, 'TouristCount', '2026-08-01', 144095.540000, 'ARIMA+LSTM', '2026-06-04 16:44:48.318633', '67573c28-f41e-46fc-9612-b80c581ea7fd', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10863, 3, 1, 'TouristCount', '2026-09-01', 34086.930000, 'ARIMA+LSTM', '2026-06-04 16:44:48.319394', '6f4ad833-480c-4631-a9bc-f928675a2cbd', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10864, 3, 1, 'TouristCount', '2026-10-01', 93223.120000, 'ARIMA+LSTM', '2026-06-04 16:44:48.320078', '3b4cd5a1-b3c7-4070-88c2-411bbb8352c9', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10865, 3, 1, 'TouristCount', '2026-11-01', 64616.580000, 'ARIMA+LSTM', '2026-06-04 16:44:48.320775', 'd6c3281f-3039-4fb1-8e1a-fce05f9d437d', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10866, 3, 1, 'TouristCount', '2026-12-01', 157657.290000, 'ARIMA+LSTM', '2026-06-04 16:44:48.321405', '80707323-e6ad-4773-af02-5e8d837ccf08', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10867, 3, 1, 'AccommodationPrice', '2026-07-01', 248.040000, 'ARIMA+LSTM', '2026-06-04 16:44:53.599363', '071dafbf-0c7d-47ed-b2cf-920e23750ed1', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10868, 3, 1, 'AccommodationPrice', '2026-08-01', 281.260000, 'ARIMA+LSTM', '2026-06-04 16:44:53.602064', '7e4fb402-5321-4794-b5b1-ca62dd857328', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10869, 3, 1, 'AccommodationPrice', '2026-09-01', 29.460000, 'ARIMA+LSTM', '2026-06-04 16:44:53.60284', 'f7ecd39b-1a66-42f0-9a6f-7373292d4a79', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10870, 3, 1, 'AccommodationPrice', '2026-10-01', 115.740000, 'ARIMA+LSTM', '2026-06-04 16:44:53.60374', '59ca1dd4-364a-4f65-990b-63c805af0966', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10871, 3, 1, 'AccommodationPrice', '2026-11-01', 183.510000, 'ARIMA+LSTM', '2026-06-04 16:44:53.604506', '85e28a62-69e8-4858-bd3c-53e31e7b84a4', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10872, 3, 1, 'AccommodationPrice', '2026-12-01', 219.880000, 'ARIMA+LSTM', '2026-06-04 16:44:53.605241', 'd281ca4e-e15e-427c-9aad-7b2165c99300', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10873, 4, 1, 'TouristCount', '2026-07-01', 7012.350000, 'ARIMA+LSTM', '2026-06-04 16:44:58.814862', '3c7d80cd-3777-4c66-9132-1624213eec3b', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10874, 4, 1, 'TouristCount', '2026-08-01', 67240.470000, 'ARIMA+LSTM', '2026-06-04 16:44:58.816095', '1f2645af-6a44-4a53-bd58-45e712916c07', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10875, 4, 1, 'TouristCount', '2026-09-01', 214340.470000, 'ARIMA+LSTM', '2026-06-04 16:44:58.816988', 'f0385ebf-d1e2-4c8a-905e-25c73db0bc49', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10876, 4, 1, 'TouristCount', '2026-10-01', 0.000000, 'ARIMA+LSTM', '2026-06-04 16:44:58.817923', 'e3539d63-8385-4e7f-be7b-5a5e8f8242f0', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10877, 4, 1, 'TouristCount', '2026-11-01', 0.000000, 'ARIMA+LSTM', '2026-06-04 16:44:58.81874', 'c9451afc-a09a-47f3-a880-b7db18fb9b54', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10878, 4, 1, 'TouristCount', '2026-12-01', 219366.010000, 'ARIMA+LSTM', '2026-06-04 16:44:58.819474', 'c574e5d2-5861-4105-b6aa-53c8ac3a82bb', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10879, 4, 1, 'AccommodationPrice', '2026-07-01', 163.960000, 'ARIMA+LSTM', '2026-06-04 16:45:04.093407', 'b2d8722a-0d39-4eaa-8eba-fffe9efe2a27', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10880, 4, 1, 'AccommodationPrice', '2026-08-01', 158.040000, 'ARIMA+LSTM', '2026-06-04 16:45:04.094262', '8ea74bb3-e582-4fa4-929e-ddd5cfc2a65a', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10881, 4, 1, 'AccommodationPrice', '2026-09-01', 125.880000, 'ARIMA+LSTM', '2026-06-04 16:45:04.094928', '2a8d0b0d-b483-43ae-b3dc-a0189f5cfec3', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10882, 4, 1, 'AccommodationPrice', '2026-10-01', 108.350000, 'ARIMA+LSTM', '2026-06-04 16:45:04.095486', '4b681ede-ec0b-4d42-adaf-e41f0290acb0', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10883, 4, 1, 'AccommodationPrice', '2026-11-01', 113.760000, 'ARIMA+LSTM', '2026-06-04 16:45:04.095966', '35f572c1-bef0-4560-9cae-ed10a881183f', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10884, 4, 1, 'AccommodationPrice', '2026-12-01', 148.090000, 'ARIMA+LSTM', '2026-06-04 16:45:04.096374', '78af7251-7ec4-4dc0-95b5-8f71089bb68e', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10885, 11, 4, 'TouristCount', '2026-07-01', 243270.950000, 'ARIMA+LSTM', '2026-06-04 16:45:09.815975', 'e63cd019-c7f7-4235-9011-bb9d967cc79c', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10886, 11, 4, 'TouristCount', '2026-08-01', 222138.200000, 'ARIMA+LSTM', '2026-06-04 16:45:09.818896', '24519def-4d95-4793-82ba-880d6ee12ee4', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10887, 11, 4, 'TouristCount', '2026-09-01', 90549.060000, 'ARIMA+LSTM', '2026-06-04 16:45:09.819998', 'e51bfbc3-df81-435f-b090-15688d7408a8', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10888, 11, 4, 'TouristCount', '2026-10-01', 64459.740000, 'ARIMA+LSTM', '2026-06-04 16:45:09.821401', 'b0da0078-1a60-43a7-8c22-0b3e37807aa3', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10889, 11, 4, 'TouristCount', '2026-11-01', 47437.250000, 'ARIMA+LSTM', '2026-06-04 16:45:09.822076', 'b8428f34-fd8e-4f10-9da9-9acb3f775d59', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10890, 11, 4, 'TouristCount', '2026-12-01', 153808.160000, 'ARIMA+LSTM', '2026-06-04 16:45:09.822724', '3b348bdd-b9d4-496e-a7d6-5b417e6f8d40', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10891, 11, 4, 'AccommodationPrice', '2026-07-01', 227.810000, 'ARIMA+LSTM', '2026-06-04 16:45:15.710265', '3085aa8e-6162-455c-97ae-f4e32698865e', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10892, 11, 4, 'AccommodationPrice', '2026-08-01', 140.000000, 'ARIMA+LSTM', '2026-06-04 16:45:15.713165', '0847eba0-6c95-4735-8a44-19d661af5792', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10893, 11, 4, 'AccommodationPrice', '2026-09-01', 111.020000, 'ARIMA+LSTM', '2026-06-04 16:45:15.714117', 'fc400cc0-782d-4dd8-b807-140966791b10', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10894, 11, 4, 'AccommodationPrice', '2026-10-01', 161.260000, 'ARIMA+LSTM', '2026-06-04 16:45:15.714871', '02f7860d-c316-4599-8e55-e104f5c6d432', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10895, 11, 4, 'AccommodationPrice', '2026-11-01', 143.160000, 'ARIMA+LSTM', '2026-06-04 16:45:15.715734', 'f523f077-8cdb-4f5b-a959-98d308478907', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10896, 11, 4, 'AccommodationPrice', '2026-12-01', 206.690000, 'ARIMA+LSTM', '2026-06-04 16:45:15.716576', '79227f72-ddde-4a8b-b016-d66ba41651ac', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10897, 12, 4, 'TouristCount', '2026-07-01', 157802.380000, 'ARIMA+LSTM', '2026-06-04 16:45:21.820867', '981a9f0f-1d7a-4bfd-a342-c85a04fe35ad', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10898, 12, 4, 'TouristCount', '2026-08-01', 301502.050000, 'ARIMA+LSTM', '2026-06-04 16:45:21.823547', 'f485e08b-bfb8-493d-b649-aa0c6139b767', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10899, 12, 4, 'TouristCount', '2026-09-01', 78236.210000, 'ARIMA+LSTM', '2026-06-04 16:45:21.825071', '92abe8a4-9840-4109-8593-778e39192574', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10900, 12, 4, 'TouristCount', '2026-10-01', 69936.020000, 'ARIMA+LSTM', '2026-06-04 16:45:21.826094', '4983a128-6803-4045-8888-c5fede8248cc', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9367, 8, 6, 'AccommodationPrice', '2026-06-01', 162.510000, 'ARIMA+LSTM', '2026-05-29 14:36:05.585528', 'bb5bf5fa-31fd-4a1e-bf3e-a4a13096011d', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9368, 8, 6, 'AccommodationPrice', '2026-07-01', 161.420000, 'ARIMA+LSTM', '2026-05-29 14:36:05.588074', 'cb13d719-b77f-4a1a-b33f-2202610bad1a', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9369, 8, 6, 'AccommodationPrice', '2026-08-01', 162.930000, 'ARIMA+LSTM', '2026-05-29 14:36:05.588889', '70280d05-50ee-4191-abcd-2213356768f6', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9370, 8, 6, 'AccommodationPrice', '2026-09-01', 115.230000, 'ARIMA+LSTM', '2026-05-29 14:36:05.589519', '1afd765c-5429-452d-bb4f-c8ac4ab82d6a', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10901, 12, 4, 'TouristCount', '2026-11-01', 119482.360000, 'ARIMA+LSTM', '2026-06-04 16:45:21.827081', '1d15da44-7ff9-4985-8511-7aee7c338699', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (10902, 12, 4, 'TouristCount', '2026-12-01', 201156.200000, 'ARIMA+LSTM', '2026-06-04 16:45:21.828002', '3f418d7d-9e51-4586-83bb-9ba6a46d4fef', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9949, 5, 2, 'TouristCount', '2026-06-01', 122073.670000, 'ARIMA+LSTM', '2026-05-29 16:08:11.546895', '6c00b596-710e-4fc7-ac7e-c6a92279c2c2', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9950, 5, 2, 'TouristCount', '2026-07-01', 111141.440000, 'ARIMA+LSTM', '2026-05-29 16:08:11.549616', '8f974b9f-1e45-45e9-9f60-a329436cfad3', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9951, 5, 2, 'TouristCount', '2026-08-01', 105805.890000, 'ARIMA+LSTM', '2026-05-29 16:08:11.550427', '56f8f56b-23ef-492d-b9f0-d8266a9e623d', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9952, 5, 2, 'TouristCount', '2026-09-01', 93301.900000, 'ARIMA+LSTM', '2026-05-29 16:08:11.551182', 'd699c5bc-9a90-4461-8234-139d5f2844a2', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9953, 5, 2, 'TouristCount', '2026-10-01', 82538.550000, 'ARIMA+LSTM', '2026-05-29 16:08:11.551929', '76cbccdd-9832-4637-a7b1-136dfdc516af', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9954, 5, 2, 'TouristCount', '2026-11-01', 100850.040000, 'ARIMA+LSTM', '2026-05-29 16:08:11.552673', 'a5d2b4e8-4e4e-42d3-bb52-28ee8ff1793f', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9955, 5, 2, 'AccommodationPrice', '2026-06-01', 160.000000, 'ARIMA+LSTM', '2026-05-29 16:08:16.659786', '05a46ddc-3239-4b46-a0a5-5c8f2575001a', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9956, 5, 2, 'AccommodationPrice', '2026-07-01', 171.220000, 'ARIMA+LSTM', '2026-05-29 16:08:16.662561', 'f2da4668-c53a-4371-b9b3-7c35ac1b0d9c', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9957, 5, 2, 'AccommodationPrice', '2026-08-01', 138.160000, 'ARIMA+LSTM', '2026-05-29 16:08:16.663387', '2df7f25f-a7b3-4005-95a6-e89d82041ebb', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9958, 5, 2, 'AccommodationPrice', '2026-09-01', 108.310000, 'ARIMA+LSTM', '2026-05-29 16:08:16.664098', 'a9442ede-74a4-459b-8bc5-fa678e832a73', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9959, 5, 2, 'AccommodationPrice', '2026-10-01', 110.480000, 'ARIMA+LSTM', '2026-05-29 16:08:16.664871', 'd9b21407-f65b-4b1f-9002-c29c6f96205d', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9960, 5, 2, 'AccommodationPrice', '2026-11-01', 140.730000, 'ARIMA+LSTM', '2026-05-29 16:08:16.665632', '51fe2e48-26f4-4b3d-a051-7c40fd699954', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9961, 6, 2, 'TouristCount', '2026-06-01', 82147.470000, 'ARIMA+LSTM', '2026-05-29 16:08:21.671235', '6f9b08bf-b8c4-4e11-b3dd-8bc2bf21b231', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9962, 6, 2, 'TouristCount', '2026-07-01', 129161.610000, 'ARIMA+LSTM', '2026-05-29 16:08:21.674073', '59124896-c07e-4116-b508-67d16cc8e5eb', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9963, 6, 2, 'TouristCount', '2026-08-01', 93623.190000, 'ARIMA+LSTM', '2026-05-29 16:08:21.674887', '604c80e7-cfaf-4470-9058-be564ab9b3cf', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9964, 6, 2, 'TouristCount', '2026-09-01', 83513.260000, 'ARIMA+LSTM', '2026-05-29 16:08:21.675642', '626c7311-630f-469a-9e68-7c9d6730e8f0', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9965, 6, 2, 'TouristCount', '2026-10-01', 61705.380000, 'ARIMA+LSTM', '2026-05-29 16:08:21.676419', 'd6e62c1c-9f77-4bf0-9566-e078ffa21e80', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9966, 6, 2, 'TouristCount', '2026-11-01', 81017.960000, 'ARIMA+LSTM', '2026-05-29 16:08:21.677147', 'ef918149-5d58-4b71-9d45-9acfeeef060c', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9967, 6, 2, 'AccommodationPrice', '2026-06-01', 123.670000, 'ARIMA+LSTM', '2026-05-29 16:08:26.779945', '47e4ad22-4849-461b-afb3-6437b5aad44b', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9968, 6, 2, 'AccommodationPrice', '2026-07-01', 127.020000, 'ARIMA+LSTM', '2026-05-29 16:08:26.782488', 'f54a62f1-b9b2-4657-ba08-6024585fe5f6', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9371, 8, 6, 'AccommodationPrice', '2026-10-01', 106.160000, 'ARIMA+LSTM', '2026-05-29 14:36:05.590063', '6420aee3-dd4b-4f92-96e1-0c109e1038ad', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9372, 8, 6, 'AccommodationPrice', '2026-11-01', 118.840000, 'ARIMA+LSTM', '2026-05-29 14:36:05.59056', 'a88df4c4-a18e-4553-8a56-fe0540027928', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9373, 9, 6, 'TouristCount', '2026-06-01', 111819.600000, 'ARIMA+LSTM', '2026-05-29 14:36:11.349895', 'ed5fb330-8903-46e6-b702-a11794ffc8b5', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9374, 9, 6, 'TouristCount', '2026-07-01', 125972.090000, 'ARIMA+LSTM', '2026-05-29 14:36:11.352776', '30f8bc22-2f69-49bc-9b08-c704aee572a3', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9375, 9, 6, 'TouristCount', '2026-08-01', 121897.280000, 'ARIMA+LSTM', '2026-05-29 14:36:11.353609', '3d474cb2-9bf4-4668-875d-b042650ffbe6', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9376, 9, 6, 'TouristCount', '2026-09-01', 112079.790000, 'ARIMA+LSTM', '2026-05-29 14:36:11.354394', '3211a08b-79e9-4c55-a471-6f8459d2962e', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9377, 9, 6, 'TouristCount', '2026-10-01', 106276.510000, 'ARIMA+LSTM', '2026-05-29 14:36:11.355159', '8ee8cf72-23e8-42c7-8e2c-f086696b0b9a', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9378, 9, 6, 'TouristCount', '2026-11-01', 110092.930000, 'ARIMA+LSTM', '2026-05-29 14:36:11.355924', '038797a4-4d21-40d0-b0af-994b32d07d33', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9379, 9, 6, 'AccommodationPrice', '2026-06-01', 126.540000, 'ARIMA+LSTM', '2026-05-29 14:36:16.473562', 'b7f5a443-274b-42cb-ad76-f1d3e0bfed48', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9380, 9, 6, 'AccommodationPrice', '2026-07-01', 159.940000, 'ARIMA+LSTM', '2026-05-29 14:36:16.47612', 'f6786916-7be3-4a5a-8c6f-12a5875b4976', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9381, 9, 6, 'AccommodationPrice', '2026-08-01', 162.020000, 'ARIMA+LSTM', '2026-05-29 14:36:16.476741', 'cc4f3ce4-7e08-4974-9e82-144197fe04af', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9382, 9, 6, 'AccommodationPrice', '2026-09-01', 131.400000, 'ARIMA+LSTM', '2026-05-29 14:36:16.477249', '6470d73c-2e20-41c3-8ebd-aaf6adf7bbb6', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9383, 9, 6, 'AccommodationPrice', '2026-10-01', 106.140000, 'ARIMA+LSTM', '2026-05-29 14:36:16.477733', 'e374b26f-73a7-45ab-971b-7355e24d3f7c', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9384, 9, 6, 'AccommodationPrice', '2026-11-01', 99.020000, 'ARIMA+LSTM', '2026-05-29 14:36:16.478214', '4083683b-eab1-4b6a-99aa-46c9ec1b81eb', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9385, 10, 6, 'TouristCount', '2026-06-01', 103187.460000, 'ARIMA+LSTM', '2026-05-29 14:36:21.468331', '2263326a-7093-4cee-bbc4-250b7aa3ff2e', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9386, 10, 6, 'TouristCount', '2026-07-01', 108632.370000, 'ARIMA+LSTM', '2026-05-29 14:36:21.469261', '628ffd95-596d-42fc-979a-8921bd7663c8', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9387, 10, 6, 'TouristCount', '2026-08-01', 79925.280000, 'ARIMA+LSTM', '2026-05-29 14:36:21.469925', '73ed5cda-bdac-4e55-abc8-4f4d29138a38', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9388, 10, 6, 'TouristCount', '2026-09-01', 71318.430000, 'ARIMA+LSTM', '2026-05-29 14:36:21.470463', '93b4c291-1257-4d21-9489-fa8d36762d65', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9389, 10, 6, 'TouristCount', '2026-10-01', 66144.630000, 'ARIMA+LSTM', '2026-05-29 14:36:21.47099', 'b4d23d8b-3183-4524-9d93-5914826c3c7d', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9390, 10, 6, 'TouristCount', '2026-11-01', 79687.840000, 'ARIMA+LSTM', '2026-05-29 14:36:21.471517', 'd1c00905-ddac-408f-a7ab-6cacc3ae4ee6', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9391, 10, 6, 'AccommodationPrice', '2026-06-01', 141.470000, 'ARIMA+LSTM', '2026-05-29 14:36:26.447747', 'c15b5900-4786-4330-97b0-da0a72b8ae09', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9392, 10, 6, 'AccommodationPrice', '2026-07-01', 148.150000, 'ARIMA+LSTM', '2026-05-29 14:36:26.450511', '06ade16f-162f-456a-b867-4fa6d4d3a8d3', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9393, 10, 6, 'AccommodationPrice', '2026-08-01', 160.510000, 'ARIMA+LSTM', '2026-05-29 14:36:26.451301', '901e328a-9e11-46de-8bc1-44141fac2c84', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9394, 10, 6, 'AccommodationPrice', '2026-09-01', 136.590000, 'ARIMA+LSTM', '2026-05-29 14:36:26.45205', '484ce2ae-5ab1-43f1-aab1-9affc0fd4ff5', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9395, 10, 6, 'AccommodationPrice', '2026-10-01', 127.510000, 'ARIMA+LSTM', '2026-05-29 14:36:26.452812', 'd2605aa8-24ce-436a-a2d1-f3ed66506f3f', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9396, 10, 6, 'AccommodationPrice', '2026-11-01', 117.070000, 'ARIMA+LSTM', '2026-05-29 14:36:26.453559', '1c91c26e-0275-4f33-81d0-7b3f7acf56f4', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9969, 6, 2, 'AccommodationPrice', '2026-08-01', 137.110000, 'ARIMA+LSTM', '2026-05-29 16:08:26.783131', 'c9e8ac76-c1aa-4f0d-86b7-844852c7ec4f', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9970, 6, 2, 'AccommodationPrice', '2026-09-01', 116.360000, 'ARIMA+LSTM', '2026-05-29 16:08:26.783723', '476e8ae4-658e-413f-8d4b-62008ebbdf78', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9971, 6, 2, 'AccommodationPrice', '2026-10-01', 122.750000, 'ARIMA+LSTM', '2026-05-29 16:08:26.784277', '74b4556a-c7ab-440c-a3f7-ea86108779ac', false);
INSERT INTO public.forecasts OVERRIDING SYSTEM VALUE VALUES (9972, 6, 2, 'AccommodationPrice', '2026-11-01', 114.530000, 'ARIMA+LSTM', '2026-05-29 16:08:26.784808', 'bf58bd78-a698-44c3-a1ae-ecae37b5836d', false);


--
-- TOC entry 4982 (class 0 OID 425781)
-- Dependencies: 227
-- Data for Name: inflation_rates; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (1, 2, 2.7742, '2024-01-01', 'ebce2a39-7f7d-41e3-9939-b9559362724f', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (2, 2, 3.5324, '2023-01-01', '65f93547-8fd9-4f29-84af-b896f7ccede6', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (3, 2, 8.3906, '2022-01-01', '3747e43e-6850-4710-8b1e-1dd097b314d0', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (4, 2, 3.0931, '2021-01-01', 'bde73c07-7443-45fd-be14-c8669ff3b2a9', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (5, 6, 3.1453, '2024-01-01', 'e8870a8a-6a36-473c-960c-f51e875aa762', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (6, 6, 5.5178, '2023-01-01', '6c3284b3-9b73-4eea-910c-87ce5da25242', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (7, 6, 5.7641, '2022-01-01', '1f2878a0-f5ef-4390-8fdf-7cf23ef9d271', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (8, 6, 3.4839, '2021-01-01', '5ea41d1b-8fd7-4a2a-a0fd-cb1e465d782c', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (9, 4, 8.4349, '2024-01-01', '5a640492-e918-47d2-8b03-fb605fd56a8e', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (10, 4, 5.8657, '2023-01-01', 'dbf295a0-6fef-4ba0-8d69-a5780f1658a8', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (11, 4, 13.7437, '2022-01-01', '607d8405-b74c-4673-916b-d57f2a45c60f', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (12, 4, 6.6945, '2021-01-01', 'c5af79ed-49ef-41aa-abf8-a4250aa838b5', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (13, 1, 58.5065, '2024-01-01', 'f3c8a9c6-9db4-4f0c-b072-e41817af3aa4', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (14, 1, 53.8594, '2023-01-01', 'e762109c-bf3b-4693-ab1b-8ae65a396b83', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (15, 1, 72.3088, '2022-01-01', '42a68e7e-e0c4-4b5f-a497-ae73c2f56e08', false);
INSERT INTO public.inflation_rates OVERRIDING SYSTEM VALUE VALUES (16, 1, 19.5965, '2021-01-01', '48b15ac9-ced9-4a95-9c47-27acb1c9679c', false);


--
-- TOC entry 4972 (class 0 OID 425726)
-- Dependencies: 217
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4984 (class 0 OID 425792)
-- Dependencies: 229
-- Data for Name: tourism_metrics; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (1, 1, 45384, 105.00, 'EUR', '2024-05-01', '2a7173fb-35a3-4f41-b489-a6219802877a', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (2, 1, 296678, 288.00, 'EUR', '2024-06-01', '2c046ca2-4ca6-48bc-b9a0-de96ff51d011', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (3, 1, 193955, 241.00, 'EUR', '2024-07-01', '356c1cc0-4ee6-45e9-8b66-f58a27268472', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (4, 1, 191838, 271.00, 'EUR', '2024-08-01', 'fe74e913-73da-493d-a754-7c3162efe763', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (5, 1, 64993, 129.00, 'EUR', '2024-09-01', 'dac31f56-82bb-45c6-8f4d-c71f785b83e5', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (6, 1, 53859, 94.00, 'EUR', '2024-10-01', 'df1d76b1-29d7-490a-8cfe-471cfa1b01e7', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (7, 1, 72685, 125.00, 'EUR', '2024-11-01', 'ad239613-58b4-4d3b-adec-5066e9b11ead', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (8, 1, 92161, 158.00, 'EUR', '2024-12-01', 'f8a392c6-ac8f-4c19-9e6f-64d989661d99', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (9, 1, 93540, 180.00, 'EUR', '2025-01-01', 'b47217c4-2422-4012-b43d-d1c0e4cf3501', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (10, 1, 114374, 168.00, 'EUR', '2025-02-01', '6e230ddd-3073-4846-90e6-7171c31f7bc7', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (11, 1, 81705, 119.00, 'EUR', '2025-03-01', '45369fac-1234-45a6-a043-abb687e6a68b', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (12, 1, 87194, 125.00, 'EUR', '2025-04-01', 'cfd5babd-3463-4f9e-911d-a9ba8bab90bb', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (13, 1, 41698, 125.00, 'EUR', '2025-05-01', 'ab52032c-0552-4b55-b3b3-50dabb397bc3', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (14, 1, 282170, 179.00, 'EUR', '2025-06-01', 'fbdd9d20-7bac-4778-a50b-2a4fec202901', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (15, 1, 219184, 184.00, 'EUR', '2025-07-01', '2158b856-ce03-48d3-96ef-0de4576f0f42', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (16, 1, 286338, 233.00, 'EUR', '2025-08-01', '96e1f2a0-5334-4568-87f4-d0665d6f6fd3', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (17, 1, 45147, 123.00, 'EUR', '2025-09-01', 'b5ea4ef0-7972-40a3-b060-4ba0a8848058', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (18, 1, 56622, 109.00, 'EUR', '2025-10-01', '04c0d7cd-eb5e-4fec-90ba-0d3a6fba3c87', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (19, 1, 53505, 123.00, 'EUR', '2025-11-01', '352d3bc7-2638-4d09-8038-6f320d2552e5', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (20, 1, 104507, 154.00, 'EUR', '2025-12-01', 'a393c78c-7e3c-4fa2-a7e4-467d2b0973ec', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (21, 1, 96733, 182.00, 'EUR', '2026-01-01', '3d089aae-b8fe-4710-bcb1-da4e8b1116e6', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (22, 1, 87527, 132.00, 'EUR', '2026-02-01', '951fc3fc-19d0-408e-bc7a-6e2f677bf015', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (23, 1, 42788, 89.00, 'EUR', '2026-03-01', '04fb91ef-2084-47d9-a19d-48a90c381997', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (24, 1, 51825, 82.00, 'EUR', '2026-04-01', '0e1c5ced-5114-4cab-aff3-66087409eb15', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (25, 1, 82922, 115.00, 'EUR', '2026-05-01', '4abac9f4-c63b-46f5-a9d0-ede0ad38e1ca', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (26, 2, 62962, 101.00, 'EUR', '2024-05-01', '4a3c28ef-97a8-41b6-a2e5-bb7ba5235da5', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (27, 2, 175586, 266.00, 'EUR', '2024-06-01', '48f063b0-46e3-411e-be7c-edab62373bf4', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (28, 2, 285779, 182.00, 'EUR', '2024-07-01', '243e6d7a-52d6-475a-8440-beae06b36e1e', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (29, 2, 158694, 198.00, 'EUR', '2024-08-01', '8c19b899-09ad-4aac-b0d5-fc1cb1eb3f78', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (30, 2, 52947, 102.00, 'EUR', '2024-09-01', '42ec6b31-87d1-4847-9642-846e813adb31', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (31, 2, 48802, 85.00, 'EUR', '2024-10-01', '67dbdc28-89b9-4d85-9b8a-e6f83562823f', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (32, 2, 56437, 91.00, 'EUR', '2024-11-01', '2ca6f4a6-51c1-432e-8c0e-ba1384a66d74', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (33, 2, 88744, 154.00, 'EUR', '2024-12-01', '5bf16bb4-2bd1-49c9-8619-c97ff691bcb8', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (34, 2, 101731, 167.00, 'EUR', '2025-01-01', '76348c35-79c4-4f69-86e3-e67d8f635e9f', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (35, 2, 104501, 128.00, 'EUR', '2025-02-01', '49173d96-810c-409f-be90-4dcfd8420b06', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (36, 2, 68233, 129.00, 'EUR', '2025-03-01', '13e7ccc0-7974-41e2-ba30-25f51d4c9ec3', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (37, 2, 53102, 124.00, 'EUR', '2025-04-01', 'ee31faca-159c-47a3-a464-be14d4057bae', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (38, 2, 47871, 124.00, 'EUR', '2025-05-01', '71c8816f-c21e-4caa-8bba-c88af5ff1a5a', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (39, 2, 294846, 201.00, 'EUR', '2025-06-01', 'c67a3c08-0eac-4822-8704-7b60a8409e6c', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (40, 2, 278683, 231.00, 'EUR', '2025-07-01', '3c4634e6-66a5-4963-9791-ddf8cfabf4f1', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (41, 2, 215833, 266.00, 'EUR', '2025-08-01', '649f59ae-5a2a-46a5-81b1-62066d3813eb', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (42, 2, 85417, 107.00, 'EUR', '2025-09-01', '8712ee21-0b2a-45d9-85d5-3ec7cf8aa3ba', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (43, 2, 46471, 129.00, 'EUR', '2025-10-01', 'c5062f0b-47a0-479d-a424-dc911d061bc9', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (44, 2, 77409, 105.00, 'EUR', '2025-11-01', '2c92e0d7-a7ee-4400-85c3-fe436d6b14b6', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (45, 2, 103543, 170.00, 'EUR', '2025-12-01', 'f2137bed-68af-4abb-aed9-a0831a87f740', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (46, 2, 109376, 185.00, 'EUR', '2026-01-01', '75e60ef1-ddb4-4115-be8e-6795b69fae6c', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (47, 2, 93451, 153.00, 'EUR', '2026-02-01', '2e234682-6cdf-44d2-a539-6efb2cc54344', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (48, 2, 72289, 119.00, 'EUR', '2026-03-01', '16444ad3-43ee-4fc8-8843-91646e26f3fd', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (49, 2, 78863, 122.00, 'EUR', '2026-04-01', '6c17fec3-e5ea-47be-ad72-438f5e3b70c8', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (50, 2, 63296, 96.00, 'EUR', '2026-05-01', 'd309b018-763b-4309-bdf8-6436462fccb2', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (51, 3, 77270, 114.00, 'EUR', '2024-05-01', 'f2e882f6-08eb-4702-a8b4-15e435228bf0', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (52, 3, 155913, 222.00, 'EUR', '2024-06-01', 'eca6ea0e-ae96-4bed-81d5-fa1fead35188', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (53, 3, 160922, 247.00, 'EUR', '2024-07-01', '7ce14f7a-d307-45a8-9c96-fd5e8ee94d40', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (54, 3, 175916, 174.00, 'EUR', '2024-08-01', 'ace1701d-ca44-4430-b1bc-3598d4c25595', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (55, 3, 79751, 116.00, 'EUR', '2024-09-01', 'db627a75-cdd2-4e60-9347-31d65081e87d', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (56, 3, 74307, 90.00, 'EUR', '2024-10-01', 'bc07f952-a634-42cb-b70a-eb95a6b67ec1', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (57, 3, 78472, 122.00, 'EUR', '2024-11-01', '0bb2a904-a8a1-4d99-8d00-dc7d9a540632', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (58, 3, 105569, 185.00, 'EUR', '2024-12-01', 'ad1a3318-e73a-47cc-bd7a-f57ef1c71f12', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (59, 3, 94509, 174.00, 'EUR', '2025-01-01', '1a5a341c-c01a-4b4e-ad51-8acd46f4c767', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (60, 3, 87418, 125.00, 'EUR', '2025-02-01', '161871ce-9306-47c7-b501-611e30c6a859', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (61, 3, 58650, 105.00, 'EUR', '2025-03-01', '0549518d-debe-44bd-910f-c4a46640fdaf', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (62, 3, 87275, 110.00, 'EUR', '2025-04-01', 'cba35ebe-97c8-4e70-96bd-c4c032bac483', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (63, 3, 40286, 100.00, 'EUR', '2025-05-01', 'eb110d2c-d9fa-4340-aae6-1e1f575712ec', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (64, 3, 175911, 209.00, 'EUR', '2025-06-01', '247a0cf6-188a-49cd-805d-fae9581657d6', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (65, 3, 267896, 216.00, 'EUR', '2025-07-01', '274fa609-4a1b-426e-8fce-29f6b5613732', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (66, 3, 195554, 292.00, 'EUR', '2025-08-01', '4f42c6c5-b632-401c-8444-20500588aa75', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (67, 3, 65500, 122.00, 'EUR', '2025-09-01', '84c05894-45bb-4bd7-bbb6-b337ea2d8fcd', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (68, 3, 47878, 124.00, 'EUR', '2025-10-01', 'cbd95950-d249-40e6-9913-aa83487c1c1a', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (69, 3, 43777, 117.00, 'EUR', '2025-11-01', 'fe6940a9-dbdc-49a7-986d-a5b912a1d849', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (70, 3, 104481, 187.00, 'EUR', '2025-12-01', '61045e20-7607-490c-984d-a31aed363355', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (71, 3, 92326, 172.00, 'EUR', '2026-01-01', 'd589a4d2-147b-421b-94ee-d8dc7cfeefed', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (72, 3, 92613, 155.00, 'EUR', '2026-02-01', 'fd2efcf9-b03d-4d9b-9f99-1cb814a703ae', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (73, 3, 44504, 105.00, 'EUR', '2026-03-01', '9da2a0ce-1312-4f4c-aade-d80180f1a518', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (74, 3, 67348, 111.00, 'EUR', '2026-04-01', '6668ec8e-74c1-41f7-beb9-e0baa8399f4b', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (75, 3, 62152, 125.00, 'EUR', '2026-05-01', 'a28d6b33-070f-4abc-b21b-e699bed986e0', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (76, 4, 77517, 100.00, 'EUR', '2024-05-01', 'fafd8b59-946e-4263-83a0-3930807853e4', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (77, 4, 261116, 259.00, 'EUR', '2024-06-01', '483cf7e2-309d-4ae3-8308-1f9d1415190c', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (78, 4, 165827, 186.00, 'EUR', '2024-07-01', 'c86c9929-6b3c-4ebd-8ddf-9d8555c8fb26', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (79, 4, 187756, 223.00, 'EUR', '2024-08-01', '35d94dde-dcf4-4d14-b0bc-4a0f5b37ac37', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (80, 4, 45091, 97.00, 'EUR', '2024-09-01', '9f028d14-fef1-4663-a7cc-71318b192b25', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (81, 4, 87010, 120.00, 'EUR', '2024-10-01', '61d2efe3-e4ee-476b-94a6-14ad263aa758', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (82, 4, 44761, 115.00, 'EUR', '2024-11-01', '3e44cc00-a739-42cd-a368-bdfc1f656114', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (83, 4, 93714, 125.00, 'EUR', '2024-12-01', '989c1c98-380e-4cee-8afe-ef0acba16cdf', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (84, 4, 89817, 190.00, 'EUR', '2025-01-01', 'f77aa005-358e-4e71-996d-3f6fff07e44d', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (85, 4, 119891, 176.00, 'EUR', '2025-02-01', 'e97fdd72-b4c9-46aa-af5c-82458dff4ace', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (86, 4, 43584, 109.00, 'EUR', '2025-03-01', 'a8590854-7f0b-4896-a7ad-ab7bb324c147', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (87, 4, 41812, 107.00, 'EUR', '2025-04-01', '66eb318c-626d-4101-8ad6-649daf0c6372', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (88, 4, 83244, 111.00, 'EUR', '2025-05-01', 'c4392185-f670-4b97-b116-8c0afc007400', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (89, 4, 176745, 244.00, 'EUR', '2025-06-01', '89bcec88-6e09-427b-9c5f-d87aab7e705d', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (92, 4, 63475, 107.00, 'EUR', '2025-09-01', '7c9d3f1a-70b0-46d3-babc-78dbede86e0f', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (95, 4, 92345, 140.00, 'EUR', '2025-12-01', '365df9f7-949b-4efa-863f-70b5ef36b154', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (98, 4, 74867, 119.00, 'EUR', '2026-03-01', '21449fee-f3a3-4a9b-9010-0a830e7f519d', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (101, 5, 87526, 100.00, 'EUR', '2024-05-01', '34124ae0-7168-49fc-a150-e572efec422f', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (104, 5, 181953, 165.00, 'EUR', '2024-08-01', '0046c982-b105-4dc8-8414-c66a20e90fb4', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (107, 5, 89715, 104.00, 'EUR', '2024-11-01', '019f4a5f-7679-490a-b8ed-f6656c514a82', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (110, 5, 109425, 195.00, 'EUR', '2025-02-01', '520bd052-b80e-4ee5-9d75-82a7627dd4b8', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (113, 5, 73018, 97.00, 'EUR', '2025-05-01', 'fecf4b67-9c4d-4431-bede-6e16e9104cc0', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (116, 5, 229412, 210.00, 'EUR', '2025-08-01', '62c720f1-4895-45cc-9e0b-403330328240', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (119, 5, 63521, 86.00, 'EUR', '2025-11-01', 'a8ae7663-c399-4599-8473-959a49880d2d', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (122, 5, 96712, 141.00, 'EUR', '2026-02-01', '90ae6eed-7fdc-4710-8206-4ec61edc27ed', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (125, 5, 89733, 129.00, 'EUR', '2026-05-01', '99f3f394-48f6-4017-8b26-0bdbd311396d', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (128, 6, 264258, 204.00, 'EUR', '2024-07-01', 'c7c42c3b-dc96-4d67-b1d4-8ecc36d4b262', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (131, 6, 73203, 122.00, 'EUR', '2024-10-01', '445b10fe-b441-46ec-8477-431081d77d54', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (134, 6, 80720, 189.00, 'EUR', '2025-01-01', '0ac98290-de5e-480c-9537-b01ef7b4a489', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (137, 6, 80583, 90.00, 'EUR', '2025-04-01', 'a4d4fb45-c6c9-472f-a909-911c318034bb', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (140, 6, 273856, 265.00, 'EUR', '2025-07-01', 'a41c3134-3f9c-4c30-a73e-7b952051cccb', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (143, 6, 79971, 105.00, 'EUR', '2025-10-01', '813805b2-540e-4dd3-963e-3b087d1d06e5', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (146, 6, 88460, 121.00, 'EUR', '2026-01-01', '54c3e78f-8497-48ba-9341-efc1208ec669', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (149, 6, 42217, 122.00, 'EUR', '2026-04-01', 'bc586007-e35d-4152-b89b-f06e0e2dff56', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (152, 7, 245207, 212.00, 'EUR', '2024-06-01', '68c895f8-b293-4d6e-ae4c-1b75ea9b5072', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (155, 7, 64290, 128.00, 'EUR', '2024-09-01', 'a114c776-8123-4781-9110-39143f38e72d', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (158, 7, 106726, 160.00, 'EUR', '2024-12-01', '0a407151-b4ff-4a19-b072-80b36fe95953', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (161, 7, 51672, 92.00, 'EUR', '2025-03-01', '80080395-320b-44b6-b25a-c58fe334d632', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (164, 7, 180885, 230.00, 'EUR', '2025-06-01', '35c8317d-5d6c-4e70-add4-53d3f9b3eef2', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (167, 7, 67669, 92.00, 'EUR', '2025-09-01', '01ab2f50-b15d-4056-a37c-663b7c07460f', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (170, 7, 91693, 135.00, 'EUR', '2025-12-01', '2e100bd1-3df3-4413-8122-09eb1d595ce1', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (173, 7, 44318, 126.00, 'EUR', '2026-03-01', '09e4da24-fe7f-4b15-804f-34819dec9b5d', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (200, 8, 79356, 109.00, 'EUR', '2026-05-01', '61adc8a8-97a4-4810-85eb-926fc62ad49b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (251, 11, 88567, 129.00, 'EUR', '2024-05-01', '91931b4e-31a2-4810-992e-b925f25439a7', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (254, 11, 204312, 180.00, 'EUR', '2024-08-01', '8ea8f7b1-6ad0-45a5-85f3-0877dc435b8c', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (257, 11, 47639, 127.00, 'EUR', '2024-11-01', '00fd690a-c86a-4e39-9fbe-c5b2df28c774', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (260, 11, 91312, 135.00, 'EUR', '2025-02-01', '266dad2b-76b6-4515-a776-474e832d003e', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (263, 11, 72504, 108.00, 'EUR', '2025-05-01', '114bf309-6d76-49d7-b746-7140098d6f96', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (266, 11, 190237, 159.00, 'EUR', '2025-08-01', '90933017-3351-4429-a1eb-be0bc41a407a', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (269, 11, 71108, 87.00, 'EUR', '2025-11-01', '66bab18c-a4b0-4a86-9f6b-2dfe2ae44f19', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (272, 11, 84674, 148.00, 'EUR', '2026-02-01', '10110383-5dcd-40cb-b98a-8e49e5512121', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (275, 11, 40767, 84.00, 'EUR', '2026-05-01', 'a89bd75b-cfd2-4309-b9e0-e9ed291a93ae', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (278, 12, 204179, 204.00, 'EUR', '2024-07-01', '66f019b1-a765-4864-aba9-b74a8df4d7b9', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (281, 12, 64201, 85.00, 'EUR', '2024-10-01', '0234a44b-f007-451d-955e-31cac1ec39fd', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (284, 12, 97858, 199.00, 'EUR', '2025-01-01', '634fcd38-dc68-4378-85f4-420843b8eae7', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (287, 12, 60079, 90.00, 'EUR', '2025-04-01', '8a84e4d4-a415-4723-8a81-0dd3dbe41017', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (290, 12, 162152, 234.00, 'EUR', '2025-07-01', 'ee3980eb-3ac0-45ea-9c4f-7a1f88fd39ab', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (293, 12, 45516, 108.00, 'EUR', '2025-10-01', 'eec98497-1c02-40c7-ba3d-28e9f22efea8', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (296, 12, 83937, 180.00, 'EUR', '2026-01-01', 'b5b2554e-47bb-4a14-aa2a-9914113f069e', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (299, 12, 66406, 80.00, 'EUR', '2026-04-01', '4b7a6575-924a-4917-a2e5-a12f6a922470', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (302, 13, 219425, 210.00, 'EUR', '2024-06-01', '24a56673-6da3-41b3-a3ce-203028043905', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (305, 13, 78600, 90.00, 'EUR', '2024-09-01', '3b5a8ab5-5e23-4061-a5e9-95d05e150f43', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (308, 13, 98913, 120.00, 'EUR', '2024-12-01', '19c6b696-91c7-47b2-98d8-20a4165e709e', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (311, 13, 48395, 116.00, 'EUR', '2025-03-01', 'eda8e5c1-e0df-4d5b-bb92-89a0fbee4614', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (314, 13, 214687, 295.00, 'EUR', '2025-06-01', 'eb5c20fb-9ef6-4e3b-80c0-90142860cf76', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (317, 13, 86522, 116.00, 'EUR', '2025-09-01', 'af0bb4c3-1774-4070-9f93-ae0e1ed7082f', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (320, 13, 85122, 198.00, 'EUR', '2025-12-01', '33df49e3-4df8-4c01-b62f-4df0ffcafdf8', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (323, 13, 69219, 88.00, 'EUR', '2026-03-01', 'f472b768-5d67-459c-bd2a-7cf373095138', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (176, 8, 74501, 1548.00, 'EUR', '2024-05-01', '1591f8f0-dcd8-4361-8493-31a29bf4dfec', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (179, 8, 156697, 1620.00, 'EUR', '2024-08-01', 'bf5382d0-e029-452b-835f-00f8ecaeaafe', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (182, 8, 75861, 1536.00, 'EUR', '2024-11-01', '1a2a5f7a-f75e-4ffd-a649-bb15e1adc208', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (185, 8, 92521, 1333.00, 'EUR', '2025-02-01', '85e03c2f-c973-476b-9500-42e18c919e4d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (188, 8, 68235, 1706.00, 'EUR', '2025-05-01', 'fe3a51e5-7285-450d-a639-8ab9d8cb4ca0', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (191, 8, 263047, 1849.00, 'EUR', '2025-08-01', '9c1c6a32-05cd-4e79-bc89-4eb9040c4e9e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (194, 8, 53805, 1549.00, 'EUR', '2025-11-01', 'b92a58a5-5bc1-4a23-84b2-d03c9dc1dfed', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (197, 8, 89634, 1391.00, 'EUR', '2026-02-01', '91f61881-7320-417d-85a2-83137bced02b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (203, 9, 281147, 1706.00, 'EUR', '2024-07-01', '93925405-37b4-410e-a5a6-76ce4ea1be1d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (90, 4, 184468, 245.00, 'EUR', '2025-07-01', 'd76ce1a9-6c5f-4d1e-b765-625dad6e7886', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (93, 4, 46740, 82.00, 'EUR', '2025-10-01', 'fa94deef-1ffc-49ec-bb2c-d97337e711f6', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (96, 4, 101225, 171.00, 'EUR', '2026-01-01', '6169ef89-880d-4d39-b8f5-69be3ff322f2', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (99, 4, 65919, 114.00, 'EUR', '2026-04-01', 'e0deb8fb-0c37-419c-a563-85d8172bc4a1', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (102, 5, 267934, 186.00, 'EUR', '2024-06-01', 'db2a4c85-4a48-46a0-bb8c-a77993fc3f78', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (105, 5, 88757, 120.00, 'EUR', '2024-09-01', '10390e9b-2077-45df-a519-68d7b1cd1320', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (108, 5, 99627, 150.00, 'EUR', '2024-12-01', 'db8d3336-463c-4bcd-9dd1-1876926a0e1f', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (111, 5, 79850, 128.00, 'EUR', '2025-03-01', '13670efc-f073-47fc-bfaf-228f280ae6d9', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (114, 5, 259802, 172.00, 'EUR', '2025-06-01', '9a54126b-4180-4981-83ce-c0eb50f7daa5', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (117, 5, 53844, 111.00, 'EUR', '2025-09-01', '4d68098e-64cd-4e66-b48d-c511419199a1', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (120, 5, 92134, 191.00, 'EUR', '2025-12-01', '5a3320ee-8e89-4484-ad3b-163f9bf5591f', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (123, 5, 60694, 107.00, 'EUR', '2026-03-01', '86f37297-b42a-45fa-a388-d078e35350f9', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (126, 6, 44368, 117.00, 'EUR', '2024-05-01', 'ea4295e8-560b-4c26-8329-536091c74456', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (129, 6, 226978, 154.00, 'EUR', '2024-08-01', 'ac907509-7f1f-42e9-97db-2529d485d013', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (132, 6, 67042, 127.00, 'EUR', '2024-11-01', '8fa8efef-d539-48ba-a839-28e0a0c77ef4', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (135, 6, 118819, 189.00, 'EUR', '2025-02-01', '1b3c9c67-e55a-4e45-9f57-b9c0b8ceebc2', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (138, 6, 62750, 121.00, 'EUR', '2025-05-01', '40c54f09-a3b4-4583-bd00-47277d375b1e', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (141, 6, 209098, 257.00, 'EUR', '2025-08-01', '775706dd-5ca3-41be-af40-b7c88aea7b99', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (144, 6, 58378, 86.00, 'EUR', '2025-11-01', '4ee9de2b-3493-4208-b511-d515007c213c', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (147, 6, 110175, 143.00, 'EUR', '2026-02-01', '2a53b0ca-054e-45bb-8f44-11b4e94dff12', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (150, 6, 47566, 105.00, 'EUR', '2026-05-01', '3dd6782a-6fc0-4cf8-b9cb-38344aaabf25', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (153, 7, 217404, 163.00, 'EUR', '2024-07-01', '0177fb12-fdce-4c83-ab4a-49b2f6c3e58f', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (156, 7, 46448, 104.00, 'EUR', '2024-10-01', '95bfd520-5db8-4f44-a175-323c3b184a7c', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (159, 7, 101203, 167.00, 'EUR', '2025-01-01', '8ce4b44b-5527-4919-991d-ddbe6bc146eb', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (162, 7, 74026, 101.00, 'EUR', '2025-04-01', '8736a343-fa1d-4931-bfc9-a5fafb4132bf', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (165, 7, 193465, 254.00, 'EUR', '2025-07-01', 'd33d376f-766a-44fd-9a1f-74b28e25ea27', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (168, 7, 51493, 83.00, 'EUR', '2025-10-01', '6db90a66-9fbd-45e9-82b8-b8c036b8a0cf', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (171, 7, 109862, 154.00, 'EUR', '2026-01-01', 'd5ce6c2c-a2d8-40a3-bf21-45760d21b568', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (174, 7, 82896, 118.00, 'EUR', '2026-04-01', '2f607b53-f38a-45be-b6dc-f6617c91466f', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (225, 9, 79164, 100.00, 'EUR', '2026-05-01', '221cb8b8-f102-440c-ab4a-f763a9fb731c', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (252, 11, 286802, 183.00, 'EUR', '2024-06-01', '9628a568-e06f-437c-9c7c-c8fcc7b29fbf', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (255, 11, 45997, 129.00, 'EUR', '2024-09-01', '4022248f-b0ea-477d-b605-f581dde34c89', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (258, 11, 117937, 183.00, 'EUR', '2024-12-01', '51b58c9c-a119-4db5-ba42-7320a6e066f1', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (261, 11, 57680, 110.00, 'EUR', '2025-03-01', 'ab6cac15-7ec3-453b-8c47-a1f673f76ae2', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (264, 11, 172913, 169.00, 'EUR', '2025-06-01', '1f1801f5-b30b-403d-bde5-2528cde2c17b', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (267, 11, 87128, 86.00, 'EUR', '2025-09-01', '86a8ad49-974f-4bbb-8bf4-2815eb13b0f9', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (270, 11, 85782, 138.00, 'EUR', '2025-12-01', 'b39d0039-8304-43de-8a83-39e9ca9e57c0', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (273, 11, 45466, 129.00, 'EUR', '2026-03-01', 'e1cbdf09-a165-4cb0-9d24-aa1bf47a21bd', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (276, 12, 43615, 106.00, 'EUR', '2024-05-01', '491d42c0-7d00-42b0-8d03-9ce8d349cd17', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (279, 12, 179697, 159.00, 'EUR', '2024-08-01', 'b8b514c5-b219-48cc-9c61-88cfb780824c', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (282, 12, 40058, 91.00, 'EUR', '2024-11-01', '9ca99f7e-a144-4fb4-ac36-6369c04357f6', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (285, 12, 94418, 198.00, 'EUR', '2025-02-01', '63b55d52-80f3-40fe-9c53-293d28da5421', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (288, 12, 78097, 80.00, 'EUR', '2025-05-01', '4a77dfaa-c219-49f3-b733-fa26a7314454', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (291, 12, 230297, 281.00, 'EUR', '2025-08-01', 'dc40b286-7341-4756-a038-0aa051a6fa59', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (294, 12, 45160, 88.00, 'EUR', '2025-11-01', 'a6338ba2-e40d-4bc8-858e-e59992d062ab', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (297, 12, 98332, 167.00, 'EUR', '2026-02-01', 'e8dcdbf7-f64f-4b2a-ac7d-3a540d8edc67', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (300, 12, 68302, 95.00, 'EUR', '2026-05-01', 'd835943f-26f1-4555-91a5-a4ced4b81f6d', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (303, 13, 162734, 249.00, 'EUR', '2024-07-01', '7f070b6f-46b8-4e95-bfa4-4de61d891c7b', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (306, 13, 73738, 87.00, 'EUR', '2024-10-01', 'a21e71d7-84e8-4948-a608-d157152083e9', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (309, 13, 93274, 127.00, 'EUR', '2025-01-01', 'aacf01f4-d425-4047-8d21-7cb7e9b3a186', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (312, 13, 79246, 116.00, 'EUR', '2025-04-01', 'f4a0c0f2-201d-43a5-9f0c-e4f5d038811a', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (315, 13, 169237, 225.00, 'EUR', '2025-07-01', 'f5dd8800-5fc9-4ee1-9f29-91668a4df6a9', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (318, 13, 40403, 92.00, 'EUR', '2025-10-01', '3641498e-f7da-4fa8-ba75-a195b685f025', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (321, 13, 88984, 161.00, 'EUR', '2026-01-01', 'ca72aed0-425a-4245-a190-7d752d2daa79', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (324, 13, 66185, 105.00, 'EUR', '2026-04-01', '9c293dd2-7dd7-4b64-9905-e846e22bb31d', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (177, 8, 281954, 1875.00, 'EUR', '2024-06-01', '5bb6478c-3f83-405a-b567-e76b5acc9c1e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (180, 8, 44142, 1620.00, 'EUR', '2024-09-01', '9a0a5e02-e905-47d7-98d9-e2e07bef008b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (183, 8, 90860, 1466.00, 'EUR', '2024-12-01', 'b20d762c-331b-4032-bdfb-6563dc5fa51e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (186, 8, 60465, 1419.00, 'EUR', '2025-03-01', '629b8a85-9096-4927-b763-9cba87198342', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (189, 8, 172876, 2272.00, 'EUR', '2025-06-01', '14993d6b-30d4-4d4f-9c09-514bab9e067b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (192, 8, 59123, 1775.00, 'EUR', '2025-09-01', 'ec14e721-877a-4e9e-89c9-8438ef995b66', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (195, 8, 100838, 1460.00, 'EUR', '2025-12-01', '11bac838-5890-436c-ba16-17105d6bb9dc', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (198, 8, 51294, 1475.00, 'EUR', '2026-03-01', '67a09b5d-533c-4682-95b7-a114e2c15215', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (201, 9, 52000, 1495.00, 'EUR', '2024-05-01', '59684d5d-6d34-4008-bc7c-54b31fd50f83', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (91, 4, 275572, 239.00, 'EUR', '2025-08-01', 'a327414d-2f4b-4635-8b63-40c5ed0c83d9', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (94, 4, 83213, 127.00, 'EUR', '2025-11-01', '2495a311-69e4-4161-b782-bd30a59e2cd5', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (97, 4, 106819, 166.00, 'EUR', '2026-02-01', 'e2d29a1b-9859-42d2-a160-8cab35072988', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (100, 4, 67139, 114.00, 'EUR', '2026-05-01', '1088f48e-72df-43b0-8883-f20b2c314a14', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (103, 5, 187638, 220.00, 'EUR', '2024-07-01', '967e1b1d-ec37-49f2-a025-6b1a80a972ea', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (106, 5, 41078, 104.00, 'EUR', '2024-10-01', 'fb0f15de-5595-4b9c-bf52-aebb6ccddeb9', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (109, 5, 90761, 168.00, 'EUR', '2025-01-01', '74b70761-c367-48c0-8692-51cacb39cf99', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (112, 5, 56159, 85.00, 'EUR', '2025-04-01', '25427a64-bb89-45a6-90e3-e8298bd5a51f', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (115, 5, 248646, 237.00, 'EUR', '2025-07-01', '80537811-9294-4fa7-9dde-d4ca248d65c8', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (118, 5, 66012, 96.00, 'EUR', '2025-10-01', '4e6a2a95-bd7f-4895-bb5a-c3ca49d8cea8', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (121, 5, 93727, 162.00, 'EUR', '2026-01-01', 'a4b00a89-04ea-4872-86cf-6af160a796fe', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (124, 5, 43885, 99.00, 'EUR', '2026-04-01', 'c49d1621-4eb7-47d1-85ec-0c328fde9a5d', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (127, 6, 237464, 293.00, 'EUR', '2024-06-01', '189a1e1f-be66-4d44-ab24-d73a580631df', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (130, 6, 78287, 121.00, 'EUR', '2024-09-01', '3f6d551d-37f3-452f-ac4b-d849e3c86446', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (133, 6, 113014, 155.00, 'EUR', '2024-12-01', 'dfe63e2a-f4cb-487d-9506-81afef591501', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (136, 6, 49138, 123.00, 'EUR', '2025-03-01', '2a904ac1-4935-4658-8bea-5999c33f96f6', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (139, 6, 291842, 287.00, 'EUR', '2025-06-01', '679007e7-1710-419f-8e20-fda2d16ccae9', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (142, 6, 55466, 93.00, 'EUR', '2025-09-01', 'f1d723f9-5c09-4350-a743-cbd8d0bd4fc4', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (145, 6, 118605, 182.00, 'EUR', '2025-12-01', '0e468d41-976e-4db1-8af2-3085fe239e93', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (148, 6, 59245, 117.00, 'EUR', '2026-03-01', '77073160-7fff-40ac-a794-deddf34ad5bf', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (151, 7, 70759, 121.00, 'EUR', '2024-05-01', 'e0a3a3fc-5bcb-4221-9aea-6a8766f94563', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (154, 7, 277584, 190.00, 'EUR', '2024-08-01', '9442d64c-a4a0-48f0-ae65-4ce5175bee01', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (157, 7, 41344, 86.00, 'EUR', '2024-11-01', 'defa9742-559b-40d2-89bb-3e76ed577f6c', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (160, 7, 109057, 181.00, 'EUR', '2025-02-01', 'b5103118-0997-4a24-95cb-791d5ae54c40', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (163, 7, 49365, 99.00, 'EUR', '2025-05-01', '96bd8381-2432-4536-ac80-0e44722a1798', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (166, 7, 214048, 190.00, 'EUR', '2025-08-01', '751f0d66-3e3e-4ccb-a211-75374a3c6eaa', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (169, 7, 74130, 113.00, 'EUR', '2025-11-01', '226c3c00-8e5c-4033-830d-703d920354ec', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (172, 7, 111567, 151.00, 'EUR', '2026-02-01', '0f6f06e1-07b5-476d-99a6-d40f58144185', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (175, 7, 87678, 101.00, 'EUR', '2026-05-01', '8a857b8c-4efc-4a14-9c0a-2125830bc745', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (250, 10, 69219, 116.00, 'EUR', '2026-05-01', '0f8244f1-bb62-46de-8950-1c5d7f8165bf', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (253, 11, 270013, 195.00, 'EUR', '2024-07-01', '23316f14-ac5e-47d1-b980-51185b4eb50f', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (256, 11, 71104, 96.00, 'EUR', '2024-10-01', '4b41d167-1c92-4802-94d5-6dd21ca8af85', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (259, 11, 107773, 173.00, 'EUR', '2025-01-01', '84c9f0f3-eb72-4139-bcf6-ffab04f2074a', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (262, 11, 80005, 97.00, 'EUR', '2025-04-01', '7a76ac17-9041-44be-999d-d9bfd0ecdaa1', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (265, 11, 180914, 198.00, 'EUR', '2025-07-01', '28dd821c-6ce0-4883-8b7f-e5dab5a68abc', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (268, 11, 68488, 114.00, 'EUR', '2025-10-01', 'ad4d192b-c2a9-463e-9964-138636ae77be', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (271, 11, 98184, 122.00, 'EUR', '2026-01-01', '18c33a4c-bad7-4be8-a7f7-f67870912776', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (274, 11, 47901, 98.00, 'EUR', '2026-04-01', '51a67a4c-ea6f-4cf7-8cbb-725a6f9f2291', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (277, 12, 256160, 248.00, 'EUR', '2024-06-01', '438cfbfc-daa4-487b-9369-3565b913694f', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (280, 12, 47089, 83.00, 'EUR', '2024-09-01', '962e88e2-bdf4-4518-a322-516a6fbb3d30', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (283, 12, 99811, 165.00, 'EUR', '2024-12-01', 'b098f7b0-6a03-4c77-8fd7-32512316c859', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (286, 12, 87846, 93.00, 'EUR', '2025-03-01', 'cce9bec0-5b28-4009-acc2-9a47094f7e40', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (289, 12, 236341, 288.00, 'EUR', '2025-06-01', '4698b85a-cd60-4395-ad5a-2cf6eb984da3', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (292, 12, 54680, 99.00, 'EUR', '2025-09-01', '88401ebd-9a5a-4273-9ba1-9d0cb8850a18', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (295, 12, 80841, 144.00, 'EUR', '2025-12-01', 'ab2360fc-e291-4b67-a1c1-559158b63151', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (298, 12, 73101, 85.00, 'EUR', '2026-03-01', '54dc661e-a4d0-4f20-a129-79fdc86d899a', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (301, 13, 64103, 91.00, 'EUR', '2024-05-01', '03de6c08-8efe-4665-898d-9da9fe2f630b', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (304, 13, 277784, 242.00, 'EUR', '2024-08-01', '302555be-ee35-4482-9b5b-96173e5eef8f', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (307, 13, 64165, 95.00, 'EUR', '2024-11-01', '8cd4fca4-b8d3-4eae-baac-d49a150d08e0', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (310, 13, 98360, 181.00, 'EUR', '2025-02-01', '3693a22b-626a-4e98-ab6c-d110c2e1b868', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (313, 13, 57989, 127.00, 'EUR', '2025-05-01', '57a3a7ed-cd77-4217-8da6-3c8ef4835135', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (316, 13, 172701, 232.00, 'EUR', '2025-08-01', '2cf7281d-a9c8-4e6b-b094-d22b6ea617ac', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (319, 13, 83202, 96.00, 'EUR', '2025-11-01', '8e1ee8be-b6e9-426b-8fac-6b23790c1315', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (322, 13, 103105, 165.00, 'EUR', '2026-02-01', '8f1a1555-9180-49c6-a569-dc3a61392645', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (325, 13, 77923, 106.00, 'EUR', '2026-05-01', '30323bf5-746b-4a89-812a-a5d1491fee42', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (326, 1, 287386, 0.00, 'NOK', '2016-01-01', 'f2d1f088-02c0-4392-8ef7-397868e07d07', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (327, 1, 319545, 0.00, 'NOK', '2016-02-01', '8cb3f7eb-50b6-4901-8a2f-126abe428194', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (328, 1, 324777, 0.00, 'NOK', '2016-03-01', '1dad5d32-57de-4d87-9c70-91a0ba42ecfe', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (329, 1, 323572, 0.00, 'NOK', '2016-04-01', '65c30259-5f86-481e-90bb-e4a43a379402', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (330, 1, 348935, 0.00, 'NOK', '2016-05-01', 'a9033472-1277-4a12-b2cd-fb3a7fe3c530', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (331, 1, 471938, 0.00, 'NOK', '2016-06-01', 'c893d327-3b0d-4395-a9c7-26ab662fd37e', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (332, 1, 512127, 0.00, 'NOK', '2016-07-01', 'bda91b92-6a1e-4b9e-a4dc-5c0bf372002a', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (333, 1, 539084, 0.00, 'NOK', '2016-08-01', 'bb732751-09ec-4755-ba43-0b1f5228d453', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (334, 1, 445358, 0.00, 'NOK', '2016-09-01', '929dd6c7-4973-4ac2-9022-9ee0d28748d2', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (335, 1, 414106, 0.00, 'NOK', '2016-10-01', '6317212e-154c-4914-904f-9cf6edc1ba5b', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (336, 1, 375608, 0.00, 'NOK', '2016-11-01', '768c9561-0bb8-4492-91dc-f551e2f4174c', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (337, 1, 291049, 0.00, 'NOK', '2016-12-01', 'edbc95a9-f24b-4d2e-af5f-3e5c538a45eb', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (338, 1, 300382, 0.00, 'NOK', '2017-01-01', '615375b3-6ee6-483e-a3e0-af7ffe254cd7', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (339, 1, 322696, 0.00, 'NOK', '2017-02-01', 'a34ce248-f190-4fc6-a2b6-94cd0af4e8ac', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (340, 1, 381877, 0.00, 'NOK', '2017-03-01', '1d0e54ec-cdaa-4a36-bdc3-d9f86b5489dd', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (341, 1, 316976, 0.00, 'NOK', '2017-04-01', 'ca5c76f9-9d6c-4bc4-a109-a7f43f964dce', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (342, 1, 395037, 0.00, 'NOK', '2017-05-01', 'c5565853-3085-436f-a304-1143e3f7bef3', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (343, 1, 458492, 0.00, 'NOK', '2017-06-01', 'c8c5fae6-48f7-4f37-8c72-f7007d0fc579', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (344, 1, 521545, 0.00, 'NOK', '2017-07-01', '7da23717-06a8-41a1-929e-58fcc906d87a', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (345, 1, 561475, 0.00, 'NOK', '2017-08-01', '0628a0fb-60d0-4252-9136-f9c9a6712115', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (346, 1, 458365, 0.00, 'NOK', '2017-09-01', '837deb43-f1f7-44fb-ad75-3eba4d90668e', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (347, 1, 401916, 0.00, 'NOK', '2017-10-01', '5359c8b2-feca-4a76-aac0-03282cc6999b', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (348, 1, 393303, 0.00, 'NOK', '2017-11-01', 'dee6a9d1-9740-44dc-8391-aa94d3eabeb2', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (349, 1, 309856, 0.00, 'NOK', '2017-12-01', '0c424ff9-2513-41b0-99d6-ac83bcef93bf', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (350, 1, 312894, 0.00, 'NOK', '2018-01-01', 'daa1627e-5a8e-42eb-bc65-b551d62e2095', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (351, 1, 339521, 0.00, 'NOK', '2018-02-01', '1fcbc9c8-56d7-4df4-9334-94fa10c1e2ac', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (352, 1, 377028, 0.00, 'NOK', '2018-03-01', '173de475-e52e-48e3-89e3-916ff7971017', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (353, 1, 358601, 0.00, 'NOK', '2018-04-01', '69b42d69-c6f9-4de2-a56b-4e39bfa630f6', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (354, 1, 406103, 0.00, 'NOK', '2018-05-01', '49a6ccfc-c461-4806-b484-7828bee910d8', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (355, 1, 493871, 0.00, 'NOK', '2018-06-01', '16b39063-96f1-4c2c-9861-2f8f532fc619', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (356, 1, 543326, 0.00, 'NOK', '2018-07-01', '9bacc622-e141-477d-a1f0-6dbc10de5291', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (357, 1, 546962, 0.00, 'NOK', '2018-08-01', '34086657-d8f1-4647-9f28-0372c27f6eca', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (358, 1, 432941, 0.00, 'NOK', '2018-09-01', '533f4fc8-8aee-459b-9d95-dc866951b83d', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (359, 1, 392383, 0.00, 'NOK', '2018-10-01', '451854a1-1b78-4d9d-84cf-4a6907760eea', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (360, 1, 365320, 0.00, 'NOK', '2018-11-01', '8501037b-310f-4986-87a0-0a3ee09f845a', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (361, 1, 286902, 0.00, 'NOK', '2018-12-01', '764c1ce8-46f6-4fbe-bd05-cc7bca25feea', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (362, 1, 324766, 0.00, 'NOK', '2019-01-01', 'aacc1304-02ba-46a0-b680-0b2ce9fad85a', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (363, 1, 327288, 0.00, 'NOK', '2019-02-01', '115e1aff-12e8-4f5b-855a-38968caeed74', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (364, 1, 427029, 0.00, 'NOK', '2019-03-01', '015bbf11-8635-4e6a-8f61-a2b20ea5f749', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (365, 1, 347094, 0.00, 'NOK', '2019-04-01', 'e08fb966-9a9c-4b27-8c05-6c5f1016c08f', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (366, 1, 471232, 0.00, 'NOK', '2019-05-01', '44851046-42db-41a3-9ed1-3e56b8367931', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (367, 1, 519160, 0.00, 'NOK', '2019-06-01', '24cfc1d8-2112-4f53-bf3e-3616f270f823', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (368, 1, 583063, 0.00, 'NOK', '2019-07-01', '291f219a-fa9f-43f3-8b7a-c99d6f541247', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (369, 1, 618157, 0.00, 'NOK', '2019-08-01', '71386400-519d-451e-9abb-70d43aa2a235', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (370, 1, 482211, 0.00, 'NOK', '2019-09-01', '78380f07-e44a-4338-97bb-79d908c44987', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (371, 1, 470463, 0.00, 'NOK', '2019-10-01', '963dee9d-c5b4-4ab2-8668-d7a056a06344', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (372, 1, 430903, 0.00, 'NOK', '2019-11-01', 'aa8be771-e353-49d4-a7be-79969c3ac4cc', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (373, 1, 339281, 0.00, 'NOK', '2019-12-01', '5826ee09-ce62-42b9-b0f5-4e2e0ad42980', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (374, 1, 353417, 0.00, 'NOK', '2020-01-01', 'b85dfb1f-884b-4ca8-80f4-d6b9c1a6b298', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (375, 1, 369988, 0.00, 'NOK', '2020-02-01', '450d8a98-aff4-41cd-a714-9d47e561f2ad', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (376, 1, 148216, 0.00, 'NOK', '2020-03-01', '6c123eb1-9a0a-4819-a032-725fdebb4c11', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (377, 1, 35675, 0.00, 'NOK', '2020-04-01', '0b34cfbc-2551-498a-8001-dab3f228744e', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (378, 1, 59110, 0.00, 'NOK', '2020-05-01', '47985dfc-e552-47e4-a953-fff43aa9b0b3', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (379, 1, 140032, 0.00, 'NOK', '2020-06-01', 'a645c242-78d0-46cf-8a8a-1e288f83f7ec', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (380, 1, 310175, 0.00, 'NOK', '2020-07-01', 'ed8a1826-97a8-4c9d-b050-7223dcb218fa', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (381, 1, 221832, 0.00, 'NOK', '2020-08-01', '5668c8ce-8d1d-4000-9ae8-e6562ab5b477', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (382, 1, 169184, 0.00, 'NOK', '2020-09-01', 'd0f066e0-7de0-4694-a55a-9d38f0c5089e', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (383, 1, 154767, 0.00, 'NOK', '2020-10-01', '4416c528-66ef-48c8-baf7-83442f59267a', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (384, 1, 95757, 0.00, 'NOK', '2020-11-01', '4201c7e7-a89d-4836-ab56-d104672550d2', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (385, 1, 80226, 0.00, 'NOK', '2020-12-01', '526d429f-21c9-4b55-8184-065ca48205c0', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (386, 1, 64705, 0.00, 'NOK', '2021-01-01', '2198620b-8145-4b6b-8b3d-e97a92a44935', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (387, 1, 57228, 0.00, 'NOK', '2021-02-01', 'c70281dd-5cf2-48d9-8d44-0ed8fe63c337', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (388, 1, 47751, 0.00, 'NOK', '2021-03-01', '828a4364-e3c2-4251-a3d9-958f10d90b67', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (389, 1, 51461, 0.00, 'NOK', '2021-04-01', 'ac175944-2c87-46fc-b2a6-72330634e7df', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (390, 1, 68621, 0.00, 'NOK', '2021-05-01', 'fa5d7f58-3507-49b9-9aa2-13f6614195fe', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (391, 1, 152813, 0.00, 'NOK', '2021-06-01', '45860ed0-b9a7-4be3-9881-3cebc019bdc5', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (392, 1, 365805, 0.00, 'NOK', '2021-07-01', '72c47b95-b5c2-4926-a758-71a8f3ccaa94', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (393, 1, 339002, 0.00, 'NOK', '2021-08-01', 'eb3834f8-ae98-4d4a-a35c-11c4fda34cb1', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (394, 1, 294408, 0.00, 'NOK', '2021-09-01', '4773026e-3bbe-4bbd-a71e-41b0502daa10', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (395, 1, 371580, 0.00, 'NOK', '2021-10-01', '6fd81cc0-dfe6-4bf1-ad18-f9e72e737487', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (396, 1, 347319, 0.00, 'NOK', '2021-11-01', 'efe88ac8-5349-430b-9fbd-31c5f67f3fe2', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (397, 1, 177451, 0.00, 'NOK', '2021-12-01', 'd1c1a4e1-b4d2-4f3d-819b-f6f7a32e9d4b', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (398, 1, 129662, 0.00, 'NOK', '2022-01-01', 'be135ecd-085e-44f7-971c-1d799d0b57a2', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (399, 1, 221859, 0.00, 'NOK', '2022-02-01', '4eb027d4-e745-45b9-b95c-80684a6aa536', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (400, 1, 354159, 0.00, 'NOK', '2022-03-01', 'd6e7ed6c-24d3-499f-9ea1-0a481884b866', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (401, 1, 336143, 0.00, 'NOK', '2022-04-01', '5f96c928-fd3a-4451-87cc-c9f9da7672df', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (402, 1, 441097, 0.00, 'NOK', '2022-05-01', '3f47af99-ec42-4d0c-b8a8-d95c3c6624c9', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (403, 1, 506155, 0.00, 'NOK', '2022-06-01', '4de82d75-8c29-4c4b-818f-f3c9bf0bfcbf', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (404, 1, 565977, 0.00, 'NOK', '2022-07-01', 'a8be4785-f397-463d-b137-07bef30c7bd9', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (405, 1, 583162, 0.00, 'NOK', '2022-08-01', 'd2b66338-2e28-4af6-8bdf-1e31557835ce', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (406, 1, 461724, 0.00, 'NOK', '2022-09-01', '11c7308d-283b-4d39-a5f4-c4bb8153d7db', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (407, 1, 434039, 0.00, 'NOK', '2022-10-01', 'fce1e84a-2af5-4466-98bc-9f50c0fa8f46', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (408, 1, 409125, 0.00, 'NOK', '2022-11-01', '39371a13-598d-4556-a044-2bf70c37f375', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (409, 1, 343705, 0.00, 'NOK', '2022-12-01', '47772a03-78bf-4102-ab1d-9c0ae8f832ed', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (410, 1, 307509, 0.00, 'NOK', '2023-01-01', 'd27dad73-1ff0-4480-a0f8-0a602cfebb9a', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (411, 1, 341011, 0.00, 'NOK', '2023-02-01', '3aad495b-8cac-4933-879e-a39e93ff9471', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (412, 1, 381516, 0.00, 'NOK', '2023-03-01', '87a4f74e-70d6-470a-8e65-b661249cbcd9', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (413, 1, 375210, 0.00, 'NOK', '2023-04-01', 'b8140bdc-321b-4ac7-aedc-80309db1e145', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (414, 1, 462588, 0.00, 'NOK', '2023-05-01', '215a45f0-85f3-4b2b-b61f-ffa14ed74045', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (415, 1, 555056, 0.00, 'NOK', '2023-06-01', '8a7fa3f4-31d0-41a6-9963-d181ad2a2daa', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (416, 1, 597949, 0.00, 'NOK', '2023-07-01', 'b56c4674-f8b7-4bd1-8f88-d557e41ed5c1', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (417, 1, 625116, 0.00, 'NOK', '2023-08-01', 'b1b3577d-6ea0-4835-9d5f-8d7315337c2c', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (418, 1, 507314, 0.00, 'NOK', '2023-09-01', 'f24e6902-1479-4eba-9525-0a2740ffaa99', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (419, 1, 453810, 0.00, 'NOK', '2023-10-01', 'da27b608-d92f-4358-84d9-0673dce98f8d', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (420, 1, 432660, 0.00, 'NOK', '2023-11-01', 'e724997e-65a6-4718-981c-2e87c682f163', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (421, 1, 364668, 0.00, 'NOK', '2023-12-01', 'a6692a22-3d09-4fd5-b88e-9cbfd9261612', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (178, 8, 224002, 1407.00, 'EUR', '2024-07-01', '9b8d2757-a95f-4156-84f8-703c7c3fa675', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (181, 8, 64285, 1507.00, 'EUR', '2024-10-01', '0f9c123a-9e8b-4cbc-a523-18d42fff0b16', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (184, 8, 102351, 1330.00, 'EUR', '2025-01-01', '243e90a9-29a0-4366-80cb-dbd027d65090', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (187, 8, 83467, 1398.00, 'EUR', '2025-04-01', '556a63b0-d935-4219-983f-6dd0949de812', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (190, 8, 257142, 1550.00, 'EUR', '2025-07-01', 'ce27fd3a-0c17-4160-a789-9c951f6af1c5', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (193, 8, 65245, 1607.00, 'EUR', '2025-10-01', 'e6fdc361-3013-40b8-80af-951263995301', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (196, 8, 99103, 1376.00, 'EUR', '2026-01-01', '365d354d-a949-46df-8ec7-13b3589d098f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (199, 8, 58611, 1468.00, 'EUR', '2026-04-01', '54057230-8458-40da-8c11-580124edba75', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (202, 9, 168081, 1674.00, 'EUR', '2024-06-01', '2083281a-c46c-4079-8ae1-ff8cc63b9655', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (204, 9, 198548, 1748.00, 'EUR', '2024-08-01', '7247c47a-c186-43d5-be3d-75060bab31fa', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (205, 9, 71918, 1551.00, 'EUR', '2024-09-01', '805e1716-d221-41af-933e-a2d7032774e0', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (206, 9, 86570, 1334.00, 'EUR', '2024-10-01', '09e4af57-15ca-4da9-9513-51c84d61b379', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (207, 9, 56265, 1305.00, 'EUR', '2024-11-01', 'e13b0bfb-ad2f-439c-93e2-87df59eb938c', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (208, 9, 85849, 1305.00, 'EUR', '2024-12-01', '1f7718d5-b084-421f-9557-cb604e4cb16b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (209, 9, 115904, 1221.00, 'EUR', '2025-01-01', '5c45ef15-4b4f-4ea9-b41a-f53446f5c475', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (210, 9, 112713, 1257.00, 'EUR', '2025-02-01', 'be2635b1-4308-4393-9923-5e91690b1b54', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (211, 9, 77207, 1295.00, 'EUR', '2025-03-01', 'c8aa6436-3f52-49f8-99f1-d80c6ecc5c70', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (212, 9, 58446, 1347.00, 'EUR', '2025-04-01', 'e70428a5-005e-48de-9e88-fc133eee7151', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (213, 9, 86268, 1621.00, 'EUR', '2025-05-01', 'e5effe47-ddd3-478c-befd-f22f3edc4c0f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (214, 9, 294871, 1855.00, 'EUR', '2025-06-01', '97600adb-abb2-4a76-a8c7-7d1b7239b0d8', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (215, 9, 198269, 1816.00, 'EUR', '2025-07-01', 'c7cc768b-2cb7-4017-b0ea-a62b38cab2be', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (216, 9, 286633, 1916.00, 'EUR', '2025-08-01', '7c40c3e9-6aa8-49d8-89af-6b5da6074a0f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (217, 9, 72218, 1627.00, 'EUR', '2025-09-01', '27b6413f-4815-49bd-abc0-45635d7874c3', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (218, 9, 48469, 1374.00, 'EUR', '2025-10-01', 'e0b1af1d-aede-4427-b549-70f6789c1afd', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (219, 9, 65364, 1328.00, 'EUR', '2025-11-01', 'fa381362-482e-498c-b1a6-33c4dc676655', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (220, 9, 117590, 1340.00, 'EUR', '2025-12-01', 'd44dda5a-eb30-410a-947c-6a3bd711592e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (221, 9, 103094, 1256.00, 'EUR', '2026-01-01', 'b8182201-1bde-448a-a7b8-513887067aaf', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (222, 9, 109338, 1321.00, 'EUR', '2026-02-01', '8add80eb-ca59-4d5a-973e-5ec74ddfe9a3', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (223, 9, 75315, 1321.00, 'EUR', '2026-03-01', '49118cad-2715-4742-a175-99cd89fdd2ef', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (224, 9, 70991, 1427.00, 'EUR', '2026-04-01', '5a74428f-98a7-450b-a2f6-46902b77bc89', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (226, 10, 79954, 1054.00, 'EUR', '2024-05-01', 'acfcd5cf-b6e9-42bf-8ac3-8f2fab62e53f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (227, 10, 219877, 1240.00, 'EUR', '2024-06-01', '8fb40408-3872-46bf-88d6-524f13f918cf', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (228, 10, 260469, 1161.00, 'EUR', '2024-07-01', '1367de74-60c2-435e-8243-ab10f3be9c79', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (229, 10, 299130, 1168.00, 'EUR', '2024-08-01', '648f9f51-130e-4c5b-a689-2b9e18b2e0d2', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (230, 10, 67115, 1222.00, 'EUR', '2024-09-01', 'ebdcf6cf-3112-409f-9362-e7e1b47645a7', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (231, 10, 72652, 1420.00, 'EUR', '2024-10-01', 'e97e761c-8f03-47d0-a091-31f32f5c333b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (232, 10, 47909, 1905.00, 'EUR', '2024-11-01', '5630cf18-45a4-45a0-bed0-cb5d34947dee', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (233, 10, 98043, 2402.00, 'EUR', '2024-12-01', '4ef875a3-2fc4-474b-a5ac-4dc8b73ec09f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (234, 10, 86689, 2328.00, 'EUR', '2025-01-01', '7e1eb3b1-a7e8-4739-a11b-b6613eace6a1', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (235, 10, 98572, 2380.00, 'EUR', '2025-02-01', 'c82fab85-0f7c-4a69-909e-6e495679ef5a', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (236, 10, 51659, 2076.00, 'EUR', '2025-03-01', 'd6e9e487-be0a-407b-b39c-02008ae3b969', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (237, 10, 58800, 1199.00, 'EUR', '2025-04-01', 'd2128be9-4c3b-4ad1-b21a-4f88ac6b0476', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (238, 10, 43159, 1211.00, 'EUR', '2025-05-01', 'f3b3533c-4d62-4be2-a869-4fe89f9ddd43', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (239, 10, 235004, 1460.00, 'EUR', '2025-06-01', 'eeaca635-2fd4-4ea1-896a-2863f65db806', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (240, 10, 297879, 1156.00, 'EUR', '2025-07-01', 'c0740d3e-f8b3-4873-819c-c8fdb8a00769', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (241, 10, 170323, 1196.00, 'EUR', '2025-08-01', '43bb7eae-6c62-4d7d-a47d-62ea722e3334', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (242, 10, 81768, 1260.00, 'EUR', '2025-09-01', '0155a6bb-aeed-4f4c-9307-6a8981c2151e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (243, 10, 84205, 1415.00, 'EUR', '2025-10-01', 'b73493bb-a5f6-4b39-b330-f02ff08bc39c', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (244, 10, 51517, 1972.00, 'EUR', '2025-11-01', '5fb31087-5238-4415-b30f-68dbb9ad2bfb', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (245, 10, 99100, 2674.00, 'EUR', '2025-12-01', 'f0b86f25-ed4e-410d-ae0c-2aba80845ca5', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (246, 10, 89043, 2526.00, 'EUR', '2026-01-01', '1a7fbe54-c04f-4506-8222-8408ae97faa7', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (247, 10, 84799, 2607.00, 'EUR', '2026-02-01', 'd9af14c5-c390-404f-bbf1-e90ee5983bd0', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (248, 10, 61705, 2152.00, 'EUR', '2026-03-01', 'a1361e7a-4247-4d11-913e-628b2423c9d1', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (249, 10, 48267, 1276.00, 'EUR', '2026-04-01', 'dd1a673d-7e02-4d2a-ac35-d0cfad0a5597', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (422, 8, 287386, 909.00, 'NOK', '2016-01-01', 'ce702cde-d0d0-4347-afcb-59c461da5dfe', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (423, 8, 319545, 941.00, 'NOK', '2016-02-01', 'a2e21e1b-290a-4546-aedc-c2d01d29e397', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (424, 8, 324777, 984.00, 'NOK', '2016-03-01', '706d7b00-c992-4a7c-adc1-718e665c38c4', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (425, 8, 323572, 948.00, 'NOK', '2016-04-01', '51face90-361b-4571-a8b7-d430406b1a73', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (426, 8, 348935, 1000.00, 'NOK', '2016-05-01', '2e8fe42e-3ec3-47fd-8865-cfebc21b13ca', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (427, 8, 471938, 1058.00, 'NOK', '2016-06-01', '136f6eb2-12d1-4b85-abbd-a7448cd47dce', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (428, 8, 512127, 788.00, 'NOK', '2016-07-01', '99b9a3ea-cadd-4cc2-af41-b18d88c0a9ce', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (429, 8, 539084, 954.00, 'NOK', '2016-08-01', '3219f588-07bf-4869-acd2-61411cd3597c', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (430, 8, 445358, 1050.00, 'NOK', '2016-09-01', 'a1154e37-9e0b-4fc5-899b-ddf856e1cfd0', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (431, 8, 414106, 976.00, 'NOK', '2016-10-01', '3dc81097-dab9-470e-9f46-e8aaed7ba1ec', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (432, 8, 375608, 1007.00, 'NOK', '2016-11-01', 'cbddc1e6-8a6b-4daf-a1bc-ccb1db330986', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (433, 8, 291049, 898.00, 'NOK', '2016-12-01', '1d27d110-72dd-48a5-b8b2-c0adf2fcb608', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (434, 8, 300382, 929.00, 'NOK', '2017-01-01', '8da78596-05f2-459d-b5d7-8e45db94812b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (435, 8, 322696, 947.00, 'NOK', '2017-02-01', 'c52c177c-aa7a-44a6-818a-a7b3f5c07875', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (436, 8, 381877, 971.00, 'NOK', '2017-03-01', 'e6e0681f-aeff-4ea3-957e-d6c87b6d9ea6', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (437, 8, 316976, 931.00, 'NOK', '2017-04-01', '13c0e5ee-d5e4-4773-857b-ceeeeac10aec', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (438, 8, 395037, 1137.00, 'NOK', '2017-05-01', 'bf599852-2103-4770-b975-e341df4f1806', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (439, 8, 458492, 1122.00, 'NOK', '2017-06-01', '2efc1e27-fb03-4304-a0b2-8c63ef55b3f5', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (440, 8, 521545, 820.00, 'NOK', '2017-07-01', '5672e1b3-3acd-4c84-8dc8-a085071d97fe', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (441, 8, 561475, 993.00, 'NOK', '2017-08-01', 'd0fc068c-0e26-4d14-bde5-835549b7c3a6', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (442, 8, 458365, 1136.00, 'NOK', '2017-09-01', '8631a030-476d-4fd4-a430-ae6a4ebf61bd', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (443, 8, 401916, 1048.00, 'NOK', '2017-10-01', '005af79f-ee1c-4fba-b7c4-36221ec990fc', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (444, 8, 393303, 1079.00, 'NOK', '2017-11-01', '0b9de789-10d3-4666-b1ea-c8b62b0cde28', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (445, 8, 309856, 974.00, 'NOK', '2017-12-01', '51b8215b-c230-47b5-8783-dbee64660235', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (446, 8, 312894, 966.00, 'NOK', '2018-01-01', 'ebc3a63f-e399-4599-a003-469b92e42278', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (447, 8, 339521, 971.00, 'NOK', '2018-02-01', '3361f883-1a96-4f06-bc79-a829b1bb4705', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (448, 8, 377028, 993.00, 'NOK', '2018-03-01', 'dd42a4cc-9202-4ba1-8158-edc2c30d4d6d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (449, 8, 358601, 1024.00, 'NOK', '2018-04-01', 'c6fabbb9-14c2-4392-8f98-6d04a19e5ee7', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (450, 8, 406103, 1143.00, 'NOK', '2018-05-01', 'be627957-d154-4f2f-8ad1-672e4299ded8', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (451, 8, 493871, 1228.00, 'NOK', '2018-06-01', '82f94f3b-4a0d-40b5-a640-a0af53efd472', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (452, 8, 543326, 934.00, 'NOK', '2018-07-01', '3ecb5802-2503-4d72-97aa-5c46cf356542', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (453, 8, 546962, 1136.00, 'NOK', '2018-08-01', 'b470a858-8334-4b1c-92e0-02a2b38362d6', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (454, 8, 432941, 1160.00, 'NOK', '2018-09-01', '77cec118-9add-48ea-b763-bf19b2cbaea8', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (455, 8, 392383, 986.00, 'NOK', '2018-10-01', '701e8c04-2b8b-4e32-a0cc-17706cff752f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (456, 8, 365320, 1104.00, 'NOK', '2018-11-01', '017d72d9-a687-42d9-8523-1e5b5075aa9d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (457, 8, 286902, 1012.00, 'NOK', '2018-12-01', '08a16803-4ad9-4a2c-9ed4-45fd741cec9d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (458, 8, 324766, 949.00, 'NOK', '2019-01-01', 'e5c8e7ad-6764-4533-8572-59a915954224', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (459, 8, 327288, 940.00, 'NOK', '2019-02-01', 'a851fc54-5a85-41a6-af8b-2fec23f38b83', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (460, 8, 427029, 1011.00, 'NOK', '2019-03-01', 'a3bcf5ca-0da1-45c4-8050-21c1f6b16904', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (461, 8, 347094, 946.00, 'NOK', '2019-04-01', '61e9f9ea-adc0-4864-8bdf-2b3f41e3f913', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (462, 8, 471232, 1094.00, 'NOK', '2019-05-01', 'bbe69708-fb3d-48d4-aed2-93f7ff1c079c', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (463, 8, 519160, 1346.00, 'NOK', '2019-06-01', '767271ff-749f-4e1f-a20f-fbc91b9f45d2', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (464, 8, 583063, 906.00, 'NOK', '2019-07-01', '1d78c72e-3e52-4d3a-ab23-8baf97d088c7', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (465, 8, 618157, 1074.00, 'NOK', '2019-08-01', '4e741b1d-70da-4098-a783-deea24c24dcf', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (466, 8, 482211, 1114.00, 'NOK', '2019-09-01', '9f55feda-741a-4ccc-8370-2e1a94075049', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (467, 8, 470463, 1059.00, 'NOK', '2019-10-01', '245bd639-53f9-4e2b-84de-b4423245c220', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (468, 8, 430903, 1029.00, 'NOK', '2019-11-01', '813fd197-c087-4085-8769-39d1289f5940', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (469, 8, 339281, 976.00, 'NOK', '2019-12-01', 'ea2359ee-5fae-479c-a469-9361a9401b69', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (470, 8, 353417, 928.00, 'NOK', '2020-01-01', 'bd886e6d-bbb2-429e-afa5-bfdd10796acc', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (471, 8, 369988, 931.00, 'NOK', '2020-02-01', '74325deb-8d0a-41a8-b3c2-06fba1bdf7e2', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (472, 8, 148216, 1035.00, 'NOK', '2020-03-01', 'd1e1d544-2b97-4a3a-8e2c-af649e61e95c', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (473, 8, 35675, 855.00, 'NOK', '2020-04-01', '82bda3e2-f2aa-4155-81a5-d623687362e3', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (474, 8, 59110, 870.00, 'NOK', '2020-05-01', 'a4789f58-735c-44c0-b474-c0d5e6911dc5', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (475, 8, 140032, 889.00, 'NOK', '2020-06-01', '4e89ed45-ab4f-4151-837e-de94d123feaa', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (476, 8, 310175, 877.00, 'NOK', '2020-07-01', 'b498152e-30da-44c1-83e2-c4c68e6e393f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (477, 8, 221832, 859.00, 'NOK', '2020-08-01', '28c9e89e-9014-4336-95eb-feabef1efd13', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (478, 8, 169184, 860.00, 'NOK', '2020-09-01', '5f7b5dc8-5e32-4100-8082-d745610eea92', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (479, 8, 154767, 823.00, 'NOK', '2020-10-01', '297791e5-5953-4c29-aa4c-e1dc6e4e6054', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (480, 8, 95757, 724.00, 'NOK', '2020-11-01', 'b7223a11-f280-4fba-acaa-04758e0e035d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (481, 8, 80226, 787.00, 'NOK', '2020-12-01', 'acebf831-e944-49cc-abbc-e7500d645949', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (482, 8, 64705, 755.00, 'NOK', '2021-01-01', 'fb6405be-08e3-4209-9fd0-3df507edf8fc', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (483, 8, 57228, 767.00, 'NOK', '2021-02-01', '3c02399c-993d-4422-a513-bf23975b5b77', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (484, 8, 47751, 742.00, 'NOK', '2021-03-01', 'a664c42b-2395-4599-b7d5-fc0448268005', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (485, 8, 51461, 772.00, 'NOK', '2021-04-01', '34a3e7b6-93f7-4f75-91a2-c10c3f6b65d9', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (486, 8, 68621, 844.00, 'NOK', '2021-05-01', 'c37b044b-a388-4f9d-857d-957471aef7ea', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (487, 8, 152813, 891.00, 'NOK', '2021-06-01', '92b3a2c1-61a0-46cd-a30c-566735970af0', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (488, 8, 365805, 986.00, 'NOK', '2021-07-01', 'f50d3b13-751d-43cd-a9bc-18d9c010edba', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (489, 8, 339002, 1034.00, 'NOK', '2021-08-01', 'aad09ea0-d0a4-427b-9277-dd2ce1a986dd', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (490, 8, 294408, 1059.00, 'NOK', '2021-09-01', '8c72b2fc-7a04-428c-b341-8b76f42bf97d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (491, 8, 371580, 1075.00, 'NOK', '2021-10-01', '1e11b36b-0b6b-4b78-b2cc-7d9915c7f2b2', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (492, 8, 347319, 1161.00, 'NOK', '2021-11-01', 'd0c106c2-1f2f-4306-a87c-2878a701e6e3', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (493, 8, 177451, 1088.00, 'NOK', '2021-12-01', 'fc835aec-30b7-4ad9-8fea-414c70aee602', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (494, 8, 129662, 946.00, 'NOK', '2022-01-01', 'f0f33d19-ad7e-4c0d-a02d-c4ba040c9dd4', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (495, 8, 221859, 1007.00, 'NOK', '2022-02-01', '0d8bede9-94f3-4b25-aa71-cee4965535ba', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (496, 8, 354159, 1103.00, 'NOK', '2022-03-01', 'a27856fe-d208-44d4-9ce5-52fb6a7efc47', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (497, 8, 336143, 1263.00, 'NOK', '2022-04-01', '7d4c354d-8b34-47a0-987b-bcd1d001559d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (498, 8, 441097, 1377.00, 'NOK', '2022-05-01', 'e7607e8f-3b2d-431e-b487-06e4fc53a5ba', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (499, 8, 506155, 1566.00, 'NOK', '2022-06-01', 'a4bbad1b-717e-4f75-831b-0c3959810cd5', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (500, 8, 565977, 1298.00, 'NOK', '2022-07-01', '22765701-c7c4-4e52-8692-09cc39271ef9', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (501, 8, 583162, 1392.00, 'NOK', '2022-08-01', 'e35d3523-b9e6-4ef0-a72f-c96f20bce374', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (502, 8, 461724, 1481.00, 'NOK', '2022-09-01', '50d1c289-1869-41b8-acc8-2aef969d2891', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (503, 8, 434039, 1377.00, 'NOK', '2022-10-01', 'e99a8e0e-a7eb-4ac1-9713-c65e3f16fba4', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (504, 8, 409125, 1384.00, 'NOK', '2022-11-01', '415391c4-0510-476a-b4ca-493a9f695dfb', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (505, 8, 343705, 1330.00, 'NOK', '2022-12-01', '77ae186e-7b24-4711-b495-3c0e834c26bb', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (506, 8, 307509, 1194.00, 'NOK', '2023-01-01', 'cfe72580-eeee-4b3c-a8ae-345eba048cf9', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (507, 8, 341011, 1228.00, 'NOK', '2023-02-01', '19a4cd78-b08b-4f5f-9cda-239c8239cab1', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (508, 8, 381516, 1268.00, 'NOK', '2023-03-01', '02385b6e-c3fe-47f9-9521-c65cf75678a8', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (509, 8, 375210, 1342.00, 'NOK', '2023-04-01', 'dd6a42bf-0e6d-40f2-89f4-75432c046861', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (510, 8, 462588, 1484.00, 'NOK', '2023-05-01', 'aaa62415-b1e0-4534-a327-50ff25bddd52', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (511, 8, 555056, 1926.00, 'NOK', '2023-06-01', '638e26b4-e317-486a-8c3c-65ce1262a827', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (512, 8, 597949, 1362.00, 'NOK', '2023-07-01', 'be859601-f84a-43ee-accb-8cdbe6fa0f21', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (513, 8, 625116, 1481.00, 'NOK', '2023-08-01', 'd01a7667-274c-41bf-a9a3-559784b1f65c', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (514, 8, 507314, 1549.00, 'NOK', '2023-09-01', 'cda689b2-3e1d-49ca-a355-6b3c30c25ab7', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (515, 8, 453810, 1408.00, 'NOK', '2023-10-01', 'e143ea5a-d75f-4bb9-bbca-b29ccfdfef95', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (516, 8, 432660, 1395.00, 'NOK', '2023-11-01', '35a03f3d-0162-405a-89a3-e4d3e6db2023', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (517, 8, 364668, 1367.00, 'NOK', '2023-12-01', '4bd81548-9193-4e70-9285-9617034f1855', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (518, 8, NULL, 1215.00, 'NOK', '2024-01-01', 'd19748e1-b9e2-4be2-adb4-3391f55b70db', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (519, 8, NULL, 1235.00, 'NOK', '2024-02-01', '23ee8d06-2279-41aa-a20f-18baa30ed2d2', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (520, 8, NULL, 1288.00, 'NOK', '2024-03-01', '49e172b7-4cb7-4013-8426-4b8539c3330a', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (521, 8, NULL, 1389.00, 'NOK', '2024-04-01', 'b6776fef-1b70-4c56-a599-4ec6a8f6dee7', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (522, 9, 89369, 887.00, 'NOK', '2016-01-01', '3806e7a1-09ef-43bb-8b30-2713f4efa861', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (523, 9, 118638, 919.00, 'NOK', '2016-02-01', '5800e69b-dec7-496d-b618-88cabf4f68e9', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (524, 9, 105223, 921.00, 'NOK', '2016-03-01', 'a1f53ba5-abb3-413f-b26b-7d060c59634b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (525, 9, 127771, 924.00, 'NOK', '2016-04-01', '56a3a90e-91e3-43fd-8a38-f1d6c0c61eb1', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (526, 9, 159024, 1020.00, 'NOK', '2016-05-01', 'd56a757d-d005-43c5-8889-726e2818bca9', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (527, 9, 218821, 1101.00, 'NOK', '2016-06-01', 'ace13f8c-9258-408c-b76d-3bc69110d534', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (528, 9, 260804, 1000.00, 'NOK', '2016-07-01', 'd4747f79-c8a9-4b12-a776-4a57337f90d5', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (529, 9, 253827, 1036.00, 'NOK', '2016-08-01', '98a11267-2e8c-4358-8f0a-f49a40b4343e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (530, 9, 180920, 983.00, 'NOK', '2016-09-01', '8ade1055-6d12-4d82-9828-768be896c50a', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (531, 9, 143335, 957.00, 'NOK', '2016-10-01', '91438b66-d1e5-4d64-b066-5e0858998b42', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (532, 9, 131897, 962.00, 'NOK', '2016-11-01', 'f8a56f7e-d873-4932-a9d5-301cefbe64fc', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (533, 9, 92313, 962.00, 'NOK', '2016-12-01', '6ce72e7a-93dd-42a7-bc13-c9eb71f506da', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (534, 9, 82888, 919.00, 'NOK', '2017-01-01', 'd1c495b8-50f7-4e6c-8cdf-7523d4ab0e66', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (535, 9, 101132, 954.00, 'NOK', '2017-02-01', '2cdfd1ca-5f79-42da-9944-1a86803edff9', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (536, 9, 115702, 930.00, 'NOK', '2017-03-01', '89e6b455-8c1c-4a37-be6b-17ac12bf5b55', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (537, 9, 124568, 956.00, 'NOK', '2017-04-01', '263c0e7d-2953-4a0f-89d7-596ec4d42837', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (538, 9, 175538, 1030.00, 'NOK', '2017-05-01', 'd5936fe7-91c7-4256-90f8-1c52d72c4f1b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (539, 9, 237683, 1135.00, 'NOK', '2017-06-01', '37d2e8f5-31b0-4503-b708-c8276ca7f427', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (540, 9, 270597, 1058.00, 'NOK', '2017-07-01', '0d3e5308-42af-4ca3-8cc2-e5bd6067fe20', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (541, 9, 275410, 1099.00, 'NOK', '2017-08-01', '94b649d6-b2e3-4065-8772-df56fe5a4fbd', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (542, 9, 206583, 1161.00, 'NOK', '2017-09-01', 'a111c0d4-0e25-48da-97d1-c3bf3e749d6a', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (543, 9, 163290, 971.00, 'NOK', '2017-10-01', '399dd656-c865-460b-9b90-638a0785e913', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (544, 9, 135133, 956.00, 'NOK', '2017-11-01', 'ecdb3f39-aead-4847-8c1f-7d4ef64cc1a5', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (545, 9, 102342, 940.00, 'NOK', '2017-12-01', '704d4a21-e18c-4d44-89a0-39ba6a3848e6', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (546, 9, 98700, 900.00, 'NOK', '2018-01-01', '95ae8b89-ecc9-4ff0-8a17-01e4c064a560', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (547, 9, 112411, 923.00, 'NOK', '2018-02-01', '5004b8c1-2668-414a-9f88-b09b7fa3fe3a', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (548, 9, 120576, 930.00, 'NOK', '2018-03-01', 'dcf52c41-dbda-4b9a-b89c-9c29dd79c1d1', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (549, 9, 149630, 928.00, 'NOK', '2018-04-01', '9c6241c7-6880-445c-ad98-9119b8075b1d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (550, 9, 194293, 1019.00, 'NOK', '2018-05-01', '4e4c1b8d-46fa-48e6-9f83-40fe11282556', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (551, 9, 258863, 1093.00, 'NOK', '2018-06-01', '8cec69e6-14b4-41ab-96e8-840bd022c59a', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (552, 9, 288857, 1063.00, 'NOK', '2018-07-01', 'ca88f432-dd89-4fe1-8c36-cede6bcf7407', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (553, 9, 300865, 1105.00, 'NOK', '2018-08-01', '4d22e44a-7a1d-4769-8117-e830c534e93e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (554, 9, 207983, 1024.00, 'NOK', '2018-09-01', '64690ab4-a7f1-4246-9530-139561dec7a5', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (555, 9, 168387, 958.00, 'NOK', '2018-10-01', 'f8cab36a-86f4-421f-9a30-7a5f5ab71132', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (556, 9, 154419, 964.00, 'NOK', '2018-11-01', '416318e7-bdb0-463e-b0f7-46f90ebeaa70', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (557, 9, 110997, 940.00, 'NOK', '2018-12-01', '419f9aff-551e-43cc-ac96-dd3b6f09f14e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (558, 9, 107550, 914.00, 'NOK', '2019-01-01', '20a0eda7-d252-45e0-bda9-91e9ae759ef1', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (559, 9, 120075, 923.00, 'NOK', '2019-02-01', '88177d73-4277-4c63-a8a8-df4f62cb2ba6', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (560, 9, 141132, 928.00, 'NOK', '2019-03-01', '9650bb6d-74b9-44b5-9a67-7b82913d8054', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (561, 9, 144500, 926.00, 'NOK', '2019-04-01', '1198ce8e-0143-4073-8a18-efef385d5501', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (562, 9, 217929, 1048.00, 'NOK', '2019-05-01', '0205727f-2a04-4a1c-a78f-bc9b1a951dc5', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (563, 9, 285240, 1178.00, 'NOK', '2019-06-01', 'a2c38833-124a-4675-abbe-a5d748539770', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (564, 9, 306548, 1104.00, 'NOK', '2019-07-01', '786cc890-df6c-4a4f-83d7-5d91de92ada6', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (565, 9, 330642, 1139.00, 'NOK', '2019-08-01', 'f27032f4-3705-4040-9bc8-47ff86ddda8f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (566, 9, 225344, 1033.00, 'NOK', '2019-09-01', 'f2cb31eb-abcb-4143-86cf-8c5db3b4d74d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (567, 9, 179607, 954.00, 'NOK', '2019-10-01', '4f319e37-0cfd-4633-adf8-e5cf4da93801', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (568, 9, 166623, 953.00, 'NOK', '2019-11-01', 'c7c2c6e3-18c4-45dd-932d-24b5ea12fce8', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (569, 9, 126413, 924.00, 'NOK', '2019-12-01', '11d96674-f772-4ef5-9c2d-9347a22d93de', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (570, 9, 121306, 924.00, 'NOK', '2020-01-01', 'a00b3491-146d-4ec8-b5c5-10549fa7b409', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (571, 9, 136315, 949.00, 'NOK', '2020-02-01', '24bbb0ac-fdb4-4fda-b001-eca0d1584146', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (572, 9, 61233, 987.00, 'NOK', '2020-03-01', 'ed32323a-6ec0-4134-b309-1d037b076945', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (573, 9, 20009, 931.00, 'NOK', '2020-04-01', '8c111061-6b4e-4973-86da-fed60692a18b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (574, 9, 38761, 1014.00, 'NOK', '2020-05-01', 'd5a24571-1095-4b1a-be6e-c578a4b894b6', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (575, 9, 82854, 1135.00, 'NOK', '2020-06-01', 'f6f9ddeb-17d8-4d8f-aff9-bb380f9b1241', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (576, 9, 246836, 1241.00, 'NOK', '2020-07-01', '31cb97c0-5e54-4afd-a17d-2177cba573d6', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (577, 9, 148962, 1166.00, 'NOK', '2020-08-01', '979b2c88-d103-4f44-83a4-b8e49a84b328', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (578, 9, 76820, 1090.00, 'NOK', '2020-09-01', 'bff9c0d1-729a-4e2e-9031-39f5380cee45', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (579, 9, 85010, 1034.00, 'NOK', '2020-10-01', '7e50f38d-3d80-4200-9f33-b71105830f11', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (580, 9, 46882, 956.00, 'NOK', '2020-11-01', '4a3c9783-c555-4f0f-99be-1e44d4d715e4', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (581, 9, 53333, 942.00, 'NOK', '2020-12-01', 'd8139ea3-1693-4dbc-84f7-f8466e362565', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (582, 9, 53781, 896.00, 'NOK', '2021-01-01', 'f8d085ed-0bab-444b-895f-efe768599789', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (583, 9, 38317, 950.00, 'NOK', '2021-02-01', 'e33305bb-94b1-4fff-a8bb-a99e02ada237', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (584, 9, 55309, 975.00, 'NOK', '2021-03-01', '5f3aef32-0792-43ab-a18a-384d74b6c158', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (585, 9, 52113, 981.00, 'NOK', '2021-04-01', '31deb422-12ba-4e04-8b7a-9882959f5966', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (586, 9, 77691, 1109.00, 'NOK', '2021-05-01', '4692777d-5805-4a6d-bcf5-5b2c99819a86', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (587, 9, 115587, 1208.00, 'NOK', '2021-06-01', '7f279ec6-3f61-4632-aacf-799eaa5ea190', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (588, 9, 215140, 1432.00, 'NOK', '2021-07-01', 'c216e660-fdfe-4f12-a9ed-8955b1a06ce2', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (589, 9, 169651, 1278.00, 'NOK', '2021-08-01', 'ba4629a6-ed74-4ce8-9e0b-a02c1379ade9', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (590, 9, 150393, 1120.00, 'NOK', '2021-09-01', 'da9ad2fe-a586-472d-b2e9-0a6f81234537', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (591, 9, 161380, 1037.00, 'NOK', '2021-10-01', '8c9178fc-ebbb-44dc-8f20-9bf727d81e29', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (592, 9, 162064, 1052.00, 'NOK', '2021-11-01', 'd5769537-14cb-4809-9d71-61ed79ff317e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (593, 9, 81905, 1043.00, 'NOK', '2021-12-01', '89b270fc-8bb5-483e-b290-91fa6cee8729', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (594, 9, 67885, 995.00, 'NOK', '2022-01-01', 'b112ae22-c6b8-4983-bbba-3573d3a5a823', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (595, 9, 106160, 1046.00, 'NOK', '2022-02-01', 'b989bd30-6ee6-46c9-8a58-86ee3fc3e358', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (596, 9, 149076, 1061.00, 'NOK', '2022-03-01', '414a9dca-c939-4485-b8ad-5222299797f3', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (597, 9, 156999, 1113.00, 'NOK', '2022-04-01', 'e42f3c52-147f-47a2-9de4-6ad35faec069', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (598, 9, 210329, 1285.00, 'NOK', '2022-05-01', 'ebc46b46-b542-47c0-9649-790cf6f39479', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (599, 9, 259991, 1391.00, 'NOK', '2022-06-01', 'f6f640f2-54d8-4b3b-90ca-33109e0d9486', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (600, 9, 283815, 1401.00, 'NOK', '2022-07-01', 'bbe3e7cc-c858-4e98-bb1f-4a0e18a1c05e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (601, 9, 308981, 1393.00, 'NOK', '2022-08-01', 'b830575c-2b90-458c-b4b4-48fa025e92c2', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (602, 9, 220581, 1272.00, 'NOK', '2022-09-01', '3b5ab33b-08f5-4476-8eff-dd1f54a178c7', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (603, 9, 183883, 1173.00, 'NOK', '2022-10-01', 'd2c94c75-1013-4349-8bb1-053f300a500a', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (604, 9, 168736, 1190.00, 'NOK', '2022-11-01', '3e9f344b-0e6b-4253-bf1e-81e9e29040a4', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (605, 9, 131406, 1195.00, 'NOK', '2022-12-01', '3b58d617-b9fe-4075-81f3-38e9af3420b3', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (606, 9, 116532, 1138.00, 'NOK', '2023-01-01', '5c7dcb76-b8eb-4c2c-acbf-e66fb2dd58e3', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (607, 9, 134955, 1165.00, 'NOK', '2023-02-01', 'd4f6728b-b0ba-4d62-8e5d-076dabfe2031', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (608, 9, 161853, 1190.00, 'NOK', '2023-03-01', 'b2126d09-534b-4768-ad37-091e3b49d5aa', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (609, 9, 156575, 1231.00, 'NOK', '2023-04-01', '1fca1ed5-101d-4225-ad01-e7684aecb9f5', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (610, 9, 230547, 1367.00, 'NOK', '2023-05-01', 'b1cc06fc-a406-4d62-9f75-299603bbd216', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (611, 9, 273897, 1526.00, 'NOK', '2023-06-01', '5ac681af-0546-4eb0-b3c1-30bf1bb7a3ad', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (612, 9, 308359, 1502.00, 'NOK', '2023-07-01', '0e416492-6dc6-415e-9d07-634361b4bdc3', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (613, 9, 334627, 1532.00, 'NOK', '2023-08-01', '6fe95893-23c7-4e07-9be9-6aada2d08070', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (614, 9, 238182, 1393.00, 'NOK', '2023-09-01', '0e9918b7-7617-4aef-a0b4-a356d9f8bad3', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (615, 9, 186070, 1255.00, 'NOK', '2023-10-01', '5d5f57c9-6159-4af6-b4e4-3b9302479d3e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (616, 9, 177615, 1249.00, 'NOK', '2023-11-01', 'b837d7d0-7bc4-48bc-a37f-127439b110f6', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (617, 9, 145994, 1294.00, 'NOK', '2023-12-01', '82ec134e-847f-4447-8564-dcc96c0e1a45', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (618, 9, NULL, 1202.00, 'NOK', '2024-01-01', '76a8c0b0-6261-4301-8e57-36175d0e4590', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (619, 9, NULL, 1236.00, 'NOK', '2024-02-01', '7ba18565-a7d8-458b-b788-a97fd0ca19b7', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (620, 9, NULL, 1251.00, 'NOK', '2024-03-01', '634c1eff-8d4c-442c-b1c8-732bc8ee442f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (621, 9, NULL, 1285.00, 'NOK', '2024-04-01', 'e004a686-d2db-450c-92f7-6650e8d0422f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (622, 10, 75829, 861.00, 'NOK', '2016-01-01', '822d9397-531c-4647-85ce-ed27be1505e3', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (623, 10, 87081, 878.00, 'NOK', '2016-02-01', '713695e7-4a16-4223-a1b6-38fbd4436027', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (624, 10, 67625, 816.00, 'NOK', '2016-03-01', '67e6e1e7-5b3b-41f3-9ca0-a0858f217305', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (625, 10, 52406, 777.00, 'NOK', '2016-04-01', 'ddb305ea-0663-452f-9cfb-f3bbd6cda3a4', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (626, 10, 46535, 781.00, 'NOK', '2016-05-01', '7c303d84-f151-4cc5-969d-a2fd337ce6e7', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (627, 10, 76149, 823.00, 'NOK', '2016-06-01', '2a77ee1b-a8f7-4a4b-bccf-67697ff237dc', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (628, 10, 78406, 661.00, 'NOK', '2016-07-01', '89c14b55-9d98-4dfa-b9d5-89252b9540f0', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (629, 10, 65843, 680.00, 'NOK', '2016-08-01', 'db306811-80a0-41d0-8692-3737334163a3', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (630, 10, 58771, 805.00, 'NOK', '2016-09-01', 'a96f40a1-f6af-4277-ac3b-55506d504607', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (631, 10, 58670, 838.00, 'NOK', '2016-10-01', '28e59830-d782-465e-928d-241f997237d0', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (632, 10, 72740, 901.00, 'NOK', '2016-11-01', 'ccc205ae-e5f1-486e-b902-89ebfc87e46c', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (633, 10, 78067, 901.00, 'NOK', '2016-12-01', '32cd6ca4-f59b-4ab4-82df-a59f997d8b49', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (634, 10, 91313, 953.00, 'NOK', '2017-01-01', '14d15bc5-b425-454a-a0d9-05701df57dce', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (635, 10, 87370, 969.00, 'NOK', '2017-02-01', '4e112a53-d6a8-4ee4-90c0-a882202858aa', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (636, 10, 81727, 923.00, 'NOK', '2017-03-01', '8682fe0d-e016-47ff-9845-422cbab2820f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (637, 10, 40595, 834.00, 'NOK', '2017-04-01', 'afc1b7fb-377a-43e5-8fe3-cbfbfb44b34a', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (638, 10, 48866, 858.00, 'NOK', '2017-05-01', '6e2d5ca7-5724-4356-8183-a1131bc4d8a5', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (639, 10, 73185, 900.00, 'NOK', '2017-06-01', 'e5440511-c076-4981-87dd-0e5e13747269', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (640, 10, 70160, 725.00, 'NOK', '2017-07-01', '23ae8a04-5622-4630-9550-198227bb6f74', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (641, 10, 69330, 814.00, 'NOK', '2017-08-01', 'ebc626e6-7c03-4229-aeb1-88588f9a81ee', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (642, 10, 58691, 868.00, 'NOK', '2017-09-01', 'ac1deceb-8fe2-456c-aae8-ad0f72a39ed1', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (643, 10, 64462, 856.00, 'NOK', '2017-10-01', '27389117-ad63-407b-88f1-da196bb9cd9e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (644, 10, 74221, 932.00, 'NOK', '2017-11-01', 'e3016c5c-f668-4f14-9a94-4ac18e7c29ec', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (645, 10, 83139, 1017.00, 'NOK', '2017-12-01', '454ec111-4930-4ec6-a69f-b0cd1858523e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (646, 10, 91512, 1071.00, 'NOK', '2018-01-01', '7c618f2d-1e60-438f-9471-ada981def6f2', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (647, 10, 93875, 1096.00, 'NOK', '2018-02-01', 'a3a19c3f-cf1b-4907-baed-3e99ca7f6f11', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (648, 10, 77564, 992.00, 'NOK', '2018-03-01', '26b72452-5d76-4ea4-be67-6fc7cdcdb3cf', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (649, 10, 48284, 811.00, 'NOK', '2018-04-01', '4feadfde-2665-49c2-b419-cd52bff2e58d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (650, 10, 48395, 811.00, 'NOK', '2018-05-01', 'a0b7b827-b760-40d1-8637-760f8c3a8e2c', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (651, 10, 75928, 915.00, 'NOK', '2018-06-01', 'b55c17af-5c01-404b-ba3f-1d53a880d2bc', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (652, 10, 74093, 753.00, 'NOK', '2018-07-01', 'ff64f369-0f59-4013-9acd-eff3ee1e604b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (653, 10, 70026, 769.00, 'NOK', '2018-08-01', 'a571608f-71f7-4099-a470-128bcb64bf86', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (654, 10, 61954, 832.00, 'NOK', '2018-09-01', '780e733a-e714-4f7f-8d7a-794013c9dc3f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (655, 10, 71499, 873.00, 'NOK', '2018-10-01', '2c7cd636-2e26-42b0-b06d-4e41f8040911', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (656, 10, 80986, 956.00, 'NOK', '2018-11-01', 'eb3aa01e-c231-4ccc-91ff-36f5026e1f24', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (657, 10, 90071, 1050.00, 'NOK', '2018-12-01', '982c7f27-1a70-4a8b-8839-29d108e3efcd', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (658, 10, 92934, 1171.00, 'NOK', '2019-01-01', 'eac946ba-d8d6-41a9-8678-c43c852ae1f6', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (659, 10, 96183, 1257.00, 'NOK', '2019-02-01', 'dc20083b-dbde-4f94-99f7-72894afef7f6', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (660, 10, 87956, 1037.00, 'NOK', '2019-03-01', 'fe237fb4-d182-4f95-9aaf-5fe9b0f69399', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (661, 10, 45167, 795.00, 'NOK', '2019-04-01', '0aa53fc1-4af0-4f8a-9d06-553096649b59', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (662, 10, 47031, 815.00, 'NOK', '2019-05-01', 'a42753fa-095c-4e9c-b848-9955e27dc787', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (663, 10, 76603, 948.00, 'NOK', '2019-06-01', '26885af6-a482-4f85-9d6c-8f89269cefe9', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (664, 10, 84136, 829.00, 'NOK', '2019-07-01', '6bc152c6-c0b3-458a-b65e-962cf88fcf40', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (665, 10, 74820, 824.00, 'NOK', '2019-08-01', 'efcd621a-2c8f-44a0-acee-97c77d6b0da4', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (666, 10, 65021, 882.00, 'NOK', '2019-09-01', '95887b9f-cfa4-4a30-9ed6-ade12fd17039', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (667, 10, 78216, 921.00, 'NOK', '2019-10-01', '6a5b34ba-57d9-49dd-b589-92e73103c996', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (668, 10, 85495, 1039.00, 'NOK', '2019-11-01', 'aafccdcd-2997-42f2-ad6d-8ca6f4a6c04f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (669, 10, 91878, 1197.00, 'NOK', '2019-12-01', 'b441a2b7-c5b6-4363-9453-a62c68b2c00b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (670, 10, 96150, 1361.00, 'NOK', '2020-01-01', '5caf33bc-af13-47fc-95c3-054df9a374f4', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (671, 10, 101835, 1373.00, 'NOK', '2020-02-01', 'fbbbc445-2c86-481e-8fa3-3317970855af', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (672, 10, 0, 1150.00, 'NOK', '2020-03-01', '33f45c06-510c-4516-88fa-d93bb8ee4d2d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (673, 10, 0, 854.00, 'NOK', '2020-04-01', 'bf9c6a7a-47bc-41af-a0af-35fb7f860984', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (674, 10, 10761, 872.00, 'NOK', '2020-05-01', 'a6df6ea3-6955-4401-a7f3-410ef123481b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (675, 10, 29648, 906.00, 'NOK', '2020-06-01', 'c2bacd1a-54bd-41cc-8df4-75640cd6c539', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (676, 10, 65695, 870.00, 'NOK', '2020-07-01', 'ecef39d2-9a2d-4129-a3f8-5c28b7b99316', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (677, 10, 44191, 853.00, 'NOK', '2020-08-01', 'b0abd7c8-85a3-4d9b-850d-8ba79e099597', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (678, 10, 34845, 864.00, 'NOK', '2020-09-01', '87e0ddfb-8882-4e87-8972-8f931d0e9e20', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (679, 10, 39245, 863.00, 'NOK', '2020-10-01', '0e8a043e-34a9-47fa-8634-073a929c3509', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (680, 10, 0, 811.00, 'NOK', '2020-11-01', '601672ff-0389-4a35-99f8-8347da3da6df', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (681, 10, 0, 839.00, 'NOK', '2020-12-01', 'f0a35950-78e1-4957-aaf0-79b1c4adf96d', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (682, 10, 17443, 828.00, 'NOK', '2021-01-01', '57fb429f-10a8-4459-85d2-d48cbf8280be', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (683, 10, 22245, 840.00, 'NOK', '2021-02-01', '0a6fb622-facb-4888-824c-c6c73340b44e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (684, 10, 15421, 825.00, 'NOK', '2021-03-01', '6eac0685-1b21-4245-b0d2-b2901aaea65e', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (685, 10, 13414, 798.00, 'NOK', '2021-04-01', '170eab87-f717-41a3-a484-02b590606b3c', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (686, 10, 23984, 895.00, 'NOK', '2021-05-01', '6fe5ddbd-7c38-4cb6-815e-d6a0120af3d8', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (687, 10, 39568, 931.00, 'NOK', '2021-06-01', '3d5d4a56-4cfe-4479-b989-ef09be1615f0', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (688, 10, 58921, 916.00, 'NOK', '2021-07-01', 'a886ec8f-45d1-4089-ba73-c91abbf63b48', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (689, 10, 58245, 924.00, 'NOK', '2021-08-01', '2dfce764-a649-4f8f-8b83-5d15b1358c46', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (690, 10, 50565, 970.00, 'NOK', '2021-09-01', '78efb1c6-2d28-42e3-9ae8-5d4c4257c178', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (691, 10, 66049, 926.00, 'NOK', '2021-10-01', 'dab9af42-ed62-47c5-9e65-52a70122c9d8', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (692, 10, 62615, 1004.00, 'NOK', '2021-11-01', '96134ec7-5198-4244-b8e9-9bcf4db352c7', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (693, 10, 58375, 1170.00, 'NOK', '2021-12-01', 'dc4a8165-83f4-41af-9376-b7ea81df36cd', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (694, 10, 53443, 1075.00, 'NOK', '2022-01-01', '34434422-5995-421f-9a37-269f4a4cc567', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (695, 10, 75361, 1193.00, 'NOK', '2022-02-01', '56ff95f5-9dd2-4299-a01a-093aedff7458', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (696, 10, 76075, 1106.00, 'NOK', '2022-03-01', '749bcd9c-e7ec-425d-8225-85e5707deec8', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (697, 10, 43011, 971.00, 'NOK', '2022-04-01', '7e99f6e0-bc7b-4d95-a1f5-fe0c92895b83', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (698, 10, 51647, 994.00, 'NOK', '2022-05-01', '40f3a1a5-03e9-4427-8cce-8ef584a12a19', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (699, 10, 75241, 1103.00, 'NOK', '2022-06-01', 'cda3097a-3474-4cbd-bae4-f3c153b6a38a', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (700, 10, 66238, 999.00, 'NOK', '2022-07-01', 'c11dd610-0a70-4e90-a121-055e9784857f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (701, 10, 69597, 1015.00, 'NOK', '2022-08-01', 'd8191b9d-421b-4506-9be0-da35e96a6912', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (702, 10, 63766, 1055.00, 'NOK', '2022-09-01', '18d3f96a-f5f2-4d4d-b7ca-6d8b813897bf', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (703, 10, 72071, 1082.00, 'NOK', '2022-10-01', '1c82e4f2-c63b-4843-9555-7947f013e2e4', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (704, 10, 80225, 1284.00, 'NOK', '2022-11-01', '37b08cea-a2a3-4b2c-9b55-3488b7bce0b6', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (705, 10, 90728, 1519.00, 'NOK', '2022-12-01', '096b7e0a-e98e-443c-86d2-faa72cd0f0d0', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (706, 10, 92654, 1581.00, 'NOK', '2023-01-01', '4f25d986-9fd8-47fc-bc0b-343ba2eca31c', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (707, 10, 87788, 1653.00, 'NOK', '2023-02-01', '5e4afa03-f5c4-4a00-8095-2676921b80a3', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (708, 10, 79996, 1486.00, 'NOK', '2023-03-01', 'c4091c25-ba5e-4fba-bbbd-9b2c7dbd012c', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (709, 10, 41682, 1121.00, 'NOK', '2023-04-01', 'f910a3fd-7bb9-4138-b39c-725650e25b8a', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (710, 10, 41951, 1071.00, 'NOK', '2023-05-01', '06f509db-5aa7-4d8c-990d-68d6c077df18', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (711, 10, 70959, 1190.00, 'NOK', '2023-06-01', '326a44d5-2dfd-4822-871c-667fb905922b', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (712, 10, 70230, 1008.00, 'NOK', '2023-07-01', 'ce44036d-791a-4b71-9e8e-ac4e8dd7255f', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (713, 10, 69649, 1115.00, 'NOK', '2023-08-01', '3c50b715-abf0-4694-b2f0-54911ca80803', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (714, 10, 58631, 1163.00, 'NOK', '2023-09-01', '6946a7d1-d6f9-459d-84ed-3c99c253f837', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (715, 10, 70536, 1216.00, 'NOK', '2023-10-01', '2d6a1d80-fcb5-43b3-9ac5-8180badf78b4', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (716, 10, 80432, 1484.00, 'NOK', '2023-11-01', 'b3ee4a8c-ccaf-4266-a3e1-f50100531639', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (717, 10, 95456, 1853.00, 'NOK', '2023-12-01', '92723af1-41a6-4256-8a4f-6a25daf95ce8', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (718, 10, NULL, 1943.00, 'NOK', '2024-01-01', 'e5f0f867-3b9e-48af-badf-d8accb9d1494', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (719, 10, NULL, 2012.00, 'NOK', '2024-02-01', '846d9c6c-87d8-4c2d-a76f-49374c9f4b23', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (720, 10, NULL, 1767.00, 'NOK', '2024-03-01', 'dfb8ffad-6b37-4305-9c1f-e534b40d2845', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (721, 10, NULL, 1108.00, 'NOK', '2024-04-01', 'c97cec27-8171-4d18-baeb-be2a214f3797', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (722, 3, 192574, 273.00, 'EUR', '2026-06-01', 'bcdfb887-aaec-4238-8e5c-4c3a9407e5ba', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (723, 4, 269246, 172.00, 'EUR', '2026-06-01', '49ab7bc5-853d-4cb8-b277-dba5939d5509', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (724, 11, 190739, 279.00, 'EUR', '2026-06-01', '3b2bc3bf-618e-42a4-9f01-6c70995da30d', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (725, 12, 273799, 288.00, 'EUR', '2026-06-01', '7dfd1f8a-5aa0-4baf-bf1e-07add0f980f8', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (726, 13, 162248, 277.00, 'EUR', '2026-06-01', '1120c977-ff8d-4a15-9f3d-9392e6658cc8', false, 4);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (727, 8, 185358, 256.00, 'EUR', '2026-06-01', '5e7ca26a-8a63-4468-8456-de6dc024b121', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (728, 9, 207262, 240.00, 'EUR', '2026-06-01', '236ec2bb-a8e0-45ee-b171-c4a9c3b6c6a2', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (729, 10, 206120, 155.00, 'EUR', '2026-06-01', '1812dc4e-f41f-43a7-a3ce-5a21164aa211', false, 6);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (730, 5, 259594, 240.00, 'EUR', '2026-06-01', '44b5cb8b-91f2-489e-bd58-3d156c7aa4cc', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (731, 6, 263480, 297.00, 'EUR', '2026-06-01', '8f7903de-101b-4f56-ae10-ec446dfd0fc9', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (732, 7, 278486, 222.00, 'EUR', '2026-06-01', '34451071-77a1-4ac4-9df2-13c8945ecdcf', false, 2);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (733, 1, 171345, 195.00, 'EUR', '2026-06-01', '922219ed-7dab-4848-955e-2d8bf70825cf', false, 1);
INSERT INTO public.tourism_metrics OVERRIDING SYSTEM VALUE VALUES (734, 2, 292756, 282.00, 'EUR', '2026-06-01', 'b15486a0-2361-4b67-94f3-b7818b78d5d5', false, 1);


--
-- TOC entry 4974 (class 0 OID 425734)
-- Dependencies: 219
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 222
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cities_id_seq', 13, true);


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 220
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.countries_id_seq', 6, true);


--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 224
-- Name: exchange_rates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.exchange_rates_id_seq', 113, true);


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 230
-- Name: forecasts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.forecasts_id_seq', 10920, true);


--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 226
-- Name: inflation_rates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inflation_rates_id_seq', 16, true);


--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 216
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, false);


--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 228
-- Name: tourism_metrics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tourism_metrics_id_seq', 734, true);


--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 218
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 4798 (class 2606 OID 425938)
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- TOC entry 4793 (class 2606 OID 425757)
-- Name: countries countries_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_code_key UNIQUE (code);


--
-- TOC entry 4795 (class 2606 OID 425930)
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- TOC entry 4801 (class 2606 OID 425945)
-- Name: exchange_rates exchange_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exchange_rates
    ADD CONSTRAINT exchange_rates_pkey PRIMARY KEY (id);


--
-- TOC entry 4816 (class 2606 OID 425972)
-- Name: forecasts forecasts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forecasts
    ADD CONSTRAINT forecasts_pkey PRIMARY KEY (id);


--
-- TOC entry 4806 (class 2606 OID 425954)
-- Name: inflation_rates inflation_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inflation_rates
    ADD CONSTRAINT inflation_rates_pkey PRIMARY KEY (id);


--
-- TOC entry 4781 (class 2606 OID 425732)
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- TOC entry 4783 (class 2606 OID 425913)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4813 (class 2606 OID 425963)
-- Name: tourism_metrics tourism_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tourism_metrics
    ADD CONSTRAINT tourism_metrics_pkey PRIMARY KEY (id);


--
-- TOC entry 4786 (class 2606 OID 425744)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4788 (class 2606 OID 425921)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4790 (class 2606 OID 425742)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4802 (class 1259 OID 425990)
-- Name: ix_exchange_rates_country_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_exchange_rates_country_date ON public.exchange_rates USING btree (country_id, date_recorded);


--
-- TOC entry 4803 (class 1259 OID 425819)
-- Name: ix_exchange_rates_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_exchange_rates_date ON public.exchange_rates USING btree (date_recorded);


--
-- TOC entry 4817 (class 1259 OID 426011)
-- Name: ix_forecasts_city_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_forecasts_city_date ON public.forecasts USING btree (city_id, forecast_date);


--
-- TOC entry 4818 (class 1259 OID 426019)
-- Name: ix_forecasts_country_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_forecasts_country_date ON public.forecasts USING btree (country_id, forecast_date);


--
-- TOC entry 4819 (class 1259 OID 425822)
-- Name: ix_forecasts_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_forecasts_date ON public.forecasts USING btree (forecast_date);


--
-- TOC entry 4807 (class 1259 OID 425997)
-- Name: ix_inflation_rates_country_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_inflation_rates_country_date ON public.inflation_rates USING btree (country_id, date_recorded);


--
-- TOC entry 4808 (class 1259 OID 425820)
-- Name: ix_inflation_rates_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_inflation_rates_date ON public.inflation_rates USING btree (date_recorded);


--
-- TOC entry 4810 (class 1259 OID 426004)
-- Name: ix_tourism_metrics_city_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_tourism_metrics_city_date ON public.tourism_metrics USING btree (city_id, date_recorded);


--
-- TOC entry 4811 (class 1259 OID 425821)
-- Name: ix_tourism_metrics_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_tourism_metrics_date ON public.tourism_metrics USING btree (date_recorded);


--
-- TOC entry 4799 (class 1259 OID 426082)
-- Name: ux_cities_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_cities_guid ON public.cities USING btree (guid);


--
-- TOC entry 4796 (class 1259 OID 426081)
-- Name: ux_countries_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_countries_guid ON public.countries USING btree (guid);


--
-- TOC entry 4804 (class 1259 OID 426083)
-- Name: ux_exchange_rates_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_exchange_rates_guid ON public.exchange_rates USING btree (guid);


--
-- TOC entry 4820 (class 1259 OID 426086)
-- Name: ux_forecasts_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_forecasts_guid ON public.forecasts USING btree (guid);


--
-- TOC entry 4809 (class 1259 OID 426084)
-- Name: ux_inflation_rates_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_inflation_rates_guid ON public.inflation_rates USING btree (guid);


--
-- TOC entry 4784 (class 1259 OID 426079)
-- Name: ux_roles_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_roles_guid ON public.roles USING btree (guid);


--
-- TOC entry 4814 (class 1259 OID 426085)
-- Name: ux_tourism_metrics_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_tourism_metrics_guid ON public.tourism_metrics USING btree (guid);


--
-- TOC entry 4791 (class 1259 OID 426080)
-- Name: ux_users_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_users_guid ON public.users USING btree (guid);


--
-- TOC entry 4822 (class 2606 OID 426092)
-- Name: cities fk_cities_countries; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT fk_cities_countries FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- TOC entry 4823 (class 2606 OID 426097)
-- Name: exchange_rates fk_exchange_rates_countries; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exchange_rates
    ADD CONSTRAINT fk_exchange_rates_countries FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- TOC entry 4826 (class 2606 OID 426112)
-- Name: forecasts fk_forecasts_cities; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forecasts
    ADD CONSTRAINT fk_forecasts_cities FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- TOC entry 4827 (class 2606 OID 426117)
-- Name: forecasts fk_forecasts_countries; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forecasts
    ADD CONSTRAINT fk_forecasts_countries FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- TOC entry 4824 (class 2606 OID 426102)
-- Name: inflation_rates fk_inflation_rates_countries; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inflation_rates
    ADD CONSTRAINT fk_inflation_rates_countries FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- TOC entry 4825 (class 2606 OID 426107)
-- Name: tourism_metrics fk_tourism_metrics_cities; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tourism_metrics
    ADD CONSTRAINT fk_tourism_metrics_cities FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- TOC entry 4821 (class 2606 OID 426087)
-- Name: users fk_users_roles; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_roles FOREIGN KEY (role_id) REFERENCES public.roles(id);


-- Completed on 2026-06-04 17:12:53

--
-- PostgreSQL database dump complete
--

