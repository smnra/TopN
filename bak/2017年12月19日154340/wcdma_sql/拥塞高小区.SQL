select *
from 
    (SELECT
        servlev.city,
        servlev.wcel_rnc_id,
        servlev.ci,
        servlev.wbts_name,
        servlev.rpdate,
        rank() over( Partition by servlev.city Order by servlev.小区拥塞率_X DESC) AS RANKS,
        servlev.小区拥塞率,
        servlev.小区拥塞率_X,
        servlev.小区拥塞率_Y,
        servlev.RAB_STP_FAIL_CS_VOICE_FROZBS,
        servlev.RAB_STP_FAIL_CS_CONV_FROZBS,
        servlev.RAB_STP_FAIL_CS_STREA_FROZBS,
        servlev.RAB_STP_FAIL_PS_CONV_FROZBS,
        servlev.RAB_STP_FAIL_PS_STREA_FROZBS,
        servlev.RAB_STP_FAIL_PS_INTER_FROZBS,
        servlev.RAB_STP_FAIL_PS_BACKG_FROZBS,
        servlev.RAB_STP_FAIL_CS_VOICE_RNC,
        servlev.RAB_STP_FAIL_CS_CONV_RNC,
        servlev.RAB_STP_FAIL_CS_STREA_RNC,
        servlev.RAB_STP_FAIL_PS_CONV_RNC,
        servlev.RAB_STP_FAIL_PS_STREA_RNC,
        servlev.RAB_STP_FAIL_PS_INTER_RNC,
        servlev.RAB_STP_FAIL_PS_BACKG_RNC,
        servlev.RAB_STP_FAIL_CS_VOICE_AC,
        servlev.RAB_STP_FAIL_CS_CONV_AC,
        servlev.RAB_STP_FAIL_CS_STREA_AC,
        servlev.RAB_STP_FAIL_PS_CONV_AC,
        servlev.RAB_STP_FAIL_PS_STREA_AC,
        servlev.RAB_STP_FAIL_PS_INTER_AC,
        servlev.RAB_STP_FAIL_PS_BACKG_AC,
        servlev.RAB_STP_FAIL_CS_V_IUB_AAL2,
        servlev.RAB_STP_FAIL_CS_CO_IUB_AAL2,
        servlev.RAB_STP_FAIL_CS_ST_IUB_AAL2,
        servlev.RAB_STP_FAIL_PS_ST_IUB_AAL2
        
    FROM
        (Select
            c.city,
            c.wcel_rnc_id,
            c.ci,
            c.wbts_name,
            to_char(servlev.period_start_time,'YYYY-MM-DD') rpdate,

            Round(Decode(Sum(servlev.RAB_STP_ATT_CS_VOICE + servlev.RAB_STP_ATT_CS_CONV +
            servlev.RAB_STP_ATT_CS_STREA + servlev.RAB_STP_ATT_PS_CONV +
            servlev.RAB_STP_ATT_PS_STREA + servlev.RAB_STP_ATT_PS_INTER +
            servlev.RAB_STP_ATT_PS_BACKG), 0, Null, Sum(servlev.RAB_STP_FAIL_CS_VOICE_FROZBS
            + servlev.RAB_STP_FAIL_CS_CONV_FROZBS + servlev.RAB_STP_FAIL_CS_STREA_FROZBS +
            servlev.RAB_STP_FAIL_PS_CONV_FROZBS + servlev.RAB_STP_FAIL_PS_STREA_FROZBS +
            servlev.RAB_STP_FAIL_PS_INTER_FROZBS + servlev.RAB_STP_FAIL_PS_BACKG_FROZBS +
            servlev.RAB_STP_FAIL_CS_VOICE_RNC + servlev.RAB_STP_FAIL_CS_CONV_RNC +
            servlev.RAB_STP_FAIL_CS_STREA_RNC + servlev.RAB_STP_FAIL_PS_CONV_RNC +
            servlev.RAB_STP_FAIL_PS_STREA_RNC + servlev.RAB_STP_FAIL_PS_INTER_RNC +
            servlev.RAB_STP_FAIL_PS_BACKG_RNC + servlev.RAB_STP_FAIL_CS_VOICE_AC +
            servlev.RAB_STP_FAIL_CS_CONV_AC + servlev.RAB_STP_FAIL_CS_STREA_AC +
            servlev.RAB_STP_FAIL_PS_CONV_AC + servlev.RAB_STP_FAIL_PS_STREA_AC +
            servlev.RAB_STP_FAIL_PS_INTER_AC + servlev.RAB_STP_FAIL_PS_BACKG_AC +
            servlev.RAB_STP_FAIL_CS_V_IUB_AAL2 + servlev.RAB_STP_FAIL_CS_CO_IUB_AAL2 +
            servlev.RAB_STP_FAIL_CS_ST_IUB_AAL2 + servlev.RAB_STP_FAIL_PS_ST_IUB_AAL2) /
            Sum(servlev.RAB_STP_ATT_CS_VOICE + servlev.RAB_STP_ATT_CS_CONV +
            servlev.RAB_STP_ATT_CS_STREA + servlev.RAB_STP_ATT_PS_CONV +
            servlev.RAB_STP_ATT_PS_STREA + servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG))*100, 4) As 小区拥塞率,


            Sum(servlev.RAB_STP_FAIL_CS_VOICE_FROZBS
            + servlev.RAB_STP_FAIL_CS_CONV_FROZBS + servlev.RAB_STP_FAIL_CS_STREA_FROZBS +
            servlev.RAB_STP_FAIL_PS_CONV_FROZBS + servlev.RAB_STP_FAIL_PS_STREA_FROZBS +
            servlev.RAB_STP_FAIL_PS_INTER_FROZBS + servlev.RAB_STP_FAIL_PS_BACKG_FROZBS +
            servlev.RAB_STP_FAIL_CS_VOICE_RNC + servlev.RAB_STP_FAIL_CS_CONV_RNC +
            servlev.RAB_STP_FAIL_CS_STREA_RNC + servlev.RAB_STP_FAIL_PS_CONV_RNC +
            servlev.RAB_STP_FAIL_PS_STREA_RNC + servlev.RAB_STP_FAIL_PS_INTER_RNC +
            servlev.RAB_STP_FAIL_PS_BACKG_RNC + servlev.RAB_STP_FAIL_CS_VOICE_AC +
            servlev.RAB_STP_FAIL_CS_CONV_AC + servlev.RAB_STP_FAIL_CS_STREA_AC +
            servlev.RAB_STP_FAIL_PS_CONV_AC + servlev.RAB_STP_FAIL_PS_STREA_AC +
            servlev.RAB_STP_FAIL_PS_INTER_AC + servlev.RAB_STP_FAIL_PS_BACKG_AC +
            servlev.RAB_STP_FAIL_CS_V_IUB_AAL2 + servlev.RAB_STP_FAIL_CS_CO_IUB_AAL2 +
            servlev.RAB_STP_FAIL_CS_ST_IUB_AAL2 + servlev.RAB_STP_FAIL_PS_ST_IUB_AAL2) AS 小区拥塞率_X,

            Sum(servlev.RAB_STP_ATT_CS_VOICE + servlev.RAB_STP_ATT_CS_CONV +
            servlev.RAB_STP_ATT_CS_STREA + servlev.RAB_STP_ATT_PS_CONV +
            servlev.RAB_STP_ATT_PS_STREA + servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG) AS 小区拥塞率_Y,

            SUM(servlev.RAB_STP_FAIL_CS_VOICE_FROZBS) AS RAB_STP_FAIL_CS_VOICE_FROZBS,
            SUM(servlev.RAB_STP_FAIL_CS_CONV_FROZBS) AS RAB_STP_FAIL_CS_CONV_FROZBS,
            SUM(servlev.RAB_STP_FAIL_CS_STREA_FROZBS) AS RAB_STP_FAIL_CS_STREA_FROZBS,
            SUM(servlev.RAB_STP_FAIL_PS_CONV_FROZBS) AS RAB_STP_FAIL_PS_CONV_FROZBS,
            SUM(servlev.RAB_STP_FAIL_PS_STREA_FROZBS) AS RAB_STP_FAIL_PS_STREA_FROZBS,
            SUM(servlev.RAB_STP_FAIL_PS_INTER_FROZBS) AS RAB_STP_FAIL_PS_INTER_FROZBS,
            SUM(servlev.RAB_STP_FAIL_PS_BACKG_FROZBS) AS RAB_STP_FAIL_PS_BACKG_FROZBS,
            SUM(servlev.RAB_STP_FAIL_CS_VOICE_RNC) AS RAB_STP_FAIL_CS_VOICE_RNC,
            SUM(servlev.RAB_STP_FAIL_CS_CONV_RNC) AS RAB_STP_FAIL_CS_CONV_RNC,
            SUM(servlev.RAB_STP_FAIL_CS_STREA_RNC) AS RAB_STP_FAIL_CS_STREA_RNC,
            SUM(servlev.RAB_STP_FAIL_PS_CONV_RNC) AS RAB_STP_FAIL_PS_CONV_RNC,
            SUM(servlev.RAB_STP_FAIL_PS_STREA_RNC) AS RAB_STP_FAIL_PS_STREA_RNC,
            SUM(servlev.RAB_STP_FAIL_PS_INTER_RNC) AS RAB_STP_FAIL_PS_INTER_RNC,
            SUM(servlev.RAB_STP_FAIL_PS_BACKG_RNC) AS RAB_STP_FAIL_PS_BACKG_RNC,
            SUM(servlev.RAB_STP_FAIL_CS_VOICE_AC) AS RAB_STP_FAIL_CS_VOICE_AC,
            SUM(servlev.RAB_STP_FAIL_CS_CONV_AC) AS RAB_STP_FAIL_CS_CONV_AC,
            SUM(servlev.RAB_STP_FAIL_CS_STREA_AC) AS RAB_STP_FAIL_CS_STREA_AC,
            SUM(servlev.RAB_STP_FAIL_PS_CONV_AC) AS RAB_STP_FAIL_PS_CONV_AC,
            SUM(servlev.RAB_STP_FAIL_PS_STREA_AC) AS RAB_STP_FAIL_PS_STREA_AC,
            SUM(servlev.RAB_STP_FAIL_PS_INTER_AC) AS RAB_STP_FAIL_PS_INTER_AC,
            SUM(servlev.RAB_STP_FAIL_PS_BACKG_AC) AS RAB_STP_FAIL_PS_BACKG_AC,
            SUM(servlev.RAB_STP_FAIL_CS_V_IUB_AAL2) AS RAB_STP_FAIL_CS_V_IUB_AAL2,
            SUM(servlev.RAB_STP_FAIL_CS_CO_IUB_AAL2) AS RAB_STP_FAIL_CS_CO_IUB_AAL2,
            SUM(servlev.RAB_STP_FAIL_CS_ST_IUB_AAL2) AS RAB_STP_FAIL_CS_ST_IUB_AAL2,
            SUM(servlev.RAB_STP_FAIL_PS_ST_IUB_AAL2) AS RAB_STP_FAIL_PS_ST_IUB_AAL2
             
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
        )  servlev
        
    WHERE
        (servlev.小区拥塞率_X >= 10)

    ORDER BY
        servlev.city,
        servlev.小区拥塞率_X  desc

    ) 

WHERE
    RANKS <=5   