# coding = utf-8
# -*- coding: utf-8 -*-
import os
os.environ['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.UTF8'
#os.environ['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.ZHS16GBK'

'''
os.path.sys.path.append('D:\\instantclient_12_1')
os.environ['ORACLE_HOME'] = 'D:\\instantclient_12_1'
os.environ['TNS_ADMIN'] = 'D:\\instantclient_12_1'
'''


os.path.sys.path.append('F:\\SMnRa\\smnra\\python\\3\\instantclient_12_1')
os.environ['ORACLE_HOME'] = 'F:\\SMnRa\\smnra\\python\\3\\instantclient_12_1'
os.environ['TNS_ADMIN'] = 'F:\\SMnRa\\smnra\\python\\3\\instantclient_12_1'


import cx_Oracle        #导入oracle 支持模块
import os                   #导入系统 模块
import datetime         #导入 时间日期 模块
import pandas as pd
import getfiles
import SMTPProxy


start_datetime = datetime.date.today().strftime("%Y%m%d") + '00' # 今天的日期 '2017102600'
end_datetime = datetime.date.today().strftime("%Y%m%d") + '13' # 今天的日期 '2017102613'



sqlFiles = getfiles.getGzipList(os.getcwd()+ '\\wcdma_sql','.SQL')

sqls = []    #存储sql脚本的列表
sheetNames = []    #存放sheet名
for i,sqlFile in enumerate(sqlFiles) :
    sheetNames.append(sqlFile.decode('utf-8').replace(os.getcwd() + '\\wcdma_sql\\','').split('.')[0])    #将文件名作为sheet名存入
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
filename = os.getcwd() +  '\\topnfile\\' + datetime.date.today().strftime("%Y%m%d") + '_WCDMA_TopN.xlsx' #定义文件名
writer = pd.ExcelWriter(filename)       #保存表格为excel

for i,sql in enumerate(sqls) :
    print(sheetNames[i],i)
    cursor.execute(proessSQL(sql))  # 执行的sql语句
    rows = cursor.fetchall()        #一次取回所有记录,保存到rows中. rows为一个 列表, rows的元素还是一个列表,所以他的结构 就是 rows的每一个元素为一个列表(一行记录)

    col = []
    for k in cursor.description:
        col.append(k[0])

    df = pd.DataFrame(rows,columns = col)         #转化为DataFream  并添加 列表 col 为列名
    tables.append(df)
    #print(str(tables[i]))


    #rrcTopN = df.loc[(df[u'RRC连接成功率'] < 99 ) & (df[u'RRC连接请求次数'] >= 100)]
    #print(sheetNames[i],i)
    df.to_excel(writer,sheetNames[i])      #保存表格为excel, 第二个参数(sql文件的名称)为sheet名
    writer.save()                           #保存表格为excel
cursor.close ()                    #关闭游标
conn.close ()						 #关闭数据库连接


mailreceiver = ['fuhuan118@163.com', 'zbg.baogang@163.com', 'tovi_jt@163.com', 'slsooner@126.com', '18628498771@163.com','donghuibi@163.com', 'hzq_83@126.com', 'twoxu@163.com', 'freeleexjp@163.com', 'fengchun@vip.163.com', 'gavinlove5296@163.com', 'yingrui.zhao@huanuo-nokia.com', 'zhai1008@163.com', 'zhuxiaofeng2008@163.com', 'yilong-1000@163.com', 'wangzj_852@163.com', '350282037@qq.com', 'leejianglei@163.com', 'waenmi@foxmail.com', 'liweibin1226@163.com']
mailcc = ['liujianxun0801@163.com', 'yonglin.qiang@nokia-sbell.com', 'ke.hu@nokia-sbell.com', 'smnra@163.com', 'li.17.zhang@nokia-sbell.com', 'guangcong.wen@nokia-sbell.com', 'jing.2.zhang@huanuo-nsb.com']
mailTitle = '3G_Top5小区_AM'
mailBody = 'WCDMA ' + start_datetime + ' - ' + end_datetime + ' Top5 小区'
mailAttachments = [filename]

sendmail = SMTPProxy.SendMail(mailreceiver, mailcc, mailTitle, mailBody, mailAttachments)    #邮件发送
sendmail.senmail()
