WITH busyhour_dl as
(SELECT 
       lncel_id,
       MAX(period_start_time) AS period_start_time
       
FROM 
        (SELECT
                lncel_id,
                period_start_time,
                下行最大业务量,
                rank() over( Partition by lncel_id Order by 下行最大业务量 DESC) AS RANKS
                
        FROM
                 (SELECT 
                    lcellt.lncel_id AS lncel_id,
                   lcellt.period_start_time AS period_start_time,
                    SUM(PDCP_SDU_VOL_DL)  AS 下行最大业务量
                    
                FROM 
                    NOKLTE_PS_LCELLT_LNCEL_HOUR lcellt
                WHERE 
                        lcellt.period_start_time >= to_date(&start_datetime, 'yyyy-mm-dd-hh24')
                    AND lcellt.period_start_time < to_date(&end_datetime, 'yyyy-mm-dd-hh24')
                    AND PDCP_SDU_VOL_DL >0

                GROUP BY 
                    lcellt.lncel_id,
                    lcellt.period_start_time
                    
                )
                
        )
        
WHERE
    RANKS =1
    
GROUP BY
    lncel_id
    
)




select *
from 
    (SELECT
        lho.city,
        lho.ci,
        lho.lnbts_name,
        lho.period_start_time,
        rank() over( Partition by lho.city Order by lho.异频切换请求次数 - lho.异频切换成功次数 DESC) AS RANKS,
        lho.异频切换成功率,
        lho.异频切换成功次数,
        lho.异频切换请求次数
        
    FROM    
        (Select
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lho.period_start_time,'YYYY-MM-DD') period_start_time,

            round(decode(sum(lho.HO_INTFREQ_SUCC),0,0,sum(lho.HO_INTFREQ_SUCC)/sum(lho.HO_INTFREQ_SUCC))*100,2)  异频切换成功率,
            sum(lho.HO_INTFREQ_SUCC) 异频切换请求次数,
            sum(lho.HO_INTFREQ_SUCC) 异频切换成功次数
            
                       
        FROM
            NOKLTE_PS_LHO_LNCEL_HOUR lho
            inner join busyhour_dl on busyhour_dl.lncel_id = lho.lncel_id
                                  and busyhour_dl.period_start_time = lho.period_start_time
            left Join C_LTE_CUSTOM c on c.lncel_objid = busyhour_dl.lncel_id
        
        Where
            lho.PERIOD_START_TIME >= To_Date(&start_datetime, 'yyyy-mm-dd-hh24') And
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