#!/bin/bash
# Written by Lowy Shin at 20160801
# For put port usage to giip KVS
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="NET-PORTUSAGE"
factorCounter="PORTCOUNT"
CntList=`lsof -i -nP | grep LISTEN | grep IPv4 | wc -l`
valueJSON=` lsof -i -nP | grep LISTEN | grep IPv4 | awk '{ split($9,str,":");print ",{\"PORT\":"str[2]",\"Service\":\""$1"\"}"}'`
valueJSON=`echo "{\"$factorCounter\":$CntList,\"$factor\":[ $valueJSON ]}" | sed -e "s/\[ ,/\[ /g"`

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
if [ $CntList > 0 ]; then
	#echo -e $valueJSON
	wget "http://giip.littleworld.net/API/kvs/put?$qs" -O "giipapi.log"
fi

rm -f giipapi.log
rm -f put?*

