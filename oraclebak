#2018.06.09
#oracle自动备份脚本
#/bin/sh
export ORACLE_SID=orcl
export ORACLE_HOME=/home/u01/app/oracle/product/11.2.0/dbhome_1
export NLS_LANG=american_america.zhs16gbk
export DATA_DIR=/home/u01/app/oracle/oradata/bak
#获取系统时间，精确到秒
now=`date +%Y%m%d%H%M%S`
#获取打包时间精确到小时
ziptime=`date +"%Y%m%d%H"`
#获取删除时间，当前时间的前2周
deletetime=`date -d "2 week ago" +"%Y%m%d%H"`
#删除2周前的zip包
rm -rf /home/u01/app/oracle/oradata/bak/db_$deletetime.zip
echo start exp $dmpfile ...
/home/u01/app/oracle/product/11.2.0/dbhome_1/bin/expdp dbservice/123456 DUMPFILE=dbservice$now.dmp DIRECTORY=DPDATA1 schemas=dbservice
/home/u01/app/oracle/product/11.2.0/dbhome_1/bin/expdp dbcount/123456 DUMPFILE=dbcount$now.dmp DIRECTORY=DPDATA1 schemas=dbcount
/home/u01/app/oracle/product/11.2.0/dbhome_1/bin/expdp dbcenter/123456 DUMPFILE=dbcenter$now.dmp DIRECTORY=DPDATA1 schemas=dbcenter
/home/u01/app/oracle/product/11.2.0/dbhome_1/bin/expdp dboperation/123456 DUMPFILE=dboperation$now.dmp DIRECTORY=DPDATA1 schemas=dboperation
/home/u01/app/oracle/product/11.2.0/dbhome_1/bin/expdp dbcms/123456 DUMPFILE=dbcms$now.dmp DIRECTORY=DPDATA1 schemas=dbcms
/home/u01/app/oracle/product/11.2.0/dbhome_1/bin/expdp db_resource/123456 DUMPFILE=db_resource$now.dmp DIRECTORY=DPDATA1 schemas=db_resource
/home/u01/app/oracle/product/11.2.0/dbhome_1/bin/expdp dbcas/123456 DUMPFILE=dbcas$now.dmp DIRECTORY=DPDATA1 schemas=dbcas

#压缩打包
zip -r /home/u01/app/oracle/oradata/bak/db_$ziptime.zip  /home/u01/app/oracle/oradata/bak/*.dmp
rm -rf /home/u01/app/oracle/oradata/bak/*.dmp
