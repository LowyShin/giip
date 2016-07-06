#----------------------------------
sk="{{sk}}"
ServerData="1"
urlapilog="http://giip.littleworld.net/api/message/put"
#----------------------------------

#install net-snmp
yum install -y net-snmp
yum install -y net-snmp-utils

# Custom Variables ----
# Message Service Number
# tpsn="81"
cfgpath="/etc/snmp"
cfgfile="snmpd.conf"
{{CustomVariables}}
# Custom Variables ----

# Change config file
sed -i "s/com2sec notConfigUser  default       public/com2sec mynetwork  $svrip       public\ncom2sec local  localhost       public/" "$cfgpath/$cfgfile"

sed -i "s/group   notConfigGroup v1           notConfigUser/group   $nmgroup v1           mynetwork/" "$cfgpath/$cfgfile"
sed -i "s/group   notConfigGroup v2c           notConfigUser/group   $nmgroup v2c           mynetwork/" "$cfgpath/$cfgfile"

#sed -i "s/view    systemview    included   .1.3.6.1.2.1.1/#view    systemview    included   .1.3.6.1.2.1.1/" "$cfgpath/$cfgfile"
#sed -i "s/view    systemview    included   .1.3.6.1.2.1.25.1.1/view    all    included   .1 80/" "$cfgpath/$cfgfile"
sed -i "s/view    systemview    included   .1.3.6.1.2.1.25.1.1/view    systemview    included   .1.3.6.1.2.1.25.1.1\nview    all    included   .1 80/" "$cfgpath/$cfgfile"
sed -i "s/access  notConfigGroup \"\"      any       noauth    exact  systemview none none/access  $nmgroup \"\"      any       noauth    exact  all none none/" "$cfgpath/$cfgfile"

sed -i "s/#disk \/ 10000/disk \/ 10000/" "$cfgpath/$cfgfile"


# start snmpd
service snmpd restart

# check status
snmpwalk -v1 -c public localhost >giip_snmp.log

# run at restart
chkconfig snmpd on

# Logging to giip
cmsg=`cat giip_snmp.log`
qs="at=$sk&tpsn=$tpsn&ServerData=$ServerData&UserData=$cmsg"
wget "$urlapilog?$qs" -O giipTmpLog.txt

# install mrtg
yum install -y mrtg >giip_mrtg.log

# Logging to giip
cmsg=`cat giip_mrtg.log`
qs="at=$sk&tpsn=$tpsn&ServerData=$ServerData&UserData=$cmsg"
wget "$urlapilog?$qs" -O giipTmpLog.txt

#rm -f giip_snmp.log
#rm -f giip_mrtg.log
#rm -f giipTmpLog.txt
