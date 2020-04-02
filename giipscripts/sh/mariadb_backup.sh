#!/bin/bash
# Written by Lowy at 20190324
# Put backupfile list to giip KVS
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# include secure information
. ~/.profile/passwd.sh
# mariadbuid, mariadbpwd

# Backup config
backuptime="06"
targetpath="/data/dbbackup"

logtime=`date '+%H'`

cd $targetpath

if [ "$logtime" -eq "$backuptime" ]; then

    dbname="giipdb"
    logdt=`date '+%Y%m%d%H%M'`
    mysqldump -u $mariadbuid -p$mariadbpwd --single-transaction $dbname > ${dbname}_full_${logdt}.dump

else

    dbname="giipdb"
    logdt=`date '+%Y%m%d%H%M'`
    mysqldump -u $mariadbuid -p$mariadbpwd --single-transaction --flush-logs --master-data --delete-master-logs ${dbname} > ${dbname}_diff_${logdt}.sql

fi

# User Variables ===============================================
factor="DBBackup"
CntList=`ls -al $targetpath | wc -l`
#valueJSON=`ls -al $targetpath | awk '{print ",{\"fileName\":\""$9"\",\"Size\":"$5"}"}' | grep -v '""' | grep -v '"."' | grep -v '".."'`
valueJSON=`echo "[{\"FieldName\":\"FileCount\",\"Value\":${CntList}}]" | sed -e "s/\[,/\[ /g"`

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
echo -e $valueJSON
wget "https://giipaspi04.azurewebsites.net/API/kvs/put?$qs" -O "giipapi.log"

rm -f giipapi.log
rm -f put?*
