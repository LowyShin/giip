#!/bin/bash
# Written by Lowy Shin at 20160807
# Put Guest OS Pool List on KVM to KVS
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="KVM"
Attrib="List"
DataCnt=`virsh pool-list --all | grep -v [----] | grep -v "Name\s\s*State" | wc -l`
valueJSON=`virsh pool-list --all | grep -v [----] | grep -v "Name\s\s*State"| awk '{print ",{\"Name\":\""$1"\", \"State\":\""$2"\", \"Autostart\":\""$3"\"}"}'`
valueJSON=`echo "{\"$factor-$Attrib\":$DataCnt,\"DATA\":[ $valueJSON ]}" | sed -e "s/\[ ,/\[ /g"`
#echo -e $valueJSON

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor-$Attrib&value=$valueJSON"
lwAPIURL="https://secure.littleworld.net/API/kvs/kvsput.asp"
if [ $DataCnt > 0 ]; then
	curl -w '\n' "$lwAPIURL" --data "$qs" -XPOST
fi

rm -f giipapi.log
rm -f put?*
rm -f 0
