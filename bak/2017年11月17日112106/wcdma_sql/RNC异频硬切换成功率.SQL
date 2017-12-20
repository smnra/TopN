select *
from 
    (SELECT
        intsysho.city,
        intsysho.wcel_rnc_id,
        intsysho.ci,
        intsysho.wbts_name,
        intsysho.rpdate,
        rank() over( Partition by intsysho.city Order by intsysho.RNC异频硬切换成功率_Y - intsysho.RNC异频硬切换成功率_X DESC) AS RANKS,
        intsysho.RNC异频硬切换成功率,
        intsysho.RNC异频硬切换成功率_X,
        intsysho.RNC异频硬切换成功率_Y,
        intsysho.succ_inter_hho_att_rt,
        intsysho.succ_inter_hho_att_nrt,
        intsysho.inter_hho_att_rt,
        intsysho.inter_hho_att_nrt
            
        
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(intsysho.period_start_time,'YYYY-MM-DD') rpdate,

            Round(decode(sum(intsysho.inter_hho_att_rt+intsysho.inter_hho_att_nrt),0, Null,
            (sum(intsysho.succ_inter_hho_att_rt+intsysho.succ_inter_hho_att_nrt)/
            sum(intsysho.inter_hho_att_rt+intsysho.inter_hho_att_nrt)))*100,4) As RNC异频硬切换成功率,

            sum(intsysho.succ_inter_hho_att_rt+intsysho.succ_inter_hho_att_nrt) As RNC异频硬切换成功率_X,
            sum(intsysho.inter_hho_att_rt+intsysho.inter_hho_att_nrt)  As RNC异频硬切换成功率_Y,
            
            sum(intsysho.succ_inter_hho_att_rt) AS succ_inter_hho_att_rt,
            sum(intsysho.succ_inter_hho_att_nrt) AS succ_inter_hho_att_nrt,
            sum(intsysho.inter_hho_att_rt) AS inter_hho_att_rt,
            sum(intsysho.inter_hho_att_nrt) AS inter_hho_att_nrt

        From
            Nokrww_Ps_Intsysho_Mnc1_Raw intsysho
        Inner Join c_w_custom c on c.wcel_objid = intsysho.WCEL_ID  
        
        Where
            intsysho.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            intsysho.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(intsysho.period_start_time,'YYYY-MM-DD')
        )  intsysho
        
    WHERE
        (intsysho.RNC异频硬切换成功率 < 99 and intsysho.RNC异频硬切换成功率_Y >= 20)
        
    Order by 
        intsysho.city,
        intsysho.RNC异频硬切换成功率_Y - intsysho.RNC异频硬切换成功率_X DESC    
        
        
        
    ) 

WHERE
    RANKS <=10
    