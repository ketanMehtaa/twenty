--
-- PostgreSQL database dump
--

\restrict P7ztTpH7qdWp2Q50J79dnTfa6aahOxspFP38ZWxtnsbevAMEtO57ZB3jzQGMH7b

-- Dumped from database version 16.10 (Debian 16.10-1.pgdg13+1)
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
-- Name: core; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA core;


ALTER SCHEMA core OWNER TO postgres;

--
-- Name: agentChatMessage_role_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."agentChatMessage_role_enum" AS ENUM (
    'user',
    'assistant'
);


ALTER TYPE core."agentChatMessage_role_enum" OWNER TO postgres;

--
-- Name: dataSource_type_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."dataSource_type_enum" AS ENUM (
    'postgres'
);


ALTER TYPE core."dataSource_type_enum" OWNER TO postgres;

--
-- Name: emailingDomain_driver_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."emailingDomain_driver_enum" AS ENUM (
    'AWS_SES'
);


ALTER TYPE core."emailingDomain_driver_enum" OWNER TO postgres;

--
-- Name: emailingDomain_status_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."emailingDomain_status_enum" AS ENUM (
    'PENDING',
    'VERIFIED',
    'FAILED',
    'TEMPORARY_FAILURE'
);


ALTER TYPE core."emailingDomain_status_enum" OWNER TO postgres;

--
-- Name: indexMetadata_indextype_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."indexMetadata_indextype_enum" AS ENUM (
    'BTREE',
    'GIN'
);


ALTER TYPE core."indexMetadata_indextype_enum" OWNER TO postgres;

--
-- Name: keyValuePair_type_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."keyValuePair_type_enum" AS ENUM (
    'USER_VARIABLE',
    'FEATURE_FLAG',
    'CONFIG_VARIABLE'
);


ALTER TYPE core."keyValuePair_type_enum" OWNER TO postgres;

--
-- Name: pageLayoutWidget_type_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."pageLayoutWidget_type_enum" AS ENUM (
    'VIEW',
    'IFRAME',
    'FIELDS',
    'GRAPH'
);


ALTER TYPE core."pageLayoutWidget_type_enum" OWNER TO postgres;

--
-- Name: pageLayout_type_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."pageLayout_type_enum" AS ENUM (
    'RECORD_INDEX',
    'RECORD_PAGE',
    'DASHBOARD'
);


ALTER TYPE core."pageLayout_type_enum" OWNER TO postgres;

--
-- Name: relationMetadata_ondeleteaction_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."relationMetadata_ondeleteaction_enum" AS ENUM (
    'CASCADE',
    'RESTRICT',
    'SET_NULL',
    'NO_ACTION'
);


ALTER TYPE core."relationMetadata_ondeleteaction_enum" OWNER TO postgres;

--
-- Name: route_httpmethod_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core.route_httpmethod_enum AS ENUM (
    'GET',
    'POST',
    'PUT',
    'PATCH',
    'DELETE'
);


ALTER TYPE core.route_httpmethod_enum OWNER TO postgres;

--
-- Name: twoFactorAuthenticationMethod_status_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."twoFactorAuthenticationMethod_status_enum" AS ENUM (
    'PENDING',
    'VERIFIED'
);


ALTER TYPE core."twoFactorAuthenticationMethod_status_enum" OWNER TO postgres;

--
-- Name: twoFactorAuthenticationMethod_strategy_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."twoFactorAuthenticationMethod_strategy_enum" AS ENUM (
    'TOTP'
);


ALTER TYPE core."twoFactorAuthenticationMethod_strategy_enum" OWNER TO postgres;

--
-- Name: viewField_aggregateoperation_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."viewField_aggregateoperation_enum" AS ENUM (
    'MIN',
    'MAX',
    'AVG',
    'SUM',
    'COUNT',
    'COUNT_UNIQUE_VALUES',
    'COUNT_EMPTY',
    'COUNT_NOT_EMPTY',
    'COUNT_TRUE',
    'COUNT_FALSE',
    'PERCENTAGE_EMPTY',
    'PERCENTAGE_NOT_EMPTY'
);


ALTER TYPE core."viewField_aggregateoperation_enum" OWNER TO postgres;

--
-- Name: viewFilterGroup_logicaloperator_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."viewFilterGroup_logicaloperator_enum" AS ENUM (
    'AND',
    'OR',
    'NOT'
);


ALTER TYPE core."viewFilterGroup_logicaloperator_enum" OWNER TO postgres;

--
-- Name: viewFilter_operand_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."viewFilter_operand_enum" AS ENUM (
    'IS',
    'IS_NOT_NULL',
    'IS_NOT',
    'LESS_THAN_OR_EQUAL',
    'GREATER_THAN_OR_EQUAL',
    'IS_BEFORE',
    'IS_AFTER',
    'CONTAINS',
    'DOES_NOT_CONTAIN',
    'IS_EMPTY',
    'IS_NOT_EMPTY',
    'IS_RELATIVE',
    'IS_IN_PAST',
    'IS_IN_FUTURE',
    'IS_TODAY',
    'VECTOR_SEARCH'
);


ALTER TYPE core."viewFilter_operand_enum" OWNER TO postgres;

--
-- Name: viewSort_direction_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."viewSort_direction_enum" AS ENUM (
    'ASC',
    'DESC'
);


ALTER TYPE core."viewSort_direction_enum" OWNER TO postgres;

--
-- Name: view_calendarlayout_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core.view_calendarlayout_enum AS ENUM (
    'DAY',
    'WEEK',
    'MONTH'
);


ALTER TYPE core.view_calendarlayout_enum OWNER TO postgres;

--
-- Name: view_kanbanaggregateoperation_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core.view_kanbanaggregateoperation_enum AS ENUM (
    'MIN',
    'MAX',
    'AVG',
    'SUM',
    'COUNT',
    'COUNT_UNIQUE_VALUES',
    'COUNT_EMPTY',
    'COUNT_NOT_EMPTY',
    'COUNT_TRUE',
    'COUNT_FALSE',
    'PERCENTAGE_EMPTY',
    'PERCENTAGE_NOT_EMPTY'
);


ALTER TYPE core.view_kanbanaggregateoperation_enum OWNER TO postgres;

--
-- Name: view_key_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core.view_key_enum AS ENUM (
    'INDEX'
);


ALTER TYPE core.view_key_enum OWNER TO postgres;

--
-- Name: view_openrecordin_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core.view_openrecordin_enum AS ENUM (
    'SIDE_PANEL',
    'RECORD_PAGE'
);


ALTER TYPE core.view_openrecordin_enum OWNER TO postgres;

--
-- Name: view_type_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core.view_type_enum AS ENUM (
    'TABLE',
    'KANBAN',
    'CALENDAR'
);


ALTER TYPE core.view_type_enum OWNER TO postgres;

--
-- Name: workspaceSSOIdentityProvider_status_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."workspaceSSOIdentityProvider_status_enum" AS ENUM (
    'Active',
    'Inactive',
    'Error'
);


ALTER TYPE core."workspaceSSOIdentityProvider_status_enum" OWNER TO postgres;

--
-- Name: workspaceSSOIdentityProvider_type_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."workspaceSSOIdentityProvider_type_enum" AS ENUM (
    'OIDC',
    'SAML'
);


ALTER TYPE core."workspaceSSOIdentityProvider_type_enum" OWNER TO postgres;

--
-- Name: workspace_activationStatus_enum; Type: TYPE; Schema: core; Owner: postgres
--

CREATE TYPE core."workspace_activationStatus_enum" AS ENUM (
    'ONGOING_CREATION',
    'PENDING_CREATION',
    'ACTIVE',
    'INACTIVE',
    'SUSPENDED'
);


ALTER TYPE core."workspace_activationStatus_enum" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _typeorm_generated_columns_and_materialized_views; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core._typeorm_generated_columns_and_materialized_views (
    type character varying NOT NULL,
    database character varying,
    schema character varying,
    "table" character varying,
    name character varying,
    value text
);


ALTER TABLE core._typeorm_generated_columns_and_materialized_views OWNER TO postgres;

--
-- Name: _typeorm_migrations; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core._typeorm_migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE core._typeorm_migrations OWNER TO postgres;

--
-- Name: _typeorm_migrations_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core._typeorm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core._typeorm_migrations_id_seq OWNER TO postgres;

--
-- Name: _typeorm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core._typeorm_migrations_id_seq OWNED BY core._typeorm_migrations.id;


--
-- Name: agent; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.agent (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    description character varying,
    prompt text NOT NULL,
    "modelId" character varying DEFAULT 'auto'::character varying NOT NULL,
    "responseFormat" jsonb,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    label character varying NOT NULL,
    icon character varying,
    "isCustom" boolean DEFAULT false NOT NULL,
    "standardId" uuid,
    "applicationId" uuid
);


ALTER TABLE core.agent OWNER TO postgres;

--
-- Name: agentChatMessage; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."agentChatMessage" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "threadId" uuid NOT NULL,
    role core."agentChatMessage_role_enum" NOT NULL,
    "rawContent" text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE core."agentChatMessage" OWNER TO postgres;

--
-- Name: agentChatThread; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."agentChatThread" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "agentId" uuid NOT NULL,
    "userWorkspaceId" uuid NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    title character varying
);


ALTER TABLE core."agentChatThread" OWNER TO postgres;

--
-- Name: agentHandoff; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."agentHandoff" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "fromAgentId" uuid NOT NULL,
    "toAgentId" uuid NOT NULL,
    "workspaceId" uuid NOT NULL,
    description text,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE core."agentHandoff" OWNER TO postgres;

--
-- Name: apiKey; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."apiKey" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    "expiresAt" timestamp with time zone NOT NULL,
    "revokedAt" timestamp with time zone,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE core."apiKey" OWNER TO postgres;

--
-- Name: appToken; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."appToken" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "userId" uuid,
    "expiresAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    "revokedAt" timestamp with time zone,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "workspaceId" uuid,
    type text DEFAULT 'REFRESH_TOKEN'::text NOT NULL,
    value text,
    context jsonb
);


ALTER TABLE core."appToken" OWNER TO postgres;

