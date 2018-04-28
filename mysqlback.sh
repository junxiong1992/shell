#!/bin/bash

backupdir=/data/mysqlbackup
time=`date +%Y%m%d%H`

#docker exec jingdocker_mysql_1 sh -c 'exec mysqldump --defaults-extra-file=/etc/my.cnf -ujingfree -ppassw0rd jingsaas' | gzip > $backupdir/jingsaas-`date +%Y%m%d`.sql.gz
docker exec jingdocker_mysql_1 sh -c 'exec mysqldump jingsaas' | gzip > $backupdir/jingsaas-`date +%Y%m%d`.sql.gz

#mysql 容器外导入sql
#docker exec -i container mysql -u xxx -p123123 dbname < setup.sql

find $backupdir -name "jingsaas-*.sql.gz" -type f -mtime +15 -exec rm {} \; > /dev/null 2>&1
