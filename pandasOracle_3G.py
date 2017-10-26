# coding = utf-8
# -*- coding: utf-8 -*-
import os
os.environ['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.UTF8'
#os.environ['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.ZHS16GBK'
os.path.sys.path.append('D:\\instantclient_12_1')
os.environ['ORACLE_HOME'] = 'D:\\instantclient_12_1'
os.environ['TNS_ADMIN'] = 'D:\\instantclient_12_1'


'''
os.path.sys.path.append('F:\\SMnRa\\smnra\\python\\3\\instantclient_12_1')
os.environ['ORACLE_HOME'] = 'F:\\SMnRa\\smnra\\python\\3\\instantclient_12_1'
os.environ['TNS_ADMIN'] = 'F:\\SMnRa\\smnra\\python\\3\\instantclient_12_1'
'''

import cx_Oracle        #导入oracle 支持模块
import os                   #导入系统 模块
from datetime import datetime         #导入 时间日期 模块
import pandas as pd
import getfiles
import SMTPProxy


start_datetime = '2017102500'
end_datetime = '2017102600'



sqlFiles = getfiles.getGzipList(os.getcwd()+ '\sql','.SQL')

sqls = []    #存储sql脚本的列表
sheetNames = []    #存放sheet名
for i,sqlFile in enumerate(sqlFiles) :
    sheetNames.append(sqlFile.decode('utf-8').replace(os.getcwd() + '\\sql\\','').split('.')[0])    #将文件名作为sheet名存入
    tmp = open(sqlFile.decode('utf-8'),mode = 'r',encoding='cp936')
    try:
        sqls.append(tmp.read())
    except Exception as e :
        print(str(e))
    finally:
        tmp.close()




print('_________________________________________________')

def proessSQL(sql) :
    newsql = sql.replace('&start_dateTime',start_datetime)
    newsql = newsql.replace('&end_datetime',end_datetime)
    #newsql = newsql.decode('utf-8')
    return newsql




conn = cx_Oracle.connect('omc/omc@192.168.4.10/oss')       #建立与oracle数据库的连接, 格式为  'user/password@IP/servicename'
cursor = conn.cursor ()																  #连接的游标

tables = []   #保存DataFream的数组
filename = os.getcwd() +  '\\' + datetime.today().strftime("%Y%m%d") + '_WCDMA_TopN.xlsx' #定义文件名
writer = pd.ExcelWriter(filename)       #保存表格为excel

for i,sql in enumerate(sqls) :
    cursor.execute(proessSQL(sql))  # 执行的sql语句
    rows = cursor.fetchall()        #一次取回所有记录,保存到rows中. rows为一个 列表, rows的元素还是一个列表,所以他的结构 就是 rows的每一个元素为一个列表(一行记录)

    col = []
    for k in cursor.description:
        col.append(k[0])

    df = pd.DataFrame(rows,columns = col)         #转化为DataFream  并添加 列表 col 为列名
    tables.append(df)
    print(str(tables[i]))


    #rrcTopN = df.loc[(df[u'RRC连接成功率'] < 99 ) & (df[u'RRC连接请求次数'] >= 100)]
    print(sheetNames[i],i)
    df.to_excel(writer,sheetNames[i])      #保存表格为excel, 第二个参数(sql文件的名称)为sheet名
    writer.save()                           #保存表格为excel
cursor.close ()                    #关闭游标
conn.close ()						 #关闭数据库连接



'''
mailreceiver = 'smnra@163.com'
mailTitle = '3G_TopN小区'
mailBody = 'WCDMA ' + start_datetime + ' - ' + end_datetime + 'Top 小区'
mailAttachments = [filename]

sendmail = SMTPProxy.SendMail(mailreceiver, mailTitle, mailBody, mailAttachments)    #邮件发送
sendmail.senmail()
'''