--
-- Name: application; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.application (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "standardId" uuid,
    label text NOT NULL,
    description text,
    version text,
    "sourceType" text DEFAULT 'local'::text NOT NULL,
    "sourcePath" text NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE core.application OWNER TO postgres;

--
-- Name: approvedAccessDomain; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."approvedAccessDomain" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    domain character varying NOT NULL,
    "isValidated" boolean DEFAULT false NOT NULL,
    "workspaceId" uuid NOT NULL
);


ALTER TABLE core."approvedAccessDomain" OWNER TO postgres;

--
-- Name: cronTrigger; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."cronTrigger" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    settings jsonb NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "serverlessFunctionId" uuid,
    "universalIdentifier" uuid
);


ALTER TABLE core."cronTrigger" OWNER TO postgres;

--
-- Name: dataSource; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."dataSource" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    url character varying,
    schema character varying,
    type core."dataSource_type_enum" DEFAULT 'postgres'::core."dataSource_type_enum" NOT NULL,
    label character varying,
    "isRemote" boolean DEFAULT false NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE core."dataSource" OWNER TO postgres;

--
-- Name: databaseEventTrigger; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."databaseEventTrigger" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    settings jsonb NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "serverlessFunctionId" uuid,
    "universalIdentifier" uuid
);


ALTER TABLE core."databaseEventTrigger" OWNER TO postgres;

--
-- Name: emailingDomain; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."emailingDomain" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    domain character varying NOT NULL,
    driver core."emailingDomain_driver_enum" NOT NULL,
    status core."emailingDomain_status_enum" DEFAULT 'PENDING'::core."emailingDomain_status_enum" NOT NULL,
    "verificationRecords" jsonb,
    "verifiedAt" timestamp with time zone,
    "workspaceId" uuid NOT NULL
);


ALTER TABLE core."emailingDomain" OWNER TO postgres;

--
-- Name: featureFlag; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."featureFlag" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    key text NOT NULL,
    "workspaceId" uuid NOT NULL,
    value boolean NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE core."featureFlag" OWNER TO postgres;

--
-- Name: fieldMetadata; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."fieldMetadata" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "objectMetadataId" uuid NOT NULL,
    type character varying NOT NULL,
    name character varying NOT NULL,
    label character varying NOT NULL,
    "defaultValue" jsonb,
    description text,
    icon character varying,
    "isCustom" boolean DEFAULT false NOT NULL,
    "isActive" boolean DEFAULT false NOT NULL,
    "isSystem" boolean DEFAULT false NOT NULL,
    "isNullable" boolean DEFAULT true,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    options jsonb,
    "standardId" uuid,
    settings jsonb,
    "isUnique" boolean DEFAULT false,
    "isLabelSyncedWithName" boolean DEFAULT false NOT NULL,
    "relationTargetFieldMetadataId" uuid,
    "relationTargetObjectMetadataId" uuid,
    "standardOverrides" jsonb,
    "isUIReadOnly" boolean DEFAULT false NOT NULL,
    "morphId" uuid,
    CONSTRAINT "CHK_FIELD_METADATA_MORPH_RELATION_REQUIRES_MORPH_ID" CHECK ((((type)::text <> 'MORPH_RELATION'::text) OR (((type)::text = 'MORPH_RELATION'::text) AND ("morphId" IS NOT NULL))))
);


ALTER TABLE core."fieldMetadata" OWNER TO postgres;

--
-- Name: fieldPermission; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."fieldPermission" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "roleId" uuid NOT NULL,
    "objectMetadataId" uuid NOT NULL,
    "fieldMetadataId" uuid NOT NULL,
    "canReadFieldValue" boolean,
    "canUpdateFieldValue" boolean,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE core."fieldPermission" OWNER TO postgres;

--
-- Name: file; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.file (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    "fullPath" character varying NOT NULL,
    size bigint NOT NULL,
    type character varying NOT NULL,
    "workspaceId" uuid NOT NULL,
    "messageId" uuid,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE core.file OWNER TO postgres;

--
-- Name: indexFieldMetadata; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."indexFieldMetadata" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "indexMetadataId" uuid NOT NULL,
    "fieldMetadataId" uuid NOT NULL,
    "order" integer NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE core."indexFieldMetadata" OWNER TO postgres;

--
-- Name: indexMetadata; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."indexMetadata" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    "workspaceId" character varying,
    "objectMetadataId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "indexType" core."indexMetadata_indextype_enum" DEFAULT 'BTREE'::core."indexMetadata_indextype_enum" NOT NULL,
    "isUnique" boolean DEFAULT false NOT NULL,
    "indexWhereClause" text,
    "isCustom" boolean DEFAULT false NOT NULL,
    "universalIdentifier" uuid
);


ALTER TABLE core."indexMetadata" OWNER TO postgres;

--
-- Name: keyValuePair; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."keyValuePair" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "userId" uuid,
    "workspaceId" uuid,
    key text NOT NULL,
    "textValueDeprecated" text,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    type core."keyValuePair_type_enum" DEFAULT 'USER_VARIABLE'::core."keyValuePair_type_enum" NOT NULL,
    value jsonb
);


ALTER TABLE core."keyValuePair" OWNER TO postgres;

--
-- Name: objectMetadata; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."objectMetadata" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "dataSourceId" uuid NOT NULL,
    "nameSingular" character varying NOT NULL,
    "namePlural" character varying NOT NULL,
    "labelSingular" character varying NOT NULL,
    "labelPlural" character varying NOT NULL,
    description text,
    icon character varying,
    "targetTableName" character varying NOT NULL,
    "isCustom" boolean DEFAULT false NOT NULL,
    "isActive" boolean DEFAULT false NOT NULL,
    "isSystem" boolean DEFAULT false NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "labelIdentifierFieldMetadataId" uuid,
    "imageIdentifierFieldMetadataId" uuid,
    "standardId" uuid,
    "isRemote" boolean DEFAULT false NOT NULL,
    "isAuditLogged" boolean DEFAULT true NOT NULL,
    "isLabelSyncedWithName" boolean DEFAULT false NOT NULL,
    shortcut character varying,
    "duplicateCriteria" jsonb,
    "isSearchable" boolean DEFAULT false NOT NULL,
    "standardOverrides" jsonb,
    "isUIReadOnly" boolean DEFAULT false NOT NULL,
    "applicationId" uuid
);


ALTER TABLE core."objectMetadata" OWNER TO postgres;

--
-- Name: objectPermission; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."objectPermission" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "roleId" uuid NOT NULL,
    "objectMetadataId" uuid NOT NULL,
    "canReadObjectRecords" boolean,
    "canUpdateObjectRecords" boolean,
    "canSoftDeleteObjectRecords" boolean,
    "canDestroyObjectRecords" boolean,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE core."objectPermission" OWNER TO postgres;

--
-- Name: pageLayout; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."pageLayout" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    "workspaceId" uuid NOT NULL,
    type core."pageLayout_type_enum" DEFAULT 'RECORD_PAGE'::core."pageLayout_type_enum" NOT NULL,
    "objectMetadataId" uuid,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE core."pageLayout" OWNER TO postgres;

--
-- Name: pageLayoutTab; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."pageLayoutTab" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying NOT NULL,
    "pageLayoutId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    "position" double precision DEFAULT '0'::double precision NOT NULL,
    "workspaceId" uuid NOT NULL
);


ALTER TABLE core."pageLayoutTab" OWNER TO postgres;

--
-- Name: pageLayoutWidget; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."pageLayoutWidget" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "pageLayoutTabId" uuid NOT NULL,
    title character varying NOT NULL,
    type core."pageLayoutWidget_type_enum" DEFAULT 'VIEW'::core."pageLayoutWidget_type_enum" NOT NULL,
    "objectMetadataId" uuid,
    "gridPosition" jsonb NOT NULL,
    configuration jsonb,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    "workspaceId" uuid NOT NULL
);


ALTER TABLE core."pageLayoutWidget" OWNER TO postgres;

--
-- Name: permissionFlag; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."permissionFlag" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "roleId" uuid NOT NULL,
    flag character varying NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE core."permissionFlag" OWNER TO postgres;

--
-- Name: postgresCredentials; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."postgresCredentials" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "user" character varying NOT NULL,
    "passwordHash" character varying NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    "workspaceId" uuid NOT NULL
);


ALTER TABLE core."postgresCredentials" OWNER TO postgres;

--
-- Name: publicDomain; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."publicDomain" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    domain character varying NOT NULL,
    "isValidated" boolean DEFAULT false NOT NULL,
    "workspaceId" uuid NOT NULL
);


ALTER TABLE core."publicDomain" OWNER TO postgres;

--
-- Name: remoteServer; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."remoteServer" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "foreignDataWrapperId" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "foreignDataWrapperOptions" jsonb,
    "userMappingOptions" jsonb,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "foreignDataWrapperType" text,
    schema text,
    label text
);


ALTER TABLE core."remoteServer" OWNER TO postgres;

--
-- Name: remoteTable; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."remoteTable" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "distantTableName" character varying NOT NULL,
    "localTableName" character varying NOT NULL,
    "workspaceId" uuid NOT NULL,
    "remoteServerId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE core."remoteTable" OWNER TO postgres;

--
-- Name: role; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.role (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    label character varying NOT NULL,
    "canUpdateAllSettings" boolean DEFAULT false NOT NULL,
    description text,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "isEditable" boolean DEFAULT true NOT NULL,
    "canReadAllObjectRecords" boolean DEFAULT false NOT NULL,
    "canUpdateAllObjectRecords" boolean DEFAULT false NOT NULL,
    "canSoftDeleteAllObjectRecords" boolean DEFAULT false NOT NULL,
    "canDestroyAllObjectRecords" boolean DEFAULT false NOT NULL,
    icon character varying,
    "canAccessAllTools" boolean DEFAULT false NOT NULL,
    "standardId" uuid,
    "canBeAssignedToUsers" boolean DEFAULT true NOT NULL,
    "canBeAssignedToAgents" boolean DEFAULT true NOT NULL,
    "canBeAssignedToApiKeys" boolean DEFAULT true NOT NULL
);


