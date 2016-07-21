#!/bin/sh
# Written by Lowy Shin at 20140922
# Last Modified by Lowy at 20150210
# 20150210 Add System Serial Number
# 20150210 Fix Manufacturer Information
# User Variables ===============================================
at="{{sk}}"
lssn="{{lssn}}"

# Get System Variables =========================================
hn=`uname -n`
echo "hostname : $hn"
mf=`dmidecode --type 1 |grep 'Product Name'`
mfsn=`dmidecode --type 1 |grep 'Serial'`
cpuname=`cat /proc/cpuinfo  | grep 'model name' | awk -F\: 'NR==1 {print $2}'`
echo "CPU : $cpuname "
os=`head -n 1 /etc/issue`
echo "OSver. : $os"
mem=`free -mt | awk '/Mem/{print $2}'`
#mem=`expr $(($mem*1024*1024))`
echo "mem : $mem"
cpunum=`cat /proc/cpuinfo | grep processor | wc -l`

# Send to API Server =========================================
qs="at=$at&lssn=$lssn&hn=$hn&mf=$mf&cpuname=$cpuname&cpunum=$cpunum&mem=$mem&os=$os&mfsn=$mfsn"
APIURL="http://giip.littleworld.net/API/LSvrInput_temp.asp?$qs"
wget "$APIURL" -O giipAPISYS.txt

# Check CPU Usage ===============================================
factor="CPUUSAGE"
value=`cat /proc/loadavg | cut -d ' ' -f 1`
value="{\"CPUUsage\":$value}"

# Send to KVSAPI Server =========================================
qs="sk=$at&type=lssn&key=$lssn&factor=$factor&value=$value"
APIURL="http://giip.littleworld.net/API/kvs/put?$qs"
wget "$APIURL" -O giipAPISYS.txt

# Clean up =========================================
rm -f giipAPISYS.txt
