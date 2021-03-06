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
        lianbho.city,
        lianbho.ci,
        lianbho.lnbts_name,
        lianbho.period_start_time,
        rank() over( Partition by lianbho.city Order by lianbho.同频切换请求次数 - lianbho.同频切换成功次数 DESC) AS RANKS,
        lianbho.同频切换成功率,
        lianbho.同频切换成功次数,
        lianbho.同频切换请求次数
        
    FROM    
        (Select
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lianbho.period_start_time,'YYYY-MM-DD') period_start_time,

            round(decode(sum(lianbho.ATT_INTRA_ENB_HO+lienbho.ATT_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_ATT-lho.HO_INTFREQ_ATT),0,0,sum(lianbho.SUCC_INTRA_ENB_HO+lienbho.SUCC_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_SUCC - lho.HO_INTFREQ_SUCC)/sum(lianbho.ATT_INTRA_ENB_HO+lienbho.ATT_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_ATT-lho.HO_INTFREQ_ATT))*100,2) AS 同频切换成功率,
            
            sum(lianbho.ATT_INTRA_ENB_HO+lienbho.ATT_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_ATT-lho.HO_INTFREQ_ATT) AS 同频切换请求次数,
            
            sum(lianbho.SUCC_INTRA_ENB_HO+lienbho.SUCC_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_SUCC-lho.HO_INTFREQ_SUCC) AS 同频切换成功次数
                       
        FROM
            NOKLTE_PS_LIANBHO_LNCEL_HOUR lianbho
            inner join busyhour_dl on busyhour_dl.lncel_id = lianbho.lncel_id
                                  and busyhour_dl.period_start_time = lianbho.period_start_time
            left Join C_LTE_CUSTOM c on c.lncel_objid = busyhour_dl.lncel_id
            
            Left Join NOKLTE_PS_LHO_LNCEL_HOUR lho
                 ON busyhour_dl.period_start_time = lho.period_start_time
                AND busyhour_dl.lncel_id = lho.lncel_id
                AND lho.period_start_time >= To_Date(&start_datetime, 'yyyy-mm-dd-hh24')
                AND lho.period_start_time < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
                
            Left Join NOKLTE_PS_LIENBHO_LNCEL_HOUR lienbho
                 ON busyhour_dl.period_start_time = lienbho.period_start_time
                AND busyhour_dl.lncel_id = lienbho.lncel_id
                AND lienbho.period_start_time >= To_Date(&start_datetime, 'yyyy-mm-dd-hh24')
                AND lienbho.period_start_time < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
        
        Where
            lianbho.PERIOD_START_TIME >= To_Date(&start_datetime, 'yyyy-mm-dd-hh24') And
            lianbho.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lianbho.period_start_time,'YYYY-MM-DD')
            
        ) lianbho

    WHERE
        (lianbho.同频切换成功率 < 95 and lianbho.同频切换请求次数 >= 100)

    ORDER BY
        lianbho.city,
        lianbho.同频切换请求次数 - lianbho.同频切换成功次数 DESC 
        
        
    ) 

WHERE
    RANKS <=5         