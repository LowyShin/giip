#!/bin/bash
# Written by Lowy Shin at 20160627
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="PROCCHK-NGINX"
ChkProc="nginx"
CntProc=`ps -ef | grep $ChkProc | grep -v grep | wc -l`
valueJSON=`ps -ef | grep $ChkProc | grep -v grep | awk '{print ",{\"UID\":\""$1"\",\"PID\":"$2",\"TIME\":\""$7"\",\"PROC\":\""$8"\",\"CMD\":\""$9" "$10" "$11" "$12" "$13"\"}"}'`
valueJSON=`echo "{\"PROCCNT\":$CntProc,\"PROCCHK\":[ $valueJSON ]}" | sed -e "s/\[ ,/\[ /g"`
#echo -e $valueJSON

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
if [ $CntProc > 0 ]; then
    wget "http://giip.littleworld.net/API/kvs/put?$qs" -O "giipapi.log"
fi

rm -f giipapi.log
rm -f put?*

