#!/bin/sh


GITROOT=/opt/nfshost/serverdisk
GITCMD=$1

function gitstatus()
{
    local project=$1
    cd $project
    git status
    cd ..
}

function gitpush()
{
    local project=$1
    cd $project
    echo -ne "Need push ?[Y/y]: "
    read y
    if [[ $y == "Y" ]] || [[ $y == "y" ]];then
    git add *
    git commit -a
    git push
    fi
    cd ..
}

function gitwork()
{
    local workdir=$1;
    cd $workdir
    local list=`ls `
    for ford in $list
    do
        if [ -d $ford ];then
            echo "=========${workdir}/${ford}========="
            case $GITCMD in
            status)
                gitstatus ${workdir}/${ford}
                ;;
            push)
                gitstatus ${workdir}/${ford}
                gitpush ${workdir}/${ford}
                ;;
            *)
                gitstatus ${workdir}/${ford}
                ;;
            esac
        else
            echo "Jump file ${workdir}/${ford}"
        fi
    done
}

function workthrough()
{
    local workdir=$1;
    cd $workdir
    local list=`ls `
    for ford in $list
    do
        if [ -d $ford ];then
            gitwork ${workdir}/${ford}
            cd ..
        else
            echo "Jump file ${workdir}/${ford}"
        fi
    done
}



## main

if [ $GITCMD == "help" ] || [ $GITCMD == "--help" ] || [ $GITCMD == "-help" ] || [ $GITCMD == "h" ];then
    echo "Usage: $0 [status|push|help]"
    exit
fi

# show tree
tree -L 2 -d $GITROOT

workthrough $GITROOT


