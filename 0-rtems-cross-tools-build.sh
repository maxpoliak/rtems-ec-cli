#!/bin/bash

export WORKSPACE=$(pwd)/rtems-rtos

mkdir -p $WORKSPACE; cd $WORKSPACE
git clone git://git.rtems.org/rtems-source-builder.git -b 5.1
cd rtems-source-builder
source-builder/sb-check
cd rtems
../source-builder/sb-set-builder \
	--log=log-i386.txt \
	--prefix=$WORKSPACE/rtems-exe \
	5/rtems-i386.bset
