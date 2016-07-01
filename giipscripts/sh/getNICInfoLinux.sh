#!/bin/sh
# Written by Lowy Shin at 20140922
# Last Modified by Lowy at 20150210
# 20150210 Add System Serial Number
# 20150210 Fix Manufacturer Information
# User Variables ===============================================
at="{{sk}}"
lssn="{{lssn}}"
PATH=$PATH:/bin:/usr/bin:/usr/sbin

ii=`ip -4 address show | grep inet`
echo "ii:$ii" >>giipAgent.log
echo "org..." >>giipAgent.log
ip -4 address show | grep inet >>giipAgent.log
gw=`netstat -rn | tail -1 | awk '{print $2}'`
dns=$(sed -e '/^$/d' /etc/resolv.conf | awk '{if (tolower($1)=="nameserver") print $2}')

# Send to API Server =========================================
qs="at=$at&lssn=$lssn&gw=$gw&dns=$dns&ii=$ii"
APIURL="http://giip.littleworld.net/API/LSvrNICInfoInputLinuxV141120.asp?$qs"
APIURL=`echo "$APIURL" |tr -d '\b\r'`
APIURL=`echo "$APIURL" |tr -d '\b\r'`
APIURL=`echo "$APIURL" |tr -d '\b\r'`
echo "APIURL:$APIURL" >>giipAgent.log
wget "$APIURL" -O giipAPINIC.txt

rm -f giipAPINIC.txt
