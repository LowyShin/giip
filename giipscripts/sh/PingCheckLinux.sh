#/bin/sh
# Written by Lowy Shin at 20140922
# User Variables ===============================================
sk="{{sk}}"

# Check Ping
HOSTS="10.10.1.1 10.10.1.2 10.10.1.3 10.10.1.4"
COUNT=4
for myHost in $HOSTS
do
  count=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')

  # for Test
  #if [ $count -eq 0 ]; then
    # 100% failed
    # echo "Host : $myHost is down (ping failed) at $(date)"
  #fi

  case "$myHost" in
    # Server 01, see tpsn from Notification Service
    "10.10.1.1" ) tpsn="19";;
    # Server 02, see tpsn from Notification Service
    "10.10.1.2" ) tpsn="20";;
    # Server 03, see tpsn from Notification Service
    "10.10.1.3" ) tpsn="21";;
    # Server 04, see tpsn from Notification Service
    "10.10.1.4" ) tpsn="22";;
  esac

  # Send to API Server =========================================
  qs="at=$at&tpsn=$tpsn&ServerData=$count"
  wget "http://giip.littleworld.net/API/message/put?$qs"

done

rm -f TriggerPoint*
