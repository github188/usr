#!/bin/bash

if [[ $UID -ne 0 ]];then
	echo "!! Root permission is requested"
	exit
fi

if [ ! -z $1 ];then
	cp $1 env -vf
fi
source /etc/profile

if [[ ! $LOVELACE_ENV == "" ]];then
	echo "env already exist"
	exit;
fi


if [ ! -f env ];then
	echo "env is not exist"
	exit;
fi

echo "set profile PATH=$PATH"
echo "PATH=\$PATH:/usr/local/bin/lovelacelee:/usr/local/bin/lovelacelee/bin/" >> /etc/profile
echo "install env"
cat ./env >> /etc/profile

echo "install ok"

source /etc/profile
rm env -f
