#!/bin/bash

hand_mode=""
mode=""
list=`svn st`
for i in $list
do
	path=`echo $i |  awk '{printf $1}'`
	echo $path
	
    case $path in 
        M)
            mode="M"
            hand_mode=$mode
            continue;
        ;;
        !)
            mode="D"
            hand_mode=$mode
            continue;
        ;;
        ?)
            mode="A"
            hand_mode=$mode
            continue;
        ;;
        *)
            mode="";;
    esac
    if [[ $mode == "A" || $mode == "D" || $mode == "M" ]];then
        continue;
    fi
    
    case $hand_mode in 
        "A")
            echo "do you want add?"	
            read ans
            if [[ $ans == "y" ]];then
                svn add $i
            fi
            continue;
        ;;
        "D")
            echo "do you want delete?"	
            read ans
            if [[ $ans == "y" ]];then
                svn del $i
            fi
            continue
        ;;
        "M")
            echo "do you want delete?"	
            read ans
            if [[ $ans == "y" ]];then
                rm $i
                continue
            fi
            echo "do you want add?"	
            read ans
            if [[ $ans == "y" ]];then
                svn add $i
            fi
            continue;
        ;;
        *)
            continue;;
    esac
	





done
