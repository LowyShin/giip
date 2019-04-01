#!/bin/bash
# Written by Lowy Shin at 20160627
# 20190331 Lowy, Update my.cnf for CCT
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# Custom Variables [start]===============================================
# for kvs
factor="CfgTune"

# Custom Variables [end]===============================================
# {{CustomVariables}}
today=`date +%Y%m%d`

### Starting Change ###
ofile="/etc/sysctl.conf"

ofilebak="$ofile.$today"
ojsontmp="${ofile}_${today}.json"
rm -f $ojsontmp

cp $ofile $ofilebak

findval="net.ipv4.tcp_tw_recycle"
chgval="1"
if grep -o "$findval" $ofile > /dev/null
then
	oldvalue=$(grep $findval $ofile | awk '{ print $3 }')
	if [ $oldvalue -ne $chgval ]
	then
		sed -i "s|\("$findval" *= *\).*|$findval=$chgval|" $ofile
	fi
	sysctl -p
	echo "{\"FileName\":\"$ofile\",\"Param\":\"$findval\",\"pValue\":\"$chgval\"}" >>$ojsontmp
else
	rst=`echo $findval=$chgval >$ofile`
	echo "{\"FileName\":\"$ofile\",\"Param\":\"$findval\",\"pValue\":\"$chgval\"}" >>$ojsontmp
fi

findval="net.ipv4.tcp_tw_reuse"
chgval="1"
if grep -o "$findval" $ofile > /dev/null
then
	oldvalue=$(grep $findval $ofile | awk '{ print $3 }')
	if [ $oldvalue -ne $chgval ]
	then
		sed -i "s|\("$findval" *= *\).*|$findval=$chgval|" $ofile
	fi
	sysctl -p
	echo "{\"FileName\":\"$ofile\",\"Param\":\"$findval\",\"pValue\":\"$chgval\"}" >>$ojsontmp
else
	rst=`echo $findval=$chgval >$ofile`
	echo "{\"FileName\":\"$ofile\",\"Param\":\"$findval\",\"pValue\":\"$chgval\"}" >>$ojsontmp
fi

findval="net.ipv4.tcp_fin_timeout"
chgval="5"
if grep -o "$findval" $ofile > /dev/null
then
	oldvalue=$(grep $findval $ofile | awk '{ print $3 }')
	if [ $oldvalue -ne $chgval ]
	then
		sed -i "s|\("$findval" *= *\).*|$findval=$chgval|" $ofile
	fi
	sysctl -p
	echo "{\"FileName\":\"$ofile\",\"Param\":\"$findval\",\"pValue\":\"$chgval\"}" >>$ojsontmp
else
	rst=`echo $findval=$chgval >$ofile`
	echo "{\"FileName\":\"$ofile\",\"Param\":\"$findval\",\"pValue\":\"$chgval\"}" >>$ojsontmp
fi

# put KVS
valueJSON=`cat $ojsontmp`
valueJSON="[${valueJSON}]"

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
lwAPIURL="http://giip03.littleworld.net/API/kvs/kvsput.asp"
curl -k -w '\n' "$lwAPIURL" --data "$qs" -XPOST
