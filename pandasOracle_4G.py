# coding = utf-8
# -*- coding: utf-8 -*-

import os
os.environ['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.UTF8'
#os.environ['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.ZHS16GBK'
#sys.path.append('D:\\instantclient_12_1')

'''
os.path.sys.path.append('D:\\instantclient_12_1')
os.environ['ORACLE_HOME'] = 'D:\\instantclient_12_1'
os.environ['TNS_ADMIN'] = 'D:\\instantclient_12_1'
'''


os.path.sys.path.append('F:\\SMnRa\\smnra\\python\\3\\instantclient_12_1')
os.environ['ORACLE_HOME'] = 'F:\\SMnRa\\smnra\\python\\3\\instantclient_12_1'
os.environ['TNS_ADMIN'] = 'F:\\SMnRa\\smnra\\python\\3\\instantclient_12_1'


import six
import packaging
import packaging.version
import packaging.specifiers
import packaging.requirements
import cx_Oracle        #导入oracle 支持模块
from datetime import datetime         #导入 时间日期 模块
import pandas as pd
import SMTPProxy

start_datetime = datetime(datetime.today().year,datetime.today().month ,datetime.today().day-1).strftime("%Y%m%d") + '00'  # 昨天的日期 '2017102500'
end_datetime = datetime.today().strftime("%Y%m%d") + '00' # 今天的日期 '2017102600'


sql = r"""
        SELECT
            cu.city,
            cu.netmodel,
            cu.lnbtsid,
            cu.lncel_lcr_id,
            cu.version,
            to_char(lcelav.period_start_time, 'yyyy-mm-dd') stdate
            ,lcelav.LNCEL_ID
            ,round(decode(sum(lcelav.DENOM_CELL_AVAIL),0,0,sum(lcelav.SAMPLES_CELL_AVAIL)/sum(lcelav.DENOM_CELL_AVAIL))*100,2) 小区可用率
            ,sum(lcelav.DENOM_CELL_AVAIL- lcelav.SAMPLES_CELL_AVAIL)*10  退服时长

            ,round(DECODE(decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' WHEN cu.version='FL16A' THEN 'FL16' WHEN cu.version='TL16' THEN 'FL16' ELSE cu.version END),'FL16', sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)), sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO))), 0, 0, sum(luest.SIGN_CONN_ESTAB_COMP) / decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' ELSE cu.version END),'FL16', sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)))) * DECODE(sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS),0,0,sum(lepsb.EPS_BEARER_SETUP_COMPLETIONS)/sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS))*100,2) 无线接通率

            ,round(DECODE(decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' WHEN cu.version='FL16A' THEN 'FL16' WHEN cu.version='TL16' THEN 'FL16' ELSE cu.version END), 'FL16',sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0, luest.SIGN_CONN_ESTAB_ATT_HIPRIO))), 0, 0, sum(luest.SIGN_CONN_ESTAB_COMP) / decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' ELSE cu.version END), 'FL16',sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO))))*100,2) AS RRC连接成功率

           , decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' WHEN cu.version='FL16A' THEN 'FL16' WHEN cu.version='TL16' THEN 'FL16' ELSE cu.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS +   luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO))) AS RRC连接请求次数

            ,sum(luest.SIGN_CONN_ESTAB_COMP) RRC连接成功次数

            ,round(decode(sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS),0,0,sum(lepsb.EPS_BEARER_SETUP_COMPLETIONS)/sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS))*100,2)  ERAB建立成功率

            ,sum(lepsb.EPS_BEARER_SETUP_COMPLETIONS)  ERAB建立成功次数

            ,sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS)   ERAB建立请求次数

            ,round(DECODE(decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' WHEN cu.version='FL16A' THEN 'FL16' WHEN cu.version='TL16' THEN 'FL16' ELSE cu.version END),'FL16', sum( lepsb.EPC_EPS_BEARER_REL_REQ_RNL  + lepsb.ERAB_REL_ENB_RNL_UEL + lepsb.ERAB_REL_ENB_RNL_EUGR + lepsb.ERAB_REL_ENB_TNL_TRU + lepsb.ERAB_REL_HO_PART + lepsb.ERAB_REL_EPC_PATH_SWITCH + lepsb.ERAB_REL_ENB_RNL_INA + lepsb.ERAB_REL_ENB_RNL_RED + lepsb.ERAB_REL_ENB_RNL_RRNA + lepsb.EPC_EPS_BEARER_REL_REQ_NORM + lepsb.EPC_EPS_BEARER_REL_REQ_DETACH ) ,sum( lepsb.EPC_EPS_BEARER_REL_REQ_NORM + lepsb.EPC_EPS_BEARER_REL_REQ_DETACH + lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.ERAB_REL_ENB_ACT_NON_GBR + lepsb.ENB_EPSBEAR_REL_REQ_RNL_REDIR + lepsb.ENB_EPS_BEARER_REL_REQ_NORM + lepsb.ENB_EPS_BEARER_REL_REQ_RNL + lepsb.ENB_EPS_BEARER_REL_REQ_TNL + lepsb.ENB_EPS_BEARER_REL_REQ_OTH + lepsb.EPC_EPS_BEAR_REL_REQ_R_QCI1 + lepsb.PRE_EMPT_GBR_BEARER + lepsb.PRE_EMPT_NON_GBR_BEARER )), 0, 0, decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' ELSE cu.version END),'FL16', SUM( lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.ERAB_REL_ENB_RNL_UEL + lepsb.ERAB_REL_ENB_RNL_EUGR + lepsb.ERAB_REL_ENB_TNL_TRU + lepsb.ERAB_REL_HO_PART + lepsb.ERAB_REL_EPC_PATH_SWITCH ) ,SUM( lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.EPC_EPS_BEAR_REL_REQ_R_QCI1 + lepsb.PRE_EMPT_GBR_BEARER + lepsb.PRE_EMPT_NON_GBR_BEARER + lepsb.ENB_EPS_BEARER_REL_REQ_RNL +    lepsb.ENB_EPS_BEARER_REL_REQ_TNL + lepsb.ENB_EPS_BEARER_REL_REQ_OTH ))/ decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' ELSE cu.version END),'FL16',sum( lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.ERAB_REL_ENB_RNL_UEL + lepsb.ERAB_REL_ENB_RNL_EUGR + lepsb.ERAB_REL_ENB_TNL_TRU + lepsb.ERAB_REL_HO_PART + lepsb.ERAB_REL_EPC_PATH_SWITCH + lepsb.ERAB_REL_ENB_RNL_INA + lepsb.ERAB_REL_ENB_RNL_RED + lepsb.ERAB_REL_ENB_RNL_RRNA + lepsb.EPC_EPS_BEARER_REL_REQ_NORM + lepsb.EPC_EPS_BEARER_REL_REQ_DETACH ) , sum( lepsb.EPC_EPS_BEARER_REL_REQ_NORM + lepsb.EPC_EPS_BEARER_REL_REQ_DETACH + lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.ERAB_REL_ENB_ACT_NON_GBR + lepsb.ENB_EPSBEAR_REL_REQ_RNL_REDIR + lepsb.ENB_EPS_BEARER_REL_REQ_NORM + lepsb.ENB_EPS_BEARER_REL_REQ_RNL + lepsb.ENB_EPS_BEARER_REL_REQ_TNL + lepsb.ENB_EPS_BEARER_REL_REQ_OTH + lepsb.EPC_EPS_BEAR_REL_REQ_R_QCI1 + lepsb.PRE_EMPT_GBR_BEARER + lepsb.PRE_EMPT_NON_GBR_BEARER )) )*100,2)  业务掉线率

            ,decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' WHEN cu.version='FL16A' THEN 'FL16' WHEN cu.version='TL16' THEN 'FL16' ELSE cu.version END),'FL16', SUM( lepsb.EPC_EPS_BEARER_REL_REQ_RNL  + lepsb.ERAB_REL_ENB_RNL_UEL + lepsb.ERAB_REL_ENB_RNL_EUGR + lepsb.ERAB_REL_ENB_TNL_TRU + lepsb.ERAB_REL_HO_PART + lepsb.ERAB_REL_EPC_PATH_SWITCH ) ,SUM( lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.EPC_EPS_BEAR_REL_REQ_R_QCI1 + lepsb.PRE_EMPT_GBR_BEARER + lepsb.PRE_EMPT_NON_GBR_BEARER + lepsb.ENB_EPS_BEARER_REL_REQ_RNL + lepsb.ENB_EPS_BEARER_REL_REQ_TNL +  lepsb.ENB_EPS_BEARER_REL_REQ_OTH)) 业务掉线次数

            ,decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' ELSE cu.version END),'FL16', sum( lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.ERAB_REL_ENB_RNL_UEL + lepsb.ERAB_REL_ENB_RNL_EUGR + lepsb.ERAB_REL_ENB_TNL_TRU + lepsb.ERAB_REL_HO_PART + lepsb.ERAB_REL_EPC_PATH_SWITCH + lepsb.ERAB_REL_ENB_RNL_INA + lepsb.ERAB_REL_ENB_RNL_RED + lepsb.ERAB_REL_ENB_RNL_RRNA + lepsb.EPC_EPS_BEARER_REL_REQ_NORM + lepsb.EPC_EPS_BEARER_REL_REQ_DETACH ) , sum( lepsb.EPC_EPS_BEARER_REL_REQ_NORM + lepsb.EPC_EPS_BEARER_REL_REQ_DETACH + lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.ERAB_REL_ENB_ACT_NON_GBR + lepsb.ENB_EPSBEAR_REL_REQ_RNL_REDIR + lepsb.ENB_EPS_BEARER_REL_REQ_NORM + lepsb.ENB_EPS_BEARER_REL_REQ_RNL + lepsb.ENB_EPS_BEARER_REL_REQ_TNL + lepsb.ENB_EPS_BEARER_REL_REQ_OTH +  lepsb.EPC_EPS_BEAR_REL_REQ_R_QCI1 + lepsb.PRE_EMPT_GBR_BEARER + lepsb.PRE_EMPT_NON_GBR_BEARER )) 业务释放次数

            ,decode(sum(lcellt.ACTIVE_TTI_UL),0,0, sum(lcellt.PDCP_SDU_VOL_UL)*8*1000/(sum(lcellt.ACTIVE_TTI_UL)*1024)) 空口上行业务平均速率,sum(lcellt.PDCP_SDU_VOL_UL)/1024 空口上行业务字节数

            ,decode(sum(lcellt.ACTIVE_TTI_DL),0,0,sum(lcellt.PDCP_SDU_VOL_DL)*8*1000/(sum(lcellt.ACTIVE_TTI_DL)*1024)) 空口下行业务平均速率
            ,sum(lcellt.PDCP_SDU_VOL_DL)/1024  空口下行业务字节数
            ,sum(lcellr.PRB_USED_UL_TOTAL)/sum(lcellr.PERIOD_DURATION*60*1000)/100上行PRB平均利用率
            ,sum(lcellr.PRB_USED_UL_TOTAL)/sum(lcellr.PERIOD_DURATION*60*1000)上行PRB占用平均数
            ,sum(lcellr.PRB_USED_DL_TOTAL)/sum(lcellr.PERIOD_DURATION*60*1000)/100 下行PRB平均利用率
            ,sum(lcellr.PRB_USED_DL_TOTAL)/sum(lcellr.PERIOD_DURATION*60*1000) 下行PRB占用平均数
            ,decode(sum(lianbho.ATT_INTRA_ENB_HO+lienbho.ATT_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_ATT-lho.HO_INTFREQ_ATT),0,0,sum(lianbho.SUCC_INTRA_ENB_HO+lienbho.SUCC_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_SUCC-lho.HO_INTFREQ_SUCC)/sum(lianbho.ATT_INTRA_ENB_HO+lienbho.ATT_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_ATT-lho.HO_INTFREQ_ATT)) 同频切换成功率
            ,sum(lisho.CSFB_REDIR_CR_ATT+lisho.CSFB_REDIR_CR_CMODE_ATT+lisho.CSFB_REDIR_CR_EMERGENCY_ATT+ nvl(lisho.CSFB_PSHO_UTRAN_ATT,0)) CSFB次数
            --sum(lisho.CSFB_REDIR_CR_ATT)   CSFB次数
            ,avg(lcelld.RRC_CONN_UE_AVG) 平均用户数
            ,max(lcelld.RRC_CONN_UE_MAX) 最大用户数
            ,round(decode(decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' WHEN cu.version='FL16A' THEN 'FL16' WHEN cu.version='TL16' THEN 'FL16' ELSE cu.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS +   luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO))),0,0,decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' ELSE cu.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_FAIL_PUCCH),sum(luest.SIGN_CONN_ESTAB_FAIL_RRMRAC))/decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' WHEN cu.version='FL16A' THEN 'FL16' WHEN cu.version='TL16' THEN 'FL16' ELSE cu.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS +   luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO))))*100,2)  RRC拥塞率

            ,decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' ELSE cu.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_FAIL_PUCCH),sum(luest.SIGN_CONN_ESTAB_FAIL_RRMRAC)) RRC拥塞次数
            ,round(decode(decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' ELSE cu.version END),'FL16',SUM(lepsb.ERAB_INI_SETUP_FAIL_TNL_TRU + lepsb.ERAB_ADD_SETUP_FAIL_TNL_TRU + lepsb.ERAB_INI_SETUP_FAIL_RNL_RRNA + lepsb.ERAB_ADD_SETUP_FAIL_RNL_RRNA),sum(lepsb.EPS_BEARER_SETUP_FAIL_RESOUR)),0,0,decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' ELSE cu.version END),'FL16',SUM(lepsb.ERAB_INI_SETUP_FAIL_TNL_TRU + lepsb.ERAB_ADD_SETUP_FAIL_TNL_TRU + lepsb.ERAB_INI_SETUP_FAIL_RNL_RRNA + lepsb.ERAB_ADD_SETUP_FAIL_RNL_RRNA),sum(lepsb.EPS_BEARER_SETUP_FAIL_RESOUR))/sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS))*100,2) ERAB拥塞率

            ,decode((CASE WHEN cu.version='FL16' THEN 'FL16' WHEN cu.version='FLF16' THEN 'FL16' ELSE cu.version END),'FL16',SUM(lepsb.ERAB_INI_SETUP_FAIL_TNL_TRU + lepsb.ERAB_ADD_SETUP_FAIL_TNL_TRU + lepsb.ERAB_INI_SETUP_FAIL_RNL_RRNA + lepsb.ERAB_ADD_SETUP_FAIL_RNL_RRNA),sum(lepsb.EPS_BEARER_SETUP_FAIL_RESOUR)) ERAB拥塞次数

            ,round(decode(sum(lcelld.UL_UE_DATA_BUFF_AVG),0,0,sum(lcellt.PDCP_SDU_VOL_UL)/1024/avg(lcelld.UL_UE_DATA_BUFF_AVG)),2) 用户平均上行吞吐率
            ,round(decode(sum(lcelld.DL_UE_DATA_BUFF_AVG),0,0,sum(lcellt.PDCP_SDU_VOL_DL)/1024/avg(lcelld.DL_UE_DATA_BUFF_AVG)),2) 用户平均下行吞吐率

            ,decode(sum((lpqul.RSSI_PUSCH_LEVEL_01)+(lpqul.RSSI_PUSCH_LEVEL_02)+
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
(lpqul.SINR_PUSCH_LEVEL_20)+(lpqul.SINR_PUSCH_LEVEL_21)+(lpqul.SINR_PUSCH_LEVEL_22)),2)) AS 平均每PRB干扰噪声功率

            ,decode(sum(lpqdl.UE_REP_CQI_LEVEL_00+lpqdl.UE_REP_CQI_LEVEL_01+lpqdl.UE_REP_CQI_LEVEL_02+lpqdl.UE_REP_CQI_LEVEL_03+lpqdl.UE_REP_CQI_LEVEL_04+lpqdl.UE_REP_CQI_LEVEL_05+lpqdl.UE_REP_CQI_LEVEL_06+lpqdl.UE_REP_CQI_LEVEL_07+lpqdl.UE_REP_CQI_LEVEL_08+lpqdl.UE_REP_CQI_LEVEL_09+lpqdl.UE_REP_CQI_LEVEL_10+lpqdl.UE_REP_CQI_LEVEL_11+lpqdl.UE_REP_CQI_LEVEL_12+lpqdl.UE_REP_CQI_LEVEL_13+lpqdl.UE_REP_CQI_LEVEL_14+lpqdl.UE_REP_CQI_LEVEL_15),0,0,round(sum(lpqdl.UE_REP_CQI_LEVEL_00+lpqdl.UE_REP_CQI_LEVEL_01+lpqdl.UE_REP_CQI_LEVEL_02+lpqdl.UE_REP_CQI_LEVEL_03+lpqdl.UE_REP_CQI_LEVEL_04+lpqdl.UE_REP_CQI_LEVEL_05+lpqdl.UE_REP_CQI_LEVEL_06)/sum(lpqdl.UE_REP_CQI_LEVEL_00+lpqdl.UE_REP_CQI_LEVEL_01+lpqdl.UE_REP_CQI_LEVEL_02+lpqdl.UE_REP_CQI_LEVEL_03+lpqdl.UE_REP_CQI_LEVEL_04+lpqdl.UE_REP_CQI_LEVEL_05+lpqdl.UE_REP_CQI_LEVEL_06+lpqdl.UE_REP_CQI_LEVEL_07+lpqdl.UE_REP_CQI_LEVEL_08+lpqdl.UE_REP_CQI_LEVEL_09+lpqdl.UE_REP_CQI_LEVEL_10+lpqdl.UE_REP_CQI_LEVEL_11+lpqdl.UE_REP_CQI_LEVEL_12+lpqdl.UE_REP_CQI_LEVEL_13+lpqdl.UE_REP_CQI_LEVEL_14+lpqdl.UE_REP_CQI_LEVEL_15),2))  CQI小于等于6的比例

            ,sum(lpqdl.UE_REP_CQI_LEVEL_00+lpqdl.UE_REP_CQI_LEVEL_01+lpqdl.UE_REP_CQI_LEVEL_02+lpqdl.UE_REP_CQI_LEVEL_03+lpqdl.UE_REP_CQI_LEVEL_04+lpqdl.UE_REP_CQI_LEVEL_05+lpqdl.UE_REP_CQI_LEVEL_06+lpqdl.UE_REP_CQI_LEVEL_07+lpqdl.UE_REP_CQI_LEVEL_08+lpqdl.UE_REP_CQI_LEVEL_09+lpqdl.UE_REP_CQI_LEVEL_10+lpqdl.UE_REP_CQI_LEVEL_11+lpqdl.UE_REP_CQI_LEVEL_12+lpqdl.UE_REP_CQI_LEVEL_13+lpqdl.UE_REP_CQI_LEVEL_14+lpqdl.UE_REP_CQI_LEVEL_15) as CQI总采样点



            ,min(lpqul.RSSI_PUCCH_MIN)  RSSI_PUCCH_MIN
            ,avg(lpqul.RSSI_PUCCH_AVG)  RSSI_PUCCH_AVG
            ,min(lpqul.RSSI_PUSCH_MIN)  RSSI_PUSCH_MIN
            ,avg(lpqul.RSSI_PUSCH_AVG)  RSSI_PUSCH_AVG
            ,sum(lianbho.ATT_INTRA_ENB_HO+lienbho.ATT_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_ATT-lho.HO_INTFREQ_ATT) 同频切换请求次数
            ,sum(lianbho.SUCC_INTRA_ENB_HO+lienbho.SUCC_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_SUCC-lho.HO_INTFREQ_SUCC) 同频切换成功次数
            ,sum(lho.HO_INTFREQ_SUCC) 异频切换请求次数
            ,sum(lho.HO_INTFREQ_SUCC) 异频切换成功次数
            ,round(decode(sum(lho.HO_INTFREQ_SUCC),0,0,sum(lho.HO_INTFREQ_SUCC)/sum(lho.HO_INTFREQ_SUCC))*100,2)  异频切换成功率
            ,sum(lisho.ISYS_HO_ATT) 异系统切换请求次数
            ,sum(lisho.ISYS_HO_SUCC) 异系统切换成功次数
            ,round(decode(sum(lisho.ISYS_HO_ATT),0,0,sum(lisho.ISYS_HO_SUCC)/sum(lisho.ISYS_HO_ATT))*100,2)  异系统切换成功率
            ,sum(lcellt.ACTIVE_TTI_UL)/1000 上行有数据的时长
            ,sum(lcellt.ACTIVE_TTI_DL)/1000  下行有数据的时长

        From
            NOKLTE_PS_LCELAV_LNCEL_HOUR lcelav,
            NOKLTE_PS_LUEST_LNCEL_HOUR luest,
            NOKLTE_PS_LEPSB_LNCEL_HOUR lepsb,
            NOKLTE_PS_LCELLT_LNCEL_HOUR lcellt, --8012
            NOKLTE_PS_LCELLR_LNCEL_HOUR lcellr,
            NOKLTE_PS_LIANBHO_LNCEL_HOUR lianbho,
            NOKLTE_PS_LISHO_LNCEL_HOUR lisho,
            NOKLTE_PS_LCELLD_LNCEL_HOUR lcelld,
            NOKLTE_PS_LIENBHO_LNCEL_HOUR lienbho,
            NOKLTE_PS_LHO_LNCEL_HOUR lho,
            NOKLTE_PS_LPQUL_LNCEL_HOUR lpqul,
            NOKLTE_PS_LPQDL_LNCEL_HOUR lpqdl,
            c_lte_custom cu
        where
               lcelav.LNCEL_ID= luest.LNCEL_ID(+)
              and luest.LNCEL_ID= lepsb.LNCEL_ID(+)
              and lepsb.LNCEL_ID= lcellt.LNCEL_ID(+)
              and lcellt.LNCEL_ID= lcellr.LNCEL_ID(+)
              and lcellr.LNCEL_ID= lianbho.LNCEL_ID(+)
              and lianbho.LNCEL_ID= lisho.LNCEL_ID(+)
              and lisho.LNCEL_ID= lcelld.LNCEL_ID(+)
              and lcelld.LNCEL_ID= lienbho.LNCEL_ID(+)
              and lcelld.LNCEL_ID= lienbho.LNCEL_ID(+)
              and lienbho.LNCEL_ID= lho.LNCEL_ID(+)
              and lho.LNCEL_ID= lpqul.LNCEL_ID(+)
              AND lpqul.LNCEL_ID= lpqdl.LNCEL_ID(+)
              and lpqdl.LNCEL_ID(+)= cu.lncel_objid AND
                 lcelav.PERIOD_START_TIME >= To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lcelav.PERIOD_START_TIME < To_Date(%s, 'yyyy-mm-dd-hh24') And
                 luest.PERIOD_START_TIME >= To_Date(%s, 'yyyy-mm-dd-hh24') And
                 luest.PERIOD_START_TIME < To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lepsb.PERIOD_START_TIME >= To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lepsb.PERIOD_START_TIME < To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lcellt.PERIOD_START_TIME >= To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lcellt.PERIOD_START_TIME < To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lcellr.PERIOD_START_TIME >= To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lcellr.PERIOD_START_TIME <To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lianbho.PERIOD_START_TIME >= To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lianbho.PERIOD_START_TIME < To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lisho.PERIOD_START_TIME >= To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lisho.PERIOD_START_TIME < To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lcelld.PERIOD_START_TIME >= To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lcelld.PERIOD_START_TIME < To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lienbho.PERIOD_START_TIME >= To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lienbho.PERIOD_START_TIME < To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lho.PERIOD_START_TIME >= To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lho.PERIOD_START_TIME < To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lpqul.PERIOD_START_TIME >= To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lpqul.PERIOD_START_TIME < To_Date(%s, 'yyyy-mm-dd-hh24') AND
                 lpqdl.PERIOD_START_TIME >= To_Date(%s, 'yyyy-mm-dd-hh24') And
                 lpqdl.PERIOD_START_TIME < To_Date(%s, 'yyyy-mm-dd-hh24')

              and lcelav.PERIOD_START_TIME=luest.PERIOD_START_TIME(+)
              and luest.PERIOD_START_TIME=lepsb.PERIOD_START_TIME(+)
              and lepsb.PERIOD_START_TIME=lcellt.PERIOD_START_TIME(+)
              and lcellt.PERIOD_START_TIME=lcellr.PERIOD_START_TIME(+)
              and lcellr.PERIOD_START_TIME=lianbho.PERIOD_START_TIME(+)
              and lianbho.PERIOD_START_TIME=lisho.PERIOD_START_TIME(+)
              and lisho.PERIOD_START_TIME=lcelld.PERIOD_START_TIME(+)
              and lcelld.PERIOD_START_TIME=lienbho.PERIOD_START_TIME(+)
              and lienbho.PERIOD_START_TIME=lho.PERIOD_START_TIME(+)
              and lho.PERIOD_START_TIME=lpqul.PERIOD_START_TIME(+)
              and lpqul.PERIOD_START_TIME=lpqdl.PERIOD_START_TIME(+)

        group BY
            cu.city,
            cu.netmodel,
            cu.lnbtsid,
            cu.lncel_lcr_id,
            cu.version,
            to_char(lcelav.period_start_time, 'yyyy-mm-dd')
            ,lcelav.LNCEL_ID
            ,cu.version

""" %(start_datetime,end_datetime,start_datetime,end_datetime,start_datetime,end_datetime,start_datetime,end_datetime,start_datetime,end_datetime,start_datetime,end_datetime,start_datetime,end_datetime,start_datetime,end_datetime,start_datetime,end_datetime,start_datetime,end_datetime,start_datetime,end_datetime,start_datetime,end_datetime )

#sql = sql.encode('utf-8')


conn = cx_Oracle.connect('omc/omc@10.100.162.10/oss')       #建立与oracle数据库的连接, 格式为  'user/password@IP/servicename'
cursor = conn.cursor ()																  #连接的游标
cursor.execute(sql)  # 执行的sql语句
rows = cursor.fetchall()        #一次取回所有记录,保存到rows中. rows为一个 列表, rows的元素还是一个列表,所以他的结构 就是 rows的每一个元素为一个列表(一行记录)

#cursor.description[8][0].decode("gbk")
col = []
for i in cursor.description:
    col.append(i[0])


df = pd.DataFrame(rows,columns = col)         #转化为DataFream  并添加 列表 col 为列名

filename = os.getcwd() +  '\\' + datetime.today().strftime("%Y%m%d") + '_LTE_TopN.xlsx' #定义文件名
writer = pd.ExcelWriter(filename)       #保存表格为excel

#rrcTopN = df[df[u'RRC连接成功率'] < 99]
rrcTopN = df.loc[(df[u'RRC连接成功率'] < 99 ) & (df[u'RRC连接请求次数'] >= 100)]
rrcTopN.to_excel(writer,'rrcTopN')      #保存表格为excel, 第二个参数为sheet名


ErabTopN = df.loc[(df[u'ERAB建立成功率'] < 99 ) & (df[u'ERAB建立请求次数'] >= 100)]
ErabTopN.to_excel(writer,'ErabTopN')      #保存表格为excel, 第二个参数为sheet名

RrcCongestion = df[df[u'RRC拥塞率'] > 0.5]
RrcCongestion.to_excel(writer,'RrcCongestion')      #保存表格为excel, 第二个参数为sheet名

EraCongestion = df[df[u'ERAB拥塞率'] > 0.5]
EraCongestion.to_excel(writer,'EraCongestion')      #保存表格为excel, 第二个参数为sheet名

yipinqiehuan = df.loc[(df[u'异频切换成功率'] < 95 ) & (df[u'异频切换成功率'] != 0 ) & (df[u'异频切换请求次数'] >= 100)]
yipinqiehuan.to_excel(writer,'yipinqiehuan')      #保存表格为excel, 第二个参数为sheet名

tongpinqiehuan = df.loc[(df[u'同频切换成功率'] < 95 ) & (df[u'异频切换成功率'] != 0 ) & (df[u'同频切换请求次数'] >= 100)]
tongpinqiehuan.to_excel(writer,'tongpinqiehuan')      #保存表格为excel, 第二个参数为sheet名

PrbInterference = df.loc[(df[u'平均每PRB干扰噪声功率'] >= -103 ) & (df[u'平均每PRB干扰噪声功率'] != 0)]
PrbInterference.to_excel(writer,'PrbInterference')      #保存表格为excel, 第二个参数为sheet名

CQI = df.loc[(df[u'CQI小于等于6的比例'] >= 20 ) & (df[u'CQI总采样点'] >= 1000)]
CQI.to_excel(writer,'CQI')      #保存表格为excel, 第二个参数为sheet名



writer.save()                           #保存表格为excel

cursor.close ()                    #关闭游标
conn.close ()						 #关闭数据库连接



mailreceiver = ['hppall@163.com','liuleib@mail.xahuilong.com','smnra@163.com']
mailTitle = '4G_TopN小区'
mailBody = 'LTE ' + start_datetime + ' - ' + end_datetime + 'Top 小区'
mailAttachments = [filename]

sendmail = SMTPProxy.SendMail(mailreceiver, mailTitle, mailBody, mailAttachments)    #邮件发送
sendmail.senmail()
