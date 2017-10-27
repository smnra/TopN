    SELECT
        INTSYSHO.city,
        INTSYSHO.wcel_rnc_id,
        INTSYSHO.ci,
        INTSYSHO.wbts_name,
        INTSYSHO.rpdate,
        INTSYSHO.小区异频切换成功率,
        INTSYSHO.X_小区异频切换成功率,
        INTSYSHO.Y_小区异频切换成功率
    
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(INTSYSHO.period_start_time,'YYYY-MM-DD') rpdate,

            ROUND(decode(Sum(IF_HHO_ATT_UL_DCH_Q_RT + IF_HHO_ATT_UE_TRX_PWR_RT +
            IF_HHO_ATT_DL_DPCH_PWR_RT + IF_HHO_ATT_CPICH_RSCP_RT + IF_HHO_ATT_CPICH_ECNO_RT
            + IF_HHO_ATT_IM_IMS_RT + IF_HHO_ATT_LB_RES_LIM_RT + IF_HHO_ATT_LB_PRX_TOT_RT +
            IF_HHO_ATT_LB_PTX_TOT_RT + IF_HHO_ATT_SB_RT + IF_HHO_ATT_LB_RSVR_SC_RT +
            IF_HHO_ATT_LB_CAPA_UL_RT + IF_HHO_ATT_LB_CAPA_DL_RT + IF_HHO_ATT_UL_DCH_Q_NRT +
            IF_HHO_ATT_UE_TRX_PWR_NRT + IF_HHO_ATT_DL_DPCH_PWR_NRT +
            IF_HHO_ATT_CPICH_RSCP_NRT + IF_HHO_ATT_CPICH_ECNO_NRT + IF_HHO_ATT_IM_IMS_NRT +
            IF_HHO_ATT_LB_RES_LIM_NRT + IF_HHO_ATT_LB_PRX_TOT_NRT +
            IF_HHO_ATT_LB_PTX_TOT_NRT + IF_HHO_ATT_SB_NRT + IF_HHO_ATT_LB_RSVR_SC_NRT +
            IF_HHO_ATT_LB_CAPA_UL_NRT + IF_HHO_ATT_LB_CAPA_DL_NRT),0,0,
            Sum(SUCC_IF_HHO_UL_DCH_Q_RT + SUCC_IF_HHO_UE_TRX_PWR_RT +
            SUCC_IF_HHO_DL_DPCH_PWR_RT + SUCC_IF_HHO_CPICH_RSCP_RT +
            SUCC_IF_HHO_CPICH_ECNO_RT + SUCC_IF_HHO_IM_IMS_RT + SUCC_IF_HHO_LB_RES_LIM_RT +
            SUCC_IF_HHO_LB_PRX_TOT_RT + SUCC_IF_HHO_LB_PTX_TOT_RT + SUCC_IF_HHO_SB_RT +
            SUCC_IF_HHO_LB_RSVR_SC_RT + SUCC_IF_HHO_LB_CAPA_UL_RT +
            SUCC_IF_HHO_LB_CAPA_DL_RT + SUCC_IF_HHO_UL_DCH_Q_NRT +
            SUCC_IF_HHO_UE_TRX_PWR_NRT + SUCC_IF_HHO_DL_DPCH_PWR_NRT +
            SUCC_IF_HHO_CPICH_RSCP_NRT + SUCC_IF_HHO_CPICH_ECNO_NRT + SUCC_IF_HHO_IM_IMS_NRT
            + SUCC_IF_HHO_LB_RES_LIM_NRT + SUCC_IF_HHO_LB_PRX_TOT_NRT +
            SUCC_IF_HHO_LB_PTX_TOT_NRT + SUCC_IF_HHO_SB_NRT + SUCC_IF_HHO_LB_RSVR_SC_NRT +
            SUCC_IF_HHO_LB_CAPA_UL_NRT + SUCC_IF_HHO_LB_CAPA_DL_NRT) /
            Sum(IF_HHO_ATT_UL_DCH_Q_RT + IF_HHO_ATT_UE_TRX_PWR_RT +
            IF_HHO_ATT_DL_DPCH_PWR_RT + IF_HHO_ATT_CPICH_RSCP_RT + IF_HHO_ATT_CPICH_ECNO_RT
            + IF_HHO_ATT_IM_IMS_RT + IF_HHO_ATT_LB_RES_LIM_RT + IF_HHO_ATT_LB_PRX_TOT_RT +
            IF_HHO_ATT_LB_PTX_TOT_RT + IF_HHO_ATT_SB_RT + IF_HHO_ATT_LB_RSVR_SC_RT +
            IF_HHO_ATT_LB_CAPA_UL_RT + IF_HHO_ATT_LB_CAPA_DL_RT + IF_HHO_ATT_UL_DCH_Q_NRT +
            IF_HHO_ATT_UE_TRX_PWR_NRT + IF_HHO_ATT_DL_DPCH_PWR_NRT +
            IF_HHO_ATT_CPICH_RSCP_NRT + IF_HHO_ATT_CPICH_ECNO_NRT + IF_HHO_ATT_IM_IMS_NRT +
            IF_HHO_ATT_LB_RES_LIM_NRT + IF_HHO_ATT_LB_PRX_TOT_NRT +
            IF_HHO_ATT_LB_PTX_TOT_NRT + IF_HHO_ATT_SB_NRT + IF_HHO_ATT_LB_RSVR_SC_NRT +
            IF_HHO_ATT_LB_CAPA_UL_NRT + IF_HHO_ATT_LB_CAPA_DL_NRT))*100,2) As 小区异频切换成功率,
            
            
            Sum(SUCC_IF_HHO_UL_DCH_Q_RT + SUCC_IF_HHO_UE_TRX_PWR_RT +
            SUCC_IF_HHO_DL_DPCH_PWR_RT + SUCC_IF_HHO_CPICH_RSCP_RT +
            SUCC_IF_HHO_CPICH_ECNO_RT + SUCC_IF_HHO_IM_IMS_RT + SUCC_IF_HHO_LB_RES_LIM_RT +
            SUCC_IF_HHO_LB_PRX_TOT_RT + SUCC_IF_HHO_LB_PTX_TOT_RT + SUCC_IF_HHO_SB_RT +
            SUCC_IF_HHO_LB_RSVR_SC_RT + SUCC_IF_HHO_LB_CAPA_UL_RT +
            SUCC_IF_HHO_LB_CAPA_DL_RT + SUCC_IF_HHO_UL_DCH_Q_NRT +
            SUCC_IF_HHO_UE_TRX_PWR_NRT + SUCC_IF_HHO_DL_DPCH_PWR_NRT +
            SUCC_IF_HHO_CPICH_RSCP_NRT + SUCC_IF_HHO_CPICH_ECNO_NRT + SUCC_IF_HHO_IM_IMS_NRT
            + SUCC_IF_HHO_LB_RES_LIM_NRT + SUCC_IF_HHO_LB_PRX_TOT_NRT +
            SUCC_IF_HHO_LB_PTX_TOT_NRT + SUCC_IF_HHO_SB_NRT + SUCC_IF_HHO_LB_RSVR_SC_NRT +
            SUCC_IF_HHO_LB_CAPA_UL_NRT + SUCC_IF_HHO_LB_CAPA_DL_NRT) AS X_小区异频切换成功率,
            
            Sum(IF_HHO_ATT_UL_DCH_Q_RT + IF_HHO_ATT_UE_TRX_PWR_RT +
            IF_HHO_ATT_DL_DPCH_PWR_RT + IF_HHO_ATT_CPICH_RSCP_RT + IF_HHO_ATT_CPICH_ECNO_RT
            + IF_HHO_ATT_IM_IMS_RT + IF_HHO_ATT_LB_RES_LIM_RT + IF_HHO_ATT_LB_PRX_TOT_RT +
            IF_HHO_ATT_LB_PTX_TOT_RT + IF_HHO_ATT_SB_RT + IF_HHO_ATT_LB_RSVR_SC_RT +
            IF_HHO_ATT_LB_CAPA_UL_RT + IF_HHO_ATT_LB_CAPA_DL_RT + IF_HHO_ATT_UL_DCH_Q_NRT +
            IF_HHO_ATT_UE_TRX_PWR_NRT + IF_HHO_ATT_DL_DPCH_PWR_NRT +
            IF_HHO_ATT_CPICH_RSCP_NRT + IF_HHO_ATT_CPICH_ECNO_NRT + IF_HHO_ATT_IM_IMS_NRT +
            IF_HHO_ATT_LB_RES_LIM_NRT + IF_HHO_ATT_LB_PRX_TOT_NRT +
            IF_HHO_ATT_LB_PTX_TOT_NRT + IF_HHO_ATT_SB_NRT + IF_HHO_ATT_LB_RSVR_SC_NRT +
            IF_HHO_ATT_LB_CAPA_UL_NRT + IF_HHO_ATT_LB_CAPA_DL_NRT) AS Y_小区异频切换成功率
            
        From
            NOKRWW_PS_INTSYSHO_MNC1_RAW INTSYSHO
            Inner Join c_w_custom c on c.wcel_objid = INTSYSHO.WCEL_ID    
            
        Where
            INTSYSHO.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            INTSYSHO.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(INTSYSHO.period_start_time,'YYYY-MM-DD')
        )  INTSYSHO
        
    WHERE
        (INTSYSHO.小区异频切换成功率 < 90 AND INTSYSHO.Y_小区异频切换成功率 <> 0)

    ORDER BY
        INTSYSHO.city,
        INTSYSHO.小区异频切换成功率  

 
 
 