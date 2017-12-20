select *
from 
    (SELECT
        lepsb.city,
        lepsb.ci,
        lepsb.lnbts_name,
        lepsb.rpdate,
        rank() over( Partition by lepsb.city Order by lepsb.ERAB拥塞次数 DESC) AS RANKS,
        lepsb.ERAB拥塞率,
        lepsb.ERAB拥塞次数,
        lepsb.ERAB建立请求次数
        
    FROM    
        (Select
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lepsb.period_start_time,'YYYY-MM-DD') rpdate,

            round(decode(decode((CASE WHEN c.version='FL16' THEN 'FL16' WHEN c.version='FLF16' THEN 'FL16' ELSE c.version END),'FL16',SUM(lepsb.ERAB_INI_SETUP_FAIL_TNL_TRU + lepsb.ERAB_ADD_SETUP_FAIL_TNL_TRU + lepsb.ERAB_INI_SETUP_FAIL_RNL_RRNA + lepsb.ERAB_ADD_SETUP_FAIL_RNL_RRNA),sum(lepsb.EPS_BEARER_SETUP_FAIL_RESOUR)),0,0,decode((CASE WHEN c.version='FL16' THEN 'FL16' WHEN c.version='FLF16' THEN 'FL16' ELSE c.version END),'FL16',SUM(lepsb.ERAB_INI_SETUP_FAIL_TNL_TRU + lepsb.ERAB_ADD_SETUP_FAIL_TNL_TRU + lepsb.ERAB_INI_SETUP_FAIL_RNL_RRNA + lepsb.ERAB_ADD_SETUP_FAIL_RNL_RRNA),sum(lepsb.EPS_BEARER_SETUP_FAIL_RESOUR))/sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS))*100,2) AS ERAB拥塞率,

            decode((CASE WHEN c.version='FL16' THEN 'FL16' WHEN c.version='FLF16' THEN 'FL16' ELSE c.version END),'FL16',SUM(lepsb.ERAB_INI_SETUP_FAIL_TNL_TRU + lepsb.ERAB_ADD_SETUP_FAIL_TNL_TRU + lepsb.ERAB_INI_SETUP_FAIL_RNL_RRNA + lepsb.ERAB_ADD_SETUP_FAIL_RNL_RRNA),sum(lepsb.EPS_BEARER_SETUP_FAIL_RESOUR)) AS ERAB拥塞次数,

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
            c.version,
            c.lnbts_name,
            to_char(lepsb.period_start_time,'YYYY-MM-DD')
            
        ) lepsb

    WHERE
        (lepsb.ERAB拥塞率 > 0.5)

    ORDER BY
        lepsb.city,
        lepsb.ERAB拥塞次数 DESC 
        
        
    ) 

WHERE
    RANKS <=10         