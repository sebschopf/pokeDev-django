--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Debian 16.8-1.pgdg120+1)
-- Dumped by pg_dump version 17.4

-- Started on 2025-05-27 03:58:38

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
-- TOC entry 9 (class 2615 OID 16564)
-- Name: auth; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 16565)
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- TOC entry 11 (class 2615 OID 16566)
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO postgres;

--
-- TOC entry 12 (class 2615 OID 16567)
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO postgres;

--
-- TOC entry 13 (class 2615 OID 16568)
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO postgres;

--
-- TOC entry 14 (class 2615 OID 16569)
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO postgres;

--
-- TOC entry 15 (class 2615 OID 16570)
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO postgres;

--
-- TOC entry 16 (class 2615 OID 16571)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO postgres;

--
-- TOC entry 17 (class 2615 OID 16572)
-- Name: vault; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 16573)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- TOC entry 4614 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 3 (class 3079 OID 16604)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- TOC entry 4615 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 4 (class 3079 OID 16641)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- TOC entry 4616 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1142 (class 1247 OID 16653)
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: postgres
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO postgres;

--
-- TOC entry 1145 (class 1247 OID 16660)
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: postgres
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO postgres;

--
-- TOC entry 1148 (class 1247 OID 16666)
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: postgres
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO postgres;

--
-- TOC entry 1151 (class 1247 OID 16672)
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: postgres
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO postgres;

--
-- TOC entry 1154 (class 1247 OID 16680)
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: postgres
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO postgres;

--
-- TOC entry 1157 (class 1247 OID 16694)
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'admin',
    'validator',
    'verified',
    'registered'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- TOC entry 1160 (class 1247 OID 16704)
-- Name: action; Type: TYPE; Schema: realtime; Owner: postgres
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO postgres;

--
-- TOC entry 1163 (class 1247 OID 16716)
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: postgres
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO postgres;

--
-- TOC entry 1166 (class 1247 OID 16733)
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: postgres
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO postgres;

--
-- TOC entry 1169 (class 1247 OID 16736)
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: postgres
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO postgres;

--
-- TOC entry 1172 (class 1247 OID 16739)
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: postgres
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO postgres;

--
-- TOC entry 478 (class 1255 OID 16740)
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO postgres;

--
-- TOC entry 4617 (class 0 OID 0)
-- Dependencies: 478
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- TOC entry 447 (class 1255 OID 16741)
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO postgres;

--
-- TOC entry 421 (class 1255 OID 16742)
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO postgres;

--
-- TOC entry 4618 (class 0 OID 0)
-- Dependencies: 421
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- TOC entry 448 (class 1255 OID 16743)
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO postgres;

--
-- TOC entry 4619 (class 0 OID 0)
-- Dependencies: 448
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- TOC entry 475 (class 1255 OID 16744)
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- TOC entry 4620 (class 0 OID 0)
-- Dependencies: 475
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- TOC entry 390 (class 1255 OID 16745)
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO postgres;

--
-- TOC entry 4621 (class 0 OID 0)
-- Dependencies: 390
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- TOC entry 435 (class 1255 OID 16746)
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- TOC entry 4623 (class 0 OID 0)
-- Dependencies: 435
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- TOC entry 476 (class 1255 OID 16747)
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO postgres;

--
-- TOC entry 401 (class 1255 OID 16748)
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO postgres;

--
-- TOC entry 409 (class 1255 OID 16749)
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO postgres;

--
-- TOC entry 4626 (class 0 OID 0)
-- Dependencies: 409
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- TOC entry 398 (class 1255 OID 16750)
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

