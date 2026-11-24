--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

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
-- Name: enum_Expenses_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_Expenses_status" AS ENUM (
    'pending',
    'approved',
    'rejected'
);


--
-- Name: enum_Ledgers_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_Ledgers_type" AS ENUM (
    'payment',
    'expense',
    'advance'
);


--
-- Name: enum_notification_recipients_recipient_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_notification_recipients_recipient_type AS ENUM (
    'ROLE',
    'CUSTOM_NUMBER'
);


--
-- Name: enum_whatsapp_notification_logs_execution_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_whatsapp_notification_logs_execution_type AS ENUM (
    'AUTOMATED',
    'MANUAL_TRIGGER',
    'TEST'
);


--
-- Name: enum_whatsapp_notification_logs_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_whatsapp_notification_logs_status AS ENUM (
    'QUEUED',
    'SENDING',
    'SENT',
    'DELIVERED',
    'FAILED',
    'SKIPPED'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Attendances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Attendances" (
    id uuid NOT NULL,
    "userId" character varying(255) NOT NULL,
    "userName" character varying(255) NOT NULL,
    date character varying(255) NOT NULL,
    "checkIn" character varying(255),
    "checkOut" character varying(255),
    "workingHours" character varying(255),
    coords json,
    address text,
    "lastHeartbeat" bigint,
    "heartbeatCount" integer DEFAULT 0 NOT NULL,
    "missedHeartbeatCount" integer DEFAULT 0 NOT NULL,
    "trackingStatus" character varying(255) DEFAULT 'ACTIVE'::character varying NOT NULL,
    "deviceManufacturer" character varying(255),
    "deviceModel" character varying(255),
    "androidVersion" character varying(255),
    "batteryLevel" double precision,
    "networkType" character varying(255),
    "gpsEnabled" boolean DEFAULT true,
    "trackingReliabilityScore" double precision,
    "notificationCount" integer DEFAULT 0 NOT NULL,
    "lastNotificationTime" bigint,
    "recoveryTime" bigint,
    "trackingInterruptedDuration" integer DEFAULT 0 NOT NULL,
    "workMode" character varying(255) DEFAULT 'office'::character varying NOT NULL,
    "isSwitched" boolean DEFAULT false NOT NULL,
    "checkInMethod" character varying(255),
    "clockOutMethod" character varying(255),
    "shiftCode" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "overtimeStatus" character varying(50) DEFAULT 'NONE'::character varying,
    "overtimeMinutes" integer DEFAULT 0,
    "overtimeHours" character varying(50),
    "overtimeApprovedBy" character varying(255),
    "overtimeApprovedAt" timestamp with time zone,
    "overtimeDecisionNote" text,
    "isHomeClockIn" boolean DEFAULT false,
    "appCheckIn" character varying(255),
    "homeDepartureTime" character varying(255),
    "hasExitedHome" boolean DEFAULT false,
    "homeGeofenceId" integer
);


--
-- Name: Expenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Expenses" (
    id text NOT NULL,
    "userId" text,
    "userName" text,
    category text,
    amount double precision,
    description text,
    "invoiceUrl" text,
    status character varying(50),
    "createdAt" text,
    "updatedAt" text,
    "billNo" text,
    "billDate" text,
    "siteName" text,
    "merchantName" text,
    "actionBy" character varying(255),
    "invoiceUrls" text,
    "suspiciousReason" text
);


--
-- Name: Ledgers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Ledgers" (
    id text NOT NULL,
    "employeeId" text,
    date text,
    description text,
    amount double precision,
    type text,
    source text,
    "createdAt" text,
    "updatedAt" text
);


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alembic_version (
    version_num text NOT NULL
);


