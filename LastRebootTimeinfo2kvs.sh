#!/bin/bash
# Written by Braum 20171126

# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
lastbootDate=`last reboot | head -1 | awk '{print $5" "$6" "$7}'`
lastbootTime=`last reboot | head -1 | awk '{print $8}'`
HowLong=`last reboot | head -1 | awk '{print $11}' | sed -e 's/[()]//g'`
factor="SysRebootingTime"
valueJSON="{\"lastbootDate\":\"$lastbootDate\", \"lastbootTime\":\"$lastbootTime\", \"HowLong\":\"It's been $HowLong\"}"
valueJSON="{\"$factor\":[ $valueJSON ]}"
echo $valueJSON


# Send Command ==================================================
#<!MEANINGLESS!> rm -f /var/log/lsyncd/lsyncd.log-*

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
wget "http://giip.littleworld.net/API/kvs/put?$qs" -O "giipapi.log"

rm -f giipapi.log
rm -f put?*
