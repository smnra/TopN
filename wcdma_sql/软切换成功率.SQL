select *
from 
    (SELECT
        SOFTHO.city,
        SOFTHO.wcel_rnc_id,
        SOFTHO.ci,
        SOFTHO.wbts_name,
        SOFTHO.rpdate,
        rank() over( Partition by SOFTHO.city Order by SOFTHO.Y_小区软切换成功率 - SOFTHO.X_小区软切换成功率 DESC) AS RANKS,
        SOFTHO.小区软切换成功率,
        SOFTHO.X_小区软切换成功率,
        SOFTHO.Y_小区软切换成功率,
        SOFTHO.SETUP_FAIL_SHO_BRANCH_BTS,
        SOFTHO.SETUP_FAIL_SHO_BRANCH_IUB,
        SOFTHO.SUCC_UPDATES_ON_SHO_FOR_RT,
        SOFTHO.UNSUCC_UPDATES_ON_SHO_FOR_RT,
        SOFTHO.UNSUCC_UPDATES_ON_SHO_NRT,
        SOFTHO.SUCC_UPDATES_ON_SHO_FOR_NRT
            
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(SOFTHO.period_start_time,'YYYY-MM-DD') rpdate,

            ROUND(Decode(Sum(SOFTHO.SUCC_UPDATES_ON_SHO_FOR_RT+ SOFTHO.UNSUCC_UPDATES_ON_SHO_FOR_RT+SOFTHO.SUCC_UPDATES_ON_SHO_FOR_NRT+ SOFTHO.UNSUCC_UPDATES_ON_SHO_NRT),
            0, 0, Sum(SOFTHO.SUCC_UPDATES_ON_SHO_FOR_RT + SOFTHO.SUCC_UPDATES_ON_SHO_FOR_NRT) /
            Sum(SOFTHO.SUCC_UPDATES_ON_SHO_FOR_RT+ SOFTHO.UNSUCC_UPDATES_ON_SHO_FOR_RT+SOFTHO.SUCC_UPDATES_ON_SHO_FOR_NRT+ SOFTHO.UNSUCC_UPDATES_ON_SHO_NRT))*100,2) As 小区软切换成功率,
            
            Sum(SOFTHO.SUCC_UPDATES_ON_SHO_FOR_RT + SOFTHO.SUCC_UPDATES_ON_SHO_FOR_NRT) As X_小区软切换成功率,
            
            Sum(SOFTHO.SUCC_UPDATES_ON_SHO_FOR_RT+ SOFTHO.UNSUCC_UPDATES_ON_SHO_FOR_RT+SOFTHO.SUCC_UPDATES_ON_SHO_FOR_NRT+ SOFTHO.UNSUCC_UPDATES_ON_SHO_NRT) As Y_小区软切换成功率,
            
            Sum(SOFTHO.SETUP_FAIL_SHO_BRANCH_BTS) As SETUP_FAIL_SHO_BRANCH_BTS,
            Sum(SOFTHO.SETUP_FAIL_SHO_BRANCH_IUB) As SETUP_FAIL_SHO_BRANCH_IUB,
            Sum(SOFTHO.SUCC_UPDATES_ON_SHO_FOR_RT) As SUCC_UPDATES_ON_SHO_FOR_RT,
            Sum(SOFTHO.UNSUCC_UPDATES_ON_SHO_FOR_RT) As UNSUCC_UPDATES_ON_SHO_FOR_RT,
            Sum(SOFTHO.UNSUCC_UPDATES_ON_SHO_NRT) As UNSUCC_UPDATES_ON_SHO_NRT,
            Sum(SOFTHO.SUCC_UPDATES_ON_SHO_FOR_NRT) As SUCC_UPDATES_ON_SHO_FOR_NRT
            
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
        (SOFTHO.小区软切换成功率 < 99 AND SOFTHO.Y_小区软切换成功率 >= 20)

    ORDER BY
        SOFTHO.city,
        SOFTHO.Y_小区软切换成功率 - SOFTHO.X_小区软切换成功率 DESC 

    ) 

WHERE
    RANKS <=10