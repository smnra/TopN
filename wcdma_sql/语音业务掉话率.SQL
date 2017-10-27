    SELECT
        servlev.city,
        servlev.wcel_rnc_id,
        servlev.ci,
        servlev.wbts_name,
        servlev.rpdate,
        servlev.语音业务掉话率,
        servlev.X_语音业务掉话率,
        servlev.Y_语音业务掉话率,
        servlev.RAB_ACT_FAIL_CS_VOICE_IU,
        servlev.RAB_ACT_FAIL_CS_VOICE_RADIO,
        servlev.RAB_ACT_FAIL_CS_VOICE_BTS,
        servlev.RAB_ACT_FAIL_CS_VOICE_IUR,
        servlev.RAB_ACT_FAIL_CS_VOICE_RNC,
        servlev.RAB_ACT_FAIL_CS_VOICE_UE,
        servlev.RAB_ACT_FAIL_CS_VOICE_TRANS,
        servlev.RAB_ACT_REL_CS_VOICE_P_EMP
            
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(servlev.period_start_time,'YYYY-MM-DD') rpdate,
            
            ROUND(Decode(Sum(servlev.RAB_ACT_COMP_CS_VOICE + servlev.RAB_ACT_REL_CS_VOICE_SRNC +
            servlev.RAB_ACT_REL_CS_VOICE_P_EMP + servlev.RAB_ACT_FAIL_CS_VOICE_IU +
            servlev.RAB_ACT_FAIL_CS_VOICE_RADIO + servlev.RAB_ACT_FAIL_CS_VOICE_BTS +
            servlev.RAB_ACT_FAIL_CS_VOICE_IUR + servlev.RAB_ACT_FAIL_CS_VOICE_RNC +
            servlev.RAB_ACT_FAIL_CS_VOICE_UE), 0, 0, Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IU +
            servlev.RAB_ACT_FAIL_CS_VOICE_RADIO + servlev.RAB_ACT_FAIL_CS_VOICE_BTS +
            servlev.RAB_ACT_FAIL_CS_VOICE_IUR + servlev.RAB_ACT_FAIL_CS_VOICE_RNC +
            servlev.RAB_ACT_FAIL_CS_VOICE_UE) / Sum(servlev.RAB_ACT_COMP_CS_VOICE +
            servlev.RAB_ACT_REL_CS_VOICE_SRNC + servlev.RAB_ACT_REL_CS_VOICE_P_EMP +
            servlev.RAB_ACT_FAIL_CS_VOICE_IU + servlev.RAB_ACT_FAIL_CS_VOICE_RADIO +
            servlev.RAB_ACT_FAIL_CS_VOICE_BTS + servlev.RAB_ACT_FAIL_CS_VOICE_IUR +
            servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE))*100,2) As 语音业务掉话率,
            
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IU + servlev.RAB_ACT_FAIL_CS_VOICE_RADIO +
            servlev.RAB_ACT_FAIL_CS_VOICE_BTS + servlev.RAB_ACT_FAIL_CS_VOICE_IUR +
            servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE) As X_语音业务掉话率,
            
            Sum(servlev.RAB_ACT_COMP_CS_VOICE + servlev.RAB_ACT_REL_CS_VOICE_SRNC +
            servlev.RAB_ACT_REL_CS_VOICE_P_EMP + servlev.RAB_ACT_FAIL_CS_VOICE_IU +
            servlev.RAB_ACT_FAIL_CS_VOICE_RADIO + servlev.RAB_ACT_FAIL_CS_VOICE_BTS +
            servlev.RAB_ACT_FAIL_CS_VOICE_IUR + servlev.RAB_ACT_FAIL_CS_VOICE_RNC +
            servlev.RAB_ACT_FAIL_CS_VOICE_UE) As Y_语音业务掉话率,
            
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IU) As RAB_ACT_FAIL_CS_VOICE_IU,
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_RADIO) As RAB_ACT_FAIL_CS_VOICE_RADIO,
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_BTS) As RAB_ACT_FAIL_CS_VOICE_BTS,
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IUR) As RAB_ACT_FAIL_CS_VOICE_IUR,
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_RNC) As RAB_ACT_FAIL_CS_VOICE_RNC,
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_UE) As RAB_ACT_FAIL_CS_VOICE_UE,
            Sum(servlev.RAB_ACT_FAIL_CS_VOICE_TRANS) As RAB_ACT_FAIL_CS_VOICE_TRANS,
            Sum(servlev.RAB_ACT_REL_CS_VOICE_P_EMP) As RAB_ACT_REL_CS_VOICE_P_EMP
            
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
        (servlev.语音业务掉话率 > 20)

    ORDER BY
        servlev.city,
        servlev.语音业务掉话率  

   