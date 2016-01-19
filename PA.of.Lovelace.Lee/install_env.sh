#!/bin/bash

if [[ $UID -ne 0 ]];then
	echo "!! Root permission is requested"
	exit
fi

if [ ! -z $1 ];then
	cp $1 env -vf
fi

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

echo "you must run `source /etc/profile` manually "
echo LOVELACE_ENV: ${LOVELACE_ENV}
echo LOVELACE_BACKUP_DIR: ${LOVELACE_BACKUP_DIR}
echo LOVELACE_BIN_DIR: ${LOVELACE_BIN_DIR}
echo LOVELACE_PA_DIR: ${LOVELACE_PA_DIR}
rm env -f
