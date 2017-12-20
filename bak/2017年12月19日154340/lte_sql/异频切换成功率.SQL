select *
from 
    (SELECT
        lho.city,
        lho.ci,
        lho.lnbts_name,
        lho.rpdate,
        rank() over( Partition by lho.city Order by lho.异频切换请求次数 - lho.异频切换成功次数 DESC) AS RANKS,
        lho.异频切换成功率,
        lho.异频切换成功次数,
        lho.异频切换请求次数
        
    FROM    
        (Select
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lho.period_start_time,'YYYY-MM-DD') rpdate,

            round(decode(sum(lho.HO_INTFREQ_SUCC),0,0,sum(lho.HO_INTFREQ_SUCC)/sum(lho.HO_INTFREQ_SUCC))*100,2)  异频切换成功率,
            sum(lho.HO_INTFREQ_SUCC) 异频切换请求次数,
            sum(lho.HO_INTFREQ_SUCC) 异频切换成功次数
            
                       
        FROM
            NOKLTE_PS_LHO_LNCEL_HOUR lho

        Inner Join C_LTE_CUSTOM c on c.lncel_objid = lho.lncel_id
        
        Where
            lho.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            lho.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lho.period_start_time,'YYYY-MM-DD')
            
        ) lho

    WHERE
        (lho.异频切换成功率 < 95 and lho.异频切换请求次数 >= 100)

    ORDER BY
        lho.city,
        lho.异频切换请求次数 - lho.异频切换成功次数 DESC
        
        
    ) 

WHERE
    RANKS <=5        