--
-- Name: archived_chats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.archived_chats (
    id uuid NOT NULL,
    chat_id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attachments (
    id uuid NOT NULL,
    message_id uuid,
    file_name character varying(255),
    file_url text NOT NULL,
    file_type character varying(255) DEFAULT 'DOCUMENT'::character varying,
    file_size integer DEFAULT 0,
    mime_type character varying(255) DEFAULT 'application/octet-stream'::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: attendance_register_edits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendance_register_edits (
    id uuid NOT NULL,
    batch_id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    date character varying(255) NOT NULL,
    from_mark character varying(10),
    to_mark character varying(10) NOT NULL,
    note text,
    edited_by character varying(255),
    before_state text,
    after_state text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: attendance_regularizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendance_regularizations (
    id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    emp_code character varying(255),
    employee_name character varying(255),
    date character varying(255) NOT NULL,
    comment text NOT NULL,
    requested_check_in character varying(255),
    requested_check_out character varying(255),
    documents text DEFAULT '[]'::text NOT NULL,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    decided_by character varying(255),
    decided_at bigint,
    decision_note text,
    attendance_id character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: chat_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_members (
    id uuid NOT NULL,
    chat_id uuid,
    employee_id character varying(255),
    role character varying(255) DEFAULT 'MEMBER'::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: chats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chats (
    id uuid NOT NULL,
    type character varying(255) DEFAULT 'DIRECT'::character varying,
    title character varying(255),
    last_message_text text,
    last_message_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: cluster_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cluster_settings (
    id bigint NOT NULL,
    cluster_radius bigint,
    created_at text,
    updated_at text
);


--
-- Name: clusters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clusters (
    id bigint NOT NULL,
    name text,
    center_lat double precision,
    center_lng double precision,
    radius bigint,
    created_at text,
    updated_at text
);


--
-- Name: clusters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clusters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clusters_id_seq OWNED BY public.clusters.id;


--
-- Name: device_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_tokens (
    id character varying(255) NOT NULL,
    employee_id character varying(255) NOT NULL,
    token text NOT NULL,
    device_type character varying(255),
    platform character varying(255),
    last_active timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    document_id character varying(100) NOT NULL,
    filename character varying(255) NOT NULL,
    file_path text NOT NULL,
    file_content bytea,
    status character varying(50),
    saved boolean,
    ocr_result json,
    final_extraction json,
    template_id character varying(100),
    template_config json,
    error text,
    verification_time integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: employee_day_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_day_activities (
    id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    date character varying(255) NOT NULL,
    title character varying(120) NOT NULL,
    notes text,
    started_at bigint NOT NULL,
    planned_end_at bigint NOT NULL,
    deadline_at bigint NOT NULL,
    ended_at bigint,
    status character varying(20) DEFAULT 'IN_PROGRESS'::character varying NOT NULL,
    extensions text DEFAULT '[]'::text NOT NULL,
    finish_reason text,
    reminders_sent integer DEFAULT 0 NOT NULL,
    deadline_reminders integer DEFAULT 0 NOT NULL,
    last_reminder_at bigint,
    start_latitude double precision,
    start_longitude double precision,
    end_latitude double precision,
    end_longitude double precision,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    site_name character varying(150)
);


--
-- Name: employee_geofence_tracking_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_geofence_tracking_states (
    employee_id character varying(255) NOT NULL,
    attendance_id character varying(255),
    consecutive_outside_count integer DEFAULT 0 NOT NULL,
    alert_sent boolean DEFAULT false NOT NULL,
    last_status character varying(255) DEFAULT 'NONE'::character varying NOT NULL,
    last_outside_ping_at timestamp with time zone,
    last_alert_sent_at timestamp with time zone,
    last_ping_timestamp bigint,
    last_evaluated_lat double precision,
    last_evaluated_lon double precision,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: employee_salary_components; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_salary_components (
    id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    component_id character varying(255) NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: geotagged_media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geotagged_media (
    id text NOT NULL,
    user_id text,
    user_name text,
    file_path text,
    media_type text,
    latitude double precision,
    longitude double precision,
    address text,
    cloudinary_url text,
    "timestamp" bigint,
    date text,
    created_at text,
    updated_at text,
    site_id bigint,
    cluster_id bigint
);


--
-- Name: holiday_calendars; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.holiday_calendars (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    location character varying(255) NOT NULL,
    state character varying(255),
    year integer DEFAULT 2026 NOT NULL,
    "isDefault" boolean DEFAULT false,
    holidays json DEFAULT '[]'::json,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: legal_acknowledgments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legal_acknowledgments (
    id uuid NOT NULL,
    user_id character varying(255) NOT NULL,
    employee_name character varying(255) NOT NULL,
    employee_email character varying(255) NOT NULL,
    device_info character varying(255),
    ip_address character varying(255),
    terms_version character varying(255) DEFAULT 'v1.0'::character varying NOT NULL,
    accepted_at timestamp with time zone NOT NULL,
    status character varying(255) DEFAULT 'ACCEPTED'::character varying NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: loan_repayments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.loan_repayments (
    id uuid NOT NULL,
    loan_id uuid NOT NULL,
    payroll_item_id uuid,
    amount_paid double precision NOT NULL,
    repayment_date timestamp with time zone,
    source character varying(255) DEFAULT 'PAYROLL'::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: loans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.loans (
    id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    principal_amount double precision NOT NULL,
    interest_rate double precision DEFAULT '0'::double precision,
    tenure_months integer NOT NULL,
    emi_amount double precision NOT NULL,
    remaining_balance double precision NOT NULL,
    status character varying(255) DEFAULT 'ACTIVE'::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: location_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_documents (
    id uuid NOT NULL,
    title character varying(255) NOT NULL,
    file_path character varying(255) NOT NULL,
    uploader_id character varying(255) NOT NULL,
    uploader_name character varying(255) NOT NULL,
    target_type character varying(255) NOT NULL,
    target_user_id character varying(255),
    target_user_name character varying(255),
    file_type character varying(255),
    file_size integer,
    uploaded_at bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: location_employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_employees (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(255) DEFAULT 'EMPLOYEE'::character varying NOT NULL,
    designation character varying(255) DEFAULT 'OFFICE'::character varying NOT NULL,
    status character varying(255) DEFAULT 'ACTIVE'::character varying NOT NULL,
    allowed_leaves integer DEFAULT 0 NOT NULL,
    consumed_leaves integer DEFAULT 0 NOT NULL,
    opening_leave_balance double precision DEFAULT '0'::double precision NOT NULL,
    earned_leaves double precision DEFAULT '0'::double precision NOT NULL,
    dob character varying(255),
    father_name character varying(255),
    spouse_name character varying(255),
    present_address text,
    emp_code character varying(255),
    nationality character varying(255),
    phone_no character varying(255),
    joining_date character varying(255),
    job_title character varying(255),
    legal_entity character varying(255) DEFAULT 'Hydromaterials Private Limited'::character varying,
    department character varying(255),
    location character varying(255),
    reporting_manager character varying(255),
    probation_policy character varying(255),
    notice_period character varying(255),
    leave_setting character varying(255),
    holiday_details character varying(255),
    weekly_offs character varying(255) DEFAULT 'Sunday'::character varying,
    attendance_setting character varying(255),
    overtime character varying(255),
    expense_policies character varying(255),
    compensation_gross double precision,
    last_revision_date character varying(255),
    pf_eligible boolean DEFAULT true,
    pf_amount double precision,
    pf_number character varying(255),
    esi_eligible boolean DEFAULT true,
    esic_number character varying(255),
    lwf_eligible boolean DEFAULT true,
    lwf_amount double precision DEFAULT '60'::double precision,
    vpf_eligible boolean DEFAULT false,
    vpf_amount double precision DEFAULT '0'::double precision,
    pt_eligible boolean DEFAULT true,
    pt_amount double precision,
    pt_state_id character varying(255),
    pt_state_code character varying(255),
    pt_exemption boolean DEFAULT false,
    pt_exemption_type character varying(255),
    pt_exemption_reason character varying(255),
    pt_effective_date character varying(255),
    tax_regime character varying(255) DEFAULT 'New Regime (Section 115BAC)'::character varying,
    bank_name character varying(255),
    bank_account_no character varying(255),
    bank_ifsc_code character varying(255),
    bank_branch_name character varying(255),
    pan_number character varying(255),
    uan_number character varying(255),
    esi_number character varying(255),
    exit_reason character varying(255),
    exit_discussed boolean,
    exit_discussion_summary text,
    exit_termination_reason character varying(255),
    exit_notice_date character varying(255),
    exit_comments text,
    exit_date character varying(255),
    profile_photo_url character varying(255),
    current_token text,
    fcm_token character varying(255),
    primary_work_mode character varying(255) DEFAULT 'office'::character varying NOT NULL,
    can_switch_mode boolean DEFAULT true NOT NULL,
    clock_in_bypass_approved boolean DEFAULT false NOT NULL,
    gender character varying(255) DEFAULT 'Male'::character varying,
    avatar text,
    is_online boolean DEFAULT false,
    last_seen timestamp with time zone,
    is_system_account boolean DEFAULT false,
    custom_fields text DEFAULT '{}'::text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    account_number character varying(255),
    ifsc_code character varying(255),
    pannumber character varying(255),
    uannumber character varying(255),
    esinumber character varying(255),
    aadhaar_number character varying(255),
    aadhaarnumber character varying(255),
    aadhar_number character varying(255),
    aadharnumber character varying(255),
    highest_qualification text,
    permanent_address text,
    emergency_contact character varying(255),
    pfnumber character varying(255),
    place_of_duty character varying(255)
);


--
-- Name: location_employees_backup; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_employees_backup (
    id text NOT NULL,
    name text,
    email text,
    password text,
    role text,
    designation text,
    allowed_leaves bigint,
    consumed_leaves bigint,
    created_at text,
    updated_at text,
    dob text,
    emp_code text,
    nationality text,
    phone_no text,
    joining_date text,
    job_title text,
    legal_entity text,
    department text,
    location text,
    reporting_manager text,
    probation_policy text,
    notice_period text,
    leave_setting text,
    holiday_details text,
    weekly_offs text,
    attendance_setting text,
    overtime text,
    expense_policies text,
    compensation_gross double precision,
    pf_eligible bigint,
    esi_eligible bigint,
    lwf_eligible bigint,
    tax_regime text,
    custom_fields text,
    status text,
    bank_name text,
    bank_account_no text,
    bank_ifsc_code text,
    bank_branch_name text,
    exit_reason text,
    exit_discussed bigint,
    exit_discussion_summary text,
    exit_termination_reason text,
    exit_notice_date text,
    exit_comments text,
    current_token text,
    exit_date text,
    profile_photo_url text,
    fcm_token text,
    primary_work_mode text,
    can_switch_mode bigint,
    clock_in_bypass_approved bigint,
    pf_number text,
    esic_number text,
    account_number text,
    ifsc_code text,
    gender text,
    avatar text,
    is_online text,
    last_seen text,
    vpf_eligible boolean,
    vpf_amount double precision,
    pt_eligible boolean,
    pt_amount double precision,
    lwf_amount double precision,
    pf_amount double precision,
    "pfAmount" double precision,
    pan_number text,
    "panNumber" text,
    uan_number text,
    "uanNumber" text,
    esi_number text,
    "esiNumber" text,
    pt_state_id text,
    pt_state_code text,
    pt_exemption bigint,
    pt_exemption_type text,
    pt_exemption_reason text,
    pt_effective_date text
);


--
-- Name: location_footprints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_footprints (
    id character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    "timestamp" bigint NOT NULL,
    date character varying(255) NOT NULL,
    tracking_method character varying(255) NOT NULL,
    latitude double precision,
    longitude double precision,
    address text,
    accuracy double precision,
    speed double precision,
    heading double precision,
    altitude double precision,
    cell_id integer,
    lac integer,
    tac integer,
    mcc integer,
    mnc integer,
    signal_strength integer,
    location_enabled boolean DEFAULT true NOT NULL,
    battery_level double precision,
    battery_temp double precision,
    network_type character varying(255),
    reason character varying(255),
    is_mock_location boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    location_source character varying(50) DEFAULT 'GPS'::character varying,
    fix_timestamp bigint,
    fix_age_ms bigint,
    fix_elapsed_realtime_nanos bigint,
    provider character varying(255),
    capture_source character varying(255),
    validation_status character varying(255)
);


--
-- Name: location_geofence_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_geofence_settings (
    id bigint NOT NULL,
    name text,
    latitude double precision,
    longitude double precision,
    radius double precision,
    created_at text,
    updated_at text,
    category character varying(32) DEFAULT 'SITE'::character varying,
    employee_id character varying(64) DEFAULT NULL::character varying
);


--
-- Name: location_geofence_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.location_geofence_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_geofence_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.location_geofence_settings_id_seq OWNED BY public.location_geofence_settings.id;


--
-- Name: location_leave_adjustments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_leave_adjustments (
    id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    emp_code character varying(255),
    employee_name character varying(255) NOT NULL,
    leave_type character varying(255) DEFAULT 'Earned Leave'::character varying NOT NULL,
    adjustment_type character varying(255) DEFAULT 'OPENING_BALANCE'::character varying NOT NULL,
    days double precision DEFAULT '0'::double precision NOT NULL,
    reason text NOT NULL,
    effective_date character varying(255),
    adjusted_by character varying(255) DEFAULT 'Admin'::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    year integer,
    month integer,
    work_date character varying(20),
    related_adjustment_id uuid,
    status character varying(20) DEFAULT 'ACTIVE'::character varying
);


--
-- Name: location_leave_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_leave_categories (
    id uuid NOT NULL,
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    duration_value integer NOT NULL,
    duration_unit character varying(255) DEFAULT 'days'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: location_leaves; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_leaves (
    id uuid NOT NULL,
    user_id character varying(255) NOT NULL,
    user_name character varying(255) NOT NULL,
    start_date character varying(255) NOT NULL,
    end_date character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    reason text NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    el_days integer DEFAULT 0 NOT NULL,
    lop_days integer DEFAULT 0 NOT NULL,
    total_days integer DEFAULT 0 NOT NULL,
    applied_at bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    action_by character varying(255),
    leave_category character varying(255),
    working_dates text
);


--
-- Name: location_leaves_backup_20260926; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_leaves_backup_20260926 (
    id text,
    user_id text,
    user_name text,
    start_date text,
    end_date text,
    type text,
    reason text,
    status text,
    applied_at bigint,
    created_at text,
    updated_at text,
    el_days bigint,
    lop_days bigint,
    total_days bigint
);


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id uuid NOT NULL,
    chat_id uuid,
    sender_id character varying(255),
    content text,
    type character varying(255) DEFAULT 'TEXT'::character varying,
    parent_message_id uuid,
    status character varying(255) DEFAULT 'SENT'::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: notification_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_logs (
    id character varying(255) NOT NULL,
    notification_id character varying(255) NOT NULL,
    employee_id character varying(255) NOT NULL,
    status character varying(255) NOT NULL,
    error text,
    sent_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: notification_recipients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_recipients (
    id integer NOT NULL,
    notification_type character varying(255) DEFAULT 'DAILY_ATTENDANCE_SUMMARY'::character varying NOT NULL,
    recipient_type public.enum_notification_recipients_recipient_type DEFAULT 'ROLE'::public.enum_notification_recipients_recipient_type NOT NULL,
    target_role character varying(255),
    phone_number character varying(255),
    name character varying(255),
    enabled boolean DEFAULT true,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: notification_recipients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notification_recipients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notification_recipients_id_seq OWNED BY public.notification_recipients.id;


--
-- Name: notification_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_settings (
    id integer NOT NULL,
    notification_type character varying(255) DEFAULT 'DAILY_ATTENDANCE_SUMMARY'::character varying NOT NULL,
    enabled boolean DEFAULT true,
    scheduled_time character varying(255) DEFAULT '12:00'::character varying,
    timezone character varying(255) DEFAULT 'Asia/Kolkata'::character varying,
    template_name character varying(255) DEFAULT 'daily_attendance_summary'::character varying,
    send_on_holidays boolean DEFAULT false,
    send_on_weekoffs boolean DEFAULT false,
    include_detailed_breakdown boolean DEFAULT false,
    max_retry_attempts integer DEFAULT 3,
    created_by character varying(255),
    updated_by character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: notification_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notification_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notification_settings_id_seq OWNED BY public.notification_settings.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    body text NOT NULL,
    type character varying(255) NOT NULL,
    target character varying(255) NOT NULL,
    target_id character varying(255),
    schedule_at timestamp with time zone,
    status character varying(255) DEFAULT 'PENDING'::character varying,
    created_by character varying(255),
    payload text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: otp_verifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.otp_verifications (
    id uuid NOT NULL,
    employee_id character varying(255),
    email character varying(255) NOT NULL,
    otp_hash character varying(255) NOT NULL,
    purpose character varying(255) DEFAULT 'PASSWORD_RESET'::character varying NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    is_used boolean DEFAULT false NOT NULL,
    reset_token character varying(255),
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: payroll_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payroll_items (
    id uuid NOT NULL,
    payroll_run_id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    working_days double precision DEFAULT '30'::double precision,
    worked_days double precision DEFAULT '30'::double precision,
    lop_days double precision DEFAULT '0'::double precision,
    overtime_hours double precision DEFAULT '0'::double precision,
    earnings_breakdown text DEFAULT '{}'::text,
    deductions_breakdown text DEFAULT '{}'::text,
    gross_earned double precision DEFAULT '0'::double precision,
    total_deductions double precision DEFAULT '0'::double precision,
    net_salary double precision DEFAULT '0'::double precision,
    reimbursements double precision DEFAULT '0'::double precision,
    status character varying(255) DEFAULT 'DRAFT'::character varying,
    professional_tax_amount double precision DEFAULT '0'::double precision,
    professional_tax_rule_id character varying(255),
    professional_tax_state_id character varying(255),
    professional_tax_salary_basis character varying(255),
    professional_tax_calculation_date character varying(255),
    error_log text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: payroll_items_backup_20260921; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payroll_items_backup_20260921 (
    id text,
    payroll_run_id text,
    employee_id text,
    worked_days double precision,
    lop_days double precision,
    overtime_hours double precision,
    earnings_breakdown text,
    deductions_breakdown text,
    gross_earned double precision,
    total_deductions double precision,
    net_salary double precision,
    reimbursements double precision,
    status text,
    error_log text,
    created_at text,
    updated_at text,
    professional_tax_amount double precision,
    professional_tax_rule_id text,
    professional_tax_state_id text,
    professional_tax_salary_basis text,
    professional_tax_calculation_date text,
    working_days double precision
);


--
-- Name: payroll_runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payroll_runs (
    id uuid NOT NULL,
    month character varying(255) NOT NULL,
    status character varying(255) DEFAULT 'DRAFT'::character varying NOT NULL,
    total_gross double precision DEFAULT '0'::double precision,
    total_deductions double precision DEFAULT '0'::double precision,
    total_net double precision DEFAULT '0'::double precision,
    processed_by character varying(255),
    error_message text,
    attendance_locked boolean DEFAULT false,
    wizard_state text DEFAULT '{}'::text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    lop_source character varying(20)
);


--
-- Name: payslips; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payslips (
    id uuid NOT NULL,
    payroll_item_id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    month character varying(255) NOT NULL,
    file_path character varying(255),
    secure_hash character varying(255),
    email_sent_status boolean DEFAULT false,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    app_sent_status boolean DEFAULT false
);


--
-- Name: pinned_chats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pinned_chats (
    id uuid NOT NULL,
    chat_id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: professional_tax_audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.professional_tax_audit_logs (
    id uuid NOT NULL,
    user_id character varying(255),
    user_name character varying(255),
    action character varying(255) NOT NULL,
    state_id uuid,
    state_code character varying(255),
    rule_id uuid,
    old_value text,
    new_value text,
    reason text,
    ip_address character varying(255),
    "timestamp" bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: professional_tax_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.professional_tax_rules (
    id uuid NOT NULL,
    state_id uuid NOT NULL,
    rule_name character varying(255),
    salary_from double precision DEFAULT '0'::double precision NOT NULL,
    salary_to double precision DEFAULT '999999999'::double precision NOT NULL,
    pt_amount double precision DEFAULT '0'::double precision NOT NULL,
    calculation_type character varying(255) DEFAULT 'FIXED'::character varying NOT NULL,
    formula_expression character varying(255),
    period_type character varying(255) DEFAULT 'MONTHLY'::character varying NOT NULL,
    month_specific_rules text,
    gender character varying(255) DEFAULT 'ALL'::character varying NOT NULL,
    employee_category character varying(255) DEFAULT 'ALL'::character varying NOT NULL,
    is_exemption boolean DEFAULT false NOT NULL,
    exemption_type character varying(255),
    exemption_value character varying(255),
    effective_from character varying(255) DEFAULT '2026-04-01'::character varying NOT NULL,
    effective_to character varying(255),
    is_active boolean DEFAULT true NOT NULL,
    status character varying(255) DEFAULT 'ACTIVE'::character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    created_by character varying(255),
    updated_by character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: professional_tax_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.professional_tax_states (
    id uuid NOT NULL,
    state_code character varying(255) NOT NULL,
    state_name character varying(255) NOT NULL,
    country_code character varying(255) DEFAULT 'IN'::character varying NOT NULL,
    tax_name character varying(255) DEFAULT 'Professional Tax'::character varying NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    salary_basis character varying(255) DEFAULT 'GROSS_SALARY'::character varying NOT NULL,
    max_annual_pt double precision DEFAULT '2500'::double precision,
    max_monthly_pt double precision,
    frequency character varying(255) DEFAULT 'MONTHLY'::character varying NOT NULL,
    effective_from character varying(255) DEFAULT '2026-04-01'::character varying NOT NULL,
    effective_to character varying(255),
    description text,
    created_by character varying(255),
    updated_by character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: project_inventory_docs_v2; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_inventory_docs_v2 (
    id integer NOT NULL,
    msid integer NOT NULL,
    group_id character varying(100),
    scheme_name character varying(255),
    doc_name character varying(255) NOT NULL,
    specification text,
    hsn_code character varying(50),
    req_qty character varying(100),
    uom character varying(50),
    make character varying(100),
    vendor_name character varying(255),
    vendor_pan character varying(50),
    paid_to character varying(255),
    tax_percent numeric(5,2),
    rate_per_unit numeric(15,4),
    bill_date date,
    bill_number character varying(100),
    kyc_type character varying(50),
    reference_no character varying(100),
    qty character varying(100),
    location character varying(100),
    file_paths text,
    last_tx_date date,
    status character varying(50),
    forwarded_to_expenses integer,
    added_by character varying(100),
    verification_time integer,
    vendor_gstin character varying(50),
    vendor_address text,
    vendor_phone text,
    vendor_email character varying(255),
    vendor_state character varying(100),
    consumer_name character varying(255),
    consumer_gstin character varying(50),
    consumer_address text,
    consumer_state character varying(100),
    consignee_name character varying(255),
    consignee_address text,
    consignee_state character varying(100),
    invoice_number character varying(100),
    invoice_date date,
    place_of_supply text,
    transport_mode character varying(50),
    destination character varying(100),
    vehicle_number character varying(50),
    subtotal numeric(15,2),
    cgst numeric(15,2),
    sgst numeric(15,2),
    igst numeric(15,2),
    cess numeric(15,2),
    round_off numeric(15,2),
    grand_total numeric(15,2),
    bank_name character varying(255),
    bank_branch character varying(255),
    account_number character varying(100),
    ifsc_code character varying(50),
    payment_terms text,
    items_json json,
    notes_json json,
    validation_passed integer,
    validation_errors json,
    validation_warnings json,
    confidence_score numeric(5,2),
    processing_time_ms numeric(15,2),
    inference_time_ms numeric(15,2),
    model_name character varying(100),
    lora_loaded integer,
    image_width integer,
    image_height integer,
    tokens_generated integer,
    additional_charges numeric(15,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: project_inventory_docs_v2_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_inventory_docs_v2_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_inventory_docs_v2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_inventory_docs_v2_id_seq OWNED BY public.project_inventory_docs_v2.id;


--
-- Name: raw_ai_extractions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.raw_ai_extractions (
    id integer NOT NULL,
    document_id character varying(100) NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    model_name character varying(100) NOT NULL,
    model_version character varying(50) NOT NULL,
    prompt_version character varying(50) NOT NULL,
    extraction_data json NOT NULL,
    raw_ocr_text text,
    ocr_blocks json,
    page_count integer DEFAULT 1 NOT NULL,
    temperature double precision NOT NULL,
    top_p double precision NOT NULL,
    max_tokens integer NOT NULL,
    confidence_score double precision,
    inference_time_ms integer NOT NULL,
    processing_pipeline_version character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying(100),
    updated_by character varying(100),
    source_application character varying(100) DEFAULT 'invoice-ocr-platform'::character varying,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    deleted_by character varying(100)
);


--
-- Name: raw_ai_extractions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.raw_ai_extractions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: raw_ai_extractions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.raw_ai_extractions_id_seq OWNED BY public.raw_ai_extractions.id;


--
-- Name: read_receipts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.read_receipts (
    id uuid NOT NULL,
    message_id uuid,
    employee_id character varying(255) NOT NULL,
    read_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: reimbursements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reimbursements (
    id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    category character varying(255) DEFAULT 'OTHER'::character varying,
    amount double precision NOT NULL,
    claim_date timestamp with time zone,
    receipt_url character varying(255),
    status character varying(255) DEFAULT 'PENDING'::character varying,
    processed_in_run_id uuid,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: salary_components; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salary_components (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    calculation_type character varying(255) NOT NULL,
    formula character varying(255),
    is_statutory boolean DEFAULT false,
    is_taxable boolean DEFAULT true,
    status character varying(255) DEFAULT 'ACTIVE'::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: salary_structures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salary_structures (
    id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    ctc double precision DEFAULT '0'::double precision NOT NULL,
    gross_salary double precision DEFAULT '0'::double precision NOT NULL,
    effective_from character varying(255) NOT NULL,
    effective_to character varying(255),
    version integer DEFAULT 1,
    status character varying(255) DEFAULT 'ACTIVE'::character varying,
    revision_reason character varying(255) DEFAULT 'Salary Revision'::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: setting_audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.setting_audit_logs (
    id integer NOT NULL,
    admin_user_id character varying(255),
    changes_json text NOT NULL,
    ip_address character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: setting_audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.setting_audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: setting_audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.setting_audit_logs_id_seq OWNED BY public.setting_audit_logs.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    id integer NOT NULL,
    config_version integer DEFAULT 1 NOT NULL,
    punch_in_start character varying(255) DEFAULT '08:30'::character varying NOT NULL,
    punch_in_end character varying(255) DEFAULT '10:00'::character varying NOT NULL,
    punch_out_time character varying(255) DEFAULT '18:00'::character varying NOT NULL,
    location_provider character varying(255) DEFAULT 'GPS Preferred'::character varying NOT NULL,
    gps_ratio_count integer DEFAULT 1 NOT NULL,
    cellular_ratio_count integer DEFAULT 6 NOT NULL,
    location_update_interval character varying(255) DEFAULT '30 Seconds'::character varying NOT NULL,
    grace_minutes integer DEFAULT 15 NOT NULL,
    half_day_minutes integer DEFAULT 240 NOT NULL,
    full_day_minutes integer DEFAULT 480 NOT NULL,
    min_working_minutes integer DEFAULT 240 NOT NULL,
    max_working_minutes integer DEFAULT 720 NOT NULL,
    overtime_threshold_minutes integer DEFAULT 480 NOT NULL,
    auto_sync_interval_seconds integer DEFAULT 30 NOT NULL,
    allow_cross_day boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    smtp_host character varying(255) DEFAULT 'smtp.gmail.com'::character varying,
    smtp_port integer DEFAULT 465,
    smtp_user character varying(255),
    smtp_pass character varying(255),
    smtp_from_name character varying(255) DEFAULT 'Hydro HRMS'::character varying,
    smtp_secure boolean DEFAULT true
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sites (
    id bigint NOT NULL,
    name text,
    latitude double precision,
    longitude double precision,
    radius double precision,
    created_at text,
    updated_at text
);


--
-- Name: special_shift_verifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.special_shift_verifications (
    id uuid NOT NULL,
    adjustment_id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    emp_code character varying(255),
    employee_name character varying(255),
    department character varying(255),
    work_date character varying(255) NOT NULL,
    day_type character varying(255) NOT NULL,
    holiday_name character varying(255),
    attendance_ids text,
    check_in character varying(255),
    check_out character varying(255),
    working_hours double precision DEFAULT '0'::double precision NOT NULL,
    eligible_days double precision DEFAULT '0'::double precision NOT NULL,
    attendance_status character varying(255) DEFAULT 'COMPLETE'::character varying NOT NULL,
    punch_issues text,
    auto_clock_out boolean DEFAULT false NOT NULL,
    evaluated_at timestamp with time zone,
    verified_by character varying(255),
    verified_by_name character varying(255),
    verified_at timestamp with time zone,
    approved_days double precision,
    override_applied boolean DEFAULT false NOT NULL,
    override_reason text,
    rejection_reason text,
    changed_after_decision boolean DEFAULT false NOT NULL,
    latest_working_hours double precision,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: system_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_rules (
    key text NOT NULL,
    value text,
    label text,
    description text,
    category text,
    created_at text,
    updated_at text
);


--
-- Name: system_settings; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.system_settings AS
 SELECT id,
    config_version,
    punch_in_start,
    punch_in_end,
    punch_out_time,
    location_provider,
    gps_ratio_count,
    cellular_ratio_count,
    location_update_interval,
    grace_minutes,
    half_day_minutes,
    full_day_minutes,
    min_working_minutes,
    max_working_minutes,
    overtime_threshold_minutes,
    auto_sync_interval_seconds,
    allow_cross_day,
    created_at,
    updated_at,
    smtp_host,
    smtp_port,
    smtp_user,
    smtp_pass,
    smtp_from_name,
    smtp_secure
   FROM public.settings;


--
-- Name: tax_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tax_records (
    id uuid NOT NULL,
    employee_id character varying(255) NOT NULL,
    financial_year character varying(255) NOT NULL,
    regime character varying(255) DEFAULT 'NEW'::character varying NOT NULL,
    investment_declarations text DEFAULT '{}'::text,
    projected_annual_tax double precision DEFAULT '0'::double precision,
    monthly_tds double precision DEFAULT '0'::double precision,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.templates (
    id character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    is_default boolean,
    sections json NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: tracking_audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tracking_audit_logs (
    id text NOT NULL,
    employee_id text,
    attendance_session_id text,
    event text,
    details text,
    "timestamp" bigint,
    created_at text,
    updated_at text
);


--
-- Name: user_verified_extractions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_verified_extractions (
    id integer NOT NULL,
    document_id character varying(100) NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    verified_data json NOT NULL,
    verified_by character varying(100) NOT NULL,
    reviewer_role character varying(50) NOT NULL,
    review_status character varying(30) NOT NULL,
    training_status character varying(30) NOT NULL,
    correction_reason text,
    review_notes text,
    was_corrected boolean NOT NULL,
    number_of_fields_changed integer NOT NULL,
    changed_fields json,
    edit_distance_score double precision NOT NULL,
    field_accuracy double precision NOT NULL,
    overall_accuracy double precision,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying(100),
    updated_by character varying(100),
    source_application character varying(100) DEFAULT 'invoice-ocr-platform'::character varying,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    deleted_by character varying(100)
);


--
-- Name: user_verified_extractions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_verified_extractions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_verified_extractions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_verified_extractions_id_seq OWNED BY public.user_verified_extractions.id;


--
-- Name: whatsapp_notification_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.whatsapp_notification_logs (
    id integer NOT NULL,
    notification_type character varying(255) DEFAULT 'DAILY_ATTENDANCE_SUMMARY'::character varying NOT NULL,
    business_date character varying(255) NOT NULL,
    recipient_phone character varying(255) NOT NULL,
    recipient_name character varying(255),
    status public.enum_whatsapp_notification_logs_status DEFAULT 'QUEUED'::public.enum_whatsapp_notification_logs_status NOT NULL,
    execution_type public.enum_whatsapp_notification_logs_execution_type DEFAULT 'AUTOMATED'::public.enum_whatsapp_notification_logs_execution_type NOT NULL,
    message_wamid character varying(255),
    payload_summary json,
    attempt_count integer DEFAULT 1,
    error_code character varying(255),
    error_message text,
    sent_at timestamp with time zone,
    delivered_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: whatsapp_notification_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.whatsapp_notification_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: whatsapp_notification_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.whatsapp_notification_logs_id_seq OWNED BY public.whatsapp_notification_logs.id;


--
-- Name: clusters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters ALTER COLUMN id SET DEFAULT nextval('public.clusters_id_seq'::regclass);


--
-- Name: location_geofence_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_geofence_settings ALTER COLUMN id SET DEFAULT nextval('public.location_geofence_settings_id_seq'::regclass);


--
-- Name: notification_recipients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_recipients ALTER COLUMN id SET DEFAULT nextval('public.notification_recipients_id_seq'::regclass);


--
-- Name: notification_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_settings ALTER COLUMN id SET DEFAULT nextval('public.notification_settings_id_seq'::regclass);


--
-- Name: project_inventory_docs_v2 id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_inventory_docs_v2 ALTER COLUMN id SET DEFAULT nextval('public.project_inventory_docs_v2_id_seq'::regclass);


--
-- Name: raw_ai_extractions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.raw_ai_extractions ALTER COLUMN id SET DEFAULT nextval('public.raw_ai_extractions_id_seq'::regclass);


--
-- Name: setting_audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.setting_audit_logs ALTER COLUMN id SET DEFAULT nextval('public.setting_audit_logs_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: user_verified_extractions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_verified_extractions ALTER COLUMN id SET DEFAULT nextval('public.user_verified_extractions_id_seq'::regclass);


--
-- Name: whatsapp_notification_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_notification_logs ALTER COLUMN id SET DEFAULT nextval('public.whatsapp_notification_logs_id_seq'::regclass);


--
-- Name: Attendances Attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Attendances"
    ADD CONSTRAINT "Attendances_pkey" PRIMARY KEY (id);


--
-- Name: Expenses Expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Expenses"
    ADD CONSTRAINT "Expenses_pkey" PRIMARY KEY (id);


--
-- Name: Ledgers Ledgers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Ledgers"
    ADD CONSTRAINT "Ledgers_pkey" PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkey PRIMARY KEY (version_num);


--
-- Name: archived_chats archived_chats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.archived_chats
    ADD CONSTRAINT archived_chats_pkey PRIMARY KEY (id);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: attendance_register_edits attendance_register_edits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance_register_edits
    ADD CONSTRAINT attendance_register_edits_pkey PRIMARY KEY (id);


--
-- Name: attendance_regularizations attendance_regularizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance_regularizations
    ADD CONSTRAINT attendance_regularizations_pkey PRIMARY KEY (id);


--
-- Name: chat_members chat_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_members
    ADD CONSTRAINT chat_members_pkey PRIMARY KEY (id);


--
-- Name: chats chats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);


--
-- Name: cluster_settings cluster_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_settings
    ADD CONSTRAINT cluster_settings_pkey PRIMARY KEY (id);


--
-- Name: clusters clusters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters
    ADD CONSTRAINT clusters_pkey PRIMARY KEY (id);


--
-- Name: device_tokens device_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_tokens
    ADD CONSTRAINT device_tokens_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (document_id);


--
-- Name: employee_day_activities employee_day_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_day_activities
    ADD CONSTRAINT employee_day_activities_pkey PRIMARY KEY (id);


--
-- Name: employee_geofence_tracking_states employee_geofence_tracking_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_geofence_tracking_states
    ADD CONSTRAINT employee_geofence_tracking_states_pkey PRIMARY KEY (employee_id);


--
-- Name: employee_salary_components employee_salary_components_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_salary_components
    ADD CONSTRAINT employee_salary_components_pkey PRIMARY KEY (id);


--
-- Name: geotagged_media geotagged_media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geotagged_media
    ADD CONSTRAINT geotagged_media_pkey PRIMARY KEY (id);


--
-- Name: holiday_calendars holiday_calendars_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.holiday_calendars
    ADD CONSTRAINT holiday_calendars_pkey PRIMARY KEY (id);


--
-- Name: legal_acknowledgments legal_acknowledgments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_acknowledgments
    ADD CONSTRAINT legal_acknowledgments_pkey PRIMARY KEY (id);


--
-- Name: loan_repayments loan_repayments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loan_repayments
    ADD CONSTRAINT loan_repayments_pkey PRIMARY KEY (id);


--
-- Name: loans loans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_pkey PRIMARY KEY (id);


--
-- Name: location_documents location_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_documents
    ADD CONSTRAINT location_documents_pkey PRIMARY KEY (id);


--
-- Name: location_employees_backup location_employees_backup_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_employees_backup
    ADD CONSTRAINT location_employees_backup_pkey PRIMARY KEY (id);


--
-- Name: location_employees location_employees_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_employees
    ADD CONSTRAINT location_employees_email_key UNIQUE (email);


--
-- Name: location_employees location_employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_employees
    ADD CONSTRAINT location_employees_pkey PRIMARY KEY (id);


--
-- Name: location_footprints location_footprints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_footprints
    ADD CONSTRAINT location_footprints_pkey PRIMARY KEY (id);


--
-- Name: location_geofence_settings location_geofence_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_geofence_settings
    ADD CONSTRAINT location_geofence_settings_pkey PRIMARY KEY (id);


--
-- Name: location_leave_adjustments location_leave_adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_leave_adjustments
    ADD CONSTRAINT location_leave_adjustments_pkey PRIMARY KEY (id);


--
-- Name: location_leave_categories location_leave_categories_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_leave_categories
    ADD CONSTRAINT location_leave_categories_code_key UNIQUE (code);


--
-- Name: location_leave_categories location_leave_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_leave_categories
    ADD CONSTRAINT location_leave_categories_pkey PRIMARY KEY (id);


--
-- Name: location_leaves location_leaves_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_leaves
    ADD CONSTRAINT location_leaves_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notification_logs notification_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_logs
    ADD CONSTRAINT notification_logs_pkey PRIMARY KEY (id);


--
-- Name: notification_recipients notification_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT notification_recipients_pkey PRIMARY KEY (id);


--
-- Name: notification_settings notification_settings_notification_type_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_settings
    ADD CONSTRAINT notification_settings_notification_type_key UNIQUE (notification_type);


--
-- Name: notification_settings notification_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_settings
    ADD CONSTRAINT notification_settings_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: otp_verifications otp_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.otp_verifications
    ADD CONSTRAINT otp_verifications_pkey PRIMARY KEY (id);


--
-- Name: payroll_items payroll_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payroll_items
    ADD CONSTRAINT payroll_items_pkey PRIMARY KEY (id);


--
-- Name: payroll_runs payroll_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payroll_runs
    ADD CONSTRAINT payroll_runs_pkey PRIMARY KEY (id);


--
-- Name: payslips payslips_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payslips
    ADD CONSTRAINT payslips_pkey PRIMARY KEY (id);


--
-- Name: pinned_chats pinned_chats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pinned_chats
    ADD CONSTRAINT pinned_chats_pkey PRIMARY KEY (id);


--
-- Name: professional_tax_audit_logs professional_tax_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professional_tax_audit_logs
    ADD CONSTRAINT professional_tax_audit_logs_pkey PRIMARY KEY (id);


--
-- Name: professional_tax_rules professional_tax_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professional_tax_rules
    ADD CONSTRAINT professional_tax_rules_pkey PRIMARY KEY (id);


--
-- Name: professional_tax_states professional_tax_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professional_tax_states
    ADD CONSTRAINT professional_tax_states_pkey PRIMARY KEY (id);


--
-- Name: professional_tax_states professional_tax_states_state_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professional_tax_states
    ADD CONSTRAINT professional_tax_states_state_code_key UNIQUE (state_code);


--
-- Name: project_inventory_docs_v2 project_inventory_docs_v2_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_inventory_docs_v2
    ADD CONSTRAINT project_inventory_docs_v2_pkey PRIMARY KEY (id);


--
-- Name: raw_ai_extractions raw_ai_extractions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.raw_ai_extractions
    ADD CONSTRAINT raw_ai_extractions_pkey PRIMARY KEY (id);


--
-- Name: read_receipts read_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.read_receipts
    ADD CONSTRAINT read_receipts_pkey PRIMARY KEY (id);


--
-- Name: reimbursements reimbursements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reimbursements
    ADD CONSTRAINT reimbursements_pkey PRIMARY KEY (id);


--
-- Name: salary_components salary_components_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_components
    ADD CONSTRAINT salary_components_pkey PRIMARY KEY (id);


--
-- Name: salary_structures salary_structures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_structures
    ADD CONSTRAINT salary_structures_pkey PRIMARY KEY (id);


--
-- Name: setting_audit_logs setting_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.setting_audit_logs
    ADD CONSTRAINT setting_audit_logs_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: sites sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: special_shift_verifications special_shift_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_verifications
    ADD CONSTRAINT special_shift_verifications_pkey PRIMARY KEY (id);


--
-- Name: system_rules system_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_rules
    ADD CONSTRAINT system_rules_pkey PRIMARY KEY (key);


--
-- Name: tax_records tax_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_records
    ADD CONSTRAINT tax_records_pkey PRIMARY KEY (id);


--
-- Name: templates templates_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.templates
    ADD CONSTRAINT templates_name_key UNIQUE (name);


--
-- Name: templates templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.templates
    ADD CONSTRAINT templates_pkey PRIMARY KEY (id);


--
-- Name: tracking_audit_logs tracking_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracking_audit_logs
    ADD CONSTRAINT tracking_audit_logs_pkey PRIMARY KEY (id);


--
-- Name: user_verified_extractions user_verified_extractions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_verified_extractions
    ADD CONSTRAINT user_verified_extractions_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_notification_logs whatsapp_notification_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_notification_logs
    ADD CONSTRAINT whatsapp_notification_logs_pkey PRIMARY KEY (id);


--
-- Name: attendance_register_edits_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attendance_register_edits_batch_id ON public.attendance_register_edits USING btree (batch_id);


--
-- Name: attendance_register_edits_employee_id_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attendance_register_edits_employee_id_date ON public.attendance_register_edits USING btree (employee_id, date);


--
-- Name: attendance_regularizations_employee_id_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attendance_regularizations_employee_id_date ON public.attendance_regularizations USING btree (employee_id, date);


--
-- Name: attendance_regularizations_status_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attendance_regularizations_status_date ON public.attendance_regularizations USING btree (status, date);


--
-- Name: attendances_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attendances_created_at ON public."Attendances" USING btree ("createdAt");


--
-- Name: attendances_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attendances_user_id ON public."Attendances" USING btree ("userId");


--
-- Name: attendances_user_id_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attendances_user_id_date ON public."Attendances" USING btree ("userId", date);


--
-- Name: attendances_user_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attendances_user_name ON public."Attendances" USING btree ("userName");


--
-- Name: employee_day_activities_employee_id_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX employee_day_activities_employee_id_date ON public.employee_day_activities USING btree (employee_id, date);


--
-- Name: employee_day_activities_status_deadline_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX employee_day_activities_status_deadline_at ON public.employee_day_activities USING btree (status, deadline_at);


--
-- Name: idx_footprints_ts_desc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_footprints_ts_desc ON public.location_footprints USING btree ("timestamp" DESC);


--
-- Name: idx_footprints_ts_user_pg; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_footprints_ts_user_pg ON public.location_footprints USING btree ("timestamp" DESC, user_id);


--
-- Name: idx_footprints_user_ts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_footprints_user_ts ON public.location_footprints USING btree (user_id, "timestamp" DESC);


--
-- Name: idx_gf_tracking_emp_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gf_tracking_emp_id ON public.employee_geofence_tracking_states USING btree (employee_id);


--
-- Name: idx_leave_adjustments_emp_year_month; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leave_adjustments_emp_year_month ON public.location_leave_adjustments USING btree (employee_id, year, month);


--
-- Name: idx_leave_adjustments_work_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leave_adjustments_work_date ON public.location_leave_adjustments USING btree (employee_id, work_date);


--
-- Name: idx_leaves_applied_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leaves_applied_at ON public.location_leaves USING btree (applied_at DESC);


--
-- Name: idx_leaves_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leaves_status ON public.location_leaves USING btree (status);


--
-- Name: idx_leaves_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leaves_user_id ON public.location_leaves USING btree (user_id);


--
-- Name: idx_raw_ai_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_raw_ai_created ON public.raw_ai_extractions USING btree (created_at);


--
-- Name: idx_raw_ai_doc_ver; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_raw_ai_doc_ver ON public.raw_ai_extractions USING btree (document_id, version);


--
-- Name: idx_raw_ai_model; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_raw_ai_model ON public.raw_ai_extractions USING btree (model_name, model_version);


--
-- Name: idx_user_ver_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_ver_created ON public.user_verified_extractions USING btree (created_at);


--
-- Name: idx_user_ver_doc_ver; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_ver_doc_ver ON public.user_verified_extractions USING btree (document_id, version);


--
-- Name: idx_user_ver_reviewer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_ver_reviewer ON public.user_verified_extractions USING btree (verified_by);


--
-- Name: idx_user_ver_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_ver_status ON public.user_verified_extractions USING btree (training_status);


--
-- Name: ix_raw_ai_extractions_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_raw_ai_extractions_created_at ON public.raw_ai_extractions USING btree (created_at);


--
-- Name: ix_raw_ai_extractions_is_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_raw_ai_extractions_is_deleted ON public.raw_ai_extractions USING btree (is_deleted);


--
-- Name: ix_user_verified_extractions_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_user_verified_extractions_created_at ON public.user_verified_extractions USING btree (created_at);


--
-- Name: ix_user_verified_extractions_is_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_user_verified_extractions_is_deleted ON public.user_verified_extractions USING btree (is_deleted);


--
-- Name: legal_acknowledgments_user_id_accepted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX legal_acknowledgments_user_id_accepted_at ON public.legal_acknowledgments USING btree (user_id, accepted_at);


--
-- Name: location_footprints_user_id_battery_level_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX location_footprints_user_id_battery_level_timestamp ON public.location_footprints USING btree (user_id, battery_level, "timestamp");


--
-- Name: location_footprints_user_id_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX location_footprints_user_id_date ON public.location_footprints USING btree (user_id, date);


--
-- Name: location_footprints_user_id_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX location_footprints_user_id_timestamp ON public.location_footprints USING btree (user_id, "timestamp");


--
-- Name: payroll_items_payroll_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payroll_items_payroll_run_id ON public.payroll_items USING btree (payroll_run_id);


--
-- Name: payroll_items_payroll_run_id_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payroll_items_payroll_run_id_employee_id ON public.payroll_items USING btree (payroll_run_id, employee_id);


--
-- Name: payroll_runs_month; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payroll_runs_month ON public.payroll_runs USING btree (month);


--
-- Name: payroll_runs_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payroll_runs_status ON public.payroll_runs USING btree (status);


--
-- Name: salary_structures_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX salary_structures_employee_id ON public.salary_structures USING btree (employee_id);


--
-- Name: salary_structures_employee_id_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX salary_structures_employee_id_status ON public.salary_structures USING btree (employee_id, status);


--
-- Name: special_shift_verifications_adjustment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX special_shift_verifications_adjustment_id ON public.special_shift_verifications USING btree (adjustment_id);


--
-- Name: special_shift_verifications_employee_id_work_date; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX special_shift_verifications_employee_id_work_date ON public.special_shift_verifications USING btree (employee_id, work_date);


--
-- Name: special_shift_verifications_work_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX special_shift_verifications_work_date ON public.special_shift_verifications USING btree (work_date);


--
-- Name: attachments attachments_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.messages(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: chat_members chat_members_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_members
    ADD CONSTRAINT chat_members_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: chat_members chat_members_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_members
    ADD CONSTRAINT chat_members_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.location_employees(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: device_tokens device_tokens_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_tokens
    ADD CONSTRAINT device_tokens_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.location_employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employee_salary_components employee_salary_components_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_salary_components
    ADD CONSTRAINT employee_salary_components_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.location_employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: loan_repayments loan_repayments_loan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loan_repayments
    ADD CONSTRAINT loan_repayments_loan_id_fkey FOREIGN KEY (loan_id) REFERENCES public.loans(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: loans loans_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.location_employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: messages messages_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: messages messages_parent_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_parent_message_id_fkey FOREIGN KEY (parent_message_id) REFERENCES public.messages(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.location_employees(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: notification_logs notification_logs_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_logs
    ADD CONSTRAINT notification_logs_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.location_employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notification_logs notification_logs_notification_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_logs
    ADD CONSTRAINT notification_logs_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payroll_items payroll_items_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payroll_items
    ADD CONSTRAINT payroll_items_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.location_employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payroll_items payroll_items_payroll_run_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payroll_items
    ADD CONSTRAINT payroll_items_payroll_run_id_fkey FOREIGN KEY (payroll_run_id) REFERENCES public.payroll_runs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payslips payslips_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payslips
    ADD CONSTRAINT payslips_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.location_employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payslips payslips_payroll_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payslips
    ADD CONSTRAINT payslips_payroll_item_id_fkey FOREIGN KEY (payroll_item_id) REFERENCES public.payroll_items(id) ON UPDATE CASCADE;


--
-- Name: professional_tax_audit_logs professional_tax_audit_logs_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professional_tax_audit_logs
    ADD CONSTRAINT professional_tax_audit_logs_state_id_fkey FOREIGN KEY (state_id) REFERENCES public.professional_tax_states(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: professional_tax_rules professional_tax_rules_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professional_tax_rules
    ADD CONSTRAINT professional_tax_rules_state_id_fkey FOREIGN KEY (state_id) REFERENCES public.professional_tax_states(id) ON UPDATE CASCADE;


--
-- Name: raw_ai_extractions raw_ai_extractions_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.raw_ai_extractions
    ADD CONSTRAINT raw_ai_extractions_document_id_fkey FOREIGN KEY (document_id) REFERENCES public.documents(document_id) ON DELETE CASCADE;


--
-- Name: read_receipts read_receipts_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.read_receipts
    ADD CONSTRAINT read_receipts_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.messages(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reimbursements reimbursements_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reimbursements
    ADD CONSTRAINT reimbursements_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.location_employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: salary_structures salary_structures_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_structures
    ADD CONSTRAINT salary_structures_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.location_employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tax_records tax_records_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_records
    ADD CONSTRAINT tax_records_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.location_employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_verified_extractions user_verified_extractions_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_verified_extractions
    ADD CONSTRAINT user_verified_extractions_document_id_fkey FOREIGN KEY (document_id) REFERENCES public.documents(document_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

