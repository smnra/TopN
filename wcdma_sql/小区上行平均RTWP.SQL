    SELECT
        CELLRES.WCEL_ID,
        CELLRES.rpdate,
        CELLRES.小区上行平均RTWP

    FROM
        (Select
            CELLRES.WCEL_ID,
            to_char(CELLRES.period_start_time,'YYYY-MM-DD-HH24') rpdate,

            ROUND(( -112 + 0.1 * Avg(decode((CELLRES.PRXTOT_DENOM_0 +
            CELLRES.PRXTOT_DENOM_1 + CELLRES.PRXTOT_DENOM_2 + CELLRES.PRXTOT_DENOM_3 +
            CELLRES.PRXTOT_DENOM_4),0,0,(CELLRES.AVE_PRXTOT_CLASS_0 * CELLRES.PRXTOT_DENOM_0 +
            CELLRES.AVE_PRXTOT_CLASS_1 * CELLRES.PRXTOT_DENOM_1 + CELLRES.AVE_PRXTOT_CLASS_2 *
            CELLRES.PRXTOT_DENOM_2 + CELLRES.AVE_PRXTOT_CLASS_3 * CELLRES.PRXTOT_DENOM_3 +
            CELLRES.AVE_PRXTOT_CLASS_4 * CELLRES.PRXTOT_DENOM_4) / (CELLRES.PRXTOT_DENOM_0 +
            CELLRES.PRXTOT_DENOM_1 + CELLRES.PRXTOT_DENOM_2 + CELLRES.PRXTOT_DENOM_3 +
            CELLRES.PRXTOT_DENOM_4)))),2) As 小区上行平均RTWP
            
        From
            NOKRWW_PS_CELLRES_MNC1_RAW CELLRES

        Where
            CELLRES.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            CELLRES.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            CELLRES.WCEL_ID,
            to_char(CELLRES.period_start_time,'YYYY-MM-DD-HH24')
        )  CELLRES
        
    WHERE
        (小区上行平均RTWP < -104 )

    ORDER BY
        小区上行平均RTWP


 
 