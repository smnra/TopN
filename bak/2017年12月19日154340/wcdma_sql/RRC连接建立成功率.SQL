select *
from 
    (SELECT
        servlev.city,
        servlev.wcel_rnc_id,
        servlev.ci,
        servlev.wbts_name,
        servlev.rpdate,
        rank() over( Partition by servlev.city Order by servlev.Y_RRC建立成功率 - servlev.X_RRC建立成功率 DESC) AS RANKS,
        servlev.RRC建立成功率,
        servlev.X_RRC建立成功率,
        servlev.Y_RRC建立成功率,
        servlev.无线接通率,
        servlev.RRC_CONN_STP_ATT,
        servlev.RRC_CONN_SETUP_COMP_AFT_DIR,
        servlev.RRC_CONN_STP_REJ_EMERG_CALL,
        servlev.RRC_CONN_ACC_REL_CELL_RESEL,
        servlev.RRC_CONN_SETUP_ATT_REPEAT,
        servlev.RRC_CONN_ACC_COMP,
        servlev.RRC_CON_SETUP_COMP_DIRECTED
        
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(servlev.period_start_time,'YYYY-MM-DD') rpdate,
            ROUND(Decode(Sum(servlev.RAB_STP_ATT_CS_VOICE + servlev.RAB_STP_ATT_CS_CONV +
            servlev.RAB_STP_ATT_CS_STREA + servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA
            + servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG) *
            Sum(servlev.MOC_CONV_CALL_ATTS + servlev.MTC_CONV_CALL_ATTS - servlev.RRC_ATT_REP_MO_CONV
            - servlev.RRC_ATT_REP_MT_CONV - servlev.RRC_ACC_REL_MO_CONV - servlev.RRC_ACC_REL_MT_CONV
            + servlev.MOC_STREA_CALL_ATTS + servlev.MOC_INTER_CALL_ATTS + servlev.MOC_BACKG_CALL_ATTS
            + servlev.MTC_STREA_CALL_ATTS + servlev.MTC_INTER_CALL_ATTS + servlev.MTC_BACKG_CALL_ATTS
            - servlev.RRC_ATT_REP_MO_STREAMING - servlev.RRC_ATT_REP_MO_INTERACTIVE -
            servlev.RRC_ATT_REP_MO_BACKGROUND - servlev.RRC_ATT_REP_MT_STREAMING -
            servlev.RRC_ATT_REP_INTERACTIVE - servlev.RRC_ATT_REP_MT_BACKGROUND -
            servlev.RRC_ACC_REL_MO_STREAMING - servlev.RRC_ACC_REL_MO_INTERACTIVE -
            servlev.RRC_ACC_REL_MO_BACKGROUND - servlev.RRC_ACC_REL_MT_STREAMING -
            servlev.RRC_ACC_REL_INTERACTIVE - servlev.RRC_ACC_REL_MT_BACKGROUND), 0, 0,
            Sum(servlev.SUCC_RRC_SETUP_CONV + servlev.SUCC_RRC_SETUP_STREA +
            servlev.SUCC_RRC_SETUP_INTERA + servlev.SUCC_RRC_SETUP_BACKG) *
            Sum(servlev.RAB_ACC_COMP_CS_VOICE + servlev.RAB_ACC_COMP_CS_CONV +
            servlev.RAB_ACC_COMP_CS_STREA + servlev.RAB_ACC_COMP_PS_CONV +
            servlev.RAB_ACC_COMP_PS_STREA + servlev.RAB_ACC_COMP_PS_INTER +
            servlev.RAB_ACC_COMP_PS_BACKG) / (Sum(servlev.RAB_STP_ATT_CS_VOICE +
            servlev.RAB_STP_ATT_CS_CONV + servlev.RAB_STP_ATT_CS_STREA + servlev.RAB_STP_ATT_PS_CONV
            + servlev.RAB_STP_ATT_PS_STREA + servlev.RAB_STP_ATT_PS_INTER +
            servlev.RAB_STP_ATT_PS_BACKG) * Sum(servlev.MOC_CONV_CALL_ATTS +
            servlev.MTC_CONV_CALL_ATTS - servlev.RRC_ATT_REP_MO_CONV - servlev.RRC_ATT_REP_MT_CONV -
            servlev.RRC_ACC_REL_MO_CONV - servlev.RRC_ACC_REL_MT_CONV + servlev.MOC_STREA_CALL_ATTS +
            servlev.MOC_INTER_CALL_ATTS + servlev.MOC_BACKG_CALL_ATTS + servlev.MTC_STREA_CALL_ATTS +
            servlev.MTC_INTER_CALL_ATTS + servlev.MTC_BACKG_CALL_ATTS -
            servlev.RRC_ATT_REP_MO_STREAMING - servlev.RRC_ATT_REP_MO_INTERACTIVE -
            servlev.RRC_ATT_REP_MO_BACKGROUND - servlev.RRC_ATT_REP_MT_STREAMING -
            servlev.RRC_ATT_REP_INTERACTIVE - servlev.RRC_ATT_REP_MT_BACKGROUND -
            servlev.RRC_ACC_REL_MO_STREAMING - servlev.RRC_ACC_REL_MO_INTERACTIVE -
            servlev.RRC_ACC_REL_MO_BACKGROUND - servlev.RRC_ACC_REL_MT_STREAMING -
            servlev.RRC_ACC_REL_INTERACTIVE - servlev.RRC_ACC_REL_MT_BACKGROUND)))*100,2) As 无线接通率,
            
            ROUND(Decode(Sum(servlev.RRC_CONN_STP_ATT + servlev.RRC_CONN_SETUP_COMP_AFT_DIR -
            servlev.RRC_CONN_STP_REJ_EMERG_CALL - servlev.RRC_CONN_ACC_REL_CELL_RESEL -
            servlev.RRC_CONN_SETUP_ATT_REPEAT), 0, 0, Sum(servlev.RRC_CONN_ACC_COMP +
            servlev.RRC_CON_SETUP_COMP_DIRECTED) / Sum(servlev.RRC_CONN_STP_ATT +
            servlev.RRC_CONN_SETUP_COMP_AFT_DIR - servlev.RRC_CONN_STP_REJ_EMERG_CALL -
            servlev.RRC_CONN_ACC_REL_CELL_RESEL - servlev.RRC_CONN_SETUP_ATT_REPEAT))*100,2) As RRC建立成功率,
            
            Sum(servlev.RRC_CONN_ACC_COMP + servlev.RRC_CON_SETUP_COMP_DIRECTED) As X_RRC建立成功率,
            
            Sum(servlev.RRC_CONN_STP_ATT + servlev.RRC_CONN_SETUP_COMP_AFT_DIR -
            servlev.RRC_CONN_STP_REJ_EMERG_CALL - servlev.RRC_CONN_ACC_REL_CELL_RESEL -
            servlev.RRC_CONN_SETUP_ATT_REPEAT) As Y_RRC建立成功率,
            
            sum(servlev.RRC_CONN_STP_ATT) AS RRC_CONN_STP_ATT,
            sum(servlev.RRC_CONN_SETUP_COMP_AFT_DIR) AS RRC_CONN_SETUP_COMP_AFT_DIR,
            sum(servlev.RRC_CONN_STP_REJ_EMERG_CALL) AS RRC_CONN_STP_REJ_EMERG_CALL,
            sum(servlev.RRC_CONN_ACC_REL_CELL_RESEL) AS RRC_CONN_ACC_REL_CELL_RESEL,
            sum(servlev.RRC_CONN_SETUP_ATT_REPEAT) AS RRC_CONN_SETUP_ATT_REPEAT,
            sum(servlev.RRC_CONN_ACC_COMP) AS RRC_CONN_ACC_COMP,
            sum(servlev.RRC_CON_SETUP_COMP_DIRECTED) AS RRC_CON_SETUP_COMP_DIRECTED

            
        From
            NOKRWW_PS_SERVLEV_MNC1_RAW servlev
        Inner Join c_w_custom c on c.wcel_objid = servlev.WCEL_ID  
        
        Where
            servlev.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            servlev.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(servlev.period_start_time,'YYYY-MM-DD')
        )  servlev
        
    WHERE
        (servlev.RRC建立成功率 < 99 and servlev.Y_RRC建立成功率 >= 100)

    ORDER BY
        servlev.city,
        servlev.Y_RRC建立成功率 - servlev.X_RRC建立成功率 DESC 
    ) 

WHERE
    RANKS <= 5 