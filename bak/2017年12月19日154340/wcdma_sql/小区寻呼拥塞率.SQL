select *
from 
    (SELECT
        rrc.city,
        rrc.wcel_rnc_id,
        rrc.ci,
        rrc.wbts_name,
        rrc.rpdate,
        rank() over( Partition by rrc.city Order by rrc.小区寻呼拥塞率_X DESC) AS RANKS,
        rrc.小区寻呼拥塞率,
        rrc.小区寻呼拥塞率_X,
        rrc.小区寻呼拥塞率_Y,
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
            SUM(rrc.CELL_UPD_AFTER_PAG_CELL_PCH + rrc.CELL_UPD_AFTER_PAG_URA_PCH)))*100, 4) As 小区寻呼拥塞率,

            SUM(rrc.FAIL_PAG_NO_RESP_CELL_PCH + rrc.FAIL_PAG_NO_RESP_URA_PCH) As 小区寻呼拥塞率_X,
            SUM(rrc.CELL_UPD_AFTER_PAG_CELL_PCH + rrc.CELL_UPD_AFTER_PAG_URA_PCH) As 小区寻呼拥塞率_Y,

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
        (rrc.小区寻呼拥塞率 > 1)

    Order by
        rrc.city,
        rrc.小区寻呼拥塞率_X DESC
        
        
    ) 

WHERE
    RANKS <=5   