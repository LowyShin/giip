#!/bin/bash
# Written by Lowy Shin at 20160627
# 160706 Lowy, Update ChainLock Count
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# Custom Variables [start]===============================================
# for kvs
factor="SYSCTL"
chgval="10"
# Custom Variables [end]===============================================
{{CustomVariables}}

today=`date +%Y%m%d`
ofile="/etc/sysctl.conf"
ofilebak="$ofile.$today"
findval="net.ipv4.tcp_fin_timeout"

if grep -o "$findval" $ofile > /dev/null
then
	#backup
	cp $ofile $ofilebak
	oldvalue=$(grep $findval $ofile | awk '{ print $3 }')

	if [ $oldvalue -gt $chgval ]
	then
		sed -i "s|\("$findval" *= *\).*|$findval = $chgval|" $ofile
	fi

	sysctl -p

	valueJSON="{\"FACTOR\":\"$factor\",\"DATA\":[{\"FIELD\":\"$findval\",\"ORG\":$oldvalue,\"NEW\":$chgval,\"BAKFILE\":\"$ofilebak\"}]}"

	# Send to KVSAPI Server =========================================
	qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
	wget "http://giip.littleworld.net/API/kvs/put?$qs"

fi
