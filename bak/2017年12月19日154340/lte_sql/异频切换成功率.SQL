select *
from 
    (SELECT
        lho.city,
        lho.ci,
        lho.lnbts_name,
        lho.rpdate,
        rank() over( Partition by lho.city Order by lho.��Ƶ�л�������� - lho.��Ƶ�л��ɹ����� DESC) AS RANKS,
        lho.��Ƶ�л��ɹ���,
        lho.��Ƶ�л��ɹ�����,
        lho.��Ƶ�л��������
        
    FROM    
        (Select
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lho.period_start_time,'YYYY-MM-DD') rpdate,

            round(decode(sum(lho.HO_INTFREQ_SUCC),0,0,sum(lho.HO_INTFREQ_SUCC)/sum(lho.HO_INTFREQ_SUCC))*100,2)  ��Ƶ�л��ɹ���,
            sum(lho.HO_INTFREQ_SUCC) ��Ƶ�л��������,
            sum(lho.HO_INTFREQ_SUCC) ��Ƶ�л��ɹ�����
            
                       
        FROM
            NOKLTE_PS_LHO_LNCEL_HOUR lho

        Inner Join C_LTE_CUSTOM c on c.lncel_objid = lho.lncel_id
        
        Where
            lho.PERIOD_START_TIME >= To_Date(&start_dateTime, 'yyyy-mm-dd-hh24') And
            lho.PERIOD_START_TIME < To_Date(&end_datetime, 'yyyy-mm-dd-hh24')
            
        Group By
            c.city,
            c.ci,
            c.lnbts_name,
            to_char(lho.period_start_time,'YYYY-MM-DD')
            
        ) lho

    WHERE
        (lho.��Ƶ�л��ɹ��� < 95 and lho.��Ƶ�л�������� >= 100)

    ORDER BY
        lho.city,
        lho.��Ƶ�л�������� - lho.��Ƶ�л��ɹ����� DESC
        
        
    ) 

WHERE
    RANKS <=5        