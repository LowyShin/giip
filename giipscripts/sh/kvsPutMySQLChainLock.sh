#!/bin/bash
# Written by Lowy Shin at 20160627
# 160706 Lowy, Update ChainLock Count
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# Custom Variables [start]===============================================
# for kvs
factor="MYSQLCHAINLOCK"
# for mysql
lwUser="root"
lwPwd="********"
lwDB="database01"
lwSQL="SELECT CONCAT(',{\"TIME\":', CAST(TIME as CHAR), ',\"INFO\":\"', ifnull(INFO, 'NULL'), '\"}' ) as JSON FROM INFORMATION_SCHEMA.PROCESSLIST where INFO is not null "
# Custom Variables [end]===============================================
{{CustomVariables}}

# Main Scripts ===============================================
valueJSON=`mysql -u $lwUser -p$lwPwd -ss -e "$lwSQL"`
schar="{"
CntRst=$(grep -o "$schar" <<< "$valueJSON" | wc -l)
valueJSON=`echo "{\"CHAINLOCK\":$CntRst, \"DATA\":[ $valueJSON ]}" | sed -e "s/\[ ,/\[ /g"`

echo $RstVal

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
wget "http://giip.littleworld.net/API/kvs/put?$qs"
