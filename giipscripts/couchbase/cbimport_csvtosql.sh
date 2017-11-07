#!/bin/bash

# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# KVS variables
factor="CBImport"

# User Variables
UFile="$1"

# make temp data
#echo "a|b|c|d|e" > $UFile
#echo "a1|b1|c1|d1|e1" >> $UFile
#echo "a2|b2|c2|d2|e2" >> $UFile
#echo "a3|b3|c3|d3|e3" >> $UFile

# Import data
# Set Header
s=`tail -n 1 $UFile`
AttribCnt=`cat $UFile |wc -l`
CharDeli="|"

CntDeli=`echo "${s}" | awk -F"${CharDeli}" '{print NF-1}'`
((CntDeli++))
#echo "$s"
#echo "Count: $CntDeli"

lwi=1
fstr=""
while [ "$lwi" -le "$CntDeli" ];
do
    if [ "$fstr" ]; then
        fstr="$fstr,f$lwi"
    else
        fstr="f$lwi"
    fi
    ((lwi++))
done
#echo "fstr:$fstr"

# Couchbase V5
# cbimport csv -c couchbase://127.0.0.1 -u admin -p root1234 \
#            -b default -d $DataFileOpt --field-separator $'|' \
#            -g key::%fname%::#UUID# -t 4

# Couchbase V4.X
while read -r line
do
    Ldata="insert into \`000\` ($fstr) values (\"$line\");"
    Ldata=`echo "$Ldata" |sed -e "s/|/\",\"/g" `
    echo "$Ldata"
done < "$UFile"

# Check Result

# Set result for KVS
valueJSON=`echo "{\"ImportFile\":\"$UFile\"}" | sed -e "s/\[ ,/\[ /g"`
#echo $valueJSON

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
lwAPIURL="http://giip.littleworld.net/API/kvs/kvsput.asp"
if [ $AttribCnt > 0 ]; then
    curl -k -w '\n' "$lwAPIURL" --data "$qs" -XPOST
    #echo "curl -k -w '\n' '$lwAPIURL' --data '$qs' -XPOST"
fi