ALTER TABLE core.role OWNER TO postgres;

--
-- Name: roleTargets; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."roleTargets" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "workspaceId" uuid NOT NULL,
    "roleId" uuid NOT NULL,
    "userWorkspaceId" uuid,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "agentId" uuid,
    "apiKeyId" uuid,
    CONSTRAINT "CHK_role_targets_single_entity" CHECK (((("agentId" IS NOT NULL) AND ("userWorkspaceId" IS NULL) AND ("apiKeyId" IS NULL)) OR (("agentId" IS NULL) AND ("userWorkspaceId" IS NOT NULL) AND ("apiKeyId" IS NULL)) OR (("agentId" IS NULL) AND ("userWorkspaceId" IS NULL) AND ("apiKeyId" IS NOT NULL))))
);


ALTER TABLE core."roleTargets" OWNER TO postgres;

--
-- Name: route; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.route (
    "universalIdentifier" uuid,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    path character varying NOT NULL,
    "isAuthRequired" boolean DEFAULT true NOT NULL,
    "httpMethod" core.route_httpmethod_enum DEFAULT 'GET'::core.route_httpmethod_enum NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "serverlessFunctionId" uuid
);


ALTER TABLE core.route OWNER TO postgres;

--
-- Name: searchFieldMetadata; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."searchFieldMetadata" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "objectMetadataId" uuid NOT NULL,
    "fieldMetadataId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "workspaceId" uuid NOT NULL
);


ALTER TABLE core."searchFieldMetadata" OWNER TO postgres;

--
-- Name: serverlessFunction; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."serverlessFunction" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    runtime character varying DEFAULT 'nodejs22.x'::character varying NOT NULL,
    description character varying,
    "latestVersion" character varying,
    "layerVersion" integer,
    "publishedVersions" jsonb DEFAULT '[]'::jsonb NOT NULL,
    "latestVersionInputSchema" jsonb,
    "timeoutSeconds" integer DEFAULT 300 NOT NULL,
    "deletedAt" timestamp with time zone,
    "universalIdentifier" uuid,
    "applicationId" uuid,
    CONSTRAINT "CHK_4a5179975ee017934a91703247" CHECK ((("timeoutSeconds" >= 1) AND ("timeoutSeconds" <= 900)))
);


ALTER TABLE core."serverlessFunction" OWNER TO postgres;

--
-- Name: twoFactorAuthenticationMethod; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."twoFactorAuthenticationMethod" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "userWorkspaceId" uuid NOT NULL,
    secret text NOT NULL,
    status core."twoFactorAuthenticationMethod_status_enum" NOT NULL,
    strategy core."twoFactorAuthenticationMethod_strategy_enum" NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE core."twoFactorAuthenticationMethod" OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."user" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "firstName" character varying DEFAULT ''::character varying NOT NULL,
    "lastName" character varying DEFAULT ''::character varying NOT NULL,
    email character varying NOT NULL,
    "isEmailVerified" boolean DEFAULT false NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    "passwordHash" character varying,
    "canImpersonate" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    "defaultAvatarUrl" character varying,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    "canAccessFullAdminPanel" boolean DEFAULT false NOT NULL
);


ALTER TABLE core."user" OWNER TO postgres;

--
-- Name: userWorkspace; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."userWorkspace" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "userId" uuid NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    "defaultAvatarUrl" character varying,
    locale character varying DEFAULT 'en'::character varying NOT NULL
);


ALTER TABLE core."userWorkspace" OWNER TO postgres;

--
-- Name: view; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.view (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    "objectMetadataId" uuid NOT NULL,
    icon text NOT NULL,
    "position" double precision DEFAULT 0 NOT NULL,
    "isCompact" boolean DEFAULT false NOT NULL,
    "openRecordIn" core.view_openrecordin_enum DEFAULT 'SIDE_PANEL'::core.view_openrecordin_enum NOT NULL,
    "kanbanAggregateOperation" core.view_kanbanaggregateoperation_enum,
    "kanbanAggregateOperationFieldMetadataId" uuid,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    "anyFieldFilterValue" text,
    type core.view_type_enum DEFAULT 'TABLE'::core.view_type_enum NOT NULL,
    "isCustom" boolean DEFAULT false NOT NULL,
    key core.view_key_enum,
    "universalIdentifier" uuid,
    "calendarLayout" core.view_calendarlayout_enum,
    "calendarFieldMetadataId" uuid,
    CONSTRAINT "CHK_VIEW_CALENDAR_INTEGRITY" CHECK (((type <> 'CALENDAR'::core.view_type_enum) OR (("calendarLayout" IS NOT NULL) AND ("calendarFieldMetadataId" IS NOT NULL))))
);


ALTER TABLE core.view OWNER TO postgres;

--
-- Name: viewField; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."viewField" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "fieldMetadataId" uuid NOT NULL,
    "isVisible" boolean DEFAULT true NOT NULL,
    size integer DEFAULT 0 NOT NULL,
    "position" double precision DEFAULT 0 NOT NULL,
    "aggregateOperation" core."viewField_aggregateoperation_enum",
    "viewId" uuid NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    "universalIdentifier" uuid
);


ALTER TABLE core."viewField" OWNER TO postgres;

--
-- Name: viewFilter; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."viewFilter" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "fieldMetadataId" uuid NOT NULL,
    value jsonb NOT NULL,
    "viewFilterGroupId" uuid,
    "positionInViewFilterGroup" double precision,
    "subFieldName" text,
    "viewId" uuid NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    operand core."viewFilter_operand_enum" DEFAULT 'CONTAINS'::core."viewFilter_operand_enum" NOT NULL,
    "universalIdentifier" uuid
);


ALTER TABLE core."viewFilter" OWNER TO postgres;

--
-- Name: viewFilterGroup; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."viewFilterGroup" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "parentViewFilterGroupId" uuid,
    "logicalOperator" core."viewFilterGroup_logicaloperator_enum" DEFAULT 'AND'::core."viewFilterGroup_logicaloperator_enum" NOT NULL,
    "positionInViewFilterGroup" double precision,
    "viewId" uuid NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    "universalIdentifier" uuid
);


ALTER TABLE core."viewFilterGroup" OWNER TO postgres;

--
-- Name: viewGroup; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."viewGroup" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "fieldMetadataId" uuid NOT NULL,
    "isVisible" boolean DEFAULT true NOT NULL,
    "fieldValue" text NOT NULL,
    "position" double precision DEFAULT 0 NOT NULL,
    "viewId" uuid NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    "universalIdentifier" uuid
);


ALTER TABLE core."viewGroup" OWNER TO postgres;

--
-- Name: viewSort; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."viewSort" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "fieldMetadataId" uuid NOT NULL,
    direction core."viewSort_direction_enum" DEFAULT 'ASC'::core."viewSort_direction_enum" NOT NULL,
    "viewId" uuid NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone,
    "universalIdentifier" uuid
);


ALTER TABLE core."viewSort" OWNER TO postgres;

--
-- Name: webhook; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.webhook (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "targetUrl" character varying NOT NULL,
    operations text[] DEFAULT '{*.*}'::text[] NOT NULL,
    description character varying,
    secret character varying NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE core.webhook OWNER TO postgres;

--
-- Name: workspace; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.workspace (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "displayName" character varying,
    logo character varying,
    "inviteHash" character varying,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "allowImpersonation" boolean DEFAULT true NOT NULL,
    "activationStatus" core."workspace_activationStatus_enum" DEFAULT 'INACTIVE'::core."workspace_activationStatus_enum" NOT NULL,
    "metadataVersion" integer DEFAULT 1 NOT NULL,
    "databaseUrl" character varying DEFAULT ''::character varying NOT NULL,
    "databaseSchema" character varying DEFAULT ''::character varying NOT NULL,
    "isPublicInviteLinkEnabled" boolean DEFAULT true NOT NULL,
    subdomain character varying NOT NULL,
    "isMicrosoftAuthEnabled" boolean DEFAULT true NOT NULL,
    "isGoogleAuthEnabled" boolean DEFAULT true NOT NULL,
    "isPasswordAuthEnabled" boolean DEFAULT true NOT NULL,
    "customDomain" character varying,
    "isCustomDomainEnabled" boolean DEFAULT false NOT NULL,
    "defaultRoleId" uuid,
    version character varying,
    "defaultAgentId" uuid,
    "isTwoFactorAuthenticationEnforced" boolean DEFAULT false NOT NULL,
    CONSTRAINT onboarded_workspace_requires_default_role CHECK ((("activationStatus" = ANY (ARRAY['PENDING_CREATION'::core."workspace_activationStatus_enum", 'ONGOING_CREATION'::core."workspace_activationStatus_enum"])) OR ("defaultRoleId" IS NOT NULL)))
);


ALTER TABLE core.workspace OWNER TO postgres;

--
-- Name: workspaceMigration; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."workspaceMigration" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    migrations jsonb,
    name character varying NOT NULL,
    "isCustom" boolean DEFAULT false NOT NULL,
    "appliedAt" timestamp with time zone,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE core."workspaceMigration" OWNER TO postgres;

--
-- Name: workspaceSSOIdentityProvider; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core."workspaceSSOIdentityProvider" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    type core."workspaceSSOIdentityProvider_type_enum" DEFAULT 'OIDC'::core."workspaceSSOIdentityProvider_type_enum" NOT NULL,
    issuer character varying NOT NULL,
    "ssoURL" character varying,
    "clientID" character varying,
    "clientSecret" character varying,
    certificate character varying,
    fingerprint character varying,
    status core."workspaceSSOIdentityProvider_status_enum" DEFAULT 'Active'::core."workspaceSSOIdentityProvider_status_enum" NOT NULL
);


ALTER TABLE core."workspaceSSOIdentityProvider" OWNER TO postgres;

--
-- Name: _typeorm_migrations id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core._typeorm_migrations ALTER COLUMN id SET DEFAULT nextval('core._typeorm_migrations_id_seq'::regclass);


