//=== Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet   : FlexPoint
// Unit     : MMQI: Module Message Queue Interface.
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/MMQI.PAS,v 1.1 2007/05/04 14:07:55 JozuaVL Exp $
// History :
//=============================================================================

unit MMQI;

//*****************************************************************************

interface

//=============================================================================
// Variables
//=============================================================================

const
  MQOD_STRUC_ID                  = 'OD  ';
  MQOD_VERSION_1                 = 1;
  MQOD_VERSION_2                 = 2;
  MQOD_VERSION_3                 = 3;
  MQOD_CURRENT_VERSION           = 3;

  MQPMO_STRUC_ID                 = 'PMO ';
  MQPMO_VERSION_1                = 1;
  MQPMO_VERSION_2                = 2;
  MQPMO_CURRENT_VERSION          = 2;

  MQGMO_STRUC_ID                 = 'GMO ';
  MQGMO_VERSION_1                = 1;
  MQGMO_VERSION_2                = 2;
  MQGMO_VERSION_3                = 3;
  MQGMO_CURRENT_VERSION          = 3;

  MQMD_STRUC_ID                  = 'MD  ';
  MQMD_VERSION_1                 = 1;
  MQMD_VERSION_2                 = 2;
  MQMD_CURRENT_VERSION           = 2;

  MQMDE_STRUC_ID                 = 'MDE ';
  MQMDE_VERSION_2                = 2;
  MQMDE_CURRENT_VERSION          = 2;

  MQBO_STRUC_ID                  = 'BO  ';
  MQBO_VERSION_1                 = 1;
  MQBO_CURRENT_VERSION           = 1;

  MQSCO_STRUC_ID                 = 'SCO ';
  MQSCO_VERSION_1                = 1;
  MQSCO_CURRENT_VERSION          = 1;

  MQAIR_STRUC_ID                 = 'AIR ';
  MQAIR_VERSION_1                = 1;
  MQAIR_CURRENT_VERSION          = 1;

  MQCNO_STRUC_ID                 = 'CNO ';
  MQCNO_VERSION_1                = 1;
  MQCNO_VERSION_2                = 2;
  MQCNO_VERSION_3                = 3;
  MQCNO_VERSION_4                = 4;
  MQCNO_CURRENT_VERSION          = 4;

  MQRFH_STRUC_ID                 = 'RFH ';
  MQRFH_VERSION_1                = 1;
  MQRFH_VERSION_2                = 2;

  MQDH_STRUC_ID                  = 'DH  ';
  MQDH_VERSION_1                 = 1;
  MQDH_CURRENT_VERSION           = 1;

  MQDLH_STRUC_ID                 = 'DLH ';
  MQDLH_VERSION_1                = 1;
  MQDLH_CURRENT_VERSION          = 1;

  MQCIH_STRUC_ID                 = 'CIH ';
  MQCIH_VERSION_1                = 1;
  MQCIH_VERSION_2                = 2;
  MQCIH_CURRENT_VERSION          = 2;

  MQIIH_STRUC_ID                 = 'IIH ';
  MQIIH_VERSION_1                = 1;
  MQIIH_CURRENT_VERSION          = 1;

  MQRMH_STRUC_ID                 = 'RMH ';
  MQRMH_VERSION_1                = 1;
  MQRMH_CURRENT_VERSION          = 1;

  MQTM_STRUC_ID                  = 'TM  ';
  MQTM_VERSION_1                 = 1;
  MQTM_CURRENT_VERSION           = 1;

  MQTMC_STRUC_ID                 = 'TMC ';
  MQTMC_VERSION_1                = '   1';
  MQTMC_VERSION_2                = '   2';
  MQTMC_CURRENT_VERSION          = '   2';

  MQWIH_STRUC_ID                 = 'WIH ';
  MQWIH_VERSION_1                = 1;
  MQWIH_CURRENT_VERSION          = 1;

  MQXQH_STRUC_ID                 = 'XQH ';
  MQXQH_VERSION_1                = 1;
  MQXQH_CURRENT_VERSION          = 1;

{Object types}
  MQOT_Q                         = 1;
  MQOT_NAMELIST                  = 2;
  MQOT_PROCESS                   = 3;
  MQOT_STORAGE_CLASS             = 4;
  MQOT_Q_MGR                     = 5;
  MQOT_CHANNEL                   = 6;
  MQOT_AUTH_INFO                 = 7;
  MQOT_CF_STRUC                  = 10;
  MQOT_RESERVED_1                = 999;

{Connect Options}
  MQCNO_STANDARD_BINDING         = $00000000;
  MQCNO_FASTPATH_BINDING         = $00000001;
  MQCNO_HANDLE_SHARE_NONE        = $00000020;
  MQCNO_HANDLE_SHARE_BLOCK       = $00000040;
  MQCNO_HANDLE_SHARE_NO_BLOCK    = $00000080;
  MQCNO_NONE                     = $00000000;

{Open Options}
  MQOO_INPUT_AS_Q_DEF            = $00000001;
  MQOO_INPUT_SHARED              = $00000002;
  MQOO_INPUT_EXCLUSIVE           = $00000004;
  MQOO_BROWSE                    = $00000008;
  MQOO_OUTPUT                    = $00000010;
  MQOO_INQUIRE                   = $00000020;
  MQOO_SET                       = $00000040;
  MQOO_BIND_ON_OPEN              = $00004000;
  MQOO_BIND_NOT_FIXED            = $00008000;
  MQOO_BIND_AS_Q_DEF             = $00000000;
  MQOO_SAVE_ALL_CONTEXT          = $00000080;
  MQOO_PASS_IDENTITY_CONTEXT     = $00000100;
  MQOO_PASS_ALL_CONTEXT          = $00000200;
  MQOO_SET_IDENTITY_CONTEXT      = $00000400;
  MQOO_SET_ALL_CONTEXT           = $00000800;
  MQOO_ALTERNATE_USER_AUTHORITY  = $00001000;
  MQOO_FAIL_IF_QUIESCING         = $00002000;
  MQOO_RESOLVE_NAMES             = $00010000;

{Report options}
  MQRO_EXCEPTION                 = $01000000;
  MQRO_EXCEPTION_WITH_DATA       = $03000000;
  MQRO_EXCEPTION_WITH_FULL_DATA  = $07000000;
  MQRO_EXPIRATION                = $00200000;
  MQRO_EXPIRATION_WITH_DATA      = $00600000;
  MQRO_EXPIRATION_WITH_FULL_DATA = $00E00000;
  MQRO_COA                       = $00000100;
  MQRO_COA_WITH_DATA             = $00000300;
  MQRO_COA_WITH_FULL_DATA        = $00000700;
  MQRO_COD                       = $00000800;
  MQRO_COD_WITH_DATA             = $00001800;
  MQRO_COD_WITH_FULL_DATA        = $00003800;
  MQRO_PAN                       = $00000001;
  MQRO_NAN                       = $00000002;
  MQRO_NEW_MSG_ID                = $00000000;
  MQRO_PASS_MSG_ID               = $00000080;
  MQRO_COPY_MSG_ID_TO_CORREL_ID  = $00000000;
  MQRO_PASS_CORREL_ID            = $00000040;
  MQRO_DEAD_LETTER_Q             = $00000000;
  MQRO_DISCARD_MSG               = $08000000;
  MQRO_NONE                      = $00000000;

{Close options}
  MQCO_NONE                      = 0;
  MQCO_DELETE                    = 1;
  MQCO_DELETE_PURGE              = 2;

{Message types}
  MQMT_SYSTEM_FIRST              = 1;
  MQMT_REQUEST                   = 1;
  MQMT_REPLY                     = 2;
  MQMT_DATAGRAM                  = 8;
  MQMT_REPORT                    = 4;
  MQMT_MQE_FIELDS_FROM_MQE       = 112;
  MQMT_MQE_FIELDS                = 113;
  MQMT_SYSTEM_LAST               = 65535;
  MQMT_APPL_FIRST                = 65536;
  MQMT_APPL_LAST                 = 999999999;

{Expiry}
  MQEI_UNLIMITED                 = -1;

{Begin Options}
  MQBO_NONE                      = $00000000;

{Feedback values}
  MQFB_NONE                      = 0;
  MQFB_SYSTEM_FIRST              = 1;
  MQFB_QUIT                      = 256;
  MQFB_EXPIRATION                = 258;
  MQFB_COA                       = 259;
  MQFB_COD                       = 260;
  MQFB_CHANNEL_COMPLETED         = 262;
  MQFB_CHANNEL_FAIL_RETRY        = 263;
  MQFB_CHANNEL_FAIL              = 264;
  MQFB_APPL_CANNOT_BE_STARTED    = 265;
  MQFB_TM_ERROR                  = 266;
  MQFB_APPL_TYPE_ERROR           = 267;
  MQFB_STOPPED_BY_MSG_EXIT       = 268;
  MQFB_XMIT_Q_MSG_ERROR          = 271;
  MQFB_PAN                       = 275;
  MQFB_NAN                       = 276;
  MQFB_STOPPED_BY_CHAD_EXIT      = 277;
  MQFB_STOPPED_BY_PUBSUB_EXIT    = 279;
  MQFB_NOT_A_REPOSITORY_MSG      = 280;
  MQFB_BIND_OPEN_CLUSRCVR_DEL    = 281;
  MQFB_DATA_LENGTH_ZERO          = 291;
  MQFB_DATA_LENGTH_NEGATIVE      = 292;
  MQFB_DATA_LENGTH_TOO_BIG       = 293;
  MQFB_BUFFER_OVERFLOW           = 294;
  MQFB_LENGTH_OFF_BY_ONE         = 295;
  MQFB_IIH_ERROR                 = 296;
  MQFB_NOT_AUTHORIZED_FOR_IMS    = 298;
  MQFB_IMS_ERROR                 = 300;
  MQFB_IMS_FIRST                 = 301;
  MQFB_IMS_LAST                  = 399;
  MQFB_CICS_INTERNAL_ERROR       = 401;
  MQFB_CICS_NOT_AUTHORIZED       = 402;
  MQFB_CICS_BRIDGE_FAILURE       = 403;
  MQFB_CICS_CORREL_ID_ERROR      = 404;
  MQFB_CICS_CCSID_ERROR          = 405;
  MQFB_CICS_ENCODING_ERROR       = 406;
  MQFB_CICS_CIH_ERROR            = 407;
  MQFB_CICS_UOW_ERROR            = 408;
  MQFB_CICS_COMMAREA_ERROR       = 409;
  MQFB_CICS_APPL_NOT_STARTED     = 410;
  MQFB_CICS_APPL_ABENDED         = 411;
  MQFB_CICS_DLQ_ERROR            = 412;
  MQFB_CICS_UOW_BACKED_OUT       = 413;
  MQFB_SYSTEM_LAST               = 65535;
  MQFB_APPL_FIRST                = 65536;
  MQFB_APPL_LAST                 = 999999999;

{Encoding}
  MQENC_NATIVE                   = $00000222;
  MQENC_INTEGER_MASK             = $0000000F;
  MQENC_DECIMAL_MASK             = $000000F0;
  MQENC_FLOAT_MASK               = $00000F00;
  MQENC_RESERVED_MASK            = $FFFFF000;
  MQENC_INTEGER_UNDEFINED        = $00000000;
  MQENC_INTEGER_NORMAL           = $00000001;
  MQENC_INTEGER_REVERSED         = $00000002;
  MQENC_FLOAT_UNDEFINED          = $00000000;
  MQENC_FLOAT_IEEE_NORMAL        = $00000100;
  MQENC_FLOAT_IEEE_REVERSED      = $00000200;
  MQENC_FLOAT_S390               = $00000300;
  MQENC_DECIMAL_UNDEFINED        = $00000000;
  MQENC_DECIMAL_NORMAL           = $00000010;
  MQENC_DECIMAL_REVERSED         = $00000020;

{Coded Character-Set Identifiers}
  MQCCSI_UNDEFINED               = 0;
  MQCCSI_DEFAULT                 = 0;
  MQCCSI_Q_MGR                   = 0;
  MQCCSI_INHERIT                 = -2;
  MQCCSI_EMBEDDED                = -1;

