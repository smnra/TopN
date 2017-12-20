select *
from 
    (SELECT
        servlev.city,
        servlev.wcel_rnc_id,
        servlev.ci,
        servlev.wbts_name,
        servlev.rpdate,
        rank() over( Partition by servlev.city Order by 分组RAB建立成功率_Y - servlev.分组RAB建立成功率_X DESC) AS RANKS,
        servlev.分组RAB建立成功率,
        servlev.分组RAB建立成功率_X,
        servlev.分组RAB建立成功率_Y,
        servlev.RAB_ACC_COMP_PS_CONV,
        servlev.RAB_STP_ATT_PS_STREA,
        servlev.RAB_STP_ATT_PS_INTER,
        servlev.RAB_STP_ATT_PS_BACKG,
        servlev.CELL_FACH_STATE_CELL_PCH_INA,
        servlev.CELL_DCH_STATE_TO_CELL_PCH,
        servlev.RAB_ACC_COMP_PS_STREA,
        servlev.RAB_ACC_COMP_PS_INTER,
        servlev.RAB_ACC_COMP_PS_BACKG
            
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(servlev.period_start_time,'YYYY-MM-DD') rpdate,

            Round(Decode(Sum(servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA +
            servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG +
            rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH), 0,
            Null, Sum(servlev.RAB_ACC_COMP_PS_CONV + servlev.RAB_ACC_COMP_PS_STREA +
            servlev.RAB_ACC_COMP_PS_INTER + servlev.RAB_ACC_COMP_PS_BACKG +
            rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) /
            (Sum(servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA +
            servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG +
            rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH)))*100, 4) As 分组RAB建立成功率,

            Sum(servlev.RAB_ACC_COMP_PS_CONV + servlev.RAB_ACC_COMP_PS_STREA +
            servlev.RAB_ACC_COMP_PS_INTER + servlev.RAB_ACC_COMP_PS_BACKG +
            rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) As 分组RAB建立成功率_X,

            Sum(servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA +
            servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG +
            rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) As 分组RAB建立成功率_Y,
            
            Sum(servlev.RAB_ACC_COMP_PS_CONV) AS RAB_ACC_COMP_PS_CONV,
            Sum(servlev.RAB_STP_ATT_PS_STREA) AS RAB_STP_ATT_PS_STREA,
            Sum(servlev.RAB_STP_ATT_PS_INTER) AS RAB_STP_ATT_PS_INTER,
            Sum(servlev.RAB_STP_ATT_PS_BACKG) AS RAB_STP_ATT_PS_BACKG,
            Sum(rrc.CELL_FACH_STATE_CELL_PCH_INA) AS CELL_FACH_STATE_CELL_PCH_INA,
            Sum(rrc.CELL_DCH_STATE_TO_CELL_PCH) AS CELL_DCH_STATE_TO_CELL_PCH,
            Sum(servlev.RAB_ACC_COMP_PS_STREA) AS RAB_ACC_COMP_PS_STREA,
            Sum(servlev.RAB_ACC_COMP_PS_INTER) AS RAB_ACC_COMP_PS_INTER,
            Sum(servlev.RAB_ACC_COMP_PS_BACKG) AS RAB_ACC_COMP_PS_BACKG


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
        (servlev.分组RAB建立成功率 < 99 AND servlev.分组RAB建立成功率_Y >= 20)

    ORDER BY
        servlev.city,
        分组RAB建立成功率_Y - servlev.分组RAB建立成功率_X DESC 

 
    
    ) 

WHERE
    RANKS <= 5   
 