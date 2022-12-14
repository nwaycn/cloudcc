PGDMP     5    2            
    z            cloudcc    10.5    10.5 p   ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            ?           1262    62272    cloudcc    DATABASE     y   CREATE DATABASE cloudcc WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE cloudcc;
             postgres    false            ?           0    0    DATABASE cloudcc    COMMENT     E   COMMENT ON DATABASE cloudcc IS '分布式FreeSWITCH配置数据库';
                  postgres    false    4261                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            ?           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        3079    13792    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            ?           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                       1255    62273    auto_insert_into_call_pg_cdr()    FUNCTION     k  CREATE FUNCTION public.auto_insert_into_call_pg_cdr() RETURNS trigger
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
 5   DROP FUNCTION public.auto_insert_into_call_pg_cdr();
       public       postgres    false    1    3                        1255    62274 ,   auto_insert_into_nway_fs_heartbeat_history()    FUNCTION       CREATE FUNCTION public.auto_insert_into_nway_fs_heartbeat_history() RETURNS trigger
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
 C   DROP FUNCTION public.auto_insert_into_nway_fs_heartbeat_history();
       public       postgres    false    1    3            ?            1259    62275    call_blacklist_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.call_blacklist_id_seq
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.call_blacklist_id_seq;
       public       postgres    false    3            ?            1259    62277    call_blacklist    TABLE     ?  CREATE TABLE public.call_blacklist (
    id bigint DEFAULT nextval('public.call_blacklist_id_seq'::regclass) NOT NULL,
    category integer DEFAULT 0,
    call_number character varying(30) NOT NULL,
    dest_number character varying(30) DEFAULT ''::character varying,
    group_number character varying(50),
    domain_id bigint DEFAULT 0,
    expire_time timestamp without time zone DEFAULT (now() + '7 days'::interval)
);
 "   DROP TABLE public.call_blacklist;
       public         postgres    false    196    3            ?           0    0    COLUMN call_blacklist.category    COMMENT     w   COMMENT ON COLUMN public.call_blacklist.category IS '类型，全局黑名单0，对外黑名单1，呼入黑名单2';
            public       postgres    false    197            ?            1259    62285    goadmin_menu_myid_seq    SEQUENCE     ?   CREATE SEQUENCE public.goadmin_menu_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;
 ,   DROP SEQUENCE public.goadmin_menu_myid_seq;
       public       postgres    false    3            ?            1259    62287    goadmin_operation_log_myid_seq    SEQUENCE     ?   CREATE SEQUENCE public.goadmin_operation_log_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;
 5   DROP SEQUENCE public.goadmin_operation_log_myid_seq;
       public       postgres    false    3            ?            1259    62289    goadmin_permissions_myid_seq    SEQUENCE     ?   CREATE SEQUENCE public.goadmin_permissions_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;
 3   DROP SEQUENCE public.goadmin_permissions_myid_seq;
       public       postgres    false    3            ?            1259    62291    goadmin_roles_myid_seq    SEQUENCE     ?   CREATE SEQUENCE public.goadmin_roles_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;
 -   DROP SEQUENCE public.goadmin_roles_myid_seq;
       public       postgres    false    3            ?            1259    62293    goadmin_session_myid_seq    SEQUENCE     ?   CREATE SEQUENCE public.goadmin_session_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;
 /   DROP SEQUENCE public.goadmin_session_myid_seq;
       public       postgres    false    3            ?            1259    62295    goadmin_site_myid_seq    SEQUENCE     ?   CREATE SEQUENCE public.goadmin_site_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;
 ,   DROP SEQUENCE public.goadmin_site_myid_seq;
       public       postgres    false    3            ?            1259    62297    goadmin_users_myid_seq    SEQUENCE     ?   CREATE SEQUENCE public.goadmin_users_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;
 -   DROP SEQUENCE public.goadmin_users_myid_seq;
       public       postgres    false    3                       1259    63212    nway_acl_id_seq    SEQUENCE     x   CREATE SEQUENCE public.nway_acl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.nway_acl_id_seq;
       public       postgres    false    3                       1259    63217    nway_acl    TABLE     +  CREATE TABLE public.nway_acl (
    id bigint DEFAULT nextval('public.nway_acl_id_seq'::regclass) NOT NULL,
    node_id bigint NOT NULL,
    acl_name character varying(100) DEFAULT ''::character varying NOT NULL,
    default_type character varying(100) DEFAULT 'allow'::character varying NOT NULL
);
    DROP TABLE public.nway_acl;
       public         postgres    false    259    3            ?           0    0    COLUMN nway_acl.default_type    COMMENT     C   COMMENT ON COLUMN public.nway_acl.default_type IS 'allow or deny';
            public       postgres    false    260                       1259    63223    nway_acl_detail_id_seq    SEQUENCE        CREATE SEQUENCE public.nway_acl_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.nway_acl_detail_id_seq;
       public       postgres    false    3                       1259    63225    nway_acl_detail    TABLE     @  CREATE TABLE public.nway_acl_detail (
    id bigint DEFAULT nextval('public.nway_acl_detail_id_seq'::regclass) NOT NULL,
    acl_type character varying(100) NOT NULL,
    is_domain boolean DEFAULT false NOT NULL,
    acl_value character varying(100) DEFAULT ''::character varying NOT NULL,
    acl_id bigint NOT NULL
);
 #   DROP TABLE public.nway_acl_detail;
       public         postgres    false    261    3            ?           0    0    COLUMN nway_acl_detail.acl_type    COMMENT     F   COMMENT ON COLUMN public.nway_acl_detail.acl_type IS 'allow or deny';
            public       postgres    false    262            ?           0    0     COLUMN nway_acl_detail.is_domain    COMMENT     H   COMMENT ON COLUMN public.nway_acl_detail.is_domain IS 'domain or cidr';
            public       postgres    false    262            ?           0    0     COLUMN nway_acl_detail.acl_value    COMMENT     K   COMMENT ON COLUMN public.nway_acl_detail.acl_value IS 'domain or ip/mask';
            public       postgres    false    262                       1259    63307    nway_area_plan_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.nway_area_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.nway_area_plan_id_seq;
       public       postgres    false    3                       1259    63309    nway_area_plan    TABLE       CREATE TABLE public.nway_area_plan (
    id bigint DEFAULT nextval('public.nway_area_plan_id_seq'::regclass) NOT NULL,
    plan_name character varying(100) DEFAULT ''::character varying NOT NULL,
    plan_desc text,
    node_id bigint,
    district_no text DEFAULT ''::text
);
 "   DROP TABLE public.nway_area_plan;
       public         postgres    false    268    3            ?           0    0    TABLE nway_area_plan    COMMENT     :   COMMENT ON TABLE public.nway_area_plan IS '区域策略';
            public       postgres    false    269            ?           0    0 !   COLUMN nway_area_plan.district_no    COMMENT     M   COMMENT ON COLUMN public.nway_area_plan.district_no IS '电话区号列表';
            public       postgres    false    269                       1259    63305    nway_area_plan_detail_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_area_plan_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.nway_area_plan_detail_id_seq;
       public       postgres    false    3                       1259    63319    nway_area_plan_detail    TABLE     ?   CREATE TABLE public.nway_area_plan_detail (
    id bigint DEFAULT nextval('public.nway_area_plan_detail_id_seq'::regclass) NOT NULL,
    district_no character varying(50) DEFAULT ''::character varying,
    area_plan_id bigint DEFAULT 0
);
 )   DROP TABLE public.nway_area_plan_detail;
       public         postgres    false    267    3            ?           0    0    TABLE nway_area_plan_detail    COMMENT     G   COMMENT ON TABLE public.nway_area_plan_detail IS '区域策略明细';
            public       postgres    false    270            ?            1259    62299    nway_base_mobile_location    TABLE     ?   CREATE TABLE public.nway_base_mobile_location (
    no character varying(7) NOT NULL,
    location character varying(50),
    district_no character varying(10)
);
 -   DROP TABLE public.nway_base_mobile_location;
       public         postgres    false    3            ?           0    0    TABLE nway_base_mobile_location    COMMENT     x   COMMENT ON TABLE public.nway_base_mobile_location IS '上海宁卫信息技术有限公司，李浩。手机归属地';
            public       postgres    false    205            ?           0    0 #   COLUMN nway_base_mobile_location.no    COMMENT     I   COMMENT ON COLUMN public.nway_base_mobile_location.no IS '手机号段';
            public       postgres    false    205            ?           0    0 )   COLUMN nway_base_mobile_location.location    COMMENT     L   COMMENT ON COLUMN public.nway_base_mobile_location.location IS '所在地';
            public       postgres    false    205            ?           0    0 ,   COLUMN nway_base_mobile_location.district_no    COMMENT     L   COMMENT ON COLUMN public.nway_base_mobile_location.district_no IS '区号';
            public       postgres    false    205            	           1259    63237    nway_black_number_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_black_number_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 123456789
    CACHE 1;
 /   DROP SEQUENCE public.nway_black_number_id_seq;
       public       postgres    false    3            
           1259    63239    nway_black_number    TABLE     *  CREATE TABLE public.nway_black_number (
    id bigint DEFAULT nextval('public.nway_black_number_id_seq'::regclass) NOT NULL,
    phone_number character varying(50),
    group_number character varying(50),
    expire_time timestamp without time zone DEFAULT now(),
    domain_id bigint DEFAULT 0
);
 %   DROP TABLE public.nway_black_number;
       public         postgres    false    265    3            ?           0    0 %   COLUMN nway_black_number.phone_number    COMMENT     E   COMMENT ON COLUMN public.nway_black_number.phone_number IS '号码';
            public       postgres    false    266            ?           0    0 %   COLUMN nway_black_number.group_number    COMMENT     N   COMMENT ON COLUMN public.nway_black_number.group_number IS '属于哪个组';
            public       postgres    false    266            ?           0    0 $   COLUMN nway_black_number.expire_time    COMMENT     b   COMMENT ON COLUMN public.nway_black_number.expire_time IS '失效时间后自动从库里清除';
            public       postgres    false    266            ?            1259    62302 !   nway_call_dialplan_details_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_call_dialplan_details_id_seq
    START WITH 73
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.nway_call_dialplan_details_id_seq;
       public       postgres    false    3            ?            1259    62304    nway_call_dialplan_details    TABLE     `  CREATE TABLE public.nway_call_dialplan_details (
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
 .   DROP TABLE public.nway_call_dialplan_details;
       public         postgres    false    206    3            ?           0    0 6   COLUMN nway_call_dialplan_details.dialplan_detail_data    COMMENT     ?   COMMENT ON COLUMN public.nway_call_dialplan_details.dialplan_detail_data IS '当为ring时，endless_playback值表示是不断循环播放ring';
            public       postgres    false    207            ?           0    0 )   COLUMN nway_call_dialplan_details.ring_id    COMMENT     l   COMMENT ON COLUMN public.nway_call_dialplan_details.ring_id IS '如果是播放彩铃，则需要彩铃id';
            public       postgres    false    207            ?           0    0 1   COLUMN nway_call_dialplan_details.outline_gateway    COMMENT     ?   COMMENT ON COLUMN public.nway_call_dialplan_details.outline_gateway IS '如果有多条网关的话，则需要在gateway中配置一个ALL,则在拨号计划的时候是指定sofia/external/,就可以将全部呼出去';
            public       postgres    false    207            ?           0    0 ,   COLUMN nway_call_dialplan_details.is_callout    COMMENT     ?   COMMENT ON COLUMN public.nway_call_dialplan_details.is_callout IS '是否呼外线，用于避免呼叫时指定路由时要用sofia/gateway或user等的';
            public       postgres    false    207            ?           0    0 2   COLUMN nway_call_dialplan_details.gateway_group_id    COMMENT     U   COMMENT ON COLUMN public.nway_call_dialplan_details.gateway_group_id IS '网关组';
            public       postgres    false    207            ?           0    0 2   COLUMN nway_call_dialplan_details.area_district_no    COMMENT     n   COMMENT ON COLUMN public.nway_call_dialplan_details.area_district_no IS '区域路由的区号，以,分隔';
            public       postgres    false    207            ?           0    0 .   COLUMN nway_call_dialplan_details.external_uri    COMMENT     ?  COMMENT ON COLUMN public.nway_call_dialplan_details.external_uri IS '外部操作的url,当ivr_menu_option_digits 为空时有效，自动将主叫  caller_number=xxx,dtmf=xxx,uuid=xxx  等消息发给url，等待url的返回值后执行，如hangup,挂机，playring,放音，dtmf+彩铃+按键长度  为获取按键 ；bridge为转接到分机，agent_group为转接到座席组，senddtmf:发送dtmf按键；
';
            public       postgres    false    207            ?           0    0 -   COLUMN nway_call_dialplan_details.is_timeplan    COMMENT     ?   COMMENT ON COLUMN public.nway_call_dialplan_details.is_timeplan IS '是否启用时间段，上午，下午上班等都可以有自己的路由';
            public       postgres    false    207            ?           0    0 ;   COLUMN nway_call_dialplan_details.dialplan_detail_type_name    COMMENT     {   COMMENT ON COLUMN public.nway_call_dialplan_details.dialplan_detail_type_name IS '可以不用Dialplan_detail_type_id了';
            public       postgres    false    207            ?            1259    62323    nway_call_dialplans_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_call_dialplans_id_seq
    START WITH 56
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.nway_call_dialplans_id_seq;
       public       postgres    false    3            ?            1259    62325    nway_call_dialplans    TABLE     u  CREATE TABLE public.nway_call_dialplans (
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
 '   DROP TABLE public.nway_call_dialplans;
       public         postgres    false    208    3            ?           0    0    TABLE nway_call_dialplans    COMMENT     ?   COMMENT ON TABLE public.nway_call_dialplans IS '优先进入到destination_number，然后检查 source是不是为空，不空处理，再检查 network_addr进行处理，不为空处理，再检查 caller_id_number，则处理';
            public       postgres    false    209            ?           0    0 (   COLUMN nway_call_dialplans.dialplan_name    COMMENT     H   COMMENT ON COLUMN public.nway_call_dialplans.dialplan_name IS '名称';
            public       postgres    false    209            ?           0    0 +   COLUMN nway_call_dialplans.dialplan_context    COMMENT     k   COMMENT ON COLUMN public.nway_call_dialplans.dialplan_context IS '这时用于标明是default或prublic';
            public       postgres    false    209            ?           0    0 *   COLUMN nway_call_dialplans.dialplan_number    COMMENT     e   COMMENT ON COLUMN public.nway_call_dialplans.dialplan_number IS '号码，可按正则表达式来';
            public       postgres    false    209            ?           0    0 /   COLUMN nway_call_dialplans.is_nway_call_outline    COMMENT     ~   COMMENT ON COLUMN public.nway_call_dialplans.is_nway_call_outline IS '是否是外呼外线的拨号计划，默认为false';
            public       postgres    false    209            ?           0    0 (   COLUMN nway_call_dialplans.use_time_plan    COMMENT     ?   COMMENT ON COLUMN public.nway_call_dialplans.use_time_plan IS '启用时间策略，默认不启用，如果启用，则按details中的对应的要使用时间策略的方式进行';
            public       postgres    false    209            ?           0    0 -   COLUMN nway_call_dialplans.destination_number    COMMENT     m   COMMENT ON COLUMN public.nway_call_dialplans.destination_number IS '用于dialplan中的destination_number';
            public       postgres    false    209            ?           0    0 !   COLUMN nway_call_dialplans.source    COMMENT     p   COMMENT ON COLUMN public.nway_call_dialplans.source IS '<condition field="source" expression="mod_sofia"/>等';
            public       postgres    false    209            ?           0    0 '   COLUMN nway_call_dialplans.network_addr    COMMENT     `   COMMENT ON COLUMN public.nway_call_dialplans.network_addr IS '192.168.0.0/16,10.0.0.0/8   等';
            public       postgres    false    209            ?           0    0 +   COLUMN nway_call_dialplans.caller_id_number    COMMENT     ?   COMMENT ON COLUMN public.nway_call_dialplans.caller_id_number IS '以,分隔的多个号码，如 18621575908,13671947488等呼入的才走这条路由';
            public       postgres    false    209            ?           0    0 "   COLUMN nway_call_dialplans.node_id    COMMENT     T   COMMENT ON COLUMN public.nway_call_dialplans.node_id IS '归属于哪一个节点';
            public       postgres    false    209            ?           0    0 &   COLUMN nway_call_dialplans.save_to_xml    COMMENT     ?   COMMENT ON COLUMN public.nway_call_dialplans.save_to_xml IS '是否自动下发到freeswitch的dialplan中，使用dialplan_context来区分default,public';
            public       postgres    false    209            ?            1259    62343    nway_fs_gateway_group    TABLE     ?   CREATE TABLE public.nway_fs_gateway_group (
    id bigint NOT NULL,
    gateway_group_name character varying(100),
    domain_id bigint DEFAULT 0,
    profile_id bigint DEFAULT 0
);
 )   DROP TABLE public.nway_fs_gateway_group;
       public         postgres    false    3            ?            1259    62348    nway_call_gateway_group_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_call_gateway_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.nway_call_gateway_group_id_seq;
       public       postgres    false    210    3            ?           0    0    nway_call_gateway_group_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.nway_call_gateway_group_id_seq OWNED BY public.nway_fs_gateway_group.id;
            public       postgres    false    211            ?            1259    62350    nway_fs_gateway_group_map    TABLE     ~   CREATE TABLE public.nway_fs_gateway_group_map (
    id bigint NOT NULL,
    gateway_id bigint,
    gateway_group_id bigint
);
 -   DROP TABLE public.nway_fs_gateway_group_map;
       public         postgres    false    3            ?            1259    62353 "   nway_call_gateway_group_map_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_call_gateway_group_map_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.nway_call_gateway_group_map_id_seq;
       public       postgres    false    212    3            ?           0    0 "   nway_call_gateway_group_map_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.nway_call_gateway_group_map_id_seq OWNED BY public.nway_fs_gateway_group_map.id;
            public       postgres    false    213            ?            1259    62355 !   nway_call_ivr_menu_options_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_call_ivr_menu_options_id_seq
    START WITH 52
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.nway_call_ivr_menu_options_id_seq;
       public       postgres    false    3            ?            1259    62357    nway_call_ivr_menu_options    TABLE     >  CREATE TABLE public.nway_call_ivr_menu_options (
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
 .   DROP TABLE public.nway_call_ivr_menu_options;
       public         postgres    false    214    3            ?           0    0 .   COLUMN nway_call_ivr_menu_options.external_uri    COMMENT     ?  COMMENT ON COLUMN public.nway_call_ivr_menu_options.external_uri IS '外部操作的url,当ivr_menu_option_digits 为空时有效，自动将主叫  caller_number=xxx,dtmf=xxx,uuid=xxx  等消息发给url，等待url的返回值后执行，如hangup,挂机，playring,放音，dtmf+彩铃+按键长度  为获取按键 ；bridge为转接到分机，agent_group为转接到座席组，senddtmf:发送dtmf按键；';
            public       postgres    false    215            ?           0    0 .   COLUMN nway_call_ivr_menu_options.is_time_plan    COMMENT     `   COMMENT ON COLUMN public.nway_call_ivr_menu_options.is_time_plan IS '是否使用时间策略';
            public       postgres    false    215            ?           0    0 .   COLUMN nway_call_ivr_menu_options.time_plan_id    COMMENT     \   COMMENT ON COLUMN public.nway_call_ivr_menu_options.time_plan_id IS 'time plan表中的id';
            public       postgres    false    215            ?           0    0 8   COLUMN nway_call_ivr_menu_options.ivr_menu_option_action    COMMENT     [  COMMENT ON COLUMN public.nway_call_ivr_menu_options.ivr_menu_option_action IS '"menu-exit", SWITCH_IVR_ACTION_DIE}, {
	"menu-sub", SWITCH_IVR_ACTION_EXECMENU}, {
	"menu-exec-app", SWITCH_IVR_ACTION_EXECAPP}, {
	"menu-play-sound", SWITCH_IVR_ACTION_PLAYSOUND}, {
	"menu-back", SWITCH_IVR_ACTION_BACK}, {
	"menu-top", SWITCH_IVR_ACTION_TOMAIN}, {';
            public       postgres    false    215            ?            1259    62374    nway_call_ivr_menus_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_call_ivr_menus_id_seq
    START WITH 20
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.nway_call_ivr_menus_id_seq;
       public       postgres    false    3            ?            1259    62376    nway_call_ivr_menus    TABLE     ?  CREATE TABLE public.nway_call_ivr_menus (
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
 '   DROP TABLE public.nway_call_ivr_menus;
       public         postgres    false    216    3            ?           0    0 (   COLUMN nway_call_ivr_menus.ivr_menu_name    COMMENT     H   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_name IS '名称';
            public       postgres    false    217            ?           0    0 -   COLUMN nway_call_ivr_menus.ivr_menu_extension    COMMENT     w   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_extension IS '短号，每个ivr都会有一个唯一的短号';
            public       postgres    false    217            ?           0    0 1   COLUMN nway_call_ivr_menus.ivr_menu_confirm_macro    COMMENT     T   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_confirm_macro IS '确认宏';
            public       postgres    false    217            ?           0    0 /   COLUMN nway_call_ivr_menus.ivr_menu_confirm_key    COMMENT     R   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_confirm_key IS '确认键';
            public       postgres    false    217            ?           0    0 4   COLUMN nway_call_ivr_menus.ivr_menu_confirm_attempts    COMMENT     Z   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_confirm_attempts IS '尝试次数';
            public       postgres    false    217            ?           0    0 +   COLUMN nway_call_ivr_menus.ivr_menu_timeout    COMMENT     Q   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_timeout IS '超时秒数';
            public       postgres    false    217            ?           0    0 7   COLUMN nway_call_ivr_menus.ivr_menu_inter_digit_timeout    COMMENT     r   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_inter_digit_timeout IS '中间不按键时的超时时间';
            public       postgres    false    217            ?           0    0 0   COLUMN nway_call_ivr_menus.ivr_menu_max_failures    COMMENT     b   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_max_failures IS '输错ivr的最大次数';
            public       postgres    false    217            ?           0    0 0   COLUMN nway_call_ivr_menus.ivr_menu_max_timeouts    COMMENT     _   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_max_timeouts IS 'ivr最大超时次数';
            public       postgres    false    217            ?           0    0 -   COLUMN nway_call_ivr_menus.ivr_menu_digit_len    COMMENT     _   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_digit_len IS '数字按键最大长度';
            public       postgres    false    217            ?           0    0 /   COLUMN nway_call_ivr_menus.ivr_menu_description    COMMENT     O   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_description IS '说明';
            public       postgres    false    217            ?           0    0 :   COLUMN nway_call_ivr_menus.ivr_menu_nway_call_crycle_order    COMMENT     ?   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_nway_call_crycle_order IS '针对属于循环呼叫的，实时记录当前呼叫的子节点的order';
            public       postgres    false    217            ?           0    0 -   COLUMN nway_call_ivr_menus.ivr_menu_parent_id    COMMENT     e   COMMENT ON COLUMN public.nway_call_ivr_menus.ivr_menu_parent_id IS '父节点，用于多层ivr中';
            public       postgres    false    217            ?            1259    62406    nway_call_operation    TABLE     ?   CREATE TABLE public.nway_call_operation (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    category character varying(50) DEFAULT 'dialplan'::character varying
);
 '   DROP TABLE public.nway_call_operation;
       public         postgres    false    3            ?           0    0 #   COLUMN nway_call_operation.category    COMMENT     O   COMMENT ON COLUMN public.nway_call_operation.category IS 'dialplan或ivrmenu';
            public       postgres    false    218            ?            1259    62413    nway_call_operation_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_call_operation_id_seq
    START WITH 7
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.nway_call_operation_id_seq;
       public       postgres    false    3            ?            1259    62415    nway_call_pg_cdr_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_call_pg_cdr_id_seq
    START WITH 1525182
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.nway_call_pg_cdr_id_seq;
       public       postgres    false    3            ?            1259    62417    nway_call_pg_cdr    TABLE     ?  CREATE TABLE public.nway_call_pg_cdr (
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
 $   DROP TABLE public.nway_call_pg_cdr;
       public         postgres    false    220    3            ?           0    0 #   COLUMN nway_call_pg_cdr.dialplan_id    COMMENT     E   COMMENT ON COLUMN public.nway_call_pg_cdr.dialplan_id IS '路由id';
            public       postgres    false    221            ?            1259    62444    nway_call_rings_id_seq    SEQUENCE        CREATE SEQUENCE public.nway_call_rings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.nway_call_rings_id_seq;
       public       postgres    false    3            ?            1259    62446    nway_call_rings    TABLE     w  CREATE TABLE public.nway_call_rings (
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
 #   DROP TABLE public.nway_call_rings;
       public         postgres    false    222    3            ?           0    0 $   COLUMN nway_call_rings.ring_category    COMMENT     h   COMMENT ON COLUMN public.nway_call_rings.ring_category IS '彩铃的类型，如ivr,voicemail,等等
';
            public       postgres    false    223            ?           0    0 !   COLUMN nway_call_rings.local_path    COMMENT     P   COMMENT ON COLUMN public.nway_call_rings.local_path IS 'web本地缓存路径';
            public       postgres    false    223            ?            1259    62453    nway_ext_group_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.nway_ext_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.nway_ext_group_id_seq;
       public       postgres    false    3            ?            1259    62455    nway_ext_group    TABLE     8  CREATE TABLE public.nway_ext_group (
    id bigint DEFAULT nextval('public.nway_ext_group_id_seq'::regclass) NOT NULL,
    group_name character varying(100),
    group_number character varying(50),
    current_ext_number character varying(50),
    domain_id bigint DEFAULT 1,
    queue_mode integer DEFAULT 0
);
 "   DROP TABLE public.nway_ext_group;
       public         postgres    false    224    3            ?           0    0    TABLE nway_ext_group    COMMENT     O   COMMENT ON TABLE public.nway_ext_group IS '分机座席分组，面向业务';
            public       postgres    false    225            ?           0    0     COLUMN nway_ext_group.group_name    COMMENT     L   COMMENT ON COLUMN public.nway_ext_group.group_name IS '组或座席组名';
            public       postgres    false    225            ?           0    0 "   COLUMN nway_ext_group.group_number    COMMENT     K   COMMENT ON COLUMN public.nway_ext_group.group_number IS '座席组短号';
            public       postgres    false    225            ?           0    0 (   COLUMN nway_ext_group.current_ext_number    COMMENT     ?   COMMENT ON COLUMN public.nway_ext_group.current_ext_number IS '当前组里接听时找到的分机，如果找不到，则再从头开始';
            public       postgres    false    225            ?           0    0     COLUMN nway_ext_group.queue_mode    COMMENT     ?   COMMENT ON COLUMN public.nway_ext_group.queue_mode IS '排队模式,0,顺序；1,随机; 2,循环; 3,记忆顺序; 4,记忆随机；5，记忆循环';
            public       postgres    false    225            ?            1259    62461    nway_ext_group_map_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_ext_group_map_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.nway_ext_group_map_id_seq;
       public       postgres    false    3            ?            1259    62463    nway_ext_group_map    TABLE     ?   CREATE TABLE public.nway_ext_group_map (
    id bigint DEFAULT nextval('public.nway_ext_group_map_id_seq'::regclass) NOT NULL,
    ext_group_id bigint,
    ext_group_number character varying(50),
    ext character varying(50)
);
 &   DROP TABLE public.nway_ext_group_map;
       public         postgres    false    226    3            ?           0    0 &   COLUMN nway_ext_group_map.ext_group_id    COMMENT     K   COMMENT ON COLUMN public.nway_ext_group_map.ext_group_id IS '分机组id';
            public       postgres    false    227            ?           0    0 *   COLUMN nway_ext_group_map.ext_group_number    COMMENT     S   COMMENT ON COLUMN public.nway_ext_group_map.ext_group_number IS '座席组号码';
            public       postgres    false    227            ?           0    0    COLUMN nway_ext_group_map.ext    COMMENT     =   COMMENT ON COLUMN public.nway_ext_group_map.ext IS '分机';
            public       postgres    false    227            ?            1259    62467    nway_extension_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_extension_id_seq
    START WITH 9063
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.nway_extension_id_seq;
       public       postgres    false    3            ?            1259    62469    nway_extension    TABLE     ?  CREATE TABLE public.nway_extension (
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
 "   DROP TABLE public.nway_extension;
       public         postgres    false    228    3            ?           0    0 $   COLUMN nway_extension.extension_name    COMMENT     J   COMMENT ON COLUMN public.nway_extension.extension_name IS '分机名称';
            public       postgres    false    229            ?           0    0 &   COLUMN nway_extension.extension_number    COMMENT     L   COMMENT ON COLUMN public.nway_extension.extension_number IS '分机号码';
            public       postgres    false    229            ?           0    0 $   COLUMN nway_extension.callout_number    COMMENT     P   COMMENT ON COLUMN public.nway_extension.callout_number IS '外呼时的号码';
            public       postgres    false    229            ?           0    0 $   COLUMN nway_extension.extension_type    COMMENT     J   COMMENT ON COLUMN public.nway_extension.extension_type IS '分机类型';
            public       postgres    false    229            ?           0    0 )   COLUMN nway_extension.extension_reg_state    COMMENT     O   COMMENT ON COLUMN public.nway_extension.extension_reg_state IS '注册状态';
            public       postgres    false    229            ?           0    0 %   COLUMN nway_extension.callout_gateway    COMMENT     K   COMMENT ON COLUMN public.nway_extension.callout_gateway IS '出局网关';
            public       postgres    false    229            ?           0    0    COLUMN nway_extension.is_record    COMMENT     E   COMMENT ON COLUMN public.nway_extension.is_record IS '是否录音';
            public       postgres    false    229            ?           0    0 *   COLUMN nway_extension.answer_without_state    COMMENT     ?   COMMENT ON COLUMN public.nway_extension.answer_without_state IS '在不上线，不置闲的情况下就可以进行应答，默认是必须由客户端上线等';
            public       postgres    false    229            ?           0    0 $   COLUMN nway_extension.say_job_number    COMMENT     ?   COMMENT ON COLUMN public.nway_extension.say_job_number IS '是否要报工号，不管是与否，当answerwithoutstate为true时，它都无效，报工号时，在本工号接听时，播放工号语音';
            public       postgres    false    229            ?           0    0     COLUMN nway_extension.job_number    COMMENT     Z   COMMENT ON COLUMN public.nway_extension.job_number IS '工号，最大为40个字符串';
            public       postgres    false    229            ?           0    0    COLUMN nway_extension.reg_state    COMMENT     h   COMMENT ON COLUMN public.nway_extension.reg_state IS 'REGED ,UNREG  ,分机发register的状态记录';
            public       postgres    false    229            ?           0    0 !   COLUMN nway_extension.agent_state    COMMENT     p   COMMENT ON COLUMN public.nway_extension.agent_state IS 'up,down,座席上下线，可作为考勤的一部分';
            public       postgres    false    229            ?           0    0 "   COLUMN nway_extension.agent_status    COMMENT     ?   COMMENT ON COLUMN public.nway_extension.agent_status IS 'idle,busy,座席忙闲，如上厕所，临时开会，不能用下线';
            public       postgres    false    229            ?           0    0     COLUMN nway_extension.call_state    COMMENT     P   COMMENT ON COLUMN public.nway_extension.call_state IS 'READY,RING,TALKING,IVR';
            public       postgres    false    229            ?           0    0 &   COLUMN nway_extension.use_custom_value    COMMENT     ^   COMMENT ON COLUMN public.nway_extension.use_custom_value IS '是否要客户满意度评价';
            public       postgres    false    229            ?           0    0    COLUMN nway_extension.client_ip    COMMENT     q   COMMENT ON COLUMN public.nway_extension.client_ip IS '客户端 ip，用于mircosip自动获取帐号和密码';
            public       postgres    false    229            ?           0    0    COLUMN nway_extension.is_select    COMMENT     Q   COMMENT ON COLUMN public.nway_extension.is_select IS '是否被网关组选中';
            public       postgres    false    229            ?           0    0    COLUMN nway_extension.locked    COMMENT     u   COMMENT ON COLUMN public.nway_extension.locked IS '是否被锁定，锁定对于外呼或呼入来说不应使用';
            public       postgres    false    229            ?           0    0    COLUMN nway_extension.dnd    COMMENT     <   COMMENT ON COLUMN public.nway_extension.dnd IS '免打扰';
            public       postgres    false    229            ?           0    0 +   COLUMN nway_extension.unconditional_forward    COMMENT     ?   COMMENT ON COLUMN public.nway_extension.unconditional_forward IS '无条件转移，有号码就直接转到这个号码，如果为空就转分机';
            public       postgres    false    229                        0    0     COLUMN nway_extension.call_level    COMMENT     i   COMMENT ON COLUMN public.nway_extension.call_level IS '0内线，1市内，2国内，3国际，4禁呼';
            public       postgres    false    229                       0    0 &   COLUMN nway_extension.last_hangup_time    COMMENT     ?   COMMENT ON COLUMN public.nway_extension.last_hangup_time IS '最后挂机时间，当使用typing修改call_state时，必须要重置这项为now()';
            public       postgres    false    229                       0    0    COLUMN nway_extension.server_ip    COMMENT     ?   COMMENT ON COLUMN public.nway_extension.server_ip IS '通过哪台服务器注册的，或者说注册在哪台服务器上的';
            public       postgres    false    229            ?            1259    62511    nway_extension_type_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_extension_type_id_seq
    START WITH 7
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.nway_extension_type_id_seq;
       public       postgres    false    3            ?            1259    62513    nway_extension_type    TABLE     ?   CREATE TABLE public.nway_extension_type (
    id bigint DEFAULT nextval('public.nway_extension_type_id_seq'::regclass) NOT NULL,
    type_name character varying(50)
);
 '   DROP TABLE public.nway_extension_type;
       public         postgres    false    230    3            ?            1259    62517    nway_fs_domains    TABLE        CREATE TABLE public.nway_fs_domains (
    id bigint NOT NULL,
    domain_name character varying(255) DEFAULT ''::character varying NOT NULL,
    domain_desc character varying(500) DEFAULT ''::character varying,
    allow_ip character varying(1000) DEFAULT '0.0.0.0'::character varying
);
 #   DROP TABLE public.nway_fs_domains;
       public         postgres    false    3                       0    0    COLUMN nway_fs_domains.allow_ip    COMMENT     T   COMMENT ON COLUMN public.nway_fs_domains.allow_ip IS '允许的ip范围以,分隔';
            public       postgres    false    232            ?            1259    62526    nway_fs_domains_id_seq    SEQUENCE        CREATE SEQUENCE public.nway_fs_domains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.nway_fs_domains_id_seq;
       public       postgres    false    3    232                       0    0    nway_fs_domains_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.nway_fs_domains_id_seq OWNED BY public.nway_fs_domains.id;
            public       postgres    false    233            ?            1259    62528    nway_fs_gateway_details    TABLE       CREATE TABLE public.nway_fs_gateway_details (
    gateway_id bigint,
    gateway_key character varying(300),
    gateway_key_desc text,
    gateway_value character varying(300),
    gateway_value_option character varying(300),
    enable boolean DEFAULT true,
    id bigint NOT NULL
);
 +   DROP TABLE public.nway_fs_gateway_details;
       public         postgres    false    3                       0    0 *   COLUMN nway_fs_gateway_details.gateway_key    COMMENT     o   COMMENT ON COLUMN public.nway_fs_gateway_details.gateway_key IS 'xml中的配置对中的key,不可为中文';
            public       postgres    false    234                       0    0 /   COLUMN nway_fs_gateway_details.gateway_key_desc    COMMENT     d   COMMENT ON COLUMN public.nway_fs_gateway_details.gateway_key_desc IS 'key的描述，可为中文';
            public       postgres    false    234                       0    0 3   COLUMN nway_fs_gateway_details.gateway_value_option    COMMENT     ^   COMMENT ON COLUMN public.nway_fs_gateway_details.gateway_value_option IS 'value的可选项';
            public       postgres    false    234            ?            1259    62535    nway_fs_gateway_details_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_fs_gateway_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.nway_fs_gateway_details_id_seq;
       public       postgres    false    234    3                       0    0    nway_fs_gateway_details_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.nway_fs_gateway_details_id_seq OWNED BY public.nway_fs_gateway_details.id;
            public       postgres    false    235            ?            1259    62537    nway_fs_gateways    TABLE     P  CREATE TABLE public.nway_fs_gateways (
    id bigint NOT NULL,
    profile_id bigint,
    gateway_name character varying(300) DEFAULT ''::character varying,
    gateway_desc text DEFAULT ''::text,
    enable boolean DEFAULT true,
    domain_id bigint DEFAULT 0,
    max_concurrent bigint DEFAULT 30,
    concurrent integer DEFAULT 0
);
 $   DROP TABLE public.nway_fs_gateways;
       public         postgres    false    3            	           0    0 $   COLUMN nway_fs_gateways.gateway_name    COMMENT     K   COMMENT ON COLUMN public.nway_fs_gateways.gateway_name IS '不可中文 ';
            public       postgres    false    236            
           0    0 $   COLUMN nway_fs_gateways.gateway_desc    COMMENT     Y   COMMENT ON COLUMN public.nway_fs_gateways.gateway_desc IS '备注，可以使用中文';
            public       postgres    false    236                       0    0 "   COLUMN nway_fs_gateways.concurrent    COMMENT     Z   COMMENT ON COLUMN public.nway_fs_gateways.concurrent IS '当前呼入呼出的并发数';
            public       postgres    false    236            ?            1259    62549    nway_fs_gateways_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_fs_gateways_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.nway_fs_gateways_id_seq;
       public       postgres    false    3    236                       0    0    nway_fs_gateways_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.nway_fs_gateways_id_seq OWNED BY public.nway_fs_gateways.id;
            public       postgres    false    237            ?            1259    62551    nway_fs_heartbeat_history    TABLE       CREATE TABLE public.nway_fs_heartbeat_history (
    id bigint NOT NULL,
    node_ip character varying(200),
    sip_result character varying(200) DEFAULT 'successed'::character varying,
    check_time timestamp without time zone DEFAULT now(),
    cpu_used character varying(50) DEFAULT ''::character varying,
    mem_used character varying(50) DEFAULT ''::character varying,
    disk_used character varying(50) DEFAULT ''::character varying,
    network_used character varying(50) DEFAULT ''::character varying
);
 -   DROP TABLE public.nway_fs_heartbeat_history;
       public         postgres    false    3                       0    0    TABLE nway_fs_heartbeat_history    COMMENT     N   COMMENT ON TABLE public.nway_fs_heartbeat_history IS '心跳检测的日志';
            public       postgres    false    238                       0    0 (   COLUMN nway_fs_heartbeat_history.node_ip    COMMENT     J   COMMENT ON COLUMN public.nway_fs_heartbeat_history.node_ip IS '节点ip';
            public       postgres    false    238                       0    0 +   COLUMN nway_fs_heartbeat_history.sip_result    COMMENT     W   COMMENT ON COLUMN public.nway_fs_heartbeat_history.sip_result IS '心跳返回结果';
            public       postgres    false    238                       0    0 +   COLUMN nway_fs_heartbeat_history.check_time    COMMENT     W   COMMENT ON COLUMN public.nway_fs_heartbeat_history.check_time IS '检查心跳时间';
            public       postgres    false    238                       0    0 )   COLUMN nway_fs_heartbeat_history.cpu_used    COMMENT     U   COMMENT ON COLUMN public.nway_fs_heartbeat_history.cpu_used IS 'cpu使用百分比';
            public       postgres    false    238            ?            1259    62563     nway_fs_heartbeat_history_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_fs_heartbeat_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.nway_fs_heartbeat_history_id_seq;
       public       postgres    false    3    238                       0    0     nway_fs_heartbeat_history_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.nway_fs_heartbeat_history_id_seq OWNED BY public.nway_fs_heartbeat_history.id;
            public       postgres    false    239            ?            1259    62565    nway_fs_node    TABLE     $  CREATE TABLE public.nway_fs_node (
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
     DROP TABLE public.nway_fs_node;
       public         postgres    false    3                       0    0    TABLE nway_fs_node    COMMENT     =   COMMENT ON TABLE public.nway_fs_node IS 'fs的节点信息';
            public       postgres    false    240                       0    0    COLUMN nway_fs_node.node_name    COMMENT     C   COMMENT ON COLUMN public.nway_fs_node.node_name IS '节点名称';
            public       postgres    false    240                       0    0    COLUMN nway_fs_node.operate_ip    COMMENT     |   COMMENT ON COLUMN public.nway_fs_node.operate_ip IS '操作ip,实际ip，vip不能算，这里用于一些常用的配置';
            public       postgres    false    240                       0    0     COLUMN nway_fs_node.operate_port    COMMENT     F   COMMENT ON COLUMN public.nway_fs_node.operate_port IS '操作端口';
            public       postgres    false    240                       0    0    COLUMN nway_fs_node.fs_esl_ip    COMMENT     =   COMMENT ON COLUMN public.nway_fs_node.fs_esl_ip IS 'esl ip';
            public       postgres    false    240                       0    0    COLUMN nway_fs_node.fs_esl_port    COMMENT     D   COMMENT ON COLUMN public.nway_fs_node.fs_esl_port IS 'fs_esl_port';
            public       postgres    false    240                       0    0    COLUMN nway_fs_node.meminfo    COMMENT     A   COMMENT ON COLUMN public.nway_fs_node.meminfo IS '备注信息';
            public       postgres    false    240                       0    0    COLUMN nway_fs_node.external_ip    COMMENT     ?   COMMENT ON COLUMN public.nway_fs_node.external_ip IS '通过路由器等映射 出去的ip,如果是内网中使用，则不需要管这个ip';
            public       postgres    false    240                       0    0 !   COLUMN nway_fs_node.fs_esl_secret    COMMENT     A   COMMENT ON COLUMN public.nway_fs_node.fs_esl_secret IS '密码';
            public       postgres    false    240                       0    0 "   COLUMN nway_fs_node.operate_secret    COMMENT     {   COMMENT ON COLUMN public.nway_fs_node.operate_secret IS '强制修改某些东西必须要连数据库，同时要认证';
            public       postgres    false    240                       0    0 $   COLUMN nway_fs_node.alow_system_call    COMMENT     ?   COMMENT ON COLUMN public.nway_fs_node.alow_system_call IS '是否允许系统调用，如以root运行，则可以调用所有root级的命令';
            public       postgres    false    240                       0    0 "   COLUMN nway_fs_node.heartbeat_port    COMMENT     ?   COMMENT ON COLUMN public.nway_fs_node.heartbeat_port IS '用于检测sip心跳的端口，由管理端向具体的节点发起，同时记录该节点返回值';
            public       postgres    false    240                       0    0    COLUMN nway_fs_node.enable    COMMENT     I   COMMENT ON COLUMN public.nway_fs_node.enable IS '是否启用该节点';
            public       postgres    false    240                        0    0 &   COLUMN nway_fs_node.extension_dialplan    COMMENT     m   COMMENT ON COLUMN public.nway_fs_node.extension_dialplan IS '分机内的路由以及分机对外的路由';
            public       postgres    false    240            !           0    0 #   COLUMN nway_fs_node.public_dialplan    COMMENT     s   COMMENT ON COLUMN public.nway_fs_node.public_dialplan IS '外线呼入或作为其它ippbx的gateway时的路由';
            public       postgres    false    240            "           0    0     COLUMN nway_fs_node.cdr_dbstring    COMMENT     ~   COMMENT ON COLUMN public.nway_fs_node.cdr_dbstring IS '存储cdr原始记录的数据库链接，用于cdr_pg_csv.xml中用';
            public       postgres    false    240            ?            1259    62585    nway_fs_node_global_details    TABLE     W  CREATE TABLE public.nway_fs_node_global_details (
    id bigint NOT NULL,
    node_id bigint,
    category character varying(200) DEFAULT 'global'::character varying,
    node_key character varying(50) DEFAULT ' '::character varying,
    node_value character varying(50),
    node_desc character varying(500) DEFAULT ' '::character varying
);
 /   DROP TABLE public.nway_fs_node_global_details;
       public         postgres    false    3            #           0    0 !   TABLE nway_fs_node_global_details    COMMENT     ?   COMMENT ON TABLE public.nway_fs_node_global_details IS '用于管理switch.conf.xml中的一些数据，以及vars.xml中的一些数据维护';
            public       postgres    false    241            $           0    0 +   COLUMN nway_fs_node_global_details.category    COMMENT     ?   COMMENT ON COLUMN public.nway_fs_node_global_details.category IS 'global为vars.xml中变量，switch 为switch.conf.xml中变量';
            public       postgres    false    241            ?            1259    62594 "   nway_fs_node_global_details_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_fs_node_global_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.nway_fs_node_global_details_id_seq;
       public       postgres    false    3    241            %           0    0 "   nway_fs_node_global_details_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.nway_fs_node_global_details_id_seq OWNED BY public.nway_fs_node_global_details.id;
            public       postgres    false    242            ?            1259    62596    nway_fs_node_id_seq    SEQUENCE     |   CREATE SEQUENCE public.nway_fs_node_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.nway_fs_node_id_seq;
       public       postgres    false    3    240            &           0    0    nway_fs_node_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.nway_fs_node_id_seq OWNED BY public.nway_fs_node.id;
            public       postgres    false    243            ?            1259    62598    nway_fs_profile_details    TABLE     ?  CREATE TABLE public.nway_fs_profile_details (
    id bigint NOT NULL,
    profile_id bigint DEFAULT 0,
    profile_key character varying(300) DEFAULT ''::character varying,
    profile_value character varying(300) DEFAULT ''::character varying,
    enable boolean DEFAULT true,
    profile_value_options character varying(300) DEFAULT ''::character varying,
    profile_key_desc text
);
 +   DROP TABLE public.nway_fs_profile_details;
       public         postgres    false    3            '           0    0 *   COLUMN nway_fs_profile_details.profile_key    COMMENT     k   COMMENT ON COLUMN public.nway_fs_profile_details.profile_key IS '在xml中的key value配置对中的key';
            public       postgres    false    244            ?            1259    62609    nway_fs_profile_details_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_fs_profile_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.nway_fs_profile_details_id_seq;
       public       postgres    false    3    244            (           0    0    nway_fs_profile_details_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.nway_fs_profile_details_id_seq OWNED BY public.nway_fs_profile_details.id;
            public       postgres    false    245            ?            1259    62611    nway_fs_profiles    TABLE     G  CREATE TABLE public.nway_fs_profiles (
    id bigint NOT NULL,
    node_id bigint DEFAULT 0,
    profile_name character varying(255) DEFAULT ''::character varying,
    profile_desc text DEFAULT ''::text,
    enable boolean DEFAULT true,
    is_internal boolean DEFAULT true,
    load_internal_user_file boolean DEFAULT true
);
 $   DROP TABLE public.nway_fs_profiles;
       public         postgres    false    3            )           0    0 $   COLUMN nway_fs_profiles.profile_name    COMMENT     V   COMMENT ON COLUMN public.nway_fs_profiles.profile_name IS '名称，只能用英文';
            public       postgres    false    246            *           0    0 $   COLUMN nway_fs_profiles.profile_desc    COMMENT     ^   COMMENT ON COLUMN public.nway_fs_profiles.profile_desc IS 'profile说明，可以有中文 ';
            public       postgres    false    246            +           0    0 #   COLUMN nway_fs_profiles.is_internal    COMMENT     ?   COMMENT ON COLUMN public.nway_fs_profiles.is_internal IS '是否为internal的profile，如果是，则没有gateway,但是会有user,如果为否，则会有gateway,没有user';
            public       postgres    false    246            ,           0    0 /   COLUMN nway_fs_profiles.load_internal_user_file    COMMENT       COMMENT ON COLUMN public.nway_fs_profiles.load_internal_user_file IS '当is_internal为true时，此值才会有效，当为true时，将把user按文件一次性加载，如果禁某个分机，则需要重新scan internal profile，否则使用nway_pbx_auth注册';
            public       postgres    false    246            ?            1259    62623    nway_fs_profiles_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_fs_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.nway_fs_profiles_id_seq;
       public       postgres    false    3    246            -           0    0    nway_fs_profiles_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.nway_fs_profiles_id_seq OWNED BY public.nway_fs_profiles.id;
            public       postgres    false    247            ?            1259    62625    nway_manager_users    TABLE     ?  CREATE TABLE public.nway_manager_users (
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
 &   DROP TABLE public.nway_manager_users;
       public         postgres    false    3            .           0    0    TABLE nway_manager_users    COMMENT     J   COMMENT ON TABLE public.nway_manager_users IS '用于管理员的帐户';
            public       postgres    false    248            /           0    0 #   COLUMN nway_manager_users.domain_id    COMMENT     ?   COMMENT ON COLUMN public.nway_manager_users.domain_id IS '创建了domain的话，是domain管理员，如果是0，则是全局系统管理员';
            public       postgres    false    248            0           0    0 %   COLUMN nway_manager_users.login_times    COMMENT     N   COMMENT ON COLUMN public.nway_manager_users.login_times IS '登录的次数';
            public       postgres    false    248            1           0    0 #   COLUMN nway_manager_users.real_name    COMMENT     U   COMMENT ON COLUMN public.nway_manager_users.real_name IS '用户名，可为中文';
            public       postgres    false    248            2           0    0     COLUMN nway_manager_users.mobile    COMMENT     I   COMMENT ON COLUMN public.nway_manager_users.mobile IS '管理员手机';
            public       postgres    false    248            ?            1259    62634    nway_manager_users_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_manager_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.nway_manager_users_id_seq;
       public       postgres    false    3    248            3           0    0    nway_manager_users_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.nway_manager_users_id_seq OWNED BY public.nway_manager_users.id;
            public       postgres    false    249                       1259    63358    nway_time_plan_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.nway_time_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.nway_time_plan_id_seq;
       public       postgres    false    3                       1259    63360    nway_time_plan    TABLE     ?   CREATE TABLE public.nway_time_plan (
    id bigint DEFAULT nextval('public.nway_time_plan_id_seq'::regclass) NOT NULL,
    plan_name character varying(100) DEFAULT ''::character varying NOT NULL,
    plan_desc text,
    node_id bigint
);
 "   DROP TABLE public.nway_time_plan;
       public         postgres    false    271    3                       1259    63370    nway_time_plan_detail_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_time_plan_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.nway_time_plan_detail_id_seq;
       public       postgres    false    3                       1259    63372    nway_time_plan_detail    TABLE     ?  CREATE TABLE public.nway_time_plan_detail (
    id bigint DEFAULT nextval('public.nway_time_plan_detail_id_seq'::regclass) NOT NULL,
    week_time character varying(50),
    time_name character varying(255),
    disable_days text,
    start_time character varying(50),
    stop_time character varying(50),
    is_usualy boolean DEFAULT true,
    custom_day character varying(100) DEFAULT ''::character varying,
    time_plan_id bigint DEFAULT 0
);
 )   DROP TABLE public.nway_time_plan_detail;
       public         postgres    false    273    3            4           0    0    TABLE nway_time_plan_detail    COMMENT     ?   COMMENT ON TABLE public.nway_time_plan_detail IS '时间策略，用于工作时间和休假时间，不同组可以不同的时间策略';
            public       postgres    false    274            5           0    0    COLUMN nway_time_plan_detail.id    COMMENT     ;   COMMENT ON COLUMN public.nway_time_plan_detail.id IS 'id';
            public       postgres    false    274            6           0    0 &   COLUMN nway_time_plan_detail.week_time    COMMENT     \   COMMENT ON COLUMN public.nway_time_plan_detail.week_time IS '1-7的工作日，用,分开';
            public       postgres    false    274            7           0    0 &   COLUMN nway_time_plan_detail.time_name    COMMENT     ^   COMMENT ON COLUMN public.nway_time_plan_detail.time_name IS '对这个时间策略取个名';
            public       postgres    false    274            8           0    0 )   COLUMN nway_time_plan_detail.disable_days    COMMENT     ?   COMMENT ON COLUMN public.nway_time_plan_detail.disable_days IS '禁止日期，如 2022-03-22, 2022-05-01,主要用于节假日';
            public       postgres    false    274            9           0    0 '   COLUMN nway_time_plan_detail.start_time    COMMENT     ]   COMMENT ON COLUMN public.nway_time_plan_detail.start_time IS '开始时间，如 09:00:00 ';
            public       postgres    false    274            :           0    0 &   COLUMN nway_time_plan_detail.stop_time    COMMENT     Z   COMMENT ON COLUMN public.nway_time_plan_detail.stop_time IS '结束时间，如18:00:00';
            public       postgres    false    274                       1259    63231    nway_vip_number_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.nway_vip_number_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 123456789
    CACHE 1;
 -   DROP SEQUENCE public.nway_vip_number_id_seq;
       public       postgres    false    3                       1259    63233    nway_vip_number    TABLE     ?   CREATE TABLE public.nway_vip_number (
    id bigint DEFAULT nextval('public.nway_vip_number_id_seq'::regclass) NOT NULL,
    phone_number character varying(50),
    group_number character varying(50),
    domain_id bigint DEFAULT 0
);
 #   DROP TABLE public.nway_vip_number;
       public         postgres    false    263    3            ;           0    0 #   COLUMN nway_vip_number.phone_number    COMMENT     C   COMMENT ON COLUMN public.nway_vip_number.phone_number IS '号码';
            public       postgres    false    264            <           0    0 #   COLUMN nway_vip_number.group_number    COMMENT     L   COMMENT ON COLUMN public.nway_vip_number.group_number IS '属于哪个组';
            public       postgres    false    264            ?            1259    62644    t_role    TABLE     ?   CREATE TABLE public.t_role (
    id bigint NOT NULL,
    role_name character varying(50),
    description character varying(200),
    create_time timestamp without time zone,
    updatetime timestamp without time zone
);
    DROP TABLE public.t_role;
       public         postgres    false    3            ?            1259    62647    t_role_id_seq    SEQUENCE     v   CREATE SEQUENCE public.t_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.t_role_id_seq;
       public       postgres    false    3    250            =           0    0    t_role_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.t_role_id_seq OWNED BY public.t_role.id;
            public       postgres    false    251            ?            1259    62649    t_role_perm    TABLE     d   CREATE TABLE public.t_role_perm (
    id bigint NOT NULL,
    role_id bigint,
    perm_id bigint
);
    DROP TABLE public.t_role_perm;
       public         postgres    false    3            ?            1259    62652    t_role_perm_id_seq    SEQUENCE     {   CREATE SEQUENCE public.t_role_perm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.t_role_perm_id_seq;
       public       postgres    false    3    252            >           0    0    t_role_perm_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.t_role_perm_id_seq OWNED BY public.t_role_perm.id;
            public       postgres    false    253            ?            1259    62654    t_user    TABLE     ?  CREATE TABLE public.t_user (
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
    DROP TABLE public.t_user;
       public         postgres    false    3            ?            1259    62660    t_user_id_seq    SEQUENCE     v   CREATE SEQUENCE public.t_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.t_user_id_seq;
       public       postgres    false    3    254            ?           0    0    t_user_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.t_user_id_seq OWNED BY public.t_user.id;
            public       postgres    false    255                        1259    62662    t_user_role    TABLE     d   CREATE TABLE public.t_user_role (
    id bigint NOT NULL,
    user_id bigint,
    role_id bigint
);
    DROP TABLE public.t_user_role;
       public         postgres    false    3                       1259    62665    t_user_role_id_seq    SEQUENCE     {   CREATE SEQUENCE public.t_user_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.t_user_role_id_seq;
       public       postgres    false    3    256            @           0    0    t_user_role_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.t_user_role_id_seq OWNED BY public.t_user_role.id;
            public       postgres    false    257                       1259    62667    wx_user    TABLE     G   CREATE TABLE public.wx_user (
    user_name text,
    password text
);
    DROP TABLE public.wx_user;
       public         postgres    false    3            Q           2604    62673    nway_fs_domains id    DEFAULT     x   ALTER TABLE ONLY public.nway_fs_domains ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_domains_id_seq'::regclass);
 A   ALTER TABLE public.nway_fs_domains ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    233    232            S           2604    62674    nway_fs_gateway_details id    DEFAULT     ?   ALTER TABLE ONLY public.nway_fs_gateway_details ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_gateway_details_id_seq'::regclass);
 I   ALTER TABLE public.nway_fs_gateway_details ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    235    234            ?           2604    62675    nway_fs_gateway_group id    DEFAULT     ?   ALTER TABLE ONLY public.nway_fs_gateway_group ALTER COLUMN id SET DEFAULT nextval('public.nway_call_gateway_group_id_seq'::regclass);
 G   ALTER TABLE public.nway_fs_gateway_group ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    211    210            ?           2604    62676    nway_fs_gateway_group_map id    DEFAULT     ?   ALTER TABLE ONLY public.nway_fs_gateway_group_map ALTER COLUMN id SET DEFAULT nextval('public.nway_call_gateway_group_map_id_seq'::regclass);
 K   ALTER TABLE public.nway_fs_gateway_group_map ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    213    212            Z           2604    62677    nway_fs_gateways id    DEFAULT     z   ALTER TABLE ONLY public.nway_fs_gateways ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_gateways_id_seq'::regclass);
 B   ALTER TABLE public.nway_fs_gateways ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    237    236            a           2604    62678    nway_fs_heartbeat_history id    DEFAULT     ?   ALTER TABLE ONLY public.nway_fs_heartbeat_history ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_heartbeat_history_id_seq'::regclass);
 K   ALTER TABLE public.nway_fs_heartbeat_history ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    239    238            p           2604    62679    nway_fs_node id    DEFAULT     r   ALTER TABLE ONLY public.nway_fs_node ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_node_id_seq'::regclass);
 >   ALTER TABLE public.nway_fs_node ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    243    240            t           2604    62680    nway_fs_node_global_details id    DEFAULT     ?   ALTER TABLE ONLY public.nway_fs_node_global_details ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_node_global_details_id_seq'::regclass);
 M   ALTER TABLE public.nway_fs_node_global_details ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    242    241            z           2604    62681    nway_fs_profile_details id    DEFAULT     ?   ALTER TABLE ONLY public.nway_fs_profile_details ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_profile_details_id_seq'::regclass);
 I   ALTER TABLE public.nway_fs_profile_details ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    245    244            ?           2604    62682    nway_fs_profiles id    DEFAULT     z   ALTER TABLE ONLY public.nway_fs_profiles ALTER COLUMN id SET DEFAULT nextval('public.nway_fs_profiles_id_seq'::regclass);
 B   ALTER TABLE public.nway_fs_profiles ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    247    246            ?           2604    62683    nway_manager_users id    DEFAULT     ~   ALTER TABLE ONLY public.nway_manager_users ALTER COLUMN id SET DEFAULT nextval('public.nway_manager_users_id_seq'::regclass);
 D   ALTER TABLE public.nway_manager_users ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    249    248            ?           2604    62685 	   t_role id    DEFAULT     f   ALTER TABLE ONLY public.t_role ALTER COLUMN id SET DEFAULT nextval('public.t_role_id_seq'::regclass);
 8   ALTER TABLE public.t_role ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    251    250            ?           2604    62686    t_role_perm id    DEFAULT     p   ALTER TABLE ONLY public.t_role_perm ALTER COLUMN id SET DEFAULT nextval('public.t_role_perm_id_seq'::regclass);
 =   ALTER TABLE public.t_role_perm ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    253    252            ?           2604    62687 	   t_user id    DEFAULT     f   ALTER TABLE ONLY public.t_user ALTER COLUMN id SET DEFAULT nextval('public.t_user_id_seq'::regclass);
 8   ALTER TABLE public.t_user ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    255    254            ?           2604    62688    t_user_role id    DEFAULT     p   ALTER TABLE ONLY public.t_user_role ALTER COLUMN id SET DEFAULT nextval('public.t_user_role_id_seq'::regclass);
 =   ALTER TABLE public.t_user_role ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    257    256            R          0    62277    call_blacklist 
   TABLE DATA               v   COPY public.call_blacklist (id, category, call_number, dest_number, group_number, domain_id, expire_time) FROM stdin;
    public       postgres    false    197   ??      ?          0    63217    nway_acl 
   TABLE DATA               G   COPY public.nway_acl (id, node_id, acl_name, default_type) FROM stdin;
    public       postgres    false    260   ??      ?          0    63225    nway_acl_detail 
   TABLE DATA               U   COPY public.nway_acl_detail (id, acl_type, is_domain, acl_value, acl_id) FROM stdin;
    public       postgres    false    262   ??      ?          0    63309    nway_area_plan 
   TABLE DATA               X   COPY public.nway_area_plan (id, plan_name, plan_desc, node_id, district_no) FROM stdin;
    public       postgres    false    269   ?      ?          0    63319    nway_area_plan_detail 
   TABLE DATA               N   COPY public.nway_area_plan_detail (id, district_no, area_plan_id) FROM stdin;
    public       postgres    false    270   z?      Z          0    62299    nway_base_mobile_location 
   TABLE DATA               N   COPY public.nway_base_mobile_location (no, location, district_no) FROM stdin;
    public       postgres    false    205   ??      ?          0    63239    nway_black_number 
   TABLE DATA               c   COPY public.nway_black_number (id, phone_number, group_number, expire_time, domain_id) FROM stdin;
    public       postgres    false    266   ??      \          0    62304    nway_call_dialplan_details 
   TABLE DATA               b  COPY public.nway_call_dialplan_details (id, dialplan_id, dialplan_detail_tag, dialplan_detail_data, dialplan_detail_inline, dialplan_detail_break, dialplan_detail_type_id, ring_id, outline_gateway, orderid, is_callout, gateway_group_id, enable_area_route, area_district_no, external_uri, is_timeplan, time_plan_id, dialplan_detail_type_name) FROM stdin;
    public       postgres    false    207   ??      ^          0    62325    nway_call_dialplans 
   TABLE DATA               0  COPY public.nway_call_dialplans (id, dialplan_name, dialplan_context, dialplan_number, dialplan_order, dialplan_description, dialplan_enabled, dialplan_continue, is_nway_call_outline, domain_id, use_time_plan, destination_number, source, network_addr, caller_id_number, node_id, save_to_xml) FROM stdin;
    public       postgres    false    209   ??      d          0    62357    nway_call_ivr_menu_options 
   TABLE DATA               ]  COPY public.nway_call_ivr_menu_options (id, ivr_menu_id, ivr_menu_option_digits, ivr_menu_option_param, ivr_menu_option_order, ivr_menu_option_description, ivr_menu_option_action_id, ring_id, is_callout, gateway_id, gateway_group_id, enable_area_route, area_district_no, external_uri, is_time_plan, time_plan_id, ivr_menu_option_action) FROM stdin;
    public       postgres    false    215   ~?      f          0    62376    nway_call_ivr_menus 
   TABLE DATA               l  COPY public.nway_call_ivr_menus (id, ivr_menu_name, ivr_menu_extension, ivr_menu_confirm_macro, ivr_menu_confirm_key, ivr_menu_confirm_attempts, ivr_menu_timeout, ivr_menu_exit_data, ivr_menu_inter_digit_timeout, ivr_menu_max_failures, ivr_menu_max_timeouts, ivr_menu_digit_len, ivr_menu_direct_dial, ivr_menu_cid_prefix, ivr_menu_description, ivr_menu_nway_call_crycle_order, ivr_menu_enabled, ivr_menu_nway_call_order_id, ivr_menu_greet_long_id, ivr_menu_greet_short_id, ivr_menu_invalid_sound_id, ivr_menu_exit_sound_id, ivr_menu_ringback_id, ivr_menu_exit_app_id, ivr_menu_parent_id, node_id, domain_id) FROM stdin;
    public       postgres    false    217   ?      g          0    62406    nway_call_operation 
   TABLE DATA               N   COPY public.nway_call_operation (id, name, description, category) FROM stdin;
    public       postgres    false    218   ??      j          0    62417    nway_call_pg_cdr 
   TABLE DATA               ?  COPY public.nway_call_pg_cdr (id, local_ip_v4, caller_id_name, caller_id_number, outbound_caller_id_number, destination_number, context, start_stamp, answer_stamp, end_stamp, duration, billsec, hangup_cause, uuid, bleg_uuid, accountcode, read_codec, write_codec, record_file, direction, sip_hangup_disposition, origination_uuid, sip_gateway_name, sip_term_status, sip_term_cause, dialplan_id, da_type, domain_id, aleg_uuid) FROM stdin;
    public       postgres    false    221   ??      l          0    62446    nway_call_rings 
   TABLE DATA               ?   COPY public.nway_call_rings (id, ring_name, ring_path, ring_description, ring_category, node_id, ring_fullpath, domain_id, local_path) FROM stdin;
    public       postgres    false    223   ??      n          0    62455    nway_ext_group 
   TABLE DATA               q   COPY public.nway_ext_group (id, group_name, group_number, current_ext_number, domain_id, queue_mode) FROM stdin;
    public       postgres    false    225   ??      p          0    62463    nway_ext_group_map 
   TABLE DATA               U   COPY public.nway_ext_group_map (id, ext_group_id, ext_group_number, ext) FROM stdin;
    public       postgres    false    227   ??      r          0    62469    nway_extension 
   TABLE DATA               s  COPY public.nway_extension (id, extension_name, extension_number, callout_number, extension_type, group_id, extension_pswd, extension_login_state, extension_reg_state, callout_gateway, is_allow_callout, is_record, answer_without_state, say_job_number, job_number, reg_state, agent_state, agent_status, call_state, lastupdatetime, core_uuid, use_custom_value, client_ip, is_register, is_select, locked, login_password, last_reg_time, dnd, unconditional_forward, call_level, follow_me, last_hangup_time, last_state_change_time, is_follow_me_callout, is_unconditional_forward_callout, use_video, server_ip, domain_id) FROM stdin;
    public       postgres    false    229   ?      t          0    62513    nway_extension_type 
   TABLE DATA               <   COPY public.nway_extension_type (id, type_name) FROM stdin;
    public       postgres    false    231   ?      u          0    62517    nway_fs_domains 
   TABLE DATA               Q   COPY public.nway_fs_domains (id, domain_name, domain_desc, allow_ip) FROM stdin;
    public       postgres    false    232   *?      w          0    62528    nway_fs_gateway_details 
   TABLE DATA               ?   COPY public.nway_fs_gateway_details (gateway_id, gateway_key, gateway_key_desc, gateway_value, gateway_value_option, enable, id) FROM stdin;
    public       postgres    false    234   ??      _          0    62343    nway_fs_gateway_group 
   TABLE DATA               ^   COPY public.nway_fs_gateway_group (id, gateway_group_name, domain_id, profile_id) FROM stdin;
    public       postgres    false    210   g?      a          0    62350    nway_fs_gateway_group_map 
   TABLE DATA               U   COPY public.nway_fs_gateway_group_map (id, gateway_id, gateway_group_id) FROM stdin;
    public       postgres    false    212   ??      y          0    62537    nway_fs_gateways 
   TABLE DATA               ?   COPY public.nway_fs_gateways (id, profile_id, gateway_name, gateway_desc, enable, domain_id, max_concurrent, concurrent) FROM stdin;
    public       postgres    false    236   ??      {          0    62551    nway_fs_heartbeat_history 
   TABLE DATA               ?   COPY public.nway_fs_heartbeat_history (id, node_ip, sip_result, check_time, cpu_used, mem_used, disk_used, network_used) FROM stdin;
    public       postgres    false    238   ??      }          0    62565    nway_fs_node 
   TABLE DATA                 COPY public.nway_fs_node (id, node_name, operate_ip, operate_port, fs_esl_ip, fs_esl_port, meminfo, external_ip, fs_esl_secret, operate_secret, alow_system_call, heartbeat_port, enable, request_url, extension_dialplan, public_dialplan, cdr_dbstring) FROM stdin;
    public       postgres    false    240   ?      ~          0    62585    nway_fs_node_global_details 
   TABLE DATA               m   COPY public.nway_fs_node_global_details (id, node_id, category, node_key, node_value, node_desc) FROM stdin;
    public       postgres    false    241   z?      ?          0    62598    nway_fs_profile_details 
   TABLE DATA               ?   COPY public.nway_fs_profile_details (id, profile_id, profile_key, profile_value, enable, profile_value_options, profile_key_desc) FROM stdin;
    public       postgres    false    244   ??      ?          0    62611    nway_fs_profiles 
   TABLE DATA               ?   COPY public.nway_fs_profiles (id, node_id, profile_name, profile_desc, enable, is_internal, load_internal_user_file) FROM stdin;
    public       postgres    false    246   ~?      ?          0    62625    nway_manager_users 
   TABLE DATA               ?   COPY public.nway_manager_users (id, domain_id, username, salt, password, create_time, last_login_time, login_times, real_name, mobile) FROM stdin;
    public       postgres    false    248   ??      ?          0    63360    nway_time_plan 
   TABLE DATA               K   COPY public.nway_time_plan (id, plan_name, plan_desc, node_id) FROM stdin;
    public       postgres    false    272   ??      ?          0    63372    nway_time_plan_detail 
   TABLE DATA               ?   COPY public.nway_time_plan_detail (id, week_time, time_name, disable_days, start_time, stop_time, is_usualy, custom_day, time_plan_id) FROM stdin;
    public       postgres    false    274   ,?      ?          0    63233    nway_vip_number 
   TABLE DATA               T   COPY public.nway_vip_number (id, phone_number, group_number, domain_id) FROM stdin;
    public       postgres    false    264   ??      ?          0    62644    t_role 
   TABLE DATA               U   COPY public.t_role (id, role_name, description, create_time, updatetime) FROM stdin;
    public       postgres    false    250   ??      ?          0    62649    t_role_perm 
   TABLE DATA               ;   COPY public.t_role_perm (id, role_id, perm_id) FROM stdin;
    public       postgres    false    252   ??      ?          0    62654    t_user 
   TABLE DATA               ?   COPY public.t_user (id, user_name, password, salt, status, create_time, last_login, update_time, email, last_ip, sex) FROM stdin;
    public       postgres    false    254   ??      ?          0    62662    t_user_role 
   TABLE DATA               ;   COPY public.t_user_role (id, user_id, role_id) FROM stdin;
    public       postgres    false    256   ??      ?          0    62667    wx_user 
   TABLE DATA               6   COPY public.wx_user (user_name, password) FROM stdin;
    public       postgres    false    258   ??      A           0    0    call_blacklist_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.call_blacklist_id_seq', 4, false);
            public       postgres    false    196            B           0    0    goadmin_menu_myid_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.goadmin_menu_myid_seq', 10, true);
            public       postgres    false    198            C           0    0    goadmin_operation_log_myid_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.goadmin_operation_log_myid_seq', 51, true);
            public       postgres    false    199            D           0    0    goadmin_permissions_myid_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.goadmin_permissions_myid_seq', 170, true);
            public       postgres    false    200            E           0    0    goadmin_roles_myid_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.goadmin_roles_myid_seq', 2, true);
            public       postgres    false    201            F           0    0    goadmin_session_myid_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.goadmin_session_myid_seq', 25, true);
            public       postgres    false    202            G           0    0    goadmin_site_myid_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.goadmin_site_myid_seq', 69, true);
            public       postgres    false    203            H           0    0    goadmin_users_myid_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.goadmin_users_myid_seq', 2, true);
            public       postgres    false    204            I           0    0    nway_acl_detail_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.nway_acl_detail_id_seq', 1, false);
            public       postgres    false    261            J           0    0    nway_acl_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.nway_acl_id_seq', 1, false);
            public       postgres    false    259            K           0    0    nway_area_plan_detail_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.nway_area_plan_detail_id_seq', 1, false);
            public       postgres    false    267            L           0    0    nway_area_plan_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.nway_area_plan_id_seq', 1, false);
            public       postgres    false    268            M           0    0    nway_black_number_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.nway_black_number_id_seq', 1, false);
            public       postgres    false    265            N           0    0 !   nway_call_dialplan_details_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.nway_call_dialplan_details_id_seq', 79, true);
            public       postgres    false    206            O           0    0    nway_call_dialplans_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.nway_call_dialplans_id_seq', 1002, true);
            public       postgres    false    208            P           0    0    nway_call_gateway_group_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.nway_call_gateway_group_id_seq', 1, false);
            public       postgres    false    211            Q           0    0 "   nway_call_gateway_group_map_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.nway_call_gateway_group_map_id_seq', 1, false);
            public       postgres    false    213            R           0    0 !   nway_call_ivr_menu_options_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.nway_call_ivr_menu_options_id_seq', 56, true);
            public       postgres    false    214            S           0    0    nway_call_ivr_menus_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.nway_call_ivr_menus_id_seq', 23, true);
            public       postgres    false    216            T           0    0    nway_call_operation_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.nway_call_operation_id_seq', 7, false);
            public       postgres    false    219            U           0    0    nway_call_pg_cdr_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.nway_call_pg_cdr_id_seq', 1525182, false);
            public       postgres    false    220            V           0    0    nway_call_rings_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.nway_call_rings_id_seq', 3, true);
            public       postgres    false    222            W           0    0    nway_ext_group_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.nway_ext_group_id_seq', 6, true);
            public       postgres    false    224            X           0    0    nway_ext_group_map_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.nway_ext_group_map_id_seq', 1, false);
            public       postgres    false    226            Y           0    0    nway_extension_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.nway_extension_id_seq', 9068, true);
            public       postgres    false    228            Z           0    0    nway_extension_type_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.nway_extension_type_id_seq', 7, false);
            public       postgres    false    230            [           0    0    nway_fs_domains_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.nway_fs_domains_id_seq', 2, true);
            public       postgres    false    233            \           0    0    nway_fs_gateway_details_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.nway_fs_gateway_details_id_seq', 17, true);
            public       postgres    false    235            ]           0    0    nway_fs_gateways_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.nway_fs_gateways_id_seq', 6, true);
            public       postgres    false    237            ^           0    0     nway_fs_heartbeat_history_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.nway_fs_heartbeat_history_id_seq', 1, false);
            public       postgres    false    239            _           0    0 "   nway_fs_node_global_details_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.nway_fs_node_global_details_id_seq', 93, true);
            public       postgres    false    242            `           0    0    nway_fs_node_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.nway_fs_node_id_seq', 8, true);
            public       postgres    false    243            a           0    0    nway_fs_profile_details_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.nway_fs_profile_details_id_seq', 1279, true);
            public       postgres    false    245            b           0    0    nway_fs_profiles_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.nway_fs_profiles_id_seq', 10, true);
            public       postgres    false    247            c           0    0    nway_manager_users_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.nway_manager_users_id_seq', 1, false);
            public       postgres    false    249            d           0    0    nway_time_plan_detail_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.nway_time_plan_detail_id_seq', 1, false);
            public       postgres    false    273            e           0    0    nway_time_plan_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.nway_time_plan_id_seq', 1, false);
            public       postgres    false    271            f           0    0    nway_vip_number_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.nway_vip_number_id_seq', 1, false);
            public       postgres    false    263            g           0    0    t_role_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.t_role_id_seq', 1, false);
            public       postgres    false    251            h           0    0    t_role_perm_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.t_role_perm_id_seq', 1, false);
            public       postgres    false    253            i           0    0    t_user_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.t_user_id_seq', 1, false);
            public       postgres    false    255            j           0    0    t_user_role_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.t_user_role_id_seq', 1, false);
            public       postgres    false    257            ?           2606    62690 "   call_blacklist PK_BLACKLIST_NUMBER 
   CONSTRAINT     k   ALTER TABLE ONLY public.call_blacklist
    ADD CONSTRAINT "PK_BLACKLIST_NUMBER" PRIMARY KEY (call_number);
 N   ALTER TABLE ONLY public.call_blacklist DROP CONSTRAINT "PK_BLACKLIST_NUMBER";
       public         postgres    false    197            ?           2606    62692 5   nway_fs_node_global_details PK_NODE_GLOBAL_DETAILS_ID 
   CONSTRAINT     u   ALTER TABLE ONLY public.nway_fs_node_global_details
    ADD CONSTRAINT "PK_NODE_GLOBAL_DETAILS_ID" PRIMARY KEY (id);
 a   ALTER TABLE ONLY public.nway_fs_node_global_details DROP CONSTRAINT "PK_NODE_GLOBAL_DETAILS_ID";
       public         postgres    false    241            ?           2606    62694    nway_fs_node PK_NODE_ID 
   CONSTRAINT     W   ALTER TABLE ONLY public.nway_fs_node
    ADD CONSTRAINT "PK_NODE_ID" PRIMARY KEY (id);
 C   ALTER TABLE ONLY public.nway_fs_node DROP CONSTRAINT "PK_NODE_ID";
       public         postgres    false    240            ?           2606    62696 "   nway_extension call_extension_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.nway_extension
    ADD CONSTRAINT call_extension_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.nway_extension DROP CONSTRAINT call_extension_pkey;
       public         postgres    false    229            ?           2606    62698 ,   nway_extension_type call_extension_type_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.nway_extension_type
    ADD CONSTRAINT call_extension_type_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.nway_extension_type DROP CONSTRAINT call_extension_type_pkey;
       public         postgres    false    231            ?           2606    62700 '   nway_call_operation call_operation_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.nway_call_operation
    ADD CONSTRAINT call_operation_pkey PRIMARY KEY (id);
 Q   ALTER TABLE ONLY public.nway_call_operation DROP CONSTRAINT call_operation_pkey;
       public         postgres    false    218            ?           2606    62702    nway_call_rings call_rings_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.nway_call_rings
    ADD CONSTRAINT call_rings_pkey PRIMARY KEY (id);
 I   ALTER TABLE ONLY public.nway_call_rings DROP CONSTRAINT call_rings_pkey;
       public         postgres    false    223            ?           2606    63326 0   nway_area_plan_detail nway_area_plan_detail_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.nway_area_plan_detail
    ADD CONSTRAINT nway_area_plan_detail_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.nway_area_plan_detail DROP CONSTRAINT nway_area_plan_detail_pkey;
       public         postgres    false    270            ?           2606    63318 "   nway_area_plan nway_area_plan_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.nway_area_plan
    ADD CONSTRAINT nway_area_plan_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.nway_area_plan DROP CONSTRAINT nway_area_plan_pkey;
       public         postgres    false    269            ?           2606    62704 :   nway_call_dialplan_details nway_call_dialplan_details_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.nway_call_dialplan_details
    ADD CONSTRAINT nway_call_dialplan_details_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.nway_call_dialplan_details DROP CONSTRAINT nway_call_dialplan_details_pkey;
       public         postgres    false    207            ?           2606    62706 ,   nway_call_dialplans nway_call_dialplans_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.nway_call_dialplans
    ADD CONSTRAINT nway_call_dialplans_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.nway_call_dialplans DROP CONSTRAINT nway_call_dialplans_pkey;
       public         postgres    false    209            ?           2606    62708 :   nway_call_ivr_menu_options nway_call_ivr_menu_options_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.nway_call_ivr_menu_options
    ADD CONSTRAINT nway_call_ivr_menu_options_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.nway_call_ivr_menu_options DROP CONSTRAINT nway_call_ivr_menu_options_pkey;
       public         postgres    false    215            ?           2606    62710 ,   nway_call_ivr_menus nway_call_ivr_menus_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.nway_call_ivr_menus
    ADD CONSTRAINT nway_call_ivr_menus_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.nway_call_ivr_menus DROP CONSTRAINT nway_call_ivr_menus_pkey;
       public         postgres    false    217            ?           2606    62712 &   nway_call_pg_cdr nway_call_pg_cdr_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.nway_call_pg_cdr
    ADD CONSTRAINT nway_call_pg_cdr_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.nway_call_pg_cdr DROP CONSTRAINT nway_call_pg_cdr_pkey;
       public         postgres    false    221            ?           2606    62714 $   nway_fs_domains nway_fs_domains_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.nway_fs_domains
    ADD CONSTRAINT nway_fs_domains_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.nway_fs_domains DROP CONSTRAINT nway_fs_domains_pkey;
       public         postgres    false    232            ?           2606    62716 *   nway_manager_users nway_manager_users_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.nway_manager_users
    ADD CONSTRAINT nway_manager_users_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.nway_manager_users DROP CONSTRAINT nway_manager_users_pkey;
       public         postgres    false    248            ?           2606    63369 "   nway_time_plan nway_time_plan_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.nway_time_plan
    ADD CONSTRAINT nway_time_plan_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.nway_time_plan DROP CONSTRAINT nway_time_plan_pkey;
       public         postgres    false    272            ?           1259    62717    BLACKLIST_NUMBER_IDX    INDEX     b   CREATE INDEX "BLACKLIST_NUMBER_IDX" ON public.call_blacklist USING btree (call_number, category);
 *   DROP INDEX public."BLACKLIST_NUMBER_IDX";
       public         postgres    false    197    197            ?           1259    62718    FKI_NODE_GLOBAL_DETAILS_NODE_ID    INDEX     l   CREATE INDEX "FKI_NODE_GLOBAL_DETAILS_NODE_ID" ON public.nway_fs_node_global_details USING btree (node_id);
 5   DROP INDEX public."FKI_NODE_GLOBAL_DETAILS_NODE_ID";
       public         postgres    false    241            ?           1259    62719    IDX_CALL_EXTENSION_EXT_NUMBER    INDEX     m   CREATE UNIQUE INDEX "IDX_CALL_EXTENSION_EXT_NUMBER" ON public.nway_extension USING btree (extension_number);
 3   DROP INDEX public."IDX_CALL_EXTENSION_EXT_NUMBER";
       public         postgres    false    229            ?           1259    62720    IDX_CALL_RINGS_MAIN    INDEX     e   CREATE INDEX "IDX_CALL_RINGS_MAIN" ON public.nway_call_rings USING btree (id, ring_name, ring_path);
 )   DROP INDEX public."IDX_CALL_RINGS_MAIN";
       public         postgres    false    223    223    223            ?           1259    62721 #   IDX_nway_call_DIALPLAN_DETAILS_MAIN    INDEX     w   CREATE INDEX "IDX_nway_call_DIALPLAN_DETAILS_MAIN" ON public.nway_call_dialplan_details USING btree (id, dialplan_id);
 9   DROP INDEX public."IDX_nway_call_DIALPLAN_DETAILS_MAIN";
       public         postgres    false    207    207            ?           1259    62722 #   IDX_nway_call_IVR_MENU_OPTIONS_MAIN    INDEX     w   CREATE INDEX "IDX_nway_call_IVR_MENU_OPTIONS_MAIN" ON public.nway_call_ivr_menu_options USING btree (id, ivr_menu_id);
 9   DROP INDEX public."IDX_nway_call_IVR_MENU_OPTIONS_MAIN";
       public         postgres    false    215    215            ?           1259    62723    NWAY_FS_NODE_INDEX_IP    INDEX     Z   CREATE INDEX "NWAY_FS_NODE_INDEX_IP" ON public.nway_fs_node USING btree (id, operate_ip);
 +   DROP INDEX public."NWAY_FS_NODE_INDEX_IP";
       public         postgres    false    240    240            ?           1259    62724     base_mobile_location_district_no    INDEX     m   CREATE INDEX base_mobile_location_district_no ON public.nway_base_mobile_location USING btree (district_no);
 4   DROP INDEX public.base_mobile_location_district_no;
       public         postgres    false    205            ?           1259    62725    base_mobile_location_no    INDEX     [   CREATE INDEX base_mobile_location_no ON public.nway_base_mobile_location USING btree (no);
 +   DROP INDEX public.base_mobile_location_no;
       public         postgres    false    205            ?           1259    62726    callee_number_index    INDEX     ^   CREATE INDEX callee_number_index ON public.nway_call_pg_cdr USING btree (destination_number);
 '   DROP INDEX public.callee_number_index;
       public         postgres    false    221            ?           1259    62727    caller_number_index    INDEX     l   CREATE INDEX caller_number_index ON public.nway_call_pg_cdr USING btree (caller_id_name, caller_id_number);
 '   DROP INDEX public.caller_number_index;
       public         postgres    false    221    221            ?           1259    62728    pg_cdr_uuid_idx    INDEX     W   CREATE INDEX pg_cdr_uuid_idx ON public.nway_call_pg_cdr USING btree (uuid, bleg_uuid);
 #   DROP INDEX public.pg_cdr_uuid_idx;
       public         postgres    false    221    221            ?           1259    62729    start_time_index    INDEX     T   CREATE INDEX start_time_index ON public.nway_call_pg_cdr USING btree (start_stamp);
 $   DROP INDEX public.start_time_index;
       public         postgres    false    221            ?           2620    62730 ,   nway_call_pg_cdr insert_tbl_nway_call_pg_cdr    TRIGGER     ?   CREATE TRIGGER insert_tbl_nway_call_pg_cdr BEFORE INSERT ON public.nway_call_pg_cdr FOR EACH ROW EXECUTE PROCEDURE public.auto_insert_into_call_pg_cdr('start_stamp');
 E   DROP TRIGGER insert_tbl_nway_call_pg_cdr ON public.nway_call_pg_cdr;
       public       postgres    false    221    287            ?           2620    62731 ;   nway_fs_heartbeat_history trigger_nway_fs_heartbeat_history    TRIGGER     ?   CREATE TRIGGER trigger_nway_fs_heartbeat_history BEFORE INSERT ON public.nway_fs_heartbeat_history FOR EACH ROW EXECUTE PROCEDURE public.auto_insert_into_nway_fs_heartbeat_history('check_time');
 T   DROP TRIGGER trigger_nway_fs_heartbeat_history ON public.nway_fs_heartbeat_history;
       public       postgres    false    238    288            R      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?   U   x????@E?5?b??{?"?1Z???nN?%??s?y?T?^??B?&lI?Z?"[ͽ???Р?C??	??i????/~	      ?      x?????? ? ?      Z      x?????? ? ?      ?      x?????? ? ?      \     x???ON? ??p????71i^[??N? ?f?a???s??F???j???t???_??????m.????	?????p A??_>_????cW?&??i;E????xx?z|&l??????i???Lhn????z6?{??? DY%
V?u?b?M8&??:A)E?6??g?	'?d??????J9?,????ϣ?0G?sp???????Wp?Z???M??u?3U?7?U0;e?p??Z^Z???o?A?E?	???8^??2?By2I???͆R????      ^   w   x?35???ON̉?΂Ҥ??dNNCN??4 4 ?8C?h??h]?XN ??,?2400?*?hMIMK,?)??4"F?1gIjq	B?!糭?/?OE?j`dhlhjn`jl ?j?????? ?D,?      d   ?   x??NK
?0]ON???L3??A?.ܤv"[J҈?7-.\I????x?&????ww?9I<????ჰ~????Kn?O?b??0G?? Q#UnG\?"6%0?-	?׋????0??*>???6?/???$????^?J?7ʘF?      f   ?   x?32?|????????eE?%??%??ʜƜ?@??i"????%?.D-8???9??Y?dG??]˟???2Mט$??? fB?j@5ː4???2????,#??2??e??iVNH?*?ƀ+F??? ?Nz      g     x?m??J?0??Oޥb?O}a?m?ҙ??u?z??:E?7Cp??u^x?ѽM??-l%e?"?}?NNN"C?;??N̗?l??Gl?)?????H@~?e???HFw!??F?CUl/???q??>+?̈0N???h???n r???X}????n!
?@?[l?û?z?????US?J?1?;`??Y?:aB??p?O???L?r???5???t?????"/~J??;?F?ӂ??(q-?X???Q??"5T???;-?Ё?q?js???>??      j      x?????? ? ?      l   ?   x????i1@?V/ci4ڑ?	W`0??????n\E\?ρ??n?????9????n>?.׏???u?<?????\gm????5y??v? ?R?T?MN?ݞ??ʬ??z??e???s==??A?iyZw??????lC|?D%??簇????d?d??_?ͮ??E?D?=?gqݤ?R??qY????????]7?[j?UJ}?b??      n   "   x?3?444 cNCNc.sNC#0r?b???? U??      p      x?????? ? ?      r   ?   x???Mj?0?ףSd"fF??!z?l??@j??&???dChB?)????4?%?? "2?? D+|wu????k??'??}???.??F??	́??L???Xڻos????f.R?
?{?R?B?'?????i?"??K?	???50??????Y??i?y??'?2h???AlH珸0q?1??p?#?L_???"޲'?THU?px ?v?V??Z)????L      t      x?????? ? ?      u   t   x?i ??1	default	默认的唯一个domain，除非需要开启多租户，则才配置添加此表	0.0.0.0
\.


A?=O      w   ?  x????J?0??O???k3??=?7?M%?&!ɘ?DDz#???p?]????.?2??[?dS??tJ/??????|1H????.??k)?en
???:Q 6???;???$٦J	??my2~?V?r??<?s??_?UW??pX^L ù"?e?4C?M??"????Rڌ?Y?2hْ?R=.????w?]?ߟ?|??iz?|????l?x?#?$?"	g??rt_?Tg???3?G?A=???)?z?Գ??tT?_nn??
Љh?C??¡?????O??I^?{3??}?4N?/?ąpMW?&LQ?,???????m??-?&??&B
??e??%~??????jB?mC?dT?????R(0I??
m??
??~cj?g??F=??Z???K?B???F+?r?-?
?.״B??_?jڶ|ժz[?????w?`      _      x?????? ? ?      a      x?????? ? ?      y   ?   x?3?44??+O???,?4?46????2?42?,I-.?|>eœ]}϶v?X?? ?ڀ+F??? ?q      {      x?????? ? ?      }   ]   x?32?,6?44?AC#NKSNC#s? ?kdȉ,??S?ꜟ??W?Xihd??Y?ij`a ?2JJ
????z???fY?6???????? ?/      ~   _  x????N?@????`???!?,?n????dM?	ɱ??I@?*A?.?"
Rӆ?UL??RH?4???EOb??/<???????Ȧ1??4Zt?<v?C???
;??/??A???C???~?%??????FV)??z??v(C?
g)?/`7Ud??%*
??????ޠy??ʿk`?S?_????????`w5???x?;???+??a|?쀑"G/?>2???M??O?ϕ???d?گ???????K?_Px?,??>?M4=?j?
?vu??ؠ??X=?4?;8}? $??qg캄?.?????vo`k3n?k>?RX
+[0?]H[w???B???v?0N}??ǰ޳??D??0ڨq????FG??C]K?)|&P6?K?)?e??Ӎ?Jd?K6????????p?܄??΢͎?ܕ?/QvȜW?	?Z&0d?????SpK?I?xB/?D?`??"U?i?1??[?s??P?1|?"[???a?<#?̤l??a?|?A?q{GE??Թ????@՚??"???5???C???y?%???9???v???-2?感`֌,R.??E?r???Pn}??Z?s![??wW6???S??????4??d?      ?   ?  x??Xmo?8???
?? w@?ջ? ???n???]?J?l6z;???+??o?e*??ùEs?gf??܋?bŸ?OyޛhopL??(AK?u?dHk(??F??B4????8&??? ????z???o??N1??f?[?n????????????֐??=)?~??^???f??
?
C.4ӛ?aM_??????????Ǯ"U?tl?+N?;O??Y??E???j/F?j??XzR?0/?I?\??&?(?Q?ȥ??@?W?$?`???????/Q? r????????Q?'k??Q??u??}S?v??a ???r???q?[&HG[?ɾV֮#?Iձ??????????OH"?0?@ǋu?h	?@?ƫi#gnu?Z??Ç????_C6/It?c?('???V׃?T?e6??lp??4r??LGJ5??|?3!?/Ld?NC߽?`c?=?(n??NC36q????$Vm-??ס?@??d???E?????s?e?q??*?U?#f???Y??K?fO???g??s`??\l ?٬)o@|???C?Խ8RQ???=TW??IѫO?	N?Xe?M?l??????b?NzA?֙6\+ⵦ?R?j??/`-=?գ?r??????<??%??~U?Вr??~)ۅ<??x:?	??t??o[???,?)ŵy"]j??4??̙^??@KE??VX?.n??41???5?-?x;?Pk????c^??-?|s~ Q|??o)ﬄl?????ilx?(؎Cu??K??&?sL??T?֤I??P??Q?=2q"?֣K?&??V0К?`?9?	:?y?5^???W֞]?;??3???ͽ`e?>P??\2_y??ۊ?O??U??t??~3η??vc[0?}????b???ЈR?#?כ??MKn*r???Hn>????Hf?ML?g'??8????A???uD?3???bͨ???	??X?\?=g?,???Ri)?????B̓??n???'?gǶ??<C???
j?"?Q?Dvk?<O??%c!PS{??Anr?ԏ???Y?:???(>@%ΌfJ-?P?4^???s;C?mLk??????D??X֩??ͥ????>?ܐ?F???9?|d?Â?v?Z9?`~?a? f??b??ń?N?
?<???.?k?c!K??Z?e?.???F??f?MBp??<
??2??|B?y?????s??Qd?%?@?{Ӯ??Z?5???n???ڠu???T?	N?F?3?????H?ɞ?`?Pd??gf?!?_Y	h1?????Mؙ?ךE????????H1R^?l?k??C??(?]?5(m?8?cM5?I??ha???+N?B??*qQ?O????r????E^?L屎-K???P??%?l3 9???e?&???7?<	?fDg<?ҳjO??????d?_x???F???K?J?i????? ?G֙NzO??9?l??.ܩ*?]+?4???C????,o????$?????s#?l???????-^0?G???EѦ???"?7?<??????g?:??=(??|?????՞??????ާU?	?Æ?O?W??????g????'(??׷??????????/a???U???9|?<??R??????M????4??ce?+h?_???????????????d?ߍ??@,V?'c:^?<5?(u0?}?߽?L?????/?w???̀?E??ؽ???ib??o?*5?O??0X?p??m
????l?????%?Ks?5?r}?%t}B~?{qon???F??M?,??Y`??u??@MV?w?a?lnyOpΝ,z^?(3?H@??2?*L6E????=??r ?l????LfɌ<????L??hopٌ?[?;ڊ?Si??????5???}K	?~?[???r????? ?0Ʌ???oy䠂?^+????,^?ѼT?Z?%?n?\D?X`j)???r	\?? ??,???d?"??????A??? ??f??a?aֹ?d^???C??????gT??wpu@????RγQ???i?#???F??I???N>?Q??E???????{??7??;%??qW?蠖?`ޱ??/?C?Tk]???qtNc?Re?F^?Xbǒ,,?L?W? a????3%2??y?"????t???G?scdިh??;`?b??=?޼y?_??,J      ?   S   x?3?4???LA.s$??	??gf^IjQ^b???3^?[?|V?Ӷ??????e??r? !P?)Hmj??%?PԂ̍???? ?+`      ?      x?????? ? ?      ?      x?3?|?}铽s?M_??id????? o?      ?   \   x?3??|:{??]m/??88,?8ͬ?8?8???ut9??8u?t?uLtL9???z?ہ$?g!??0?Aƕp?????  ?!      ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?   ?   x?}˻?0@?????@,?y8??#H,iiE?>?|=B?w:??1?d?Z???<?P)K?s[}ja{???r?]?@ $b?YGk	????89????P.??3R?^??5?Ϻ????[g???l=?|S sGc??(l      ?      x?????? ? ?      ?      x?????? ? ?     