{Formats}
  MQFMT_NONE                     = '        ';
  MQFMT_ADMIN                    = 'MQADMIN ';
  MQFMT_CHANNEL_COMPLETED        = 'MQCHCOM ';
  MQFMT_CICS                     = 'MQCICS  ';
  MQFMT_COMMAND_1                = 'MQCMD1  ';
  MQFMT_COMMAND_2                = 'MQCMD2  ';
  MQFMT_DEAD_LETTER_HEADER       = 'MQDEAD  ';
  MQFMT_DIST_HEADER              = 'MQHDIST ';
  MQFMT_EVENT                    = 'MQEVENT ';
  MQFMT_IMS                      = 'MQIMS   ';
  MQFMT_IMS_VAR_STRING           = 'MQIMSVS ';
  MQFMT_MD_EXTENSION             = 'MQHMDE  ';
  MQFMT_PCF                      = 'MQPCF   ';
  MQFMT_REF_MSG_HEADER           = 'MQHREF  ';
  MQFMT_RF_HEADER                = 'MQHRF   ';
  MQFMT_RF_HEADER_2              = 'MQHRF2  ';
  MQFMT_STRING                   = 'MQSTR   ';
  MQFMT_TRIGGER                  = 'MQTRIG  ';
  MQFMT_WORK_INFO_HEADER         = 'MQHWIH  ';

{Message Flags}
  MQMF_SEGMENTATION_INHIBITED     = $00000000;
  MQMF_SEGMENTATION_ALLOWED       = $00000001;
  MQMF_MSG_IN_GROUP               = $00000008;
  MQMF_LAST_MSG_IN_GROUP          = $00000010;
  MQMF_SEGMENT                    = $00000002;
  MQMF_LAST_SEGMENT               = $00000004;
  MQMF_NONE                       = $00000000;
  MQMF_REJECT_UNSUP_MASK          = $00000FFF;
  MQMF_ACCEPT_UNSUP_MASK          = $FFF00000;
  MQMF_ACCEPT_UNSUP_IF_XMIT_MASK  = $000FF000;

{Application types}
  MQAT_UNKNOWN                    = -1;
  MQAT_NO_CONTEXT                 = 0;
  MQAT_CICS                       = 1;
  MQAT_MVS                        = 2;
  MQAT_OS390                      = 2;
  MQAT_ZOS                        = 2;
  MQAT_IMS                        = 3;
  MQAT_OS2                        = 4;
  MQAT_DOS                        = 5;
  MQAT_AIX                        = 6;
  MQAT_UNIX                       = 6;
  MQAT_QMGR                       = 7;
  MQAT_OS400                      = 8;
  MQAT_WINDOWS                    = 9;
  MQAT_CICS_VSE                   = 10;
  MQAT_WINDOWS_NT                 = 11;
  MQAT_VMS                        = 12;
  MQAT_GUARDIAN                   = 13;
  MQAT_NSK                        = 13;
  MQAT_VOS                        = 14;
  MQAT_IMS_BRIDGE                 = 19;
  MQAT_XCF                        = 20;
  MQAT_CICS_BRIDGE                = 21;
  MQAT_NOTES_AGENT                = 22;
  MQAT_USER                       = 25;
  MQAT_BROKER                     = 26;
  MQAT_JAVA                       = 28;
  MQAT_DQM                        = 29;
  MQAT_CHANNEL_INITIATOR          = 30;
  MQAT_DEFAULT                    = 6;
  MQAT_USER_FIRST                 = 65536;
  MQAT_USER_LAST                  = 999999999;

{Put-message options}
  MQPMO_SYNCPOINT                 = $00000002;
  MQPMO_NO_SYNCPOINT              = $00000004;
  MQPMO_NEW_MSG_ID                = $00000040;
  MQPMO_NEW_CORREL_ID             = $00000080;
  MQPMO_LOGICAL_ORDER             = $00008000;
  MQPMO_NO_CONTEXT                = $00004000;
  MQPMO_DEFAULT_CONTEXT           = $00000020;
  MQPMO_PASS_IDENTITY_CONTEXT     = $00000100;
  MQPMO_PASS_ALL_CONTEXT          = $00000200;
  MQPMO_SET_IDENTITY_CONTEXT      = $00000400;
  MQPMO_SET_ALL_CONTEXT           = $00000800;
  MQPMO_ALTERNATE_USER_AUTHORITY  = $00001000;
  MQPMO_FAIL_IF_QUIESCING         = $00002000;
  MQPMO_NONE                      = $00000000;

{Put Message Record Fields}
  MQPMRF_MSG_ID                   = $00000001;
  MQPMRF_CORREL_ID                = $00000002;
  MQPMRF_GROUP_ID                 = $00000004;
  MQPMRF_FEEDBACK                 = $00000008;
  MQPMRF_ACCOUNTING_TOKEN         = $00000010;
  MQPMRF_NONE                     = $00000000;

{Get-message options}
  MQGMO_WAIT                      = $00000001;
  MQGMO_NO_WAIT                   = $00000000;
  MQGMO_SET_SIGNAL                = $00000008;
  MQGMO_FAIL_IF_QUIESCING         = $00002000;
  MQGMO_SYNCPOINT                 = $00000002;
  MQGMO_SYNCPOINT_IF_PERSISTENT   = $00001000;
  MQGMO_NO_SYNCPOINT              = $00000004;
  MQGMO_MARK_SKIP_BACKOUT         = $00000080;
  MQGMO_BROWSE_FIRST              = $00000010;
  MQGMO_BROWSE_NEXT               = $00000020;
  MQGMO_BROWSE_MSG_UNDER_CURSOR   = $00000800;
  MQGMO_MSG_UNDER_CURSOR          = $00000100;
  MQGMO_LOCK                      = $00000200;
  MQGMO_UNLOCK                    = $00000400;
  MQGMO_ACCEPT_TRUNCATED_MSG      = $00000040;
  MQGMO_CONVERT                   = $00004000;
  MQGMO_LOGICAL_ORDER             = $00008000;
  MQGMO_COMPLETE_MSG              = $00010000;
  MQGMO_ALL_MSGS_AVAILABLE        = $00020000;
  MQGMO_ALL_SEGMENTS_AVAILABLE    = $00040000;
  MQGMO_NONE                      = $00000000;

{String Lengths}
  MQ_ABEND_CODE_LENGTH            = 4;
  MQ_ACCOUNTING_TOKEN_LENGTH      = 32;
  MQ_APPL_IDENTITY_DATA_LENGTH    = 32;
  MQ_APPL_NAME_LENGTH             = 28;
  MQ_APPL_ORIGIN_DATA_LENGTH      = 4;
  MQ_APPL_TAG_LENGTH              = 28;
  MQ_ATTENTION_ID_LENGTH          = 4;
  MQ_AUTH_INFO_CONN_NAME_LENGTH   = 264;
  MQ_AUTH_INFO_DESC_LENGTH        = 64;
  MQ_AUTH_INFO_NAME_LENGTH        = 48;
  MQ_AUTHENTICATOR_LENGTH         = 8;
  MQ_BRIDGE_NAME_LENGTH           = 24;
  MQ_CANCEL_CODE_LENGTH           = 4;
  MQ_CF_STRUC_DESC_LENGTH         = 64;
  MQ_CF_STRUC_NAME_LENGTH         = 12;
  MQ_CHANNEL_DATE_LENGTH          = 12;
  MQ_CHANNEL_DESC_LENGTH          = 64;
  MQ_CHANNEL_NAME_LENGTH          = 20;
  MQ_CHANNEL_TIME_LENGTH          = 8;
  MQ_CLUSTER_NAME_LENGTH          = 48;
  MQ_CONN_NAME_LENGTH             = 264;
  MQ_CONN_TAG_LENGTH              = 128;
  MQ_CORREL_ID_LENGTH             = 24;
  MQ_CREATION_DATE_LENGTH         = 12;
  MQ_CREATION_TIME_LENGTH         = 8;
  MQ_DATE_LENGTH                  = 12;
  MQ_DISTINGUISHED_NAME_LENGTH    = 1024;
  MQ_EXIT_DATA_LENGTH             = 32;
  MQ_EXIT_NAME_LENGTH             = 128;
  MQ_EXIT_PD_AREA_LENGTH          = 48;
  MQ_EXIT_USER_AREA_LENGTH        = 16;
  MQ_FACILITY_LENGTH              = 8;
  MQ_FACILITY_LIKE_LENGTH         = 4;
  MQ_FORMAT_LENGTH                = 8;
  MQ_FUNCTION_LENGTH              = 4;
  MQ_GROUP_ID_LENGTH              = 24;
  MQ_LDAP_PASSWORD_LENGTH         = 32;
  MQ_LOCAL_ADDRESS_LENGTH         = 48;
  MQ_LTERM_OVERRIDE_LENGTH        = 8;
  MQ_LUWID_LENGTH                 = 16;
  MQ_MAX_EXIT_NAME_LENGTH         = 128;
  MQ_MAX_MCA_USER_ID_LENGTH       = 64;
  MQ_MAX_USER_ID_LENGTH           = 64;
  MQ_MCA_JOB_NAME_LENGTH          = 28;
  MQ_MCA_NAME_LENGTH              = 20;
  MQ_MCA_USER_ID_LENGTH           = 12;
  MQ_MFS_MAP_NAME_LENGTH          = 8;
  MQ_MODE_NAME_LENGTH             = 8;
  MQ_MSG_HEADER_LENGTH            = 4000;
  MQ_MSG_ID_LENGTH                = 24;
  MQ_MSG_TOKEN_LENGTH             = 16;
  MQ_NAMELIST_DESC_LENGTH         = 64;
  MQ_NAMELIST_NAME_LENGTH         = 48;
  MQ_OBJECT_INSTANCE_ID_LENGTH    = 24;
  MQ_OBJECT_NAME_LENGTH           = 48;
  MQ_PASSWORD_LENGTH              = 12;
  MQ_PROCESS_APPL_ID_LENGTH       = 256;
  MQ_PROCESS_DESC_LENGTH          = 64;
  MQ_PROCESS_ENV_DATA_LENGTH      = 128;
  MQ_PROCESS_NAME_LENGTH          = 48;
  MQ_PROCESS_USER_DATA_LENGTH     = 128;
  MQ_PUT_APPL_NAME_LENGTH         = 28;
  MQ_PUT_DATE_LENGTH              = 8;
  MQ_PUT_TIME_LENGTH              = 8;
  MQ_Q_DESC_LENGTH                = 64;
  MQ_Q_MGR_DESC_LENGTH            = 64;
  MQ_Q_MGR_IDENTIFIER_LENGTH      = 48;
  MQ_Q_MGR_NAME_LENGTH            = 48;
  MQ_Q_NAME_LENGTH                = 48;
  MQ_QSG_NAME_LENGTH              = 4;
  MQ_REMOTE_SYS_ID_LENGTH         = 4;
  MQ_SECURITY_ID_LENGTH           = 40;
  MQ_SERVICE_NAME_LENGTH          = 32;
  MQ_SERVICE_STEP_LENGTH          = 8;
  MQ_SHORT_CONN_NAME_LENGTH       = 20;
  MQ_SSL_CIPHER_SPEC_LENGTH       = 32;
  MQ_SSL_CRYPTO_HARDWARE_LENGTH   = 256;
  MQ_SSL_HANDSHAKE_STAGE_LENGTH   = 32;
  MQ_SSL_KEY_REPOSITORY_LENGTH    = 256;
  MQ_SSL_PEER_NAME_LENGTH         = 1024;
  MQ_SSL_SHORT_PEER_NAME_LENGTH   = 256;
  MQ_START_CODE_LENGTH            = 4;
  MQ_STORAGE_CLASS_DESC_LENGTH    = 64;
  MQ_STORAGE_CLASS_LENGTH         = 8;
  MQ_SUB_IDENTITY_LENGTH          = 128;
  MQ_TIME_LENGTH                  = 8;
  MQ_TOTAL_EXIT_DATA_LENGTH       = 999;
  MQ_TOTAL_EXIT_NAME_LENGTH       = 999;
  MQ_TP_NAME_LENGTH               = 64;
  MQ_TRAN_INSTANCE_ID_LENGTH      = 16;
  MQ_TRANSACTION_ID_LENGTH        = 4;
  MQ_TRIGGER_DATA_LENGTH          = 64;
  MQ_USER_ID_LENGTH               = 12;
  MQ_XCF_GROUP_NAME_LENGTH        =  8;
  MQ_XCF_MEMBER_NAME_LENGTH       =  16;