--
-- Name: approvedAccessDomain IDX_APPROVED_ACCESS_DOMAIN_DOMAIN_WORKSPACE_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."approvedAccessDomain"
    ADD CONSTRAINT "IDX_APPROVED_ACCESS_DOMAIN_DOMAIN_WORKSPACE_ID_UNIQUE" UNIQUE (domain, "workspaceId");


--
-- Name: emailingDomain IDX_EMAILING_DOMAIN_DOMAIN_WORKSPACE_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."emailingDomain"
    ADD CONSTRAINT "IDX_EMAILING_DOMAIN_DOMAIN_WORKSPACE_ID_UNIQUE" UNIQUE (domain, "workspaceId");


--
-- Name: featureFlag IDX_FEATURE_FLAG_KEY_WORKSPACE_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."featureFlag"
    ADD CONSTRAINT "IDX_FEATURE_FLAG_KEY_WORKSPACE_ID_UNIQUE" UNIQUE (key, "workspaceId");


--
-- Name: fieldMetadata IDX_FIELD_METADATA_NAME_OBJECT_METADATA_ID_WORKSPACE_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."fieldMetadata"
    ADD CONSTRAINT "IDX_FIELD_METADATA_NAME_OBJECT_METADATA_ID_WORKSPACE_ID_UNIQUE" UNIQUE (name, "objectMetadataId", "workspaceId");


--
-- Name: fieldPermission IDX_FIELD_PERMISSION_FIELD_METADATA_ID_ROLE_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."fieldPermission"
    ADD CONSTRAINT "IDX_FIELD_PERMISSION_FIELD_METADATA_ID_ROLE_ID_UNIQUE" UNIQUE ("fieldMetadataId", "roleId");


--
-- Name: indexMetadata IDX_INDEX_METADATA_NAME_WORKSPACE_ID_OBJECT_METADATA_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."indexMetadata"
    ADD CONSTRAINT "IDX_INDEX_METADATA_NAME_WORKSPACE_ID_OBJECT_METADATA_ID_UNIQUE" UNIQUE (name, "workspaceId", "objectMetadataId");


--
-- Name: keyValuePair IDX_KEY_VALUE_PAIR_KEY_USER_ID_WORKSPACE_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."keyValuePair"
    ADD CONSTRAINT "IDX_KEY_VALUE_PAIR_KEY_USER_ID_WORKSPACE_ID_UNIQUE" UNIQUE (key, "userId", "workspaceId");


--
-- Name: objectMetadata IDX_OBJECT_METADATA_NAME_PLURAL_WORKSPACE_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."objectMetadata"
    ADD CONSTRAINT "IDX_OBJECT_METADATA_NAME_PLURAL_WORKSPACE_ID_UNIQUE" UNIQUE ("namePlural", "workspaceId");


--
-- Name: objectMetadata IDX_OBJECT_METADATA_NAME_SINGULAR_WORKSPACE_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."objectMetadata"
    ADD CONSTRAINT "IDX_OBJECT_METADATA_NAME_SINGULAR_WORKSPACE_ID_UNIQUE" UNIQUE ("nameSingular", "workspaceId");


--
-- Name: objectPermission IDX_OBJECT_PERMISSION_OBJECT_METADATA_ID_ROLE_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."objectPermission"
    ADD CONSTRAINT "IDX_OBJECT_PERMISSION_OBJECT_METADATA_ID_ROLE_ID_UNIQUE" UNIQUE ("objectMetadataId", "roleId");


--
-- Name: permissionFlag IDX_PERMISSION_FLAG_FLAG_ROLE_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."permissionFlag"
    ADD CONSTRAINT "IDX_PERMISSION_FLAG_FLAG_ROLE_ID_UNIQUE" UNIQUE (flag, "roleId");


--
-- Name: role IDX_ROLE_LABEL_WORKSPACE_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.role
    ADD CONSTRAINT "IDX_ROLE_LABEL_WORKSPACE_ID_UNIQUE" UNIQUE (label, "workspaceId");


--
-- Name: roleTargets IDX_ROLE_TARGETS_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."roleTargets"
    ADD CONSTRAINT "IDX_ROLE_TARGETS_UNIQUE" UNIQUE ("userWorkspaceId", "roleId");


--
-- Name: route IDX_ROUTE_PATH_HTTP_METHOD_WORKSPACE_ID_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.route
    ADD CONSTRAINT "IDX_ROUTE_PATH_HTTP_METHOD_WORKSPACE_ID_UNIQUE" UNIQUE (path, "httpMethod", "workspaceId");


--
-- Name: searchFieldMetadata IDX_SEARCH_FIELD_METADATA_OBJECT_FIELD_UNIQUE; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."searchFieldMetadata"
    ADD CONSTRAINT "IDX_SEARCH_FIELD_METADATA_OBJECT_FIELD_UNIQUE" UNIQUE ("objectMetadataId", "fieldMetadataId");


--
-- Name: searchFieldMetadata PK_085190eb7531f4aeb8ccab3f42c; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."searchFieldMetadata"
    ADD CONSTRAINT "PK_085190eb7531f4aeb8ccab3f42c" PRIMARY KEY (id);


--
-- Name: route PK_08affcd076e46415e5821acf52d; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.route
    ADD CONSTRAINT "PK_08affcd076e46415e5821acf52d" PRIMARY KEY (id);


--
-- Name: workspace PK_098656ae401f3e1a4586f47fd8e; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.workspace
    ADD CONSTRAINT "PK_098656ae401f3e1a4586f47fd8e" PRIMARY KEY (id);


--
-- Name: viewFilter PK_09f9ffa2f66263b9eb301460137; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewFilter"
    ADD CONSTRAINT "PK_09f9ffa2f66263b9eb301460137" PRIMARY KEY (id);


--
-- Name: cronTrigger PK_153e054abdb2663942d4661e3bb; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."cronTrigger"
    ADD CONSTRAINT "PK_153e054abdb2663942d4661e3bb" PRIMARY KEY (id);


--
-- Name: viewFilterGroup PK_16f55359d609168b826405ed307; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewFilterGroup"
    ADD CONSTRAINT "PK_16f55359d609168b826405ed307" PRIMARY KEY (id);


--
-- Name: objectPermission PK_23a4033c1aa380d0d1431731add; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."objectPermission"
    ADD CONSTRAINT "PK_23a4033c1aa380d0d1431731add" PRIMARY KEY (id);


--
-- Name: apiKey PK_2ae3a5e8e04fb402b2dc8d6ce4b; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."apiKey"
    ADD CONSTRAINT "PK_2ae3a5e8e04fb402b2dc8d6ce4b" PRIMARY KEY (id);


--
-- Name: pageLayoutWidget PK_2f997489b8b15cb26a0b9d4220b; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."pageLayoutWidget"
    ADD CONSTRAINT "PK_2f997489b8b15cb26a0b9d4220b" PRIMARY KEY (id);


--
-- Name: file PK_36b46d232307066b3a2c9ea3a1d; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.file
    ADD CONSTRAINT "PK_36b46d232307066b3a2c9ea3a1d" PRIMARY KEY (id);


--
-- Name: postgresCredentials PK_3f9c4cdf895bfea0a6ea15bdd81; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."postgresCredentials"
    ADD CONSTRAINT "PK_3f9c4cdf895bfea0a6ea15bdd81" PRIMARY KEY (id);


--
-- Name: agentHandoff PK_44aad35fb18ea2696f242d3fd76; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."agentHandoff"
    ADD CONSTRAINT "PK_44aad35fb18ea2696f242d3fd76" PRIMARY KEY (id);


--
-- Name: serverlessFunction PK_49bfacee064bee9d0d486483b60; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."serverlessFunction"
    ADD CONSTRAINT "PK_49bfacee064bee9d0d486483b60" PRIMARY KEY (id);


--
-- Name: pageLayout PK_5028ccb46ffa0c945d2f9246dfa; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."pageLayout"
    ADD CONSTRAINT "PK_5028ccb46ffa0c945d2f9246dfa" PRIMARY KEY (id);


--
-- Name: approvedAccessDomain PK_523281ce57c84e1a039f4538c19; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."approvedAccessDomain"
    ADD CONSTRAINT "PK_523281ce57c84e1a039f4538c19" PRIMARY KEY (id);


--
-- Name: application PK_569e0c3e863ebdf5f2408ee1670; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.application
    ADD CONSTRAINT "PK_569e0c3e863ebdf5f2408ee1670" PRIMARY KEY (id);


--
-- Name: indexFieldMetadata PK_5928f67e43eff7d95aa79fd96fd; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."indexFieldMetadata"
    ADD CONSTRAINT "PK_5928f67e43eff7d95aa79fd96fd" PRIMARY KEY (id);


--
-- Name: remoteTable PK_632b3858de52c8c2eb00c709b52; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."remoteTable"
    ADD CONSTRAINT "PK_632b3858de52c8c2eb00c709b52" PRIMARY KEY (id);


--
-- Name: dataSource PK_6d01ae6c0f47baf4f8e37342268; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."dataSource"
    ADD CONSTRAINT "PK_6d01ae6c0f47baf4f8e37342268" PRIMARY KEY (id);


--
-- Name: appToken PK_7d8bee0204106019488c4c50ffa; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."appToken"
    ADD CONSTRAINT "PK_7d8bee0204106019488c4c50ffa" PRIMARY KEY (id);


--
-- Name: objectMetadata PK_81fb7f4f4244211cfbd188af1e8; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."objectMetadata"
    ADD CONSTRAINT "PK_81fb7f4f4244211cfbd188af1e8" PRIMARY KEY (id);


--
-- Name: view PK_86cfb9e426c77d60b900fe2b543; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.view
    ADD CONSTRAINT "PK_86cfb9e426c77d60b900fe2b543" PRIMARY KEY (id);


--
-- Name: featureFlag PK_894efa1b1822de801f3b9e04069; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."featureFlag"
    ADD CONSTRAINT "PK_894efa1b1822de801f3b9e04069" PRIMARY KEY (id);


--
-- Name: permissionFlag PK_8c144a021030d7e3326835a04c8; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."permissionFlag"
    ADD CONSTRAINT "PK_8c144a021030d7e3326835a04c8" PRIMARY KEY (id);


