@echo off

color F0

rem 设置窗口背景色为白色，文字颜色为黑色

title 批处理扫网段(By TaoGe)

rem 设置窗口标题

echo.

echo 输入你要扫描的IP段，直接按回车则为192.168.16：

set /p IpDuan=

rem 将用户输入赋值给IpDuan变量

if "%IpDuan%"=="" (set IpDuan=192.168.16)

rem 判断IpDuan变量是否赋值，如果为空，则赋值为192.168.16

echo 输入你要扫描的IP起始位，直接按回车则为1：

set /p QiShi=

rem 将用户输入赋值给QiShi变量

if "%QiShi%"=="" (set QiShi=1)

rem 判断QiShi变量是否赋值，如果为空，则赋值为1

echo 输入你要扫描的IP结束位，直接按回车则为255：

set /p JieShu=

rem 将用户输入赋值给JieShu变量

if "%JieShu%"=="" (set JieShu=255)

rem 判断JieShu变量是否赋值，如果为空，则赋值为255

echo 起始IP：%IpDuan%.%QiShi%  

rem 显示起始IP

echo 结束IP：%IpDuan%.%JieShu%  

rem 显示结束IP

echo ======================================================= >>Ping-%IpDuan%.txt

rem 记录分割线

echo 开始时间：%date%%time% >>Ping-%IpDuan%.txt

rem 记录开始时间

echo 起始IP：%IpDuan%.%QiShi% >>Ping-%IpDuan%.txt  

rem 记录起始IP

echo 结束IP：%IpDuan%.%JieShu% >>Ping-%IpDuan%.txt 

rem 记录结束IP

echo 正在扫描，请等待...

echo 提前结束请直接关闭窗口

@for /l %%n in (%QiShi%,1,%JieShu%) do @ping -w 600 -n 1 %IpDuan%.%%n|find  /i "ttl" >>Ping-%IpDuan%.txt

rem 开始执行

echo 结束时间：%date% %time%  >>Ping-%IpDuan%.txt

rem 记录结束时间

echo ======================================================= >>Ping-%IpDuan%.txt

rem 记录分割线

echo 扫描完毕,按任意键退出...&pause>nul
