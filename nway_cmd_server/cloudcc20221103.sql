--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: auto_insert_into_call_pg_cdr(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.auto_insert_into_call_pg_cdr() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$  
DECLARE  
    time_column_name    text ;       
    curMM       varchar(10);    
    isExist         int;    
    startTime       text;  
    endTime     text;  
    strSQL          text;  
      
BEGIN  
 
    time_column_name := TG_ARGV[0];  
     
    
    EXECUTE 'SELECT $1.'||time_column_name INTO strSQL USING NEW;  
    curMM := to_char( strSQL::timestamp , 'YYYY_MM' );  
    select count(*) INTO isExist from pg_class where relname = (TG_RELNAME||'_'||curMM);  
   
    IF ( isExist =0 ) THEN    
     
        startTime := curMM||'_01 00:00:00.000';  
        endTime := to_char( startTime::timestamp + interval '1 month', 'YYYY-MM-DD HH24:MI:SS.MS');  
        strSQL := 'CREATE TABLE IF NOT EXISTS '||TG_RELNAME||'_'||curMM||  
                  ' ( CHECK('||time_column_name||'>='''|| startTime ||''' AND '  
                             ||time_column_name||'< '''|| endTime ||''' )  
                          ) INHERITS ('||TG_RELNAME||') ;'  ;    
        EXECUTE strSQL;  
  
       
        strSQL := 'CREATE INDEX '||TG_RELNAME||'_'||curMM||'_INDEX_'||time_column_name||' ON '  
                  ||TG_RELNAME||'_'||curMM||' ('||time_column_name||');' ;  
        EXECUTE strSQL;  
        
        strSQL := 'CREATE INDEX '||TG_RELNAME||'_'||curMM||'_INDEX_UUID ON '  
                  ||TG_RELNAME||'_'||curMM||' (uuid,bleg_uuid);' ;  
        EXECUTE strSQL;  
        strSQL := 'CREATE INDEX '||TG_RELNAME||'_'||curMM||'_INDEX_ORIGI_UUID ON '  
                  ||TG_RELNAME||'_'||curMM||' (origination_uuid);' ;  
        EXECUTE strSQL; 
        
         
    END IF;  
  
    
    strSQL := 'INSERT INTO '||TG_RELNAME||'_'||curMM||' SELECT $1.*' ;  
    EXECUTE strSQL USING NEW;  
  
    RETURN NULL;   
END  
$_$;


ALTER FUNCTION public.auto_insert_into_call_pg_cdr() OWNER TO postgres;

--
-- Name: auto_insert_into_nway_fs_heartbeat_history(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.auto_insert_into_nway_fs_heartbeat_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$  
DECLARE  
    time_column_name    text ;       
    curMM       varchar(10);    
    isExist         int;    
    startTime       text;  
    endTime     text;  
    strSQL          text;  
      
BEGIN  
 
    time_column_name := TG_ARGV[0];  
     
    
    EXECUTE 'SELECT $1.'||time_column_name INTO strSQL USING NEW;  
    curMM := to_char( strSQL::timestamp , 'YYYY_MM' );  
    select count(*) INTO isExist from pg_class where relname = (TG_RELNAME||'_'||curMM);  
   
    IF ( isExist =0 ) THEN    
     
        startTime := curMM||'_01 00:00:00.000';  
        endTime := to_char( startTime::timestamp + interval '1 month', 'YYYY-MM-DD HH24:MI:SS.MS');  
        strSQL := 'CREATE TABLE IF NOT EXISTS '||TG_RELNAME||'_'||curMM||  
                  ' ( CHECK('||time_column_name||'>='''|| startTime ||''' AND '  
                             ||time_column_name||'< '''|| endTime ||''' )  
                          ) INHERITS ('||TG_RELNAME||') ;'  ;    
        EXECUTE strSQL;  
  
       
        strSQL := 'CREATE INDEX '||TG_RELNAME||'_'||curMM||'_INDEX_'||time_column_name||' ON '  
                  ||TG_RELNAME||'_'||curMM||' ('||time_column_name||');' ;  
        EXECUTE strSQL;  
        
       
        
         
    END IF;  
  
    
    strSQL := 'INSERT INTO '||TG_RELNAME||'_'||curMM||' SELECT $1.*' ;  
    EXECUTE strSQL USING NEW;  
  
    RETURN NULL;   
END  
$_$;


ALTER FUNCTION public.auto_insert_into_nway_fs_heartbeat_history() OWNER TO postgres;

--
-- Name: call_blacklist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.call_blacklist_id_seq
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.call_blacklist_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: call_blacklist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.call_blacklist (
    id bigint DEFAULT nextval('public.call_blacklist_id_seq'::regclass) NOT NULL,
    category integer DEFAULT 0,
    call_number character varying(30) NOT NULL,
    dest_number character varying(30) DEFAULT ''::character varying,
    group_number character varying(50),
    domain_id bigint DEFAULT 0,
    expire_time timestamp without time zone DEFAULT (now() + '7 days'::interval)
);


ALTER TABLE public.call_blacklist OWNER TO postgres;

--
-- Name: COLUMN call_blacklist.category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.call_blacklist.category IS '类型，全局黑名单0，对外黑名单1，呼入黑名单2';


--
-- Name: goadmin_menu_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goadmin_menu_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_menu_myid_seq OWNER TO postgres;

--
-- Name: goadmin_operation_log_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goadmin_operation_log_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_operation_log_myid_seq OWNER TO postgres;

--
-- Name: goadmin_permissions_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goadmin_permissions_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_permissions_myid_seq OWNER TO postgres;

--
-- Name: goadmin_roles_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goadmin_roles_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_roles_myid_seq OWNER TO postgres;

--
-- Name: goadmin_session_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goadmin_session_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_session_myid_seq OWNER TO postgres;

--
-- Name: goadmin_site_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goadmin_site_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_site_myid_seq OWNER TO postgres;

--
-- Name: goadmin_users_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goadmin_users_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_users_myid_seq OWNER TO postgres;

--
-- Name: nway_acl; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_acl (
    id bigint NOT NULL,
    node_id bigint NOT NULL,
    acl_name character varying(100) DEFAULT ''''''::character varying NOT NULL,
    default_type character varying(100) DEFAULT 'allow'::character varying NOT NULL
);


ALTER TABLE public.nway_acl OWNER TO postgres;

--
-- Name: nway_acl_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_acl_detail (
    id bigint NOT NULL,
    acl_type character varying(100) NOT NULL,
    is_domain boolean DEFAULT false NOT NULL,
    acl_value character varying(100) DEFAULT ''''''::character varying NOT NULL
);


ALTER TABLE public.nway_acl_detail OWNER TO postgres;

--
-- Name: nway_acl_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_acl_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_acl_detail_id_seq OWNER TO postgres;

--
-- Name: nway_acl_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_acl_detail_id_seq OWNED BY public.nway_acl_detail.id;


--
-- Name: nway_acl_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_acl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_acl_id_seq OWNER TO postgres;

--
-- Name: nway_acl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_acl_id_seq OWNED BY public.nway_acl.id;


--
-- Name: nway_base_mobile_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_base_mobile_location (
    no character varying(7) NOT NULL,
    location character varying(50),
    district_no character varying(10)
);


ALTER TABLE public.nway_base_mobile_location OWNER TO postgres;

--
-- Name: TABLE nway_base_mobile_location; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.nway_base_mobile_location IS '上海宁卫信息技术有限公司，李浩。手机归属地';


--
-- Name: COLUMN nway_base_mobile_location.no; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_base_mobile_location.no IS '手机号段';


--
-- Name: COLUMN nway_base_mobile_location.location; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_base_mobile_location.location IS '所在地';


--
-- Name: COLUMN nway_base_mobile_location.district_no; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_base_mobile_location.district_no IS '区号';


--
-- Name: nway_call_dialplan_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_call_dialplan_details_id_seq
    START WITH 73
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_call_dialplan_details_id_seq OWNER TO postgres;

--
-- Name: nway_call_dialplan_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_call_dialplan_details (
    id bigint DEFAULT nextval('public.nway_call_dialplan_details_id_seq'::regclass) NOT NULL,
    dialplan_id bigint,
    dialplan_detail_tag character varying(255),
    dialplan_detail_data text,
    dialplan_detail_inline text DEFAULT '    '::text,
    dialplan_detail_break boolean DEFAULT false,
    dialplan_detail_type_id integer,
    ring_id bigint DEFAULT 0,
    outline_gateway bigint DEFAULT 0,
    orderid integer DEFAULT 0,
    is_callout boolean DEFAULT false,
    gateway_group_id bigint DEFAULT 0,
    enable_area_route boolean DEFAULT false,
    area_district_no text,
    external_uri character varying(255) DEFAULT ''::character varying,
    is_timeplan boolean DEFAULT false,
    time_plan_id bigint DEFAULT 0,
    dialplan_detail_type_name character varying(60) DEFAULT ''::character varying
);


ALTER TABLE public.nway_call_dialplan_details OWNER TO postgres;

--
-- Name: COLUMN nway_call_dialplan_details.dialplan_detail_data; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplan_details.dialplan_detail_data IS '当为ring时，endless_playback值表示是不断循环播放ring';


--
-- Name: COLUMN nway_call_dialplan_details.ring_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplan_details.ring_id IS '如果是播放彩铃，则需要彩铃id';


--
-- Name: COLUMN nway_call_dialplan_details.outline_gateway; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplan_details.outline_gateway IS '如果有多条网关的话，则需要在gateway中配置一个ALL,则在拨号计划的时候是指定sofia/external/,就可以将全部呼出去';


--
-- Name: COLUMN nway_call_dialplan_details.is_callout; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplan_details.is_callout IS '是否呼外线，用于避免呼叫时指定路由时要用sofia/gateway或user等的';


--
-- Name: COLUMN nway_call_dialplan_details.gateway_group_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplan_details.gateway_group_id IS '网关组';


--
-- Name: COLUMN nway_call_dialplan_details.area_district_no; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplan_details.area_district_no IS '区域路由的区号，以,分隔';


--
-- Name: COLUMN nway_call_dialplan_details.external_uri; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplan_details.external_uri IS '外部操作的url,当ivr_menu_option_digits 为空时有效，自动将主叫  caller_number=xxx,dtmf=xxx,uuid=xxx  等消息发给url，等待url的返回值后执行，如hangup,挂机，playring,放音，dtmf+彩铃+按键长度  为获取按键 ；bridge为转接到分机，agent_group为转接到座席组，senddtmf:发送dtmf按键；
';


--
-- Name: COLUMN nway_call_dialplan_details.is_timeplan; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplan_details.is_timeplan IS '是否启用时间段，上午，下午上班等都可以有自己的路由';


--
-- Name: COLUMN nway_call_dialplan_details.dialplan_detail_type_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplan_details.dialplan_detail_type_name IS '可以不用Dialplan_detail_type_id了';


--
-- Name: nway_call_dialplans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_call_dialplans_id_seq
    START WITH 56
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_call_dialplans_id_seq OWNER TO postgres;

--
-- Name: nway_call_dialplans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_call_dialplans (
    id bigint DEFAULT nextval('public.nway_call_dialplans_id_seq'::regclass) NOT NULL,
    dialplan_name character varying(255),
    dialplan_context character varying(255) DEFAULT 'destination_number'::character varying,
    dialplan_number character varying(255),
    dialplan_order numeric DEFAULT 1,
    dialplan_description text,
    dialplan_enabled boolean DEFAULT true,
    dialplan_continue boolean DEFAULT false,
    is_nway_call_outline boolean DEFAULT false,
    domain_id bigint DEFAULT 1,
    use_time_plan boolean DEFAULT false,
    destination_number character varying(300) DEFAULT ''::character varying,
    source character varying(255),
    network_addr character varying(255) DEFAULT ''::character varying,
    caller_id_number character varying(300),
    node_id bigint DEFAULT 0,
    save_to_xml boolean DEFAULT false
);


ALTER TABLE public.nway_call_dialplans OWNER TO postgres;

--
-- Name: TABLE nway_call_dialplans; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.nway_call_dialplans IS '优先进入到destination_number，然后检查 source是不是为空，不空处理，再检查 network_addr进行处理，不为空处理，再检查 caller_id_number，则处理';


--
-- Name: COLUMN nway_call_dialplans.dialplan_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplans.dialplan_name IS '名称';


--
-- Name: COLUMN nway_call_dialplans.dialplan_context; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplans.dialplan_context IS '这时用于标明是default或prublic';


--
-- Name: COLUMN nway_call_dialplans.dialplan_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplans.dialplan_number IS '号码，可按正则表达式来';


--
-- Name: COLUMN nway_call_dialplans.is_nway_call_outline; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplans.is_nway_call_outline IS '是否是外呼外线的拨号计划，默认为false';


--
-- Name: COLUMN nway_call_dialplans.use_time_plan; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplans.use_time_plan IS '启用时间策略，默认不启用，如果启用，则按details中的对应的要使用时间策略的方式进行';


--
-- Name: COLUMN nway_call_dialplans.destination_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplans.destination_number IS '用于dialplan中的destination_number';


--
-- Name: COLUMN nway_call_dialplans.source; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplans.source IS '<condition field="source" expression="mod_sofia"/>等';


--
-- Name: COLUMN nway_call_dialplans.network_addr; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplans.network_addr IS '192.168.0.0/16,10.0.0.0/8   等';


--
-- Name: COLUMN nway_call_dialplans.caller_id_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplans.caller_id_number IS '以,分隔的多个号码，如 18621575908,13671947488等呼入的才走这条路由';


--
-- Name: COLUMN nway_call_dialplans.node_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplans.node_id IS '归属于哪一个节点';


--
-- Name: COLUMN nway_call_dialplans.save_to_xml; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_dialplans.save_to_xml IS '是否自动下发到freeswitch的dialplan中，使用dialplan_context来区分default,public';


--
-- Name: nway_fs_gateway_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_fs_gateway_group (
    id bigint NOT NULL,
    gateway_group_name character varying(100),
    domain_id bigint DEFAULT 0,
    profile_id bigint DEFAULT 0
);


ALTER TABLE public.nway_fs_gateway_group OWNER TO postgres;

--
-- Name: nway_call_gateway_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_call_gateway_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_call_gateway_group_id_seq OWNER TO postgres;

--
-- Name: nway_call_gateway_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_call_gateway_group_id_seq OWNED BY public.nway_fs_gateway_group.id;


--
-- Name: nway_fs_gateway_group_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_fs_gateway_group_map (
    id bigint NOT NULL,
    gateway_id bigint,
    gateway_group_id bigint
);


ALTER TABLE public.nway_fs_gateway_group_map OWNER TO postgres;

--
-- Name: nway_call_gateway_group_map_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_call_gateway_group_map_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_call_gateway_group_map_id_seq OWNER TO postgres;

--
-- Name: nway_call_gateway_group_map_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_call_gateway_group_map_id_seq OWNED BY public.nway_fs_gateway_group_map.id;


--
-- Name: nway_call_ivr_menu_options_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_call_ivr_menu_options_id_seq
    START WITH 52
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_call_ivr_menu_options_id_seq OWNER TO postgres;

--
-- Name: nway_call_ivr_menu_options; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_call_ivr_menu_options (
    id bigint DEFAULT nextval('public.nway_call_ivr_menu_options_id_seq'::regclass) NOT NULL,
    ivr_menu_id bigint,
    ivr_menu_option_digits character varying(50),
    ivr_menu_option_param character varying(1000),
    ivr_menu_option_order integer DEFAULT 0,
    ivr_menu_option_description text,
    ivr_menu_option_action_id integer,
    ring_id bigint DEFAULT 0,
    is_callout boolean DEFAULT false,
    gateway_id bigint DEFAULT 0,
    gateway_group_id bigint DEFAULT 0,
    enable_area_route boolean DEFAULT false,
    area_district_no text,
    external_uri character varying(255) DEFAULT ''::character varying,
    is_time_plan boolean DEFAULT false,
    time_plan_id bigint DEFAULT 0,
    ivr_menu_option_action character varying(50) DEFAULT ''::character varying
);


ALTER TABLE public.nway_call_ivr_menu_options OWNER TO postgres;

--
-- Name: COLUMN nway_call_ivr_menu_options.external_uri; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menu_options.external_uri IS '外部操作的url,当ivr_menu_option_digits 为空时有效，自动将主叫  caller_number=xxx,dtmf=xxx,uuid=xxx  等消息发给url，等待url的返回值后执行，如hangup,挂机，playring,放音，dtmf+彩铃+按键长度  为获取按键 ；bridge为转接到分机，agent_group为转接到座席组，senddtmf:发送dtmf按键；';


--
-- Name: COLUMN nway_call_ivr_menu_options.is_time_plan; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menu_options.is_time_plan IS '是否使用时间策略';


--
-- Name: COLUMN nway_call_ivr_menu_options.time_plan_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menu_options.time_plan_id IS 'time plan表中的id';


--
-- Name: COLUMN nway_call_ivr_menu_options.ivr_menu_option_action; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menu_options.ivr_menu_option_action IS '"menu-exit", SWITCH_IVR_ACTION_DIE}, {
	"menu-sub", SWITCH_IVR_ACTION_EXECMENU}, {
	"menu-exec-app", SWITCH_IVR_ACTION_EXECAPP}, {
	"menu-play-sound", SWITCH_IVR_ACTION_PLAYSOUND}, {
	"menu-back", SWITCH_IVR_ACTION_BACK}, {
	"menu-top", SWITCH_IVR_ACTION_TOMAIN}, {';


--
-- Name: nway_call_ivr_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_call_ivr_menus_id_seq
    START WITH 20
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_call_ivr_menus_id_seq OWNER TO postgres;

--
-- Name: nway_call_ivr_menus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_call_ivr_menus (
    id bigint DEFAULT nextval('public.nway_call_ivr_menus_id_seq'::regclass) NOT NULL,
    ivr_menu_name character varying(200) NOT NULL,
    ivr_menu_extension text NOT NULL,
    ivr_menu_confirm_macro character varying(200) DEFAULT ''::character varying,
    ivr_menu_confirm_key character varying(200) DEFAULT ''::character varying,
    ivr_menu_confirm_attempts integer DEFAULT 3,
    ivr_menu_timeout integer DEFAULT 60,
    ivr_menu_exit_data text DEFAULT '   '::text,
    ivr_menu_inter_digit_timeout integer DEFAULT 10,
    ivr_menu_max_failures integer DEFAULT 3,
    ivr_menu_max_timeouts integer DEFAULT 120,
    ivr_menu_digit_len integer DEFAULT 1,
    ivr_menu_direct_dial character varying(200) DEFAULT ''::character varying,
    ivr_menu_cid_prefix character varying(200) DEFAULT ''::character varying,
    ivr_menu_description text,
    ivr_menu_nway_call_crycle_order integer DEFAULT 0,
    ivr_menu_enabled boolean DEFAULT true,
    ivr_menu_nway_call_order_id bigint DEFAULT 0,
    ivr_menu_greet_long_id bigint DEFAULT 0,
    ivr_menu_greet_short_id bigint DEFAULT 0,
    ivr_menu_invalid_sound_id bigint DEFAULT 0,
    ivr_menu_exit_sound_id bigint DEFAULT 0,
    ivr_menu_ringback_id bigint DEFAULT 0,
    ivr_menu_exit_app_id integer DEFAULT 0,
    ivr_menu_parent_id bigint DEFAULT 0,
    node_id bigint DEFAULT 0,
    domain_id bigint DEFAULT 0
);


ALTER TABLE public.nway_call_ivr_menus OWNER TO postgres;

--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_name IS '名称';


--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_extension; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_extension IS '短号，每个ivr都会有一个唯一的短号';


--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_confirm_macro; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_confirm_macro IS '确认宏';


--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_confirm_key; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_confirm_key IS '确认键';


--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_confirm_attempts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_confirm_attempts IS '尝试次数';


--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_timeout; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_timeout IS '超时秒数';


--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_inter_digit_timeout; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_inter_digit_timeout IS '中间不按键时的超时时间';


--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_max_failures; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_max_failures IS '输错ivr的最大次数';


--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_max_timeouts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_max_timeouts IS 'ivr最大超时次数';


--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_digit_len; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_digit_len IS '数字按键最大长度';


--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_description IS '说明';


--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_nway_call_crycle_order; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_nway_call_crycle_order IS '针对属于循环呼叫的，实时记录当前呼叫的子节点的order';


--
-- Name: COLUMN nway_call_ivr_menus.ivr_menu_parent_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_parent_id IS '父节点，用于多层ivr中';


--
-- Name: nway_call_operation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_call_operation (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    category character varying(50) DEFAULT 'dialplan'::character varying
);


ALTER TABLE public.nway_call_operation OWNER TO postgres;

--
-- Name: COLUMN nway_call_operation.category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_operation.category IS 'dialplan或ivrmenu';


--
-- Name: nway_call_operation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_call_operation_id_seq
    START WITH 7
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_call_operation_id_seq OWNER TO postgres;

--
-- Name: nway_call_pg_cdr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_call_pg_cdr_id_seq
    START WITH 1525182
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_call_pg_cdr_id_seq OWNER TO postgres;

--
-- Name: nway_call_pg_cdr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_call_pg_cdr (
    id integer DEFAULT nextval('public.nway_call_pg_cdr_id_seq'::regclass) NOT NULL,
    local_ip_v4 character(16),
    caller_id_name character(50) DEFAULT ' '::bpchar,
    caller_id_number character(50),
    outbound_caller_id_number character(50) DEFAULT ' '::bpchar,
    destination_number character(50) DEFAULT ' '::bpchar,
    context character(50) DEFAULT ' '::bpchar,
    start_stamp timestamp without time zone,
    answer_stamp timestamp without time zone,
    end_stamp timestamp without time zone,
    duration integer DEFAULT 0,
    billsec integer DEFAULT 0,
    hangup_cause character(30) DEFAULT ' '::bpchar,
    uuid character(50) DEFAULT ' '::bpchar,
    bleg_uuid character(50) DEFAULT ' '::bpchar,
    accountcode character(50) DEFAULT ' '::bpchar,
    read_codec character(10) DEFAULT ' '::bpchar,
    write_codec character(10) DEFAULT ' '::bpchar,
    record_file character varying(255) DEFAULT ' '::character varying,
    direction character varying(50) DEFAULT ' '::character varying,
    sip_hangup_disposition character varying(50),
    origination_uuid character varying(100),
    sip_gateway_name character varying(50),
    sip_term_status character varying(50) DEFAULT ''::character varying,
    sip_term_cause character varying(50) DEFAULT ''::character varying,
    dialplan_id bigint DEFAULT 0,
    da_type character varying(50) DEFAULT ' '::character varying,
    domain_id bigint DEFAULT 1,
    aleg_uuid character varying(60) DEFAULT ''::character varying
);


ALTER TABLE public.nway_call_pg_cdr OWNER TO postgres;

--
-- Name: COLUMN nway_call_pg_cdr.dialplan_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_pg_cdr.dialplan_id IS '路由id';


--
-- Name: nway_call_rings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_call_rings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_call_rings_id_seq OWNER TO postgres;

--
-- Name: nway_call_rings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_call_rings (
    id bigint DEFAULT nextval('public.nway_call_rings_id_seq'::regclass) NOT NULL,
    ring_name character varying(200),
    ring_path character varying(255),
    ring_description text,
    ring_category bigint,
    node_id bigint,
    ring_fullpath character varying(255),
    domain_id bigint,
    local_path character varying(255)
);


ALTER TABLE public.nway_call_rings OWNER TO postgres;

--
-- Name: COLUMN nway_call_rings.ring_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_rings.ring_category IS '彩铃的类型，如ivr,voicemail,等等
';


--
-- Name: COLUMN nway_call_rings.local_path; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_call_rings.local_path IS 'web本地缓存路径';


--
-- Name: nway_ext_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_ext_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_ext_group_id_seq OWNER TO postgres;

--
-- Name: nway_ext_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_ext_group (
    id bigint DEFAULT nextval('public.nway_ext_group_id_seq'::regclass) NOT NULL,
    group_name character varying(100),
    group_number character varying(50),
    current_ext_number character varying(50),
    domain_id bigint DEFAULT 1,
    queue_mode integer DEFAULT 0
);


ALTER TABLE public.nway_ext_group OWNER TO postgres;

--
-- Name: TABLE nway_ext_group; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.nway_ext_group IS '分机座席分组，面向业务';


--
-- Name: COLUMN nway_ext_group.group_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_ext_group.group_name IS '组或座席组名';


--
-- Name: COLUMN nway_ext_group.group_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_ext_group.group_number IS '座席组短号';


--
-- Name: COLUMN nway_ext_group.current_ext_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_ext_group.current_ext_number IS '当前组里接听时找到的分机，如果找不到，则再从头开始';


--
-- Name: COLUMN nway_ext_group.queue_mode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_ext_group.queue_mode IS '排队模式,0,顺序；1,随机; 2,循环; 3,记忆顺序; 4,记忆随机；5，记忆循环';


--
-- Name: nway_ext_group_map_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_ext_group_map_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_ext_group_map_id_seq OWNER TO postgres;

--
-- Name: nway_ext_group_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_ext_group_map (
    id bigint DEFAULT nextval('public.nway_ext_group_map_id_seq'::regclass) NOT NULL,
    ext_group_id bigint,
    ext_group_number character varying(50),
    ext character varying(50)
);


ALTER TABLE public.nway_ext_group_map OWNER TO postgres;

--
-- Name: COLUMN nway_ext_group_map.ext_group_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_ext_group_map.ext_group_id IS '分机组id';


--
-- Name: COLUMN nway_ext_group_map.ext_group_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_ext_group_map.ext_group_number IS '座席组号码';


--
-- Name: COLUMN nway_ext_group_map.ext; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_ext_group_map.ext IS '分机';


--
-- Name: nway_extension_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_extension_id_seq
    START WITH 9063
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_extension_id_seq OWNER TO postgres;

--
-- Name: nway_extension; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_extension (
    id bigint DEFAULT nextval('public.nway_extension_id_seq'::regclass) NOT NULL,
    extension_name character varying(50) NOT NULL,
    extension_number character varying(50) NOT NULL,
    callout_number character varying(50) DEFAULT ''::character varying,
    extension_type bigint DEFAULT 0,
    group_id bigint DEFAULT 0,
    extension_pswd character varying(130) DEFAULT 'nway.com.cn'::character varying,
    extension_login_state character varying(50) DEFAULT 'success'::character varying,
    extension_reg_state character varying(50) DEFAULT ''::character varying,
    callout_gateway bigint DEFAULT 0,
    is_allow_callout boolean DEFAULT true,
    is_record boolean DEFAULT false,
    answer_without_state boolean DEFAULT false,
    say_job_number boolean DEFAULT false,
    job_number character varying(40) DEFAULT ''::character varying,
    reg_state character varying(30) DEFAULT 'unreg'::character varying,
    agent_state character varying(30) DEFAULT 'down'::character varying,
    agent_status character varying(30) DEFAULT 'idle'::character varying,
    call_state character varying(30) DEFAULT 'ready'::character varying,
    lastupdatetime character varying(30),
    core_uuid character varying(300) DEFAULT ''::character varying,
    use_custom_value boolean DEFAULT false,
    client_ip character varying(50) DEFAULT '127.0.0.1'::character varying,
    is_register boolean DEFAULT false,
    is_select boolean DEFAULT false,
    locked boolean DEFAULT false,
    login_password character varying(50) DEFAULT 'nway.com.cn'::character varying,
    last_reg_time timestamp without time zone DEFAULT now(),
    dnd boolean DEFAULT false,
    unconditional_forward character varying(30) DEFAULT ''::character varying,
    call_level integer DEFAULT 0,
    follow_me character varying(30) DEFAULT ''::character varying,
    last_hangup_time timestamp without time zone DEFAULT now(),
    last_state_change_time timestamp without time zone DEFAULT now(),
    is_follow_me_callout boolean DEFAULT false,
    is_unconditional_forward_callout boolean DEFAULT false,
    use_video boolean DEFAULT false,
    server_ip character varying(100) DEFAULT ''::character varying,
    domain_id bigint DEFAULT 0
);


ALTER TABLE public.nway_extension OWNER TO postgres;

--
-- Name: COLUMN nway_extension.extension_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.extension_name IS '分机名称';


--
-- Name: COLUMN nway_extension.extension_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.extension_number IS '分机号码';


--
-- Name: COLUMN nway_extension.callout_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.callout_number IS '外呼时的号码';


--
-- Name: COLUMN nway_extension.extension_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.extension_type IS '分机类型';


--
-- Name: COLUMN nway_extension.extension_reg_state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.extension_reg_state IS '注册状态';


--
-- Name: COLUMN nway_extension.callout_gateway; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.callout_gateway IS '出局网关';


--
-- Name: COLUMN nway_extension.is_record; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.is_record IS '是否录音';


--
-- Name: COLUMN nway_extension.answer_without_state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.answer_without_state IS '在不上线，不置闲的情况下就可以进行应答，默认是必须由客户端上线等';


--
-- Name: COLUMN nway_extension.say_job_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.say_job_number IS '是否要报工号，不管是与否，当answerwithoutstate为true时，它都无效，报工号时，在本工号接听时，播放工号语音';


--
-- Name: COLUMN nway_extension.job_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.job_number IS '工号，最大为40个字符串';


--
-- Name: COLUMN nway_extension.reg_state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.reg_state IS 'REGED ,UNREG  ,分机发register的状态记录';


--
-- Name: COLUMN nway_extension.agent_state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.agent_state IS 'up,down,座席上下线，可作为考勤的一部分';


--
-- Name: COLUMN nway_extension.agent_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.agent_status IS 'idle,busy,座席忙闲，如上厕所，临时开会，不能用下线';


--
-- Name: COLUMN nway_extension.call_state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.call_state IS 'READY,RING,TALKING,IVR';


--
-- Name: COLUMN nway_extension.use_custom_value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.use_custom_value IS '是否要客户满意度评价';


--
-- Name: COLUMN nway_extension.client_ip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.client_ip IS '客户端 ip，用于mircosip自动获取帐号和密码';


--
-- Name: COLUMN nway_extension.is_select; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.is_select IS '是否被网关组选中';


--
-- Name: COLUMN nway_extension.locked; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.locked IS '是否被锁定，锁定对于外呼或呼入来说不应使用';


--
-- Name: COLUMN nway_extension.dnd; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.dnd IS '免打扰';


--
-- Name: COLUMN nway_extension.unconditional_forward; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.unconditional_forward IS '无条件转移，有号码就直接转到这个号码，如果为空就转分机';


--
-- Name: COLUMN nway_extension.call_level; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.call_level IS '0内线，1市内，2国内，3国际，4禁呼';


--
-- Name: COLUMN nway_extension.last_hangup_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.last_hangup_time IS '最后挂机时间，当使用typing修改call_state时，必须要重置这项为now()';


--
-- Name: COLUMN nway_extension.server_ip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_extension.server_ip IS '通过哪台服务器注册的，或者说注册在哪台服务器上的';


--
-- Name: nway_extension_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_extension_type_id_seq
    START WITH 7
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_extension_type_id_seq OWNER TO postgres;

--
-- Name: nway_extension_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_extension_type (
    id bigint DEFAULT nextval('public.nway_extension_type_id_seq'::regclass) NOT NULL,
    type_name character varying(50)
);


ALTER TABLE public.nway_extension_type OWNER TO postgres;

--
-- Name: nway_fs_domains; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_fs_domains (
    id bigint NOT NULL,
    domain_name character varying(255) DEFAULT ''::character varying NOT NULL,
    domain_desc character varying(500) DEFAULT ''::character varying,
    allow_ip character varying(1000) DEFAULT '0.0.0.0'::character varying
);


ALTER TABLE public.nway_fs_domains OWNER TO postgres;

--
-- Name: COLUMN nway_fs_domains.allow_ip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_domains.allow_ip IS '允许的ip范围以,分隔';


--
-- Name: nway_fs_domains_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_fs_domains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_fs_domains_id_seq OWNER TO postgres;

--
-- Name: nway_fs_domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_fs_domains_id_seq OWNED BY public.nway_fs_domains.id;


--
-- Name: nway_fs_gateway_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_fs_gateway_details (
    gateway_id bigint,
    gateway_key character varying(300),
    gateway_key_desc text,
    gateway_value character varying(300),
    gateway_value_option character varying(300),
    enable boolean DEFAULT true,
    id bigint NOT NULL
);


ALTER TABLE public.nway_fs_gateway_details OWNER TO postgres;

--
-- Name: COLUMN nway_fs_gateway_details.gateway_key; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_gateway_details.gateway_key IS 'xml中的配置对中的key,不可为中文';


--
-- Name: COLUMN nway_fs_gateway_details.gateway_key_desc; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_gateway_details.gateway_key_desc IS 'key的描述，可为中文';


--
-- Name: COLUMN nway_fs_gateway_details.gateway_value_option; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_gateway_details.gateway_value_option IS 'value的可选项';


--
-- Name: nway_fs_gateway_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_fs_gateway_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_fs_gateway_details_id_seq OWNER TO postgres;

--
-- Name: nway_fs_gateway_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_fs_gateway_details_id_seq OWNED BY public.nway_fs_gateway_details.id;


--
-- Name: nway_fs_gateways; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_fs_gateways (
    id bigint NOT NULL,
    profile_id bigint,
    gateway_name character varying(300) DEFAULT ''::character varying,
    gateway_desc text DEFAULT ''::text,
    enable boolean DEFAULT true,
    domain_id bigint DEFAULT 0,
    max_concurrent bigint DEFAULT 30,
    concurrent integer DEFAULT 0
);


ALTER TABLE public.nway_fs_gateways OWNER TO postgres;

--
-- Name: COLUMN nway_fs_gateways.gateway_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_gateways.gateway_name IS '不可中文 ';


--
-- Name: COLUMN nway_fs_gateways.gateway_desc; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_gateways.gateway_desc IS '备注，可以使用中文';


--
-- Name: COLUMN nway_fs_gateways.concurrent; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_gateways.concurrent IS '当前呼入呼出的并发数';


--
-- Name: nway_fs_gateways_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_fs_gateways_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_fs_gateways_id_seq OWNER TO postgres;

--
-- Name: nway_fs_gateways_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_fs_gateways_id_seq OWNED BY public.nway_fs_gateways.id;


--
-- Name: nway_fs_heartbeat_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_fs_heartbeat_history (
    id bigint NOT NULL,
    node_ip character varying(200),
    sip_result character varying(200) DEFAULT 'successed'::character varying,
    check_time timestamp without time zone DEFAULT now(),
    cpu_used character varying(50) DEFAULT ''::character varying,
    mem_used character varying(50) DEFAULT ''::character varying,
    disk_used character varying(50) DEFAULT ''::character varying,
    network_used character varying(50) DEFAULT ''::character varying
);


ALTER TABLE public.nway_fs_heartbeat_history OWNER TO postgres;

--
-- Name: TABLE nway_fs_heartbeat_history; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.nway_fs_heartbeat_history IS '心跳检测的日志';


--
-- Name: COLUMN nway_fs_heartbeat_history.node_ip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_heartbeat_history.node_ip IS '节点ip';


--
-- Name: COLUMN nway_fs_heartbeat_history.sip_result; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_heartbeat_history.sip_result IS '心跳返回结果';


--
-- Name: COLUMN nway_fs_heartbeat_history.check_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_heartbeat_history.check_time IS '检查心跳时间';


--
-- Name: COLUMN nway_fs_heartbeat_history.cpu_used; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_heartbeat_history.cpu_used IS 'cpu使用百分比';


--
-- Name: nway_fs_heartbeat_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_fs_heartbeat_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_fs_heartbeat_history_id_seq OWNER TO postgres;

--
-- Name: nway_fs_heartbeat_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_fs_heartbeat_history_id_seq OWNED BY public.nway_fs_heartbeat_history.id;


--
-- Name: nway_fs_node; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_fs_node (
    id bigint NOT NULL,
    node_name character varying(255) NOT NULL,
    operate_ip character varying(200) DEFAULT '127.0.0.1'::character varying NOT NULL,
    operate_port character varying(100) DEFAULT '8021'::character varying NOT NULL,
    fs_esl_ip character varying(200) DEFAULT '127.0.0.1'::character varying NOT NULL,
    fs_esl_port character varying(100) DEFAULT '8021'::character varying NOT NULL,
    meminfo text,
    external_ip character varying(200) DEFAULT '127.0.0.1'::character varying NOT NULL,
    fs_esl_secret character varying(50) DEFAULT 'ClueCon'::character varying NOT NULL,
    operate_secret character varying(50) DEFAULT 'Nway123!'::character varying NOT NULL,
    alow_system_call boolean DEFAULT true NOT NULL,
    heartbeat_port character varying(100) DEFAULT '5080'::character varying NOT NULL,
    enable boolean DEFAULT true NOT NULL,
    request_url character varying(255) DEFAULT ''::character varying,
    extension_dialplan character varying(300) DEFAULT '127.0.0.1:8096'::character varying,
    public_dialplan character varying(300) DEFAULT '127.0.0.1:8097'::character varying,
    cdr_dbstring character varying(300) DEFAULT 'user=postgres dbname=nwaycc password=Nway2017 host=127.0.0.1 port=5432 sslmode=disable'::character varying
);


ALTER TABLE public.nway_fs_node OWNER TO postgres;

--
-- Name: TABLE nway_fs_node; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.nway_fs_node IS 'fs的节点信息';


--
-- Name: COLUMN nway_fs_node.node_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.node_name IS '节点名称';


--
-- Name: COLUMN nway_fs_node.operate_ip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.operate_ip IS '操作ip,实际ip，vip不能算，这里用于一些常用的配置';


--
-- Name: COLUMN nway_fs_node.operate_port; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.operate_port IS '操作端口';


--
-- Name: COLUMN nway_fs_node.fs_esl_ip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.fs_esl_ip IS 'esl ip';


--
-- Name: COLUMN nway_fs_node.fs_esl_port; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.fs_esl_port IS 'fs_esl_port';


--
-- Name: COLUMN nway_fs_node.meminfo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.meminfo IS '备注信息';


--
-- Name: COLUMN nway_fs_node.external_ip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.external_ip IS '通过路由器等映射 出去的ip,如果是内网中使用，则不需要管这个ip';


--
-- Name: COLUMN nway_fs_node.fs_esl_secret; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.fs_esl_secret IS '密码';


--
-- Name: COLUMN nway_fs_node.operate_secret; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.operate_secret IS '强制修改某些东西必须要连数据库，同时要认证';


--
-- Name: COLUMN nway_fs_node.alow_system_call; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.alow_system_call IS '是否允许系统调用，如以root运行，则可以调用所有root级的命令';


--
-- Name: COLUMN nway_fs_node.heartbeat_port; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.heartbeat_port IS '用于检测sip心跳的端口，由管理端向具体的节点发起，同时记录该节点返回值';


--
-- Name: COLUMN nway_fs_node.enable; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.enable IS '是否启用该节点';


--
-- Name: COLUMN nway_fs_node.extension_dialplan; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.extension_dialplan IS '分机内的路由以及分机对外的路由';


--
-- Name: COLUMN nway_fs_node.public_dialplan; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.public_dialplan IS '外线呼入或作为其它ippbx的gateway时的路由';


--
-- Name: COLUMN nway_fs_node.cdr_dbstring; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node.cdr_dbstring IS '存储cdr原始记录的数据库链接，用于cdr_pg_csv.xml中用';


--
-- Name: nway_fs_node_global_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_fs_node_global_details (
    id bigint NOT NULL,
    node_id bigint,
    category character varying(200) DEFAULT 'global'::character varying,
    node_key character varying(50) DEFAULT ' '::character varying,
    node_value character varying(50),
    node_desc character varying(500) DEFAULT ' '::character varying
);


ALTER TABLE public.nway_fs_node_global_details OWNER TO postgres;

--
-- Name: TABLE nway_fs_node_global_details; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.nway_fs_node_global_details IS '用于管理switch.conf.xml中的一些数据，以及vars.xml中的一些数据维护';


--
-- Name: COLUMN nway_fs_node_global_details.category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_node_global_details.category IS 'global为vars.xml中变量，switch 为switch.conf.xml中变量';


--
-- Name: nway_fs_node_global_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_fs_node_global_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_fs_node_global_details_id_seq OWNER TO postgres;

--
-- Name: nway_fs_node_global_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_fs_node_global_details_id_seq OWNED BY public.nway_fs_node_global_details.id;


--
-- Name: nway_fs_node_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_fs_node_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_fs_node_id_seq OWNER TO postgres;

--
-- Name: nway_fs_node_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_fs_node_id_seq OWNED BY public.nway_fs_node.id;


--
-- Name: nway_fs_profile_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_fs_profile_details (
    id bigint NOT NULL,
    profile_id bigint DEFAULT 0,
    profile_key character varying(300) DEFAULT ''::character varying,
    profile_value character varying(300) DEFAULT ''::character varying,
    enable boolean DEFAULT true,
    profile_value_options character varying(300) DEFAULT ''::character varying,
    profile_key_desc text
);


ALTER TABLE public.nway_fs_profile_details OWNER TO postgres;

--
-- Name: COLUMN nway_fs_profile_details.profile_key; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_profile_details.profile_key IS '在xml中的key value配置对中的key';


--
-- Name: nway_fs_profile_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_fs_profile_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_fs_profile_details_id_seq OWNER TO postgres;

--
-- Name: nway_fs_profile_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_fs_profile_details_id_seq OWNED BY public.nway_fs_profile_details.id;


--
-- Name: nway_fs_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_fs_profiles (
    id bigint NOT NULL,
    node_id bigint DEFAULT 0,
    profile_name character varying(255) DEFAULT ''::character varying,
    profile_desc text DEFAULT ''::text,
    enable boolean DEFAULT true,
    is_internal boolean DEFAULT true,
    load_internal_user_file boolean DEFAULT true
);


ALTER TABLE public.nway_fs_profiles OWNER TO postgres;

--
-- Name: COLUMN nway_fs_profiles.profile_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_profiles.profile_name IS '名称，只能用英文';


--
-- Name: COLUMN nway_fs_profiles.profile_desc; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_profiles.profile_desc IS 'profile说明，可以有中文 ';


--
-- Name: COLUMN nway_fs_profiles.is_internal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_profiles.is_internal IS '是否为internal的profile，如果是，则没有gateway,但是会有user,如果为否，则会有gateway,没有user';


--
-- Name: COLUMN nway_fs_profiles.load_internal_user_file; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_fs_profiles.load_internal_user_file IS '当is_internal为true时，此值才会有效，当为true时，将把user按文件一次性加载，如果禁某个分机，则需要重新scan internal profile，否则使用nway_pbx_auth注册';


--
-- Name: nway_fs_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_fs_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_fs_profiles_id_seq OWNER TO postgres;

--
-- Name: nway_fs_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_fs_profiles_id_seq OWNED BY public.nway_fs_profiles.id;


--
-- Name: nway_manager_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_manager_users (
    id bigint NOT NULL,
    domain_id bigint DEFAULT 0,
    username character varying(50),
    salt character varying(50),
    password character varying(50),
    create_time timestamp without time zone DEFAULT now(),
    last_login_time timestamp without time zone DEFAULT now(),
    login_times bigint DEFAULT 0,
    real_name character varying(50) DEFAULT ' '::character varying,
    mobile character varying(50) DEFAULT ' '::character varying
);


ALTER TABLE public.nway_manager_users OWNER TO postgres;

--
-- Name: TABLE nway_manager_users; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.nway_manager_users IS '用于管理员的帐户';


--
-- Name: COLUMN nway_manager_users.domain_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_manager_users.domain_id IS '创建了domain的话，是domain管理员，如果是0，则是全局系统管理员';


--
-- Name: COLUMN nway_manager_users.login_times; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_manager_users.login_times IS '登录的次数';


--
-- Name: COLUMN nway_manager_users.real_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_manager_users.real_name IS '用户名，可为中文';


--
-- Name: COLUMN nway_manager_users.mobile; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_manager_users.mobile IS '管理员手机';


--
-- Name: nway_manager_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_manager_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_manager_users_id_seq OWNER TO postgres;

--
-- Name: nway_manager_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_manager_users_id_seq OWNED BY public.nway_manager_users.id;


--
-- Name: nway_time_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nway_time_plans (
    id bigint NOT NULL,
    week_time character varying(50),
    time_name character varying(255),
    disable_days text,
    start_time character varying(50),
    stop_time character varying(50)
);


ALTER TABLE public.nway_time_plans OWNER TO postgres;

--
-- Name: TABLE nway_time_plans; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.nway_time_plans IS '时间策略，用于工作时间和休假时间，不同组可以不同的时间策略';


--
-- Name: COLUMN nway_time_plans.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_time_plans.id IS 'id';


--
-- Name: COLUMN nway_time_plans.week_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_time_plans.week_time IS '1-7的工作日，用,分开';


--
-- Name: COLUMN nway_time_plans.time_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_time_plans.time_name IS '对这个时间策略取个名';


--
-- Name: COLUMN nway_time_plans.disable_days; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_time_plans.disable_days IS '禁止日期，如 2022-03-22, 2022-05-01,主要用于节假日';


--
-- Name: COLUMN nway_time_plans.start_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_time_plans.start_time IS '开始时间，如 09:00:00 ';


--
-- Name: COLUMN nway_time_plans.stop_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.nway_time_plans.stop_time IS '结束时间，如18:00:00';


--
-- Name: nway_time_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nway_time_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nway_time_plans_id_seq OWNER TO postgres;

--
-- Name: nway_time_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nway_time_plans_id_seq OWNED BY public.nway_time_plans.id;


--
-- Name: t_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t_role (
    id bigint NOT NULL,
    role_name character varying(50),
    description character varying(200),
    create_time timestamp without time zone,
    updatetime timestamp without time zone
);


ALTER TABLE public.t_role OWNER TO postgres;

--
-- Name: t_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.t_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_role_id_seq OWNER TO postgres;

--
-- Name: t_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.t_role_id_seq OWNED BY public.t_role.id;


--
-- Name: t_role_perm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t_role_perm (
    id bigint NOT NULL,
    role_id bigint,
    perm_id bigint
);


ALTER TABLE public.t_role_perm OWNER TO postgres;

--
-- Name: t_role_perm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.t_role_perm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_role_perm_id_seq OWNER TO postgres;

--
-- Name: t_role_perm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.t_role_perm_id_seq OWNED BY public.t_role_perm.id;


--
-- Name: t_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t_user (
    id bigint NOT NULL,
    user_name character varying(50) NOT NULL,
    password character varying(50) DEFAULT '123456'::character varying NOT NULL,
    salt character varying(40),
    status integer DEFAULT 0,
    create_time timestamp without time zone,
    last_login timestamp without time zone,
    update_time timestamp without time zone,
    email character varying(60),
    last_ip character varying(60),
    sex integer DEFAULT 0
);


ALTER TABLE public.t_user OWNER TO postgres;

--
-- Name: t_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.t_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_user_id_seq OWNER TO postgres;

--
-- Name: t_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.t_user_id_seq OWNED BY public.t_user.id;


--
-- Name: t_user_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t_user_role (
    id bigint NOT NULL,
    user_id bigint,
    role_id bigint
);


ALTER TABLE public.t_user_role OWNER TO postgres;

--
-- Name: t_user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.t_user_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_user_role_id_seq OWNER TO postgres;

--
-- Name: t_user_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.t_user_role_id_seq OWNED BY public.t_user_role.id;


--
-- Name: wx_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wx_user (
    user_name text,
    password text
);


ALTER TABLE public.wx_user OWNER TO postgres;

--
-- Name: nway_acl id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_acl ALTER COLUMN id SET DEFAULT nextval('public.nway_acl_id_seq'::regclass);


--
-- Name: nway_acl_detail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_acl_detail ALTER COLUMN id SET DEFAULT nextval('public.nway_acl_detail_id_seq'::regclass);


--
-- Name: nway_fs_domains id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_domains ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_domains_id_seq'::regclass);


--
-- Name: nway_fs_gateway_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_gateway_details ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_gateway_details_id_seq'::regclass);


--
-- Name: nway_fs_gateway_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_gateway_group ALTER COLUMN id SET DEFAULT nextval('public.nway_call_gateway_group_id_seq'::regclass);


--
-- Name: nway_fs_gateway_group_map id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_gateway_group_map ALTER COLUMN id SET DEFAULT nextval('public.nway_call_gateway_group_map_id_seq'::regclass);


--
-- Name: nway_fs_gateways id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_gateways ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_gateways_id_seq'::regclass);


--
-- Name: nway_fs_heartbeat_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_heartbeat_history ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_heartbeat_history_id_seq'::regclass);


--
-- Name: nway_fs_node id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_node ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_node_id_seq'::regclass);


--
-- Name: nway_fs_node_global_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_node_global_details ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_node_global_details_id_seq'::regclass);


--
-- Name: nway_fs_profile_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_profile_details ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_profile_details_id_seq'::regclass);


--
-- Name: nway_fs_profiles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_profiles ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_profiles_id_seq'::regclass);


--
-- Name: nway_manager_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_manager_users ALTER COLUMN id SET DEFAULT nextval('public.nway_manager_users_id_seq'::regclass);


--
-- Name: nway_time_plans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_time_plans ALTER COLUMN id SET DEFAULT nextval('public.nway_time_plans_id_seq'::regclass);


--
-- Name: t_role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_role ALTER COLUMN id SET DEFAULT nextval('public.t_role_id_seq'::regclass);


--
-- Name: t_role_perm id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_role_perm ALTER COLUMN id SET DEFAULT nextval('public.t_role_perm_id_seq'::regclass);


--
-- Name: t_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_user ALTER COLUMN id SET DEFAULT nextval('public.t_user_id_seq'::regclass);


--
-- Name: t_user_role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_user_role ALTER COLUMN id SET DEFAULT nextval('public.t_user_role_id_seq'::regclass);


--
-- Data for Name: call_blacklist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.call_blacklist (id, category, call_number, dest_number, group_number, domain_id, expire_time) FROM stdin;
\.


--
-- Data for Name: nway_acl; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_acl (id, node_id, acl_name, default_type) FROM stdin;
\.


--
-- Data for Name: nway_acl_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_acl_detail (id, acl_type, is_domain, acl_value) FROM stdin;
\.


--
-- Data for Name: nway_base_mobile_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_base_mobile_location (no, location, district_no) FROM stdin;
\.


--
-- Data for Name: nway_call_dialplan_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_call_dialplan_details (id, dialplan_id, dialplan_detail_tag, dialplan_detail_data, dialplan_detail_inline, dialplan_detail_break, dialplan_detail_type_id, ring_id, outline_gateway, orderid, is_callout, gateway_group_id, enable_area_route, area_district_no, external_uri, is_timeplan, time_plan_id, dialplan_detail_type_name) FROM stdin;
74	0				f	0	0	0	1	f	0	f			f	0	
75	0				f	0	0	0	1	f	0	f			f	0	
78	1002	呼转	user/$0		f	0	0	0	1	f	0	f			f	0	bridge
79	56	放音	/usr/local/freeswitch/sounds/uploads/test/2022_04_26/b3b33a69-1a0a-421f-a772-dc6e56f21f02.wav		f	0	0	0	2	f	0	f			f	0	playback
77	56	呼转	/usr/local/freeswitch/sounds/uploads/test/2022_04_26/b3b33a69-1a0a-421f-a772-dc6e56f21f02.wav		f	0	0	0	1	f	0	f			f	0	playback
\.


--
-- Data for Name: nway_call_dialplans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_call_dialplans (id, dialplan_name, dialplan_context, dialplan_number, dialplan_order, dialplan_description, dialplan_enabled, dialplan_continue, is_nway_call_outline, domain_id, use_time_plan, destination_number, source, network_addr, caller_id_number, node_id, save_to_xml) FROM stdin;
56	local_call	public		1		t	f	f	0	f	^10[01][0-9]$				8	t
1002	public_call	default		2		t	f	f	0	f	^10[01][0-9]$				8	t
\.


--
-- Data for Name: nway_call_ivr_menu_options; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_call_ivr_menu_options (id, ivr_menu_id, ivr_menu_option_digits, ivr_menu_option_param, ivr_menu_option_order, ivr_menu_option_description, ivr_menu_option_action_id, ring_id, is_callout, gateway_id, gateway_group_id, enable_area_route, area_district_no, external_uri, is_time_plan, time_plan_id, ivr_menu_option_action) FROM stdin;
52	0	0	bridge user/1000	0		0	0	f	0	0	f			f	0	menu-exec-app
54	21	1	transfer 1234*256 enum	0		0	0	f	0	0	f			f	0	menu-exec-app
55	20	1	bridge user/1000	0		0	0	f	0	0	f			f	0	menu-exec-app
56	20	3	ivr-1	0		0	0	f	0	0	f			f	0	menu-sub
\.


--
-- Data for Name: nway_call_ivr_menus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_call_ivr_menus (id, ivr_menu_name, ivr_menu_extension, ivr_menu_confirm_macro, ivr_menu_confirm_key, ivr_menu_confirm_attempts, ivr_menu_timeout, ivr_menu_exit_data, ivr_menu_inter_digit_timeout, ivr_menu_max_failures, ivr_menu_max_timeouts, ivr_menu_digit_len, ivr_menu_direct_dial, ivr_menu_cid_prefix, ivr_menu_description, ivr_menu_nway_call_crycle_order, ivr_menu_enabled, ivr_menu_nway_call_order_id, ivr_menu_greet_long_id, ivr_menu_greet_short_id, ivr_menu_invalid_sound_id, ivr_menu_exit_sound_id, ivr_menu_ringback_id, ivr_menu_exit_app_id, ivr_menu_parent_id, node_id, domain_id) FROM stdin;
20	测试	ivr_test		#	3	10000		2000	3	3	0				0	t	0	3	3	3	3	0	0	0	8	0
23	第三级子IVR	ivr-3		#	3	10000		2000	3	3	0				0	t	0	3	3	3	3	0	0	22	8	0
21	第一级子IVR	ivr-1		#	3	10000		2000	3	3	0				0	t	0	3	3	3	3	0	0	20	8	0
22	第二级子IVR	ivr-2		#	3	10000		2000	3	3	0				0	t	0	3	3	3	3	0	0	21	8	0
\.


--
-- Data for Name: nway_call_operation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_call_operation (id, name, description, category) FROM stdin;
2	set	设置变量	dialplan
1	bridge	桥接出去	dialplan
3	transfer	转接出去	dialplan
5	answer	应答	dialplan
6	pre_answer		dialplan
7	playback	播放语音	dialplan
8	socket	转给外部的socket应用	dialplan
9	park	转给外部的inbound应用	dialplan
4	nwayacd	排队	dialplan
10	ivr	ivr	dialplan
11	menu-exit		ivrmenu
12	menu-sub		ivrmenu
13	menu-exec-app		ivrmenu
14	menu-play-sound		ivrmenu
15	menu-back		ivrmenu
16	menu-top		ivrmenu
\.


--
-- Data for Name: nway_call_pg_cdr; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_call_pg_cdr (id, local_ip_v4, caller_id_name, caller_id_number, outbound_caller_id_number, destination_number, context, start_stamp, answer_stamp, end_stamp, duration, billsec, hangup_cause, uuid, bleg_uuid, accountcode, read_codec, write_codec, record_file, direction, sip_hangup_disposition, origination_uuid, sip_gateway_name, sip_term_status, sip_term_cause, dialplan_id, da_type, domain_id, aleg_uuid) FROM stdin;
\.


--
-- Data for Name: nway_call_rings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_call_rings (id, ring_name, ring_path, ring_description, ring_category, node_id, ring_fullpath, domain_id, local_path) FROM stdin;
1	欢迎词	uploads/test/2022_04_26/3706725f-6198-43df-ac3f-3610eda861c2.wav	欢迎词	0	0	/usr/local/freeswitch/sounds/uploads/test/2022_04_26/3706725f-6198-43df-ac3f-3610eda861c2.wav	\N	uploads/test/2022_04_26/3706725f-6198-43df-ac3f-3610eda861c2.wav
2	欢迎词	uploads/test/2022_04_26/ead3fc8a-a7d9-4419-bc3f-1f5c30cae168.wav	欢迎词	0	0	/usr/local/freeswitch/sounds/uploads/test/2022_04_26/ead3fc8a-a7d9-4419-bc3f-1f5c30cae168.wav	\N	uploads/test/2022_04_26/ead3fc8a-a7d9-4419-bc3f-1f5c30cae168.wav
3	欢迎词	uploads/test/2022_04_26/b3b33a69-1a0a-421f-a772-dc6e56f21f02.wav	欢迎词	0	8	/usr/local/freeswitch/sounds/uploads/test/2022_04_26/b3b33a69-1a0a-421f-a772-dc6e56f21f02.wav	\N	uploads/test/2022_04_26/b3b33a69-1a0a-421f-a772-dc6e56f21f02.wav
\.


--
-- Data for Name: nway_ext_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_ext_group (id, group_name, group_number, current_ext_number, domain_id, queue_mode) FROM stdin;
3	110	110		1	3
\.


--
-- Data for Name: nway_ext_group_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_ext_group_map (id, ext_group_id, ext_group_number, ext) FROM stdin;
\.


--
-- Data for Name: nway_extension; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_extension (id, extension_name, extension_number, callout_number, extension_type, group_id, extension_pswd, extension_login_state, extension_reg_state, callout_gateway, is_allow_callout, is_record, answer_without_state, say_job_number, job_number, reg_state, agent_state, agent_status, call_state, lastupdatetime, core_uuid, use_custom_value, client_ip, is_register, is_select, locked, login_password, last_reg_time, dnd, unconditional_forward, call_level, follow_me, last_hangup_time, last_state_change_time, is_follow_me_callout, is_unconditional_forward_callout, use_video, server_ip, domain_id) FROM stdin;
9067	yhh	80002	31570530	0	0	123456	ready	reged	0	t	t	t	f		reged	ready	up	idle	2022-10-03 19:51:21.09215+08		f		t	t	f		2022-10-03 19:51:21.09215	f		2		2022-10-03 19:51:21.09215	2022-10-03 19:51:21.09215	f	f	t		1
9068	nway1	80000		0	0	123456	ready	reged	0	t	t	t	f		reged	ready	up	idle	2022-10-19 11:41:59.24554+08		f		t	t	f		2022-10-19 11:41:59.24554	f		2		2022-10-19 11:41:59.24554	2022-10-19 11:41:59.24554	f	f	t		1
9063	lihao	1000		0	0	123456	success		0	t	f	f	f		unreg	down	idle	ready	\N		f	127.0.0.1	f	f	f	nway.com.cn	2022-10-19 15:42:11.165871	f		0		2022-10-19 15:42:11.165871	2022-10-19 15:42:11.165871	f	f	f		0
\.


--
-- Data for Name: nway_extension_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_extension_type (id, type_name) FROM stdin;
\.


--
-- Data for Name: nway_fs_domains; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_fs_domains (id, domain_name, domain_desc, allow_ip) FROM stdin;
1	default	默认的唯一个domain，除非需要开启多租户，则才配置添加此表	0.0.0.0
\.


--
-- Data for Name: nway_fs_gateway_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_fs_gateway_details (gateway_id, gateway_key, gateway_key_desc, gateway_value, gateway_value_option, enable, id) FROM stdin;
6	realm	ip:port or doamin:port	0.0.0.0:5060		t	4
6	proxy	ip:port or doamin:port	0.0.0.0:5060		t	5
6	register	是否要注册到realm的服务器	false	true/false	t	6
6	username	要注册到realm的服务器的username	nway		f	7
6	password	要注册到realm的服务器的password	nway		f	8
6	register-proxy	注册代理	0.0.0.0:5060		f	9
6	expire-seconds	失效时长	60		f	10
6	register-transport	注册信令协议	udp	tcp/udp/tls	f	11
6	caller-id-in-from		true		f	12
6	contact-params				f	13
6	extension-in-contact		true		f	14
6	ping		25		f	15
6	cid-type		rpid		f	16
6	rfc-5626		true		f	17
\.


--
-- Data for Name: nway_fs_gateway_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_fs_gateway_group (id, gateway_group_name, domain_id, profile_id) FROM stdin;
\.


--
-- Data for Name: nway_fs_gateway_group_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_fs_gateway_group_map (id, gateway_id, gateway_group_id) FROM stdin;
\.


--
-- Data for Name: nway_fs_gateways; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_fs_gateways (id, profile_id, gateway_name, gateway_desc, enable, domain_id, max_concurrent, concurrent) FROM stdin;
6	10	nway		t	0	30	\N
\.


--
-- Data for Name: nway_fs_heartbeat_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_fs_heartbeat_history (id, node_ip, sip_result, check_time, cpu_used, mem_used, disk_used, network_used) FROM stdin;
\.


--
-- Data for Name: nway_fs_node; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_fs_node (id, node_name, operate_ip, operate_port, fs_esl_ip, fs_esl_port, meminfo, external_ip, fs_esl_secret, operate_secret, alow_system_call, heartbeat_port, enable, request_url, extension_dialplan, public_dialplan, cdr_dbstring) FROM stdin;
18	s1	10.0.0.120	8095	127.0.0.1	8021		0.0.0.0	ClueCon	Nway123!	t	5080	t	http://127.0.0.1:3000/	127.0.0.1:8096		
\.


--
-- Data for Name: nway_fs_node_global_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_fs_node_global_details (id, node_id, category, node_key, node_value, node_desc) FROM stdin;
174	18	global	default_password	1234	默认密码
175	18	global	recordings_dir	/usr/local/freeswitch/recordings	默认录音路径
176	18	global	sounds_dir	/usr/local/freeswitch/sounds	默认彩铃录音上传路径
177	18	global	global_codec_prefs	PCMA,H264	默认全局编码
178	18	global	outbound_codec_prefs	PCMA,H264	默认出局编码
179	18	global	external_rtp_ip	$${local_ip_v4}	默认外部rtp ip
180	18	global	external_sip_ip	$${local_ip_v4}	默认外部sip ip
181	18	global	outbound_caller_name	lihao	默认呼出名称
182	18	global	outbound_caller_id	18621575908	默认呼出名称
183	18	global	sip_tls_version	tlsv1,tlsv1.1,tlsv1.2	支持ssl版本
184	18	global	internal_sip_port	5060	 
185	18	global	external_sip_port	5080	 
186	18	switch	max-db-handles	50	默认数据库句柄
187	18	switch	db-handle-timeout	10	默认数据库句柄超时
188	18	switch	event-heartbeat-interval	20	默认数据库句柄超时
189	18	switch	max-sessions	10000	默认最大会话数
190	18	switch	sessions-per-second	80	默认每秒会话数
191	18	switch	rtp-start-port	10000	默认开始的rtp端口
192	18	switch	rtp-end-port	60000	默认结束的rtp端口
193	18	switch	multiple-registrations	false	是否允许多并发注册
\.


--
-- Data for Name: nway_fs_profile_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_fs_profile_details (id, profile_id, profile_key, profile_value, enable, profile_value_options, profile_key_desc) FROM stdin;
2320	19	debug	0	t		
2321	19	sip-trace	no	t		
2322	19	sip-capture	no	t		
2323	19	rfc2833-pt	101	t		
2324	19	sip-port	$${external_sip_port}	t		
2325	19	dialplan	XML	t		
2326	19	ext-sip-ip	$${external_sip_ip}	t		
2327	19	ext-rtp-ip	$${external_rtp_ip}	t		
2328	19	rtp-ip	$${local_ip_v4}	t		
2329	19	sip-ip	$${local_ip_v4}	t		
2330	19	inbound-late-negotiation	true	t		
2331	19	inbound-zrtp-passthru	true	t		
2332	19	context	public	t		
2333	19	dtmf-duration	2000	t		
2334	19	inbound-codec-prefs	PCMA,H264	t	PCMA,H264,PCMU,G722	
2335	19	outbound-codec-prefs	PCMA,H264	t	PCMA,H264,PCMU,G722	
2336	19	hold-music	$${hold-music}	t		
2337	19	rtp-timer-name	soft	t		
2338	19	local-network-acl	localnet.auto	t	localnet.auto/passive	
2339	19	enable-100rel	false	t		
2340	19	manage-presence	false	t	 	
2341	19	inbound-codec-negotiation	generous	t		
2342	19	nonce-ttl	60	t		
2343	19	auth-calls	false	t		
2344	19	tls-ciphers	$${sip_tls_ciphers}	f		
2345	19	tls-version	$${sip_tls_version}	f		
2346	19	enable-3pcc	true	f	 	
2347	19	rtp-hold-timeout-sec	1800	f		
2348	19	rtp-timeout-sec	300	t		
2349	20	watchdog-enabled	no	t		
2350	20	watchdog-step-timeout	30000	t		
2351	20	watchdog-event-timeout	30000	t		
2352	20	log-auth-failures	false	t		
2353	20	forward-unsolicited-mwi-notify	false	t		
2354	20	context	public	t		
2355	20	rfc2833-pt	101	t		
2356	20	sip-port	$${internal_sip_port}	t		
2357	20	dialplan	XML	t		
2358	20	dtmf-duration	2000	t		
2359	20	inbound-codec-prefs	$${global_codec_prefs}	t		
2360	20	outbound-codec-prefs	$${global_codec_prefs}	t		
2361	20	rtp-timer-name	soft	t		
2362	20	rtp-ip	$${local_ip_v4}	t		
2363	20	sip-ip	$${local_ip_v4}	t		
2364	20	hold-music	$${hold_music}	t		
2365	20	apply-nat-acl	nat.auto	t		
2366	20	enable-100rel	true	f		
2367	20	disable-srv503	true	f		
2368	20	enable-compact-headers	true	f		
2369	20	enable-timer	false	t		
2370	20	minimum-session-expires	120	f		
2371	20	apply-inbound-acl	domains	t		
2372	20	local-network-acl	localnet.auto	t		
2373	20	apply-register-acl	domains	f		
2374	20	dtmf-type	info	f		
2375	20	send-message-query-on-register	true	f		
2376	20	send-presence-on-register	first-only	f		
2377	20	caller-id-type	rpid	f		
2378	20	caller-id-type	pid	f		
2379	20	caller-id-type	none	f		
2380	20	record-path	$${recordings_dir}	t		
2381	20	record-template	${caller_id_number}.${target_domain}.${strftime(%Y-%m-%d-%H-%M-%S)}.wav	t		
2382	20	manage-presence	true	t		
2383	20	presence-probe-on-register	true	f		
2384	20	manage-shared-appearance	true	f		
2385	20	dbname	share_presence	f		
2386	20	presence-hosts	$${domain},$${local_ip_v4}	t		
2387	20	presence-privacy	$${presence_privacy}	t		
2388	20	bitpacking	aal2	f		
2389	20	max-proceeding	1000	f		
2390	20	session-timeout	1800	f		
2391	20	multiple-registrations	contact	f		
2392	20	inbound-codec-negotiation	generous	t		
2393	20	bind-params	transport=udp	f		
2394	20	unregister-on-options-fail	true	f		
2395	20	all-reg-options-ping	true	f		
2396	20	nat-options-ping	true	f		
2397	20	sip-options-respond-503-on-busy	true	f		
2398	20	sip-messages-respond-200-ok	true	f		
2399	20	sip-subscribe-respond-200-ok	true	f		
2400	20	tls	$${internal_ssl_enable}	t		
2401	20	tls-only	false	t		
2402	20	tls-bind-params	transport=tls	t		
2403	20	tls-sip-port	$${internal_tls_port}	t		
2404	20	tls-cert-dir		f		
2405	20	tls-passphrase		t		
2406	20	tls-verify-date	true	t		
2407	20	tls-verify-policy	none	t		
2408	20	tls-verify-depth	2	t		
2409	20	tls-verify-in-subjects		t		
2410	20	tls-version	$${sip_tls_version}	t		
2411	20	tls-ciphers	$${sip_tls_ciphers}	t		
2412	20	rtp-autoflush-during-bridge	false	f		
2413	20	rtp-rewrite-timestamps	true	f		
2414	20	pass-rfc2833	true	f		
2415	20	inbound-bypass-media	true	f		
2416	20	inbound-proxy-media	true	f		
2417	20	inbound-late-negotiation	true	t		
2418	20	inbound-zrtp-passthru	true	t		
2419	20	accept-blind-reg	true	f		
2420	20	accept-blind-auth	true	f		
2421	20	suppress-cng	true	f		
2422	20	nonce-ttl	60	t		
2423	20	disable-transcoding	true	f		
2424	20	manual-redirect	true	f		
2425	20	disable-transfer	true	f		
2426	20	disable-register	true	f		
2427	20	NDLB-broken-auth-hash	true	f		
2428	20	NDLB-received-in-nat-reg-contact	true	f		
2429	20	auth-calls	$${internal_auth_calls}	t		
2430	20	auth-subscriptions	true	t		
2431	20	inbound-reg-force-matching-username	true	t		
2432	20	auth-all-packets	false	t		
2433	20	ext-rtp-ip	$${external_rtp_ip}	t		external_sip_ip\\n\\n\n\t            Used as the public IP address for SDP.\\n\\n\n\t\t\t\t\t            Can be an one of:\\n\\n\n\t            ip address            - \\"12.34.56.78\\"\\n\\n\n\t            a stun server lookup  - \\"stun:stun.server.com\\"\\n\\n\n\t            a DNS name            - \\"host:host.server.com\\"\\n\\n\n\t            auto                  - Use guessed ip.\\n\\n\n\t            auto-nat              - Use ip learned from NAT-PMP or UPNP
2434	20	ext-sip-ip	$${external_sip_ip}	t		
2435	20	rtp-timeout-sec	300	t		
2436	20	rtp-hold-timeout-sec	1800	t		
2437	20	alias	sip:10.0.1.251:5555	f		
2438	20	force-register-domain	$${domain}	t		
2439	20	force-subscription-domain	$${domain}	t		
2440	20	force-register-db-domain	$${domain}	t		
2441	20	ws-binding	:5066	t		
2442	20	wss-binding	:7443	t		
2443	20	delete-subs-on-register	false	f		
2444	20	inbound-reg-in-new-thread	true	f		
2445	20	rtcp-audio-interval-msec	5000	f		
2446	20	rtcp-video-interval-msec	5000	f		
2447	20	force-subscription-expires	60	f		
2448	20	sip-subscription-max-deviation	120	f		
2449	20	disable-transfer	true	f	disable register and transfer which may be undesirable in a public switch 	
2450	20	disable-register	true	f		
2451	20	enable-3pcc	true	f		
2452	20	NDLB-force-rport	true	f		
2454	20	disable-rtp-auto-adjust	true	f		
2455	20	inbound-use-callid-as-uuid	true	f		
2456	20	outbound-use-uuid-as-callid	true	f		
2457	20	rtp-autofix-timing	false	f		
2458	20	pass-callee-id	false	f		
2459	20	auto-rtp-bugs	clear	f		
2460	20	disable-srv	false	f		the following can be used as workaround with bogus SRV/NAPTR records
2461	20	disable-naptr	false	f		
2462	20	timer-T1	500	f		
2463	20	timer-T1X64	32000	f		
2464	20	timer-T2	4000	f		
2465	20	timer-T4	4000	f		
2466	20	auto-jitterbuffer-msec	60	f		
2467	20	renegotiate-codec-on-hold	true	f		
2468	20	auto-invite-100	false	f		
\.


--
-- Data for Name: nway_fs_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_fs_profiles (id, node_id, profile_name, profile_desc, enable, is_internal, load_internal_user_file) FROM stdin;
6	0			f	f	f
7	0			f	f	f
19	18	internal	默认的内线profile	t	t	f
20	18	external	默认的外线profile	t	f	f
\.


--
-- Data for Name: nway_manager_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_manager_users (id, domain_id, username, salt, password, create_time, last_login_time, login_times, real_name, mobile) FROM stdin;
\.


--
-- Data for Name: nway_time_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nway_time_plans (id, week_time, time_name, disable_days, start_time, stop_time) FROM stdin;
\.


--
-- Data for Name: t_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.t_role (id, role_name, description, create_time, updatetime) FROM stdin;
\.


--
-- Data for Name: t_role_perm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.t_role_perm (id, role_id, perm_id) FROM stdin;
\.


--
-- Data for Name: t_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.t_user (id, user_name, password, salt, status, create_time, last_login, update_time, email, last_ip, sex) FROM stdin;
1	admin	945c65b120a8e09f1fa507128e9ba48b	szFswPLYXE	0	2022-03-30 17:56:03.831837	2022-11-02 11:37:58.749361	2022-11-02 11:37:58.749428	lihao@nway.com.cn	47.1-4.124.127	0
\.


--
-- Data for Name: t_user_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.t_user_role (id, user_id, role_id) FROM stdin;
\.


--
-- Data for Name: wx_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wx_user (user_name, password) FROM stdin;
\.


--
-- Name: call_blacklist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.call_blacklist_id_seq', 4, false);


--
-- Name: goadmin_menu_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_menu_myid_seq', 10, true);


--
-- Name: goadmin_operation_log_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_operation_log_myid_seq', 51, true);


--
-- Name: goadmin_permissions_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_permissions_myid_seq', 170, true);


--
-- Name: goadmin_roles_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_roles_myid_seq', 2, true);


--
-- Name: goadmin_session_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_session_myid_seq', 25, true);


--
-- Name: goadmin_site_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_site_myid_seq', 69, true);


--
-- Name: goadmin_users_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_users_myid_seq', 2, true);


--
-- Name: nway_acl_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_acl_detail_id_seq', 1, false);


--
-- Name: nway_acl_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_acl_id_seq', 1, false);


--
-- Name: nway_call_dialplan_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_call_dialplan_details_id_seq', 79, true);


--
-- Name: nway_call_dialplans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_call_dialplans_id_seq', 1002, true);


--
-- Name: nway_call_gateway_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_call_gateway_group_id_seq', 1, false);


--
-- Name: nway_call_gateway_group_map_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_call_gateway_group_map_id_seq', 1, false);


--
-- Name: nway_call_ivr_menu_options_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_call_ivr_menu_options_id_seq', 56, true);


--
-- Name: nway_call_ivr_menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_call_ivr_menus_id_seq', 23, true);


--
-- Name: nway_call_operation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_call_operation_id_seq', 7, false);


--
-- Name: nway_call_pg_cdr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_call_pg_cdr_id_seq', 1525182, false);


--
-- Name: nway_call_rings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_call_rings_id_seq', 3, true);


--
-- Name: nway_ext_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_ext_group_id_seq', 6, true);


--
-- Name: nway_ext_group_map_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_ext_group_map_id_seq', 1, false);


--
-- Name: nway_extension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_extension_id_seq', 9068, true);


--
-- Name: nway_extension_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_extension_type_id_seq', 7, false);


--
-- Name: nway_fs_domains_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_fs_domains_id_seq', 2, true);


--
-- Name: nway_fs_gateway_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_fs_gateway_details_id_seq', 17, true);


--
-- Name: nway_fs_gateways_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_fs_gateways_id_seq', 6, true);


--
-- Name: nway_fs_heartbeat_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_fs_heartbeat_history_id_seq', 1, false);


--
-- Name: nway_fs_node_global_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_fs_node_global_details_id_seq', 193, true);


--
-- Name: nway_fs_node_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_fs_node_id_seq', 18, true);


--
-- Name: nway_fs_profile_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_fs_profile_details_id_seq', 2588, true);


--
-- Name: nway_fs_profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_fs_profiles_id_seq', 21, true);


--
-- Name: nway_manager_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_manager_users_id_seq', 1, false);


--
-- Name: nway_time_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nway_time_plans_id_seq', 1, false);


--
-- Name: t_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.t_role_id_seq', 1, false);


--
-- Name: t_role_perm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.t_role_perm_id_seq', 1, false);


--
-- Name: t_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.t_user_id_seq', 1, false);


--
-- Name: t_user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.t_user_role_id_seq', 1, false);


--
-- Name: call_blacklist PK_BLACKLIST_NUMBER; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.call_blacklist
    ADD CONSTRAINT "PK_BLACKLIST_NUMBER" PRIMARY KEY (call_number);


--
-- Name: nway_fs_node_global_details PK_NODE_GLOBAL_DETAILS_ID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_node_global_details
    ADD CONSTRAINT "PK_NODE_GLOBAL_DETAILS_ID" PRIMARY KEY (id);


--
-- Name: nway_fs_node PK_NODE_ID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_node
    ADD CONSTRAINT "PK_NODE_ID" PRIMARY KEY (id);


--
-- Name: nway_extension call_extension_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_extension
    ADD CONSTRAINT call_extension_pkey PRIMARY KEY (id);


--
-- Name: nway_extension_type call_extension_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_extension_type
    ADD CONSTRAINT call_extension_type_pkey PRIMARY KEY (id);


--
-- Name: nway_call_operation call_operation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_call_operation
    ADD CONSTRAINT call_operation_pkey PRIMARY KEY (id);


--
-- Name: nway_call_rings call_rings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_call_rings
    ADD CONSTRAINT call_rings_pkey PRIMARY KEY (id);


--
-- Name: nway_call_dialplan_details nway_call_dialplan_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_call_dialplan_details
    ADD CONSTRAINT nway_call_dialplan_details_pkey PRIMARY KEY (id);


--
-- Name: nway_call_dialplans nway_call_dialplans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_call_dialplans
    ADD CONSTRAINT nway_call_dialplans_pkey PRIMARY KEY (id);


--
-- Name: nway_call_ivr_menu_options nway_call_ivr_menu_options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_call_ivr_menu_options
    ADD CONSTRAINT nway_call_ivr_menu_options_pkey PRIMARY KEY (id);


--
-- Name: nway_call_ivr_menus nway_call_ivr_menus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_call_ivr_menus
    ADD CONSTRAINT nway_call_ivr_menus_pkey PRIMARY KEY (id);


--
-- Name: nway_call_pg_cdr nway_call_pg_cdr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_call_pg_cdr
    ADD CONSTRAINT nway_call_pg_cdr_pkey PRIMARY KEY (id);


--
-- Name: nway_fs_domains nway_fs_domains_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_fs_domains
    ADD CONSTRAINT nway_fs_domains_pkey PRIMARY KEY (id);


--
-- Name: nway_manager_users nway_manager_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nway_manager_users
    ADD CONSTRAINT nway_manager_users_pkey PRIMARY KEY (id);


--
-- Name: BLACKLIST_NUMBER_IDX; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "BLACKLIST_NUMBER_IDX" ON public.call_blacklist USING btree (call_number, category);


--
-- Name: FKI_NODE_GLOBAL_DETAILS_NODE_ID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "FKI_NODE_GLOBAL_DETAILS_NODE_ID" ON public.nway_fs_node_global_details USING btree (node_id);


--
-- Name: IDX_CALL_EXTENSION_EXT_NUMBER; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_CALL_EXTENSION_EXT_NUMBER" ON public.nway_extension USING btree (extension_number);


--
-- Name: IDX_CALL_RINGS_MAIN; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_CALL_RINGS_MAIN" ON public.nway_call_rings USING btree (id, ring_name, ring_path);


--
-- Name: IDX_nway_call_DIALPLAN_DETAILS_MAIN; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_nway_call_DIALPLAN_DETAILS_MAIN" ON public.nway_call_dialplan_details USING btree (id, dialplan_id);


--
-- Name: IDX_nway_call_IVR_MENU_OPTIONS_MAIN; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_nway_call_IVR_MENU_OPTIONS_MAIN" ON public.nway_call_ivr_menu_options USING btree (id, ivr_menu_id);


--
-- Name: NWAY_FS_NODE_INDEX_IP; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "NWAY_FS_NODE_INDEX_IP" ON public.nway_fs_node USING btree (id, operate_ip);


--
-- Name: base_mobile_location_district_no; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX base_mobile_location_district_no ON public.nway_base_mobile_location USING btree (district_no);


--
-- Name: base_mobile_location_no; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX base_mobile_location_no ON public.nway_base_mobile_location USING btree (no);


--
-- Name: callee_number_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX callee_number_index ON public.nway_call_pg_cdr USING btree (destination_number);


--
-- Name: caller_number_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX caller_number_index ON public.nway_call_pg_cdr USING btree (caller_id_name, caller_id_number);


--
-- Name: pg_cdr_uuid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pg_cdr_uuid_idx ON public.nway_call_pg_cdr USING btree (uuid, bleg_uuid);


--
-- Name: start_time_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX start_time_index ON public.nway_call_pg_cdr USING btree (start_stamp);


--
-- Name: nway_call_pg_cdr insert_tbl_nway_call_pg_cdr; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER insert_tbl_nway_call_pg_cdr BEFORE INSERT ON public.nway_call_pg_cdr FOR EACH ROW EXECUTE PROCEDURE public.auto_insert_into_call_pg_cdr('start_stamp');


--
-- Name: nway_fs_heartbeat_history trigger_nway_fs_heartbeat_history; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_nway_fs_heartbeat_history BEFORE INSERT ON public.nway_fs_heartbeat_history FOR EACH ROW EXECUTE PROCEDURE public.auto_insert_into_nway_fs_heartbeat_history('check_time');


--
-- PostgreSQL database dump complete
--

