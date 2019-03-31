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
ofile="/etc/my.cnf"

ofilebak="$ofile.$today"
ojsontmp="${ofile}_${today}.json"
rm -f $ojsontmp

cp $ofile $ofilebak

findval="connect_timeout"
chgval="28800"
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

findval="interactive_timeout"
chgval="28800"
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

findval="net_read_timeout"
chgval="6000"
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

findval="net_write_timeout"
chgval="6000"
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

findval="wait_timeout"
chgval="28800"
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
