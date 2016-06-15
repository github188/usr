#!/bin/bash
toolname=$0

COLOR_R="\033[40;31;1m"
COLOR_G="\033[40;32;1m"
COLOR_B="\033[40;34;1m"
COLOR_W="\033[41;37;1;5m"
COLOR_E="\033[0m"

# 开启网络
echo -ne $COLOR_G"==config network==\n"$COLOR_E
ifconfig enp2s0 up
# 重启smb
echo -ne $COLOR_G"==config samba==\n"$COLOR_E
chmod 755 /var/cache/samba/msg
systemctl start nmbd.service
systemctl start smbd.service

#rm -rf /tmp/ipc.build.dir

while [ 1 ]
do  
TM_H=`date +%H`
TM_M=`date +%M`
TM_S=`date +%S`
if [ $TM_H == "05" ] && [ $TM_M == "59" ] && [ $TM_S == "59" ];then
    echo -ne $COLOR_B"auto reboot server\n"$COLOR_E
    reboot;
fi

#echo -ne $COLOR_G"==wait reboot cond $TM_H:$TM_M:$TM_S==\n"$COLOR_E
echo "==wait reboot cond $TM_H:$TM_M:$TM_S==" > /tmp/audo_server_reboot.log
sleep 1;
done


