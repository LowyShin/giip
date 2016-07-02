crontab -l
(crontab -l ; echo "# 160701 Lowy, for giip")| crontab -
(crontab -l ; echo "* * * * * bash --login -c 'sh /usr/local/scripts/giipAgent.sh'")| crontab -
crontab -l
