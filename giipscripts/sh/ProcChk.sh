#!/bin/bash
# Written by Lowy Shin at 20190327
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="ServiceProc"
ChkProc1="nginx"
ChkProc2="apache"
ChkProc3="apache2"
CntProcSum=0

lwCmd2File=`ps axo pid,ppid,user,pcpu,pmem,start,time,comm,args k pmem | awk '($2 > 3) && ($8 == "nginx") {print "{\"PID\":"$1",\"PPID\":"$2",\"USER\":\""$3"\",\"CPU\":"$4",\"MEM\":"$5",\"Start\":\""$6"\",\"Spend\":\""$7"\",\"Cmd\":\""$8"\",\"Param\":\""$9" "$10" "$11" "$12" "$13" "$14" "$15" "$16"\"}" }' >giiptmpdata.txt`
CntProc=`cat giiptmpdata.txt | wc -l`
if [ $CntProc > 0 ]; then
    valueJSON=`echo $valueJSON {\"ProcName\":\"nginx\",\"Count\":$CntProc}`
    CntProcSum=`expr $CntProcSum + $CntProc`
fi

lwCmd2File=`ps axo pid,ppid,user,pcpu,pmem,start,time,comm,args k pmem | awk '($2 > 3) && ($8 == "apache") {print "{\"PID\":"$1",\"PPID\":"$2",\"USER\":\""$3"\",\"CPU\":"$4",\"MEM\":"$5",\"Start\":\""$6"\",\"Spend\":\""$7"\",\"Cmd\":\""$8"\",\"Param\":\""$9" "$10" "$11" "$12" "$13" "$14" "$15" "$16"\"}" }' >giiptmpdata.txt`
CntProc=`cat giiptmpdata.txt | wc -l`
if [ $CntProc > 0 ]; then
    valueJSON=`echo $valueJSON {\"ProcName\":\"apache\",\"Count\":$CntProc}`
    CntProcSum=`expr $CntProcSum + $CntProc`
fi

lwCmd2File=`ps axo pid,ppid,user,pcpu,pmem,start,time,comm,args k pmem | awk '($2 > 3) && ($8 == "apache2") {print "{\"PID\":"$1",\"PPID\":"$2",\"USER\":\""$3"\",\"CPU\":"$4",\"MEM\":"$5",\"Start\":\""$6"\",\"Spend\":\""$7"\",\"Cmd\":\""$8"\",\"Param\":\""$9" "$10" "$11" "$12" "$13" "$14" "$15" "$16"\"}" }' >giiptmpdata.txt`
CntProc=`cat giiptmpdata.txt | wc -l`
if [ $CntProc > 0 ]; then
    valueJSON=`echo $valueJSON {\"ProcName\":\"apache2\",\"Count\":$CntProc}`
    CntProcSum=`expr $CntProcSum + $CntProc`
fi

lwCmd2File=`ps axo pid,ppid,user,pcpu,pmem,start,time,comm,args k pmem | awk '($2 > 3) && ($8 == "mysqld") {print "{\"PID\":"$1",\"PPID\":"$2",\"USER\":\""$3"\",\"CPU\":"$4",\"MEM\":"$5",\"Start\":\""$6"\",\"Spend\":\""$7"\",\"Cmd\":\""$8"\",\"Param\":\""$9" "$10" "$11" "$12" "$13" "$14" "$15" "$16"\"}" }' >giiptmpdata.txt`
CntProc=`cat giiptmpdata.txt | wc -l`
if [ $CntProc > 0 ]; then
    valueJSON=`echo $valueJSON {\"ProcName\":\"mysql\",\"Count\":$CntProc}`
    CntProcSum=`expr $CntProcSum + $CntProc`
fi

valueJSON=`echo "{\"PROCCNT\":$CntProcSum,\"PROCCHK\":[ $valueJSON ]}"`
echo $valueJSON > result.txt

# Send to KVSAPI Server =========================================
lwAPIURL="http://giip03.littleworld.net/api/kvs/kvsput.asp"
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
if [ $CntProcSum > 0 ]; then
    curl -k -w '\n' "$lwAPIURL" --data "$qs" -XPOST
fi

#rm -f giiptmpdata.txt
rm -f giipapi.log
rm -f put?*

