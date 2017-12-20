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
        lepsb.city,
        lepsb.ci,
        lepsb.lnbts_name,
        lepsb.period_start_time,
        rank() over( Partition by lepsb.city Order by lepsb.ERAB建立请求次数 - lepsb.ERAB建立成功次数 DESC) AS RANKS,
        lepsb.ERAB建立成功率,
        lepsb.ERAB建立成功次数,
        lepsb.ERAB建立请求次数
        
    FROM    
        (Select
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lepsb.period_start_time,'YYYY-MM-DD') period_start_time,

            round(decode(sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS),0,0,sum(lepsb.EPS_BEARER_SETUP_COMPLETIONS)/sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS))*100,2) AS ERAB建立成功率,

            sum(lepsb.EPS_BEARER_SETUP_COMPLETIONS) AS ERAB建立成功次数,

            sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS) AS ERAB建立请求次数

        FROM
            NOKLTE_PS_LEPSB_LNCEL_HOUR lepsb
            inner join busyhour_dl on busyhour_dl.lncel_id = lepsb.lncel_id
                                  and busyhour_dl.period_start_time = lepsb.period_start_time
            left Join C_LTE_CUSTOM c on c.lncel_objid = busyhour_dl.lncel_id
        
        Where
            lepsb.PERIOD_START_TIME >= To_Date(&start_datetime, 'yyyy-mm-dd-hh24') And
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