{Unit of Work Control}
  MQCUOWC_ONLY                    = $00000111;
  MQCUOWC_CONTINUE                = $00010000;
  MQCUOWC_FIRST                   = $00000011;
  MQCUOWC_MIDDLE                  = $00000010;
  MQCUOWC_LAST                    = $00000110;
  MQCUOWC_COMMIT                  = $00000100;
  MQCUOWC_BACKOUT                 = $00001100;

{Character-Attribute Selectors}
  MQCA_ALTERATION_DATE            = 2027;
  MQCA_ALTERATION_TIME            = 2028;
  MQCA_APPL_ID                    = 2001;
  MQCA_AUTH_INFO_CONN_NAME        = 2053;
  MQCA_AUTH_INFO_DESC             = 2046;
  MQCA_AUTH_INFO_NAME             = 2045;
  MQCA_BACKOUT_REQ_Q_NAME         = 2019;
  MQCA_BASE_Q_NAME                = 2002;
  MQCA_CF_STRUC_DESC              = 2052;
  MQCA_CF_STRUC_NAME              = 2039;
  MQCA_CHANNEL_AUTO_DEF_EXIT      = 2026;
  MQCA_CLUSTER_DATE               = 2037;
  MQCA_CLUSTER_NAME               = 2029;
  MQCA_CLUSTER_NAMELIST           = 2030;
  MQCA_CLUSTER_Q_MGR_NAME         = 2031;
  MQCA_CLUSTER_TIME               = 2038;
  MQCA_CLUSTER_WORKLOAD_DATA      = 2034;
  MQCA_CLUSTER_WORKLOAD_EXIT      = 2033;
  MQCA_COMMAND_INPUT_Q_NAME       = 2003;
  MQCA_CREATION_DATE              = 2004;
  MQCA_CREATION_TIME              = 2005;
  MQCA_DEAD_LETTER_Q_NAME         = 2006;
  MQCA_DEF_XMIT_Q_NAME            = 2025;
  MQCA_ENV_DATA                   = 2007;
  MQCA_FIRST                      = 2001;
  MQCA_IGQ_USER_ID                = 2041;
  MQCA_INITIATION_Q_NAME          = 2008;
  MQCA_LAST                       = 4000;
  MQCA_LAST_USED                  = 2053;
  MQCA_LDAP_PASSWORD              = 2048;
  MQCA_LDAP_USER_NAME             = 2047;
  MQCA_NAMELIST_DESC              = 2009;
  MQCA_NAMELIST_NAME              = 2010;
  MQCA_NAMES                      = 2020;
  MQCA_PROCESS_DESC               = 2011;
  MQCA_PROCESS_NAME               = 2012;
  MQCA_Q_DESC                     = 2013;
  MQCA_Q_MGR_DESC                 = 2014;
  MQCA_Q_MGR_IDENTIFIER           = 2032;
  MQCA_Q_MGR_NAME                 = 2015;
  MQCA_Q_NAME                     = 2016;
  MQCA_QSG_NAME                   = 2040;
  MQCA_REMOTE_Q_MGR_NAME          = 2017;
  MQCA_REMOTE_Q_NAME              = 2018;
  MQCA_REPOSITORY_NAME            = 2035;
  MQCA_REPOSITORY_NAMELIST        = 2036;
  MQCA_SSL_CRL_NAMELIST           = 2050;
  MQCA_SSL_CRYPTO_HARDWARE        = 2051;
  MQCA_SSL_KEY_REPOSITORY         = 2049;
  MQCA_STORAGE_CLASS              = 2022;
  MQCA_STORAGE_CLASS_DESC         = 2042;
  MQCA_TRIGGER_DATA               = 2023;
  MQCA_USER_DATA                  = 2021;
  MQCA_USER_LIST                  = 4000;
  MQCA_XCF_GROUP_NAME             = 2043;
  MQCA_XCF_MEMBER_NAME            = 2044;
  MQCA_XMIT_Q_NAME                = 2024;

{Integer-Attribute Selectors}
  MQIA_APPL_TYPE                  = 1;
  MQIA_ARCHIVE                    = 60;
  MQIA_AUTH_INFO_TYPE             = 66;
  MQIA_AUTHORITY_EVENT            = 47;
  MQIA_BACKOUT_THRESHOLD          = 22;
  MQIA_CF_LEVEL                   = 70;
  MQIA_CF_RECOVER                 = 71;
  MQIA_CHANNEL_AUTO_DEF           = 55;
  MQIA_CHANNEL_AUTO_DEF_EVENT     = 56;
  MQIA_CLUSTER_Q_TYPE             = 59;
  MQIA_CLUSTER_WORKLOAD_LENGTH    = 58;
  MQIA_CODED_CHAR_SET_ID          = 2;
  MQIA_COMMAND_LEVEL              = 31;
  MQIA_CONFIGURATION_EVENT        = 51;
  MQIA_CURRENT_Q_DEPTH            = 3;
  MQIA_DEF_BIND                   = 61;
  MQIA_DEF_INPUT_OPEN_OPTION      = 4;
  MQIA_DEF_PERSISTENCE            = 5;
  MQIA_DEF_PRIORITY               = 6;
  MQIA_DEFINITION_TYPE            = 7;
  MQIA_DIST_LISTS                 = 34;
  MQIA_EXPIRY_INTERVAL            = 39;
  MQIA_FIRST                      = 1;
  MQIA_HARDEN_GET_BACKOUT         = 8;
  MQIA_HIGH_Q_DEPTH               = 36;
  MQIA_IGQ_PUT_AUTHORITY          = 65;
  MQIA_INDEX_TYPE                 = 57;
  MQIA_INHIBIT_EVENT              = 48;
  MQIA_INHIBIT_GET                = 9;
  MQIA_INHIBIT_PUT                = 10;
  MQIA_INTRA_GROUP_QUEUING        = 64;
  MQIA_LAST                       = 2000;
  MQIA_LAST_USED                  = 66;
  MQIA_LOCAL_EVENT                = 49;
  MQIA_MAX_HANDLES                = 11;
  MQIA_MAX_MSG_LENGTH             = 13;
  MQIA_MAX_PRIORITY               = 14;
  MQIA_MAX_Q_DEPTH                = 15;
  MQIA_MAX_UNCOMMITTED_MSGS       = 33;
  MQIA_MSG_DELIVERY_SEQUENCE      = 16;
  MQIA_MSG_DEQ_COUNT              = 38;
  MQIA_MSG_ENQ_COUNT              = 37;
  MQIA_NAME_COUNT                 = 19;
  MQIA_NAMELIST_TYPE              = 72;
  MQIA_OPEN_INPUT_COUNT           = 17;
  MQIA_OPEN_OUTPUT_COUNT          = 18;
  MQIA_PAGESET_ID                 = 62;
  MQIA_PERFORMANCE_EVENT          = 53;
  MQIA_PLATFORM                   = 32;
  MQIA_Q_DEPTH_HIGH_EVENT         = 43;
  MQIA_Q_DEPTH_HIGH_LIMIT         = 40;
  MQIA_Q_DEPTH_LOW_EVENT          = 44;
  MQIA_Q_DEPTH_LOW_LIMIT          = 41;
  MQIA_Q_DEPTH_MAX_EVENT          = 42;
  MQIA_Q_SERVICE_INTERVAL         = 54;
  MQIA_Q_SERVICE_INTERVAL_EVENT   = 46;
  MQIA_Q_TYPE                     = 20;
  MQIA_QSG_DISP                   = 63;
  MQIA_REMOTE_EVENT               = 50;
  MQIA_RETENTION_INTERVAL         = 21;
  MQIA_SCOPE                      = 45;
  MQIA_SHAREABILITY               = 23;
  MQIA_SSL_TASKS                  = 69;
  MQIA_START_STOP_EVENT           = 52;
  MQIA_SYNCPOINT                  = 30;
  MQIA_TIME_SINCE_RESET           = 35;
  MQIA_TRIGGER_CONTROL            = 24;
  MQIA_TRIGGER_DEPTH              = 29;
  MQIA_TRIGGER_INTERVAL           = 25;
  MQIA_TRIGGER_MSG_PRIORITY       = 26;
  MQIA_TRIGGER_TYPE               = 28;
  MQIA_USAGE                      = 12;
  MQIA_USER_LIST                  = 2000;

{Return Code}
  MQCRC_OK                        = 0;
  MQCRC_CICS_EXEC_ERROR           = 1;
  MQCRC_MQ_API_ERROR              = 2;
  MQCRC_BRIDGE_ERROR              = 3;
  MQCRC_BRIDGE_ABEND              = 4;
  MQCRC_APPLICATION_ABEND         = 5;
  MQCRC_SECURITY_ERROR            = 6;
  MQCRC_PROGRAM_NOT_AVAILABLE     = 7;
  MQCRC_BRIDGE_TIMEOUT            = 8;
  MQCRC_TRANSID_NOT_AVAILABLE     = 9;

{Completion Codes}
  MQCC_OK                         = 0;
  MQCC_WARNING                    = 1;
  MQCC_FAILED                     = 2;
  MQCC_UNKNOWN                    = -1;