--
-- TOC entry 417 (class 1255 OID 18286)
-- Name: add_language_feature(integer, text, text, text, text, boolean, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_language_feature(p_language_id integer, p_feature_name text, p_feature_slug text, p_feature_type text, p_value text, p_is_primary boolean, p_source_url text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_feature_id INTEGER;
    v_language_feature_id INTEGER;
BEGIN
    -- Vérifier si la caractéristique existe déjà
    SELECT id INTO v_feature_id FROM features 
    WHERE slug = p_feature_slug;
    
    -- Si la caractéristique n'existe pas, la créer
    IF v_feature_id IS NULL THEN
        INSERT INTO features (name, slug, feature_type)
        VALUES (p_feature_name, p_feature_slug, p_feature_type)
        RETURNING id INTO v_feature_id;
    END IF;
    
    -- Vérifier si l'association langage-caractéristique existe déjà
    SELECT id INTO v_language_feature_id FROM language_features
    WHERE language_id = p_language_id AND feature_id = v_feature_id;
    
    -- Si l'association n'existe pas, la créer
    IF v_language_feature_id IS NULL THEN
        INSERT INTO language_features (
            language_id, 
            feature_id, 
            value, 
            is_primary, 
            source_url
        )
        VALUES (
            p_language_id, 
            v_feature_id, 
            p_value, 
            p_is_primary, 
            p_source_url
        )
        RETURNING id INTO v_language_feature_id;
        
        RETURN v_language_feature_id;
    ELSE
        -- Mettre à jour l'association existante
        UPDATE language_features
        SET 
            value = p_value,
            is_primary = p_is_primary,
            source_url = p_source_url
        WHERE id = v_language_feature_id;
        
        RETURN v_language_feature_id;
    END IF;
END;
$$;


ALTER FUNCTION public.add_language_feature(p_language_id integer, p_feature_name text, p_feature_slug text, p_feature_type text, p_value text, p_is_primary boolean, p_source_url text) OWNER TO postgres;

--
-- TOC entry 456 (class 1255 OID 18282)
-- Name: add_language_feature(text, text, text, boolean, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_language_feature(lang_name text, feature_slug text, feature_value text, is_primary_feature boolean DEFAULT true, source_url_value text DEFAULT NULL::text, feature_name text DEFAULT NULL::text, feature_type text DEFAULT 'technical'::text, feature_description text DEFAULT NULL::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    lang_id INTEGER;
    feat_id INTEGER;
BEGIN
    -- Récupérer l'ID du langage
    SELECT id INTO lang_id FROM languages WHERE name = lang_name;
    
    IF lang_id IS NULL THEN
        RAISE EXCEPTION 'Langage % non trouvé dans la base de données', lang_name;
    END IF;
    
    -- Vérifier si la caractéristique existe, sinon la créer
    SELECT id INTO feat_id FROM features WHERE slug = feature_slug;
    
    IF feat_id IS NULL AND feature_name IS NOT NULL THEN
        INSERT INTO features (name, slug, feature_type, description)
        VALUES (feature_name, feature_slug, feature_type, COALESCE(feature_description, feature_name))
        RETURNING id INTO feat_id;
    ELSIF feat_id IS NULL THEN
        RAISE EXCEPTION 'Caractéristique % non trouvée et nom non fourni pour la créer', feature_slug;
    END IF;
    
    -- Vérifier si cette combinaison langage/caractéristique/valeur existe déjà
    IF NOT EXISTS (SELECT 1 FROM language_features 
                  WHERE language_id = lang_id AND feature_id = feat_id AND value = feature_value) THEN
        INSERT INTO language_features (language_id, feature_id, value, is_primary, source_url)
        VALUES (lang_id, feat_id, feature_value, is_primary_feature, source_url_value);
        
        RAISE NOTICE 'Ajouté: % - % - %', lang_name, feature_slug, feature_value;
    ELSE
        RAISE NOTICE 'Déjà existant: % - % - %', lang_name, feature_slug, feature_value;
    END IF;
END;
$$;


ALTER FUNCTION public.add_language_feature(lang_name text, feature_slug text, feature_value text, is_primary_feature boolean, source_url_value text, feature_name text, feature_type text, feature_description text) OWNER TO postgres;

--
-- TOC entry 433 (class 1255 OID 16751)
-- Name: create_security_logs_table(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_security_logs_table() RETURNS void
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  -- Vérifier si la table existe déjà
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'security_logs'
  ) THEN
    -- Créer la table
    CREATE TABLE public.security_logs (
      id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      event_type TEXT NOT NULL,
      user_id UUID,
      ip_address TEXT,
      user_agent TEXT,
      path TEXT,
      details TEXT,
      severity TEXT NOT NULL,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );
    
    -- Ajouter des index pour améliorer les performances des requêtes
    CREATE INDEX idx_security_logs_event_type ON public.security_logs(event_type);
    CREATE INDEX idx_security_logs_user_id ON public.security_logs(user_id);
    CREATE INDEX idx_security_logs_created_at ON public.security_logs(created_at);
    
    -- Ajouter une politique RLS pour restreindre l'accès
    ALTER TABLE public.security_logs ENABLE ROW LEVEL SECURITY;
    
    -- Seuls les administrateurs peuvent voir les logs
    CREATE POLICY "Admins can view security logs" 
      ON public.security_logs 
      FOR SELECT 
      USING (
        auth.uid() IN (
          SELECT id FROM public.user_roles WHERE role = 'admin'
        )
      );
  END IF;
END;
$$;


ALTER FUNCTION public.create_security_logs_table() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 255 (class 1259 OID 16752)
-- Name: todos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.todos (
    id integer NOT NULL,
    title text NOT NULL,
    description text,
    status_id integer,
    category_id integer,
    user_id uuid,
    is_completed boolean DEFAULT false,
    due_date timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.todos OWNER TO postgres;

--
-- TOC entry 388 (class 1255 OID 16760)
-- Name: create_user_todos(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user_todos(user_uuid uuid) RETURNS SETOF public.todos
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE
  todo_id INT;
  category_id INT;
BEGIN
  -- Vérifier si l'utilisateur existe
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE id = user_uuid) THEN
    RAISE EXCEPTION 'Utilisateur non trouvé';
  END IF;

  -- Récupérer une catégorie par défaut (ou en créer une si nécessaire)
  SELECT id INTO category_id FROM todo_categories LIMIT 1;
  
  IF category_id IS NULL THEN
    INSERT INTO todo_categories (name, color) 
    VALUES ('Général', '#3b82f6') 
    RETURNING id INTO category_id;
  END IF;

  -- Créer des tâches par défaut pour l'utilisateur
  INSERT INTO todos (title, description, category_id, user_id, is_completed, created_at, updated_at)
  VALUES 
    ('Découvrir un nouveau langage', 'Explorer un langage de programmation que vous n''avez jamais utilisé', category_id, user_uuid, false, NOW(), NOW()),
    ('Contribuer au Pokedex', 'Ajouter une suggestion ou une correction à un langage existant', category_id, user_uuid, false, NOW(), NOW()),
    ('Proposer un nouveau langage', 'Soumettre un langage qui n''est pas encore dans le Pokedex', category_id, user_uuid, false, NOW(), NOW())
  RETURNING *;

  RETURN;
END;
$$;


ALTER FUNCTION public.create_user_todos(user_uuid uuid) OWNER TO postgres;

--
-- TOC entry 4628 (class 0 OID 0)
-- Dependencies: 388
-- Name: FUNCTION create_user_todos(user_uuid uuid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.create_user_todos(user_uuid uuid) IS 'Crée des tâches par défaut pour un utilisateur donné';


--
-- TOC entry 406 (class 1255 OID 18289)
-- Name: generate_database_structure(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_database_structure() RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    result json;
    tables_jsonb jsonb := '{}'::jsonb;
    table_record record;
    table_json json;
    columns_json json;
    primary_keys_json json;
    foreign_keys_json json;
    sample_data_json json;
    sample_query text;
BEGIN
    -- Pour chaque table dans le schéma public
    FOR table_record IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_type = 'BASE TABLE'
    LOOP
        -- Obtenir les colonnes
        SELECT json_agg(json_build_object(
            'name', column_name,
            'type', data_type,
            'nullable', is_nullable = 'YES'
        ) ORDER BY ordinal_position)
        INTO columns_json
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = table_record.table_name;
        
        -- Obtenir les clés primaires
        SELECT json_agg(tc.column_name)
        INTO primary_keys_json
        FROM information_schema.table_constraints AS tcon
        JOIN information_schema.key_column_usage AS tc
        ON tcon.constraint_name = tc.constraint_name
        WHERE tcon.constraint_type = 'PRIMARY KEY'
        AND tcon.table_schema = 'public'
        AND tcon.table_name = table_record.table_name;
        
        -- Obtenir les clés étrangères
        SELECT json_agg(
            json_build_object(
                'column_name', kcu.column_name,
                'foreign_table_name', ccu.table_name,
                'foreign_column_name', ccu.column_name
            )
        )
        INTO foreign_keys_json
        FROM information_schema.table_constraints AS tc
        JOIN information_schema.key_column_usage AS kcu
        ON tc.constraint_name = kcu.constraint_name
        JOIN information_schema.constraint_column_usage AS ccu
        ON ccu.constraint_name = tc.constraint_name
        WHERE tc.constraint_type = 'FOREIGN KEY'
        AND tc.table_schema = 'public'
        AND tc.table_name = table_record.table_name;
        
        -- Essayer d'obtenir un échantillon de données
        BEGIN
            sample_query := 'SELECT json_agg(row_to_json(t)) FROM (SELECT * FROM ' || 
                            quote_ident(table_record.table_name) || ' LIMIT 5) t';
            EXECUTE sample_query INTO sample_data_json;
        EXCEPTION WHEN OTHERS THEN
            sample_data_json := '[]'::json;
        END;
        
        -- Construire l'objet JSON pour cette table
        table_json = json_build_object(
            'columns', COALESCE(columns_json, '[]'::json),
            'primary_keys', COALESCE(primary_keys_json, '[]'::json),
            'foreign_keys', COALESCE(foreign_keys_json, '[]'::json),
            'sample_data', COALESCE(sample_data_json, '[]'::json)
        );
        
        -- Ajouter cette table au résultat en utilisant jsonb_set
        tables_jsonb = jsonb_set(
            tables_jsonb, 
            ARRAY[table_record.table_name], 
            to_jsonb(table_json)
        );
    END LOOP;
    
    -- Construire le résultat final
    result = json_build_object(
        'database_name', current_database(),
        'schema', 'public',
        'tables', tables_jsonb
    );
    
    RETURN result;
END;
$$;


ALTER FUNCTION public.generate_database_structure() OWNER TO postgres;

--
-- TOC entry 477 (class 1255 OID 16761)
-- Name: get_user_role(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_role() RETURNS public.user_role
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT role FROM user_roles WHERE id = auth.uid();
$$;


ALTER FUNCTION public.get_user_role() OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 16762)
-- Name: sessions; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO postgres;

--
-- TOC entry 4629 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- TOC entry 4630 (class 0 OID 0)
-- Dependencies: 256
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- TOC entry 442 (class 1255 OID 16767)
-- Name: get_user_sessions(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_sessions(user_id uuid) RETURNS SETOF auth.sessions
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  SELECT * FROM auth.sessions WHERE user_id = $1;
$_$;


ALTER FUNCTION public.get_user_sessions(user_id uuid) OWNER TO postgres;

--
-- TOC entry 419 (class 1255 OID 16768)
-- Name: get_user_with_relations(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_with_relations(user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE
  result JSONB;
BEGIN
  SELECT 
    jsonb_build_object(
      'id', ur.id,
      'role', ur.role,
      'created_at', ur.created_at,
      'updated_at', ur.updated_at,
      'auth_user', jsonb_build_object(
        'email', au.email,
        'created_at', au.created_at,
        'last_sign_in_at', au.last_sign_in_at
      ),
      'profile', COALESCE(
        (SELECT jsonb_build_object(
          'username', p.username,
          'avatar_url', p.avatar_url,
          'updated_at', p.updated_at
        )
        FROM profiles p
        WHERE p.id = user_id),
        '{}'::jsonb
      )
    ) INTO result
  FROM 
    user_roles ur
  JOIN 
    auth.users au ON ur.id = au.id
  WHERE 
    ur.id = user_id;
    
  RETURN result;
END;
$$;


ALTER FUNCTION public.get_user_with_relations(user_id uuid) OWNER TO postgres;

--
-- TOC entry 453 (class 1255 OID 16769)
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    -- Logique de la fonction ici
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- TOC entry 4631 (class 0 OID 0)
-- Dependencies: 453
-- Name: FUNCTION handle_new_user(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.handle_new_user() IS 'Fonction sécurisée pour gérer les nouveaux utilisateurs';


--
-- TOC entry 400 (class 1255 OID 16770)
-- Name: has_role(public.user_role); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.has_role(required_role public.user_role) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  user_current_role user_role;
BEGIN
  -- Modification ici : utiliser profiles au lieu de user_roles
  SELECT role::user_role INTO user_current_role 
  FROM profiles 
  WHERE user_id = auth.uid();
  
  -- La logique de hiérarchie des rôles reste identique
  RETURN CASE
    WHEN user_current_role = 'admin' THEN TRUE
    WHEN user_current_role = 'validator' AND required_role IN ('validator', 'verified', 'registered') THEN TRUE
    WHEN user_current_role = 'verified' AND required_role IN ('verified', 'registered') THEN TRUE
    WHEN user_current_role = 'registered' AND required_role = 'registered' THEN TRUE
    ELSE FALSE
  END;
END;
$$;


ALTER FUNCTION public.has_role(required_role public.user_role) OWNER TO postgres;

--
-- TOC entry 483 (class 1255 OID 16771)
-- Name: increment_language_likes(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increment_language_likes(lang_id bigint) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  INSERT INTO public.stats_languages (language_id, likes_count)
  VALUES (lang_id, 1)
  ON CONFLICT (language_id) 
  DO UPDATE SET 
    likes_count = public.stats_languages.likes_count + 1,
    last_updated = NOW();
END;
$$;


ALTER FUNCTION public.increment_language_likes(lang_id bigint) OWNER TO postgres;

--
-- TOC entry 4632 (class 0 OID 0)
-- Dependencies: 483
-- Name: FUNCTION increment_language_likes(lang_id bigint); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.increment_language_likes(lang_id bigint) IS 'Fonction sécurisée pour incrémenter le compteur de likes d''un langage';


--
-- TOC entry 399 (class 1255 OID 16772)
-- Name: increment_language_views(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increment_language_views(lang_id bigint) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  INSERT INTO public.stats_languages (language_id, views_count)
  VALUES (lang_id, 1)
  ON CONFLICT (language_id) 
  DO UPDATE SET 
    views_count = public.stats_languages.views_count + 1,
    last_updated = NOW();
END;
$$;


ALTER FUNCTION public.increment_language_views(lang_id bigint) OWNER TO postgres;

--
-- TOC entry 4633 (class 0 OID 0)
-- Dependencies: 399
-- Name: FUNCTION increment_language_views(lang_id bigint); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.increment_language_views(lang_id bigint) IS 'Fonction sécurisée pour incrémenter le compteur de vues d''un langage';


--
-- TOC entry 407 (class 1255 OID 16773)
-- Name: set_user_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_user_id() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  NEW.user_id := auth.uid();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_user_id() OWNER TO postgres;

--
-- TOC entry 488 (class 1255 OID 18268)
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_modified_column() OWNER TO postgres;

--
-- TOC entry 412 (class 1255 OID 16774)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

--
-- TOC entry 4634 (class 0 OID 0)
-- Dependencies: 412
-- Name: FUNCTION update_updated_at_column(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.update_updated_at_column() IS 'Fonction sécurisée pour mettre à jour automatiquement la colonne updated_at';


--
-- TOC entry 473 (class 1255 OID 16775)
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO postgres;

--
-- TOC entry 404 (class 1255 OID 16777)
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO postgres;

--
-- TOC entry 405 (class 1255 OID 16778)
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO postgres;

--
-- TOC entry 463 (class 1255 OID 16779)
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO postgres;

--
-- TOC entry 387 (class 1255 OID 16780)
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO postgres;

--
-- TOC entry 403 (class 1255 OID 16781)
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO postgres;

--
-- TOC entry 426 (class 1255 OID 16782)
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO postgres;

--
-- TOC entry 441 (class 1255 OID 16783)
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO postgres;

--
-- TOC entry 482 (class 1255 OID 16784)
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      PERFORM pg_notify(
          'realtime:system',
          jsonb_build_object(
              'error', SQLERRM,
              'function', 'realtime.send',
              'event', event,
              'topic', topic,
              'private', private
          )::text
      );
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO postgres;

--
-- TOC entry 461 (class 1255 OID 16785)
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO postgres;

--
-- TOC entry 449 (class 1255 OID 16786)
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO postgres;

--
-- TOC entry 451 (class 1255 OID 16787)
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO postgres;

--
-- TOC entry 465 (class 1255 OID 16788)
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: postgres
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO postgres;

--
-- TOC entry 413 (class 1255 OID 16789)
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: postgres
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO postgres;

--
-- TOC entry 452 (class 1255 OID 16790)
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: postgres
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO postgres;

--
-- TOC entry 386 (class 1255 OID 16791)
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: postgres
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO postgres;

--
-- TOC entry 438 (class 1255 OID 16792)
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: postgres
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO postgres;

--
-- TOC entry 481 (class 1255 OID 16793)
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: postgres
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO postgres;

--
-- TOC entry 445 (class 1255 OID 16794)
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: postgres
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO postgres;

--
-- TOC entry 431 (class 1255 OID 16795)
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: postgres
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO postgres;

--
-- TOC entry 458 (class 1255 OID 16796)
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: postgres
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO postgres;

--
-- TOC entry 394 (class 1255 OID 16797)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: postgres
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO postgres;

--
-- TOC entry 410 (class 1255 OID 16798)
-- Name: secrets_encrypt_secret_secret(); Type: FUNCTION; Schema: vault; Owner: postgres
--

CREATE FUNCTION vault.secrets_encrypt_secret_secret() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		BEGIN
		        new.secret = CASE WHEN new.secret IS NULL THEN NULL ELSE
			CASE WHEN new.key_id IS NULL THEN NULL ELSE pg_catalog.encode(
			  pgsodium.crypto_aead_det_encrypt(
				pg_catalog.convert_to(new.secret, 'utf8'),
				pg_catalog.convert_to((new.id::text || new.description::text || new.created_at::text || new.updated_at::text)::text, 'utf8'),
				new.key_id::uuid,
				new.nonce
			  ),
				'base64') END END;
		RETURN new;
		END;
		$$;


ALTER FUNCTION vault.secrets_encrypt_secret_secret() OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 16799)
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO postgres;

--
-- TOC entry 4635 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- TOC entry 258 (class 1259 OID 16805)
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO postgres;

--
-- TOC entry 4636 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- TOC entry 259 (class 1259 OID 16810)
-- Name: identities; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO postgres;

--
-- TOC entry 4637 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- TOC entry 4638 (class 0 OID 0)
-- Dependencies: 259
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- TOC entry 260 (class 1259 OID 16817)
-- Name: instances; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO postgres;

--
-- TOC entry 4639 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- TOC entry 261 (class 1259 OID 16822)
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO postgres;

--
-- TOC entry 4640 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- TOC entry 262 (class 1259 OID 16827)
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO postgres;

--
-- TOC entry 4641 (class 0 OID 0)
-- Dependencies: 262
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- TOC entry 263 (class 1259 OID 16832)
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO postgres;

--
-- TOC entry 4642 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- TOC entry 264 (class 1259 OID 16837)
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 16845)
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO postgres;

--
-- TOC entry 4643 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- TOC entry 266 (class 1259 OID 16851)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO postgres;

--
-- TOC entry 4644 (class 0 OID 0)
-- Dependencies: 266
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- TOC entry 267 (class 1259 OID 16852)
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO postgres;

--
-- TOC entry 4645 (class 0 OID 0)
-- Dependencies: 267
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- TOC entry 268 (class 1259 OID 16860)
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO postgres;

--
-- TOC entry 4646 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- TOC entry 269 (class 1259 OID 16866)
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO postgres;

--
-- TOC entry 4647 (class 0 OID 0)
-- Dependencies: 269
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- TOC entry 270 (class 1259 OID 16869)
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO postgres;

--
-- TOC entry 4648 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- TOC entry 271 (class 1259 OID 16875)
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO postgres;

--
-- TOC entry 4649 (class 0 OID 0)
-- Dependencies: 271
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- TOC entry 4650 (class 0 OID 0)
-- Dependencies: 271
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- TOC entry 272 (class 1259 OID 16881)
-- Name: users; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO postgres;

--
-- TOC entry 4651 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- TOC entry 4652 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- TOC entry 334 (class 1259 OID 18167)
-- Name: accessibility_criteria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accessibility_criteria (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    weight numeric(5,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT accessibility_criteria_weight_check CHECK (((weight >= (0)::numeric) AND (weight <= (100)::numeric)))
);


ALTER TABLE public.accessibility_criteria OWNER TO postgres;

--
-- TOC entry 333 (class 1259 OID 18166)
-- Name: accessibility_criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accessibility_criteria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accessibility_criteria_id_seq OWNER TO postgres;

--
-- TOC entry 4653 (class 0 OID 0)
-- Dependencies: 333
-- Name: accessibility_criteria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accessibility_criteria_id_seq OWNED BY public.accessibility_criteria.id;


--
-- TOC entry 328 (class 1259 OID 18108)
-- Name: accessibility_levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accessibility_levels (
    id integer NOT NULL,
    level_number integer NOT NULL,
    name character varying(50) NOT NULL,
    description text NOT NULL,
    prerequisites text NOT NULL,
    estimated_learning_time character varying(50) NOT NULL,
    level_order integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.accessibility_levels OWNER TO postgres;

--
-- TOC entry 4654 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE accessibility_levels; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.accessibility_levels IS 'Définit les différents niveaux d''accessibilité/difficulté pour l''apprentissage des langages de programmation';


--
-- TOC entry 327 (class 1259 OID 18107)
-- Name: accessibility_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accessibility_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accessibility_levels_id_seq OWNER TO postgres;

--
-- TOC entry 4655 (class 0 OID 0)
-- Dependencies: 327
-- Name: accessibility_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accessibility_levels_id_seq OWNED BY public.accessibility_levels.id;


--
-- TOC entry 236 (class 1259 OID 16412)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16411)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 16420)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16419)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 16406)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16405)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 240 (class 1259 OID 16426)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16434)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16433)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 239 (class 1259 OID 16425)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 244 (class 1259 OID 16440)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16439)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 273 (class 1259 OID 16896)
-- Name: corrections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.corrections (
    id integer NOT NULL,
    language_id integer NOT NULL,
    framework text,
    correction_text text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    field character varying(100),
    suggestion text,
    user_id uuid,
    reviewed_at timestamp with time zone,
    reviewed_by_id integer
);


ALTER TABLE public.corrections OWNER TO postgres;

--
-- TOC entry 4656 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE corrections; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.corrections IS 'table des corrections et des status';


--
-- TOC entry 274 (class 1259 OID 16904)
-- Name: corrections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.corrections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.corrections_id_seq OWNER TO postgres;

--
-- TOC entry 4657 (class 0 OID 0)
-- Dependencies: 274
-- Name: corrections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.corrections_id_seq OWNED BY public.corrections.id;


--
-- TOC entry 324 (class 1259 OID 17791)
-- Name: db_docs_chapter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.db_docs_chapter (
    id bigint NOT NULL,
    title character varying(200) NOT NULL,
    slug character varying(50) NOT NULL,
    "order" integer NOT NULL,
    description text NOT NULL,
    CONSTRAINT db_docs_chapter_order_check CHECK (("order" >= 0))
);


ALTER TABLE public.db_docs_chapter OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 17790)
-- Name: db_docs_chapter_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.db_docs_chapter ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.db_docs_chapter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 326 (class 1259 OID 17802)
-- Name: db_docs_section; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.db_docs_section (
    id bigint NOT NULL,
    title character varying(200) NOT NULL,
    content text NOT NULL,
    sql_example text NOT NULL,
    "order" integer NOT NULL,
    chapter_id bigint NOT NULL,
    CONSTRAINT db_docs_section_order_check CHECK (("order" >= 0))
);


ALTER TABLE public.db_docs_section OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 17801)
-- Name: db_docs_section_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.db_docs_section ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.db_docs_section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 246 (class 1259 OID 16498)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16497)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 16398)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16397)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 16390)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16389)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 249 (class 1259 OID 16554)
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- TOC entry 350 (class 1259 OID 18346)
-- Name: django_site; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO postgres;

