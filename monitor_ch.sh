#! /bin/bash 
# by：Lcry site:www.51it.wang

# 清屏
clear

unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage

while getopts iv name
do
        case $name in
          i)iopt=1;;
          v)vopt=1;;
          *)echo "无效的命令!请重新输入";;
        esac
done

if [[ ! -z $iopt ]]
then
{
wd=$(pwd)
basename "$(test -L "$0" && readlink "$0" || echo "$0")" > /tmp/scriptname
scriptname=$(echo -e -n $wd/ && cat /tmp/scriptname)
su -c "cp $scriptname /usr/bin/monitor" root && echo "祝贺你！脚本安装，现在可以执行 [monitor]命令监控服务器了" || echo "安装失败！"
}
fi

if [[ ! -z $vopt ]]
then
{
echo -e "本监控脚本版本0.1\n修改人：lcry \n在Apache 2许可下发布"
}
fi

if [[ $# -eq 0 ]]
then
{


# 定义变量TECSERT
tecreset=$(tput sgr0)
datetime=$(date "+%Y-%m-%d %H:%M:%S")
echo -e "\033[36m "-----------------"$datetime"-------------------" \033[0m"
# 检查是否连接到互联网
ping -c 1 www.baidu.com &> /dev/null && echo -e '\E[32m'"互联网连通性: $tecreset 已连接" || echo -e '\E[32m'"Internet: $tecreset 未连接"

# 检查系统类型
os=$(uname -o)
echo -e '\E[32m'"操作系统类型 :" $tecreset $os

# 检查系统发布版本和名称
cat /etc/redhat-release | grep 'NAME\|VERSION' | grep -v 'VERSION_ID' | grep -v 'PRETTY_NAME' > /tmp/osrelease
echo -n -e '\E[32m'"操作系统名称 :" $tecreset  && cat /tmp/osrelease | grep -v "VERSION" | cut -f2 -d\"
echo -n -e '\E[32m'"操作系统版本 :" $tecreset && cat /tmp/osrelease | grep -v "NAME" | cut -f2 -d\"

# 检查架构
architecture=$(uname -m)
echo -e '\E[32m'"架构 :" $tecreset $architecture

# 检查内核版本 
kernelrelease=$(uname -r)
echo -e '\E[32m'"内核版本 :" $tecreset $kernelrelease

# 检查主机名
echo -e '\E[32m'"主机名 :" $tecreset $HOSTNAME

# 检查内网IP
internalip=$(hostname -I)
echo -e '\E[32m'"内部IP :" $tecreset $internalip

# 检查外网IP
externalip=$(curl -s ipecho.net/plain;echo)
echo -e '\E[32m'"外部IP : $tecreset "$externalip

# 检查DNS
nameservers=$(cat /etc/resolv.conf | sed '1 d' | awk '{print $2}')
echo -e '\E[32m'"域名服务器 :" $tecreset $nameservers 

# 检查已登录用户
who>/tmp/who
echo -e '\E[32m'"已登录用户 :" $tecreset && cat /tmp/who 

# 检查内存和交换分区
free -h | grep -v + > /tmp/ramcache
echo -e '\E[32m'"内存使用情况 :" $tecreset
cat /tmp/ramcache | grep -v "Swap"
echo -e '\E[32m'"交换分区使用率 :" $tecreset
cat /tmp/ramcache | grep -v "Mem"

# 检查磁盘使用情况
df -h| grep 'Filesystem\|/dev/sda*' > /tmp/diskusage
echo -e '\E[32m'"磁盘使用率 :" $tecreset 
cat /tmp/diskusage

# 检查内存和CPU使用率
IDLE=$(mpstat | tail -1 | awk '{print $NF}' | awk -F% '{print $1}')
CPUU=$(top -n1 | awk '/Cpu/{print $2}')"%"
USED=$(free -m | sed -n '2p' | awk '{print $3"M"}')
TOTAL=$(free -m | grep "Mem: " |awk '{print $2"M"}')
USEDRAT=$(free -m | sed -n '2p' | awk '{print $3/$2*100"%"}')
echo -e '\E[32m'"内存总共大小:" "\033[37m $TOTAL \033[0m"
echo -e '\E[32m'"已使用内存大小：" "\033[37m $USED \033[0m"
echo -e '\E[32m'"内存使用比率: " "\033[37m $USEDRAT \033[0m"
echo -e '\E[32m'"CPU使用比率：" "\033[37m $CPUU \033[0m"


# 检查平均负载
#loadaverage=$(top -n 1 -b | grep "load average:" | awk '{print $10 $11 $12}')
loadaverage=$(uptime)
echo -e '\E[32m'"平均负载 :" $tecreset $loadaverage

# 检查系统开机时间
tecuptime=$(uptime | awk '{print $3,$4}' | cut -f1 -d,)
echo -e '\E[32m'"系统开机时间/(时:分) :" $tecreset $tecuptime

# 释放变量
unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage

# 删除临时文件
rm /tmp/osrelease /tmp/who /tmp/ramcache /tmp/diskusage
}
fi
shift $(($OPTIND -1))
echo -e "\033[36m "-----------------"$datetime"-------------------" \033[0m"
