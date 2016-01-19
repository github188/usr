#!/bin/bash

if [[ $UID -ne 0 ]];then
	echo "!! Root permission is requested"
	exit
fi

source /etc/profile

if [[ ! $LOVELACE_ENV == "" ]];then
	echo "env already exist"
	exit;
fi

echo "PATH=\$PATH:/usr/local/bin/lovelacelee:/usr/local/bin/lovelacelee/bin/" >> /etc/profile
echo "set profile PATH=$PATH"

if [ ! -f env ];then
	echo "env is not exist"
	exit;
fi

echo "install env"
cat ./env >> /etc/profile

echo "install ok"