--
-- Name: remoteServer PK_8e5d208498fa2c9710bb934023a; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."remoteServer"
    ADD CONSTRAINT "PK_8e5d208498fa2c9710bb934023a" PRIMARY KEY (id);


--
-- Name: roleTargets PK_9c02cbdd9053fbb6791e21b7146; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."roleTargets"
    ADD CONSTRAINT "PK_9c02cbdd9053fbb6791e21b7146" PRIMARY KEY (id);


--
-- Name: user PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."user"
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- Name: agentChatThread PK_a53b1d75d11ec67d13590cfa627; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."agentChatThread"
    ADD CONSTRAINT "PK_a53b1d75d11ec67d13590cfa627" PRIMARY KEY (id);


--
-- Name: _typeorm_migrations PK_a6ff2a8e8bb563f3d15635efd01; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core._typeorm_migrations
    ADD CONSTRAINT "PK_a6ff2a8e8bb563f3d15635efd01" PRIMARY KEY (id);


--
-- Name: agent PK_agent; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.agent
    ADD CONSTRAINT "PK_agent" PRIMARY KEY (id);


--
-- Name: role PK_b36bcfe02fc8de3c57a8b2391c2; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.role
    ADD CONSTRAINT "PK_b36bcfe02fc8de3c57a8b2391c2" PRIMARY KEY (id);


--
-- Name: databaseEventTrigger PK_b3e1ceba9d36f8b5aac6342a267; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."databaseEventTrigger"
    ADD CONSTRAINT "PK_b3e1ceba9d36f8b5aac6342a267" PRIMARY KEY (id);


--
-- Name: viewField PK_ba2a5aa5f0bd7ac82788fae921e; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewField"
    ADD CONSTRAINT "PK_ba2a5aa5f0bd7ac82788fae921e" PRIMARY KEY (id);


--
-- Name: twoFactorAuthenticationMethod PK_c455f6a499e7110fc95e4bea540; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."twoFactorAuthenticationMethod"
    ADD CONSTRAINT "PK_c455f6a499e7110fc95e4bea540" PRIMARY KEY (id);


--
-- Name: keyValuePair PK_c5a1ca828435d3eaf8f9361ed4b; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."keyValuePair"
    ADD CONSTRAINT "PK_c5a1ca828435d3eaf8f9361ed4b" PRIMARY KEY (id);


--
-- Name: fieldMetadata PK_d046b1c7cea325ebc4cdc25e7a9; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."fieldMetadata"
    ADD CONSTRAINT "PK_d046b1c7cea325ebc4cdc25e7a9" PRIMARY KEY (id);


--
-- Name: viewGroup PK_d2aa8cad01e9d5e99c23f9ccec3; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewGroup"
    ADD CONSTRAINT "PK_d2aa8cad01e9d5e99c23f9ccec3" PRIMARY KEY (id);


--
-- Name: fieldPermission PK_d7bb911e4f9b1b5e3bfcfdd1c4b; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."fieldPermission"
    ADD CONSTRAINT "PK_d7bb911e4f9b1b5e3bfcfdd1c4b" PRIMARY KEY (id);


--
-- Name: emailingDomain PK_dca7032537b5d307f8cc6d74f1d; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."emailingDomain"
    ADD CONSTRAINT "PK_dca7032537b5d307f8cc6d74f1d" PRIMARY KEY (id);


--
-- Name: webhook PK_e6765510c2d078db49632b59020; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.webhook
    ADD CONSTRAINT "PK_e6765510c2d078db49632b59020" PRIMARY KEY (id);


--
-- Name: viewSort PK_eceb74d297f926313af6463d496; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewSort"
    ADD CONSTRAINT "PK_eceb74d297f926313af6463d496" PRIMARY KEY (id);


--
-- Name: pageLayoutTab PK_f1327f6ea950cdc59fe17569c5c; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."pageLayoutTab"
    ADD CONSTRAINT "PK_f1327f6ea950cdc59fe17569c5c" PRIMARY KEY (id);


--
-- Name: agentChatMessage PK_f54a95b34e98d94251bce37a180; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."agentChatMessage"
    ADD CONSTRAINT "PK_f54a95b34e98d94251bce37a180" PRIMARY KEY (id);


--
-- Name: indexMetadata PK_f73bb3c3678aee204e341f0ca4e; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."indexMetadata"
    ADD CONSTRAINT "PK_f73bb3c3678aee204e341f0ca4e" PRIMARY KEY (id);


--
-- Name: workspaceMigration PK_f9b06eb42494795f73acb5c2350; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."workspaceMigration"
    ADD CONSTRAINT "PK_f9b06eb42494795f73acb5c2350" PRIMARY KEY (id);


--
-- Name: publicDomain PK_ff55a0f1bc3b6e2c32feff734b1; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."publicDomain"
    ADD CONSTRAINT "PK_ff55a0f1bc3b6e2c32feff734b1" PRIMARY KEY (id);


--
-- Name: publicDomain UQ_1311e24fbd049c561c53a274f2a; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."publicDomain"
    ADD CONSTRAINT "UQ_1311e24fbd049c561c53a274f2a" UNIQUE (domain);


--
-- Name: fieldMetadata UQ_47a6c57e1652b6475f8248cff78; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."fieldMetadata"
    ADD CONSTRAINT "UQ_47a6c57e1652b6475f8248cff78" UNIQUE ("relationTargetFieldMetadataId");


--
-- Name: workspace UQ_900f0a3eb789159c26c8bcb39cd; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.workspace
    ADD CONSTRAINT "UQ_900f0a3eb789159c26c8bcb39cd" UNIQUE ("customDomain");


--
-- Name: workspace UQ_cba6255a24deb1fff07dd7351b8; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.workspace
    ADD CONSTRAINT "UQ_cba6255a24deb1fff07dd7351b8" UNIQUE (subdomain);


--
-- Name: userWorkspace userWorkspace_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."userWorkspace"
    ADD CONSTRAINT "userWorkspace_pkey" PRIMARY KEY (id);


--
-- Name: workspaceSSOIdentityProvider workspaceSSOIdentityProvider_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."workspaceSSOIdentityProvider"
    ADD CONSTRAINT "workspaceSSOIdentityProvider_pkey" PRIMARY KEY (id);


--
-- Name: IDX_1c39502392dd9cbb186deba158; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_1c39502392dd9cbb186deba158" ON core.route USING btree ("workspaceId", "universalIdentifier");


--
-- Name: IDX_2909f5139c479e4632df03fd5e; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_2909f5139c479e4632df03fd5e" ON core."twoFactorAuthenticationMethod" USING btree ("userWorkspaceId", strategy);


--
-- Name: IDX_38232fc0c6567ed029c2b1a12c; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_38232fc0c6567ed029c2b1a12c" ON core."viewSort" USING btree ("workspaceId", "universalIdentifier");


--
-- Name: IDX_3bd935d6f8c5ce87194b8db824; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_3bd935d6f8c5ce87194b8db824" ON core."agentChatThread" USING btree ("userWorkspaceId");


--
-- Name: IDX_552aa6908966e980099b3e5ebf; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_552aa6908966e980099b3e5ebf" ON core.view USING btree ("workspaceId", "universalIdentifier");


--
-- Name: IDX_5b43e65e322d516c9307bed97a; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_5b43e65e322d516c9307bed97a" ON core."serverlessFunction" USING btree ("workspaceId", "universalIdentifier");


--
-- Name: IDX_8adc1fd6cb0dad2fbfd945954d; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_8adc1fd6cb0dad2fbfd945954d" ON core."cronTrigger" USING btree ("workspaceId", "universalIdentifier");


--
-- Name: IDX_960465af116edf9ac501bfb3db; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_960465af116edf9ac501bfb3db" ON core."databaseEventTrigger" USING btree ("workspaceId", "universalIdentifier");


--
-- Name: IDX_AGENT_HANDOFF_FROM_TO_WORKSPACE_UNIQUE; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_AGENT_HANDOFF_FROM_TO_WORKSPACE_UNIQUE" ON core."agentHandoff" USING btree ("fromAgentId", "toAgentId", "workspaceId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_AGENT_HANDOFF_ID_DELETED_AT; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_AGENT_HANDOFF_ID_DELETED_AT" ON core."agentHandoff" USING btree (id, "deletedAt");


--
-- Name: IDX_AGENT_ID_DELETED_AT; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_AGENT_ID_DELETED_AT" ON core.agent USING btree (id, "deletedAt");


--
-- Name: IDX_AGENT_NAME_WORKSPACE_ID_UNIQUE; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_AGENT_NAME_WORKSPACE_ID_UNIQUE" ON core.agent USING btree (name, "workspaceId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_API_KEY_WORKSPACE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_API_KEY_WORKSPACE_ID" ON core."apiKey" USING btree ("workspaceId");


--
-- Name: IDX_APPLICATION_STANDARD_ID_WORKSPACE_ID_UNIQUE; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_APPLICATION_STANDARD_ID_WORKSPACE_ID_UNIQUE" ON core.application USING btree ("standardId", "workspaceId") WHERE (("deletedAt" IS NULL) AND ("standardId" IS NOT NULL));


--
-- Name: IDX_APPLICATION_WORKSPACE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_APPLICATION_WORKSPACE_ID" ON core.application USING btree ("workspaceId");


--
-- Name: IDX_CRON_TRIGGER_WORKSPACE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_CRON_TRIGGER_WORKSPACE_ID" ON core."cronTrigger" USING btree ("workspaceId");


--
-- Name: IDX_DATABASE_EVENT_TRIGGER_WORKSPACE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_DATABASE_EVENT_TRIGGER_WORKSPACE_ID" ON core."databaseEventTrigger" USING btree ("workspaceId");


--
-- Name: IDX_DATA_SOURCE_WORKSPACE_ID_CREATED_AT; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_DATA_SOURCE_WORKSPACE_ID_CREATED_AT" ON core."dataSource" USING btree ("workspaceId", "createdAt");


--
-- Name: IDX_FIELD_METADATA_OBJECT_METADATA_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_FIELD_METADATA_OBJECT_METADATA_ID" ON core."fieldMetadata" USING btree ("objectMetadataId");


