# You can see secret key in service page of giip
sk="<SecretKey>"
# if you registered logical server name same as hostname then below, or put your label name
lb=`hostname`

# Append to crontab
crontab -l
(crontab -l ; echo "# 160701 Lowy, for giip")| crontab -
(crontab -l ; echo "* * * * * bash --login -c 'sh /usr/local/giip/scripts/giipAgent.sh'")| crontab -
crontab -l

# make file
mkdir -p /usr/local/giip/scripts
# download giip agent
wget "http://giipapi.littleworld.net/api/agent/getbylabel?op=giipAgentlinux&sk=$sk&lb=$lb" -O /usr/local/giip/scripts/giipAgent.sh

# check and install dos2unix
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

# convert giipScript
dos2unix /usr/local/giip/scripts/giipAgent.sh
