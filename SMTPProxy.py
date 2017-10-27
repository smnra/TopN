#coding: utf-8
import requests
import smtplibproxy as smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from email.header import Header



class SendMail:
    def __init__(self,receiver,title,mainText,attachments):                 #receiver参数是收件人, title是邮件标题,mainText是邮件正文,attachments 参数是附件路径列表


        self.sender = 'hppall@163.com'
        self.receiver = receiver
        self.subject = title
        self.smtpserver = 'smtp.163.com'
        self.username = 'hppall'
        self.password = '3615165'
        self.msg = MIMEMultipart()

        # 下面是文字部分，也就是纯文本
        self.puretext = MIMEText(mainText,'plain','utf-8')   #中文需参数‘utf-8'，单字节字符不需要
        self.msg.attach(self.puretext)

        for attachment in attachments :  # 循环添加附件
            self.attPart = MIMEApplication(open(attachment, 'rb').read())
            self.attPart.add_header('Content-Disposition', 'attachment', filename = attachment)
            self.msg.attach(self.attPart)


        '''
        # 首先是xlsx类型的附件
        self.xlsxpart = MIMEApplication(open(xlsxFileName, 'rb').read())
        self.xlsxpart.add_header('Content-Disposition', 'attachment', filename = xlsxFileName)
        self.msg.attach(self.xlsxpart)

        # jpg类型的附件
        self.jpgpart = MIMEApplication(open(jpgFileName, 'rb').read())
        self.jpgpart.add_header('Content-Disposition', 'attachment', filename=jpgFileName)
        self.msg.attach(self.jpgpart)
        '''


    def senmail(self):
        ##  下面开始真正的发送邮件了
        try:
            self.msg['Subject'] = Header(self.subject, 'utf-8')
            self.msg['From'] = 'SMnRa<hppall@163.com>'
            self.msg['To'] = self.receiver
            client = smtplib.SMTP()
            client.connect('smtp.163.com')
            client.login(self.username, self.password)
            client.sendmail(self.sender, self.receiver, self.msg.as_string())
            client.quit()
            print('邮件发送成功！')
        except smtplib.SMTPRecipientsRefused:
            print('Recipient refused')
        except smtplib.SMTPAuthenticationError:
            print('Auth error')
        except smtplib.SMTPSenderRefused:
            print('Sender refused')
        except smtplib.SMTPException as e:
            print(e)



if __name__ == '__main__' :
    sendmail = SendMail('smnra@163.com','Modul Test','proxy,text,xlsx,jpg',['20170922_LTE_TopN.xlsx','erab.jpg'])
    sendmail.senmail()