--
-- Name: IDX_FIELD_METADATA_OBJECT_METADATA_ID_WORKSPACE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_FIELD_METADATA_OBJECT_METADATA_ID_WORKSPACE_ID" ON core."fieldMetadata" USING btree ("objectMetadataId", "workspaceId");


--
-- Name: IDX_FIELD_METADATA_RELATION_TARGET_FIELD_METADATA_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_FIELD_METADATA_RELATION_TARGET_FIELD_METADATA_ID" ON core."fieldMetadata" USING btree ("relationTargetFieldMetadataId");


--
-- Name: IDX_FIELD_METADATA_RELATION_TARGET_OBJECT_METADATA_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_FIELD_METADATA_RELATION_TARGET_OBJECT_METADATA_ID" ON core."fieldMetadata" USING btree ("relationTargetObjectMetadataId");


--
-- Name: IDX_FIELD_METADATA_WORKSPACE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_FIELD_METADATA_WORKSPACE_ID" ON core."fieldMetadata" USING btree ("workspaceId");


--
-- Name: IDX_FIELD_PERMISSION_WORKSPACE_ID_ROLE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_FIELD_PERMISSION_WORKSPACE_ID_ROLE_ID" ON core."fieldPermission" USING btree ("workspaceId", "roleId");


--
-- Name: IDX_FILE_WORKSPACE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_FILE_WORKSPACE_ID" ON core.file USING btree ("workspaceId");


--
-- Name: IDX_INDEX_FIELD_METADATA_FIELD_METADATA_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_INDEX_FIELD_METADATA_FIELD_METADATA_ID" ON core."indexFieldMetadata" USING btree ("fieldMetadataId");


--
-- Name: IDX_INDEX_METADATA_WORKSPACE_ID_OBJECT_METADATA_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_INDEX_METADATA_WORKSPACE_ID_OBJECT_METADATA_ID" ON core."indexMetadata" USING btree ("workspaceId", "objectMetadataId");


--
-- Name: IDX_KEY_VALUE_PAIR_KEY_USER_ID_NULL_WORKSPACE_ID_UNIQUE; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_KEY_VALUE_PAIR_KEY_USER_ID_NULL_WORKSPACE_ID_UNIQUE" ON core."keyValuePair" USING btree (key, "userId") WHERE ("workspaceId" IS NULL);


--
-- Name: IDX_KEY_VALUE_PAIR_KEY_WORKSPACE_ID_NULL_USER_ID_UNIQUE; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_KEY_VALUE_PAIR_KEY_WORKSPACE_ID_NULL_USER_ID_UNIQUE" ON core."keyValuePair" USING btree (key, "workspaceId") WHERE ("userId" IS NULL);


--
-- Name: IDX_OBJECT_PERMISSION_WORKSPACE_ID_ROLE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_OBJECT_PERMISSION_WORKSPACE_ID_ROLE_ID" ON core."objectPermission" USING btree ("workspaceId", "roleId");


--
-- Name: IDX_PAGE_LAYOUT_TAB_WORKSPACE_ID_PAGE_LAYOUT_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_PAGE_LAYOUT_TAB_WORKSPACE_ID_PAGE_LAYOUT_ID" ON core."pageLayoutTab" USING btree ("workspaceId", "pageLayoutId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_PAGE_LAYOUT_WIDGET_WORKSPACE_ID_PAGE_LAYOUT_TAB_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_PAGE_LAYOUT_WIDGET_WORKSPACE_ID_PAGE_LAYOUT_TAB_ID" ON core."pageLayoutWidget" USING btree ("workspaceId", "pageLayoutTabId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_PAGE_LAYOUT_WORKSPACE_ID_OBJECT_METADATA_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_PAGE_LAYOUT_WORKSPACE_ID_OBJECT_METADATA_ID" ON core."pageLayout" USING btree ("workspaceId", "objectMetadataId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_ROLE_TARGETS_AGENT_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_ROLE_TARGETS_AGENT_ID" ON core."roleTargets" USING btree ("agentId");


--
-- Name: IDX_ROLE_TARGETS_API_KEY_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_ROLE_TARGETS_API_KEY_ID" ON core."roleTargets" USING btree ("apiKeyId");


--
-- Name: IDX_ROLE_TARGETS_WORKSPACE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_ROLE_TARGETS_WORKSPACE_ID" ON core."roleTargets" USING btree ("userWorkspaceId", "workspaceId");


--
-- Name: IDX_SEARCH_FIELD_METADATA_OBJECT_METADATA_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_SEARCH_FIELD_METADATA_OBJECT_METADATA_ID" ON core."searchFieldMetadata" USING btree ("objectMetadataId");


--
-- Name: IDX_SEARCH_FIELD_METADATA_WORKSPACE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_SEARCH_FIELD_METADATA_WORKSPACE_ID" ON core."searchFieldMetadata" USING btree ("workspaceId");


--
-- Name: IDX_SERVERLESS_FUNCTION_ID_DELETED_AT; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_SERVERLESS_FUNCTION_ID_DELETED_AT" ON core."serverlessFunction" USING btree (id, "deletedAt");


--
-- Name: IDX_USER_WORKSPACE_USER_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_USER_WORKSPACE_USER_ID" ON core."userWorkspace" USING btree ("userId");


--
-- Name: IDX_USER_WORKSPACE_USER_ID_WORKSPACE_ID_UNIQUE; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_USER_WORKSPACE_USER_ID_WORKSPACE_ID_UNIQUE" ON core."userWorkspace" USING btree ("userId", "workspaceId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_USER_WORKSPACE_WORKSPACE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_USER_WORKSPACE_WORKSPACE_ID" ON core."userWorkspace" USING btree ("workspaceId");


--
-- Name: IDX_VIEW_FIELD_FIELD_METADATA_ID_VIEW_ID_UNIQUE; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_VIEW_FIELD_FIELD_METADATA_ID_VIEW_ID_UNIQUE" ON core."viewField" USING btree ("fieldMetadataId", "viewId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_VIEW_FIELD_VIEW_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_VIEW_FIELD_VIEW_ID" ON core."viewField" USING btree ("viewId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_VIEW_FIELD_WORKSPACE_ID_VIEW_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_VIEW_FIELD_WORKSPACE_ID_VIEW_ID" ON core."viewField" USING btree ("workspaceId", "viewId");


--
-- Name: IDX_VIEW_FILTER_FIELD_METADATA_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_VIEW_FILTER_FIELD_METADATA_ID" ON core."viewFilter" USING btree ("fieldMetadataId");


--
-- Name: IDX_VIEW_FILTER_GROUP_VIEW_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_VIEW_FILTER_GROUP_VIEW_ID" ON core."viewFilterGroup" USING btree ("viewId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_VIEW_FILTER_GROUP_WORKSPACE_ID_VIEW_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_VIEW_FILTER_GROUP_WORKSPACE_ID_VIEW_ID" ON core."viewFilterGroup" USING btree ("workspaceId", "viewId");


--
-- Name: IDX_VIEW_FILTER_VIEW_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_VIEW_FILTER_VIEW_ID" ON core."viewFilter" USING btree ("viewId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_VIEW_FILTER_WORKSPACE_ID_VIEW_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_VIEW_FILTER_WORKSPACE_ID_VIEW_ID" ON core."viewFilter" USING btree ("workspaceId", "viewId");


--
-- Name: IDX_VIEW_GROUP_VIEW_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_VIEW_GROUP_VIEW_ID" ON core."viewGroup" USING btree ("viewId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_VIEW_GROUP_WORKSPACE_ID_VIEW_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_VIEW_GROUP_WORKSPACE_ID_VIEW_ID" ON core."viewGroup" USING btree ("workspaceId", "viewId");


--
-- Name: IDX_VIEW_SORT_FIELD_METADATA_ID_VIEW_ID_UNIQUE; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_VIEW_SORT_FIELD_METADATA_ID_VIEW_ID_UNIQUE" ON core."viewSort" USING btree ("fieldMetadataId", "viewId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_VIEW_SORT_VIEW_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_VIEW_SORT_VIEW_ID" ON core."viewSort" USING btree ("viewId") WHERE ("deletedAt" IS NULL);


--
-- Name: IDX_VIEW_SORT_WORKSPACE_ID_VIEW_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_VIEW_SORT_WORKSPACE_ID_VIEW_ID" ON core."viewSort" USING btree ("workspaceId", "viewId");


--
-- Name: IDX_VIEW_WORKSPACE_ID_OBJECT_METADATA_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_VIEW_WORKSPACE_ID_OBJECT_METADATA_ID" ON core.view USING btree ("workspaceId", "objectMetadataId");


--
-- Name: IDX_WEBHOOK_WORKSPACE_ID; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_WEBHOOK_WORKSPACE_ID" ON core.webhook USING btree ("workspaceId");


--
-- Name: IDX_WORKSPACE_ACTIVATION_STATUS; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_WORKSPACE_ACTIVATION_STATUS" ON core.workspace USING btree ("activationStatus");


--
-- Name: IDX_a44e3b03f0eca32d0504d5ef73; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_a44e3b03f0eca32d0504d5ef73" ON core."viewGroup" USING btree ("workspaceId", "universalIdentifier");


--
-- Name: IDX_b27c681286ac581f81498c5d4b; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_b27c681286ac581f81498c5d4b" ON core."indexMetadata" USING btree ("workspaceId", "universalIdentifier");


--
-- Name: IDX_b86af4ea24cae518dee8eae996; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_b86af4ea24cae518dee8eae996" ON core."viewField" USING btree ("workspaceId", "universalIdentifier");


--
-- Name: IDX_cd4588bfc9ad73345b3953a039; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_cd4588bfc9ad73345b3953a039" ON core."viewFilter" USING btree ("workspaceId", "universalIdentifier");


--
-- Name: IDX_cd5b23d4e471b630137b3017ba; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_cd5b23d4e471b630137b3017ba" ON core."agentChatMessage" USING btree ("threadId");


--
-- Name: IDX_d0bdc80c68a48b1f26727aabfe; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX "IDX_d0bdc80c68a48b1f26727aabfe" ON core."agentChatThread" USING btree ("agentId");


