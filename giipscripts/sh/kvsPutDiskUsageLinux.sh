#!/bin/bash
# Written by Lowy Shin at 20160627
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="DISKUSAGE"
value=`df -PaT | grep '/' | awk '{print $6}'`

dffs=`df -PaT | grep '/' | awk '{print $1}'`
dfty=`df -PaT | grep '/' | awk '{print $2}'`
dfbl=`df -PaT | grep '/' | awk '{print $3}'`
dfus=`df -PaT | grep '/' | awk '{print $4}'`
dfav=`df -PaT | grep '/' | awk '{print $5}'`
dfca=`df -PaT | grep '/' | awk '{print $6}'`
dfmo=`df -PaT | grep '/' | awk '{print $7}'`

arydffs=(${dffs//'\n'/ })
arydfty=(${dfty//'\n'/ })
arydfbl=(${dfbl//'\n'/ })
arydfus=(${dfus//'\n'/ })
arydfav=(${dfav//'\n'/ })
arydfca=(${dfca//'\n'/ })
arydfmo=(${dfmo//'\n'/ })

array=(${value//'\n'/ })
valueJSON="{\"df -PaT\":["
for i in "${!array[@]}"
do
	if [ $i -gt 0 ]; then
		valueJSON="$valueJSON, "
	fi
	if [ $arydfbl[i] -gt 0 ]; then
		valueJSON="$valueJSON {\"Filesystem\":\"${arydffs[i]}\", \"Type\":\"${arydfty[i]}\", \"1024-blocks\":${arydfbl[i]}, \"Used\":${arydfus[i]}, \"Available\":${arydfav[i]}, \"Capacity\":\"${arydfca[i]}\", \"Mounted on\":\"${arydfmo[i]}\"}"
	fi
done
valueJSON="$valueJSON ] }"
#echo -e $valueJSON
# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
wget "http://giip.littleworld.net/API/kvs/put?$qs"
