#!/bin/bash
# Written by Lowy Shin at 20160627
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="CONNECTIONCOUNT"
value=`netstat -ant | awk '{print $6}' | sort | uniq -c | sort -n`

echo $value

array=(${value//' '/ })

valueJSON="{\"netstat\":[ {"
for i in "${!array[@]}"
do
	if [ $(($i % 2)) -eq 0 ]; then
		if [ $i -gt 0 ]; then
			valueJSON="$valueJSON, "
		fi
		valueJSON="$valueJSON \"${array[i+1]}\":\"${array[i]}\""
	fi
done
valueJSON="$valueJSON } ] }"
#echo -e $valueJSON
# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
wget "http://giip.littleworld.net/API/kvs/put?$qs" -O "giipapi.log"

rm -f giipapi.log
rm -f put?*

