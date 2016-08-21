#!/bin/bash
# Written by Lowy Shin at 20160807
# Put Guest OS List on KVM to KVS
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# CustomVariables =========================================
# Copy below and paste to0 customvariables box and edit check URL
lwURL="giip.littleworld.net"
Attrib="giip"

# User Variables ===============================================
factor="HTTPStatus"
{{CustomVariables}}
DataCnt=1
valueJSON=`curl -LI $lwURL --max-time 5 -o /dev/null -w '%{http_code}\n' -s`
valueJSON=`echo "{\"$factor-$Attrib\":$lwURL,\"STATUS\":$valueJSON}" | sed -e "s/\[ ,/\[ /g"`
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

