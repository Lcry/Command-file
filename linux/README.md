linux脚本说明：
脚本统一路径：
https://raw.githubusercontent.com/Lcry/Command-file/master/（此处填脚本名）<br>
例子：
https://raw.githubusercontent.com/Lcry/Command-file/master/mysqlbak.sh<br>执行：
```wget -N --no-check-certificate https://raw.githubusercontent.com/Lcry/Command-file/linux/master/mysqlbak.sh && bash mysqlbak.sh```<br><br>

## 1.脚本名称：oraclebak.sh<br>

按照表空间导出备份，脚本具体内容如下：<br>
oracle版本：11g<br>
软件安装地址：/home/u01/app/oracle/product/11.2.0/dbhome_1<br>
实例名：orcl<br>
数据库编码格式：american_america.zhs16gbk<br>
逻辑目录名：DPDATA1<br>
逻辑目录地址：/home/u01/app/oracle/oradata/bak<br>

## 2.脚本名称：mysqlbak.sh<br>

按照mysql全库导出备份，脚本具体内容如下：<br>
mysqle版本：5.6.35<br>
软件安装地址：/usr/local/mysql<br>
用户名：root<br>
密码：123465<br>
备份目录：/mysqlbak<br>

## 3.脚本名称：oradb.sh<br>

oracle11g自启动脚本：<br>
注：使用时将oradb.sh修改为oradb<br>
使用方法：<br>
1）在root 账户下修改/etc/oratab 文件：<br>
orcl:/u01/app/oracle/product/11.2.0/dbhome_1:N<br>
最后的N 改为Y;<br>
2）在oracle 账户下修改ORACLE 自带的启动与关闭脚本:<br>
vi $ORACLE_HOME/bin/dbstart<br>
找到ORACLE_HOME_LISTNER=$1 这一行 改为：ORACLE_HOME_LISTNER=$ORACLE_HOME<br>
vi $ORACLE_HOME/bin/dbshut<br>
找到ORACLE_HOME_LISTNER=$1 这一行 改为：ORACLE_HOME_LISTNER=$ORACLE_HOME<br>
3）设置开机自启动:<br>
vi /etc/init.d/oradb写入脚本内容即可<br>
4）验证<br>
chkconfig --add oradb   # 添加服务<br>
chkconfig oradb  on     # 启动自动运动<br>
chkconfig --list oradb   # 查看是否成功<br>
5）重启系统验证<br>
执行reboot<br>

## 4.脚本名称：monitor_ch.sh<br>

(中文版)监控服务器互联网连通性、操作系统类型、内存、CPU、硬盘等情况<br>
使用方法：下载脚本到服务器，授权chmod 755 -R monitor_ch.sh<br>
直接使用方法：./monitor_ch.sh
若需要安装版本：执行./monitor_ch.sh -i,安装之后可以再任何目录下执行monitor<br>
若报错 mpstat: command not found,请执行yum install -y sysstat<br>

## 5.脚本名称：monitor_en.sh<br>

(英文版)监控服务器互联网连通性、操作系统类型、内存、CPU、硬盘等情况<br>
使用方法：下载脚本到服务器，授权chmod 755 -R monitor_en.sh<br>
直接使用方法：./monitor_en.sh
若需要安装版本：执行./monitor_en.sh -i,安装之后可以再任何目录下执行monitor<br>
若报错 mpstat: command not found,请执行yum install -y sysstat<br>

## 6.脚本名称：unixbench.sh<br>

自动安装UnixBench一键跑分<br>

## 7.脚本名称：centos7init.sh<br>

CentOS7生产环境优化脚本：网络配置、主机名配置、yum源更新、时钟同步、内核参数配置、语言时区、关闭SELINUX、防火墙、SSH 参数配置，可参考脚本自行新增或删除不需要的信息，参考互联网并亲测<br>

使用方法：下载脚本到服务器，root用户执行sh centos7init.sh 你要设置的主机名<br>

一键命令：

`curl -O https://raw.githubusercontent.com/Lcry/Command-file/linux/master/centos7init.sh && sh centos7init.sh lcryCentos7`

或者

`wget -N --no-check-certificate https://raw.githubusercontent.com/Lcry/Command-file/linux//master/centos7init.sh && sh centos7init.sh lcryCentos7 `
