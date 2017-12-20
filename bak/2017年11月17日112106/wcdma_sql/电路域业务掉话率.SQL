select *
from 
    (SELECT
        servlev.city,
        servlev.wcel_rnc_id,
        servlev.ci,
        servlev.wbts_name,
        servlev.rpdate,
        rank() over( Partition by servlev.city Order by servlev.语音业务掉话率_X DESC) AS RANKS,
        servlev.语音业务掉话率,
        servlev.语音业务掉话率_X,
        servlev.语音业务掉话率_Y,
        servlev.RAB_ACT_COMP_CS_VOICE,
        servlev.RAB_ACT_REL_CS_VOICE_SRNC,
        servlev.RAB_ACT_REL_CS_VOICE_P_EMP,
        servlev.RAB_ACT_FAIL_CS_VOICE_IU,
        servlev.RAB_ACT_FAIL_CS_VOICE_RADIO,
        servlev.RAB_ACT_FAIL_CS_VOICE_BTS,
        servlev.RAB_ACT_FAIL_CS_VOICE_IUR,
        servlev.RAB_ACT_FAIL_CS_VOICE_RNC,
        servlev.RAB_ACT_FAIL_CS_VOICE_UE
            
        
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(servlev.period_start_time,'YYYY-MM-DD') rpdate,

            Round(Decode(Sum(servlev.RAB_ACT_COMP_CS_VOICE +
            servlev.RAB_ACT_REL_CS_VOICE_SRNC + servlev.RAB_ACT_REL_CS_VOICE_P_EMP +
            servlev.RAB_ACT_FAIL_CS_VOICE_IU + servlev.RAB_ACT_FAIL_CS_VOICE_RADIO +
            servlev.RAB_ACT_FAIL_CS_VOICE_BTS + servlev.RAB_ACT_FAIL_CS_VOICE_IUR +
            servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE),
            0, Null, Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IU +
            servlev.RAB_ACT_FAIL_CS_VOICE_RADIO + servlev.RAB_ACT_FAIL_CS_VOICE_BTS +
            servlev.RAB_ACT_FAIL_CS_VOICE_IUR + servlev.RAB_ACT_FAIL_CS_VOICE_RNC +
            servlev.RAB_ACT_FAIL_CS_VOICE_UE) / Sum(servlev.RAB_ACT_COMP_CS_VOICE +
            servlev.RAB_ACT_REL_CS_VOICE_SRNC + servlev.RAB_ACT_REL_CS_VOICE_P_EMP +
            servlev.RAB_ACT_FAIL_CS_VOICE_IU + servlev.RAB_ACT_FAIL_CS_VOICE_RADIO +
            servlev.RAB_ACT_FAIL_CS_VOICE_BTS + servlev.RAB_ACT_FAIL_CS_VOICE_IUR +
            servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE))*100, 4) As 语音业务掉话率,

            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IU + servlev.RAB_ACT_FAIL_CS_VOICE_RADIO +
            servlev.RAB_ACT_FAIL_CS_VOICE_BTS + servlev.RAB_ACT_FAIL_CS_VOICE_IUR +
            servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE) As 语音业务掉话率_X,

            Sum(servlev.RAB_ACT_COMP_CS_VOICE + servlev.RAB_ACT_REL_CS_VOICE_SRNC +
            servlev.RAB_ACT_REL_CS_VOICE_P_EMP + servlev.RAB_ACT_FAIL_CS_VOICE_IU +
            servlev.RAB_ACT_FAIL_CS_VOICE_RADIO + servlev.RAB_ACT_FAIL_CS_VOICE_BTS +
            servlev.RAB_ACT_FAIL_CS_VOICE_IUR + servlev.RAB_ACT_FAIL_CS_VOICE_RNC +
            servlev.RAB_ACT_FAIL_CS_VOICE_UE) As 语音业务掉话率_Y,
            
            Sum(servlev.RAB_ACT_COMP_CS_VOICE) As RAB_ACT_COMP_CS_VOICE,
            Sum(servlev.RAB_ACT_REL_CS_VOICE_SRNC) As RAB_ACT_REL_CS_VOICE_SRNC,
            Sum(servlev.RAB_ACT_REL_CS_VOICE_P_EMP) As RAB_ACT_REL_CS_VOICE_P_EMP,
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IU) As RAB_ACT_FAIL_CS_VOICE_IU,
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_RADIO) As RAB_ACT_FAIL_CS_VOICE_RADIO,
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_BTS) As RAB_ACT_FAIL_CS_VOICE_BTS,
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IUR) As RAB_ACT_FAIL_CS_VOICE_IUR,
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_RNC) As RAB_ACT_FAIL_CS_VOICE_RNC,
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_UE) As RAB_ACT_FAIL_CS_VOICE_UE
            
            
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
        (servlev.语音业务掉话率 < 99 and servlev.语音业务掉话率_X >= 20)

    ORDER BY 
        servlev.CITY,
        servlev.语音业务掉话率_X DESC
    
    ) 

WHERE
    RANKS <=10   
 