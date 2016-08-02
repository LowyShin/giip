#!/bin/bash
# Written by Hellala at 20160802
# Put userlist to giip KVS
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="USERS"
factorCounter="USERCOUNT"
CntList=`cat /etc/passwd | wc -l`
valueJSON=`cat /etc/passwd | awk '{ split($1,str,":");print",{\"User\":"str[1]"}"}'`
valueJSON=`echo "{\"$factorCounter\":$CntList,\"$factor\":[$valueJSON]}" | sed -e "s/\[,/\[ /g"`

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
if [ $CntList > 0 ]; then
	echo -e $valueJSON
	#wget "http://giip.littleworld.net/API/kvs/put?$qs" -O "giipapi.log"
fi

rm -f giipapi.log
rm -f put?*
