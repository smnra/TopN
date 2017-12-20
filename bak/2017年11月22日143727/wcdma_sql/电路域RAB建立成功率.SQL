select *
from 
    (SELECT
        servlev.city,
        servlev.wcel_rnc_id,
        servlev.ci,
        servlev.wbts_name,
        servlev.rpdate,
        rank() over( Partition by servlev.city Order by 语音RAB建立成功率_Y - servlev.语音RAB建立成功率_X DESC) AS RANKS,
        servlev.语音RAB建立成功率,
        servlev.语音RAB建立成功率_X,
        servlev.语音RAB建立成功率_Y
            
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(servlev.period_start_time,'YYYY-MM-DD') rpdate,

            Round(Decode(Sum(servlev.RAB_STP_ATT_CS_VOICE), 0, Null,
            Sum(servlev.RAB_ACC_COMP_CS_VOICE) / (Sum(servlev.RAB_STP_ATT_CS_VOICE)))*100, 4) As 语音RAB建立成功率,


            Sum(servlev.RAB_ACC_COMP_CS_VOICE) AS 语音RAB建立成功率_X,
            Sum(servlev.RAB_STP_ATT_CS_VOICE) AS 语音RAB建立成功率_Y


        From
            NOKRWW_PS_SERVLEV_MNC1_RAW servlev
            Inner Join c_w_custom c on c.wcel_objid = servlev.WCEL_ID   
            
        Where
            servlev.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            servlev.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(servlev.period_start_time,'YYYY-MM-DD')
        ) servlev
        
    WHERE
        (servlev.语音RAB建立成功率 < 99 AND servlev.语音RAB建立成功率_Y >= 20)

    ORDER BY
        servlev.city,
        servlev.语音RAB建立成功率_Y - servlev.语音RAB建立成功率_X DESC   

 
    
    ) 

WHERE
    RANKS <=10   
 
 
 