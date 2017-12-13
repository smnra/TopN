
import arrow

now = arrow.now()
#获取当前时间  <Arrow [2017-12-06T11:42:32.079055+08:00]>
#print(now)

'''
now.year
#年 2017
now.month
#月份 12
now.day
#日期 6
now.hour
#小时 11
now.minute
#分钟 42
now.second
#秒 32
now.week
#今年的第几周  49



# 日期运算

now.replace(days=+1)
#天加减,明天的时间 <Arrow [2017-12-07T11:42:32.079055+08:00]>

now.replace(days=+1, hours=-1)
# 明天 的上一个小时 时间 <Arrow [2017-12-07T10:42:32.079055+08:00]>

now.replace(weeks=+1)
# 下一周的时间 <Arrow [2017-12-13T11:42:32.079055+08:00]>

now.replace(months=+1)
# 下一个月的时间 <Arrow [2018-01-06T11:42:32.079055+08:00]>




#根据某个限定条件获取最大时间与最小时间

now.floor('year')
#今年的最小时间 <Arrow [2017-01-01T00:00:00+08:00]>

now.floor('month')
#这个月的最小时间 <Arrow [2017-12-01T00:00:00+08:00]>

now.floor('week')
#这周的最小时间  <Arrow [2017-12-04T00:00:00+08:00]>

now.floor('day')
#今天的最小时间  <Arrow [2017-12-06T00:00:00+08:00]>




now.ceil('year')
#今年的最大时间 <Arrow [2017-12-31T23:59:59.999999+08:00]>

now.ceil('month')
#这个月的最大时间 <Arrow [2017-12-31T23:59:59.999999+08:00]>

now.ceil('week')
#这周的最大时间  <Arrow [2017-12-10T23:59:59.999999+08:00]>

now.ceil('day')
#今天的最大时间  <Arrow [2017-12-06T23:59:59.999999+08:00]>







#常用日期

now.replace(weeks=-1).floor('week')
#上周周一的时间  <Arrow [2017-11-27T00:00:00+08:00]>

now.floor('week')
#这周周一的时间  <Arrow [2017-12-04T00:00:00+08:00]>

now.replace(weeks=+1).floor('week')
#下周周一的时间  <Arrow [2017-12-11T00:00:00+08:00]>


now.replace(months=-1).floor('month')
# 上个月 1号的时间  <Arrow [2017-11-01T00:00:00+08:00]>

now.floor('month')
#这个月1号的时间  <Arrow [2017-12-01T00:00:00+08:00]>

now.replace(months=+1).floor('month')
# 下个月 1号的时间  <Arrow [2018-01-01T00:00:00+08:00]>

now.replace(months=-1).floor('month').replace(weeks=+1).floor('week')
# 上个月的第一个周一的时间

now.floor('month').replace(weeks=+1).floor('week')
# 本月的第一个周一的时间 <Arrow [2017-12-04T00:00:00+08:00]>




#时间格式化输出
now.format('YYYYMMDDHH')
#输出为字符串格式的 时间  '2017120611'




now.replace(months=-1).floor('month').format('YYYYMMDDHH')
# 输出字符串 上个月1号的日期  '2017110100'

now.floor('month').replace(weeks=+1).floor('week').format('YYYYMMDDHH')
# 输出字符串 本月的第一个周一的日期  '2017120400'

now.floor('month').format('YYYYMMDDHH')
# 输出字符串 本月的第一天的日期  '2017120100'

'''

def getDateRange():
    '''
    #获取参数(默认为当天)所在月份的第一个完整周 周一的日期
    '''
    now = arrow.now()                                                        #当前时间
    rangeDate={}                                                             #定义返回值  字典
    rangeDate['today'] = arrow.now().format('YYYYMMDDHH')                 #今日的日期

    lastMonth_1st_day = now.floor('month').replace(months = -1)             #上个月1号的日期
    thisMonth_1st_day = now.floor('month')                                  #这个月1号的日期
    nextMonth_1st_day = now.floor('month').replace(months = +1)             #下个月1号的日期
    lastWeek_Monday = now.replace(weeks = -1).floor('week')             #上一周周一的日期
    thisWeek_Monday = now.floor('week')                                 #这一周周一的日期
    if thisMonth_1st_day.isoweekday() == 1 :                                #如果这个月的1号是周一,
        thisMonth_1st_Monday = now.floor('month')                           #则这个月的第一个完整周 的 周一的日期 就是当月的1号的日期
    else :
        thisMonth_1st_Monday = now.floor('month').replace(weeks = +1).floor('week')      #否则这个月的第一个完整周 的 周一的日期 就是当月1号所在的下一周的周一的日期

    if thisWeek_Monday - thisMonth_1st_Monday == thisWeek_Monday - thisWeek_Monday :       #如果 这一周周一的日期  减去这个月的第一个完整周 周一的日期 如果结果等于0
        rangeDate['startDate'] = lastMonth_1st_day.format('YYYYMMDDHH')               #开始时间就是上个月1号
        rangeDate['endDate'] = thisMonth_1st_Monday.format('YYYYMMDDHH')               #结束时间就是这个月的第一个完整周 周一的日期
    else :
        rangeDate['startDate'] = thisMonth_1st_day.format('YYYYMMDDHH')               #开始时间就是这个月1号
        rangeDate['endDate'] = nextMonth_1st_day.format('YYYYMMDDHH')                 #结束时间就是这个月的第一个完整周 周一的日期

    return rangeDate

if __name__ == '__main__' :
    print(getDateRange())