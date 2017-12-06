
import arrow

now = arrow.now()
#获取当前时间  <Arrow [2017-12-06T11:42:32.079055+08:00]>
print(now)

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




