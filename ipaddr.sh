
ifconfig eth0 |grep "inet addr:" |awk '{print $2}'|cut -c 6-

