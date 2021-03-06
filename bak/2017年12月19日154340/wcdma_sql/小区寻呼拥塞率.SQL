select *
from 
    (SELECT
        rrc.city,
        rrc.wcel_rnc_id,
        rrc.ci,
        rrc.wbts_name,
        rrc.rpdate,
        rank() over( Partition by rrc.city Order by rrc.С��Ѱ��ӵ����_X DESC) AS RANKS,
        rrc.С��Ѱ��ӵ����,
        rrc.С��Ѱ��ӵ����_X,
        rrc.С��Ѱ��ӵ����_Y,
        rrc.FAIL_PAG_NO_RESP_CELL_PCH,
        rrc.FAIL_PAG_NO_RESP_URA_PCH,
        rrc.CELL_UPD_AFTER_PAG_CELL_PCH,
        rrc.CELL_UPD_AFTER_PAG_URA_PCH
            
        
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(rrc.period_start_time,'YYYY-MM-DD') rpdate,        

            Round(decode(SUM(rrc.CELL_UPD_AFTER_PAG_CELL_PCH + rrc.CELL_UPD_AFTER_PAG_URA_PCH),0,0,
            (SUM(rrc.FAIL_PAG_NO_RESP_CELL_PCH + rrc.FAIL_PAG_NO_RESP_URA_PCH)/
            SUM(rrc.CELL_UPD_AFTER_PAG_CELL_PCH + rrc.CELL_UPD_AFTER_PAG_URA_PCH)))*100, 4) As С��Ѱ��ӵ����,

            SUM(rrc.FAIL_PAG_NO_RESP_CELL_PCH + rrc.FAIL_PAG_NO_RESP_URA_PCH) As С��Ѱ��ӵ����_X,
            SUM(rrc.CELL_UPD_AFTER_PAG_CELL_PCH + rrc.CELL_UPD_AFTER_PAG_URA_PCH) As С��Ѱ��ӵ����_Y,

            SUM(rrc.FAIL_PAG_NO_RESP_CELL_PCH) As FAIL_PAG_NO_RESP_CELL_PCH,
            SUM(rrc.FAIL_PAG_NO_RESP_URA_PCH) As FAIL_PAG_NO_RESP_URA_PCH,
            SUM(rrc.CELL_UPD_AFTER_PAG_CELL_PCH) As CELL_UPD_AFTER_PAG_CELL_PCH, 
            SUM(rrc.CELL_UPD_AFTER_PAG_URA_PCH) As CELL_UPD_AFTER_PAG_URA_PCH
            
        From
            NOKRWW_PS_RRC_MNC1_RAW rrc
        Inner Join c_w_custom c on c.wcel_objid = rrc.WCEL_ID  
        
        Where
            rrc.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            rrc.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(rrc.period_start_time,'YYYY-MM-DD')
        )  rrc
        
    WHERE
        (rrc.С��Ѱ��ӵ���� > 1)

    Order by
        rrc.city,
        rrc.С��Ѱ��ӵ����_X DESC
        
        
    ) 

WHERE
    RANKS <=5   