{Reason Codes}
  MQRC_NONE                        = 0;
  MQRC_APPL_FIRST                  = 900;
  MQRC_APPL_LAST                   = 999;
  MQRC_ALIAS_BASE_Q_TYPE_ERROR     = 2001;
  MQRC_ALREADY_CONNECTED           = 2002;
  MQRC_BACKED_OUT                  = 2003;
  MQRC_BUFFER_ERROR                = 2004;
  MQRC_BUFFER_LENGTH_ERROR         = 2005;
  MQRC_CHAR_ATTR_LENGTH_ERROR      = 2006;
  MQRC_CHAR_ATTRS_ERROR            = 2007;
  MQRC_CHAR_ATTRS_TOO_SHORT        = 2008;
  MQRC_CONNECTION_BROKEN           = 2009;
  MQRC_DATA_LENGTH_ERROR           = 2010;
  MQRC_DYNAMIC_Q_NAME_ERROR        = 2011;
  MQRC_ENVIRONMENT_ERROR           = 2012;
  MQRC_EXPIRY_ERROR                = 2013;
  MQRC_FEEDBACK_ERROR              = 2014;
  MQRC_GET_INHIBITED               = 2016;
  MQRC_HANDLE_NOT_AVAILABLE        = 2017;
  MQRC_HCONN_ERROR                 = 2018;
  MQRC_HOBJ_ERROR                  = 2019;
  MQRC_INHIBIT_VALUE_ERROR         = 2020;
  MQRC_INT_ATTR_COUNT_ERROR        = 2021;
  MQRC_INT_ATTR_COUNT_TOO_SMALL    = 2022;
  MQRC_INT_ATTRS_ARRAY_ERROR       = 2023;
  MQRC_SYNCPOINT_LIMIT_REACHED     = 2024;
  MQRC_MAX_CONNS_LIMIT_REACHED     = 2025;
  MQRC_MD_ERROR                    = 2026;
  MQRC_MISSING_REPLY_TO_Q          = 2027;
  MQRC_MSG_TYPE_ERROR              = 2029;
  MQRC_MSG_TOO_BIG_FOR_Q           = 2030;
  MQRC_MSG_TOO_BIG_FOR_Q_MGR       = 2031;
  MQRC_NO_MSG_AVAILABLE            = 2033;
  MQRC_NO_MSG_UNDER_CURSOR         = 2034;
  MQRC_NOT_AUTHORIZED              = 2035;
  MQRC_NOT_OPEN_FOR_BROWSE         = 2036;
  MQRC_NOT_OPEN_FOR_INPUT          = 2037;
  MQRC_NOT_OPEN_FOR_INQUIRE        = 2038;
  MQRC_NOT_OPEN_FOR_OUTPUT         = 2039;
  MQRC_NOT_OPEN_FOR_SET            = 2040;
  MQRC_OBJECT_CHANGED              = 2041;
  MQRC_OBJECT_IN_USE               = 2042;
  MQRC_OBJECT_TYPE_ERROR           = 2043;
  MQRC_OD_ERROR                    = 2044;
  MQRC_OPTION_NOT_VALID_FOR_TYPE   = 2045;
  MQRC_OPTIONS_ERROR               = 2046;
  MQRC_PERSISTENCE_ERROR           = 2047;
  MQRC_PERSISTENT_NOT_ALLOWED      = 2048;
  MQRC_PRIORITY_EXCEEDS_MAXIMUM    = 2049;
  MQRC_PRIORITY_ERROR              = 2050;
  MQRC_PUT_INHIBITED               = 2051;
  MQRC_Q_DELETED                   = 2052;
  MQRC_Q_FULL                      = 2053;
  MQRC_Q_NOT_EMPTY                 = 2055;
  MQRC_Q_SPACE_NOT_AVAILABLE       = 2056;
  MQRC_Q_TYPE_ERROR                = 2057;
  MQRC_Q_MGR_NAME_ERROR            = 2058;
  MQRC_Q_MGR_NOT_AVAILABLE         = 2059;
  MQRC_REPORT_OPTIONS_ERROR        = 2061;
  MQRC_SECOND_MARK_NOT_ALLOWED     = 2062;
  MQRC_SECURITY_ERROR              = 2063;
  MQRC_SELECTOR_COUNT_ERROR        = 2065;
  MQRC_SELECTOR_LIMIT_EXCEEDED     = 2066;
  MQRC_SELECTOR_ERROR              = 2067;
  MQRC_SELECTOR_NOT_FOR_TYPE       = 2068;
  MQRC_SIGNAL_OUTSTANDING          = 2069;
  MQRC_SIGNAL_REQUEST_ACCEPTED     = 2070;
  MQRC_STORAGE_NOT_AVAILABLE       = 2071;
  MQRC_SYNCPOINT_NOT_AVAILABLE     = 2072;
  MQRC_TRIGGER_CONTROL_ERROR       = 2075;
  MQRC_TRIGGER_DEPTH_ERROR         = 2076;
  MQRC_TRIGGER_MSG_PRIORITY_ERR    = 2077;
  MQRC_TRIGGER_TYPE_ERROR          = 2078;
  MQRC_TRUNCATED_MSG_ACCEPTED      = 2079;
  MQRC_TRUNCATED_MSG_FAILED        = 2080;
  MQRC_UNKNOWN_ALIAS_BASE_Q        = 2082;
  MQRC_UNKNOWN_OBJECT_NAME         = 2085;
  MQRC_UNKNOWN_OBJECT_Q_MGR        = 2086;
  MQRC_UNKNOWN_REMOTE_Q_MGR        = 2087;
  MQRC_WAIT_INTERVAL_ERROR         = 2090;
  MQRC_XMIT_Q_TYPE_ERROR           = 2091;
  MQRC_XMIT_Q_USAGE_ERROR          = 2092;
  MQRC_NOT_OPEN_FOR_PASS_ALL       = 2093;
  MQRC_NOT_OPEN_FOR_PASS_IDENT     = 2094;
  MQRC_NOT_OPEN_FOR_SET_ALL        = 2095;
  MQRC_NOT_OPEN_FOR_SET_IDENT      = 2096;
  MQRC_CONTEXT_HANDLE_ERROR        = 2097;
  MQRC_CONTEXT_NOT_AVAILABLE       = 2098;
  MQRC_SIGNAL1_ERROR               = 2099;
  MQRC_OBJECT_ALREADY_EXISTS       = 2100;
  MQRC_OBJECT_DAMAGED              = 2101;
  MQRC_RESOURCE_PROBLEM            = 2102;
  MQRC_ANOTHER_Q_MGR_CONNECTED     = 2103;
  MQRC_UNKNOWN_REPORT_OPTION       = 2104;
  MQRC_STORAGE_CLASS_ERROR         = 2105;
  MQRC_COD_NOT_VALID_FOR_XCF_Q     = 2106;
  MQRC_XWAIT_CANCELED              = 2107;
  MQRC_XWAIT_ERROR                 = 2108;
  MQRC_SUPPRESSED_BY_EXIT          = 2109;
  MQRC_FORMAT_ERROR                = 2110;
  MQRC_SOURCE_CCSID_ERROR          = 2111;
  MQRC_SOURCE_INTEGER_ENC_ERROR    = 2112;
  MQRC_SOURCE_DECIMAL_ENC_ERROR    = 2113;
  MQRC_SOURCE_FLOAT_ENC_ERROR      = 2114;
  MQRC_TARGET_CCSID_ERROR          = 2115;
  MQRC_TARGET_INTEGER_ENC_ERROR    = 2116;
  MQRC_TARGET_DECIMAL_ENC_ERROR    = 2117;
  MQRC_TARGET_FLOAT_ENC_ERROR      = 2118;
  MQRC_NOT_CONVERTED               = 2119;
  MQRC_CONVERTED_MSG_TOO_BIG       = 2120;
  MQRC_TRUNCATED                   = 2120;
  MQRC_NO_EXTERNAL_PARTICIPANTS    = 2121;
  MQRC_PARTICIPANT_NOT_AVAILABLE   = 2122;
  MQRC_OUTCOME_MIXED               = 2123;
  MQRC_OUTCOME_PENDING             = 2124;
  MQRC_BRIDGE_STARTED              = 2125;
  MQRC_BRIDGE_STOPPED              = 2126;
  MQRC_ADAPTER_STORAGE_SHORTAGE    = 2127;
  MQRC_UOW_IN_PROGRESS             = 2128;
  MQRC_ADAPTER_CONN_LOAD_ERROR     = 2129;
  MQRC_ADAPTER_SERV_LOAD_ERROR     = 2130;
  MQRC_ADAPTER_DEFS_ERROR          = 2131;
  MQRC_ADAPTER_DEFS_LOAD_ERROR     = 2132;
  MQRC_ADAPTER_CONV_LOAD_ERROR     = 2133;
  MQRC_BO_ERROR                    = 2134;
  MQRC_DH_ERROR                    = 2135;
  MQRC_MULTIPLE_REASONS            = 2136;
  MQRC_OPEN_FAILED                 = 2137;
  MQRC_ADAPTER_DISC_LOAD_ERROR     = 2138;
  MQRC_CNO_ERROR                   = 2139;
  MQRC_CICS_WAIT_FAILED            = 2140;
  MQRC_DLH_ERROR                   = 2141;
  MQRC_HEADER_ERROR                = 2142;
  MQRC_SOURCE_LENGTH_ERROR         = 2143;
  MQRC_TARGET_LENGTH_ERROR         = 2144;
  MQRC_SOURCE_BUFFER_ERROR         = 2145;
  MQRC_TARGET_BUFFER_ERROR         = 2146;
  MQRC_IIH_ERROR                   = 2148;
  MQRC_PCF_ERROR                   = 2149;
  MQRC_DBCS_ERROR                  = 2150;
  MQRC_OBJECT_NAME_ERROR           = 2152;
  MQRC_OBJECT_Q_MGR_NAME_ERROR     = 2153;
  MQRC_RECS_PRESENT_ERROR          = 2154;
  MQRC_OBJECT_RECORDS_ERROR        = 2155;
  MQRC_RESPONSE_RECORDS_ERROR      = 2156;
  MQRC_ASID_MISMATCH               = 2157;
  MQRC_PMO_RECORD_FLAGS_ERROR      = 2158;
  MQRC_PUT_MSG_RECORDS_ERROR       = 2159;
  MQRC_CONN_ID_IN_USE              = 2160;
  MQRC_Q_MGR_QUIESCING             = 2161;
  MQRC_Q_MGR_STOPPING              = 2162;
  MQRC_DUPLICATE_RECOV_COORD       = 2163;
  MQRC_PMO_ERROR                   = 2173;
  MQRC_API_EXIT_NOT_FOUND          = 2182;
  MQRC_API_EXIT_LOAD_ERROR         = 2183;
  MQRC_REMOTE_Q_NAME_ERROR         = 2184;
  MQRC_INCONSISTENT_PERSISTENCE    = 2185;
  MQRC_GMO_ERROR                   = 2186;
  MQRC_CICS_BRIDGE_RESTRICTION     = 2187;
  MQRC_STOPPED_BY_CLUSTER_EXIT     = 2188;
  MQRC_CLUSTER_RESOLUTION_ERROR    = 2189;
  MQRC_CONVERTED_STRING_TOO_BIG    = 2190;
  MQRC_TMC_ERROR                   = 2191;
  MQRC_PAGESET_FULL                = 2192;
  MQRC_STORAGE_MEDIUM_FULL         = 2192;
  MQRC_PAGESET_ERROR               = 2193;
  MQRC_NAME_NOT_VALID_FOR_TYPE     = 2194;
  MQRC_UNEXPECTED_ERROR            = 2195;
  MQRC_UNKNOWN_XMIT_Q              = 2196;
  MQRC_UNKNOWN_DEF_XMIT_Q          = 2197;
  MQRC_DEF_XMIT_Q_TYPE_ERROR       = 2198;
  MQRC_DEF_XMIT_Q_USAGE_ERROR      = 2199;
  MQRC_NAME_IN_USE                 = 2201;
  MQRC_CONNECTION_QUIESCING        = 2202;
  MQRC_CONNECTION_STOPPING         = 2203;
  MQRC_ADAPTER_NOT_AVAILABLE       = 2204;
  MQRC_MSG_ID_ERROR                = 2206;
  MQRC_CORREL_ID_ERROR             = 2207;
  MQRC_FILE_SYSTEM_ERROR           = 2208;
  MQRC_NO_MSG_LOCKED               = 2209;
  MQRC_FILE_NOT_AUDITED            = 2216;
  MQRC_CONNECTION_NOT_AUTHORIZED   = 2217;
  MQRC_MSG_TOO_BIG_FOR_CHANNEL     = 2218;
  MQRC_CALL_IN_PROGRESS            = 2219;
  MQRC_RMH_ERROR                   = 2220;
  MQRC_Q_MGR_ACTIVE                = 2222;
  MQRC_Q_MGR_NOT_ACTIVE            = 2223;
  MQRC_Q_DEPTH_HIGH                = 2224;
  MQRC_Q_DEPTH_LOW                 = 2225;
  MQRC_Q_SERVICE_INTERVAL_HIGH     = 2226;
  MQRC_Q_SERVICE_INTERVAL_OK       = 2227;
  MQRC_UNIT_OF_WORK_NOT_STARTED    = 2232;
  MQRC_CHANNEL_AUTO_DEF_OK         = 2233;
  MQRC_CHANNEL_AUTO_DEF_ERROR      = 2234;
  MQRC_CFH_ERROR                   = 2235;
  MQRC_CFIL_ERROR                  = 2236;
  MQRC_CFIN_ERROR                  = 2237;
  MQRC_CFSL_ERROR                  = 2238;
  MQRC_CFST_ERROR                  = 2239;
  MQRC_INCOMPLETE_GROUP            = 2241;
  MQRC_INCOMPLETE_MSG              = 2242;
  MQRC_INCONSISTENT_CCSIDS         = 2243;
  MQRC_INCONSISTENT_ENCODINGS      = 2244;
  MQRC_INCONSISTENT_UOW            = 2245;
  MQRC_INVALID_MSG_UNDER_CURSOR    = 2246;
  MQRC_MATCH_OPTIONS_ERROR         = 2247;
  MQRC_MDE_ERROR                   = 2248;
  MQRC_MSG_FLAGS_ERROR             = 2249;
  MQRC_MSG_SEQ_NUMBER_ERROR        = 2250;
  MQRC_OFFSET_ERROR                = 2251;
  MQRC_ORIGINAL_LENGTH_ERROR       = 2252;
  MQRC_SEGMENT_LENGTH_ZERO         = 2253;
  MQRC_UOW_NOT_AVAILABLE           = 2255;
  MQRC_WRONG_GMO_VERSION           = 2256;
  MQRC_WRONG_MD_VERSION            = 2257;
  MQRC_GROUP_ID_ERROR              = 2258;
  MQRC_INCONSISTENT_BROWSE         = 2259;
  MQRC_XQH_ERROR                   = 2260;
  MQRC_SRC_ENV_ERROR               = 2261;
  MQRC_SRC_NAME_ERROR              = 2262;
  MQRC_DEST_ENV_ERROR              = 2263;
  MQRC_DEST_NAME_ERROR             = 2264;
  MQRC_TM_ERROR                    = 2265;
  MQRC_CLUSTER_EXIT_ERROR          = 2266;
  MQRC_CLUSTER_EXIT_LOAD_ERROR     = 2267;
  MQRC_CLUSTER_PUT_INHIBITED       = 2268;
  MQRC_CLUSTER_RESOURCE_ERROR      = 2269;
  MQRC_NO_DESTINATIONS_AVAILABLE   = 2270;
  MQRC_CONN_TAG_IN_USE             = 2271;
  MQRC_PARTIALLY_CONVERTED         = 2272;
  MQRC_CONNECTION_ERROR            = 2273;
  MQRC_OPTION_ENVIRONMENT_ERROR    = 2274;
  MQRC_CD_ERROR                    = 2277;
  MQRC_CLIENT_CONN_ERROR           = 2278;
  MQRC_CHANNEL_STOPPED_BY_USER     = 2279;
  MQRC_HCONFIG_ERROR               = 2280;
  MQRC_FUNCTION_ERROR              = 2281;
  MQRC_CHANNEL_STARTED             = 2282;
  MQRC_CHANNEL_STOPPED             = 2283;
  MQRC_CHANNEL_CONV_ERROR          = 2284;
  MQRC_SERVICE_NOT_AVAILABLE       = 2285;
  MQRC_INITIALIZATION_FAILED       = 2286;
  MQRC_TERMINATION_FAILED          = 2287;
  MQRC_UNKNOWN_Q_NAME              = 2288;
  MQRC_SERVICE_ERROR               = 2289;
  MQRC_Q_ALREADY_EXISTS            = 2290;
  MQRC_USER_ID_NOT_AVAILABLE       = 2291;
  MQRC_UNKNOWN_ENTITY              = 2292;
  MQRC_UNKNOWN_AUTH_ENTITY         = 2293;
  MQRC_UNKNOWN_REF_OBJECT          = 2294;
  MQRC_CHANNEL_ACTIVATED           = 2295;
  MQRC_CHANNEL_NOT_ACTIVATED       = 2296;
  MQRC_UOW_CANCELED                = 2297;
  MQRC_FUNCTION_NOT_SUPPORTED      = 2298;
  MQRC_SELECTOR_TYPE_ERROR         = 2299;
  MQRC_COMMAND_TYPE_ERROR          = 2300;
  MQRC_MULTIPLE_INSTANCE_ERROR     = 2301;
  MQRC_SYSTEM_ITEM_NOT_ALTERABLE   = 2302;
  MQRC_BAG_CONVERSION_ERROR        = 2303;
  MQRC_SELECTOR_OUT_OF_RANGE       = 2304;
  MQRC_SELECTOR_NOT_UNIQUE         = 2305;
  MQRC_INDEX_NOT_PRESENT           = 2306;
  MQRC_STRING_ERROR                = 2307;
  MQRC_ENCODING_NOT_SUPPORTED      = 2308;
  MQRC_SELECTOR_NOT_PRESENT        = 2309;
  MQRC_OUT_SELECTOR_ERROR          = 2310;
  MQRC_STRING_TRUNCATED            = 2311;
  MQRC_SELECTOR_WRONG_TYPE         = 2312;
  MQRC_INCONSISTENT_ITEM_TYPE      = 2313;
  MQRC_INDEX_ERROR                 = 2314;
  MQRC_SYSTEM_BAG_NOT_ALTERABLE    = 2315;
  MQRC_ITEM_COUNT_ERROR            = 2316;
  MQRC_FORMAT_NOT_SUPPORTED        = 2317;
  MQRC_SELECTOR_NOT_SUPPORTED      = 2318;
  MQRC_ITEM_VALUE_ERROR            = 2319;
  MQRC_HBAG_ERROR                  = 2320;
  MQRC_PARAMETER_MISSING           = 2321;
  MQRC_CMD_SERVER_NOT_AVAILABLE    = 2322;
  MQRC_STRING_LENGTH_ERROR         = 2323;
  MQRC_INQUIRY_COMMAND_ERROR       = 2324;
  MQRC_NESTED_BAG_NOT_SUPPORTED    = 2325;
  MQRC_BAG_WRONG_TYPE              = 2326;
  MQRC_ITEM_TYPE_ERROR             = 2327;
  MQRC_SYSTEM_BAG_NOT_DELETABLE    = 2328;
  MQRC_SYSTEM_ITEM_NOT_DELETABLE   = 2329;
  MQRC_CODED_CHAR_SET_ID_ERROR     = 2330;
  MQRC_MSG_TOKEN_ERROR             = 2331;
  MQRC_MISSING_WIH                 = 2332;
  MQRC_WIH_ERROR                   = 2333;
  MQRC_RFH_ERROR                   = 2334;
  MQRC_RFH_STRING_ERROR            = 2335;
  MQRC_RFH_COMMAND_ERROR           = 2336;
  MQRC_RFH_PARM_ERROR              = 2337;
  MQRC_RFH_DUPLICATE_PARM          = 2338;
  MQRC_RFH_PARM_MISSING            = 2339;
  MQRC_CHAR_CONVERSION_ERROR       = 2340;
  MQRC_UCS2_CONVERSION_ERROR       = 2341;
  MQRC_DB2_NOT_AVAILABLE           = 2342;
  MQRC_OBJECT_NOT_UNIQUE           = 2343;
  MQRC_CONN_TAG_NOT_RELEASED       = 2344;
  MQRC_CF_NOT_AVAILABLE            = 2345;
  MQRC_CF_STRUC_IN_USE             = 2346;
  MQRC_CF_STRUC_LIST_HDR_IN_USE    = 2347;
  MQRC_CF_STRUC_AUTH_FAILED        = 2348;
  MQRC_CF_STRUC_ERROR              = 2349;
  MQRC_CONN_TAG_NOT_USABLE         = 2350;
  MQRC_GLOBAL_UOW_CONFLICT         = 2351;
  MQRC_LOCAL_UOW_CONFLICT          = 2352;
  MQRC_HANDLE_IN_USE_FOR_UOW       = 2353;
  MQRC_UOW_ENLISTMENT_ERROR        = 2354;
  MQRC_UOW_MIX_NOT_SUPPORTED       = 2355;
  MQRC_WXP_ERROR                   = 2356;
  MQRC_CURRENT_RECORD_ERROR        = 2357;
  MQRC_NEXT_OFFSET_ERROR           = 2358;
  MQRC_NO_RECORD_AVAILABLE         = 2359;
  MQRC_OBJECT_LEVEL_INCOMPATIBLE   = 2360;
  MQRC_NEXT_RECORD_ERROR           = 2361;
  MQRC_BACKOUT_THRESHOLD_REACHED   = 2362;
  MQRC_MSG_NOT_MATCHED             = 2363;
  MQRC_JMS_FORMAT_ERROR            = 2364;
  MQRC_SEGMENTS_NOT_SUPPORTED      = 2365;
  MQRC_WRONG_CF_LEVEL              = 2366;
  MQRC_CONFIG_CREATE_OBJECT        = 2367;
  MQRC_CONFIG_CHANGE_OBJECT        = 2368;
  MQRC_CONFIG_DELETE_OBJECT        = 2369;
  MQRC_CONFIG_REFRESH_OBJECT       = 2370;
  MQRC_CHANNEL_SSL_ERROR           = 2371;
  MQRC_CF_STRUC_FAILED             = 2373;
  MQRC_API_EXIT_ERROR              = 2374;
  MQRC_API_EXIT_INIT_ERROR         = 2375;
  MQRC_API_EXIT_TERM_ERROR         = 2376;
  MQRC_EXIT_REASON_ERROR           = 2377;
  MQRC_RESERVED_VALUE_ERROR        = 2378;
  MQRC_NO_DATA_AVAILABLE           = 2379;
  MQRC_SCO_ERROR                   = 2380;
  MQRC_KEY_REPOSITORY_ERROR        = 2381;
  MQRC_CRYPTO_HARDWARE_ERROR       = 2382;
  MQRC_AUTH_INFO_REC_COUNT_ERROR   = 2383;
  MQRC_AUTH_INFO_REC_ERROR         = 2384;
  MQRC_AIR_ERROR                   = 2385;
  MQRC_AUTH_INFO_TYPE_ERROR        = 2386;
  MQRC_AUTH_INFO_CONN_NAME_ERROR   = 2387;
  MQRC_LDAP_USER_NAME_ERROR        = 2388;
  MQRC_LDAP_USER_NAME_LENGTH_ERR   = 2389;
  MQRC_LDAP_PASSWORD_ERROR         = 2390;
  MQRC_SSL_ALREADY_INITIALIZED     = 2391;
  MQRC_SSL_CONFIG_ERROR            = 2392;
  MQRC_SSL_INITIALIZATION_ERROR    = 2393;
  MQRC_Q_INDEX_TYPE_ERROR          = 2394;
  MQRC_SSL_NOT_ALLOWED             = 2396;
  MQRC_JSSE_ERROR                  = 2397;
  MQRC_SSL_PEER_NAME_MISMATCH      = 2398;
  MQRC_SSL_PEER_NAME_ERROR         = 2399;
  MQRC_UNSUPPORTED_CIPHER_SUITE    = 2400;
  MQRC_SSL_CERTIFICATE_REVOKED     = 2401;
  MQRC_SSL_CERT_STORE_ERROR        = 2402;
  MQRC_REOPEN_EXCL_INPUT_ERROR     = 6100;
  MQRC_REOPEN_INQUIRE_ERROR        = 6101;
  MQRC_REOPEN_SAVED_CONTEXT_ERR    = 6102;
  MQRC_REOPEN_TEMPORARY_Q_ERROR    = 6103;
  MQRC_ATTRIBUTE_LOCKED            = 6104;
  MQRC_CURSOR_NOT_VALID            = 6105;
  MQRC_ENCODING_ERROR              = 6106;
  MQRC_STRUC_ID_ERROR              = 6107;
  MQRC_NULL_POINTER                = 6108;
  MQRC_NO_CONNECTION_REFERENCE     = 6109;
  MQRC_NO_BUFFER                   = 6110;
  MQRC_BINARY_DATA_LENGTH_ERROR    = 6111;
  MQRC_BUFFER_NOT_AUTOMATIC        = 6112;
  MQRC_INSUFFICIENT_BUFFER         = 6113;
  MQRC_INSUFFICIENT_DATA           = 6114;
  MQRC_DATA_TRUNCATED              = 6115;
  MQRC_ZERO_LENGTH                 = 6116;
  MQRC_NEGATIVE_LENGTH             = 6117;
  MQRC_NEGATIVE_OFFSET             = 6118;
  MQRC_INCONSISTENT_FORMAT         = 6119;
  MQRC_INCONSISTENT_OBJECT_STATE   = 6120;
  MQRC_CONTEXT_OBJECT_NOT_VALID    = 6121;
  MQRC_CONTEXT_OPEN_ERROR          = 6122;
  MQRC_STRUC_LENGTH_ERROR          = 6123;
  MQRC_NOT_CONNECTED               = 6124;
  MQRC_NOT_OPEN                    = 6125;
  MQRC_DISTRIBUTION_LIST_EMPTY     = 6126;
  MQRC_INCONSISTENT_OPEN_OPTIONS   = 6127;
  MQRC_WRONG_VERSION               = 6128;
  MQRC_REFERENCE_ERROR             = 6129;

