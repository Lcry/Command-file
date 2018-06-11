#!/bin/bash 
# chkconfig: 2345 90 10 
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1 
export ORACLE_SID=orcl 
export PATH=$PATH:$ORACLE_HOME/bin 
ORCL_OWN="oracle" 
# if the executables do not exist -- display error 
if [ ! -f $ORACLE_HOME/bin/dbstart -o ! -d $ORACLE_HOME ] 
then 
   echo "Oracle startup: cannot start" 
   exit 1 
fi 
# depending on parameter -- start, stop, restart 
# of the instance and listener or usage display 
case "$1" in 
start) 
# Oracle listener and instance startup 
echo -n "Starting Oracle: " 
su - $ORCL_OWN -c "$ORACLE_HOME/bin/lsnrctl start" 
su - $ORCL_OWN -c "$ORACLE_HOME/bin/dbstart" 

#touch /var/lock/subsys/oradb 
#su - $ORCL_OWN -c "$ORACLE_HOME/bin/emctl start dbconsole" 

echo "OK" 
;; 
stop) 
# Oracle listener and instance shutdown 
echo -n "Shutdown Oracle: " 
su - $ORCL_OWN -c "$ORACLE_HOME/bin/lsnrctl stop" 
su - $ORCL_OWN -c "$ORACLE_HOME/bin/dbshut" 

#su - $ORCL_OWN -c "$ORACLE_HOME/bin/emctl stop dbconsole" 
#rm -f /var/lock/subsys/oradb 

echo "OK" 
;; 
reload|restart) 
$0 stop 
$1 start 
;; 
*) 
echo "Usage: 'basename $0' start|stop|restart|reload" 
exit 1 
esac 
exit 0 
