#!/bin/bash
# Written by bobblue at 201727
#
# install for iostat
# sudo apt-get install sysstat
#


# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="ST_Disk"

AttribCnt=`df -T --type=ext4 | grep '/' | wc -l`
valueJSON=`df -T --type=ext4 | grep '/' | awk '{print ",{\"Mount\":\""$7"\",\"Filesystem\":\""$1"\",\"Type\":\""$2"\",\"Used\":"$4",\"Available\":"$5",\"Capacity\":"$3",\"IOPS\":"$1"}"}'`
#echo ${valueJSON[0]}

myarr=($(iostat -N | grep 'cl-' | awk '{ print $1 }'))
#echo ${myarr[0]}

for vol in "${myarr[@]}"
do
  if [[ $valueJSON =~ $vol ]]; then

    iops=$(iostat -N | grep $vol | awk '{print "\"DiskReadsPersec\":\""$2"\",\"DiskWritesPersec\":\""$3"\""}')
    valueJSON=${valueJSON//"\"IOPS\":/dev/mapper/"$vol/$iops}

  fi
done

valueJSON=`echo $valueJSON | sed -e "s#,\"IOPS\":[a-zA-Z0-9/-]*\}#,\"DiskReadsPersec\":\"0\",\"DiskWritesPersec\":\"0\"\}#g"`
valueJSON=`echo "[ $valueJSON ]" | sed -e "s/\[ ,/\[ /g"`
#valueJSON=`echo "{\"$factor\":$AttribCnt,\"DATA\":[ $valueJSON ]}" | sed -e "s/\[ ,/\[ /g"`
#echo $valueJSON

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
lwAPIURL="http://125.7.235.90/API/kvs/kvsput.asp"
if [ $AttribCnt > 0 ]; then
 curl -k -w '\n' "$lwAPIURL" --data "$qs" -XPOST
    #echo "curl -k -w '\n' '$lwAPIURL' --data '$qs' -XPOST"
fi

rm -f giipapi.log
rm -f put?*
rm -f 0
