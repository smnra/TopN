
import socks
import socket

socks.set_default_proxy(socks.HTTP, "10.22.0.238", 3128)   #代理类型 地址 端口
socket.socket = socks.socksocket    # 用socks 代理 smtp模块

def getipaddress(hostname,port =25) :
    results = socket.getaddrinfo(hostname, port, 0, 0, socket.IPPROTO_TCP)
    hosts = []
    for resule in results :
        hosts.append(resule[4][0])
        print(resule[4][0])
    return hosts

if __name__ == '__main__':
    hosts = []
    hosts = getipaddress('smtp.163.com',25)