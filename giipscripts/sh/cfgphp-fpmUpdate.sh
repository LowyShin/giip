#!/bin/bash
# Written by Lowy Shin at 20160627
# 20190331 Lowy, Update sysctl.conf
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# Custom Variables [start]===============================================
# for kvs
factor="CfgTune-php-fpm"

# Custom Variables [end]===============================================
# {{CustomVariables}}
today=`date +%Y%m%d`

### Starting Change ###
ofile="/etc/php-fpm.d/www.conf"
ocharcmt=";"

ofilebak="$ofile.$today"
ofiletmp="$ofile.tmp"
ojsontmp="${ofile}_${today}.json"
rm -f $ojsontmp

cp $ofile $ofilebak

findval="pm.max_children"
chgval="768"
if grep -o "$findval" $ofile > /dev/null
then
    sed -i "s|"$findval"|"${ocharcmt}${findval}"|" $ofile
fi
echo "$findval=$chgval" >>$ofile
echo "{\"FileName\":\"$ofile\",\"Param\":\"$findval\",\"pValue\":\"$chgval\"}" >>$ojsontmp

findval="pm.start_servers"
chgval="50"
if grep -o "$findval" $ofile > /dev/null
then
    sed -i "s|"$findval"|"${ocharcmt}${findval}"|" $ofile
fi
echo "$findval=$chgval" >>$ofile
echo "{\"FileName\":\"$ofile\",\"Param\":\"$findval\",\"pValue\":\"$chgval\"}" >>$ojsontmp

findval="pm.max_spare_servers"
chgval="768"
if grep -o "$findval" $ofile > /dev/null
then
    sed -i "s|"$findval"|"${ocharcmt}${findval}"|" $ofile
fi
echo "$findval=$chgval" >>$ofile
echo "{\"FileName\":\"$ofile\",\"Param\":\"$findval\",\"pValue\":\"$chgval\"}" >>$ojsontmp

# put KVS
valueJSON=`cat $ojsontmp`
valueJSON="[${valueJSON}]"

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
lwAPIURL="http://giip03.littleworld.net/API/kvs/kvsput.asp"
curl -k -w '\n' "$lwAPIURL" --data "$qs" -XPOST
