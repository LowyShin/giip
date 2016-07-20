#!/bin/bash
DATE=`date +%Y%m%d%H%M`

PASSWORD='Replace Your Target Password'

DIP=(
Replace Your Target IP
)

PORT=Replace Your Target SSH Port

idx=0


CHECK_SSH=`which sshpass`
RESULT=`echo $?`
if [ ${RESULT} != 0 ];then
        wget http://pkgs.repoforge.org/sshpass/sshpass-1.05-1.el6.rf.x86_64.rpm ; rpm -Uvh sshpass-1.05-1.el6.rf.x86_64.rpm; rm -f sshpass-1.05-1.el6.rf.x86_64.rpm
fi

SSH=`which sshpass 2> /dev/null`

echo ----------Working Start-------------- ;

SSH_ARGS="-o StrictHostKeyChecking=no"


for DST in ${DIP[*]}; do

echo ----------Logging start-------------- >> $0.$DATE

        $SSH -p ${PASSWORD} ssh $SSH_ARGS -p${PORT} root@${DST} "hostname;
                                        service crond restart; echo "" " >> $0.$DATE
echo ----------Logging Finish------------- >> $0.$DATE

idx=$((idx + 1))

echo ----------Working Finish-------------- ;

done
