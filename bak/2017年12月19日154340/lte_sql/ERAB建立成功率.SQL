select *
from 
    (SELECT
        lepsb.city,
        lepsb.ci,
        lepsb.lnbts_name,
        lepsb.rpdate,
        rank() over( Partition by lepsb.city Order by lepsb.ERAB建立请求次数 - lepsb.ERAB建立成功次数 DESC) AS RANKS,
        lepsb.ERAB建立成功率,
        lepsb.ERAB建立成功次数,
        lepsb.ERAB建立请求次数
        
    FROM    
        (Select
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lepsb.period_start_time,'YYYY-MM-DD') rpdate,

            round(decode(sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS),0,0,sum(lepsb.EPS_BEARER_SETUP_COMPLETIONS)/sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS))*100,2) AS ERAB建立成功率,

            sum(lepsb.EPS_BEARER_SETUP_COMPLETIONS) AS ERAB建立成功次数,

            sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS) AS ERAB建立请求次数

        FROM
            NOKLTE_PS_LEPSB_LNCEL_HOUR lepsb

        Inner Join C_LTE_CUSTOM c on c.lncel_objid = lepsb.lncel_id
        
        Where
            lepsb.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            lepsb.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lepsb.period_start_time,'YYYY-MM-DD')
            
        ) lepsb

    WHERE
        (lepsb.ERAB建立成功率 < 99 and lepsb.ERAB建立请求次数 >= 100)

    ORDER BY
        lepsb.city,
        lepsb.ERAB建立请求次数 - lepsb.ERAB建立成功次数 DESC 
        
        
    ) 

WHERE
    RANKS <=5         