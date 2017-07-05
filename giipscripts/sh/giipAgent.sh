#!/bin/bash
# giipAgent Ver. 1.2
# Written by Lowy Shin at 20140922
# 170705 Lowy, Fix execute shell not haver 755 permission.
# {{today}} : Replace today to "YYYYMMDD"
# User Variables ===============================================
sk="|acctoken|"
lssn="|lssn|"

# Check os2unix
CHECK_Converter=`which dos2unix`
RESULT=`echo $?`

#OS Check
ostype=`head -n 1 /etc/issue | awk '{print $1}'`
if [ $ostype = "Ubuntu" ];then
	os=`lsb_release -d`
	os=`echo "$os"| sed -e "s/Description\://g"`

	if [ ${RESULT} != 0 ];then
		apt-get install -y dos2unix
	fi
else
	os=`cat /etc/redhat-release`

	if [ ${RESULT} != 0 ];then
		yum install -y dos2unix
	fi
fi

tmpFileName="giipTmpScript.sh"
logdt=`date '+%Y/%m/%d %H:%M:%S'`
Today=`date '+%Y%m%d'`

wget "|protocol||domain|/api/cqe/queue/get03?sk=$sk&lssn=$lssn&os=$os&df=os" -O $tmpFileName

echo "[$logdt]" >> giipAgent.log

ls -l $tmpFileName
dos2unix $tmpFileName

while [ -s $tmpFileName ];
do

	n=`sed -n '/\/expect/=' giipTmpScript.sh`
	if [[ n -eq 1 ]]; then
		expect ./giipTmpScript.sh >> giipAgent.log
		echo "Executed expect script..." >> giipAgent.log
	else
		sh ./giipTmpScript.sh >> giipAgent.log
		echo "Executed script..." >> giipAgent.log
	fi

	wget "|protocol||domain|/api/cqe/queue/get03?sk=$sk&lssn=$lssn&os=$os&df=os" -O $tmpFileName
	ls -l $tmpFileName
	dos2unix $tmpFileName
done

rm -f $tmpFileName
