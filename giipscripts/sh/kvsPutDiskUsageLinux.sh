#!/bin/bash
# Written by Lowy Shin at 20160627
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="DISKUSAGE"
AttribCnt=`df -PaT | grep '/' | grep -v '0        0' | wc -l`
valueJSON=`df -PaT | grep '/' | grep -v '0        0' | awk '{print ",{\"Filesystem\":\""$1"\", \"Type\":\""$2"\", \"1024-blocks\":"$3", \"Used\":"$4", \"Available\":"$5", \"Capacity\":\""$6"\", \"Mounted on\":\""$7"\"}"}'`
valueJSON=`echo "{\"$factor\":$AttribCnt,\"DATA\":[ $valueJSON ]}" | sed -e "s/\[ ,/\[ /g"`
#echo -e $valueJSON

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
lwAPIURL="https://secure.littleworld.net/API/kvs/kvsput.asp"
if [ $AttribCnt > 0 ]; then
	curl -k -w '\n' "$lwAPIURL" --data "$qs" -XPOST
fi

rm -f giipapi.log
rm -f put?*
rm -f 0
