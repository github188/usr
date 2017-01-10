###
# Created by Lovelace.Lee(lovelacelee@gmail.com)
# On 2016.12.12
###

#!/bin/sh

INPUT=""
SIZE=""
NAME=""
HANDLE=""

function print_help()
{
    echo ""
    echo "Usage:  sclicetar.sh [args...]"
    echo "        -p:   Packages combine to one single file."
    echo "        -x:   Extract single file to multi-slices."
    echo "        -f:   Input file for [-x]."    
    echo "        -s:   Size of every data-slice."
    echo "        -n:   Filename for [-p]."
    echo ""
}

function x_option()
{
    echo "Extract [$INPUT] with [$SIZE] slices."
    tar cjf - $INPUT | split -d -b $SIZE - $NAME.tar.bz2.
}

function p_option()
{
    echo "Package with slices to [$NAME]."
    cat $NAME.tar.bz2.* | tar xj
}

function argsparser()
{
    if [ $# -lt 1 ]; then
        print_help
        exit 0;
    fi    
    for arg in $*
    do
        lvalue=`echo $arg | sed 's/=.*//g'`
        rvalue=`echo $arg | sed 's/.*=//g'`
        if [ -n "$arg" ];then #arg exist
            case $lvalue in
            -help|--help|--h|--he|--hel-h|-he|-hel) 
                print_help
                exit 0;;
            -p)
                if [ -z $HANDLE ];then
                    HANDLE="p_option";
                else
                    echo "[-x] is aready defined."
                    exit
                fi
                ;;
            -x)
                if [ -z $HANDLE ];then
                    HANDLE="x_option";
                else
                    echo "[-p] is aready defined."
                    exit
                fi
                ;;
            -f)
                INPUT=$rvalue;;
            -s)
                SIZE=$rvalue;;
            -n)
                NAME=$rvalue;;
            *) 
                print_help
                exit 0;;
            esac
        fi
    done
}

argsparser $*;

echo "HANDLE:   $HANDLE"
echo "INPUT:    $INPUT"
echo "NAME:     $NAME"
echo "SIZE:     $SIZE"   

eval "$HANDLE";

