select *
from 
    (SELECT
        intsysho.city,
        intsysho.wcel_rnc_id,
        intsysho.ci,
        intsysho.wbts_name,
        intsysho.rpdate,
        rank() over( Partition by intsysho.city Order by intsysho.RNC��ƵӲ�л��ɹ���_Y - intsysho.RNC��ƵӲ�л��ɹ���_X DESC) AS RANKS,
        intsysho.RNC��ƵӲ�л��ɹ���,
        intsysho.RNC��ƵӲ�л��ɹ���_X,
        intsysho.RNC��ƵӲ�л��ɹ���_Y,
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
            sum(intsysho.inter_hho_att_rt+intsysho.inter_hho_att_nrt)))*100,4) As RNC��ƵӲ�л��ɹ���,

            sum(intsysho.succ_inter_hho_att_rt+intsysho.succ_inter_hho_att_nrt) As RNC��ƵӲ�л��ɹ���_X,
            sum(intsysho.inter_hho_att_rt+intsysho.inter_hho_att_nrt)  As RNC��ƵӲ�л��ɹ���_Y,
            
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
        (intsysho.RNC��ƵӲ�л��ɹ��� < 99 and intsysho.RNC��ƵӲ�л��ɹ���_Y >= 20)
        
    Order by 
        intsysho.city,
        intsysho.RNC��ƵӲ�л��ɹ���_Y - intsysho.RNC��ƵӲ�л��ɹ���_X DESC    
        
        
        
    ) 

WHERE
    RANKS <= 5
    