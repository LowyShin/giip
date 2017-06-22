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
wget "http://giip.littleworld.net/api/agent/getbylabel?op=giipAgentlinux&sk=$sk&lb=$lb" -O /usr/local/giip/scripts/giipAgent.sh
