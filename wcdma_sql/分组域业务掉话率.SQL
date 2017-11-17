select *
from 
    (SELECT
        servlev.city,
        servlev.wcel_rnc_id,
        servlev.ci,
        servlev.wbts_name,
        servlev.rpdate,
        rank() over( Partition by servlev.city Order by servlev.分组业务掉线率_X DESC) AS RANKS,
        servlev.分组业务掉线率,
        servlev.分组业务掉线率_X,
        servlev.分组业务掉线率_Y,
        servlev.rab_act_fail_ps_inter_bts,
        servlev.rab_act_fail_ps_inter_iu,
        servlev.rab_act_fail_ps_inter_iur,
        servlev.rab_act_fail_ps_inter_radio,
        servlev.rab_act_fail_ps_inter_rnc,
        servlev.rab_act_fail_ps_inter_ue,
        servlev.rab_act_fail_ps_inter_trans,
        servlev.rab_act_fail_ps_backg_bts,
        servlev.rab_act_fail_ps_backg_iu,
        servlev.rab_act_fail_ps_backg_iur,
        servlev.rab_act_fail_ps_backg_radio,
        servlev.rab_act_fail_ps_backg_rnc,
        servlev.rab_act_fail_ps_backg_ue,
        servlev.rab_act_fail_ps_backg_trans,
        servlev.rab_act_fail_ps_strea_bts,
        servlev.rab_act_fail_ps_strea_iu,
        servlev.rab_act_fail_ps_strea_iur,
        servlev.rab_act_fail_ps_strea_radio,
        servlev.rab_act_fail_ps_strea_rnc,
        servlev.rab_act_fail_ps_strea_ue,
        servlev.rab_act_fail_ps_strea_trans,
        servlev.RAB_ACT_FAIL_PS_BACKG_PCH,
        servlev.RAB_ACT_FAIL_PS_INT_PCH
            
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(servlev.period_start_time,'YYYY-MM-DD') rpdate,

            Round(Decode(Sum(servlev.RAB_ACT_COMP_PS_CONV + servlev.RAB_ACT_COMP_PS_STREA +
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
            servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE +
            rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH), 0,
            Null, Sum(servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
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
            servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE +
            rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH))*100, 4) As 分组业务掉线率,

            Sum(servlev.rab_act_fail_ps_inter_bts + servlev.rab_act_fail_ps_inter_iu
            + servlev.rab_act_fail_ps_inter_iur + servlev.rab_act_fail_ps_inter_radio
            + servlev.rab_act_fail_ps_inter_rnc + servlev.rab_act_fail_ps_inter_ue
            + servlev.rab_act_fail_ps_inter_trans + servlev.rab_act_fail_ps_backg_bts
            + servlev.rab_act_fail_ps_backg_iu + servlev.rab_act_fail_ps_backg_iur
            + servlev.rab_act_fail_ps_backg_radio + servlev.rab_act_fail_ps_backg_rnc
            + servlev.rab_act_fail_ps_backg_ue + servlev.rab_act_fail_ps_backg_trans
            + servlev.rab_act_fail_ps_strea_bts + servlev.rab_act_fail_ps_strea_iu
            + servlev.rab_act_fail_ps_strea_iur + servlev.rab_act_fail_ps_strea_radio
            + servlev.rab_act_fail_ps_strea_rnc + servlev.rab_act_fail_ps_strea_ue
            + servlev.rab_act_fail_ps_strea_trans -  servlev.RAB_ACT_FAIL_PS_BACKG_PCH
            -  servlev.RAB_ACT_FAIL_PS_INT_PCH) As 分组业务掉线率_X,

            Sum(servlev.rab_act_comp_ps_strea + servlev.rab_act_comp_ps_backg
            + servlev.rab_act_comp_ps_inter + servlev.rab_act_rel_ps_strea_p_emp
            + servlev.rab_act_rel_ps_strea_srnc + servlev.rab_act_rel_ps_backg_srnc
            + servlev.rab_act_rel_ps_inter_srnc + servlev.rab_act_rel_ps_strea_hho
            + servlev.rab_act_rel_ps_backg_hho + servlev.rab_act_rel_ps_inter_hho
            + servlev.rab_act_rel_ps_strea_isho + servlev.rab_act_rel_ps_bgr_isho
            + servlev.rab_act_rel_ps_inter_isho + servlev.rab_act_fail_ps_strea_iu
            + servlev.rab_act_fail_ps_strea_radio + servlev.rab_act_fail_ps_strea_bts
            + servlev.rab_act_fail_ps_strea_iur + servlev.rab_act_fail_ps_strea_rnc
            + servlev.rab_act_fail_ps_strea_ue + servlev.rab_act_fail_ps_strea_trans
            + servlev.rab_act_fail_ps_inter_iu + servlev.rab_act_fail_ps_inter_radio
            + servlev.rab_act_fail_ps_inter_bts + servlev.rab_act_fail_ps_inter_iur
            + servlev.rab_act_fail_ps_inter_rnc + servlev.rab_act_fail_ps_inter_ue
            + servlev.rab_act_fail_ps_inter_trans + servlev.rab_act_fail_ps_backg_iu
            + servlev.rab_act_fail_ps_backg_radio + servlev.rab_act_fail_ps_backg_bts
            + servlev.rab_act_fail_ps_backg_iur + servlev.rab_act_fail_ps_backg_rnc
            + servlev.rab_act_fail_ps_backg_ue + servlev.rab_act_fail_ps_backg_trans
            +rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) As 分组业务掉线率_Y,
          
            SUM(servlev.rab_act_fail_ps_inter_bts) AS rab_act_fail_ps_inter_bts,
            SUM(servlev.rab_act_fail_ps_inter_iu) AS rab_act_fail_ps_inter_iu,
            SUM(servlev.rab_act_fail_ps_inter_iur) AS rab_act_fail_ps_inter_iur,
            SUM(servlev.rab_act_fail_ps_inter_radio) AS rab_act_fail_ps_inter_radio,
            SUM(servlev.rab_act_fail_ps_inter_rnc) AS rab_act_fail_ps_inter_rnc,
            SUM(servlev.rab_act_fail_ps_inter_ue) AS rab_act_fail_ps_inter_ue,
            SUM(servlev.rab_act_fail_ps_inter_trans) AS rab_act_fail_ps_inter_trans,
            SUM(servlev.rab_act_fail_ps_backg_bts) AS rab_act_fail_ps_backg_bts,
            SUM(servlev.rab_act_fail_ps_backg_iu) AS rab_act_fail_ps_backg_iu,
            SUM(servlev.rab_act_fail_ps_backg_iur) AS rab_act_fail_ps_backg_iur,
            SUM(servlev.rab_act_fail_ps_backg_radio) AS rab_act_fail_ps_backg_radio,
            SUM(servlev.rab_act_fail_ps_backg_rnc) AS rab_act_fail_ps_backg_rnc,
            SUM(servlev.rab_act_fail_ps_backg_ue) AS rab_act_fail_ps_backg_ue,
            SUM(servlev.rab_act_fail_ps_backg_trans) AS rab_act_fail_ps_backg_trans,
            SUM(servlev.rab_act_fail_ps_strea_bts) AS rab_act_fail_ps_strea_bts,
            SUM(servlev.rab_act_fail_ps_strea_iu) AS rab_act_fail_ps_strea_iu,
            SUM(servlev.rab_act_fail_ps_strea_iur) AS rab_act_fail_ps_strea_iur,
            SUM(servlev.rab_act_fail_ps_strea_radio) AS rab_act_fail_ps_strea_radio,
            SUM(servlev.rab_act_fail_ps_strea_rnc) AS rab_act_fail_ps_strea_rnc,
            SUM(servlev.rab_act_fail_ps_strea_ue) AS rab_act_fail_ps_strea_ue,
            SUM(servlev.rab_act_fail_ps_strea_trans) AS rab_act_fail_ps_strea_trans,
            SUM(servlev.RAB_ACT_FAIL_PS_BACKG_PCH) AS RAB_ACT_FAIL_PS_BACKG_PCH,
            SUM(servlev.RAB_ACT_FAIL_PS_INT_PCH) AS RAB_ACT_FAIL_PS_INT_PCH
            
        From
            NOKRWW_PS_SERVLEV_MNC1_RAW servlev
        Left Join NOKRWW_PS_RRC_MNC1_RAW rrc
             ON servlev.period_start_time = rrc.period_start_time
            AND servlev.WCEL_ID = rrc.WCEL_ID
            AND rrc.period_start_time >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24')
            AND rrc.period_start_time < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
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
        ) servlev
        
    WHERE
        (servlev.分组业务掉线率 > 0.5 AND servlev.分组业务掉线率_X >= 20)

    Order by
        servlev.city,
        servlev.分组业务掉线率_X DESC
    
    ) 

WHERE
    RANKS <=10   
 

 
 
 