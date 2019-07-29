#!/usr/bin/bash

#ROOTがSSHでログインできるかチェック
function isRootLogin(){
permitRootLogin=`grep -e "PermitRootLogin\syes" -e "#PermitRootLogin" /etc/ssh/sshd_config.org`
if [ -n "${permitRootLogin}" ]; then
yesOrNo=`echo $permitRootLogin | cut -d' ' -f2`
if [ -n "${yesOrNo}" ] && [ $yesOrNo = 'yes' ]; then
echo 1
else 
echo 0
fi
fi
}


#ユーザが作成されているかチェック
function isUsers(){
USERS=(`grep bash /etc/passwd | cut -d: -f1`)
if [ ${#USERS[@]} -gt 1 ] ; then
echo 1
else 
echo 0
fi
}

#sshd_configのPermitRootLoginを変更
function fixSshdConfig(){
# fix
sed -i -e 's/PermitRootLogin yes/PermitRootLogin no/g' -i -e 's/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config.org
# restart
systemctl restart sshd.service
# end
echo 'ROOTログインを廃止しました'
}


# ----Shell開始----
# user check
if [ 1 = "`isUsers`" ] ; then

isRootLogin
#ssh root login check
if [ 1 = "`isRootLogin`" ] ; then
# root ssh check
fixSshdConfig
else
echo 'ROOTユーザログイン廃止設定済みです'
fi

else
echo 'ユーザを作成してください'
fi

# ----終了----

