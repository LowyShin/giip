#!/bin/bash
# Written by Lowy Shin at 20160627
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="PROCCHK-NGINX"
valueJSON=`ps -ef | grep nginx | awk '{print "{\"UID\":\""$1"\",\"PID\":"$2",\"TIME\":\""$7"\",\"PROC\":\""$8"\",\"CMD\":\""$9" "$10" "$11" "$12" "$13"\"}"}'`
valueJSON="{\"PROCCHK\":[ $valueJSON ]}" | sed -e "s/} {/}, {/g"
#echo -e $valueJSON

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
wget "http://giip.littleworld.net/API/kvs/put?$qs" -O "giipapi.log"

rm -f giipapi.log
rm -f put?*

