    SELECT
        CELLRES.city,
        CELLRES.wcel_rnc_id,
        CELLRES.ci,
        CELLRES.wbts_name,
        CELLRES.rpdate,
        CELLRES.小区上行平均RTWP

    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(CELLRES.period_start_time,'YYYY-MM-DD') rpdate,

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
            Inner Join c_w_custom c on c.wcel_objid = CELLRES.WCEL_ID 
            
        Where
            CELLRES.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            CELLRES.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(CELLRES.period_start_time,'YYYY-MM-DD')
        )  CELLRES
        
    WHERE
        (CELLRES.小区上行平均RTWP < -104 )

    ORDER BY
        CELLRES.city,
        CELLRES.小区上行平均RTWP


 
 