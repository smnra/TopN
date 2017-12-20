select *
from 
    (SELECT
        servlev.city,
        servlev.wcel_rnc_id,
        servlev.ci,
        servlev.wbts_name,
        servlev.rpdate,
        rank() over( Partition by servlev.city Order by servlev.RAB建立成功率_Y - servlev.RAB建立成功率_X DESC) AS RANKS,
        servlev.无线接通率,
        servlev.RAB建立成功率_X,
        servlev.RAB建立成功率_Y,
        servlev.RRC建立成功率_X,
        servlev.RRC建立成功率_Y,
        servlev.RRC_CONN_STP_ATT,
        servlev.RRC_CONN_SETUP_COMP_AFT_DIR,
        servlev.RRC_CONN_STP_REJ_EMERG_CALL,
        servlev.RRC_CONN_ACC_REL_CELL_RESEL,
        servlev.RRC_CONN_SETUP_ATT_REPEAT,
        servlev.RRC_CONN_ACC_COMP,
        servlev.RRC_CON_SETUP_COMP_DIRECTED,
        servlev.RAB_ACC_COMP_CS_VOICE,
        servlev.RAB_ACC_COMP_CS_CONV,
        servlev.RAB_ACC_COMP_CS_STREA,
        servlev.RAB_ACC_COMP_PS_CONV,
        servlev.RAB_ACC_COMP_PS_STREA,
        servlev.RAB_ACC_COMP_PS_INTER,
        servlev.RAB_ACC_COMP_PS_BACKG,
        servlev.RAB_STP_ATT_CS_VOICE,
        servlev.RAB_STP_ATT_CS_CONV,
        servlev.RAB_STP_ATT_CS_STREA,
        servlev.RAB_STP_ATT_PS_CONV,
        servlev.RAB_STP_ATT_PS_STREA,
        servlev.RAB_STP_ATT_PS_INTER,
        servlev.RAB_STP_ATT_PS_BACKG
            
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(servlev.period_start_time,'YYYY-MM-DD') rpdate,
            
            
            round(decode(Sum(servlev.RRC_CONN_STP_ATT + servlev.RRC_CONN_SETUP_COMP_AFT_DIR -
            servlev.RRC_CONN_STP_REJ_EMERG_CALL - servlev.RRC_CONN_ACC_REL_CELL_RESEL -
            servlev.RRC_CONN_SETUP_ATT_REPEAT + rrc.CELL_FACH_STATE_CELL_PCH_INA +
            rrc.CELL_DCH_STATE_TO_CELL_PCH),0,1,Sum(servlev.RRC_CONN_ACC_COMP + servlev.RRC_CON_SETUP_COMP_DIRECTED +
            rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH)/Sum(servlev.RRC_CONN_STP_ATT + servlev.RRC_CONN_SETUP_COMP_AFT_DIR -
            servlev.RRC_CONN_STP_REJ_EMERG_CALL - servlev.RRC_CONN_ACC_REL_CELL_RESEL -
            servlev.RRC_CONN_SETUP_ATT_REPEAT + rrc.CELL_FACH_STATE_CELL_PCH_INA +
            rrc.CELL_DCH_STATE_TO_CELL_PCH))            
            *
            decode(Sum(servlev.RAB_STP_ATT_CS_VOICE + servlev.RAB_STP_ATT_CS_CONV +
            servlev.RAB_STP_ATT_CS_STREA + servlev.RAB_STP_ATT_PS_CONV +
            servlev.RAB_STP_ATT_PS_STREA + servlev.RAB_STP_ATT_PS_INTER +
            servlev.RAB_STP_ATT_PS_BACKG),0,1,Sum(servlev.RAB_ACC_COMP_CS_VOICE + servlev.RAB_ACC_COMP_CS_CONV +
            servlev.RAB_ACC_COMP_CS_STREA + servlev.RAB_ACC_COMP_PS_CONV +
            servlev.RAB_ACC_COMP_PS_STREA + servlev.RAB_ACC_COMP_PS_INTER +
            servlev.RAB_ACC_COMP_PS_BACKG)/Sum(servlev.RAB_STP_ATT_CS_VOICE + servlev.RAB_STP_ATT_CS_CONV +
            servlev.RAB_STP_ATT_CS_STREA + servlev.RAB_STP_ATT_PS_CONV +
            servlev.RAB_STP_ATT_PS_STREA + servlev.RAB_STP_ATT_PS_INTER +
            servlev.RAB_STP_ATT_PS_BACKG))
            
            *100,4)  AS 无线接通率,
            
            
            

            Sum(servlev.RRC_CONN_ACC_COMP + servlev.RRC_CON_SETUP_COMP_DIRECTED +
            rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) As RRC建立成功率_X,

            Sum(servlev.RRC_CONN_STP_ATT + servlev.RRC_CONN_SETUP_COMP_AFT_DIR -
            servlev.RRC_CONN_STP_REJ_EMERG_CALL - servlev.RRC_CONN_ACC_REL_CELL_RESEL -
            servlev.RRC_CONN_SETUP_ATT_REPEAT + rrc.CELL_FACH_STATE_CELL_PCH_INA +
            rrc.CELL_DCH_STATE_TO_CELL_PCH) As RRC建立成功率_Y,

            Sum(servlev.RAB_ACC_COMP_CS_VOICE + servlev.RAB_ACC_COMP_CS_CONV +
            servlev.RAB_ACC_COMP_CS_STREA + servlev.RAB_ACC_COMP_PS_CONV +
            servlev.RAB_ACC_COMP_PS_STREA + servlev.RAB_ACC_COMP_PS_INTER +
            servlev.RAB_ACC_COMP_PS_BACKG) As RAB建立成功率_X,
            
            Sum(servlev.RAB_STP_ATT_CS_VOICE + servlev.RAB_STP_ATT_CS_CONV +
            servlev.RAB_STP_ATT_CS_STREA + servlev.RAB_STP_ATT_PS_CONV +
            servlev.RAB_STP_ATT_PS_STREA + servlev.RAB_STP_ATT_PS_INTER +
            servlev.RAB_STP_ATT_PS_BACKG) As RAB建立成功率_Y,
            
            sum(servlev.RRC_CONN_STP_ATT) AS RRC_CONN_STP_ATT,
            sum(servlev.RRC_CONN_SETUP_COMP_AFT_DIR) AS RRC_CONN_SETUP_COMP_AFT_DIR,
            sum(servlev.RRC_CONN_STP_REJ_EMERG_CALL) AS RRC_CONN_STP_REJ_EMERG_CALL,
            sum(servlev.RRC_CONN_ACC_REL_CELL_RESEL) AS RRC_CONN_ACC_REL_CELL_RESEL,
            sum(servlev.RRC_CONN_SETUP_ATT_REPEAT) AS RRC_CONN_SETUP_ATT_REPEAT,
            sum(servlev.RRC_CONN_ACC_COMP) AS RRC_CONN_ACC_COMP,
            sum(servlev.RRC_CON_SETUP_COMP_DIRECTED) AS RRC_CON_SETUP_COMP_DIRECTED,
            SUM(servlev.RAB_ACC_COMP_CS_VOICE) AS RAB_ACC_COMP_CS_VOICE,
            SUM(servlev.RAB_ACC_COMP_CS_CONV) AS RAB_ACC_COMP_CS_CONV,
            SUM(servlev.RAB_ACC_COMP_CS_STREA) AS RAB_ACC_COMP_CS_STREA,
            SUM(servlev.RAB_ACC_COMP_PS_CONV) AS RAB_ACC_COMP_PS_CONV,
            SUM(servlev.RAB_ACC_COMP_PS_STREA) AS RAB_ACC_COMP_PS_STREA,
            SUM(servlev.RAB_ACC_COMP_PS_INTER) AS RAB_ACC_COMP_PS_INTER,
            SUM(servlev.RAB_ACC_COMP_PS_BACKG) AS RAB_ACC_COMP_PS_BACKG,
            SUM(servlev.RAB_STP_ATT_CS_VOICE) AS RAB_STP_ATT_CS_VOICE,
            SUM(servlev.RAB_STP_ATT_CS_CONV) AS RAB_STP_ATT_CS_CONV,
            SUM(servlev.RAB_STP_ATT_CS_STREA) AS RAB_STP_ATT_CS_STREA,
            SUM(servlev.RAB_STP_ATT_PS_CONV) AS RAB_STP_ATT_PS_CONV,
            SUM(servlev.RAB_STP_ATT_PS_STREA) AS RAB_STP_ATT_PS_STREA,
            SUM(servlev.RAB_STP_ATT_PS_INTER) AS RAB_STP_ATT_PS_INTER,
            SUM(servlev.RAB_STP_ATT_PS_BACKG) AS RAB_STP_ATT_PS_BACKG


        From
            NOKRWW_PS_SERVLEV_MNC1_RAW servlev
        Left Join NOKRWW_PS_RRC_MNC1_RAW rrc
             ON servlev.period_start_time = rrc.period_start_time
            AND servlev.WCEL_ID = rrc.WCEL_ID
            AND rrc.period_start_time >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24')
            AND rrc.period_start_time < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
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
        ) servlev
        
    WHERE
        (servlev.无线接通率 < 95 AND servlev.RAB建立成功率_Y >= 40)

    ORDER BY
        servlev.city,
        servlev.RAB建立成功率_Y - servlev.RAB建立成功率_X DESC
    ) 

WHERE
    RANKS <= 5
 