--
-- TOC entry 349 (class 1259 OID 18345)
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_site ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 340 (class 1259 OID 18221)
-- Name: features; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.features (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(100) NOT NULL,
    description text,
    feature_type character varying(50) NOT NULL,
    is_boolean boolean DEFAULT false NOT NULL,
    has_multiple_values boolean DEFAULT false NOT NULL,
    possible_values jsonb,
    default_value character varying(100),
    importance_weight integer DEFAULT 5,
    display_order integer DEFAULT 0,
    icon_path character varying(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.features OWNER TO postgres;

--
-- TOC entry 339 (class 1259 OID 18220)
-- Name: features_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.features_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.features_id_seq OWNER TO postgres;

--
-- TOC entry 4658 (class 0 OID 0)
-- Dependencies: 339
-- Name: features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.features_id_seq OWNED BY public.features.id;


--
-- TOC entry 275 (class 1259 OID 16905)
-- Name: libraries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.libraries (
    id integer NOT NULL,
    name text NOT NULL,
    language_id integer,
    description text,
    official_website text,
    github_url text,
    logo_path text,
    popularity integer,
    is_open_source boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    features text[] DEFAULT '{}'::text[],
    unique_selling_point text,
    best_for text,
    used_for text,
    documentation_url text,
    version text,
    technology_type character varying(50),
    subtype character varying(50),
    slug text NOT NULL,
    license text,
    website_url text
);


ALTER TABLE public.libraries OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 16914)
-- Name: frameworks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.frameworks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.frameworks_id_seq OWNER TO postgres;

--
-- TOC entry 4659 (class 0 OID 0)
-- Dependencies: 276
-- Name: frameworks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.frameworks_id_seq OWNED BY public.libraries.id;


--
-- TOC entry 336 (class 1259 OID 18179)
-- Name: language_accessibility_evaluations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_accessibility_evaluations (
    id integer NOT NULL,
    language_accessibility_level_id integer NOT NULL,
    criteria_id integer NOT NULL,
    score numeric(5,2) NOT NULL,
    justification text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT language_accessibility_evaluations_score_check CHECK (((score >= (0)::numeric) AND (score <= (100)::numeric)))
);


ALTER TABLE public.language_accessibility_evaluations OWNER TO postgres;

--
-- TOC entry 335 (class 1259 OID 18178)
-- Name: language_accessibility_evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_accessibility_evaluations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.language_accessibility_evaluations_id_seq OWNER TO postgres;

--
-- TOC entry 4660 (class 0 OID 0)
-- Dependencies: 335
-- Name: language_accessibility_evaluations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_accessibility_evaluations_id_seq OWNED BY public.language_accessibility_evaluations.id;


--
-- TOC entry 332 (class 1259 OID 18141)
-- Name: language_accessibility_levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_accessibility_levels (
    id integer NOT NULL,
    language_id integer NOT NULL,
    accessibility_level_id integer NOT NULL,
    notes text,
    accessibility_score integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    score_explanation text,
    CONSTRAINT language_accessibility_levels_accessibility_score_check CHECK (((accessibility_score >= 0) AND (accessibility_score <= 100)))
);


ALTER TABLE public.language_accessibility_levels OWNER TO postgres;

--
-- TOC entry 4661 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE language_accessibility_levels; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.language_accessibility_levels IS 'Associe des niveaux d''accessibilité aux langages avec des notes spécifiques et un score numérique';


--
-- TOC entry 331 (class 1259 OID 18140)
-- Name: language_accessibility_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_accessibility_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.language_accessibility_levels_id_seq OWNER TO postgres;

--
-- TOC entry 4662 (class 0 OID 0)
-- Dependencies: 331
-- Name: language_accessibility_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_accessibility_levels_id_seq OWNED BY public.language_accessibility_levels.id;


--
-- TOC entry 344 (class 1259 OID 18299)
-- Name: language_feature_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_feature_values (
    id integer NOT NULL,
    language_id integer NOT NULL,
    feature_id integer NOT NULL,
    value text NOT NULL,
    value_details text,
    is_primary boolean DEFAULT true,
    source_url character varying(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    notes text
);


ALTER TABLE public.language_feature_values OWNER TO postgres;

--
-- TOC entry 4663 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE language_feature_values; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.language_feature_values IS 'Stocke les valeurs spécifiques des caractéristiques pour chaque langage de programmation';


--
-- TOC entry 343 (class 1259 OID 18298)
-- Name: language_feature_values_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_feature_values_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.language_feature_values_id_seq OWNER TO postgres;

--
-- TOC entry 4664 (class 0 OID 0)
-- Dependencies: 343
-- Name: language_feature_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_feature_values_id_seq OWNED BY public.language_feature_values.id;


--
-- TOC entry 342 (class 1259 OID 18241)
-- Name: language_features; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_features (
    id integer NOT NULL,
    language_id integer NOT NULL,
    feature_id integer NOT NULL,
    value character varying(255) NOT NULL,
    value_details jsonb,
    is_primary boolean DEFAULT false,
    source_url character varying(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.language_features OWNER TO postgres;

--
-- TOC entry 341 (class 1259 OID 18240)
-- Name: language_features_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_features_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.language_features_id_seq OWNER TO postgres;

--
-- TOC entry 4665 (class 0 OID 0)
-- Dependencies: 341
-- Name: language_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_features_id_seq OWNED BY public.language_features.id;


--
-- TOC entry 277 (class 1259 OID 16915)
-- Name: language_proposals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_proposals (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(50),
    description text,
    created_year integer,
    creator character varying(255),
    used_for text,
    strengths text[],
    popular_frameworks text[],
    user_id uuid,
    status character varying(50) DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT valid_proposal_type CHECK (((type)::text = ANY (ARRAY[('language'::character varying)::text, ('tool'::character varying)::text, ('framework'::character varying)::text, ('library'::character varying)::text])))
);


ALTER TABLE public.language_proposals OWNER TO postgres;

--
-- TOC entry 4666 (class 0 OID 0)
-- Dependencies: 277
-- Name: COLUMN language_proposals.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.language_proposals.type IS 'Type de proposition: language, tool, framework, library';


--
-- TOC entry 278 (class 1259 OID 16924)
-- Name: language_proposals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_proposals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.language_proposals_id_seq OWNER TO postgres;

--
-- TOC entry 4667 (class 0 OID 0)
-- Dependencies: 278
-- Name: language_proposals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_proposals_id_seq OWNED BY public.language_proposals.id;


--
-- TOC entry 279 (class 1259 OID 16925)
-- Name: language_usage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_usage (
    id integer NOT NULL,
    language_id integer,
    category_id integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.language_usage OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 16929)
-- Name: language_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.language_usage_id_seq OWNER TO postgres;

--
-- TOC entry 4668 (class 0 OID 0)
-- Dependencies: 280
-- Name: language_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_usage_id_seq OWNED BY public.language_usage.id;


--
-- TOC entry 281 (class 1259 OID 16930)
-- Name: languages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.languages (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    year_created integer,
    creator character varying(255),
    description text,
    logo_path character varying(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    type character varying(50),
    usage_rate integer,
    is_open_source boolean DEFAULT true,
    short_description text,
    used_for text,
    strengths text[],
    popular_frameworks text[],
    tools jsonb,
    logo_svg text,
    default_accessibility_level_id integer,
    accessibility_score integer,
    CONSTRAINT languages_accessibility_score_check CHECK (((accessibility_score >= 0) AND (accessibility_score <= 100)))
);


ALTER TABLE public.languages OWNER TO postgres;

--
-- TOC entry 4669 (class 0 OID 0)
-- Dependencies: 281
-- Name: COLUMN languages.default_accessibility_level_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.languages.default_accessibility_level_id IS 'Niveau d''accessibilité global par défaut pour ce langage';


--
-- TOC entry 4670 (class 0 OID 0)
-- Dependencies: 281
-- Name: COLUMN languages.accessibility_score; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.languages.accessibility_score IS 'Score global de facilité d''apprentissage du langage (0-100)';


--
-- TOC entry 248 (class 1259 OID 16537)
-- Name: languages_framework; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.languages_framework (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(50) NOT NULL,
    description text NOT NULL,
    website character varying(200) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    language_id bigint NOT NULL
);


ALTER TABLE public.languages_framework OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 16536)
-- Name: languages_framework_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.languages_framework ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.languages_framework_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 282 (class 1259 OID 16938)
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.languages_id_seq OWNER TO postgres;

--
-- TOC entry 4671 (class 0 OID 0)
-- Dependencies: 282
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.languages_id_seq OWNED BY public.languages.id;


--
-- TOC entry 283 (class 1259 OID 16939)
-- Name: library_language_associations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.library_language_associations (
    library_id integer NOT NULL,
    language_id integer NOT NULL
);


ALTER TABLE public.library_language_associations OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 16942)
-- Name: library_languages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.library_languages (
    id integer NOT NULL,
    library_id integer NOT NULL,
    language_id integer NOT NULL,
    primary_language boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.library_languages OWNER TO postgres;

--
-- TOC entry 4672 (class 0 OID 0)
-- Dependencies: 284
-- Name: TABLE library_languages; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.library_languages IS 'Table de jonction pour associer une bibliothèque à plusieurs langages de programmation';


--
-- TOC entry 285 (class 1259 OID 16947)
-- Name: library_languages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.library_languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.library_languages_id_seq OWNER TO postgres;

--
-- TOC entry 4673 (class 0 OID 0)
-- Dependencies: 285
-- Name: library_languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.library_languages_id_seq OWNED BY public.library_languages.id;


--
-- TOC entry 286 (class 1259 OID 16948)
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    username text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    avatar_url text,
    full_name text,
    bio text,
    website text,
    user_id integer NOT NULL,
    role character varying(20) NOT NULL
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- TOC entry 346 (class 1259 OID 18323)
-- Name: seo_seoconfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seo_seoconfig (
    id bigint NOT NULL,
    site_name character varying(100) NOT NULL,
    site_description text NOT NULL,
    default_keywords character varying(255) NOT NULL,
    og_image character varying(200),
    twitter_handle character varying(50)
);


ALTER TABLE public.seo_seoconfig OWNER TO postgres;

--
-- TOC entry 345 (class 1259 OID 18322)
-- Name: seo_seoconfig_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.seo_seoconfig ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.seo_seoconfig_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 348 (class 1259 OID 18331)
-- Name: seo_seometadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seo_seometadata (
    id bigint NOT NULL,
    object_id integer NOT NULL,
    custom_title character varying(60),
    custom_description character varying(160),
    custom_keywords character varying(255),
    no_index boolean NOT NULL,
    no_follow boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    content_type_id integer NOT NULL,
    CONSTRAINT seo_seometadata_object_id_check CHECK ((object_id >= 0))
);


ALTER TABLE public.seo_seometadata OWNER TO postgres;

--
-- TOC entry 347 (class 1259 OID 18330)
-- Name: seo_seometadata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.seo_seometadata ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.seo_seometadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 330 (class 1259 OID 18120)
-- Name: skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skills (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    skill_type character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT skills_skill_type_check CHECK (((skill_type)::text = ANY ((ARRAY['syntax'::character varying, 'concept'::character varying, 'technique'::character varying, 'tool'::character varying])::text[])))
);


ALTER TABLE public.skills OWNER TO postgres;

--
-- TOC entry 4674 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE skills; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.skills IS 'Catalogue des compétences techniques requises pour la programmation';


--
-- TOC entry 329 (class 1259 OID 18119)
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skills_id_seq OWNER TO postgres;

--
-- TOC entry 4675 (class 0 OID 0)
-- Dependencies: 329
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skills_id_seq OWNED BY public.skills.id;


--
-- TOC entry 287 (class 1259 OID 16955)
-- Name: stats_languages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stats_languages (
    id bigint NOT NULL,
    language_id bigint NOT NULL,
    views_count bigint DEFAULT 0,
    likes_count bigint DEFAULT 0,
    shares_count bigint DEFAULT 0,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.stats_languages OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 16962)
-- Name: stats_languages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.stats_languages ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.stats_languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 289 (class 1259 OID 16963)
-- Name: stats_searches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stats_searches (
    id bigint NOT NULL,
    search_term text NOT NULL,
    user_id uuid,
    results_count integer,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.stats_searches OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 16969)
-- Name: stats_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.stats_searches ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.stats_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 291 (class 1259 OID 16970)
-- Name: stats_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stats_users (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    contributions_count bigint DEFAULT 0,
    corrections_count bigint DEFAULT 0,
    proposals_count bigint DEFAULT 0,
    last_activity timestamp with time zone DEFAULT now()
);


ALTER TABLE public.stats_users OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 16977)
-- Name: stats_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.stats_users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.stats_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 293 (class 1259 OID 16978)
-- Name: stats_visits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stats_visits (
    id bigint NOT NULL,
    page_path text NOT NULL,
    user_id uuid,
    referrer text,
    user_agent text,
    ip_address text,
    created_at timestamp with time zone DEFAULT now(),
    session_id text
);


ALTER TABLE public.stats_visits OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 16984)
-- Name: stats_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.stats_visits ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.stats_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 295 (class 1259 OID 16985)
-- Name: technology_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.technology_categories (
    id integer NOT NULL,
    type character varying(50) NOT NULL,
    icon_name character varying(50) NOT NULL,
    color character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.technology_categories OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 16989)
-- Name: technology_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.technology_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.technology_categories_id_seq OWNER TO postgres;

--
-- TOC entry 4676 (class 0 OID 0)
-- Dependencies: 296
-- Name: technology_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.technology_categories_id_seq OWNED BY public.technology_categories.id;


--
-- TOC entry 297 (class 1259 OID 16990)
-- Name: technology_subtypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.technology_subtypes (
    id integer NOT NULL,
    category_id integer,
    name character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    description text
);


ALTER TABLE public.technology_subtypes OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 16994)
-- Name: technology_subtypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.technology_subtypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.technology_subtypes_id_seq OWNER TO postgres;

--
-- TOC entry 4677 (class 0 OID 0)
-- Dependencies: 298
-- Name: technology_subtypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.technology_subtypes_id_seq OWNED BY public.technology_subtypes.id;


--
-- TOC entry 299 (class 1259 OID 16995)
-- Name: todo_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.todo_categories (
    id integer NOT NULL,
    name text NOT NULL,
    color text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.todo_categories OWNER TO postgres;

--
-- TOC entry 300 (class 1259 OID 17001)
-- Name: todo_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.todo_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.todo_categories_id_seq OWNER TO postgres;

--
-- TOC entry 4678 (class 0 OID 0)
-- Dependencies: 300
-- Name: todo_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.todo_categories_id_seq OWNED BY public.todo_categories.id;


--
-- TOC entry 301 (class 1259 OID 17002)
-- Name: todo_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.todo_status (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.todo_status OWNER TO postgres;

--
-- TOC entry 302 (class 1259 OID 17008)
-- Name: todo_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.todo_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.todo_status_id_seq OWNER TO postgres;

--
-- TOC entry 4679 (class 0 OID 0)
-- Dependencies: 302
-- Name: todo_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.todo_status_id_seq OWNED BY public.todo_status.id;


--
-- TOC entry 303 (class 1259 OID 17009)
-- Name: todos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.todos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.todos_id_seq OWNER TO postgres;

--
-- TOC entry 4680 (class 0 OID 0)
-- Dependencies: 303
-- Name: todos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.todos_id_seq OWNED BY public.todos.id;


--
-- TOC entry 356 (class 1259 OID 18369)
-- Name: tool; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    usage text,
    type_id integer,
    technology_category_id integer,
    technology_subtype_id integer,
    official_website character varying(255),
    documentation_url character varying(255),
    is_open_source boolean DEFAULT false,
    license character varying(100),
    logo_path character varying(255),
    author character varying(100),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.tool OWNER TO postgres;

--
-- TOC entry 352 (class 1259 OID 18355)
-- Name: tool_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_category (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.tool_category OWNER TO postgres;

--
-- TOC entry 351 (class 1259 OID 18354)
-- Name: tool_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tool_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tool_category_id_seq OWNER TO postgres;

--
-- TOC entry 4681 (class 0 OID 0)
-- Dependencies: 351
-- Name: tool_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tool_category_id_seq OWNED BY public.tool_category.id;


--
-- TOC entry 355 (class 1259 OID 18368)
-- Name: tool_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tool_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tool_id_seq OWNER TO postgres;

--
-- TOC entry 4682 (class 0 OID 0)
-- Dependencies: 355
-- Name: tool_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tool_id_seq OWNED BY public.tool.id;


--
-- TOC entry 358 (class 1259 OID 18388)
-- Name: tool_language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_language (
    id integer NOT NULL,
    tool_id integer,
    language_id integer,
    is_primary boolean DEFAULT false
);


ALTER TABLE public.tool_language OWNER TO postgres;

--
-- TOC entry 357 (class 1259 OID 18387)
-- Name: tool_language_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tool_language_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tool_language_id_seq OWNER TO postgres;

--
-- TOC entry 4683 (class 0 OID 0)
-- Dependencies: 357
-- Name: tool_language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tool_language_id_seq OWNED BY public.tool_language.id;


--
-- TOC entry 360 (class 1259 OID 18416)
-- Name: tool_technology_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_technology_category (
    id integer NOT NULL,
    tool_id integer,
    technology_category_id integer
);


ALTER TABLE public.tool_technology_category OWNER TO postgres;

--
-- TOC entry 359 (class 1259 OID 18415)
-- Name: tool_technology_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tool_technology_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tool_technology_category_id_seq OWNER TO postgres;

--
-- TOC entry 4684 (class 0 OID 0)
-- Dependencies: 359
-- Name: tool_technology_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tool_technology_category_id_seq OWNED BY public.tool_technology_category.id;


--
-- TOC entry 362 (class 1259 OID 18433)
-- Name: tool_technology_subtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_technology_subtype (
    id integer NOT NULL,
    tool_id integer,
    technology_subtype_id integer
);


ALTER TABLE public.tool_technology_subtype OWNER TO postgres;

--
-- TOC entry 361 (class 1259 OID 18432)
-- Name: tool_technology_subtype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tool_technology_subtype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tool_technology_subtype_id_seq OWNER TO postgres;

--
-- TOC entry 4685 (class 0 OID 0)
-- Dependencies: 361
-- Name: tool_technology_subtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tool_technology_subtype_id_seq OWNED BY public.tool_technology_subtype.id;


--
-- TOC entry 364 (class 1259 OID 18450)
-- Name: tool_tool; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_tool (
    id integer NOT NULL,
    tool_id integer,
    related_tool_id integer,
    relation_type character varying(50)
);


ALTER TABLE public.tool_tool OWNER TO postgres;

--
-- TOC entry 363 (class 1259 OID 18449)
-- Name: tool_tool_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tool_tool_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tool_tool_id_seq OWNER TO postgres;

--
-- TOC entry 4686 (class 0 OID 0)
-- Dependencies: 363
-- Name: tool_tool_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tool_tool_id_seq OWNED BY public.tool_tool.id;


--
-- TOC entry 368 (class 1259 OID 18481)
-- Name: tool_tool_usage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_tool_usage (
    id integer NOT NULL,
    tool_id integer,
    usage_id integer
);


ALTER TABLE public.tool_tool_usage OWNER TO postgres;

--
-- TOC entry 367 (class 1259 OID 18480)
-- Name: tool_tool_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tool_tool_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tool_tool_usage_id_seq OWNER TO postgres;

--
-- TOC entry 4687 (class 0 OID 0)
-- Dependencies: 367
-- Name: tool_tool_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tool_tool_usage_id_seq OWNED BY public.tool_tool_usage.id;


--
-- TOC entry 354 (class 1259 OID 18362)
-- Name: tool_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.tool_type OWNER TO postgres;

--
-- TOC entry 353 (class 1259 OID 18361)
-- Name: tool_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tool_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tool_type_id_seq OWNER TO postgres;

--
-- TOC entry 4688 (class 0 OID 0)
-- Dependencies: 353
-- Name: tool_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tool_type_id_seq OWNED BY public.tool_type.id;


--
-- TOC entry 366 (class 1259 OID 18472)
-- Name: tool_usage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_usage (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.tool_usage OWNER TO postgres;

--
-- TOC entry 365 (class 1259 OID 18471)
-- Name: tool_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tool_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tool_usage_id_seq OWNER TO postgres;

--
-- TOC entry 4689 (class 0 OID 0)
-- Dependencies: 365
-- Name: tool_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tool_usage_id_seq OWNED BY public.tool_usage.id;


--
-- TOC entry 370 (class 1259 OID 18501)
-- Name: tools_technologycategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tools_technologycategory (
    id bigint NOT NULL,
    type character varying(255) NOT NULL,
    icon_name character varying(255),
    color character varying(255),
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.tools_technologycategory OWNER TO postgres;

--
-- TOC entry 369 (class 1259 OID 18500)
-- Name: tools_technologycategory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tools_technologycategory ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tools_technologycategory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 376 (class 1259 OID 18521)
-- Name: tools_technologysubtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tools_technologysubtype (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    description text,
    category_id bigint NOT NULL
);


ALTER TABLE public.tools_technologysubtype OWNER TO postgres;

--
-- TOC entry 375 (class 1259 OID 18520)
-- Name: tools_technologysubtype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tools_technologysubtype ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tools_technologysubtype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 378 (class 1259 OID 18529)
-- Name: tools_tool; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tools_tool (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    structure text,
    usage text,
    official_website character varying(200),
    documentation_url character varying(200),
    is_open_source boolean NOT NULL,
    license character varying(255),
    logo_path character varying(255),
    author character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    technology_category_id bigint,
    technology_subtype_id bigint,
    category_id bigint,
    type_id bigint
);


ALTER TABLE public.tools_tool OWNER TO postgres;

--
-- TOC entry 377 (class 1259 OID 18528)
-- Name: tools_tool_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tools_tool ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tools_tool_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 372 (class 1259 OID 18509)
-- Name: tools_toolcategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tools_toolcategory (
    id bigint NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.tools_toolcategory OWNER TO postgres;

--
-- TOC entry 371 (class 1259 OID 18508)
-- Name: tools_toolcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tools_toolcategory ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tools_toolcategory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 380 (class 1259 OID 18537)
-- Name: tools_toollanguage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tools_toollanguage (
    id bigint NOT NULL,
    is_primary boolean NOT NULL,
    language_id bigint NOT NULL,
    tool_id bigint NOT NULL
);


ALTER TABLE public.tools_toollanguage OWNER TO postgres;

--
-- TOC entry 379 (class 1259 OID 18536)
-- Name: tools_toollanguage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tools_toollanguage ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tools_toollanguage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 374 (class 1259 OID 18515)
-- Name: tools_tooltype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tools_tooltype (
    id bigint NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.tools_tooltype OWNER TO postgres;

--
-- TOC entry 373 (class 1259 OID 18514)
-- Name: tools_tooltype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tools_tooltype ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tools_tooltype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 304 (class 1259 OID 17010)
-- Name: usage_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usage_categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    description text,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.usage_categories OWNER TO postgres;

--
-- TOC entry 305 (class 1259 OID 17017)
-- Name: usage_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usage_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usage_categories_id_seq OWNER TO postgres;

--
-- TOC entry 4690 (class 0 OID 0)
-- Dependencies: 305
-- Name: usage_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usage_categories_id_seq OWNED BY public.usage_categories.id;


--
-- TOC entry 306 (class 1259 OID 17018)
-- Name: user_language_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_language_likes (
    id integer NOT NULL,
    user_id uuid NOT NULL,
    language_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_language_likes OWNER TO postgres;

--
-- TOC entry 307 (class 1259 OID 17022)
-- Name: user_language_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_language_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_language_likes_id_seq OWNER TO postgres;

--
-- TOC entry 4691 (class 0 OID 0)
-- Dependencies: 307
-- Name: user_language_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_language_likes_id_seq OWNED BY public.user_language_likes.id;


--
-- TOC entry 308 (class 1259 OID 17023)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id uuid NOT NULL,
    role public.user_role DEFAULT 'registered'::public.user_role NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- TOC entry 309 (class 1259 OID 17029)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email text NOT NULL,
    role text DEFAULT 'registered'::text NOT NULL,
    name text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT users_role_check CHECK ((role = ANY (ARRAY['registered'::text, 'verified'::text, 'validator'::text, 'admin'::text])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 320 (class 1259 OID 17654)
-- Name: utilisateurs_correctioncomment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utilisateurs_correctioncomment (
    id bigint NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    correction_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.utilisateurs_correctioncomment OWNER TO postgres;

--
-- TOC entry 319 (class 1259 OID 17653)
-- Name: utilisateurs_correctioncomment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.utilisateurs_correctioncomment ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.utilisateurs_correctioncomment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 322 (class 1259 OID 17662)
-- Name: utilisateurs_languageexpertise; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utilisateurs_languageexpertise (
    id bigint NOT NULL,
    expertise_level character varying(20) NOT NULL,
    notes text,
    created_at timestamp with time zone NOT NULL,
    language_id bigint NOT NULL,
    user_id uuid NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.utilisateurs_languageexpertise OWNER TO postgres;

--
-- TOC entry 321 (class 1259 OID 17661)
-- Name: utilisateurs_languageexpertise_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.utilisateurs_languageexpertise ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.utilisateurs_languageexpertise_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 310 (class 1259 OID 17038)
-- Name: messages; Type: TABLE; Schema: realtime; Owner: postgres
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO postgres;

--
-- TOC entry 311 (class 1259 OID 17045)
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: postgres
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO postgres;

--
-- TOC entry 312 (class 1259 OID 17048)
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: postgres
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO postgres;

--
-- TOC entry 313 (class 1259 OID 17056)
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: postgres
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 314 (class 1259 OID 17057)
-- Name: buckets; Type: TABLE; Schema: storage; Owner: postgres
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO postgres;

--
-- TOC entry 4692 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: postgres
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 315 (class 1259 OID 17066)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: postgres
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO postgres;

--
-- TOC entry 316 (class 1259 OID 17070)
-- Name: objects; Type: TABLE; Schema: storage; Owner: postgres
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO postgres;

--
-- TOC entry 4693 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: postgres
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 317 (class 1259 OID 17080)
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: postgres
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO postgres;

--
-- TOC entry 318 (class 1259 OID 17087)
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: postgres
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO postgres;

--
-- TOC entry 3778 (class 2604 OID 17617)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 3872 (class 2604 OID 18170)
-- Name: accessibility_criteria id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accessibility_criteria ALTER COLUMN id SET DEFAULT nextval('public.accessibility_criteria_id_seq'::regclass);


--
-- TOC entry 3863 (class 2604 OID 18111)
-- Name: accessibility_levels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accessibility_levels ALTER COLUMN id SET DEFAULT nextval('public.accessibility_levels_id_seq'::regclass);


--
-- TOC entry 3788 (class 2604 OID 17618)
-- Name: corrections id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corrections ALTER COLUMN id SET DEFAULT nextval('public.corrections_id_seq'::regclass);


--
-- TOC entry 3878 (class 2604 OID 18224)
-- Name: features id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.features ALTER COLUMN id SET DEFAULT nextval('public.features_id_seq'::regclass);


--
-- TOC entry 3875 (class 2604 OID 18182)
-- Name: language_accessibility_evaluations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_accessibility_evaluations ALTER COLUMN id SET DEFAULT nextval('public.language_accessibility_evaluations_id_seq'::regclass);


--
-- TOC entry 3869 (class 2604 OID 18144)
-- Name: language_accessibility_levels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_accessibility_levels ALTER COLUMN id SET DEFAULT nextval('public.language_accessibility_levels_id_seq'::regclass);


--
-- TOC entry 3889 (class 2604 OID 18302)
-- Name: language_feature_values id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_feature_values ALTER COLUMN id SET DEFAULT nextval('public.language_feature_values_id_seq'::regclass);


--
-- TOC entry 3885 (class 2604 OID 18244)
-- Name: language_features id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_features ALTER COLUMN id SET DEFAULT nextval('public.language_features_id_seq'::regclass);


--
-- TOC entry 3797 (class 2604 OID 17619)
-- Name: language_proposals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_proposals ALTER COLUMN id SET DEFAULT nextval('public.language_proposals_id_seq'::regclass);


--
-- TOC entry 3801 (class 2604 OID 17620)
-- Name: language_usage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_usage ALTER COLUMN id SET DEFAULT nextval('public.language_usage_id_seq'::regclass);


--
-- TOC entry 3803 (class 2604 OID 17621)
-- Name: languages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages ALTER COLUMN id SET DEFAULT nextval('public.languages_id_seq'::regclass);


--
-- TOC entry 3792 (class 2604 OID 17622)
-- Name: libraries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libraries ALTER COLUMN id SET DEFAULT nextval('public.frameworks_id_seq'::regclass);


--
-- TOC entry 3807 (class 2604 OID 17623)
-- Name: library_languages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_languages ALTER COLUMN id SET DEFAULT nextval('public.library_languages_id_seq'::regclass);


--
-- TOC entry 3866 (class 2604 OID 18123)
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills ALTER COLUMN id SET DEFAULT nextval('public.skills_id_seq'::regclass);


--
-- TOC entry 3822 (class 2604 OID 17624)
-- Name: technology_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technology_categories ALTER COLUMN id SET DEFAULT nextval('public.technology_categories_id_seq'::regclass);


--
-- TOC entry 3824 (class 2604 OID 17625)
-- Name: technology_subtypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technology_subtypes ALTER COLUMN id SET DEFAULT nextval('public.technology_subtypes_id_seq'::regclass);


--
-- TOC entry 3826 (class 2604 OID 17626)
-- Name: todo_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todo_categories ALTER COLUMN id SET DEFAULT nextval('public.todo_categories_id_seq'::regclass);


--
-- TOC entry 3828 (class 2604 OID 17627)
-- Name: todo_status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todo_status ALTER COLUMN id SET DEFAULT nextval('public.todo_status_id_seq'::regclass);


--
-- TOC entry 3769 (class 2604 OID 17628)
-- Name: todos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todos ALTER COLUMN id SET DEFAULT nextval('public.todos_id_seq'::regclass);


--
-- TOC entry 3895 (class 2604 OID 18372)
-- Name: tool id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool ALTER COLUMN id SET DEFAULT nextval('public.tool_id_seq'::regclass);


--
-- TOC entry 3893 (class 2604 OID 18358)
-- Name: tool_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_category ALTER COLUMN id SET DEFAULT nextval('public.tool_category_id_seq'::regclass);


--
-- TOC entry 3899 (class 2604 OID 18391)
-- Name: tool_language id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_language ALTER COLUMN id SET DEFAULT nextval('public.tool_language_id_seq'::regclass);


--
-- TOC entry 3901 (class 2604 OID 18419)
-- Name: tool_technology_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_technology_category ALTER COLUMN id SET DEFAULT nextval('public.tool_technology_category_id_seq'::regclass);


--
-- TOC entry 3902 (class 2604 OID 18436)
-- Name: tool_technology_subtype id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_technology_subtype ALTER COLUMN id SET DEFAULT nextval('public.tool_technology_subtype_id_seq'::regclass);


--
-- TOC entry 3903 (class 2604 OID 18453)
-- Name: tool_tool id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_tool ALTER COLUMN id SET DEFAULT nextval('public.tool_tool_id_seq'::regclass);


--
-- TOC entry 3905 (class 2604 OID 18484)
-- Name: tool_tool_usage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_tool_usage ALTER COLUMN id SET DEFAULT nextval('public.tool_tool_usage_id_seq'::regclass);


--
-- TOC entry 3894 (class 2604 OID 18365)
-- Name: tool_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_type ALTER COLUMN id SET DEFAULT nextval('public.tool_type_id_seq'::regclass);


--
-- TOC entry 3904 (class 2604 OID 18475)
-- Name: tool_usage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_usage ALTER COLUMN id SET DEFAULT nextval('public.tool_usage_id_seq'::regclass);


--
-- TOC entry 3830 (class 2604 OID 17629)
-- Name: usage_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usage_categories ALTER COLUMN id SET DEFAULT nextval('public.usage_categories_id_seq'::regclass);


--
-- TOC entry 3833 (class 2604 OID 17630)
-- Name: user_language_likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_language_likes ALTER COLUMN id SET DEFAULT nextval('public.user_language_likes_id_seq'::regclass);


--
-- TOC entry 4004 (class 2606 OID 17110)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 3988 (class 2606 OID 17112)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 3992 (class 2606 OID 17114)
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- TOC entry 3997 (class 2606 OID 17116)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- TOC entry 3999 (class 2606 OID 17118)
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- TOC entry 4002 (class 2606 OID 17120)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 4006 (class 2606 OID 17122)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 4009 (class 2606 OID 17124)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4012 (class 2606 OID 17126)
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- TOC entry 4014 (class 2606 OID 17128)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 4019 (class 2606 OID 17130)
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4027 (class 2606 OID 17132)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4030 (class 2606 OID 17134)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4033 (class 2606 OID 17136)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 4035 (class 2606 OID 17138)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4040 (class 2606 OID 17140)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4043 (class 2606 OID 17142)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 3984 (class 2606 OID 17144)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4046 (class 2606 OID 17146)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 4049 (class 2606 OID 17148)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4061 (class 2606 OID 17150)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 4063 (class 2606 OID 17152)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4196 (class 2606 OID 18177)
-- Name: accessibility_criteria accessibility_criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accessibility_criteria
    ADD CONSTRAINT accessibility_criteria_pkey PRIMARY KEY (id);


--
-- TOC entry 4182 (class 2606 OID 18117)
-- Name: accessibility_levels accessibility_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accessibility_levels
    ADD CONSTRAINT accessibility_levels_pkey PRIMARY KEY (id);


--
-- TOC entry 3938 (class 2606 OID 16524)
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 3943 (class 2606 OID 16455)
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- TOC entry 3946 (class 2606 OID 16424)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3940 (class 2606 OID 16416)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 3933 (class 2606 OID 16446)
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- TOC entry 3935 (class 2606 OID 16410)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 3954 (class 2606 OID 16438)
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3957 (class 2606 OID 16470)
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- TOC entry 3948 (class 2606 OID 16430)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 3960 (class 2606 OID 16444)
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3963 (class 2606 OID 16484)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- TOC entry 3951 (class 2606 OID 16519)
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- TOC entry 4065 (class 2606 OID 17154)
-- Name: corrections corrections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corrections
    ADD CONSTRAINT corrections_pkey PRIMARY KEY (id);


--
-- TOC entry 4174 (class 2606 OID 17798)
-- Name: db_docs_chapter db_docs_chapter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.db_docs_chapter
    ADD CONSTRAINT db_docs_chapter_pkey PRIMARY KEY (id);


--
-- TOC entry 4177 (class 2606 OID 17800)
-- Name: db_docs_chapter db_docs_chapter_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.db_docs_chapter
    ADD CONSTRAINT db_docs_chapter_slug_key UNIQUE (slug);


--
-- TOC entry 4180 (class 2606 OID 17809)
-- Name: db_docs_section db_docs_section_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.db_docs_section
    ADD CONSTRAINT db_docs_section_pkey PRIMARY KEY (id);


--
-- TOC entry 3966 (class 2606 OID 16505)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3928 (class 2606 OID 16404)
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- TOC entry 3930 (class 2606 OID 16402)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3926 (class 2606 OID 16396)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3976 (class 2606 OID 16560)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 4231 (class 2606 OID 18352)
-- Name: django_site django_site_domain_a2e37b91_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain);


--
-- TOC entry 4233 (class 2606 OID 18350)
-- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- TOC entry 4204 (class 2606 OID 18234)
-- Name: features features_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.features
    ADD CONSTRAINT features_pkey PRIMARY KEY (id);


--
-- TOC entry 4206 (class 2606 OID 18236)
-- Name: features features_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.features
    ADD CONSTRAINT features_slug_key UNIQUE (slug);


--
-- TOC entry 4069 (class 2606 OID 17156)
-- Name: libraries frameworks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libraries
    ADD CONSTRAINT frameworks_pkey PRIMARY KEY (id);


--
-- TOC entry 4200 (class 2606 OID 18191)
-- Name: language_accessibility_evaluations language_accessibility_evalua_language_accessibility_level__key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_accessibility_evaluations
    ADD CONSTRAINT language_accessibility_evalua_language_accessibility_level__key UNIQUE (language_accessibility_level_id, criteria_id);


--
-- TOC entry 4202 (class 2606 OID 18189)
-- Name: language_accessibility_evaluations language_accessibility_evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_accessibility_evaluations
    ADD CONSTRAINT language_accessibility_evaluations_pkey PRIMARY KEY (id);


--
-- TOC entry 4192 (class 2606 OID 18153)
-- Name: language_accessibility_levels language_accessibility_levels_language_id_accessibility_lev_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_accessibility_levels
    ADD CONSTRAINT language_accessibility_levels_language_id_accessibility_lev_key UNIQUE (language_id, accessibility_level_id);


--
-- TOC entry 4194 (class 2606 OID 18151)
-- Name: language_accessibility_levels language_accessibility_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_accessibility_levels
    ADD CONSTRAINT language_accessibility_levels_pkey PRIMARY KEY (id);


--
-- TOC entry 4221 (class 2606 OID 18309)
-- Name: language_feature_values language_feature_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_feature_values
    ADD CONSTRAINT language_feature_values_pkey PRIMARY KEY (id);


--
-- TOC entry 4215 (class 2606 OID 18253)
-- Name: language_features language_features_language_id_feature_id_value_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_features
    ADD CONSTRAINT language_features_language_id_feature_id_value_key UNIQUE (language_id, feature_id, value);


--
-- TOC entry 4217 (class 2606 OID 18251)
-- Name: language_features language_features_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_features
    ADD CONSTRAINT language_features_pkey PRIMARY KEY (id);


--
-- TOC entry 4079 (class 2606 OID 17158)
-- Name: language_proposals language_proposals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_proposals
    ADD CONSTRAINT language_proposals_pkey PRIMARY KEY (id);


--
-- TOC entry 4081 (class 2606 OID 17160)
-- Name: language_usage language_usage_language_id_category_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_usage
    ADD CONSTRAINT language_usage_language_id_category_id_key UNIQUE (language_id, category_id);


--
-- TOC entry 4083 (class 2606 OID 17162)
-- Name: language_usage language_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_usage
    ADD CONSTRAINT language_usage_pkey PRIMARY KEY (id);


--
-- TOC entry 3970 (class 2606 OID 16543)
-- Name: languages_framework languages_framework_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages_framework
    ADD CONSTRAINT languages_framework_pkey PRIMARY KEY (id);


--
-- TOC entry 3973 (class 2606 OID 16545)
-- Name: languages_framework languages_framework_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages_framework
    ADD CONSTRAINT languages_framework_slug_key UNIQUE (slug);


--
-- TOC entry 4085 (class 2606 OID 17164)
-- Name: languages languages_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_name_key UNIQUE (name);


--
-- TOC entry 4087 (class 2606 OID 17166)
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- TOC entry 4089 (class 2606 OID 17168)
-- Name: languages languages_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_slug_key UNIQUE (slug);


--
-- TOC entry 4073 (class 2606 OID 17170)
-- Name: libraries libraries_name_language_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libraries
    ADD CONSTRAINT libraries_name_language_unique UNIQUE (name, language_id);


--
-- TOC entry 4091 (class 2606 OID 17172)
-- Name: library_language_associations library_language_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_language_associations
    ADD CONSTRAINT library_language_associations_pkey PRIMARY KEY (library_id, language_id);


--
-- TOC entry 4095 (class 2606 OID 17174)
-- Name: library_languages library_languages_library_id_language_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_languages
    ADD CONSTRAINT library_languages_library_id_language_id_key UNIQUE (library_id, language_id);


--
-- TOC entry 4097 (class 2606 OID 17176)
-- Name: library_languages library_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_languages
    ADD CONSTRAINT library_languages_pkey PRIMARY KEY (id);


--
-- TOC entry 4099 (class 2606 OID 18291)
-- Name: profiles profiles_user_id_36580373_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_36580373_pk PRIMARY KEY (user_id);


--
-- TOC entry 4223 (class 2606 OID 18329)
-- Name: seo_seoconfig seo_seoconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seo_seoconfig
    ADD CONSTRAINT seo_seoconfig_pkey PRIMARY KEY (id);


--
-- TOC entry 4226 (class 2606 OID 18338)
-- Name: seo_seometadata seo_seometadata_content_type_id_object_id_097338cd_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seo_seometadata
    ADD CONSTRAINT seo_seometadata_content_type_id_object_id_097338cd_uniq UNIQUE (content_type_id, object_id);


--
-- TOC entry 4228 (class 2606 OID 18336)
-- Name: seo_seometadata seo_seometadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seo_seometadata
    ADD CONSTRAINT seo_seometadata_pkey PRIMARY KEY (id);


--
-- TOC entry 4186 (class 2606 OID 18132)
-- Name: skills skills_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_name_key UNIQUE (name);


--
-- TOC entry 4188 (class 2606 OID 18130)
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- TOC entry 4101 (class 2606 OID 17180)
-- Name: stats_languages stats_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stats_languages
    ADD CONSTRAINT stats_languages_pkey PRIMARY KEY (id);


--
-- TOC entry 4104 (class 2606 OID 17182)
-- Name: stats_searches stats_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stats_searches
    ADD CONSTRAINT stats_searches_pkey PRIMARY KEY (id);


--
-- TOC entry 4107 (class 2606 OID 17184)
-- Name: stats_users stats_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stats_users
    ADD CONSTRAINT stats_users_pkey PRIMARY KEY (id);


--
-- TOC entry 4111 (class 2606 OID 17186)
-- Name: stats_visits stats_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stats_visits
    ADD CONSTRAINT stats_visits_pkey PRIMARY KEY (id);


--
-- TOC entry 4113 (class 2606 OID 17188)
-- Name: technology_categories technology_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technology_categories
    ADD CONSTRAINT technology_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4115 (class 2606 OID 17190)
-- Name: technology_categories technology_categories_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technology_categories
    ADD CONSTRAINT technology_categories_type_key UNIQUE (type);


--
-- TOC entry 4117 (class 2606 OID 17192)
-- Name: technology_subtypes technology_subtypes_category_id_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technology_subtypes
    ADD CONSTRAINT technology_subtypes_category_id_name_key UNIQUE (category_id, name);


--
-- TOC entry 4119 (class 2606 OID 17194)
-- Name: technology_subtypes technology_subtypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technology_subtypes
    ADD CONSTRAINT technology_subtypes_pkey PRIMARY KEY (id);


--
-- TOC entry 4121 (class 2606 OID 17196)
-- Name: todo_categories todo_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todo_categories
    ADD CONSTRAINT todo_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4123 (class 2606 OID 17198)
-- Name: todo_status todo_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todo_status
    ADD CONSTRAINT todo_status_pkey PRIMARY KEY (id);


--
-- TOC entry 3981 (class 2606 OID 17200)
-- Name: todos todos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT todos_pkey PRIMARY KEY (id);


--
-- TOC entry 4235 (class 2606 OID 18360)
-- Name: tool_category tool_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_category
    ADD CONSTRAINT tool_category_pkey PRIMARY KEY (id);


--
-- TOC entry 4243 (class 2606 OID 18394)
-- Name: tool_language tool_language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_language
    ADD CONSTRAINT tool_language_pkey PRIMARY KEY (id);


--
-- TOC entry 4239 (class 2606 OID 18376)
-- Name: tool tool_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool
    ADD CONSTRAINT tool_pkey PRIMARY KEY (id);


--
-- TOC entry 4245 (class 2606 OID 18421)
-- Name: tool_technology_category tool_technology_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_technology_category
    ADD CONSTRAINT tool_technology_category_pkey PRIMARY KEY (id);


--
-- TOC entry 4247 (class 2606 OID 18438)
-- Name: tool_technology_subtype tool_technology_subtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_technology_subtype
    ADD CONSTRAINT tool_technology_subtype_pkey PRIMARY KEY (id);


--
-- TOC entry 4249 (class 2606 OID 18455)
-- Name: tool_tool tool_tool_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_tool
    ADD CONSTRAINT tool_tool_pkey PRIMARY KEY (id);


--
-- TOC entry 4253 (class 2606 OID 18486)
-- Name: tool_tool_usage tool_tool_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_tool_usage
    ADD CONSTRAINT tool_tool_usage_pkey PRIMARY KEY (id);


--
-- TOC entry 4237 (class 2606 OID 18367)
-- Name: tool_type tool_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_type
    ADD CONSTRAINT tool_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4251 (class 2606 OID 18479)
-- Name: tool_usage tool_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_usage
    ADD CONSTRAINT tool_usage_pkey PRIMARY KEY (id);


--
-- TOC entry 4255 (class 2606 OID 18507)
-- Name: tools_technologycategory tools_technologycategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_technologycategory
    ADD CONSTRAINT tools_technologycategory_pkey PRIMARY KEY (id);


--
-- TOC entry 4262 (class 2606 OID 18527)
-- Name: tools_technologysubtype tools_technologysubtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_technologysubtype
    ADD CONSTRAINT tools_technologysubtype_pkey PRIMARY KEY (id);


--
-- TOC entry 4265 (class 2606 OID 18535)
-- Name: tools_tool tools_tool_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_tool
    ADD CONSTRAINT tools_tool_pkey PRIMARY KEY (id);


--
-- TOC entry 4257 (class 2606 OID 18513)
-- Name: tools_toolcategory tools_toolcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_toolcategory
    ADD CONSTRAINT tools_toolcategory_pkey PRIMARY KEY (id);


--
-- TOC entry 4271 (class 2606 OID 18541)
-- Name: tools_toollanguage tools_toollanguage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_toollanguage
    ADD CONSTRAINT tools_toollanguage_pkey PRIMARY KEY (id);


--
-- TOC entry 4259 (class 2606 OID 18519)
-- Name: tools_tooltype tools_tooltype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_tooltype
    ADD CONSTRAINT tools_tooltype_pkey PRIMARY KEY (id);


--
-- TOC entry 4075 (class 2606 OID 17202)
-- Name: libraries unique_framework_per_language; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libraries
    ADD CONSTRAINT unique_framework_per_language UNIQUE (name, language_id);


--
-- TOC entry 4077 (class 2606 OID 17204)
-- Name: libraries unique_library_slug; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libraries
    ADD CONSTRAINT unique_library_slug UNIQUE (slug);


--
-- TOC entry 4241 (class 2606 OID 18467)
-- Name: tool unique_tool_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool
    ADD CONSTRAINT unique_tool_name UNIQUE (name);


--
-- TOC entry 4125 (class 2606 OID 17206)
-- Name: usage_categories usage_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usage_categories
    ADD CONSTRAINT usage_categories_name_key UNIQUE (name);


--
-- TOC entry 4127 (class 2606 OID 17208)
-- Name: usage_categories usage_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usage_categories
    ADD CONSTRAINT usage_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4129 (class 2606 OID 17210)
-- Name: user_language_likes user_language_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_language_likes
    ADD CONSTRAINT user_language_likes_pkey PRIMARY KEY (id);


--
-- TOC entry 4131 (class 2606 OID 17212)
-- Name: user_language_likes user_language_likes_user_id_language_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_language_likes
    ADD CONSTRAINT user_language_likes_user_id_language_id_key UNIQUE (user_id, language_id);


--
-- TOC entry 4133 (class 2606 OID 17214)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4135 (class 2606 OID 17216)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4137 (class 2606 OID 17218)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4165 (class 2606 OID 17660)
-- Name: utilisateurs_correctioncomment utilisateurs_correctioncomment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs_correctioncomment
    ADD CONSTRAINT utilisateurs_correctioncomment_pkey PRIMARY KEY (id);


--
-- TOC entry 4168 (class 2606 OID 17682)
-- Name: utilisateurs_languageexpertise utilisateurs_languageexp_user_id_language_id_a01240e1_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs_languageexpertise
    ADD CONSTRAINT utilisateurs_languageexp_user_id_language_id_a01240e1_uniq UNIQUE (user_id, language_id);


--
-- TOC entry 4171 (class 2606 OID 17668)
-- Name: utilisateurs_languageexpertise utilisateurs_languageexpertise_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs_languageexpertise
    ADD CONSTRAINT utilisateurs_languageexpertise_pkey PRIMARY KEY (id);


--
-- TOC entry 4139 (class 2606 OID 17220)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: postgres
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4144 (class 2606 OID 17222)
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: postgres
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- TOC entry 4141 (class 2606 OID 17224)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: postgres
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4148 (class 2606 OID 17226)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: postgres
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4150 (class 2606 OID 17228)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: postgres
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4152 (class 2606 OID 17230)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: postgres
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4157 (class 2606 OID 17232)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: postgres
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4162 (class 2606 OID 17234)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: postgres
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4160 (class 2606 OID 17236)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: postgres
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 3989 (class 1259 OID 17237)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 4051 (class 1259 OID 17238)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4052 (class 1259 OID 17239)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4053 (class 1259 OID 17240)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4010 (class 1259 OID 17241)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 3990 (class 1259 OID 17242)
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- TOC entry 3995 (class 1259 OID 17243)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 4694 (class 0 OID 0)
-- Dependencies: 3995
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 4000 (class 1259 OID 17244)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 3993 (class 1259 OID 17245)
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- TOC entry 3994 (class 1259 OID 17246)
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- TOC entry 4007 (class 1259 OID 17247)
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- TOC entry 4015 (class 1259 OID 17248)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 4016 (class 1259 OID 17249)
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- TOC entry 4020 (class 1259 OID 17250)
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- TOC entry 4021 (class 1259 OID 17251)
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- TOC entry 4022 (class 1259 OID 17252)
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- TOC entry 4054 (class 1259 OID 17253)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4055 (class 1259 OID 17254)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4023 (class 1259 OID 17255)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 4024 (class 1259 OID 17256)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 4025 (class 1259 OID 17257)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 4028 (class 1259 OID 17258)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 4031 (class 1259 OID 17259)
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- TOC entry 4036 (class 1259 OID 17260)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 4037 (class 1259 OID 17261)
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- TOC entry 4038 (class 1259 OID 17262)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 4041 (class 1259 OID 17263)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 3982 (class 1259 OID 17264)
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- TOC entry 3985 (class 1259 OID 17265)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 4044 (class 1259 OID 17266)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 4047 (class 1259 OID 17267)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 4050 (class 1259 OID 17268)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 4017 (class 1259 OID 17269)
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- TOC entry 3986 (class 1259 OID 17270)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 4056 (class 1259 OID 17271)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 4695 (class 0 OID 0)
-- Dependencies: 4056
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: postgres
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 4057 (class 1259 OID 17272)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 4058 (class 1259 OID 17273)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 4059 (class 1259 OID 17274)
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: postgres
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- TOC entry 3936 (class 1259 OID 16525)
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- TOC entry 3941 (class 1259 OID 16466)
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- TOC entry 3944 (class 1259 OID 16467)
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- TOC entry 3931 (class 1259 OID 16452)
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- TOC entry 3952 (class 1259 OID 16482)
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- TOC entry 3955 (class 1259 OID 16481)
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- TOC entry 3958 (class 1259 OID 16496)
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 3961 (class 1259 OID 16495)
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 3949 (class 1259 OID 16520)
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- TOC entry 4175 (class 1259 OID 17810)
-- Name: db_docs_chapter_slug_d1e9c713_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX db_docs_chapter_slug_d1e9c713_like ON public.db_docs_chapter USING btree (slug varchar_pattern_ops);


--
-- TOC entry 4178 (class 1259 OID 17816)
-- Name: db_docs_section_chapter_id_5d71a6e0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX db_docs_section_chapter_id_5d71a6e0 ON public.db_docs_section USING btree (chapter_id);


--
-- TOC entry 3964 (class 1259 OID 16516)
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- TOC entry 3967 (class 1259 OID 16517)
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- TOC entry 3974 (class 1259 OID 16562)
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- TOC entry 3977 (class 1259 OID 16561)
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- TOC entry 4229 (class 1259 OID 18353)
-- Name: django_site_domain_a2e37b91_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_site_domain_a2e37b91_like ON public.django_site USING btree (domain varchar_pattern_ops);


--
-- TOC entry 4183 (class 1259 OID 18118)
-- Name: idx_accessibility_levels_level_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_accessibility_levels_level_number ON public.accessibility_levels USING btree (level_number);


--
-- TOC entry 4066 (class 1259 OID 17275)
-- Name: idx_corrections_language_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_corrections_language_id ON public.corrections USING btree (language_id);


--
-- TOC entry 4067 (class 1259 OID 17276)
-- Name: idx_corrections_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_corrections_user_id ON public.corrections USING btree (user_id);


--
-- TOC entry 4197 (class 1259 OID 18203)
-- Name: idx_evaluations_criteria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_evaluations_criteria ON public.language_accessibility_evaluations USING btree (criteria_id);


--
-- TOC entry 4198 (class 1259 OID 18202)
-- Name: idx_evaluations_language_level; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_evaluations_language_level ON public.language_accessibility_evaluations USING btree (language_accessibility_level_id);


--
-- TOC entry 4207 (class 1259 OID 18239)
-- Name: idx_features_display_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_features_display_order ON public.features USING btree (display_order);


--
-- TOC entry 4208 (class 1259 OID 18237)
-- Name: idx_features_feature_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_features_feature_type ON public.features USING btree (feature_type);


--
-- TOC entry 4209 (class 1259 OID 18238)
-- Name: idx_features_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_features_slug ON public.features USING btree (slug);


--
-- TOC entry 4070 (class 1259 OID 17277)
-- Name: idx_frameworks_language_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_frameworks_language_id ON public.libraries USING btree (language_id);


--
-- TOC entry 4189 (class 1259 OID 18164)
-- Name: idx_lang_access_language; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lang_access_language ON public.language_accessibility_levels USING btree (language_id);


--
-- TOC entry 4190 (class 1259 OID 18165)
-- Name: idx_lang_access_level; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lang_access_level ON public.language_accessibility_levels USING btree (accessibility_level_id);


--
-- TOC entry 4218 (class 1259 OID 18321)
-- Name: idx_language_feature_values_feature_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_language_feature_values_feature_id ON public.language_feature_values USING btree (feature_id);


--
-- TOC entry 4219 (class 1259 OID 18320)
-- Name: idx_language_feature_values_language_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_language_feature_values_language_id ON public.language_feature_values USING btree (language_id);


--
-- TOC entry 4210 (class 1259 OID 18265)
-- Name: idx_language_features_feature_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_language_features_feature_id ON public.language_features USING btree (feature_id);


--
-- TOC entry 4211 (class 1259 OID 18266)
-- Name: idx_language_features_is_primary; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_language_features_is_primary ON public.language_features USING btree (is_primary);


--
-- TOC entry 4212 (class 1259 OID 18264)
-- Name: idx_language_features_language_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_language_features_language_id ON public.language_features USING btree (language_id);


--
-- TOC entry 4213 (class 1259 OID 18267)
-- Name: idx_language_features_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_language_features_value ON public.language_features USING btree (value);


--
-- TOC entry 4071 (class 1259 OID 17278)
-- Name: idx_libraries_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_libraries_slug ON public.libraries USING btree (slug);


--
-- TOC entry 4092 (class 1259 OID 17279)
-- Name: idx_library_languages_language_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_library_languages_language_id ON public.library_languages USING btree (language_id);


--
-- TOC entry 4093 (class 1259 OID 17280)
-- Name: idx_library_languages_library_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_library_languages_library_id ON public.library_languages USING btree (library_id);


--
-- TOC entry 4184 (class 1259 OID 18133)
-- Name: idx_skills_skill_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_skills_skill_type ON public.skills USING btree (skill_type);


--
-- TOC entry 4102 (class 1259 OID 17281)
-- Name: idx_stats_searches_search_term; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stats_searches_search_term ON public.stats_searches USING btree (search_term);


--
-- TOC entry 4105 (class 1259 OID 17282)
-- Name: idx_stats_users_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stats_users_user_id ON public.stats_users USING btree (user_id);


--
-- TOC entry 4108 (class 1259 OID 17283)
-- Name: idx_stats_visits_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stats_visits_created_at ON public.stats_visits USING btree (created_at);


--
-- TOC entry 4109 (class 1259 OID 17284)
-- Name: idx_stats_visits_page_path; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stats_visits_page_path ON public.stats_visits USING btree (page_path);


--
-- TOC entry 3978 (class 1259 OID 17285)
-- Name: idx_todos_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_todos_status ON public.todos USING btree (status_id);


--
-- TOC entry 3979 (class 1259 OID 17286)
-- Name: idx_todos_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_todos_user ON public.todos USING btree (user_id);


--
-- TOC entry 3968 (class 1259 OID 16553)
-- Name: languages_framework_language_id_6fdceb70; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX languages_framework_language_id_6fdceb70 ON public.languages_framework USING btree (language_id);


--
-- TOC entry 3971 (class 1259 OID 16552)
-- Name: languages_framework_slug_2924fc4e_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX languages_framework_slug_2924fc4e_like ON public.languages_framework USING btree (slug varchar_pattern_ops);


--
-- TOC entry 4224 (class 1259 OID 18344)
-- Name: seo_seometadata_content_type_id_b92121ee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX seo_seometadata_content_type_id_b92121ee ON public.seo_seometadata USING btree (content_type_id);


--
-- TOC entry 4260 (class 1259 OID 18552)
-- Name: tools_technologysubtype_category_id_012ae5d7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tools_technologysubtype_category_id_012ae5d7 ON public.tools_technologysubtype USING btree (category_id);


--
-- TOC entry 4263 (class 1259 OID 18570)
-- Name: tools_tool_category_id_75826aee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tools_tool_category_id_75826aee ON public.tools_tool USING btree (category_id);


--
-- TOC entry 4266 (class 1259 OID 18568)
-- Name: tools_tool_technology_category_id_35ab9fd6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tools_tool_technology_category_id_35ab9fd6 ON public.tools_tool USING btree (technology_category_id);


--
-- TOC entry 4267 (class 1259 OID 18569)
-- Name: tools_tool_technology_subtype_id_8c591fa0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tools_tool_technology_subtype_id_8c591fa0 ON public.tools_tool USING btree (technology_subtype_id);


--
-- TOC entry 4268 (class 1259 OID 18583)
-- Name: tools_tool_type_id_1e0b0d96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tools_tool_type_id_1e0b0d96 ON public.tools_tool USING btree (type_id);


--
-- TOC entry 4269 (class 1259 OID 18581)
-- Name: tools_toollanguage_language_id_9300b205; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tools_toollanguage_language_id_9300b205 ON public.tools_toollanguage USING btree (language_id);


--
-- TOC entry 4272 (class 1259 OID 18582)
-- Name: tools_toollanguage_tool_id_7f90b0ed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tools_toollanguage_tool_id_7f90b0ed ON public.tools_toollanguage USING btree (tool_id);


--
-- TOC entry 4163 (class 1259 OID 17679)
-- Name: utilisateurs_correctioncomment_correction_id_dc0ede57; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX utilisateurs_correctioncomment_correction_id_dc0ede57 ON public.utilisateurs_correctioncomment USING btree (correction_id);


--
-- TOC entry 4166 (class 1259 OID 17680)
-- Name: utilisateurs_correctioncomment_user_id_e01a021a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX utilisateurs_correctioncomment_user_id_e01a021a ON public.utilisateurs_correctioncomment USING btree (user_id);


--
-- TOC entry 4169 (class 1259 OID 17693)
-- Name: utilisateurs_languageexpertise_language_id_d6d8f621; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX utilisateurs_languageexpertise_language_id_d6d8f621 ON public.utilisateurs_languageexpertise USING btree (language_id);


--
-- TOC entry 4172 (class 1259 OID 17694)
-- Name: utilisateurs_languageexpertise_user_id_167b9ff7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX utilisateurs_languageexpertise_user_id_167b9ff7 ON public.utilisateurs_languageexpertise USING btree (user_id);


--
-- TOC entry 4142 (class 1259 OID 17287)
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: postgres
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- TOC entry 4145 (class 1259 OID 17288)
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: postgres
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- TOC entry 4146 (class 1259 OID 17289)
-- Name: bname; Type: INDEX; Schema: storage; Owner: postgres
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4153 (class 1259 OID 17290)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: postgres
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4158 (class 1259 OID 17291)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: postgres
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4154 (class 1259 OID 17292)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: postgres
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4155 (class 1259 OID 17293)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: postgres
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4355 (class 2620 OID 17294)
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: postgres
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- TOC entry 4356 (class 2620 OID 17295)
-- Name: corrections set_corrections_user_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_corrections_user_id BEFORE INSERT ON public.corrections FOR EACH ROW EXECUTE FUNCTION public.set_user_id();


--
-- TOC entry 4361 (class 2620 OID 18269)
-- Name: features update_features_modtime; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_features_modtime BEFORE UPDATE ON public.features FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- TOC entry 4362 (class 2620 OID 18270)
-- Name: language_features update_language_features_modtime; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_language_features_modtime BEFORE UPDATE ON public.language_features FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- TOC entry 4357 (class 2620 OID 17296)
-- Name: profiles update_profiles_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4358 (class 2620 OID 17297)
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4359 (class 2620 OID 17298)
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: postgres
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- TOC entry 4360 (class 2620 OID 17299)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: postgres
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4286 (class 2606 OID 17300)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4287 (class 2606 OID 17305)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4288 (class 2606 OID 17310)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4289 (class 2606 OID 17315)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4290 (class 2606 OID 17320)
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4291 (class 2606 OID 17325)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4292 (class 2606 OID 17330)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4293 (class 2606 OID 17335)
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- TOC entry 4294 (class 2606 OID 17340)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4285 (class 2606 OID 17345)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4295 (class 2606 OID 17350)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4274 (class 2606 OID 16461)
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4275 (class 2606 OID 16456)
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4273 (class 2606 OID 16447)
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4276 (class 2606 OID 16476)
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4277 (class 2606 OID 16471)
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4278 (class 2606 OID 16490)
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4279 (class 2606 OID 16485)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4296 (class 2606 OID 17355)
-- Name: corrections corrections_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corrections
    ADD CONSTRAINT corrections_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id);


--
-- TOC entry 4297 (class 2606 OID 18100)
-- Name: corrections corrections_reviewed_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corrections
    ADD CONSTRAINT corrections_reviewed_by_id_fkey FOREIGN KEY (reviewed_by_id) REFERENCES public.auth_user(id) ON DELETE SET NULL;


--
-- TOC entry 4298 (class 2606 OID 17360)
-- Name: corrections corrections_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corrections
    ADD CONSTRAINT corrections_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- TOC entry 4325 (class 2606 OID 17811)
-- Name: db_docs_section db_docs_section_chapter_id_5d71a6e0_fk_db_docs_chapter_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.db_docs_section
    ADD CONSTRAINT db_docs_section_chapter_id_5d71a6e0_fk_db_docs_chapter_id FOREIGN KEY (chapter_id) REFERENCES public.db_docs_chapter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4280 (class 2606 OID 16506)
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4281 (class 2606 OID 16511)
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4299 (class 2606 OID 17365)
-- Name: libraries frameworks_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libraries
    ADD CONSTRAINT frameworks_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id);


--
-- TOC entry 4328 (class 2606 OID 18192)
-- Name: language_accessibility_evaluations language_accessibility_evalua_language_accessibility_level_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_accessibility_evaluations
    ADD CONSTRAINT language_accessibility_evalua_language_accessibility_level_fkey FOREIGN KEY (language_accessibility_level_id) REFERENCES public.language_accessibility_levels(id) ON DELETE CASCADE;


--
-- TOC entry 4329 (class 2606 OID 18197)
-- Name: language_accessibility_evaluations language_accessibility_evaluations_criteria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_accessibility_evaluations
    ADD CONSTRAINT language_accessibility_evaluations_criteria_id_fkey FOREIGN KEY (criteria_id) REFERENCES public.accessibility_criteria(id) ON DELETE CASCADE;


--
-- TOC entry 4326 (class 2606 OID 18159)
-- Name: language_accessibility_levels language_accessibility_levels_accessibility_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_accessibility_levels
    ADD CONSTRAINT language_accessibility_levels_accessibility_level_id_fkey FOREIGN KEY (accessibility_level_id) REFERENCES public.accessibility_levels(id) ON DELETE CASCADE;


--
-- TOC entry 4327 (class 2606 OID 18154)
-- Name: language_accessibility_levels language_accessibility_levels_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_accessibility_levels
    ADD CONSTRAINT language_accessibility_levels_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id) ON DELETE CASCADE;


--
-- TOC entry 4332 (class 2606 OID 18315)
-- Name: language_feature_values language_feature_values_feature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_feature_values
    ADD CONSTRAINT language_feature_values_feature_id_fkey FOREIGN KEY (feature_id) REFERENCES public.language_features(id) ON DELETE CASCADE;


--
-- TOC entry 4333 (class 2606 OID 18310)
-- Name: language_feature_values language_feature_values_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_feature_values
    ADD CONSTRAINT language_feature_values_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id) ON DELETE CASCADE;


--
-- TOC entry 4330 (class 2606 OID 18259)
-- Name: language_features language_features_feature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_features
    ADD CONSTRAINT language_features_feature_id_fkey FOREIGN KEY (feature_id) REFERENCES public.features(id) ON DELETE CASCADE;


--
-- TOC entry 4331 (class 2606 OID 18254)
-- Name: language_features language_features_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_features
    ADD CONSTRAINT language_features_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id) ON DELETE CASCADE;


--
-- TOC entry 4300 (class 2606 OID 17370)
-- Name: language_proposals language_proposals_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_proposals
    ADD CONSTRAINT language_proposals_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- TOC entry 4301 (class 2606 OID 17375)
-- Name: language_usage language_usage_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_usage
    ADD CONSTRAINT language_usage_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.usage_categories(id) ON DELETE CASCADE;


--
-- TOC entry 4302 (class 2606 OID 17380)
-- Name: language_usage language_usage_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_usage
    ADD CONSTRAINT language_usage_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id) ON DELETE CASCADE;


--
-- TOC entry 4303 (class 2606 OID 18134)
-- Name: languages languages_default_accessibility_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_default_accessibility_level_id_fkey FOREIGN KEY (default_accessibility_level_id) REFERENCES public.accessibility_levels(id) ON DELETE SET NULL;


--
-- TOC entry 4304 (class 2606 OID 17385)
-- Name: library_language_associations library_language_associations_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_language_associations
    ADD CONSTRAINT library_language_associations_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id) ON DELETE CASCADE;


--
-- TOC entry 4305 (class 2606 OID 17390)
-- Name: library_language_associations library_language_associations_library_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_language_associations
    ADD CONSTRAINT library_language_associations_library_id_fkey FOREIGN KEY (library_id) REFERENCES public.libraries(id) ON DELETE CASCADE;


--
-- TOC entry 4306 (class 2606 OID 17395)
-- Name: library_languages library_languages_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_languages
    ADD CONSTRAINT library_languages_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id) ON DELETE CASCADE;


--
-- TOC entry 4307 (class 2606 OID 17400)
-- Name: library_languages library_languages_library_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_languages
    ADD CONSTRAINT library_languages_library_id_fkey FOREIGN KEY (library_id) REFERENCES public.libraries(id) ON DELETE CASCADE;


--
-- TOC entry 4308 (class 2606 OID 18292)
-- Name: profiles profiles_user_id_36580373_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_36580373_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4334 (class 2606 OID 18339)
-- Name: seo_seometadata seo_seometadata_content_type_id_b92121ee_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seo_seometadata
    ADD CONSTRAINT seo_seometadata_content_type_id_b92121ee_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4309 (class 2606 OID 17410)
-- Name: stats_languages stats_languages_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stats_languages
    ADD CONSTRAINT stats_languages_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id) ON DELETE CASCADE;


--
-- TOC entry 4310 (class 2606 OID 17415)
-- Name: stats_searches stats_searches_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stats_searches
    ADD CONSTRAINT stats_searches_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- TOC entry 4311 (class 2606 OID 17420)
-- Name: stats_users stats_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stats_users
    ADD CONSTRAINT stats_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4312 (class 2606 OID 17425)
-- Name: stats_visits stats_visits_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stats_visits
    ADD CONSTRAINT stats_visits_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- TOC entry 4313 (class 2606 OID 17430)
-- Name: technology_subtypes technology_subtypes_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technology_subtypes
    ADD CONSTRAINT technology_subtypes_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.technology_categories(id);


--
-- TOC entry 4282 (class 2606 OID 17435)
-- Name: todos todos_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT todos_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.todo_categories(id);


--
-- TOC entry 4283 (class 2606 OID 17440)
-- Name: todos todos_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT todos_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.todo_status(id);


--
-- TOC entry 4284 (class 2606 OID 17445)
-- Name: todos todos_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT todos_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- TOC entry 4338 (class 2606 OID 18400)
-- Name: tool_language tool_language_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_language
    ADD CONSTRAINT tool_language_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id) ON DELETE CASCADE;


--
-- TOC entry 4339 (class 2606 OID 18395)
-- Name: tool_language tool_language_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_language
    ADD CONSTRAINT tool_language_tool_id_fkey FOREIGN KEY (tool_id) REFERENCES public.tool(id) ON DELETE CASCADE;


--
-- TOC entry 4335 (class 2606 OID 18405)
-- Name: tool tool_technology_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool
    ADD CONSTRAINT tool_technology_category_id_fkey FOREIGN KEY (technology_category_id) REFERENCES public.technology_categories(id);


--
-- TOC entry 4340 (class 2606 OID 18427)
-- Name: tool_technology_category tool_technology_category_technology_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_technology_category
    ADD CONSTRAINT tool_technology_category_technology_category_id_fkey FOREIGN KEY (technology_category_id) REFERENCES public.technology_categories(id) ON DELETE CASCADE;


--
-- TOC entry 4341 (class 2606 OID 18422)
-- Name: tool_technology_category tool_technology_category_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_technology_category
    ADD CONSTRAINT tool_technology_category_tool_id_fkey FOREIGN KEY (tool_id) REFERENCES public.tool(id) ON DELETE CASCADE;


--
-- TOC entry 4336 (class 2606 OID 18410)
-- Name: tool tool_technology_subtype_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool
    ADD CONSTRAINT tool_technology_subtype_id_fkey FOREIGN KEY (technology_subtype_id) REFERENCES public.technology_subtypes(id);


--
-- TOC entry 4342 (class 2606 OID 18444)
-- Name: tool_technology_subtype tool_technology_subtype_technology_subtype_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_technology_subtype
    ADD CONSTRAINT tool_technology_subtype_technology_subtype_id_fkey FOREIGN KEY (technology_subtype_id) REFERENCES public.technology_subtypes(id) ON DELETE CASCADE;


--
-- TOC entry 4343 (class 2606 OID 18439)
-- Name: tool_technology_subtype tool_technology_subtype_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_technology_subtype
    ADD CONSTRAINT tool_technology_subtype_tool_id_fkey FOREIGN KEY (tool_id) REFERENCES public.tool(id) ON DELETE CASCADE;


--
-- TOC entry 4344 (class 2606 OID 18461)
-- Name: tool_tool tool_tool_related_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_tool
    ADD CONSTRAINT tool_tool_related_tool_id_fkey FOREIGN KEY (related_tool_id) REFERENCES public.tool(id) ON DELETE CASCADE;


--
-- TOC entry 4345 (class 2606 OID 18456)
-- Name: tool_tool tool_tool_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_tool
    ADD CONSTRAINT tool_tool_tool_id_fkey FOREIGN KEY (tool_id) REFERENCES public.tool(id) ON DELETE CASCADE;


--
-- TOC entry 4346 (class 2606 OID 18487)
-- Name: tool_tool_usage tool_tool_usage_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_tool_usage
    ADD CONSTRAINT tool_tool_usage_tool_id_fkey FOREIGN KEY (tool_id) REFERENCES public.tool(id) ON DELETE CASCADE;


--
-- TOC entry 4347 (class 2606 OID 18492)
-- Name: tool_tool_usage tool_tool_usage_usage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_tool_usage
    ADD CONSTRAINT tool_tool_usage_usage_id_fkey FOREIGN KEY (usage_id) REFERENCES public.tool_usage(id) ON DELETE CASCADE;


--
-- TOC entry 4337 (class 2606 OID 18382)
-- Name: tool tool_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool
    ADD CONSTRAINT tool_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.tool_type(id);


--
-- TOC entry 4348 (class 2606 OID 18547)
-- Name: tools_technologysubtype tools_technologysubt_category_id_012ae5d7_fk_tools_tec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_technologysubtype
    ADD CONSTRAINT tools_technologysubt_category_id_012ae5d7_fk_tools_tec FOREIGN KEY (category_id) REFERENCES public.tools_technologycategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4349 (class 2606 OID 18563)
-- Name: tools_tool tools_tool_category_id_75826aee_fk_tools_toolcategory_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_tool
    ADD CONSTRAINT tools_tool_category_id_75826aee_fk_tools_toolcategory_id FOREIGN KEY (category_id) REFERENCES public.tools_toolcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4350 (class 2606 OID 18553)
-- Name: tools_tool tools_tool_technology_category__35ab9fd6_fk_tools_tec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_tool
    ADD CONSTRAINT tools_tool_technology_category__35ab9fd6_fk_tools_tec FOREIGN KEY (technology_category_id) REFERENCES public.tools_technologycategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4351 (class 2606 OID 18558)
-- Name: tools_tool tools_tool_technology_subtype_i_8c591fa0_fk_tools_tec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_tool
    ADD CONSTRAINT tools_tool_technology_subtype_i_8c591fa0_fk_tools_tec FOREIGN KEY (technology_subtype_id) REFERENCES public.tools_technologysubtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4352 (class 2606 OID 18542)
-- Name: tools_tool tools_tool_type_id_1e0b0d96_fk_tools_tooltype_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_tool
    ADD CONSTRAINT tools_tool_type_id_1e0b0d96_fk_tools_tooltype_id FOREIGN KEY (type_id) REFERENCES public.tools_tooltype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4353 (class 2606 OID 18571)
-- Name: tools_toollanguage tools_toollanguage_language_id_9300b205_fk_languages_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_toollanguage
    ADD CONSTRAINT tools_toollanguage_language_id_9300b205_fk_languages_id FOREIGN KEY (language_id) REFERENCES public.languages(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4354 (class 2606 OID 18576)
-- Name: tools_toollanguage tools_toollanguage_tool_id_7f90b0ed_fk_tools_tool_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools_toollanguage
    ADD CONSTRAINT tools_toollanguage_tool_id_7f90b0ed_fk_tools_tool_id FOREIGN KEY (tool_id) REFERENCES public.tools_tool(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4314 (class 2606 OID 17450)
-- Name: user_language_likes user_language_likes_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_language_likes
    ADD CONSTRAINT user_language_likes_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id) ON DELETE CASCADE;


--
-- TOC entry 4315 (class 2606 OID 17455)
-- Name: user_language_likes user_language_likes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_language_likes
    ADD CONSTRAINT user_language_likes_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4316 (class 2606 OID 17460)
-- Name: user_roles user_roles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4317 (class 2606 OID 17465)
-- Name: users users_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4322 (class 2606 OID 17669)
-- Name: utilisateurs_correctioncomment utilisateurs_correct_correction_id_dc0ede57_fk_correctio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs_correctioncomment
    ADD CONSTRAINT utilisateurs_correct_correction_id_dc0ede57_fk_correctio FOREIGN KEY (correction_id) REFERENCES public.corrections(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4323 (class 2606 OID 17674)
-- Name: utilisateurs_correctioncomment utilisateurs_correctioncomment_user_id_e01a021a_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs_correctioncomment
    ADD CONSTRAINT utilisateurs_correctioncomment_user_id_e01a021a_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4324 (class 2606 OID 17683)
-- Name: utilisateurs_languageexpertise utilisateurs_languag_language_id_d6d8f621_fk_languages; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs_languageexpertise
    ADD CONSTRAINT utilisateurs_languag_language_id_d6d8f621_fk_languages FOREIGN KEY (language_id) REFERENCES public.languages(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4318 (class 2606 OID 17470)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: postgres
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4319 (class 2606 OID 17475)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: postgres
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4320 (class 2606 OID 17480)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: postgres
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4321 (class 2606 OID 17485)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: postgres
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4510 (class 0 OID 16799)
-- Dependencies: 257
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4511 (class 0 OID 16805)
-- Dependencies: 258
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4512 (class 0 OID 16810)
-- Dependencies: 259
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4513 (class 0 OID 16817)
-- Dependencies: 260
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4514 (class 0 OID 16822)
-- Dependencies: 261
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4515 (class 0 OID 16827)
-- Dependencies: 262
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4516 (class 0 OID 16832)
-- Dependencies: 263
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4517 (class 0 OID 16837)
-- Dependencies: 264
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4518 (class 0 OID 16845)
-- Dependencies: 265
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4519 (class 0 OID 16852)
-- Dependencies: 267
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4520 (class 0 OID 16860)
-- Dependencies: 268
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4521 (class 0 OID 16866)
-- Dependencies: 269
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4509 (class 0 OID 16762)
-- Dependencies: 256
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4522 (class 0 OID 16869)
-- Dependencies: 270
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4523 (class 0 OID 16875)
-- Dependencies: 271
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4524 (class 0 OID 16881)
-- Dependencies: 272
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: postgres
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4551 (class 3256 OID 17490)
-- Name: todo_categories Everyone can view categories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Everyone can view categories" ON public.todo_categories FOR SELECT USING (true);


--
-- TOC entry 4552 (class 3256 OID 17491)
-- Name: todo_status Everyone can view statuses; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Everyone can view statuses" ON public.todo_status FOR SELECT USING (true);


--
-- TOC entry 4553 (class 3256 OID 17492)
-- Name: users Les admins et validateurs peuvent voir tous les utilisateurs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les admins et validateurs peuvent voir tous les utilisateurs" ON public.users FOR SELECT USING ((public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role)));


--
-- TOC entry 4554 (class 3256 OID 17493)
-- Name: stats_searches Les admins et validateurs peuvent voir toutes les stats de rech; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les admins et validateurs peuvent voir toutes les stats de rech" ON public.stats_searches FOR SELECT USING ((public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role)));


--
-- TOC entry 4555 (class 3256 OID 17494)
-- Name: stats_users Les admins et validateurs peuvent voir toutes les stats utilisa; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les admins et validateurs peuvent voir toutes les stats utilisa" ON public.stats_users FOR SELECT USING ((public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role)));


--
-- TOC entry 4556 (class 3256 OID 17495)
-- Name: users Les admins peuvent créer des utilisateurs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les admins peuvent créer des utilisateurs" ON public.users FOR INSERT WITH CHECK (public.has_role('admin'::public.user_role));


--
-- TOC entry 4557 (class 3256 OID 17496)
-- Name: users Les admins peuvent modifier les utilisateurs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les admins peuvent modifier les utilisateurs" ON public.users FOR UPDATE USING (public.has_role('admin'::public.user_role));


--
-- TOC entry 4558 (class 3256 OID 17497)
-- Name: user_language_likes Les admins peuvent tout voir; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les admins peuvent tout voir" ON public.user_language_likes USING (public.has_role('admin'::public.user_role));


--
-- TOC entry 4559 (class 3256 OID 17500)
-- Name: user_language_likes Les utilisateurs peuvent supprimer leurs propres likes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les utilisateurs peuvent supprimer leurs propres likes" ON public.user_language_likes FOR DELETE USING ((auth.uid() = user_id));


--
-- TOC entry 4560 (class 3256 OID 17502)
-- Name: users Les utilisateurs peuvent voir leur propre profil; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les utilisateurs peuvent voir leur propre profil" ON public.users FOR SELECT USING ((auth.uid() = id));


--
-- TOC entry 4561 (class 3256 OID 17503)
-- Name: user_roles Les utilisateurs peuvent voir leur propre rôle; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les utilisateurs peuvent voir leur propre rôle" ON public.user_roles FOR SELECT USING (((auth.uid() = id) OR public.has_role('admin'::public.user_role)));


--
-- TOC entry 4562 (class 3256 OID 17504)
-- Name: corrections Les utilisateurs peuvent voir leurs propres corrections; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les utilisateurs peuvent voir leurs propres corrections" ON public.corrections FOR SELECT USING (((auth.uid() = user_id) OR public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role)));


--
-- TOC entry 4563 (class 3256 OID 17505)
-- Name: user_language_likes Les utilisateurs peuvent voir leurs propres likes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les utilisateurs peuvent voir leurs propres likes" ON public.user_language_likes FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4564 (class 3256 OID 17506)
-- Name: language_proposals Les utilisateurs peuvent voir leurs propres propositions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les utilisateurs peuvent voir leurs propres propositions" ON public.language_proposals FOR SELECT USING (((auth.uid() = user_id) OR public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role)));


--
-- TOC entry 4565 (class 3256 OID 17507)
-- Name: stats_users Les utilisateurs peuvent voir leurs propres stats; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Les utilisateurs peuvent voir leurs propres stats" ON public.stats_users FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4566 (class 3256 OID 17508)
-- Name: languages Seuls les admins et validateurs peuvent insérer des langages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins et validateurs peuvent insérer des langages" ON public.languages FOR INSERT WITH CHECK ((public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role)));


--
-- TOC entry 4567 (class 3256 OID 17509)
-- Name: languages Seuls les admins et validateurs peuvent modifier des langages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins et validateurs peuvent modifier des langages" ON public.languages FOR UPDATE USING ((public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role)));


--
-- TOC entry 4568 (class 3256 OID 17510)
-- Name: corrections Seuls les admins et validateurs peuvent modifier les correction; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins et validateurs peuvent modifier les correction" ON public.corrections FOR UPDATE USING ((public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role)));


--
-- TOC entry 4569 (class 3256 OID 17511)
-- Name: language_proposals Seuls les admins et validateurs peuvent modifier les propositio; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins et validateurs peuvent modifier les propositio" ON public.language_proposals FOR UPDATE USING ((public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role)));


--
-- TOC entry 4570 (class 3256 OID 17512)
-- Name: languages Seuls les admins et validateurs peuvent supprimer des langages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins et validateurs peuvent supprimer des langages" ON public.languages FOR DELETE USING ((public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role)));


--
-- TOC entry 4572 (class 3256 OID 17513)
-- Name: technology_categories Seuls les admins peuvent ajouter des catégories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent ajouter des catégories" ON public.technology_categories FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.id = auth.uid()) AND (user_roles.role = ANY (ARRAY['admin'::public.user_role, 'validator'::public.user_role]))))));


--
-- TOC entry 4573 (class 3256 OID 17514)
-- Name: usage_categories Seuls les admins peuvent ajouter des catégories d'usage; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent ajouter des catégories d'usage" ON public.usage_categories FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.id = auth.uid()) AND (user_roles.role = ANY (ARRAY['admin'::public.user_role, 'validator'::public.user_role]))))));


--
-- TOC entry 4574 (class 3256 OID 17515)
-- Name: technology_subtypes Seuls les admins peuvent ajouter des sous-types; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent ajouter des sous-types" ON public.technology_subtypes FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.id = auth.uid()) AND (user_roles.role = ANY (ARRAY['admin'::public.user_role, 'validator'::public.user_role]))))));


--
-- TOC entry 4575 (class 3256 OID 17516)
-- Name: user_roles Seuls les admins peuvent mettre à jour les rôles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent mettre à jour les rôles" ON public.user_roles FOR UPDATE USING (public.has_role('admin'::public.user_role));


--
-- TOC entry 4576 (class 3256 OID 17517)
-- Name: technology_categories Seuls les admins peuvent modifier les catégories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent modifier les catégories" ON public.technology_categories FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.id = auth.uid()) AND (user_roles.role = ANY (ARRAY['admin'::public.user_role, 'validator'::public.user_role]))))));


--
-- TOC entry 4579 (class 3256 OID 17518)
-- Name: usage_categories Seuls les admins peuvent modifier les catégories d'usage; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent modifier les catégories d'usage" ON public.usage_categories FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.id = auth.uid()) AND (user_roles.role = ANY (ARRAY['admin'::public.user_role, 'validator'::public.user_role]))))));


--
-- TOC entry 4580 (class 3256 OID 17519)
-- Name: user_roles Seuls les admins peuvent modifier les rôles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent modifier les rôles" ON public.user_roles FOR INSERT WITH CHECK (public.has_role('admin'::public.user_role));


--
-- TOC entry 4581 (class 3256 OID 17520)
-- Name: technology_subtypes Seuls les admins peuvent modifier les sous-types; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent modifier les sous-types" ON public.technology_subtypes FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.id = auth.uid()) AND (user_roles.role = ANY (ARRAY['admin'::public.user_role, 'validator'::public.user_role]))))));


--
-- TOC entry 4582 (class 3256 OID 17521)
-- Name: library_language_associations Seuls les admins peuvent supprimer des associations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent supprimer des associations" ON public.library_language_associations FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.id = auth.uid()) AND (user_roles.role = 'admin'::public.user_role)))));


--
-- TOC entry 4583 (class 3256 OID 17522)
-- Name: technology_categories Seuls les admins peuvent supprimer des catégories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent supprimer des catégories" ON public.technology_categories FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.id = auth.uid()) AND (user_roles.role = ANY (ARRAY['admin'::public.user_role, 'validator'::public.user_role]))))));


--
-- TOC entry 4584 (class 3256 OID 17523)
-- Name: usage_categories Seuls les admins peuvent supprimer des catégories d'usage; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent supprimer des catégories d'usage" ON public.usage_categories FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.id = auth.uid()) AND (user_roles.role = ANY (ARRAY['admin'::public.user_role, 'validator'::public.user_role]))))));


--
-- TOC entry 4571 (class 3256 OID 17524)
-- Name: language_proposals Seuls les admins peuvent supprimer des propositions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent supprimer des propositions" ON public.language_proposals FOR DELETE USING (public.has_role('admin'::public.user_role));


--
-- TOC entry 4585 (class 3256 OID 17525)
-- Name: technology_subtypes Seuls les admins peuvent supprimer des sous-types; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent supprimer des sous-types" ON public.technology_subtypes FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.id = auth.uid()) AND (user_roles.role = ANY (ARRAY['admin'::public.user_role, 'validator'::public.user_role]))))));


--
-- TOC entry 4586 (class 3256 OID 17526)
-- Name: user_roles Seuls les admins peuvent supprimer les rôles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les admins peuvent supprimer les rôles" ON public.user_roles FOR DELETE USING (public.has_role('admin'::public.user_role));


--
-- TOC entry 4587 (class 3256 OID 17527)
-- Name: library_language_associations Seuls les utilisateurs vérifiés et admins peuvent ajouter des; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les utilisateurs vérifiés et admins peuvent ajouter des" ON public.library_language_associations FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.id = auth.uid()) AND (user_roles.role = ANY (ARRAY['verified'::public.user_role, 'validator'::public.user_role, 'admin'::public.user_role]))))));


--
-- TOC entry 4588 (class 3256 OID 17528)
-- Name: library_language_associations Seuls les validateurs et admins peuvent modifier des associatio; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Seuls les validateurs et admins peuvent modifier des associatio" ON public.library_language_associations FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.id = auth.uid()) AND (user_roles.role = ANY (ARRAY['validator'::public.user_role, 'admin'::public.user_role]))))));


--
-- TOC entry 4589 (class 3256 OID 17529)
-- Name: stats_searches Tous les utilisateurs authentifiés peuvent voir les stats de r; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tous les utilisateurs authentifiés peuvent voir les stats de r" ON public.stats_searches FOR SELECT USING ((auth.uid() IS NOT NULL));


--
-- TOC entry 4590 (class 3256 OID 17530)
-- Name: library_language_associations Tout le monde peut lire les associations bibliothèque-langage; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tout le monde peut lire les associations bibliothèque-langage" ON public.library_language_associations FOR SELECT USING (true);


--
-- TOC entry 4591 (class 3256 OID 17531)
-- Name: library_languages Tout le monde peut lire les associations bibliothèque-langage; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tout le monde peut lire les associations bibliothèque-langage" ON public.library_languages FOR SELECT USING (true);


--
-- TOC entry 4592 (class 3256 OID 17532)
-- Name: libraries Tout le monde peut lire les bibliothèques; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tout le monde peut lire les bibliothèques" ON public.libraries FOR SELECT USING (true);


--
-- TOC entry 4593 (class 3256 OID 17533)
-- Name: languages Tout le monde peut lire les langages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tout le monde peut lire les langages" ON public.languages FOR SELECT USING (true);


--
-- TOC entry 4594 (class 3256 OID 17534)
-- Name: corrections Tout le monde peut soumettre des corrections; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tout le monde peut soumettre des corrections" ON public.corrections FOR INSERT WITH CHECK (true);


--
-- TOC entry 4595 (class 3256 OID 17535)
-- Name: usage_categories Tout le monde peut voir les catégories d'usage; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tout le monde peut voir les catégories d'usage" ON public.usage_categories FOR SELECT USING (true);


--
-- TOC entry 4596 (class 3256 OID 17536)
-- Name: technology_categories Tout le monde peut voir les catégories de technologie; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tout le monde peut voir les catégories de technologie" ON public.technology_categories FOR SELECT USING (true);


--
-- TOC entry 4597 (class 3256 OID 17537)
-- Name: technology_subtypes Tout le monde peut voir les sous-types de technologie; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tout le monde peut voir les sous-types de technologie" ON public.technology_subtypes FOR SELECT USING (true);


--
-- TOC entry 4577 (class 3256 OID 17538)
-- Name: todos Users can delete their own todos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete their own todos" ON public.todos FOR DELETE USING ((user_id = auth.uid()));


--
-- TOC entry 4578 (class 3256 OID 17539)
-- Name: todos Users can insert their own todos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own todos" ON public.todos FOR INSERT WITH CHECK ((user_id = auth.uid()));


--
-- TOC entry 4598 (class 3256 OID 17540)
-- Name: todos Users can update their own todos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own todos" ON public.todos FOR UPDATE USING ((user_id = auth.uid()));


--
-- TOC entry 4599 (class 3256 OID 17541)
-- Name: todos Users can view their own todos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own todos" ON public.todos FOR SELECT USING ((user_id = auth.uid()));


--
-- TOC entry 4525 (class 0 OID 16896)
-- Dependencies: 273
-- Name: corrections; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.corrections ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4527 (class 0 OID 16915)
-- Dependencies: 277
-- Name: language_proposals; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.language_proposals ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4528 (class 0 OID 16925)
-- Dependencies: 279
-- Name: language_usage; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.language_usage ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4529 (class 0 OID 16930)
-- Dependencies: 281
-- Name: languages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.languages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4526 (class 0 OID 16905)
-- Dependencies: 275
-- Name: libraries; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.libraries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4530 (class 0 OID 16939)
-- Dependencies: 283
-- Name: library_language_associations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.library_language_associations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4531 (class 0 OID 16942)
-- Dependencies: 284
-- Name: library_languages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.library_languages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4532 (class 0 OID 16948)
-- Dependencies: 286
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4600 (class 3256 OID 17542)
-- Name: language_usage select_language_usage; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY select_language_usage ON public.language_usage FOR SELECT USING ((( SELECT auth.uid() AS uid) IS NOT NULL));


--
-- TOC entry 4533 (class 0 OID 16955)
-- Dependencies: 287
-- Name: stats_languages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.stats_languages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4534 (class 0 OID 16963)
-- Dependencies: 289
-- Name: stats_searches; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.stats_searches ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4535 (class 0 OID 16970)
-- Dependencies: 291
-- Name: stats_users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.stats_users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4536 (class 0 OID 16978)
-- Dependencies: 293
-- Name: stats_visits; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.stats_visits ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4537 (class 0 OID 16985)
-- Dependencies: 295
-- Name: technology_categories; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.technology_categories ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4538 (class 0 OID 16990)
-- Dependencies: 297
-- Name: technology_subtypes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.technology_subtypes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4539 (class 0 OID 16995)
-- Dependencies: 299
-- Name: todo_categories; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.todo_categories ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4540 (class 0 OID 17002)
-- Dependencies: 301
-- Name: todo_status; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.todo_status ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4508 (class 0 OID 16752)
-- Dependencies: 255
-- Name: todos; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.todos ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4541 (class 0 OID 17010)
-- Dependencies: 304
-- Name: usage_categories; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.usage_categories ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4542 (class 0 OID 17018)
-- Dependencies: 306
-- Name: user_language_likes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_language_likes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4543 (class 0 OID 17023)
-- Dependencies: 308
-- Name: user_roles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4544 (class 0 OID 17029)
-- Dependencies: 309
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4545 (class 0 OID 17038)
-- Dependencies: 310
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: postgres
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4601 (class 3256 OID 17543)
-- Name: objects Allow public read access 1peuqw_0; Type: POLICY; Schema: storage; Owner: postgres
--

CREATE POLICY "Allow public read access 1peuqw_0" ON storage.objects FOR SELECT USING ((bucket_id = 'logos'::text));


--
-- TOC entry 4602 (class 3256 OID 17544)
-- Name: objects Permettre aux users auth de supprimer leur avatar; Type: POLICY; Schema: storage; Owner: postgres
--

CREATE POLICY "Permettre aux users auth de supprimer leur avatar" ON storage.objects FOR DELETE USING (((bucket_id = 'avatars'::text) AND (auth.role() = 'authenticated'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- TOC entry 4603 (class 3256 OID 17545)
-- Name: objects Permettre aux users auth de update leur avatar; Type: POLICY; Schema: storage; Owner: postgres
--

CREATE POLICY "Permettre aux users auth de update leur avatar" ON storage.objects FOR UPDATE USING (((bucket_id = 'avatars'::text) AND (auth.role() = 'authenticated'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- TOC entry 4604 (class 3256 OID 17546)
-- Name: objects Permettre à tous de lire les avatars 1oj01fe_0; Type: POLICY; Schema: storage; Owner: postgres
--

CREATE POLICY "Permettre à tous de lire les avatars 1oj01fe_0" ON storage.objects FOR SELECT USING ((bucket_id = 'avatars'::text));


--
-- TOC entry 4605 (class 3256 OID 17547)
-- Name: objects Seuls les admins et validateurs peuvent mettre à jour des logo; Type: POLICY; Schema: storage; Owner: postgres
--

CREATE POLICY "Seuls les admins et validateurs peuvent mettre à jour des logo" ON storage.objects FOR UPDATE USING (((bucket_id = 'logos'::text) AND (public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role))));


--
-- TOC entry 4606 (class 3256 OID 17548)
-- Name: objects Seuls les admins et validateurs peuvent supprimer des logos; Type: POLICY; Schema: storage; Owner: postgres
--

CREATE POLICY "Seuls les admins et validateurs peuvent supprimer des logos" ON storage.objects FOR DELETE USING (((bucket_id = 'logos'::text) AND (public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role))));


--
-- TOC entry 4607 (class 3256 OID 17549)
-- Name: objects Seuls les admins et validateurs peuvent télécharger des logos; Type: POLICY; Schema: storage; Owner: postgres
--

CREATE POLICY "Seuls les admins et validateurs peuvent télécharger des logos" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'logos'::text) AND (public.has_role('admin'::public.user_role) OR public.has_role('validator'::public.user_role))));


--
-- TOC entry 4546 (class 0 OID 17057)
-- Dependencies: 314
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: postgres
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4547 (class 0 OID 17066)
-- Dependencies: 315
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: postgres
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4548 (class 0 OID 17070)
-- Dependencies: 316
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: postgres
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4549 (class 0 OID 17080)
-- Dependencies: 317
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: postgres
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4550 (class 0 OID 17087)
-- Dependencies: 318
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: postgres
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4608 (class 6104 OID 17550)
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- TOC entry 4622 (class 0 OID 0)
-- Dependencies: 390
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_graphql_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4624 (class 0 OID 0)
-- Dependencies: 476
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgrst_ddl_watch() FROM postgres;
GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4625 (class 0 OID 0)
-- Dependencies: 401
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgrst_drop_watch() FROM postgres;
GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4627 (class 0 OID 0)
-- Dependencies: 409
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.set_graphql_placeholder() FROM postgres;
GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- TOC entry 3763 (class 3466 OID 17558)
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO postgres;

--
-- TOC entry 3764 (class 3466 OID 17559)
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO postgres;

--
-- TOC entry 3765 (class 3466 OID 17560)
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO postgres;

--
-- TOC entry 3766 (class 3466 OID 17561)
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO postgres;

--
-- TOC entry 3767 (class 3466 OID 17562)
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO postgres;

--
-- TOC entry 3768 (class 3466 OID 17563)
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO postgres;

-- Completed on 2025-05-27 03:58:43

--
-- PostgreSQL database dump complete
--