--
-- Name: IDX_e6ed40a61e4584e98584019a47; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_e6ed40a61e4584e98584019a47" ON core."viewFilterGroup" USING btree ("workspaceId", "universalIdentifier");


--
-- Name: UQ_USER_EMAIL; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX "UQ_USER_EMAIL" ON core."user" USING btree (email) WHERE ("deletedAt" IS NULL);


--
-- Name: pageLayoutTab FK_0177b1574efe6e6f24651977340; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."pageLayoutTab"
    ADD CONSTRAINT "FK_0177b1574efe6e6f24651977340" FOREIGN KEY ("pageLayoutId") REFERENCES core."pageLayout"(id) ON DELETE CASCADE;


--
-- Name: agentHandoff FK_020114432e51baf65bbbc46e350; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."agentHandoff"
    ADD CONSTRAINT "FK_020114432e51baf65bbbc46e350" FOREIGN KEY ("toAgentId") REFERENCES core.agent(id) ON DELETE CASCADE;


--
-- Name: indexMetadata FK_051487e9b745cb175950130b63f; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."indexMetadata"
    ADD CONSTRAINT "FK_051487e9b745cb175950130b63f" FOREIGN KEY ("objectMetadataId") REFERENCES core."objectMetadata"(id) ON DELETE CASCADE;


--
-- Name: pageLayoutWidget FK_0659a4d171c93f5c046f18d24cd; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."pageLayoutWidget"
    ADD CONSTRAINT "FK_0659a4d171c93f5c046f18d24cd" FOREIGN KEY ("pageLayoutTabId") REFERENCES core."pageLayoutTab"(id) ON DELETE CASCADE;


--
-- Name: viewFilter FK_06858adf0fb54ec88fa602198ca; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewFilter"
    ADD CONSTRAINT "FK_06858adf0fb54ec88fa602198ca" FOREIGN KEY ("viewId") REFERENCES core.view(id) ON DELETE CASCADE;


--
-- Name: application FK_08d1d5e33c2a3ce7c140e9b335b; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.application
    ADD CONSTRAINT "FK_08d1d5e33c2a3ce7c140e9b335b" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: viewField FK_0a48a0b66daedac1314437be5eb; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewField"
    ADD CONSTRAINT "FK_0a48a0b66daedac1314437be5eb" FOREIGN KEY ("fieldMetadataId") REFERENCES core."fieldMetadata"(id) ON DELETE CASCADE;


--
-- Name: objectMetadata FK_0b19dd17369574578bc18c405b2; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."objectMetadata"
    ADD CONSTRAINT "FK_0b19dd17369574578bc18c405b2" FOREIGN KEY ("dataSourceId") REFERENCES core."dataSource"(id) ON DELETE CASCADE;


--
-- Name: keyValuePair FK_0dae35d1c0fbdda6495be4ae71a; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."keyValuePair"
    ADD CONSTRAINT "FK_0dae35d1c0fbdda6495be4ae71a" FOREIGN KEY ("userId") REFERENCES core."user"(id) ON DELETE CASCADE;


--
-- Name: permissionFlag FK_13f8ca9c517976733a1ce4c10eb; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."permissionFlag"
    ADD CONSTRAINT "FK_13f8ca9c517976733a1ce4c10eb" FOREIGN KEY ("roleId") REFERENCES core.role(id) ON DELETE CASCADE;


--
-- Name: viewFilter FK_193548db5abc45713087f7d1af6; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewFilter"
    ADD CONSTRAINT "FK_193548db5abc45713087f7d1af6" FOREIGN KEY ("fieldMetadataId") REFERENCES core."fieldMetadata"(id) ON DELETE CASCADE;


--
-- Name: searchFieldMetadata FK_1b78544eb06f82059a2a01013a3; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."searchFieldMetadata"
    ADD CONSTRAINT "FK_1b78544eb06f82059a2a01013a3" FOREIGN KEY ("objectMetadataId") REFERENCES core."objectMetadata"(id) ON DELETE CASCADE;


--
-- Name: userWorkspace FK_22f5e76f493c3fb20237cfc48b0; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."userWorkspace"
    ADD CONSTRAINT "FK_22f5e76f493c3fb20237cfc48b0" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: pageLayoutTab FK_2528e67c8c0c953d8303172989e; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."pageLayoutTab"
    ADD CONSTRAINT "FK_2528e67c8c0c953d8303172989e" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: agent FK_259c48f99f625708723414adb5d; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.agent
    ADD CONSTRAINT "FK_259c48f99f625708723414adb5d" FOREIGN KEY ("applicationId") REFERENCES core.application(id) ON DELETE SET NULL;


--
-- Name: fieldPermission FK_2763aee5614b54019d692333fe1; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."fieldPermission"
    ADD CONSTRAINT "FK_2763aee5614b54019d692333fe1" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: viewSort FK_2b36c6adea4542b4844d9fb1806; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewSort"
    ADD CONSTRAINT "FK_2b36c6adea4542b4844d9fb1806" FOREIGN KEY ("viewId") REFERENCES core.view(id) ON DELETE CASCADE;


--
-- Name: viewGroup FK_2d7cfc4748058a0ca648835d046; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewGroup"
    ADD CONSTRAINT "FK_2d7cfc4748058a0ca648835d046" FOREIGN KEY ("viewId") REFERENCES core.view(id) ON DELETE CASCADE;


--
-- Name: viewFilter FK_32cabc67e40d24acab541c469a8; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewFilter"
    ADD CONSTRAINT "FK_32cabc67e40d24acab541c469a8" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: agentChatThread FK_3bd935d6f8c5ce87194b8db8240; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."agentChatThread"
    ADD CONSTRAINT "FK_3bd935d6f8c5ce87194b8db8240" FOREIGN KEY ("userWorkspaceId") REFERENCES core."userWorkspace"(id) ON DELETE CASCADE;


--
-- Name: remoteTable FK_3db5ae954f9197def326053f06a; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."remoteTable"
    ADD CONSTRAINT "FK_3db5ae954f9197def326053f06a" FOREIGN KEY ("remoteServerId") REFERENCES core."remoteServer"(id) ON DELETE CASCADE;


--
-- Name: view FK_3e5ea41c239ef1b75b0d42bef99; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.view
    ADD CONSTRAINT "FK_3e5ea41c239ef1b75b0d42bef99" FOREIGN KEY ("objectMetadataId") REFERENCES core."objectMetadata"(id) ON DELETE CASCADE;


--
-- Name: fieldMetadata FK_47a6c57e1652b6475f8248cff78; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."fieldMetadata"
    ADD CONSTRAINT "FK_47a6c57e1652b6475f8248cff78" FOREIGN KEY ("relationTargetFieldMetadataId") REFERENCES core."fieldMetadata"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pageLayoutWidget FK_555948f84165dce1fe1f5f955ce; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."pageLayoutWidget"
    ADD CONSTRAINT "FK_555948f84165dce1fe1f5f955ce" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: view FK_580dad12c8b92f3a3c307c4e66d; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.view
    ADD CONSTRAINT "FK_580dad12c8b92f3a3c307c4e66d" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: webhook FK_597ab5e7de76f1836b8fd80d6b9; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.webhook
    ADD CONSTRAINT "FK_597ab5e7de76f1836b8fd80d6b9" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: searchFieldMetadata FK_5f10e00da471e19f52513f47d8b; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."searchFieldMetadata"
    ADD CONSTRAINT "FK_5f10e00da471e19f52513f47d8b" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: viewSort FK_5f3278d6791aa4c58423e556ae6; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewSort"
    ADD CONSTRAINT "FK_5f3278d6791aa4c58423e556ae6" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: viewGroup FK_61053f5509cc31e5d7139fba1cb; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewGroup"
    ADD CONSTRAINT "FK_61053f5509cc31e5d7139fba1cb" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: viewFilterGroup FK_6aa17342705ae5526de377bf7ed; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewFilterGroup"
    ADD CONSTRAINT "FK_6aa17342705ae5526de377bf7ed" FOREIGN KEY ("parentViewFilterGroupId") REFERENCES core."viewFilterGroup"(id) ON DELETE CASCADE;


--
-- Name: featureFlag FK_6be7761fa8453f3a498aab6e72b; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."featureFlag"
    ADD CONSTRAINT "FK_6be7761fa8453f3a498aab6e72b" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: searchFieldMetadata FK_6d5c6922bfd1578b1eff2abb9d6; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."searchFieldMetadata"
    ADD CONSTRAINT "FK_6d5c6922bfd1578b1eff2abb9d6" FOREIGN KEY ("fieldMetadataId") REFERENCES core."fieldMetadata"(id) ON DELETE CASCADE;


--
-- Name: fieldMetadata FK_6f6c87ec32cca956d8be321071c; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."fieldMetadata"
    ADD CONSTRAINT "FK_6f6c87ec32cca956d8be321071c" FOREIGN KEY ("relationTargetObjectMetadataId") REFERENCES core."objectMetadata"(id) ON DELETE CASCADE;


--
-- Name: agentHandoff FK_7128daa5ac9f787388391b52269; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."agentHandoff"
    ADD CONSTRAINT "FK_7128daa5ac9f787388391b52269" FOREIGN KEY ("fromAgentId") REFERENCES core.agent(id) ON DELETE CASCADE;


--
-- Name: approvedAccessDomain FK_73d3e340b6ce0716a25a86361fc; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."approvedAccessDomain"
    ADD CONSTRAINT "FK_73d3e340b6ce0716a25a86361fc" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: pageLayout FK_760ec8b78721991220b76accd55; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."pageLayout"
    ADD CONSTRAINT "FK_760ec8b78721991220b76accd55" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: databaseEventTrigger FK_7650f1b8b693cde204f44ab0aa4; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."databaseEventTrigger"
    ADD CONSTRAINT "FK_7650f1b8b693cde204f44ab0aa4" FOREIGN KEY ("serverlessFunctionId") REFERENCES core."serverlessFunction"(id) ON DELETE CASCADE;