{Priority}
  MQPRI_PRIORITY_AS_Q_DEF        = -1;

{Original length}
  MQOL_UNDEFINED                 = -1;

{Wait interval}
  MQWI_UNLIMITED                 = -1;
  MQCGWI_DEFAULT                 = -2;

{Returned length}
  MQRL_UNDEFINED                 = -1;

{Authentication Information Type}
  MQAIT_CRL_LDAP                 = 1;

{Output Data Length}
  MQCODL_AS_INPUT                = -1;

{Integer Attribute Value Denoting "Not Applicable"}
  MQIAV_NOT_APPLICABLE           = -1;
  MQIAV_UNDEFINED                = -2;

{Persistence values}
  MQPER_NOT_PERSISTENT           = 0;
  MQPER_PERSISTENT               = 1;
  MQPER_PERSISTENCE_AS_Q_DEF     = 2;

{Signal Values}
  MQEC_MSG_ARRIVED               = 2;
  MQEC_WAIT_INTERVAL_EXPIRED     = 3;
  MQEC_WAIT_CANCELED             = 4;
  MQEC_Q_MGR_QUIESCING           = 5;
  MQEC_CONNECTION_QUIESCING      = 6;

{Match Options}
  MQMO_MATCH_MSG_ID              = $00000001;
  MQMO_MATCH_CORREL_ID           = $00000002;
  MQMO_MATCH_GROUP_ID            = $00000004;
  MQMO_MATCH_MSG_SEQ_NUMBER      = $00000008;
  MQMO_MATCH_OFFSET              = $00000010;
  MQMO_MATCH_MSG_TOKEN           = $00000020;
  MQMO_NONE                      = $00000000;

