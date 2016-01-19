
#*******************************************************************************
#* Copyright (C), 2000-2014,  Streamax Technology Co., Ltd.
#* Filename:  Readme
#* Author:    Lee
#* Version:   1.0.0
#* Date:      2014-5-21
#* BriefInfo: 
#*******************************************************************************
#修改记录：
#   INCS手动添加功能 2013.10.14
#   LIBS手动添加功能 2013.10.14
#   手动配置-g -Werror选项,有-g选项时,不strip 2013.12.12
#   在源码目录下生成makefile工程文件
#   所有的头文件目录均命名为include
#   所有的库目录均命名为lib

#功能说明：
#   递归查找项目根目录及其子目录下所有的include目录列表作为-I选项
#   递归查找项目根目录及其子目录下所有的lib目录列表作为-L选项
#   递归查找项目根目录及其子目录下所有的目录，并在其中生成c/c++项目的makefile
#   生成主makefile管理所有的OBJS文件列表

#支持选项：
# "Usage:  makeconfigure [args...]"
# "        (-help|--help):                      show help information"
# "        (-exec|-liba|-libso):                default [-exec]"
# "        (PROJECT_TYPE=c|c++):                default [c]"
# "        (PROJECT_NAME=main):                 default [main]"
# "        (CROSS_COMPILER=arm-linux-):         default []"
# "        (INSTALL=/usr/loca/bin):             default [./bin]"
# "        (-I\"path\"):                        Add one include path. "
# "        (-L\"path\"):                        Add one lib path."
# "        (-DDEFINITION):                      Add one macro definition."
# "        (-lLIBNAME):                         Add one lib link option."



