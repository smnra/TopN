    SELECT
        servlev.city,
        servlev.wcel_rnc_id,
        servlev.ci,
        servlev.wbts_name,
        servlev.rpdate,
        servlev.语音业务RAB建立成功率,
        servlev.X_语音业务RAB建立SucRat,
        servlev.Y_语音业务RAB建立SucRat,
        servlev.RAB_STP_FAIL_CS_VOICE_AC,
        servlev.RAB_STP_FAIL_CS_VOICE_BTS,
        servlev.RAB_STP_FAIL_CS_VOICE_TRANS,
        servlev.RAB_STP_FAIL_CS_VOICE_RNC,
        servlev.RAB_STP_FAIL_CS_VOICE_FROZBS,
        servlev.RAB_ACC_FAIL_CS_VOICE_MS,
        servlev.RAB_ACC_FAIL_CS_VOICE_RNC
            
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(servlev.period_start_time,'YYYY-MM-DD') rpdate,
            ROUND(Decode(Sum(servlev.RAB_STP_ATT_CS_VOICE), 0, 0, Sum(servlev.RAB_ACC_COMP_CS_VOICE) /
            Sum(servlev.RAB_STP_ATT_CS_VOICE))*100,2) As 语音业务RAB建立成功率,
            
            Sum(servlev.RAB_ACC_COMP_CS_VOICE) As X_语音业务RAB建立SucRat,
            Sum(servlev.RAB_STP_ATT_CS_VOICE) As Y_语音业务RAB建立SucRat,
            Sum(servlev.RAB_STP_FAIL_CS_VOICE_AC) As RAB_STP_FAIL_CS_VOICE_AC,
            Sum(servlev.RAB_STP_FAIL_CS_VOICE_BTS) As RAB_STP_FAIL_CS_VOICE_BTS,
            Sum(servlev.RAB_STP_FAIL_CS_VOICE_TRANS) As RAB_STP_FAIL_CS_VOICE_TRANS,
            Sum(servlev.RAB_STP_FAIL_CS_VOICE_RNC) As RAB_STP_FAIL_CS_VOICE_RNC,
            Sum(servlev.RAB_STP_FAIL_CS_VOICE_FROZBS) As RAB_STP_FAIL_CS_VOICE_FROZBS,
            Sum(servlev.RAB_ACC_FAIL_CS_VOICE_MS) As RAB_ACC_FAIL_CS_VOICE_MS,
            Sum(servlev.RAB_ACC_FAIL_CS_VOICE_RNC) As RAB_ACC_FAIL_CS_VOICE_RNC
            
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
        (servlev.语音业务RAB建立成功率 < 90 AND servlev.Y_语音业务RAB建立SucRat<> 0 )

    ORDER BY
        servlev.city,
        servlev.语音业务RAB建立成功率  


