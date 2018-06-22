#! /bin/bash

###  dump DB prod to beta  ###

read -p "Enter db name ,eg :db_mytoken >"   db
read -p "Enter prod db passwd ,eg :pass1 >"  pass1
read -p "Enter beta db passwd,eg :pass2 >"  pass2

BACKUPDIR=/data/logs/mysqlbackup
DATABASE=$db

PROD_HOST=ro-mytoken-db-prod
PRODUSER=mytoke
PRODPASS=$pass1

BETA_HOST=beta.cqppqk8ghbfd
BETAUSER=mytoken_ad
BETAPASS=$pass2



echo "START---- `date +%Y-%m-%d,%H:%m:%s`"

mkdir -p $BACKUPDIR

##backup from prod
mysqldump -h $PROD_HOST -u $PRODUSER -p$PRODPASS $DATABASE |gzip > $BACKUPDIR/$DATABASE-`date +%Y%m%d`.sql.gz

###  --ignore-table=database.table1 --ignore-table=database.table2
#mysqldump -h $PROD_HOST -u $PRODUSER -p$PRODPASS $DATABASE --ignore-table=$DATABASE.table1 |gzip > $BACKUPDIR/db_mytoken-`date +%Y%m%d`.sql.gz

echo "CONTINUE----`date +%Y-%m-%d,%H:%m:%s` --- PROD DB backup is completed! restore BETA DB"

##restore  beta
gunzip < $BACKUPDIR/$DATABASE-`date +%Y%m%d`.sql.gz | mysql -h $BETA_HOST -u $BETAUSER -p$BETAPASS $DATABASE


echo "END---- `date +%Y-%m-%d,%H:%m:%s`"

# Remove old files 30 days
# find $BACKUPDIR -name "db_mytoken-*.sql.gz" -type f -mtime +30 -exec rm {} \; > /dev/null 2>&1


