select *
from 
    (SELECT
        intsysho.city,
        intsysho.wcel_rnc_id,
        intsysho.ci,
        intsysho.wbts_name,
        intsysho.rpdate,
        rank() over( Partition by intsysho.city Order by intsysho.同频硬切换成功率_Y - intsysho.同频硬切换成功率_X DESC) AS RANKS,
        intsysho.同频硬切换成功率,
        intsysho.同频硬切换成功率_X,
        intsysho.同频硬切换成功率_Y,
        intsysho.succ_hho_caused_sho_incap_rt,
        intsysho.succ_hho_sho_incap_nrt,
        intsysho.hho_att_caused_sho_incap_rt,
        intsysho.immed_hho_csd_sho_incap_rt,
        intsysho.hho_att_caused_sho_incap_nrt,
        intsysho.immed_hho_csd_sho_incap_nrt
            
        
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(intsysho.period_start_time,'YYYY-MM-DD') rpdate,        

            Round(decode(sum(intsysho.hho_att_caused_sho_incap_rt+intsysho.immed_hho_csd_sho_incap_rt+
            intsysho.hho_att_caused_sho_incap_nrt+intsysho.immed_hho_csd_sho_incap_nrt),0,Null,
            (sum(intsysho.succ_hho_caused_sho_incap_rt+intsysho.succ_hho_sho_incap_nrt)/
            sum(intsysho.hho_att_caused_sho_incap_rt+intsysho.immed_hho_csd_sho_incap_rt+
            intsysho.hho_att_caused_sho_incap_nrt+intsysho.immed_hho_csd_sho_incap_nrt)))*100,4) As 同频硬切换成功率,

            sum(intsysho.succ_hho_caused_sho_incap_rt+intsysho.succ_hho_sho_incap_nrt) As 同频硬切换成功率_X,
            sum(intsysho.hho_att_caused_sho_incap_rt+intsysho.immed_hho_csd_sho_incap_rt+
            intsysho.hho_att_caused_sho_incap_nrt+intsysho.immed_hho_csd_sho_incap_nrt)  As 同频硬切换成功率_Y,
            
            sum(intsysho.succ_hho_caused_sho_incap_rt) AS succ_hho_caused_sho_incap_rt,
            sum(intsysho.succ_hho_sho_incap_nrt) AS succ_hho_sho_incap_nrt,
            sum(intsysho.hho_att_caused_sho_incap_rt) AS hho_att_caused_sho_incap_rt,
            sum(intsysho.immed_hho_csd_sho_incap_rt) AS immed_hho_csd_sho_incap_rt,
            sum(intsysho.hho_att_caused_sho_incap_nrt) AS hho_att_caused_sho_incap_nrt,
            sum(intsysho.immed_hho_csd_sho_incap_nrt) AS immed_hho_csd_sho_incap_nrt

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
        (intsysho.同频硬切换成功率 < 99 and intsysho.同频硬切换成功率_Y >= 100)

      

    Order by
        intsysho.city,
        intsysho.同频硬切换成功率_Y - intsysho.同频硬切换成功率_X DESC
        
        
    ) 

WHERE
    RANKS <= 5   
 