{Group status}
  MQGS_NOT_IN_GROUP              = ' ';
  MQGS_MSG_IN_GROUP              = 'G';
  MQGS_LAST_MSG_IN_GROUP         = 'L';

{Segment status}
  MQSS_NOT_A_SEGMENT             = ' ';
  MQSS_SEGMENT                   = 'S';
  MQSS_LAST_SEGMENT              = 'L';

{Segmentation}
  MQSEG_INHIBITED                = ' ';
  MQSEG_ALLOWED                  = 'A';

{Link Type}
  MQCLT_PROGRAM                  = 1;
  MQCLT_TRANSACTION              = 2;

{ADS Descriptor}
  MQCADSD_NONE                   = $00000000;
  MQCADSD_SEND                   = $00000001;
  MQCADSD_RECV                   = $00000010;
  MQCADSD_MSGFORMAT              = $00000100;

{Conversational Task}
  MQCCT_YES                      = $00000001;
  MQCCT_NO                       = $00000000;

{Task End Status}
  MQCTES_NOSYNC                  = $00000000;
  MQCTES_COMMIT                  = $00000100;
  MQCTES_BACKOUT                 = $00001100;
  MQCTES_ENDTASK                 = $00010000;

{MQRH}
  MQRFH_STRUC_LENGTH_FIXED       = 32;
  MQRFH_STRUC_LENGTH_FIXED_2     = 36;
  MQRFH_NONE                     = $00000000;

{Names for Name/Value String}
  MQNVS_APPL_TYPE                = 'OPT_APP_GRP ';
  MQNVS_MSG_TYPE                 = 'OPT_MSG_TYPE ';

{General Flags}
  MQDHF_NEW_MSG_IDS              = $00000001;
  MQDHF_NONE                     = $00000000;

{Function}
  MQCFUNC_MQCONN                 = 'CONN';
  MQCFUNC_MQGET                  = 'GET ';
  MQCFUNC_MQINQ                  = 'INQ ';
  MQCFUNC_MQOPEN                 = 'OPEN';
  MQCFUNC_MQPUT                  = 'PUT ';
  MQCFUNC_MQPUT1                 = 'PUT1';
  MQCFUNC_NONE                   = '    ';

{Start Code}
  MQCSC_START                    = 'S   ';
  MQCSC_STARTDATA                = 'SD  ';
  MQCSC_TERMINPUT                = 'TD  ';
  MQCSC_NONE                     = '    ';

{CIH}
  MQCIH_LENGTH_1                 = 164;
  MQCIH_LENGTH_2                 = 180;
  MQCIH_CURRENT_LENGTH           = 180;
  MQCIH_NONE                     = $00000000;

{IIH}
  MQIIH_LENGTH_1                  = 84;
  MQIIH_NONE                      = $00000000;

{WIH}
  MQWIH_LENGTH_1                  = 120;
  MQWIH_CURRENT_LENGTH            = 120;
  MQWIH_NONE                      = $00000000;

{MQRMH Flags}
  MQRMHF_LAST                     = $00000001;
  MQRMHF_NOT_LAST                 = $00000000;

{MQMDE}
  MQMDE_LENGTH_2                  = 72;
  MQMDEF_NONE                     = $00000000;

{Transaction State}
  MQITS_IN_CONVERSATION           = 'C';
  MQITS_NOT_IN_CONVERSATION       = ' ';
  MQITS_ARCHITECTED               = 'A';

{Commit Mode}
  MQICM_COMMIT_THEN_SEND          = '0';
  MQICM_SEND_THEN_COMMIT          = '1';

{Security Scope}
  MQISS_CHECK                     = 'C';
  MQISS_FULL                      = 'F';

type
  MQLONG     = Longint;
  PMQLONG    = ^MQLONG;
  MQHOBJ     = MQLONG;
  PMQHOBJ    = ^MQHOBJ;
  MQHCONN    = MQLONG;
  PMQHCONN   = ^MQHCONN;
  MQPTR      = Pointer;
  MQCHAR     = Char;
  MQCHAR4    = array [0..3]   of Char;
  MQCHAR8    = array [0..7]   of Char;
  MQCHAR12   = array [0..11]  of Char;
  MQCHAR20   = array [0..19]  of Char;
  MQCHAR28   = array [0..27]  of Char;
  MQCHAR32   = array [0..31]  of Char;
  MQCHAR48   = array [0..47]  of Char;
  MQCHAR64   = array [0..63]  of Char;
  MQCHAR128  = array [0..127] of Char;
  MQCHAR256  = array [0..255] of Char;
  MQCHAR264  = array [0..263] of Char;
  PMQCHAR    = PChar;
  PMQCHAR4   = ^MQCHAR4;
  PMQCHAR8   = ^MQCHAR8;
  PMQCHAR12  = ^MQCHAR12;
  PMQCHAR20  = ^MQCHAR20;
  PMQCHAR28  = ^MQCHAR28;
  PMQCHAR32  = ^MQCHAR32;
  PMQCHAR48  = ^MQCHAR48;
  PMQCHAR64  = ^MQCHAR64;
  PMQCHAR128 = ^MQCHAR128;
  PMQCHAR256 = ^MQCHAR256;
  PMQCHAR264 = ^MQCHAR264;
  MQBYTE16   = array [0..15]  of Byte;
  MQBYTE24   = array [0..23]  of Byte;
  MQBYTE32   = array [0..31]  of Byte;
  MQBYTE40   = array [0..39]  of Byte;
  MQBYTE128  = array [0..127] of Byte;

