#!/sbin/sh
# 151113 Lowy
# ver.0.9
# script for giip automation

# System Variables
sk="{{sk}}"
lssn="{{lssn}}"
urlapilog="http://giip.littleworld.net/API/message/put"
qs="at=$sk&tpsn=$tpsn&ServerData=${#checkfile}&UserData=$checkfile"

# All install 
yum install -y httpd mysql-server mysql php php-devel php-pear php-mysql php-mbstring php-gd
cmsg="APM Install complete"
qs="at=$sk&tpsn=$tpsn&ServerData=$ServerData&UserData=$cmsg"
wget "$urlapilog?$qs" -O giipTmpLog.txt

# backup config
cp -av /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.ori
# KeepAlive on for mid-size web service
sed -i 's/KeepAlive Off/KeepAlive On/' /etc/httpd/conf/httpd.conf
# Hide non-hostname warning message
sed -i 's/#ServerName www.example.com:80/ServerName 127.0.0.1:80/' /etc/httpd/conf/httpd.conf
# Fix error for non-utf8
sed -i 's/AddDefaultCharset UTF-8/#AddDefaultCharset UTF-8/' /etc/httpd/conf/httpd.conf
# Hide Apache Version
sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/httpd/conf/httpd.conf
sed -i 's/ServerSignature On/ServerSignature Off/' /etc/httpd/conf/httpd.conf
# check config to log
grep -P 'KeepAlive O|^ServerName|AddDefaultCharset|ServerTokens|ServerSignature' /etc/httpd/conf/httpd.conf >giipTmpText.txt
cmsg=`cat giipTmpText.txt`
qs="at=$sk&tpsn=$tpsn&ServerData=$ServerData&UserData=$cmsg"
wget "$urlapilog?$qs" -O giipTmpLog.txt


# backup php.ini
cp -av /etc/php.ini /etc/php.ini.ori
# check php.ini
grep -P 'short_open_tag =|expose_php =|date.timezone =|register_globals =|register_long_arrays =|magic_quotes_gpc =|allow_call_time_pass_reference =|error_reporting =|display_errors =|display_startup_errors =' /etc/php.ini
# Normal config
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = "Asia\/Seoul"/' /etc/php.ini
sed -i 's/allow_call_time_pass_reference = Off/allow_call_time_pass_reference = On/' /etc/php.ini
# Hide php version
sed -i 's/expose_php = On/expose_php = Off/' /etc/php.ini
# Show error
sed -i 's/display_errors = Off/display_errors = On/' /etc/php.ini
sed -i 's/display_startup_errors = Off/display_startup_errors = On/' /etc/php.ini
# Change error level
sed -i 's/error_reporting = E_ALL \& ~E_DEPRECATED/error_reporting = E_ALL \& ~E_NOTICE \& ~E_DEPRECATED \& ~E_USER_DEPRECATED/' /etc/php.ini
# Environment (Must check from solution vendor)
sed -i 's/register_globals = Off/register_globals = On/' /etc/php.ini
sed -i 's/magic_quotes_gpc = Off/magic_quotes_gpc = On/' /etc/php.ini
# Check configuration
grep -P 'short_open_tag =|expose_php = |date.timezone =|register_globals =|register_long_arrays =|magic_quotes_gpc =|allow_call_time_pass_reference =|error_reporting =|display_errors =|display_startup_errors =' /etc/php.ini >giipTmpText.txt
cmsg=`cat giipTmpText.txt`
qs="at=$sk&tpsn=$tpsn&ServerData=$ServerData&UserData=$cmsg"
wget "$urlapilog?$qs" -O giipTmpLog.txt


# Start apache
/etc/init.d/httpd start
# Set start apache when system restarted
/sbin/chkconfig httpd on

# MySQL config backup
cp -av /etc/my.cnf /etc/my.cnf.ori
# Tune for memory
cp -av /usr/share/mysql/my-huge.cnf /etc/my.cnf
# Change for next version
sed -i 's/skip-locking/skip-external-locking/' /etc/my.cnf

# Start MySQL
/etc/init.d/mysqld start
# Set start mysqld when system restarted
/sbin/chkconfig mysqld on
# Set secure config
# Set manual input root password
# /usr/bin/mysql_secure_installation
# Enter mysql
# mysql -uroot -p
cmsg="Started apache & MySQL !! Set manual config by secure.. /usr/bin/mysql_secure_installation"
qs="at=$sk&tpsn=$tpsn&ServerData=$ServerData&UserData=$cmsg"
wget "$urlapilog?$qs" -O giipTmpLog.txt
