    SELECT
        PKTCALL.city,
        PKTCALL.wcel_rnc_id,
        PKTCALL.ci,
        PKTCALL.wbts_name,
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
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(PKTCALL.period_start_time,'YYYY-MM-DD') rpdate,
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
            Inner Join c_w_custom c on c.wcel_objid = TRAFFIC.WCEL_ID     
            
        Where
            PKTCALL.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            PKTCALL.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(PKTCALL.period_start_time,'YYYY-MM-DD')
        )  PKTCALL 
        
    WHERE
        (PKTCALL.HSUPA分组域业务掉线率 > 20 and PKTCALL.Y_HSUPA分组域Serv掉线率 >50)

    ORDER BY
        PKTCALL.city,
        PKTCALL.HSUPA分组域业务掉线率  desc
      
      

    
 