const
 MQMI_NONE    : MQBYTE24  = ( $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
 MQCI_NONE    : MQBYTE24  = ( $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
 MQCT_NONE    : MQCHAR128 = ( #0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0);
 MQACT_NONE   : MQBYTE32  = ( $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
 MQGI_NONE    : MQBYTE24  = ( $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
 MQSID_NONE   : MQBYTE40  = ( $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
 MQCFAC_NONE  : MQCHAR8   = ( #0,#0,#0,#0,#0,#0,#0,#0);
 MQMTOK_NONE  : MQBYTE16  = ( $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
 MQIAUT_NONE  : MQCHAR8   = '        ';

type
  MQOD = record
    StrucId             : MQCHAR4;
    Version             : MQLONG;
    ObjectType          : MQLONG;
    ObjectName          : MQCHAR48;
    ObjectQMgrName      : MQCHAR48;
    DynamicQName        : MQCHAR48;
    AlternateUserID     : MQCHAR12;
    RecsPresent         : MQLONG;
    KnownDestCount      : MQLONG;
    UnKnownDestCount    : MQLONG;
    InvalidDestCount    : MQLONG;
    ObjectRecOffset     : MQLONG;
    ResponseRecOffset   : MQLONG;
    ObjectPointer       : MQPTR;
    ResponseRecPointer  : MQPTR;
    AlternateSecurityID : MQBYTE40;
    ResolvedQName       : MQCHAR48;
    ResolvedQMgrName    : MQCHAR48;
  end;
  PMQOD = ^MQOD;

  MQMD = record
    StrucId             : MQCHAR4;
    Version             : MQLONG;
    Report              : MQLONG;
    MsgType             : MQLONG;
    Expiry              : MQLONG;
    FeedBack            : MQLONG;
    Encoding            : MQLONG;
    CodedCharSetId      : MQLONG;
    Format              : MQCHAR8;
    Priority            : MQLONG;
    Persistence         : MQLONG;
    MsgId               : MQBYTE24;
    CorrelId            : MQBYTE24;
    BackoutCount        : MQLONG;
    ReplyToQ            : MQCHAR48;
    ReplyToQMgr         : MQCHAR48;
    UserIdentifier      : MQCHAR12;
    AccountingToken     : MQBYTE32;
    ApplIdentityData    : MQCHAR32;
    PutApplType         : MQLONG;
    PutApplName         : MQCHAR28;
    PutDate             : MQCHAR8;
    PutTime             : MQCHAR8;
    ApplOriginData      : MQCHAR4;
    GroupId             : MQBYTE24;
    MsgSeqNumber        : MQLONG;
    Offset              : MQLONG;
    MsgFlags            : MQLONG;
    OriginalLength      : MQLONG;
  end;
  PMQMD = ^MQMD;

  MQMD1 = record
    StrucId             : MQCHAR4;
    Version             : MQLONG;
    Report              : MQLONG;
    MsgType             : MQLONG;
    Expiry              : MQLONG;
    FeedBack            : MQLONG;
    Encoding            : MQLONG;
    CodedCharSetId      : MQLONG;
    Format              : MQCHAR8;
    Priority            : MQLONG;
    Persistence         : MQLONG;
    MsgId               : MQBYTE24;
    CorrelId            : MQBYTE24;
    BackoutCount        : MQLONG;
    ReplyToQ            : MQCHAR48;
    ReplyToQMgr         : MQCHAR48;
    UserIdentifier      : MQCHAR12;
    AccountingToken     : MQBYTE32;
    ApplIdentityData    : MQCHAR32;
    PutApplType         : MQLONG;
    PutApplName         : MQCHAR28;
    PutDate             : MQCHAR8;
    PutTime             : MQCHAR8;
    ApplOriginData      : MQCHAR4;
  end;
  PMQMD1= ^MQMD1;

  MQMDE = record
    StrucId            : MQCHAR4;
    Version            : MQLONG;
    StrucLength        : MQLONG;
    Encoding           : MQLONG;
    CodedCharSetId     : MQLONG;
    Format             : MQCHAR8;
    Flags              : MQLONG;
    GroupId            : MQBYTE24;
    MsgSeqNumber       : MQLONG;
    Offset             : MQLONG;
    MsgFlags           : MQLONG;
    OriginalLength     : MQLONG;
  end;
  PMQMDE = ^MQMDE;

  MQPMO = record
    StrucId             : MQCHAR4;
    Version             : MQLONG;
    Options             : MQLONG;
    TimeOut             : MQLONG;
    Context             : MQHOBJ;
    KnownDestCount      : MQLONG;
    UnKnownDestCount    : MQLONG;
    InvalidDestCount    : MQLONG;
    ResolvedQName       : MQCHAR48;
    ResolvedQMgrName    : MQCHAR48;
    RecsPresent         : MQLONG;
    PutMsgRecFields     : MQLONG;
    PutMsgRecOffset     : MQLONG;
    ResponseRecOffset   : MQLONG;
    PutMsgRecPtr        : MQPTR;
    ResponseRecPtr      : MQPTR;
  end;
  PMQPMO = ^MQPMO;

  MQGMO = record
    StrucId             : MQCHAR4;
    Version             : MQLONG;
    Options             : MQLONG;
    WaitInterval        : MQLONG;
    Signal1             : MQLONG;
    Signal2             : MQLONG;
    ResolvedQName       : MQCHAR48;
    MatchOptions        : MQLONG;
    GroupStatus         : MQCHAR;
    SegmentStatus       : MQCHAR;
    Segmentation        : MQCHAR;
    Reserved1           : MQCHAR;
    MsgToken            : MQBYTE16;
    ReturnedLength      : MQLONG;
  end;
  PMQGMO = ^MQGMO;

  MQBO = record
    StrucId : MQCHAR4;
    Version : MQLONG;
    Options : MQLONG;
  end;
  PMQBO = ^MQBO;

  MQAIR = record
    StrucId            : MQCHAR4;
    Version            : MQLONG;
    AuthInfoType       : MQLONG;
    AuthInfoConnName   : MQCHAR264;
    LDAPUserNamePtr    : PMQCHAR;
    LDAPUserNameOffset : MQLONG;
    LDAPUserNameLength : MQLONG;
    LDAPPassword       : MQCHAR32;
  end;
  PMQAIR = ^MQAIR;

  MQSCO = record
    StrucId           : MQCHAR4;
    Version           : MQLONG;
    KeyRepository     : MQCHAR256;
    CryptoHardware    : MQCHAR256;
    AuthInfoRecCount  : MQLONG;
    AuthInfoRecOffset : MQLONG;
    AuthInfoRecPtr    : PMQAIR;
  end;
  PMQSCO = ^MQSCO;

  MQCNO = record
    StrucId          : MQCHAR4;
    Version          : MQLONG;
    Options          : MQLONG;
    ClientConnOffset : MQLONG;
    ClientConnPtr    : MQPTR;
    ConnTag          : MQBYTE128;
    SSLConfigPtr     : PMQSCO;
    SSLConfigOffset  : MQLONG;
  end;
  PMQCNO = ^ MQCNO;

  MQRFH = record
    StrucId          : MQCHAR4;
    Version          : MQLONG;
    StrucLength      : MQLONG;
    Encoding         : MQLONG;
    CodedCharSetId   : MQLONG;
    Format           : MQCHAR8;
    Flags            : MQLONG;
  end;
  PMQRFH = ^MQRFH;

  MQRFH2 = record
    StrucId          : MQCHAR4;
    Version          : MQLONG;
    StrucLength      : MQLONG;
    Encoding         : MQLONG;
    CodedCharSetId   : MQLONG;
    Format           : MQCHAR8;
    Flags            : MQLONG;
    NameValueCCSID   : MQLONG;
  end;
  PMQRFH2 = ^MQRFH2;

  MQDLH = record
    StrucId          : MQCHAR4;
    Version          : MQLONG;
    Reason           : MQLONG;
    DestQName        : MQCHAR48;
    DestQMgrName     : MQCHAR48;
    Encoding         : MQLONG;
    CodedCharSetId   : MQLONG;
    Format           : MQCHAR8;
    PutApplType      : MQLONG;
    PutApplName      : MQCHAR28;
    PutDate          : MQCHAR8;
    PutTime          : MQCHAR8;
  end;
  PMQDLH = ^MQDLH;

  MQIIH = record
    StrucId          : MQCHAR4;
    Version          : MQLONG;
    StrucLength      : MQLONG;
    Encoding         : MQLONG;
    CodedCharSetId   : MQLONG;
    Format           : MQCHAR8;
    Flags            : MQLONG;
    LTermOverride    : MQCHAR8;
    MFSMapName       : MQCHAR8;
    ReplyToFormat    : MQCHAR8;
    Authenticator    : MQCHAR8;
    TranInstanceId   : MQBYTE16;
    TranState        : MQCHAR;
    CommitMode       : MQCHAR;
    SecurityScope    : MQCHAR;
    Reserved         : MQCHAR;
  end;
  PMQIIH = ^MQIIH;

  MQCIH = record
    StrucId            : MQCHAR4;
    Version            : MQLONG;
    StrucLength        : MQLONG;
    Encoding           : MQLONG;
    CodedCharSetId     : MQLONG;
    Format             : MQCHAR8;
    Flags              : MQLONG;
    ReturnCode         : MQLONG;
    CompCode           : MQLONG;
    Reason             : MQLONG;
    UOWControl         : MQLONG;
    GetWaitInterval    : MQLONG;
    LinkType           : MQLONG;
    OutputDataLength   : MQLONG;
    FacilityKeepTime   : MQLONG;
    ADSDescriptor      : MQLONG;
    ConversationalTask : MQLONG;
    TaskEndStatus      : MQLONG;
    Facility           : MQCHAR8;
    Func               : MQCHAR4;
    AbendCode          : MQCHAR4;
    Authenticator      : MQCHAR8;
    Reserved1          : MQCHAR8;
    ReplyToFormat      : MQCHAR8;
    RemoteSysId        : MQCHAR4;
    RemoteTransId      : MQCHAR4;
    TransactionId      : MQCHAR4;
    FacilityLike       : MQCHAR4;
    AttentionId        : MQCHAR4;
    StartCode          : MQCHAR4;
    CancelCode         : MQCHAR4;
    NextTransactionId  : MQCHAR4;
    Reserved2          : MQCHAR8;
    Reserved3          : MQCHAR8;
    CursorPosition     : MQLONG;
    ErrorOffset        : MQLONG;
    InputItem          : MQLONG;
    Reserved4          : MQLONG;
  end;
  PMQCIH = ^MQCIH;

  MQDH = record
    StrucId            : MQCHAR4;
    Version            : MQLONG;
    StrucLength        : MQLONG;
    Encoding           : MQLONG;
    CodedCharSetId     : MQLONG;
    Format             : MQCHAR8;
    Flags              : MQLONG;
    PutMsgRecFields    : MQLONG;
    RecsPresent        : MQLONG;
    ObjectRecOffset    : MQLONG;
    PutMsgRecOffset    : MQLONG;
  end;
  PMQDH = ^MQDH;

  MQOR = record
    ObjectName         : MQCHAR48;
    ObjectQMgrName     : MQCHAR48;
  end;
  PMQOR = ^MQOR;

  MQRR = record
    CompCode           : MQLONG;
    Reason             : MQLONG;
  end;
  PMQRR = ^MQRR;

  MQPMR = record
    MsgId              : MQBYTE24;
    CorrelId           : MQBYTE24;
    GroupId            : MQBYTE24;
    FeedBack           : MQLONG;
    AccountingToken    : MQBYTE32;
  end;
  PMQPMR = ^MQPMR;

  MQRMH = record
    StrucId            : MQCHAR4;
    Version            : MQLONG;
    StrucLength        : MQLONG;
    Encoding           : MQLONG;
    CodedCharSetId     : MQLONG;
    Format             : MQCHAR8;
    Flags              : MQLONG;
    ObjectType         : MQCHAR8;
    ObjectInstanceId   : MQBYTE24;
    SrcEnvLength       : MQLONG;
    SrcEnvOffset       : MQLONG;
    SrcNameLength      : MQLONG;
    SrcNameOffset      : MQLONG;
    DestEnvLength      : MQLONG;
    DestEnvOffset      : MQLONG;
    DestNameLength     : MQLONG;
    DestNameOffset     : MQLONG;
    DataLogicalLength  : MQLONG;
    DataLogicalOffset  : MQLONG;
    DataLogicalOffset2 : MQLONG;
  end;
  PMQRMH = ^MQRMH;

  MQTM = record
    StrucId            : MQCHAR4;
    Version            : MQLONG;
    QName              : MQCHAR48;
    ProcessName        : MQCHAR48;
    TriggerData        : MQCHAR64;
    ApplType           : MQLONG;
    ApplId             : MQCHAR256;
    EnvData            : MQCHAR128;
    UserData           : MQCHAR128;
  end;
  PMQTM = ^MQTM;

  MQTMC2 = record
    StrucId            : MQCHAR4;
    Version            : MQCHAR4;
    QName              : MQCHAR48;
    ProcessName        : MQCHAR48;
    TriggerData        : MQCHAR64;
    ApplType           : MQLONG;
    ApplId             : MQCHAR256;
    EnvData            : MQCHAR128;
    UserData           : MQCHAR128;
    QMgrName           : MQCHAR48;
  end;
  PMQTMC2= ^MQTMC2;

  MQWIH = record
    StrucId            : MQCHAR4;
    Version            : MQLONG;
    StrucLength        : MQLONG;
    Encoding           : MQLONG;
    CodedCharSetId     : MQLONG;
    Format             : MQCHAR8;
    Flags              : MQLONG;
    ServiceName        : MQCHAR32;
    ServiceStep        : MQCHAR8;
    MsgToken           : MQBYTE16;
    Reserved           : MQCHAR32;
  end;
  PMQWIH = ^MQWIH;

  MQXP = record
    StrucId            : MQCHAR4;
    Version            : MQLONG;
    ExitId             : MQLONG;
    ExitReason         : MQLONG;
    ExitResponse       : MQLONG;
    ExitCommand        : MQLONG;
    ExitParamCount     : MQLONG;
    Reserved           : MQLONG;
    ExitUserArea       : MQBYTE16;
  end;
  PMQXP = ^MQXP;

  MQXQH = record
    StrucId            : MQCHAR4;
    Version            : MQLONG;
    RemoteQName        : MQCHAR48;
    RemoteQMgrName     : MQCHAR48;
    MsgDesc            : MQMD1;
  end;
  PMQXQH = ^MQXQH;

const
  MQOD_DEFAULT : MQOD = (StrucId:MQOD_STRUC_ID;
                         Version:MQOD_VERSION_1;
                         ObjectType:MQOT_Q;
                         ObjectName:#0;
                         ObjectQMgrName:#0;
                         DynamicQName:'AMQ.*'#0;
                         RecsPresent:0;
                         KnownDestCount:0;
                         UnKnownDestCount:0;
                         InvalidDestCount:0;
                         ObjectRecOffset:0;
                         ResponseRecOffset:0;
                         ObjectPointer:nil;
                         ResponseRecPointer:nil;
                         AlternateSecurityID:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                         ResolvedQName:#0;
                         ResolvedQMgrName:#0;
                         );
   MQMD_DEFAULT : MQMD = (StrucId:MQMD_STRUC_ID;
                          Version:MQMD_VERSION_1;
                          Report:MQRO_NONE;
                          MsgType:MQMT_DATAGRAM;
                          Expiry:MQEI_UNLIMITED;
                          FeedBack:MQFB_NONE;
                          Encoding:MQENC_NATIVE;
                          CodedCharSetId:MQCCSI_Q_MGR;
                          Format:MQFMT_NONE;
                          Priority:MQPRI_PRIORITY_AS_Q_DEF;
                          Persistence:MQPER_PERSISTENCE_AS_Q_DEF;
                          MsgId:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                          CorrelId:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                          BackoutCount:0;
                          ReplyToQ:#0;
                          ReplyToQMgr:#0;
                          UserIdentifier:#0;
                          AccountingToken:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                          ApplIdentityData:#0;
                          PutApplType:MQAT_NO_CONTEXT;
                          PutApplName:#0;
                          PutDate:#0;
                          PutTime:#0;
                          ApplOriginData:#0;
                          GroupId:( $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                          MsgSeqNumber:1;
                          Offset:0;
                          MsgFlags:MQMF_NONE;
                          OriginalLength:MQOL_UNDEFINED;
                         );
   MQMD1_DEFAULT : MQMD= (StrucId:MQMD_STRUC_ID;
                          Version:MQMD_VERSION_1;
                          Report:MQRO_NONE;
                          MsgType:MQMT_DATAGRAM;
                          Expiry:MQEI_UNLIMITED;
                          FeedBack:MQFB_NONE;
                          Encoding:MQENC_NATIVE;
                          CodedCharSetId:MQCCSI_Q_MGR;
                          Format:MQFMT_NONE;
                          Priority:MQPRI_PRIORITY_AS_Q_DEF;
                          Persistence:MQPER_PERSISTENCE_AS_Q_DEF;
                          MsgId:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                          CorrelId:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                          BackoutCount:0;
                          ReplyToQ:#0;
                          ReplyToQMgr:#0;
                          UserIdentifier:#0;
                          AccountingToken:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                          ApplIdentityData:#0;
                          PutApplType:MQAT_NO_CONTEXT;
                          PutApplName:#0;
                          PutDate:#0;
                          PutTime:#0;
                          ApplOriginData:#0;
                         );
  MQMDE_DEFAULT : MQMDE = (StrucId:MQMDE_STRUC_ID;
                           Version:MQMDE_VERSION_2;
                           StrucLength:MQMDE_LENGTH_2;
                           Encoding:MQENC_NATIVE;
                           CodedCharSetId:MQCCSI_UNDEFINED;
                           Format:(#0,#0,#0,#0,#0,#0,#0,#0);
                           Flags:MQMDEF_NONE;
                           GroupId:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                           MsgSeqNumber:1;
                           Offset:0;
                           MsgFlags:MQMF_NONE;
                           OriginalLength:MQOL_UNDEFINED;
                          );
  MQPMO_DEFAULT : MQPMO = (StrucId:MQPMO_STRUC_ID;
                           Version:MQPMO_VERSION_1;
                           Options:MQPMO_NONE;
                           TimeOut:-1;
                           Context:0;
                           KnownDestCount:0;
                           UnKnownDestCount:0;
                           InvalidDestCount:0;
                           ResolvedQName:#0;
                           ResolvedQMgrName:#0;
                           RecsPresent:0;
                           PutMsgRecFields:0;
                           PutMsgRecOffset:0;
                           PutMsgRecPtr:nil;
                           ResponseRecPtr:nil;
                          );
  MQGMO_DEFAULT : MQGMO = (StrucId:MQGMO_STRUC_ID;
                           Version:MQGMO_VERSION_1;
                           Options:MQGMO_NO_WAIT;
                           WaitInterval:0;
                           Signal1:0;
                           Signal2:0;
                           ResolvedQName:#0;
                           MatchOptions:(MQMO_MATCH_MSG_ID+MQMO_MATCH_CORREL_ID);
                           GroupStatus:MQGS_NOT_IN_GROUP;
                           SegmentStatus: MQSS_NOT_A_SEGMENT;
                           Segmentation:MQSEG_INHIBITED;
                           Reserved1:' ';
                           MsgToken:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                           ReturnedLength:MQRL_UNDEFINED;
                          );
   MQBO_DEFAULT : MQBO  = (StrucId:MQBO_STRUC_ID;
                           Version:MQBO_VERSION_1;
                           Options:MQBO_NONE;
                           );
   MQRR_DEFAULT : MQRR  = (CompCode:MQCC_OK;
                           Reason:MQRC_NONE;
                          );
   MQAIR_DEFAULT : MQAIR = (StrucId:MQAIR_STRUC_ID;
                            Version:MQAIR_VERSION_1;
                            AuthInfoType:MQAIT_CRL_LDAP;
                            AuthInfoConnName:#0;
                            LDAPUserNamePtr:nil;
                            LDAPUserNameOffset:0;
                            LDAPUserNameLength:0;
                            LDAPPassword:#0;
                            );
   MQCNO_DEFAULT : MQCNO = (StrucId:MQCNO_STRUC_ID;
                            Version:MQCNO_VERSION_1;
                            Options:MQCNO_NONE;
                            ClientConnOffset:0;
                            ClientConnPtr:nil;
                            ConnTag:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                            SSLConfigPtr:nil;
                            SSLConfigOffset:0;
                           );
   MQSCO_DEFAULT : MQSCO = (StrucId:MQSCO_STRUC_ID;
                            Version:MQSCO_VERSION_1;
                            KeyRepository:#0;
                            CryptoHardware:#0;
                            AuthInfoRecCount:0;
                            AuthInfoRecOffset:0;
                            AuthInfoRecPtr:nil;
                           );
   MQRFH2_DEFAULT : MQRFH2=(StrucId:MQRFH_STRUC_ID;
                            Version:MQRFH_VERSION_2;
                            StrucLength:MQRFH_STRUC_LENGTH_FIXED_2;
                            Encoding:MQENC_NATIVE;
                            CodedCharSetId:MQCCSI_INHERIT;
                            Format:'        ';
                            Flags:MQRFH_NONE;
                            NameValueCCSID:1208;
                           );
   MQRFH_DEFAULT : MQRFH = (StrucId:MQRFH_STRUC_ID;
                            Version:MQRFH_VERSION_1;
                            StrucLength:MQRFH_STRUC_LENGTH_FIXED;
                            Encoding:MQENC_NATIVE;
                            CodedCharSetId:MQCCSI_UNDEFINED;
                            Format:'        ';
                            Flags:MQRFH_NONE;
                           );
  MQDLH_DEFAULT : MQDLH  = (StrucId:MQDLH_STRUC_ID;
                            Version:MQDLH_VERSION_1;
                            DestQName:#0;
                            DestQMgrName:#0;
                            Encoding:0;
                            CodedCharSetId:MQCCSI_UNDEFINED;
                            Format:(#0,#0,#0,#0,#0,#0,#0,#0);
                            PutApplType:0;
                            PutApplName:#0;
                            PutDate:#0;
                            PutTime:#0;
                           );
  MQIIH_DEFAULT : MQIIH  = (StrucId:MQIIH_STRUC_ID;
                            Version:MQIIH_VERSION_1;
                            StrucLength:MQIIH_LENGTH_1;
                            Encoding:0;
                            CodedCharSetId:0;
                            Format:(#0,#0,#0,#0,#0,#0,#0,#0);
                            Flags:MQIIH_NONE;
                            LTermOverride:'        ';
                            MFSMapName:'        ';
                            ReplyToFormat:MQFMT_NONE;
                            Authenticator:'        ';
                            TranInstanceId:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                            TranState:MQITS_NOT_IN_CONVERSATION;
                            CommitMode:MQICM_COMMIT_THEN_SEND;
                            SecurityScope:MQISS_CHECK;
                            Reserved:' ';
                           );
  MQCIH_DEFAULT : MQCIH =  (StrucId:MQCIH_STRUC_ID;
                            Version:MQCIH_VERSION_2;
                            StrucLength:MQCIH_LENGTH_2;
                            Encoding:0;
                            CodedCharSetId:0;
                            Format:(#0,#0,#0,#0,#0,#0,#0,#0);
                            Flags:MQCIH_NONE;
                            ReturnCode:MQCRC_OK;
                            CompCode:MQCC_OK;
                            Reason:MQRC_NONE;
                            UOWControl:MQCUOWC_ONLY;
                            GetWaitInterval:MQCGWI_DEFAULT;
                            LinkType:MQCLT_PROGRAM;
                            OutputDataLength:MQCODL_AS_INPUT;
                            FacilityKeepTime:0;
                            ADSDescriptor:MQCADSD_NONE;
                            ConversationalTask:MQCCT_NO;
                            TaskEndStatus:MQCTES_NOSYNC;
                            Facility:(#0,#0,#0,#0,#0,#0,#0,#0);
                            Func:MQCFUNC_NONE;
                            AbendCode:'    ';
                            Authenticator:'        ';
                            Reserved1:'        ';
                            ReplyToFormat:MQFMT_NONE;
                            RemoteSysId:'    ';
                            RemoteTransId:'    ';
                            TransactionId:'    ';
                            FacilityLike:'    ';
                            AttentionId:'    ';
                            StartCode:MQCSC_NONE;
                            CancelCode:'    ';
                            NextTransactionId:'    ';
                            Reserved2:'        ';
                            Reserved3:'        ';
                            CursorPosition:0;
                            ErrorOffset:0;
                            InputItem:0;
                            Reserved4:0;
                           );
  MQDH_DEFAULT : MQDH    = (StrucId:MQDH_STRUC_ID;
                            Version:MQDH_VERSION_1;
                            StrucLength:0;
                            Encoding:0;
                            CodedCharSetId:MQCCSI_UNDEFINED;
                            Format:(#0,#0,#0,#0,#0,#0,#0,#0);
                            Flags:MQDHF_NONE;
                            PutMsgRecFields:MQPMRF_NONE;
                            RecsPresent:0;
                            ObjectRecOffset:0;
                            PutMsgRecOffset:0;
                           );
  MQOR_DEFAULT : MQOR    = (ObjectName:#0;
                             ObjectQMgrName:#0;
                           );
  MQRMH_DEFAULT : MQRMH  = (StrucId:MQRMH_STRUC_ID;
                            Version:MQRMH_VERSION_1;
                            StrucLength:0;
                            Encoding:MQENC_NATIVE;
                            CodedCharSetId:MQCCSI_UNDEFINED;
                            Format:(#0,#0,#0,#0,#0,#0,#0,#0);
                            Flags:MQRMHF_NOT_LAST;
                            ObjectType:'        ';
                            ObjectInstanceId:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                            SrcEnvLength:0;
                            SrcEnvOffset:0;
                            SrcNameLength:0;
                            SrcNameOffset:0;
                            DestEnvLength:0;
                            DestEnvOffset:0;
                            DestNameLength:0;
                            DestNameOffset:0;
                            DataLogicalLength:0;
                            DataLogicalOffset:0;
                            DataLogicalOffset2:0;
                           );
  MQTM_DEFAULT : MQTM    = (StrucId:MQTM_STRUC_ID;
                            Version:MQTM_VERSION_1;
                            QName:#0;
                            ProcessName:#0;
                            TriggerData:#0;
                            ApplType:0;
                            ApplId:#0;
                            EnvData:#0;
                            UserData:#0;
                           );
  MQTMC2_DEFAULT : MQTMC2= (StrucId:MQTMC_STRUC_ID;
                            Version:MQTMC_VERSION_2;
                            QName:#0;
                            ProcessName:#0;
                            TriggerData:#0;
                            ApplType:0;
                            ApplId:#0;
                            EnvData:#0;
                            UserData:#0;
                            QMgrName:#0;
                           );
  MQWIH_DEFAULT : MQWIH  = (StrucId:MQWIH_STRUC_ID;
                            Version:MQWIH_VERSION_1;
                            StrucLength:MQWIH_LENGTH_1;
                            Encoding:0;
                            CodedCharSetId:MQCCSI_UNDEFINED;
                            Format:(#0,#0,#0,#0,#0,#0,#0,#0);
                            Flags:MQWIH_NONE;
                            ServiceName:'                                ';
                            ServiceStep:'        ';
                            MsgToken:($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
                            Reserved:'                                ';
                           );

//=============================================================================
// Procedures
//=============================================================================

  procedure MQCONN (QMgrName:PMQCHAR48;HConn:PMQHCONN;Compcode,Reason:PMQLONG);cdecl;external 'mqm.dll';
  procedure MQCONNX(QMgrName:PMQCHAR48;ConnectOpts:PMQCNO;Hconn:PMQHCONN;Compcode,Reason:PMQLONG);cdecl;external 'mqm.dll';
  procedure MQDISC (HConn:PMQHCONN;Compcode,Reason:PMQLONG);cdecl;external 'mqm.dll';
  procedure MQOPEN (HConn:MQHCONN;ObjDesc:PMQOD;Options:MQLONG;Hobj: PMQHOBJ; CompCode, Reason:PMQLONG);cdecl;external 'mqm.dll';
  procedure MQCLOSE(HConn:MQHCONN;HObj:PMQHOBJ;Options:MQLONG;Compcode,Reason :PMQLONG);cdecl;external 'mqm.dll';
  procedure MQPUT  (HConn:MQHCONN;HObj:MQHOBJ;MsgDesc:PMQMD;PutMsgOptions:PMQPMO;BufferLength:MQLONG;Buffer:PChar;CompCode,Reason:PMQLONG);cdecl;external 'mqm.dll';
  procedure MQGET  (Hconn:MQHCONN;HObj:MQHOBJ;MsgDesc:PMQMD;GetMsgOptions:PMQGMO;BufferLength:MQLONG;Buffer:PChar;DataLength:PMQLONG;CompCode, Reason:PMQLONG);cdecl;external 'mqm.dll';
  procedure MQPUT1 (Hconn:MQHCONN;ObjDesc:PMQOD;MsgDesc:PMQMD;PutMsgOptions:PMQPMO;BufferLength:MQLONG;Buffer:PChar;CompCode, Reason:PMQLONG);cdecl;external 'mqm.dll';
  procedure MQINQ  (Hconn:MQHCONN;HObj:MQHOBJ;SelectorCount:MQLONG;Selectors:PMQLONG;IntAttrCount:MQLONG;IntAttrs:PMQLONG;CharAttrLength:MQLONG;CharAttrs:PMQCHAR;CompCode, Reason:PMQLONG);cdecl;external 'mqm.dll';
  procedure MQSET  (Hconn:MQHCONN;HObj:MQHOBJ;SelectorCount:MQLONG;Selectors:PMQLONG;IntAttrCount:MQLONG;IntAttrs:PMQLONG;CharAttrLength:MQLONG;CharAttrs:PMQCHAR;CompCode, Reason:PMQLONG);cdecl;external 'mqm.dll';
  procedure MQBEGIN(Hconn:MQHCONN;BeginOptions:PMQBO;CompCode, Reason:PMQLONG);cdecl;external 'mqm.dll';
  procedure MQBACK (Hconn:MQHCONN;CompCode, Reason:PMQLONG);cdecl;external 'mqm.dll';
  procedure MQCMIT (Hconn:MQHCONN;CompCode, Reason:PMQLONG);cdecl;external 'mqm.dll';

//*****************************************************************************

implementation

uses
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'MMQI';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile: $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2007/05/04 14:07:55 $';

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of MMQI
