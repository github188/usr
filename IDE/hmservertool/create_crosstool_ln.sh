#!/bin/sh

CROSS_TOOL_PAH=/opt/toolchain/arm-hisiv500-linux/arm-hisiv500-linux/bin
TOOL_PREFIX=arm-hisiv500-linux-uclibcgnueabi-
TARGET_PREFIX=arm-linux-

FILELIST=`ls ${CROSS_TOOL_PAH}`

for i in $FILELIST
do
    tool=${i//${TOOL_PREFIX}}
    echo "ln -s ${CROSS_TOOL_PAH}/$i ${TARGET_PREFIX}${tool}"
    ln -s ${CROSS_TOOL_PAH}/$i ${TARGET_PREFIX}${tool}
done
