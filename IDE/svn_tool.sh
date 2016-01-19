#!/bin/bash
toolname=$0
cmd=$1
jira=$2
filename=$2
info=$3
COLOR_R="\033[40;31;1m"
COLOR_G="\033[40;32;1m"
COLOR_B="\033[40;34;1m"
COLOR_W="\033[41;37;1;5m"
COLOR_E="\033[0m"

CODE_DIR=/home/developer/IPCamera/CODE

list=`ls ${CODE_DIR}`

function printf_help()
{
	echo "Usage: 在CODE目录下使用, 方便管理所有分支, 为2.0代码编写."
	echo "$0 [up] 更新所有代码"
	echo "$0 [ci] [jira][info] 不确认提交所有代码"
	echo "$0 [cix] [jira][info] 提交所有代码前需要确认"
	echo "$0 [show] 显示改动"
	echo "$0 [co] [filename] 按文件checkou SVN目录"
}


function upall(){
	for i in $list
	do
		if [ $i == ${toolname/.\//} ];then
			continue;
		fi
		if [ ! -d ${CODE_DIR}/$i ];then
			continue;
		fi
		cd ${CODE_DIR}/$i
		echo "svn updating ${CODE_DIR}/$i ..."
		svn up
		cd -
	done
}
#查看修改
function showall(){
	num=0;
	for i in $list
	do
		if [ $i == ${toolname/.\//} ];then
			continue;
		fi
		if [ ! -d ${CODE_DIR}/$i ];then
			continue;
		fi
		pushd ${CODE_DIR}/$i
		echo -e $COLOR_G${num}==========================================$COLOR_E
		echo "svn show ${CODE_DIR}/$i ..."
		svn st
		popd;
		echo -e $COLOR_G==========================================${num}$COLOR_E
		num=`expr ${num} + 1`
	done
}

#提交所有代码前不需要确认
function ciall(){
	for i in $list
	do
		#echo $i ${toolname/.\//}
		if [ $i == ${toolname/.\//} ];then
			continue;
		fi
		if [ ! -d ${CODE_DIR}/$i ];then
			continue;
		fi
		cd ${CODE_DIR}/$i
		echo "svn commit ${CODE_DIR}/$i ..."
			svn ci -m "$1 $2"
		cd -
	done
}

#提交所有代码前需要确认
function cixall(){
	for i in $list
	do
		#echo $i ${toolname/.\//}
		if [ $i == ${toolname/.\//} ];then
			continue;
		fi
		if [ ! -d ${CODE_DIR}/$i ];then
			continue;
		fi
		cd ${CODE_DIR}/$i
		echo -ne "svn commit ${CODE_DIR}/$i ... \033[80G[Yy/Nn]     <-   "
		read an
		if [[ $an == "Y" || $an == "y" ]];then
			svn ci -m "$1 $2"
		fi
		cd -
	done
}
#根据文件co
function svnco(){
	if [ -z $filename ]; then
		printf_help 
		exit;
	fi
	cat $filename | while read line
	do
		dir=`echo $line | awk '{print $1}'`
		svn=`echo $line | awk '{print $2}'`
		echo "======check out $svn ---> $dir======="
		if [ ! -d $dir ] ;then
			echo "$dir is not exist , mkdir"
			mkdir -p $dir
		fi
		svn co $svn $dir
	done
}

#############################
if [[ $cmd == "up" ]];then
	upall;
elif [[ $cmd == "ci" ]];then
	ciall $jira $info;
elif [[ $cmd == "cix" ]];then
	cixall $jira $info;
elif [[ $cmd == "show" ]];then
	showall;
elif [[ $cmd == "co" ]];then
	svnco;
else
	printf_help;
fi
