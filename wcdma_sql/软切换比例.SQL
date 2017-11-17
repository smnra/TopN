select *
from 
    (SELECT
        SOFTHO.city,
        SOFTHO.wcel_rnc_id,
        SOFTHO.ci,
        SOFTHO.wbts_name,
        SOFTHO.rpdate,
        rank() over( Partition by SOFTHO.city Order by SOFTHO.»Ì«–ªª±»¿˝_X DESC) AS RANKS,
        SOFTHO.»Ì«–ªª±»¿˝,
        SOFTHO.»Ì«–ªª±»¿˝_X,
        SOFTHO.»Ì«–ªª±»¿˝_Y,
        softho.ONE_CELL_IN_ACT_SET_FOR_RT,
        softho.ONE_CELL_IN_ACT_SET_FOR_NRT,
        softho.TWO_CELLS_IN_ACT_SET_FOR_RT, 
        softho.TWO_CELLS_IN_ACT_SET_FOR_NRT,
        softho.THREE_CELLS_IN_ACT_SET_RT,
        softho.THREE_CELLS_IN_ACT_SET_NRT
            
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(SOFTHO.period_start_time,'YYYY-MM-DD') rpdate,

            round(decode(sum((nvl((softho.ONE_CELL_IN_ACT_SET_FOR_RT + softho.ONE_CELL_IN_ACT_SET_FOR_NRT)*1,0)+
            nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*2,0)+
            nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*3,0))),0,NULL,
            sum((nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*1,0)+
            nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*2,0))) /
            sum((nvl((softho.ONE_CELL_IN_ACT_SET_FOR_RT + softho.ONE_CELL_IN_ACT_SET_FOR_NRT)*1,0)+
            nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*2,0)+
            nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*3,0)))*100),3) AS »Ì«–ªª±»¿˝,
            
            sum((nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*1,0)+
            nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*2,0))) AS »Ì«–ªª±»¿˝_X,
            
            sum((nvl((softho.ONE_CELL_IN_ACT_SET_FOR_RT + softho.ONE_CELL_IN_ACT_SET_FOR_NRT)*1,0)+
            nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*2,0)+
            nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*3,0))) AS »Ì«–ªª±»¿˝_Y,

            sum(softho.ONE_CELL_IN_ACT_SET_FOR_RT) AS ONE_CELL_IN_ACT_SET_FOR_RT,
            sum(softho.ONE_CELL_IN_ACT_SET_FOR_NRT) AS ONE_CELL_IN_ACT_SET_FOR_NRT,
            sum(softho.TWO_CELLS_IN_ACT_SET_FOR_RT) AS TWO_CELLS_IN_ACT_SET_FOR_RT,
            sum(softho.TWO_CELLS_IN_ACT_SET_FOR_NRT) AS TWO_CELLS_IN_ACT_SET_FOR_NRT,
            sum(softho.THREE_CELLS_IN_ACT_SET_RT) AS THREE_CELLS_IN_ACT_SET_RT,
            sum(softho.THREE_CELLS_IN_ACT_SET_NRT) AS THREE_CELLS_IN_ACT_SET_NRT
  
        From
            NOKRWW_PS_SOFTHO_MNC1_RAW SOFTHO
            Inner Join c_w_custom c on c.wcel_objid = SOFTHO.WCEL_ID   
            
        Where
            SOFTHO.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            SOFTHO.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(SOFTHO.period_start_time,'YYYY-MM-DD')
        )  SOFTHO 
        
    WHERE
        (SOFTHO.»Ì«–ªª±»¿˝ > 35 AND SOFTHO.»Ì«–ªª±»¿˝_X >= 100)

    Order by
        SOFTHO.city,
        SOFTHO.»Ì«–ªª±»¿˝_X DESC
        


    ) 

WHERE
    RANKS <=10   
 