    SELECT
        servlev.WCEL_ID,
        servlev.rpdate,
        servlev.R99分组域RAB建立成功率,
        servlev.X_R99分组域RAB建立SucRat,
        servlev.Y_R99分组域RAB建立SucRat,
        servlev.RAB_STP_FAIL_PS_INTER_AC,
        servlev.RAB_STP_FAIL_PS_INTER_RNC,
        servlev.RAB_STP_FAIL_PS_INTER_ANCH,
        servlev.RAB_STP_FAIL_PS_INTER_FROZBS,
        servlev.RAB_STP_FAIL_PS_BACKG_AC,
        servlev.RAB_STP_FAIL_PS_BACKG_RNC,
        servlev.RAB_STP_FAIL_PS_BACKG_ANCH,
        servlev.RAB_STP_FAIL_PS_BACKG_FROZBS,
        servlev.RAB_ACC_FAIL_PS_INTER_MS,
        servlev.RAB_ACC_FAIL_PS_INTER_RNC,
        servlev.RAB_ACC_FAIL_PS_BACKG_MS,
        servlev.RAB_ACC_FAIL_PS_BACKG_RNC,
        servlev.RAB_STP_FAIL_PS_NOT_SUPP_PAR,
        servlev.RAB_STP_FAIL_PS_UE_CAPA
            
    FROM
        (Select
            servlev.WCEL_ID,
            to_char(servlev.period_start_time,'YYYY-MM-DD-HH24') rpdate,
            
            ROUND(Decode(Sum(servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA +
            servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG), 0, 0,
            Sum(servlev.RAB_ACC_COMP_PS_CONV + servlev.RAB_ACC_COMP_PS_STREA +
            servlev.RAB_ACC_COMP_PS_INTER + servlev.RAB_ACC_COMP_PS_BACKG) /
            Sum(servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA +
            servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG))*100,2) As R99分组域RAB建立成功率,
            
            Sum(servlev.RAB_ACC_COMP_PS_CONV + servlev.RAB_ACC_COMP_PS_STREA +
            servlev.RAB_ACC_COMP_PS_INTER + servlev.RAB_ACC_COMP_PS_BACKG) As X_R99分组域RAB建立SucRat,
            
            Sum(servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA +
            servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG) As Y_R99分组域RAB建立SucRat,
            
            Sum(servlev.RAB_STP_FAIL_PS_INTER_AC) As RAB_STP_FAIL_PS_INTER_AC,
            Sum(servlev.RAB_STP_FAIL_PS_INTER_RNC) As RAB_STP_FAIL_PS_INTER_RNC,
            Sum(servlev.RAB_STP_FAIL_PS_INTER_ANCH) As RAB_STP_FAIL_PS_INTER_ANCH,
            Sum(servlev.RAB_STP_FAIL_PS_INTER_FROZBS) As RAB_STP_FAIL_PS_INTER_FROZBS,
            Sum(servlev.RAB_STP_FAIL_PS_BACKG_AC) As RAB_STP_FAIL_PS_BACKG_AC,
            Sum(servlev.RAB_STP_FAIL_PS_BACKG_RNC) As RAB_STP_FAIL_PS_BACKG_RNC,
            Sum(servlev.RAB_STP_FAIL_PS_BACKG_ANCH) As RAB_STP_FAIL_PS_BACKG_ANCH,
            Sum(servlev.RAB_STP_FAIL_PS_BACKG_FROZBS) As RAB_STP_FAIL_PS_BACKG_FROZBS,
            Sum(servlev.RAB_ACC_FAIL_PS_INTER_MS) As RAB_ACC_FAIL_PS_INTER_MS,
            Sum(servlev.RAB_ACC_FAIL_PS_INTER_RNC) As RAB_ACC_FAIL_PS_INTER_RNC,
            Sum(servlev.RAB_ACC_FAIL_PS_BACKG_MS) As RAB_ACC_FAIL_PS_BACKG_MS,
            Sum(servlev.RAB_ACC_FAIL_PS_BACKG_RNC) As RAB_ACC_FAIL_PS_BACKG_RNC,
            Sum(servlev.RAB_STP_FAIL_PS_NOT_SUPP_PAR) As RAB_STP_FAIL_PS_NOT_SUPP_PAR,
            Sum(servlev.RAB_STP_FAIL_PS_UE_CAPA) As RAB_STP_FAIL_PS_UE_CAPA
            
        From
            NOKRWW_PS_SERVLEV_MNC1_RAW servlev
            
        Where
            servlev.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            servlev.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            servlev.WCEL_ID,
            to_char(servlev.period_start_time,'YYYY-MM-DD-HH24')
        )  servlev 
        
    WHERE
        (R99分组域RAB建立成功率 < 90 AND Y_R99分组域RAB建立SucRat <> 0)

    ORDER BY
        R99分组域RAB建立成功率  

    
    
 