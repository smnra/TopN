    SELECT
        SOFTHO.WCEL_ID,
        SOFTHO.rpdate,
        SOFTHO.小区软切换成功率,
        SOFTHO.X_小区软切换成功率,
        SOFTHO.Y_小区软切换成功率,
        SOFTHO.SETUP_FAIL_SHO_BRANCH_BTS,
        SOFTHO.SETUP_FAIL_SHO_BRANCH_IUB,
        SOFTHO.SUCC_UPDATES_ON_SHO_FOR_RT,
        SOFTHO.SUCC_UPDATES_ON_SHO_FOR_NRT
            
    FROM
        (Select
            SOFTHO.WCEL_ID,
            to_char(SOFTHO.period_start_time,'YYYY-MM-DD-HH24') rpdate,

            ROUND(Decode(Sum(SOFTHO.CELL_ADD_REQ_ON_SHO_FOR_RT + SOFTHO.CELL_DEL_REQ_ON_SHO_FOR_RT +
            SOFTHO.CELL_REPL_REQ_ON_SHO_FOR_RT + SOFTHO.CELL_ADD_REQ_ON_SHO_FOR_NRT +
            SOFTHO.CELL_DEL_REQ_ON_SHO_FOR_NRT + SOFTHO.CELL_REPL_REQ_ON_SHO_FOR_NRT),
            0, 0, Sum(SOFTHO.SUCC_UPDATES_ON_SHO_FOR_RT + SOFTHO.SUCC_UPDATES_ON_SHO_FOR_NRT) /
            Sum(SOFTHO.CELL_ADD_REQ_ON_SHO_FOR_RT + SOFTHO.CELL_DEL_REQ_ON_SHO_FOR_RT +
            SOFTHO.CELL_REPL_REQ_ON_SHO_FOR_RT + SOFTHO.CELL_ADD_REQ_ON_SHO_FOR_NRT +
            SOFTHO.CELL_DEL_REQ_ON_SHO_FOR_NRT + SOFTHO.CELL_REPL_REQ_ON_SHO_FOR_NRT))*100,2) As 小区软切换成功率,
            
            Sum(SOFTHO.SUCC_UPDATES_ON_SHO_FOR_RT + SOFTHO.SUCC_UPDATES_ON_SHO_FOR_NRT) As X_小区软切换成功率,
            
            Sum(SOFTHO.CELL_ADD_REQ_ON_SHO_FOR_RT + SOFTHO.CELL_DEL_REQ_ON_SHO_FOR_RT +
            SOFTHO.CELL_REPL_REQ_ON_SHO_FOR_RT + SOFTHO.CELL_ADD_REQ_ON_SHO_FOR_NRT +
            SOFTHO.CELL_DEL_REQ_ON_SHO_FOR_NRT + SOFTHO.CELL_REPL_REQ_ON_SHO_FOR_NRT) As Y_小区软切换成功率,
            
            Sum(SOFTHO.SETUP_FAIL_SHO_BRANCH_BTS) As SETUP_FAIL_SHO_BRANCH_BTS,
            Sum(SOFTHO.SETUP_FAIL_SHO_BRANCH_IUB) As SETUP_FAIL_SHO_BRANCH_IUB,
            Sum(SOFTHO.SUCC_UPDATES_ON_SHO_FOR_RT) As SUCC_UPDATES_ON_SHO_FOR_RT,
            Sum(SOFTHO.SUCC_UPDATES_ON_SHO_FOR_NRT) As SUCC_UPDATES_ON_SHO_FOR_NRT
            
        From
            NOKRWW_PS_SOFTHO_MNC1_RAW SOFTHO
         
        Where
            SOFTHO.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            SOFTHO.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            SOFTHO.WCEL_ID,
            to_char(SOFTHO.period_start_time,'YYYY-MM-DD-HH24')
        )  SOFTHO 
        
    WHERE
        (小区软切换成功率 < 90 AND Y_小区软切换成功率 <> 0)

    ORDER BY
        小区软切换成功率  

 
 
 