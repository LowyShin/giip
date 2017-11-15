//getSystemInfoLinux.sh//
#!/bin/sh
# Written by Braum at 20171019
# Last Modified by Braum at 20170109
# User Variables ===============================================
at="{{sk}}"
lssn="{{lssn}}"

# Get System Variables =========================================
hn=`uname -n` 
echo "hostname : $hn"
mf=`prtconf | grep -i 'Processor Type'`
mfsn=`prtconf -|grep 'Serial Number'`
cpuname= `uname -M` 
echo "CPU : $cpuname "
os=`oslevel`
echo "OSver. : $os"
mem=`prtconf -m | awk '{print $3}'`
#mem=`expr $(($mem*1024*1024))`
echo "mem : $mem"
cpunum=`lscfg | grep proc | wc -l`
# //finish// #


# Send to API Server =========================================
qs="at=$at&lssn=$lssn&hn=$hn&mf=$mf&cpuname=$cpuname&cpunum=$cpunum&mem=$mem&os=$os&mfsn=$mfsn"
APIURL="http://giip.littleworld.net/API/LSvrInput_temp.asp?$qs"
wget -O giipAPISYS.txt "$APIURL"

# Check CPU Usage ===============================================
factor="CPUUSAGE"
value=`cat /proc/loadavg | cut -d ' ' -f 1`
value="{\"CPUUsage\":$value}"

# Send to KVSAPI Server =========================================
qs="sk=$at&type=lssn&key=$lssn&factor=$factor&value=$value"
APIURL="http://giip.littleworld.net/API/kvs/put?$qs"
wget -O giipAPISYS.txt "$APIURL" 

# Clean up =========================================
rm -f giipAPISYS.txt
