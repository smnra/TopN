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
        lpqdl.city,
        lpqdl.ci,
        lpqdl.lnbts_name,
        lpqdl.period_start_time,
        rank() over( Partition by lpqdl.city Order by CQI小于等于6的比例 DESC) AS RANKS,
        lpqdl.CQI小于等于6的比例,
        lpqdl.CQI总采样点
    
    FROM    
        (Select
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lpqdl.period_start_time,'YYYY-MM-DD') period_start_time,

            decode(sum(lpqdl.UE_REP_CQI_LEVEL_00+lpqdl.UE_REP_CQI_LEVEL_01+lpqdl.UE_REP_CQI_LEVEL_02+lpqdl.UE_REP_CQI_LEVEL_03+lpqdl.UE_REP_CQI_LEVEL_04+lpqdl.UE_REP_CQI_LEVEL_05+lpqdl.UE_REP_CQI_LEVEL_06+lpqdl.UE_REP_CQI_LEVEL_07+lpqdl.UE_REP_CQI_LEVEL_08+lpqdl.UE_REP_CQI_LEVEL_09+lpqdl.UE_REP_CQI_LEVEL_10+lpqdl.UE_REP_CQI_LEVEL_11+lpqdl.UE_REP_CQI_LEVEL_12+lpqdl.UE_REP_CQI_LEVEL_13+lpqdl.UE_REP_CQI_LEVEL_14+lpqdl.UE_REP_CQI_LEVEL_15),0,0,round(sum(lpqdl.UE_REP_CQI_LEVEL_00+lpqdl.UE_REP_CQI_LEVEL_01+lpqdl.UE_REP_CQI_LEVEL_02+lpqdl.UE_REP_CQI_LEVEL_03+lpqdl.UE_REP_CQI_LEVEL_04+lpqdl.UE_REP_CQI_LEVEL_05+lpqdl.UE_REP_CQI_LEVEL_06)/sum(lpqdl.UE_REP_CQI_LEVEL_00+lpqdl.UE_REP_CQI_LEVEL_01+lpqdl.UE_REP_CQI_LEVEL_02+lpqdl.UE_REP_CQI_LEVEL_03+lpqdl.UE_REP_CQI_LEVEL_04+lpqdl.UE_REP_CQI_LEVEL_05+lpqdl.UE_REP_CQI_LEVEL_06+lpqdl.UE_REP_CQI_LEVEL_07+lpqdl.UE_REP_CQI_LEVEL_08+lpqdl.UE_REP_CQI_LEVEL_09+lpqdl.UE_REP_CQI_LEVEL_10+lpqdl.UE_REP_CQI_LEVEL_11+lpqdl.UE_REP_CQI_LEVEL_12+lpqdl.UE_REP_CQI_LEVEL_13+lpqdl.UE_REP_CQI_LEVEL_14+lpqdl.UE_REP_CQI_LEVEL_15),2)) AS "CQI小于等于6的比例",

            sum(lpqdl.UE_REP_CQI_LEVEL_00+lpqdl.UE_REP_CQI_LEVEL_01+lpqdl.UE_REP_CQI_LEVEL_02+lpqdl.UE_REP_CQI_LEVEL_03+lpqdl.UE_REP_CQI_LEVEL_04+lpqdl.UE_REP_CQI_LEVEL_05+lpqdl.UE_REP_CQI_LEVEL_06+lpqdl.UE_REP_CQI_LEVEL_07+lpqdl.UE_REP_CQI_LEVEL_08+lpqdl.UE_REP_CQI_LEVEL_09+lpqdl.UE_REP_CQI_LEVEL_10+lpqdl.UE_REP_CQI_LEVEL_11+lpqdl.UE_REP_CQI_LEVEL_12+lpqdl.UE_REP_CQI_LEVEL_13+lpqdl.UE_REP_CQI_LEVEL_14+lpqdl.UE_REP_CQI_LEVEL_15) AS CQI总采样点

        FROM
            NOKLTE_PS_LPQDL_LNCEL_HOUR lpqdl
            inner join busyhour_dl on busyhour_dl.lncel_id = lpqdl.lncel_id
                                  and busyhour_dl.period_start_time = lpqdl.period_start_time
            left Join C_LTE_CUSTOM c on c.lncel_objid = busyhour_dl.lncel_id
        
        Where
            lpqdl.PERIOD_START_TIME >= To_Date(&start_datetime, 'yyyy-mm-dd-hh24') And
            lpqdl.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lpqdl.period_start_time,'YYYY-MM-DD')
            
        ) lpqdl

    WHERE
        (lpqdl.CQI小于等于6的比例 >= 20 and lpqdl.CQI总采样点 >= 1000)

    ORDER BY
        lpqdl.city,
        lpqdl.CQI小于等于6的比例 DESC 
        
        
    ) 

WHERE
    RANKS <=5        