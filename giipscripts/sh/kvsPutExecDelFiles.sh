#!/bin/bash
# Written by Lowy Shin at 20160627
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="LOGDEL"
valueJSON=`ls -al /var/log/lsyncd | grep lsyncd.log- | awk '{print "{\"FileName\":\""$9"\",\"Date\":"$6" "$7",\"TIME\":\""$8"\",\"Size\":\""$5"\"}"}'`
valueJSON="{\"$factor\":[ $valueJSON ]}" | sed -e "s/} {/}, {/g"

# Send Command ==================================================
rm -f /var/log/lsyncd/lsyncd.log-*

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
wget "http://giip.littleworld.net/API/kvs/put?$qs" -O "giipapi.log"

rm -f giipapi.log
rm -f put?*

