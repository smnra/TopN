    SELECT
        servlev.city,
        servlev.wcel_rnc_id,
        servlev.ci,
        servlev.wbts_name,
        servlev.rpdate,
        servlev.R99分组域业务掉线率,
        servlev.X_R99分组域业务掉线率,
        servlev.Y_R99分组域业务掉线率,
        servlev.RAB_ACT_FAIL_PS_CONV_IU,
        servlev.RAB_ACT_FAIL_PS_STREA_IU,
        servlev.RAB_ACT_FAIL_PS_INTER_IU,
        servlev.RAB_ACT_FAIL_PS_BACKG_IU,
        servlev.RAB_ACT_FAIL_PS_CONV_RADIO,
        servlev.RAB_ACT_FAIL_PS_STREA_RADIO,
        servlev.RAB_ACT_FAIL_PS_INTER_RADIO,
        servlev.RAB_ACT_FAIL_PS_BACKG_RADIO,
        servlev.RAB_ACT_FAIL_PS_CONV_BTS,
        servlev.RAB_ACT_FAIL_PS_STREA_BTS,
        servlev.RAB_ACT_FAIL_PS_INTER_BTS,
        servlev.RAB_ACT_FAIL_PS_BACKG_BTS,
        servlev.RAB_ACT_FAIL_PS_CONV_IUR,
        servlev.RAB_ACT_FAIL_PS_STREA_IUR,
        servlev.RAB_ACT_FAIL_PS_INTER_IUR,
        servlev.RAB_ACT_FAIL_PS_BACKG_IUR,
        servlev.RAB_ACT_FAIL_PS_CONV_RNC,
        servlev.RAB_ACT_FAIL_PS_STREA_RNC,
        servlev.RAB_ACT_FAIL_PS_INTER_RNC,
        servlev.RAB_ACT_FAIL_PS_BACKG_RNC,
        servlev.RAB_ACT_FAIL_PS_CONV_UE,
        servlev.RAB_ACT_FAIL_PS_STREA_UE,
        servlev.RAB_ACT_FAIL_PS_INTER_UE,
        servlev.RAB_ACT_FAIL_PS_BACKG_UE,
        servlev.RAB_ACT_FAIL_PS_INT_PCH,
        servlev.RAB_ACT_FAIL_PS_BACKG_PCH
            
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(servlev.period_start_time,'YYYY-MM-DD') rpdate,
            ROUND(Decode(Sum(servlev.RAB_ACT_COMP_PS_CONV + servlev.RAB_ACT_COMP_PS_STREA +
            servlev.RAB_ACT_COMP_PS_INTER + servlev.RAB_ACT_COMP_PS_BACKG +
            servlev.RAB_ACT_REL_PS_CONV_SRNC + servlev.RAB_ACT_REL_PS_CONV_P_EMP +
            servlev.RAB_ACT_REL_PS_STREA_SRNC + servlev.RAB_ACT_REL_PS_STREA_P_EMP +
            servlev.RAB_ACT_REL_PS_INTER_SRNC + servlev.RAB_ACT_REL_PS_BACKG_SRNC +
            servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
            servlev.RAB_ACT_FAIL_PS_CONV_BTS + servlev.RAB_ACT_FAIL_PS_CONV_IUR +
            servlev.RAB_ACT_FAIL_PS_CONV_RNC + servlev.RAB_ACT_FAIL_PS_CONV_UE +
            servlev.RAB_ACT_FAIL_PS_STREA_IU + servlev.RAB_ACT_FAIL_PS_STREA_RADIO +
            servlev.RAB_ACT_FAIL_PS_STREA_BTS + servlev.RAB_ACT_FAIL_PS_STREA_IUR +
            servlev.RAB_ACT_FAIL_PS_STREA_RNC + servlev.RAB_ACT_FAIL_PS_STREA_UE +
            servlev.RAB_ACT_FAIL_PS_INTER_IU + servlev.RAB_ACT_FAIL_PS_INTER_RADIO +
            servlev.RAB_ACT_FAIL_PS_INTER_BTS + servlev.RAB_ACT_FAIL_PS_INTER_IUR +
            servlev.RAB_ACT_FAIL_PS_INTER_RNC + servlev.RAB_ACT_FAIL_PS_INTER_UE +
            servlev.RAB_ACT_FAIL_PS_BACKG_IU + servlev.RAB_ACT_FAIL_PS_BACKG_RADIO +
            servlev.RAB_ACT_FAIL_PS_BACKG_BTS + servlev.RAB_ACT_FAIL_PS_BACKG_IUR +
            servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE), 0, 0,
            Sum(servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
            servlev.RAB_ACT_FAIL_PS_CONV_BTS + servlev.RAB_ACT_FAIL_PS_CONV_IUR +
            servlev.RAB_ACT_FAIL_PS_CONV_RNC + servlev.RAB_ACT_FAIL_PS_CONV_UE +
            servlev.RAB_ACT_FAIL_PS_STREA_IU + servlev.RAB_ACT_FAIL_PS_STREA_RADIO +
            servlev.RAB_ACT_FAIL_PS_STREA_BTS + servlev.RAB_ACT_FAIL_PS_STREA_IUR +
            servlev.RAB_ACT_FAIL_PS_STREA_RNC + servlev.RAB_ACT_FAIL_PS_STREA_UE +
            servlev.RAB_ACT_FAIL_PS_INTER_IU + servlev.RAB_ACT_FAIL_PS_INTER_RADIO +
            servlev.RAB_ACT_FAIL_PS_INTER_BTS + servlev.RAB_ACT_FAIL_PS_INTER_IUR +
            servlev.RAB_ACT_FAIL_PS_INTER_RNC + servlev.RAB_ACT_FAIL_PS_INTER_UE +
            servlev.RAB_ACT_FAIL_PS_BACKG_IU + servlev.RAB_ACT_FAIL_PS_BACKG_RADIO +
            servlev.RAB_ACT_FAIL_PS_BACKG_BTS + servlev.RAB_ACT_FAIL_PS_BACKG_IUR +
            servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE -
            servlev.RAB_ACT_FAIL_PS_INT_PCH - servlev.RAB_ACT_FAIL_PS_BACKG_PCH) /
            Sum(servlev.RAB_ACT_COMP_PS_CONV + servlev.RAB_ACT_COMP_PS_STREA +
            servlev.RAB_ACT_COMP_PS_INTER + servlev.RAB_ACT_COMP_PS_BACKG +
            servlev.RAB_ACT_REL_PS_CONV_SRNC + servlev.RAB_ACT_REL_PS_CONV_P_EMP +
            servlev.RAB_ACT_REL_PS_STREA_SRNC + servlev.RAB_ACT_REL_PS_STREA_P_EMP +
            servlev.RAB_ACT_REL_PS_INTER_SRNC + servlev.RAB_ACT_REL_PS_BACKG_SRNC +
            servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
            servlev.RAB_ACT_FAIL_PS_CONV_BTS + servlev.RAB_ACT_FAIL_PS_CONV_IUR +
            servlev.RAB_ACT_FAIL_PS_CONV_RNC + servlev.RAB_ACT_FAIL_PS_CONV_UE +
            servlev.RAB_ACT_FAIL_PS_STREA_IU + servlev.RAB_ACT_FAIL_PS_STREA_RADIO +
            servlev.RAB_ACT_FAIL_PS_STREA_BTS + servlev.RAB_ACT_FAIL_PS_STREA_IUR +
            servlev.RAB_ACT_FAIL_PS_STREA_RNC + servlev.RAB_ACT_FAIL_PS_STREA_UE +
            servlev.RAB_ACT_FAIL_PS_INTER_IU + servlev.RAB_ACT_FAIL_PS_INTER_RADIO +
            servlev.RAB_ACT_FAIL_PS_INTER_BTS + servlev.RAB_ACT_FAIL_PS_INTER_IUR +
            servlev.RAB_ACT_FAIL_PS_INTER_RNC + servlev.RAB_ACT_FAIL_PS_INTER_UE +
            servlev.RAB_ACT_FAIL_PS_BACKG_IU + servlev.RAB_ACT_FAIL_PS_BACKG_RADIO +
            servlev.RAB_ACT_FAIL_PS_BACKG_BTS + servlev.RAB_ACT_FAIL_PS_BACKG_IUR +
            servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE))*100,2) As R99分组域业务掉线率,
            
            Sum(servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
            servlev.RAB_ACT_FAIL_PS_CONV_BTS + servlev.RAB_ACT_FAIL_PS_CONV_IUR +
            servlev.RAB_ACT_FAIL_PS_CONV_RNC + servlev.RAB_ACT_FAIL_PS_CONV_UE +
            servlev.RAB_ACT_FAIL_PS_STREA_IU + servlev.RAB_ACT_FAIL_PS_STREA_RADIO +
            servlev.RAB_ACT_FAIL_PS_STREA_BTS + servlev.RAB_ACT_FAIL_PS_STREA_IUR +
            servlev.RAB_ACT_FAIL_PS_STREA_RNC + servlev.RAB_ACT_FAIL_PS_STREA_UE +
            servlev.RAB_ACT_FAIL_PS_INTER_IU + servlev.RAB_ACT_FAIL_PS_INTER_RADIO +
            servlev.RAB_ACT_FAIL_PS_INTER_BTS + servlev.RAB_ACT_FAIL_PS_INTER_IUR +
            servlev.RAB_ACT_FAIL_PS_INTER_RNC + servlev.RAB_ACT_FAIL_PS_INTER_UE +
            servlev.RAB_ACT_FAIL_PS_BACKG_IU + servlev.RAB_ACT_FAIL_PS_BACKG_RADIO +
            servlev.RAB_ACT_FAIL_PS_BACKG_BTS + servlev.RAB_ACT_FAIL_PS_BACKG_IUR +
            servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE -
            servlev.RAB_ACT_FAIL_PS_INT_PCH - servlev.RAB_ACT_FAIL_PS_BACKG_PCH) As X_R99分组域业务掉线率,
            
            Sum(servlev.RAB_ACT_COMP_PS_CONV + servlev.RAB_ACT_COMP_PS_STREA +
            servlev.RAB_ACT_COMP_PS_INTER + servlev.RAB_ACT_COMP_PS_BACKG +
            servlev.RAB_ACT_REL_PS_CONV_SRNC + servlev.RAB_ACT_REL_PS_CONV_P_EMP +
            servlev.RAB_ACT_REL_PS_STREA_SRNC + servlev.RAB_ACT_REL_PS_STREA_P_EMP +
            servlev.RAB_ACT_REL_PS_INTER_SRNC + servlev.RAB_ACT_REL_PS_BACKG_SRNC +
            servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
            servlev.RAB_ACT_FAIL_PS_CONV_BTS + servlev.RAB_ACT_FAIL_PS_CONV_IUR +
            servlev.RAB_ACT_FAIL_PS_CONV_RNC + servlev.RAB_ACT_FAIL_PS_CONV_UE +
            servlev.RAB_ACT_FAIL_PS_STREA_IU + servlev.RAB_ACT_FAIL_PS_STREA_RADIO +
            servlev.RAB_ACT_FAIL_PS_STREA_BTS + servlev.RAB_ACT_FAIL_PS_STREA_IUR +
            servlev.RAB_ACT_FAIL_PS_STREA_RNC + servlev.RAB_ACT_FAIL_PS_STREA_UE +
            servlev.RAB_ACT_FAIL_PS_INTER_IU + servlev.RAB_ACT_FAIL_PS_INTER_RADIO +
            servlev.RAB_ACT_FAIL_PS_INTER_BTS + servlev.RAB_ACT_FAIL_PS_INTER_IUR +
            servlev.RAB_ACT_FAIL_PS_INTER_RNC + servlev.RAB_ACT_FAIL_PS_INTER_UE +
            servlev.RAB_ACT_FAIL_PS_BACKG_IU + servlev.RAB_ACT_FAIL_PS_BACKG_RADIO +
            servlev.RAB_ACT_FAIL_PS_BACKG_BTS + servlev.RAB_ACT_FAIL_PS_BACKG_IUR +
            servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE) As Y_R99分组域业务掉线率,
            
            Sum(servlev.RAB_ACT_FAIL_PS_CONV_IU) As RAB_ACT_FAIL_PS_CONV_IU,
            Sum(servlev.RAB_ACT_FAIL_PS_STREA_IU) As RAB_ACT_FAIL_PS_STREA_IU,
            Sum(servlev.RAB_ACT_FAIL_PS_INTER_IU) As RAB_ACT_FAIL_PS_INTER_IU,
            Sum(servlev.RAB_ACT_FAIL_PS_BACKG_IU) As RAB_ACT_FAIL_PS_BACKG_IU,
            Sum(servlev.RAB_ACT_FAIL_PS_CONV_RADIO) As RAB_ACT_FAIL_PS_CONV_RADIO,
            Sum(servlev.RAB_ACT_FAIL_PS_STREA_RADIO) As RAB_ACT_FAIL_PS_STREA_RADIO,
            Sum(servlev.RAB_ACT_FAIL_PS_INTER_RADIO) As RAB_ACT_FAIL_PS_INTER_RADIO,
            Sum(servlev.RAB_ACT_FAIL_PS_BACKG_RADIO) As RAB_ACT_FAIL_PS_BACKG_RADIO,
            Sum(servlev.RAB_ACT_FAIL_PS_CONV_BTS) As RAB_ACT_FAIL_PS_CONV_BTS,
            Sum(servlev.RAB_ACT_FAIL_PS_STREA_BTS) As RAB_ACT_FAIL_PS_STREA_BTS,
            Sum(servlev.RAB_ACT_FAIL_PS_INTER_BTS) As RAB_ACT_FAIL_PS_INTER_BTS,
            Sum(servlev.RAB_ACT_FAIL_PS_BACKG_BTS) As RAB_ACT_FAIL_PS_BACKG_BTS,
            Sum(servlev.RAB_ACT_FAIL_PS_CONV_IUR) As RAB_ACT_FAIL_PS_CONV_IUR,
            Sum(servlev.RAB_ACT_FAIL_PS_STREA_IUR) As RAB_ACT_FAIL_PS_STREA_IUR,
            Sum(servlev.RAB_ACT_FAIL_PS_INTER_IUR) As RAB_ACT_FAIL_PS_INTER_IUR,
            Sum(servlev.RAB_ACT_FAIL_PS_BACKG_IUR) As RAB_ACT_FAIL_PS_BACKG_IUR,
            Sum(servlev.RAB_ACT_FAIL_PS_CONV_RNC) As RAB_ACT_FAIL_PS_CONV_RNC,
            Sum(servlev.RAB_ACT_FAIL_PS_STREA_RNC) As RAB_ACT_FAIL_PS_STREA_RNC,
            Sum(servlev.RAB_ACT_FAIL_PS_INTER_RNC) As RAB_ACT_FAIL_PS_INTER_RNC,
            Sum(servlev.RAB_ACT_FAIL_PS_BACKG_RNC) As RAB_ACT_FAIL_PS_BACKG_RNC,
            Sum(servlev.RAB_ACT_FAIL_PS_CONV_UE) As RAB_ACT_FAIL_PS_CONV_UE,
            Sum(servlev.RAB_ACT_FAIL_PS_STREA_UE) As RAB_ACT_FAIL_PS_STREA_UE,
            Sum(servlev.RAB_ACT_FAIL_PS_INTER_UE) As RAB_ACT_FAIL_PS_INTER_UE,
            Sum(servlev.RAB_ACT_FAIL_PS_BACKG_UE) As RAB_ACT_FAIL_PS_BACKG_UE,
            Sum(servlev.RAB_ACT_FAIL_PS_INT_PCH) As RAB_ACT_FAIL_PS_INT_PCH,
            Sum(servlev.RAB_ACT_FAIL_PS_BACKG_PCH) As RAB_ACT_FAIL_PS_BACKG_PCH
            
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
        (servlev.R99分组域业务掉线率 > 20 and servlev.Y_R99分组域业务掉线率 > 50)

    ORDER BY
        servlev.city,
        servlev.R99分组域业务掉线率  desc



   