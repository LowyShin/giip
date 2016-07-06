#!/bin/bash
today=`date +%Y%m%d`
ofile="/etc/sysctl.conf"
ofilebak="$ofile.$today"
findval="net.ipv4.tcp_fin_timeout"
chgval="10"

if grep -o "$findval" $ofile > /dev/null
then
	#backup
	cp $ofile $ofilebak
	oldvalue=$(grep $findval $ofile | awk '{ print $3 }')

	if [ $oldvalue -gt $chgval ]
	then
		sed -i "s|\("$findval" *= *\).*|$findval = $chgval|" $ofile
	fi

	sysctl -p
fi
