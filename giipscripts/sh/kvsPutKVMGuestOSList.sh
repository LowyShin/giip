#!/bin/bash
# Written by Lowy Shin at 20160807
# Put Guest OS List on KVM to KVS
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="KVM"
Attrib="List"
DataCnt=`virsh list --all | grep [0-9] | wc -l`
valueJSON=`virsh list --all | grep [0-9] | awk '{print ",{\"ID\":\""$1"\", \"Name\":\""$2"\", \"State\":\""$3" "$4"\"}"}'`
valueJSON=`echo "{\"$factor-$Attrib\":$DataCnt,\"DATA\":[ $valueJSON ]}" | sed -e "s/\[ ,/\[ /g"`
#echo -e $valueJSON

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor-$Attrib&value=$valueJSON"
lwAPIURL="https://secure.littleworld.net/API/kvs/kvsput.asp"
if [ $DataCnt > 0 ]; then
	curl -k -w '\n' "$lwAPIURL" --data "$qs" -XPOST
fi

rm -f giipapi.log
rm -f put?*
rm -f 0
