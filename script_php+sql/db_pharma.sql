--
-- PostgreSQL database dump
--

-- Dumped from database version 10.9 (Ubuntu 10.9-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.9 (Ubuntu 10.9-0ubuntu0.18.04.1)

-- Started on 2019-07-05 00:26:01 +07

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
-- TOC entry 1 (class 3079 OID 13173)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 4520 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 2 (class 3079 OID 24981)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 4521 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- TOC entry 1433 (class 1255 OID 26543)
-- Name: getnearpharmacies(double precision, double precision); Type: FUNCTION; Schema: public; Owner: basile
--

CREATE FUNCTION public.getnearpharmacies(double precision, double precision) RETURNS TABLE(nompharma character varying, geom public.geometry)
    LANGUAGE plpgsql
    AS $_$
BEGIN
      RETURN QUERY SELECT p.nompharma, ST_X(p.geom) AS latitude , ST_Y(p.geom) AS longitude
    FROM pharmacie_view p, garde g
    WHERE ST_DWithin (p.geom, ST_GeomFromText('POINT($1 $2)', 4326), 5)
          AND p.idpharma=g.idpharma AND g.date_fin<CURRENT_DATE AND g.date_debut>CURRENT_DATE
    LIMIT 20;
END; $_$;


ALTER FUNCTION public.getnearpharmacies(double precision, double precision) OWNER TO basile;

--
-- TOC entry 212 (class 1259 OID 26518)
-- Name: pharmacie_id_seq; Type: SEQUENCE; Schema: public; Owner: basile
--

CREATE SEQUENCE public.pharmacie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pharmacie_id_seq OWNER TO basile;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 213 (class 1259 OID 26520)
-- Name: pharmacie; Type: TABLE; Schema: public; Owner: basile
--

CREATE TABLE public.pharmacie (
    idpharma integer DEFAULT nextval('public.pharmacie_id_seq'::regclass) NOT NULL,
    nompharma character varying(255) NOT NULL,
    addrpharma text,
    telpharma character varying(255),
    etat integer,
    geom public.geometry(Point,4326)
);


ALTER TABLE public.pharmacie OWNER TO basile;

--
-- TOC entry 214 (class 1259 OID 26529)
-- Name: pharmacie_view; Type: VIEW; Schema: public; Owner: basile
--

CREATE VIEW public.pharmacie_view AS
 SELECT p.idpharma,
    p.nompharma,
    p.addrpharma,
    p.telpharma,
    p.etat,
    public.st_x(public.st_transform(p.geom, 4674)) AS longitude,
    public.st_y(public.st_transform(p.geom, 4674)) AS latitude
   FROM public.pharmacie p;


ALTER TABLE public.pharmacie_view OWNER TO basile;

--
-- TOC entry 1432 (class 1255 OID 26541)
-- Name: getpharmacie(integer); Type: FUNCTION; Schema: public; Owner: basile
--

CREATE FUNCTION public.getpharmacie(integer) RETURNS public.pharmacie_view
    LANGUAGE plpgsql
    AS $_$
BEGIN
    SELECT * FROM pharmacie_view WHERE idpharma = $1;
END; $_$;


ALTER FUNCTION public.getpharmacie(integer) OWNER TO basile;

--
-- TOC entry 215 (class 1259 OID 26533)
-- Name: categ_id_seq; Type: SEQUENCE; Schema: public; Owner: basile
--

CREATE SEQUENCE public.categ_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categ_id_seq OWNER TO basile;

--
-- TOC entry 216 (class 1259 OID 26535)
-- Name: categorie; Type: TABLE; Schema: public; Owner: basile
--

CREATE TABLE public.categorie (
    idcateg integer DEFAULT nextval('public.categ_id_seq'::regclass) NOT NULL,
    nomcateg character varying(255) NOT NULL
);


ALTER TABLE public.categorie OWNER TO basile;

--
-- TOC entry 217 (class 1259 OID 26544)
-- Name: garde_id_seq; Type: SEQUENCE; Schema: public; Owner: basile
--

CREATE SEQUENCE public.garde_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.garde_id_seq OWNER TO basile;

--
-- TOC entry 218 (class 1259 OID 26546)
-- Name: garde; Type: TABLE; Schema: public; Owner: basile
--

CREATE TABLE public.garde (
    idgarde integer DEFAULT nextval('public.garde_id_seq'::regclass) NOT NULL,
    date_debut date NOT NULL,
    date_fin date,
    idpharma integer
);


ALTER TABLE public.garde OWNER TO basile;

--
-- TOC entry 4510 (class 0 OID 26535)
-- Dependencies: 216
-- Data for Name: categorie; Type: TABLE DATA; Schema: public; Owner: basile
--

COPY public.categorie (idcateg, nomcateg) FROM stdin;
1	Moderne
2	Traditionelle
\.


--
-- TOC entry 4512 (class 0 OID 26546)
-- Dependencies: 218
-- Data for Name: garde; Type: TABLE DATA; Schema: public; Owner: basile
--

COPY public.garde (idgarde, date_debut, date_fin, idpharma) FROM stdin;
1	2019-06-28	2019-07-06	2
3	2019-06-28	2019-07-06	4
2	2019-06-28	2092019-07-06	3
\.


--
-- TOC entry 4508 (class 0 OID 26520)
-- Dependencies: 213
-- Data for Name: pharmacie; Type: TABLE DATA; Schema: public; Owner: basile
--

COPY public.pharmacie (idpharma, nompharma, addrpharma, telpharma, etat, geom) FROM stdin;
2	Vietnam Sport Hopital	Rue de hopital sport	0865786431	\N	0101000020E6100000D9CEF753E305354029CB10C7BA705A40
3	Pharmacy Nam Tu Liem District	Rue Pharmacy Nam Tu Liem District	0865786431	\N	0101000020E6100000D9CEF753E305354029CB10C7BA705A40
4	PharmacyCau Giay District	Rue PharmacyCau Giay District	0865786431	\N	0101000020E61000001283C0CAA1053540B81E85EB51725A40
5	Phòng Khám Đa Khoa District	Rue Phòng Khám Đa Khoa District	0865786431	\N	0101000020E61000001283C0CAA1053540FFCA4A9352725A40
\.


--
-- TOC entry 4365 (class 0 OID 25290)
-- Dependencies: 198
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- TOC entry 4522 (class 0 OID 0)
-- Dependencies: 215
-- Name: categ_id_seq; Type: SEQUENCE SET; Schema: public; Owner: basile
--

SELECT pg_catalog.setval('public.categ_id_seq', 2, true);


--
-- TOC entry 4523 (class 0 OID 0)
-- Dependencies: 217
-- Name: garde_id_seq; Type: SEQUENCE SET; Schema: public; Owner: basile
--

SELECT pg_catalog.setval('public.garde_id_seq', 1, false);


--
-- TOC entry 4524 (class 0 OID 0)
-- Dependencies: 212
-- Name: pharmacie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: basile
--

SELECT pg_catalog.setval('public.pharmacie_id_seq', 5, true);


--
-- TOC entry 4374 (class 2606 OID 26540)
-- Name: categorie categorie_pkey; Type: CONSTRAINT; Schema: public; Owner: basile
--

ALTER TABLE ONLY public.categorie
    ADD CONSTRAINT categorie_pkey PRIMARY KEY (idcateg);


--
-- TOC entry 4376 (class 2606 OID 26551)
-- Name: garde garde_pkey; Type: CONSTRAINT; Schema: public; Owner: basile
--

ALTER TABLE ONLY public.garde
    ADD CONSTRAINT garde_pkey PRIMARY KEY (idgarde);


--
-- TOC entry 4372 (class 2606 OID 26528)
-- Name: pharmacie pharmacie_pkey; Type: CONSTRAINT; Schema: public; Owner: basile
--

ALTER TABLE ONLY public.pharmacie
    ADD CONSTRAINT pharmacie_pkey PRIMARY KEY (idpharma);


--
-- TOC entry 4370 (class 1259 OID 26542)
-- Name: idx_pharmacie_geom; Type: INDEX; Schema: public; Owner: basile
--

CREATE INDEX idx_pharmacie_geom ON public.pharmacie USING btree (geom);


--
-- TOC entry 4377 (class 2606 OID 26552)
-- Name: garde fk_garde_id_pharma; Type: FK CONSTRAINT; Schema: public; Owner: basile
--

ALTER TABLE ONLY public.garde
    ADD CONSTRAINT fk_garde_id_pharma FOREIGN KEY (idpharma) REFERENCES public.pharmacie(idpharma) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2019-07-05 00:26:04 +07

--
-- PostgreSQL database dump complete
--

