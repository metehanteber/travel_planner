--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2026-06-04 17:30:14

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

INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (14, 7, 'İzmir', '0efe3d54-69a3-4e4b-9588-f4e240aa520e', false, NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (15, 7, 'Kapadokya', 'c386db35-ab6a-404d-a1f6-d80fb0902d46', false, NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (16, 7, 'İstanbul', '04ea0dae-61e7-4c2c-aeb1-1e3945b9aae7', false, 'TR10');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (17, 7, 'Antalya', '9df051f7-e65a-4378-9f38-d50d9696ef87', false, 'TR61');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (18, 10, 'Moskova', '0480a277-d605-4163-9266-30bde29dbb98', false, NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (19, 10, 'St. Petersburg', '834211e4-ef36-4c63-983c-0085c98dcabe', false, NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (20, 10, 'Soçi', '9ea9cccc-55ad-4e58-b7bc-8f084eab13ae', false, NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (21, 8, 'Oslo', '3581b4a6-a8a4-41a6-9034-d5ad16baa659', false, '03101 03');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (22, 8, 'Bergen', 'dbb71da3-86ec-478d-b589-a54ec6f78003', false, '46101 46');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (23, 8, 'Tromsø', '8298edad-3de3-46db-b5ac-837e35cad87f', false, '54101 55');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (24, 9, 'Madrid', '8067d55f-9402-44a9-a1bf-560a6705fcd3', false, '29 9009');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (25, 9, 'Barselona', '6f3aad50-d922-4221-a9a6-6ca356931181', false, '9 9005');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (26, 9, 'İbiza', 'b6f3f0cd-3050-40e6-b247-0506ac4d7fc6', false, '8 9000');


--
-- TOC entry 4976 (class 0 OID 425751)
-- Dependencies: 221
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (7, 'Türkiye', 'TR', '509266b2-0d19-4a66-9d67-e58ed133b75f', false, 'TRY');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (8, 'Norveç', 'NO', '64c7f816-db9a-4a6e-bf88-555ab695ce60', false, 'NOK');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (9, 'İspanya', 'ES', '63e0b713-1faa-4c68-bb4a-bb3c05f4e2e3', false, 'EUR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (10, 'Rusya', 'RU', 'cb18ddc5-59b9-41f2-a508-7dd4833a8fee', false, 'RUB');


--
-- TOC entry 4980 (class 0 OID 425770)
-- Dependencies: 225
-- Data for Name: exchange_rates; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4986 (class 0 OID 425803)
-- Dependencies: 231
-- Data for Name: forecasts; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4982 (class 0 OID 425781)
-- Dependencies: 227
-- Data for Name: inflation_rates; Type: TABLE DATA; Schema: public; Owner: -
--



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

SELECT pg_catalog.setval('public.cities_id_seq', 26, true);


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 220
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.countries_id_seq', 10, true);


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


-- Completed on 2026-06-04 17:30:14

--
-- PostgreSQL database dump complete
--

