#!/bin/bash
#*******************************************************************************
#* Copyright (C), 2000-2014,  Streamax Technology Co., Ltd.
#* Filename:  Config.sh 
#* Author:    Lovelace.Lee
#* Version:   1.0.0
#* Date:      2014-5-21
#* BriefInfo: makefile config tool, for more infomation, please read readme.
#*******************************************************************************


function print_help()
{
    echo ""
    echo "Usage:  [args...]"
    echo "        (-help|--help):                      show help information"
    echo "        (-exec|-liba|-libso):                default [-exec]"
    echo "        (PROJECT_TYPE=c|c++):                default [c]"
    echo "        (PROJECT_NAME=main):                 default [main]"
    echo "        (CROSS_COMPILER=arm-linux-):         default []"
    echo "        (INSTALL=/usr/loca/bin):             default [./bin]"
    echo "        (-I\"path\"):                        Add one include path. "
    echo "        (-L\"path\"):                        Add one lib path."
    echo "        (-DDEFINITION):                      Add one macro definition."
    echo "        (-lLIBNAME):                         Add one lib link option."
    echo ""
}

function findfile()
{
    filename=$1;
    workdir=$2;
    cd $workdir
    list=`ls `
    for ford in $list
    do
        if [ -d $ford ];then
            findfile $filename $ford
            cd ..
        else
            if [ $ford == $filename ];then
                echo "$workdir/$ford"
            fi
        fi
    done
}
#parse ARGS
#$* all args list passed by user
function parseARGS()
{
    for arg in $*
    do
    #two arg type -arg or arg=value
        lvalue=`echo $arg | sed 's/=.*//g'`
        rvalue=`echo $arg | sed 's/.*=//g'`
        if [ -n "$arg" ];then #arg exist
            case $lvalue in
            -help|--help|--h|--he|--hel-h|-he|-hel) 
                print_help
                exit 0;;
            -exec)
                BUILDING_TYPE=exec;;
            -libso)
                BUILDING_TYPE=libso;;
            -liba)
                BUILDING_TYPE=liba;;
            C++|c++|cpp|CPP|Cpp|cPP|Cxx|cxx|CXX|cXX)
                PROJECT_TYPE="c++";;
            C|c)
                PROJECT_TYPE="c";;
            PROJECT_TYPE)
                case $rvalue in
                    C|c) 
                    PROJECT_TYPE="c";;
                    C++|c++|cpp|CPP|Cpp|cPP|Cxx|cxx|CXX|cXX)
                    PROJECT_TYPE="c++"
                esac;;
            PROJECT_NAME)
                PROJECT_NAME=$rvalue;;
            CROSS_COMPILER) 
                CROSS_COMPILER=$rvalue;;
            INSTALL)
                INSTALL_DIR=$rvalue;;
            -Werror|-g)
                m_a_k_e_o_p_t_i_o_n=._._.;;
            *) 
                arg=${lvalue:0:2}
                case $arg in
                    -I|-l|-D|-L) 
                    d_e_f_i_n_i_t_i_o_n=d_o_e_n_d
                    ;;
                    *) 
                    echo "Unknown option $lvalue"
                    return 110
                    ;;
                esac
            esac
        fi
    done
}
#include std.sh
#You can install this std.sh and config.sh to system envrionment
#Use this command more convinient
stdfun=`findfile std.sh .`
if [[ ! -e ${stdfun} ]];then
    echo "Can not find stdfun."
    exit 1;
else
    . ${stdfun}
fi
#parse args, start first
parseARGS $*;
if [ $? == 110 ];then
    #need help
    print_help
    exit 1;
fi

#null project
isnullproject $PROJECT_DIR;
if [ $? == 4 ];then
    echo "Project is null, without any source code file."
    exit 1;
fi

echo ""
echo "Configuring start ..."
#Cross compiler
if [ -n $CROSS_COMPILER ];then
    CC=$CROSS_COMPILER$CC
    echo "Set C compiler to $CC"
    CXX=$CROSS_COMPILER$CXX
    echo "Set C++ compiler to $CXX"
fi
echo "Set project type to \"$PROJECT_TYPE\""
echo "Use objs dir as compiler building directory? \"$USE_OBJSDIR\""
echo "Set building type to \"$BUILDING_TYPE\""
echo "Set project name to \"$PROJECT_NAME\""
echo "Set install directory to \"$INSTALL_DIR\"" 
if [ ! -d $INSTALL_DIR ];then
    mkdir -p $INSTALL_DIR
fi
if [ ! -d $BIN_DIR ];then
    mkdir -p $BIN_DIR
fi
#-I
for arg in $*
do
    if [ -n "$arg" ];then
        if [[ ${arg:0:2} == "-I" ]];then
            incpath=${arg#*I}
            INCS=-I\"$incpath\"\ $INCS
        fi
    fi
done
echo "Set include path as $INCS"
#-L
for arg in $*
do
    if [ -n "$arg" ];then
        if [[ ${arg:0:2} == "-L" ]];then
            libpath=${arg#*L}
            LIBS=-L\"$libpath\"\ $LIBS
        fi
    fi
done
echo "Set lib link path as $LIBS"
#Find -D options
for arg in $*
do
    if [ -n "$arg" ];then
        if [[ ${arg:0:2} == "-D" ]];then
            DEFS=$arg\ $DEFS
        fi
    fi
done
echo "Set precompile defines as \"$DEFS\""
#Find -l options
for arg in $*
do
    if [ -n "$arg" ];then
        case $arg in
        -liba|-libso)
            donothing=doend
            ;;
        *)
            if [[ ${arg:0:2} == "-l" ]];then
                LDFLAGS=$arg\ $LDFLAGS
            fi
            ;;
        esac
    fi
done
echo "Set linker flags as \"$LDFLAGS\""
#Find make parameters
for arg in $*
do
    if [ -n "$arg" ];then
        case $arg in
            -Werror)
                CCFLAGS=$CCFLAGS\ $arg
                CXXFLAGS=$CXXFLAGS\ $arg
            ;;
            -g)
                CCFLAGS=$CCFLAGS\ $arg
                CXXFLAGS=$CXXFLAGS\ $arg
                LDFLAGS=$LDFLAGS\ $arg
                USESTRIP=N
            ;;
        esac
    fi
done
echo "Set C compiler flags \"$CCFLAGS\""
echo "Set C++ compiler flags \"$CXXFLAGS\""
generatemakefile $PROJECT_TYPE $BUILDING_TYPE $PROJECT_NAME; 

# debug
#echo "all *.o filelist = $OBJSLIST"

echo "Configure successful. Use make to compile the project."
echo
