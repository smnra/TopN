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
        lpqul.city,
        lpqul.ci,
        lpqul.lnbts_name,
        lpqul.period_start_time,
        rank() over( Partition by lpqul.city Order by lpqul.平均每PRB干扰噪声功率 DESC) AS RANKS,
        lpqul.平均每PRB干扰噪声功率,
        lpqul.RSSI_PUCCH_MIN,
        lpqul.RSSI_PUCCH_AVG,
        lpqul.RSSI_PUSCH_MIN,
        lpqul.RSSI_PUSCH_AVG
        
    FROM    
        (Select
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lpqul.period_start_time,'YYYY-MM-DD') period_start_time,

            decode(sum((lpqul.RSSI_PUSCH_LEVEL_01)+(lpqul.RSSI_PUSCH_LEVEL_02)+
            (lpqul.RSSI_PUSCH_LEVEL_03)+(lpqul.RSSI_PUSCH_LEVEL_04)+(lpqul.RSSI_PUSCH_LEVEL_05)+
            (lpqul.RSSI_PUSCH_LEVEL_06)+(lpqul.RSSI_PUSCH_LEVEL_07)+(lpqul.RSSI_PUSCH_LEVEL_08)+
            (lpqul.RSSI_PUSCH_LEVEL_09)+(lpqul.RSSI_PUSCH_LEVEL_10)+(lpqul.RSSI_PUSCH_LEVEL_11)+
            (lpqul.RSSI_PUSCH_LEVEL_12)+(lpqul.RSSI_PUSCH_LEVEL_13)+(lpqul.RSSI_PUSCH_LEVEL_14)+
            (lpqul.RSSI_PUSCH_LEVEL_15)+(lpqul.RSSI_PUSCH_LEVEL_16)+(lpqul.RSSI_PUSCH_LEVEL_17)+
            (lpqul.RSSI_PUSCH_LEVEL_18)+(lpqul.RSSI_PUSCH_LEVEL_19)+(lpqul.RSSI_PUSCH_LEVEL_20)+
            (lpqul.RSSI_PUSCH_LEVEL_21)+(lpqul.RSSI_PUSCH_LEVEL_22)),0,-140,round(sum(-120*(lpqul.RSSI_PUSCH_LEVEL_01)-119*(lpqul.RSSI_PUSCH_LEVEL_02)-117*(lpqul.RSSI_PUSCH_LEVEL_03)-
            115*(lpqul.RSSI_PUSCH_LEVEL_04)-113*(lpqul.RSSI_PUSCH_LEVEL_05)-111*(lpqul.RSSI_PUSCH_LEVEL_06)-
            109*(lpqul.RSSI_PUSCH_LEVEL_07)-107*(lpqul.RSSI_PUSCH_LEVEL_08)-105*(lpqul.RSSI_PUSCH_LEVEL_09)-
            103*(lpqul.RSSI_PUSCH_LEVEL_10)-101*(lpqul.RSSI_PUSCH_LEVEL_11)-99*(lpqul.RSSI_PUSCH_LEVEL_12)-
            97*(lpqul.RSSI_PUSCH_LEVEL_13)-95*(lpqul.RSSI_PUSCH_LEVEL_14)-93*(lpqul.RSSI_PUSCH_LEVEL_15)-
            91*(lpqul.RSSI_PUSCH_LEVEL_16)-89*(lpqul.RSSI_PUSCH_LEVEL_17)-87*(lpqul.RSSI_PUSCH_LEVEL_18)-
            85*(lpqul.RSSI_PUSCH_LEVEL_19)-83*(lpqul.RSSI_PUSCH_LEVEL_20)-81*(lpqul.RSSI_PUSCH_LEVEL_21)-
            80*(lpqul.RSSI_PUSCH_LEVEL_22))/sum((lpqul.RSSI_PUSCH_LEVEL_01)+(lpqul.RSSI_PUSCH_LEVEL_02)+
            (lpqul.RSSI_PUSCH_LEVEL_03)+(lpqul.RSSI_PUSCH_LEVEL_04)+(lpqul.RSSI_PUSCH_LEVEL_05)+
            (lpqul.RSSI_PUSCH_LEVEL_06)+(lpqul.RSSI_PUSCH_LEVEL_07)+(lpqul.RSSI_PUSCH_LEVEL_08)+
            (lpqul.RSSI_PUSCH_LEVEL_09)+(lpqul.RSSI_PUSCH_LEVEL_10)+(lpqul.RSSI_PUSCH_LEVEL_11)+
            (lpqul.RSSI_PUSCH_LEVEL_12)+(lpqul.RSSI_PUSCH_LEVEL_13)+(lpqul.RSSI_PUSCH_LEVEL_14)+
            (lpqul.RSSI_PUSCH_LEVEL_15)+(lpqul.RSSI_PUSCH_LEVEL_16)+(lpqul.RSSI_PUSCH_LEVEL_17)+
            (lpqul.RSSI_PUSCH_LEVEL_18)+(lpqul.RSSI_PUSCH_LEVEL_19)+(lpqul.RSSI_PUSCH_LEVEL_20)+
            (lpqul.RSSI_PUSCH_LEVEL_21)+(lpqul.RSSI_PUSCH_LEVEL_22)),2))
            -
            decode(sum((lpqul.SINR_PUSCH_LEVEL_1)+(lpqul.SINR_PUSCH_LEVEL_2)+(lpqul.SINR_PUSCH_LEVEL_3)+
            (lpqul.SINR_PUSCH_LEVEL_4)+(lpqul.SINR_PUSCH_LEVEL_5)+(lpqul.SINR_PUSCH_LEVEL_6)+(lpqul.SINR_PUSCH_LEVEL_7)
            +(lpqul.SINR_PUSCH_LEVEL_8)+(lpqul.SINR_PUSCH_LEVEL_9)+(lpqul.SINR_PUSCH_LEVEL_10)+
            (lpqul.SINR_PUSCH_LEVEL_11)+(lpqul.SINR_PUSCH_LEVEL_12)+(lpqul.SINR_PUSCH_LEVEL_13)+
            (lpqul.SINR_PUSCH_LEVEL_14)+(lpqul.SINR_PUSCH_LEVEL_15)+(lpqul.SINR_PUSCH_LEVEL_16)+
            (lpqul.SINR_PUSCH_LEVEL_17)+(lpqul.SINR_PUSCH_LEVEL_18)+(lpqul.SINR_PUSCH_LEVEL_19)+
            (lpqul.SINR_PUSCH_LEVEL_20)+(lpqul.SINR_PUSCH_LEVEL_21)+(lpqul.SINR_PUSCH_LEVEL_22)),0,0,round(sum(-10*(lpqul.SINR_PUSCH_LEVEL_1)-9*(lpqul.SINR_PUSCH_LEVEL_2)-7*(lpqul.SINR_PUSCH_LEVEL_3)-
            5*(lpqul.SINR_PUSCH_LEVEL_4)-3*(lpqul.SINR_PUSCH_LEVEL_5)-1*(lpqul.SINR_PUSCH_LEVEL_6)
            +1*(lpqul.SINR_PUSCH_LEVEL_7)+3*(lpqul.SINR_PUSCH_LEVEL_8)+5*(lpqul.SINR_PUSCH_LEVEL_9)+
            7*(lpqul.SINR_PUSCH_LEVEL_10)+9*(lpqul.SINR_PUSCH_LEVEL_11)+11*(lpqul.SINR_PUSCH_LEVEL_12)+
            13*(lpqul.SINR_PUSCH_LEVEL_13)+15*(lpqul.SINR_PUSCH_LEVEL_14)+17*(lpqul.SINR_PUSCH_LEVEL_15)+
            19*(lpqul.SINR_PUSCH_LEVEL_16)+21*(lpqul.SINR_PUSCH_LEVEL_17)+23*(lpqul.SINR_PUSCH_LEVEL_18)+
            25*(lpqul.SINR_PUSCH_LEVEL_19)+27*(lpqul.SINR_PUSCH_LEVEL_20)+29*(lpqul.SINR_PUSCH_LEVEL_21)+
            30*(lpqul.SINR_PUSCH_LEVEL_22))/sum((lpqul.SINR_PUSCH_LEVEL_1)+(lpqul.SINR_PUSCH_LEVEL_2)+(lpqul.SINR_PUSCH_LEVEL_3)+
            (lpqul.SINR_PUSCH_LEVEL_4)+(lpqul.SINR_PUSCH_LEVEL_5)+(lpqul.SINR_PUSCH_LEVEL_6)+(lpqul.SINR_PUSCH_LEVEL_7)
            +(lpqul.SINR_PUSCH_LEVEL_8)+(lpqul.SINR_PUSCH_LEVEL_9)+(lpqul.SINR_PUSCH_LEVEL_10)+
            (lpqul.SINR_PUSCH_LEVEL_11)+(lpqul.SINR_PUSCH_LEVEL_12)+(lpqul.SINR_PUSCH_LEVEL_13)+
            (lpqul.SINR_PUSCH_LEVEL_14)+(lpqul.SINR_PUSCH_LEVEL_15)+(lpqul.SINR_PUSCH_LEVEL_16)+
            (lpqul.SINR_PUSCH_LEVEL_17)+(lpqul.SINR_PUSCH_LEVEL_18)+(lpqul.SINR_PUSCH_LEVEL_19)+
            (lpqul.SINR_PUSCH_LEVEL_20)+(lpqul.SINR_PUSCH_LEVEL_21)+(lpqul.SINR_PUSCH_LEVEL_22)),2)) AS 平均每PRB干扰噪声功率,

            min(lpqul.RSSI_PUCCH_MIN)  RSSI_PUCCH_MIN,
            avg(lpqul.RSSI_PUCCH_AVG)  RSSI_PUCCH_AVG,
            min(lpqul.RSSI_PUSCH_MIN)  RSSI_PUSCH_MIN,
            avg(lpqul.RSSI_PUSCH_AVG)  RSSI_PUSCH_AVG
            
        FROM
            NOKLTE_PS_LPQUL_LNCEL_HOUR lpqul
            inner join busyhour_dl on busyhour_dl.lncel_id = lpqul.lncel_id
                                  and busyhour_dl.period_start_time = lpqul.period_start_time
            left Join C_LTE_CUSTOM c on c.lncel_objid = busyhour_dl.lncel_id
        
        Where
            lpqul.PERIOD_START_TIME >= To_Date(&start_datetime, 'yyyy-mm-dd-hh24') And
            lpqul.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lpqul.period_start_time,'YYYY-MM-DD')
            
        ) lpqul

    WHERE
        (lpqul.平均每PRB干扰噪声功率 >= -103 and lpqul.平均每PRB干扰噪声功率 <> 0)

    ORDER BY
        lpqul.city,
        lpqul.平均每PRB干扰噪声功率 DESC 
        
        
    ) 

WHERE
    RANKS <=5        