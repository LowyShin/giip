#!/bin/bash
# Written by Lowy Shin at 20160627
# System Variables ===============================================
sk="5b002a760d306cd0eaccb5869e120345"
lssn="70840"

# User Variables ===============================================
factor="SNMP"
AttribCnt=10
CPU=`snmpwalk -v 2c -c public localhost 1.3.6.1.4.1.2021.11`
MEMORY=`snmpwalk -v 2c -c public localhost 1.3.6.1.4.1.2021.4`
HDD=`snmpwalk -v 2c -c public localhost 1.3.6.1.4.1.2021.9.1.6`

valueJSON="{\"CPU\":\"$CPU\",\"MEMORY\":\"$MEMORY\",\"HDD\":\"$HDD\"}" #valueJSON=`echo $valueJSON | tr -d `
valueJSON=`echo "[ $valueJSON ]" | sed -e "s/\[ ,/\[ /g"`
#echo -e $valueJSON

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
lwAPIURL="http://www.littleworld.net/API/kvs/kvsput.asp"
if [ $AttribCnt > 0 ]; then
	curl -k -w '\n' "$lwAPIURL" --data "$qs" -XPOST
fi

rm -f giipapi.log
rm -f put?*
rm -f 0