--
-- Name: emailingDomain FK_793a938bef2aae0a2129f78951f; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."emailingDomain"
    ADD CONSTRAINT "FK_793a938bef2aae0a2129f78951f" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: publicDomain FK_7e9ca5fd7aa30b8396ea3d1d6be; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."publicDomain"
    ADD CONSTRAINT "FK_7e9ca5fd7aa30b8396ea3d1d6be" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: agentHandoff FK_7ea2d1182dc5324e7cef9903302; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."agentHandoff"
    ADD CONSTRAINT "FK_7ea2d1182dc5324e7cef9903302" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: viewSort FK_818522b962a9b756accb5b3149d; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewSort"
    ADD CONSTRAINT "FK_818522b962a9b756accb5b3149d" FOREIGN KEY ("fieldMetadataId") REFERENCES core."fieldMetadata"(id) ON DELETE CASCADE;


--
-- Name: objectPermission FK_826052747c82e59f0a006204256; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."objectPermission"
    ADD CONSTRAINT "FK_826052747c82e59f0a006204256" FOREIGN KEY ("roleId") REFERENCES core.role(id) ON DELETE CASCADE;


--
-- Name: viewFilterGroup FK_8919a390f4022ab1e40182a5ac3; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewFilterGroup"
    ADD CONSTRAINT "FK_8919a390f4022ab1e40182a5ac3" FOREIGN KEY ("viewId") REFERENCES core.view(id) ON DELETE CASCADE;


--
-- Name: appToken FK_8cd4819144baf069777b5729136; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."appToken"
    ADD CONSTRAINT "FK_8cd4819144baf069777b5729136" FOREIGN KEY ("userId") REFERENCES core."user"(id) ON DELETE CASCADE;


--
-- Name: roleTargets FK_915c8bcb0f861a56f793a4b8331; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."roleTargets"
    ADD CONSTRAINT "FK_915c8bcb0f861a56f793a4b8331" FOREIGN KEY ("apiKeyId") REFERENCES core."apiKey"(id) ON DELETE CASCADE;


--
-- Name: postgresCredentials FK_9494639abc06f9c8c3691bf5d22; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."postgresCredentials"
    ADD CONSTRAINT "FK_9494639abc06f9c8c3691bf5d22" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: viewField FK_96158de54c78944b5340b6f708e; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewField"
    ADD CONSTRAINT "FK_96158de54c78944b5340b6f708e" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: userWorkspace FK_a2da2ea7d6cd1e5a4c5cb1791f8; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."userWorkspace"
    ADD CONSTRAINT "FK_a2da2ea7d6cd1e5a4c5cb1791f8" FOREIGN KEY ("userId") REFERENCES core."user"(id) ON DELETE CASCADE;


--
-- Name: file FK_a78a68c3f577a485dd4c741909f; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.file
    ADD CONSTRAINT "FK_a78a68c3f577a485dd4c741909f" FOREIGN KEY ("messageId") REFERENCES core."agentChatMessage"(id) ON DELETE CASCADE;


--
-- Name: twoFactorAuthenticationMethod FK_b0f44ffd7c794beb48cb1e1b1a9; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."twoFactorAuthenticationMethod"
    ADD CONSTRAINT "FK_b0f44ffd7c794beb48cb1e1b1a9" FOREIGN KEY ("userWorkspaceId") REFERENCES core."userWorkspace"(id) ON DELETE CASCADE;


--
-- Name: indexFieldMetadata FK_b20192c432612eb710801dd5664; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."indexFieldMetadata"
    ADD CONSTRAINT "FK_b20192c432612eb710801dd5664" FOREIGN KEY ("indexMetadataId") REFERENCES core."indexMetadata"(id) ON DELETE CASCADE;


--
-- Name: viewGroup FK_b3aa7ec58cdd9e83729f2232591; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewGroup"
    ADD CONSTRAINT "FK_b3aa7ec58cdd9e83729f2232591" FOREIGN KEY ("fieldMetadataId") REFERENCES core."fieldMetadata"(id) ON DELETE CASCADE;


--
-- Name: viewFilter FK_b518bd61175e0963370e09ef15e; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewFilter"
    ADD CONSTRAINT "FK_b518bd61175e0963370e09ef15e" FOREIGN KEY ("viewFilterGroupId") REFERENCES core."viewFilterGroup"(id) ON DELETE CASCADE;


--
-- Name: fieldPermission FK_bbf16a91f5a10199e5b18c019ba; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."fieldPermission"
    ADD CONSTRAINT "FK_bbf16a91f5a10199e5b18c019ba" FOREIGN KEY ("roleId") REFERENCES core.role(id) ON DELETE CASCADE;


--
-- Name: workspaceSSOIdentityProvider FK_bc8d8855198de1fbc32fba8df93; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."workspaceSSOIdentityProvider"
    ADD CONSTRAINT "FK_bc8d8855198de1fbc32fba8df93" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: indexFieldMetadata FK_be0950612a54b58c72bd62d629e; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."indexFieldMetadata"
    ADD CONSTRAINT "FK_be0950612a54b58c72bd62d629e" FOREIGN KEY ("fieldMetadataId") REFERENCES core."fieldMetadata"(id) ON DELETE CASCADE;


--
-- Name: keyValuePair FK_c137e3d8b3980901e114941daa2; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."keyValuePair"
    ADD CONSTRAINT "FK_c137e3d8b3980901e114941daa2" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: agent FK_c4cb56621768a4a325dd772bbe1; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.agent
    ADD CONSTRAINT "FK_c4cb56621768a4a325dd772bbe1" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: pageLayoutWidget FK_c4dc95034f53a12601e623d9171; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."pageLayoutWidget"
    ADD CONSTRAINT "FK_c4dc95034f53a12601e623d9171" FOREIGN KEY ("objectMetadataId") REFERENCES core."objectMetadata"(id) ON DELETE CASCADE;


--
-- Name: viewField FK_c5ab40cd4debb51d588752a4857; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewField"
    ADD CONSTRAINT "FK_c5ab40cd4debb51d588752a4857" FOREIGN KEY ("viewId") REFERENCES core.view(id) ON DELETE CASCADE;


--
-- Name: route FK_c63b1110bbf09051be2f495d0be; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.route
    ADD CONSTRAINT "FK_c63b1110bbf09051be2f495d0be" FOREIGN KEY ("serverlessFunctionId") REFERENCES core."serverlessFunction"(id) ON DELETE CASCADE;


--
-- Name: apiKey FK_c8b3efa54a29aa873043e72fb1d; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."apiKey"
    ADD CONSTRAINT "FK_c8b3efa54a29aa873043e72fb1d" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: agentChatMessage FK_cd5b23d4e471b630137b3017ba6; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."agentChatMessage"
    ADD CONSTRAINT "FK_cd5b23d4e471b630137b3017ba6" FOREIGN KEY ("threadId") REFERENCES core."agentChatThread"(id) ON DELETE CASCADE;


--
-- Name: agentChatThread FK_d0bdc80c68a48b1f26727aabfe6; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."agentChatThread"
    ADD CONSTRAINT "FK_d0bdc80c68a48b1f26727aabfe6" FOREIGN KEY ("agentId") REFERENCES core.agent(id) ON DELETE CASCADE;


--
-- Name: roleTargets FK_d5838ba43033ee6266d8928d7d7; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."roleTargets"
    ADD CONSTRAINT "FK_d5838ba43033ee6266d8928d7d7" FOREIGN KEY ("roleId") REFERENCES core.role(id) ON DELETE CASCADE;


--
-- Name: fieldPermission FK_d5c47a26fe71648894d05da3d3a; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."fieldPermission"
    ADD CONSTRAINT "FK_d5c47a26fe71648894d05da3d3a" FOREIGN KEY ("fieldMetadataId") REFERENCES core."fieldMetadata"(id) ON DELETE CASCADE;


--
-- Name: appToken FK_d6ae19a7aa2bbd4919053257772; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."appToken"
    ADD CONSTRAINT "FK_d6ae19a7aa2bbd4919053257772" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: fieldPermission FK_dc8e552397f5e44d175fedf752a; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."fieldPermission"
    ADD CONSTRAINT "FK_dc8e552397f5e44d175fedf752a" FOREIGN KEY ("objectMetadataId") REFERENCES core."objectMetadata"(id) ON DELETE CASCADE;


--
-- Name: viewFilterGroup FK_dce74ab06fa7a2effcbf1b98dff; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."viewFilterGroup"
    ADD CONSTRAINT "FK_dce74ab06fa7a2effcbf1b98dff" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: pageLayout FK_dd63ca42614bacf58971aabdcbb; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."pageLayout"
    ADD CONSTRAINT "FK_dd63ca42614bacf58971aabdcbb" FOREIGN KEY ("objectMetadataId") REFERENCES core."objectMetadata"(id) ON DELETE CASCADE;


--
-- Name: fieldMetadata FK_de2a09b9e3e690440480d2dee26; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."fieldMetadata"
    ADD CONSTRAINT "FK_de2a09b9e3e690440480d2dee26" FOREIGN KEY ("objectMetadataId") REFERENCES core."objectMetadata"(id) ON DELETE CASCADE;


--
-- Name: file FK_de468b3d8dcf7e94f7074220929; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.file
    ADD CONSTRAINT "FK_de468b3d8dcf7e94f7074220929" FOREIGN KEY ("workspaceId") REFERENCES core.workspace(id) ON DELETE CASCADE;


--
-- Name: objectPermission FK_efbcf3528718de2b5c45c0a8a83; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."objectPermission"
    ADD CONSTRAINT "FK_efbcf3528718de2b5c45c0a8a83" FOREIGN KEY ("objectMetadataId") REFERENCES core."objectMetadata"(id) ON DELETE CASCADE;


--
-- Name: cronTrigger FK_f70831ec336e0cb42d6a33b80ba; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core."cronTrigger"
    ADD CONSTRAINT "FK_f70831ec336e0cb42d6a33b80ba" FOREIGN KEY ("serverlessFunctionId") REFERENCES core."serverlessFunction"(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict P7ztTpH7qdWp2Q50J79dnTfa6aahOxspFP38ZWxtnsbevAMEtO57ZB3jzQGMH7b

