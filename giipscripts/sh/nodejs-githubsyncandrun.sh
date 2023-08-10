#!/bin/bash
# Written by Lowy Shin at 20160627
# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

hn=`hostname`
reponame="giipasp"
port="4000"
# separate variables with hostname
if [ $hn == "giip-stg-vm01" ];then
    branch="stg"
    env="prod"
elif [ $hn == "giip-prod-Z0IN8G" ];then
    branch="prod"
    env="prod"
elif [ $hn == "giip-dev-vm01" ];then
    branch="dev"
    env="dev"
fi

cd /usr/projects/${reponame}

echo "move directory"
pwd

-- check github for changes
git fetch
HEADHASH=$(git rev-parse HEAD)
UPSTREAMHASH=$(git rev-parse $1@{upstream})

if [ "$HEADHASH" == "$UPSTREAMHASH" ]
then
    echo -e ${ERROR}No changes with ${reponame} ${branch}. Aborting.${NOCOLOR}
    echo
    rst="UPSTREAMHASH:${UPSTREAMHASH}"
else
    rst="UPSTREAMHASH:${UPSTREAMHASH}"
    echo "git changed!"
    echo "HEADHASH : ${HEADHASH}"
    echo "UPSTREAMHASH : ${UPSTREAMHASH}"

    echo "git pull origin ${branch}"
    git pull origin ${branch}
    yarn install
    yarn build:${env}

    # set local ip to nuxt.config.js for permit from outside
    ip=`ifconfig |grep inet |grep broadcast | awk '{print $2}'`
    r=`cat nuxt.config.js |grep ${ip}`
    if [[ $r = "" ]]; then
        mv nuxt.config.js ../
        echo "moved org file... "
        sed -e "s/NUXT_CLIENT_PORT,/NUXT_CLIENT_PORT,\n    host: \'${ip}\'/g" ../nuxt.config.js>nuxt.config.js
        echo "put ip done..."
    else
        echo "${r}"
        echo "nothing to changes..."
    fi

    # kill process
    PID=`ps -eaf | grep ${branch} | grep -v grep | awk '{print $2}'`
    if [[ "" !=  "$PID" ]]; then
        echo "killing process $PID"
        kill $PID
    fi
    sleep 5
    # if hung process, kill force
    PID=`ps -eaf | grep ${branch} | grep -v grep | awk '{print $2}'`
    if [[ "" !=  "$PID" ]]; then
        echo "killing process force $PID"
        kill -9 $PID
    fi
    sleep 5

fi

echo "process check..."
netcnt=`netstat -anp |grep ":${port} " | grep node |wc -l`
if [ $netcnt -lt 1 ];then
    echo "${reponame} proc count : $netcnt ${env} process running..."
    cd /usr/projects/${reponame};yarn start:${env}&
else
    echo "Service port is on-line"
    netstat -anp |grep ":${port} " | grep node
fi

# User Variables ===============================================
factor="PROCCHK-${reponame}"
ChkProc="${reponame}"
CntProc=`ps -ef | grep $ChkProc | grep -v grep | wc -l`
valueJSON=`ps -ef | grep $ChkProc | grep -v grep | awk '{print ",{\"UID\":\""$1"\",\"PID\":"$2",\"TIME\":\""$7"\",\"PROC\":\""$8"\",\"CMD\":\""$9" "$10" "$11" "$12" "$13"\"}"}'`
valueJSON=`echo "{\"PROCCNT\":$CntProc,\"PROCCHK\":[ $valueJSON ]}" | sed -e "s/\[ ,/\[ /g"`
#echo -e $valueJSON

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
lwAPIURL="https://giipasp.azurewebsites.net/API/kvs/kvsput.asp"
if [ $CntProc > 0 ]; then
    curl -k -w '\n' "$lwAPIURL" --data "$qs" -XPOST
fi

rm -f giipapi.log
rm -f put?*

