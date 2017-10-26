    SELECT
        PKTCALL.WCEL_ID,
        PKTCALL.rpdate,
        PKTCALL.HSUPA分组域业务掉线率,
        PKTCALL.X_HSUPA分组域Serv掉线率,
        PKTCALL.Y_HSUPA分组域Serv掉线率,
        PKTCALL.REL_EDCH_RL_FAIL_INT,
        PKTCALL.REL_EDCH_RL_FAIL_BGR,
        PKTCALL.REL_EDCH_OTHER_FAIL_INT,
        PKTCALL.REL_EDCH_OTHER_FAIL_BGR
            
    FROM
        (Select
            PKTCALL.WCEL_ID,
            to_char(PKTCALL.period_start_time,'YYYY-MM-DD-HH24') rpdate,

            ROUND(Decode(Sum(PKTCALL.PS_REL_RL_FAIL_HS_E_INT + PKTCALL.PS_REL_RL_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_E_INT + PKTCALL.PS_REL_OTH_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_NORM_HS_E_INT + PKTCALL.PS_REL_NORM_HS_E_BGR +
            PKTCALL.PS_SWI_HS_E_TO_D_D_INT + PKTCALL.PS_SWI_HS_E_TO_D_D_BGR), 0, 0,
            Sum(PKTCALL.PS_REL_RL_FAIL_HS_E_INT + PKTCALL.PS_REL_RL_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_E_INT + PKTCALL.PS_REL_OTH_FAIL_HS_E_BGR) /
            Sum(PKTCALL.PS_REL_RL_FAIL_HS_E_INT + PKTCALL.PS_REL_RL_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_E_INT + PKTCALL.PS_REL_OTH_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_NORM_HS_E_INT + PKTCALL.PS_REL_NORM_HS_E_BGR +
            PKTCALL.PS_SWI_HS_E_TO_D_D_INT + PKTCALL.PS_SWI_HS_E_TO_D_D_BGR))*100,2) As HSUPA分组域业务掉线率,
            
            Sum(PKTCALL.PS_REL_RL_FAIL_HS_E_INT + PKTCALL.PS_REL_RL_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_E_INT + PKTCALL.PS_REL_OTH_FAIL_HS_E_BGR) As X_HSUPA分组域Serv掉线率,
            
            Sum(PKTCALL.PS_REL_RL_FAIL_HS_E_INT + PKTCALL.PS_REL_RL_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_E_INT + PKTCALL.PS_REL_OTH_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_NORM_HS_E_INT + PKTCALL.PS_REL_NORM_HS_E_BGR +
            PKTCALL.PS_SWI_HS_E_TO_D_D_INT + PKTCALL.PS_SWI_HS_E_TO_D_D_BGR) As Y_HSUPA分组域Serv掉线率,
            
            Sum(TRAFFIC.REL_EDCH_RL_FAIL_INT) As REL_EDCH_RL_FAIL_INT,
            Sum(TRAFFIC.REL_EDCH_RL_FAIL_BGR) As REL_EDCH_RL_FAIL_BGR,
            Sum(TRAFFIC.REL_EDCH_OTHER_FAIL_INT) As REL_EDCH_OTHER_FAIL_INT,
            Sum(TRAFFIC.REL_EDCH_OTHER_FAIL_BGR) As REL_EDCH_OTHER_FAIL_BGR
            
        From
                       NOKRWW_PS_TRAFFIC_MNC1_RAW TRAFFIC
            Inner Join NOKRWW_PS_PKTCALL_MNC1_RAW PKTCALL On TRAFFIC.WCEL_ID = PKTCALL.WCEL_ID And
                                               TRAFFIC.PERIOD_START_TIME = PKTCALL.PERIOD_START_TIME
            
        Where
            PKTCALL.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            PKTCALL.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            PKTCALL.WCEL_ID,
            to_char(PKTCALL.period_start_time,'YYYY-MM-DD-HH24')
        )  PKTCALL 
        
    WHERE
        (HSUPA分组域业务掉线率 > 20)

    ORDER BY
        HSUPA分组域业务掉线率  
      

    
 
