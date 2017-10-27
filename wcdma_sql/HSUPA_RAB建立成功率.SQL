    SELECT
        TRAFFIC.city,
        TRAFFIC.wcel_rnc_id,
        TRAFFIC.ci,
        TRAFFIC.wbts_name,
        TRAFFIC.rpdate,
        TRAFFIC.HSUPA_RAB建立成功率,
        TRAFFIC.X_HSUPA_RAB建立成功率,
        TRAFFIC.Y_HSUPA_RAB建立成功率,
        TRAFFIC.UL_DCH_SEL_MAX_HSUPA_USR_INT,
        TRAFFIC.UL_DCH_SEL_MAX_HSUPA_USR_BGR,
        TRAFFIC.UL_DCH_SEL_BTS_HW_INT,
        TRAFFIC.UL_DCH_SEL_BTS_HW_BGR,
        TRAFFIC.EDCH_ALLO_CANC_NA_AS_INT,
        TRAFFIC.EDCH_ALLO_CANC_NA_AS_BGR,
        TRAFFIC.SETUP_FAIL_EDCH_UE_INT,
        TRAFFIC.SETUP_FAIL_EDCH_UE_BGR,
        TRAFFIC.SETUP_FAIL_EDCH_BTS_INT,
        TRAFFIC.SETUP_FAIL_EDCH_BTS_BGR,
        TRAFFIC.SETUP_FAIL_EDCH_TRANS_INT,
        TRAFFIC.SETUP_FAIL_EDCH_TRANS_BGR,
        TRAFFIC.SETUP_FAIL_EDCH_OTHER_INT,
        TRAFFIC.SETUP_FAIL_EDCH_OTHER_BGR
            
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(TRAFFIC.period_start_time,'YYYY-MM-DD') rpdate,

            ROUND(Decode(Sum(TRAFFIC.ALLO_SUCCESS_EDCH_INT + TRAFFIC.ALLO_SUCCESS_EDCH_BGR +
            TRAFFIC.SETUP_FAIL_EDCH_UE_INT + TRAFFIC.SETUP_FAIL_EDCH_UE_BGR), 0, 0,
            Sum(TRAFFIC.ALLO_SUCCESS_EDCH_INT + TRAFFIC.ALLO_SUCCESS_EDCH_BGR) /
            Sum(TRAFFIC.ALLO_SUCCESS_EDCH_INT + TRAFFIC.ALLO_SUCCESS_EDCH_BGR +
            TRAFFIC.SETUP_FAIL_EDCH_UE_INT + TRAFFIC.SETUP_FAIL_EDCH_UE_BGR))*100,2) As HSUPA_RAB建立成功率,
            
            Sum(TRAFFIC.ALLO_SUCCESS_EDCH_INT + TRAFFIC.ALLO_SUCCESS_EDCH_BGR) As X_HSUPA_RAB建立成功率,
            
            Sum(TRAFFIC.ALLO_SUCCESS_EDCH_INT + TRAFFIC.ALLO_SUCCESS_EDCH_BGR +
            TRAFFIC.SETUP_FAIL_EDCH_UE_INT + TRAFFIC.SETUP_FAIL_EDCH_UE_BGR) As Y_HSUPA_RAB建立成功率,
            
            Sum(TRAFFIC.UL_DCH_SEL_MAX_HSUPA_USR_INT) As UL_DCH_SEL_MAX_HSUPA_USR_INT,
            Sum(TRAFFIC.UL_DCH_SEL_MAX_HSUPA_USR_BGR) As UL_DCH_SEL_MAX_HSUPA_USR_BGR,
            Sum(TRAFFIC.UL_DCH_SEL_BTS_HW_INT) As UL_DCH_SEL_BTS_HW_INT,
            Sum(TRAFFIC.UL_DCH_SEL_BTS_HW_BGR) As UL_DCH_SEL_BTS_HW_BGR,
            Sum(TRAFFIC.EDCH_ALLO_CANC_NA_AS_INT) As EDCH_ALLO_CANC_NA_AS_INT,
            Sum(TRAFFIC.EDCH_ALLO_CANC_NA_AS_BGR) As EDCH_ALLO_CANC_NA_AS_BGR,
            Sum(TRAFFIC.SETUP_FAIL_EDCH_UE_INT) As SETUP_FAIL_EDCH_UE_INT,
            Sum(TRAFFIC.SETUP_FAIL_EDCH_UE_BGR) As SETUP_FAIL_EDCH_UE_BGR,
            Sum(TRAFFIC.SETUP_FAIL_EDCH_BTS_INT) As SETUP_FAIL_EDCH_BTS_INT,
            Sum(TRAFFIC.SETUP_FAIL_EDCH_BTS_BGR) As SETUP_FAIL_EDCH_BTS_BGR,
            Sum(TRAFFIC.SETUP_FAIL_EDCH_TRANS_INT) As SETUP_FAIL_EDCH_TRANS_INT,
            Sum(TRAFFIC.SETUP_FAIL_EDCH_TRANS_BGR) As SETUP_FAIL_EDCH_TRANS_BGR,
            Sum(TRAFFIC.SETUP_FAIL_EDCH_OTHER_INT) As SETUP_FAIL_EDCH_OTHER_INT,
            Sum(TRAFFIC.SETUP_FAIL_EDCH_OTHER_BGR) As SETUP_FAIL_EDCH_OTHER_BGR
            
        From
            NOKRWW_PS_TRAFFIC_MNC1_RAW TRAFFIC
            Inner Join c_w_custom c on c.wcel_objid = TRAFFIC.WCEL_ID     
       
        Where
            TRAFFIC.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            TRAFFIC.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(TRAFFIC.period_start_time,'YYYY-MM-DD')
        )  TRAFFIC 
        
    WHERE
        (TRAFFIC.HSUPA_RAB建立成功率 < 90 AND TRAFFIC.Y_HSUPA_RAB建立成功率 <> 0)

    ORDER BY
        TRAFFIC.city,
        TRAFFIC.HSUPA_RAB建立成功率  
  
    
   