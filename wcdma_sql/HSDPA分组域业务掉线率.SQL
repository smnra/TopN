    SELECT
        PKTCALL.city,
        PKTCALL.wcel_rnc_id,
        PKTCALL.ci,
        PKTCALL.wbts_name,
        PKTCALL.rpdate,
        PKTCALL.HSDPA分组域业务掉线率,
        PKTCALL.X_HSDPA分组域Serv掉线率,
        PKTCALL.Y_HSDPA分组域Serv掉线率,
        PKTCALL.REL_ALLO_OTH_FAIL_HSDSCH_INT,
        PKTCALL.REL_ALLO_OTH_FAIL_HSDSCH_BGR,
        PKTCALL.REL_ALLO_RL_FAIL_HS_DSCH_INT,
        PKTCALL.REL_ALLO_RL_FAIL_HS_DSCH_BGR
            
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(PKTCALL.period_start_time,'YYYY-MM-DD') rpdate,

            Decode(Sum(PKTCALL.PS_REL_RL_FAIL_HS_E_INT + PKTCALL.PS_REL_RL_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_RL_FAIL_HS_D_INT + PKTCALL.PS_REL_RL_FAIL_HS_D_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_E_INT + PKTCALL.PS_REL_OTH_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_D_INT + PKTCALL.PS_REL_OTH_FAIL_HS_D_BGR +
            PKTCALL.PS_REL_NORM_HS_E_INT + PKTCALL.PS_REL_NORM_HS_E_BGR +
            PKTCALL.PS_REL_NORM_HS_D_INT + PKTCALL.PS_REL_NORM_HS_D_BGR +
            PKTCALL.PS_SWI_HS_E_TO_D_D_INT + PKTCALL.PS_SWI_HS_E_TO_D_D_BGR +
            PKTCALL.PS_SWI_HS_D_TO_D_D_INT + PKTCALL.PS_SWI_HS_D_TO_D_D_BGR), 0, 0,
            Sum(PKTCALL.PS_REL_RL_FAIL_HS_E_INT + PKTCALL.PS_REL_RL_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_RL_FAIL_HS_D_INT + PKTCALL.PS_REL_RL_FAIL_HS_D_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_E_INT + PKTCALL.PS_REL_OTH_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_D_INT + PKTCALL.PS_REL_OTH_FAIL_HS_D_BGR) /
            Sum(PKTCALL.PS_REL_RL_FAIL_HS_E_INT + PKTCALL.PS_REL_RL_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_RL_FAIL_HS_D_INT + PKTCALL.PS_REL_RL_FAIL_HS_D_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_E_INT + PKTCALL.PS_REL_OTH_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_D_INT + PKTCALL.PS_REL_OTH_FAIL_HS_D_BGR +
            PKTCALL.PS_REL_NORM_HS_E_INT + PKTCALL.PS_REL_NORM_HS_E_BGR +
            PKTCALL.PS_REL_NORM_HS_D_INT + PKTCALL.PS_REL_NORM_HS_D_BGR +
            PKTCALL.PS_SWI_HS_E_TO_D_D_INT + PKTCALL.PS_SWI_HS_E_TO_D_D_BGR +
            PKTCALL.PS_SWI_HS_D_TO_D_D_INT + PKTCALL.PS_SWI_HS_D_TO_D_D_BGR)) As HSDPA分组域业务掉线率,
            
            Sum(PKTCALL.PS_REL_RL_FAIL_HS_E_INT + PKTCALL.PS_REL_RL_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_RL_FAIL_HS_D_INT + PKTCALL.PS_REL_RL_FAIL_HS_D_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_E_INT + PKTCALL.PS_REL_OTH_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_D_INT + PKTCALL.PS_REL_OTH_FAIL_HS_D_BGR) As X_HSDPA分组域Serv掉线率,
            
            Sum(PKTCALL.PS_REL_RL_FAIL_HS_E_INT + PKTCALL.PS_REL_RL_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_RL_FAIL_HS_D_INT + PKTCALL.PS_REL_RL_FAIL_HS_D_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_E_INT + PKTCALL.PS_REL_OTH_FAIL_HS_E_BGR +
            PKTCALL.PS_REL_OTH_FAIL_HS_D_INT + PKTCALL.PS_REL_OTH_FAIL_HS_D_BGR +
            PKTCALL.PS_REL_NORM_HS_E_INT + PKTCALL.PS_REL_NORM_HS_E_BGR +
            PKTCALL.PS_REL_NORM_HS_D_INT + PKTCALL.PS_REL_NORM_HS_D_BGR +
            PKTCALL.PS_SWI_HS_E_TO_D_D_INT + PKTCALL.PS_SWI_HS_E_TO_D_D_BGR +
            PKTCALL.PS_SWI_HS_D_TO_D_D_INT + PKTCALL.PS_SWI_HS_D_TO_D_D_BGR) As Y_HSDPA分组域Serv掉线率,
            
            Sum(TRAFFIC.REL_ALLO_OTH_FAIL_HSDSCH_INT) As REL_ALLO_OTH_FAIL_HSDSCH_INT,
            Sum(TRAFFIC.REL_ALLO_OTH_FAIL_HSDSCH_BGR) As REL_ALLO_OTH_FAIL_HSDSCH_BGR,
            Sum(TRAFFIC.REL_ALLO_RL_FAIL_HS_DSCH_INT) As REL_ALLO_RL_FAIL_HS_DSCH_INT,
            Sum(TRAFFIC.REL_ALLO_RL_FAIL_HS_DSCH_BGR) As REL_ALLO_RL_FAIL_HS_DSCH_BGR
            
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
        (PKTCALL.HSDPA分组域业务掉线率 > 20 and PKTCALL.Y_HSDPA分组域Serv掉线率 >50)

    ORDER BY
        PKTCALL.city,
        PKTCALL.HSDPA分组域业务掉线率 desc
      
 
    
 