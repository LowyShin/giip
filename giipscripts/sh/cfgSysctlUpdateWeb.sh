#!/bin/bash
# Written by Lowy Shin at 20160627
# 20190331 Lowy, Update sysctl.conf
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# Custom Variables [start]===============================================
# for kvs
factor="CfgTune-sysctl"
ocharcmt="#"

# Custom Variables [end]===============================================
# {{CustomVariables}}
today=`date +%Y%m%d`

### Starting Change ###
ofile="/etc/sysctl.conf"

ofilebak="$ofile.$today"
ofiletmp="$ofile.tmp"
ojsontmp="${ofile}_${today}.json"
rm -f $ojsontmp

cp $ofile $ofilebak

findval="net.ipv4.tcp_tw_recycle"
chgval="1"
if grep -o "$findval" $ofile > /dev/null
then
    sed -i "s|"$findval"|"${ocharcmt} ${today} ${findval}"|" $ofile
fi
rst=`echo $findval=$chgval >>$ofile`
echo "{\"FileName\":\"$ofile\",\"Param\":\"$findval\",\"pValue\":\"$chgval\"}" >>$ojsontmp

findval="net.ipv4.tcp_tw_reuse"
chgval="1"
if grep -o "$findval" $ofile > /dev/null
then
    sed -i "s|"$findval"|"${ocharcmt} ${today} ${findval}"|" $ofile
fi
rst=`echo $findval=$chgval >>$ofile`
echo "{\"FileName\":\"$ofile\",\"Param\":\"$findval\",\"pValue\":\"$chgval\"}" >>$ojsontmp

findval="net.ipv4.tcp_fin_timeout"
chgval="5"
if grep -o "$findval" $ofile > /dev/null
then
    sed -i "s|"$findval"|"${ocharcmt} ${today} ${findval}"|" $ofile
fi
rst=`echo $findval=$chgval >>$ofile`
echo "{\"FileName\":\"$ofile\",\"Param\":\"$findval\",\"pValue\":\"$chgval\"}" >>$ojsontmp

sysctl -p

# put KVS
valueJSON=`cat $ojsontmp`
valueJSON="[${valueJSON}]"

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
lwAPIURL="http://giip03.littleworld.net/API/kvs/kvsput.asp"
curl -k -w '\n' "$lwAPIURL" --data "$qs" -XPOST
