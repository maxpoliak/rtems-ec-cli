#!/bin/bash

export WORKSPACE=$(pwd)/rtems-rtos

mkdir -p $WORKSPACE; cd $WORKSPACE
git clone git://git.rtems.org/rtems-source-builder.git -b 5.1
cd rtems-source-builder
source-builder/sb-check
cd rtems
../source-builder/sb-set-builder --log=log-i386.txt --prefix=$WORKSPACE/rtems-exe 5/rtems-i386.bset
export PATH=$WORKSPACE/rtems-exe/bin:$PATH
export PATH=$WORKSPACE/rtems/rtems-exe/i386-rtems5/bin:$PATH
cd $WORKSPACE
git clone git://git.rtems.org/rtems.git -b 5.1
cd rtems
export LC_ALL="en_US.UTF-8"
./bootstrap -c && ./bootstrap -H && $WORKSPACE/rtems-source-builder/source-builder/sb-bootstrap
mkdir -p $WORKSPACE/tmp; cd $WORKSPACE/tmp
$WORKSPACE/rtems/rtems-bsps
$WORKSPACE/rtems/configure --target=i386-rtems5 \
	--prefix=$WORKSPACE/build --disable-multiprocessing \
	--disable-cxx --disable-rdbg \
	--enable-maintainer-mode --enable-tests \
	--enable-networking --enable-posix \
	--disable-itron --disable-deprecated \
	--disable-ada --disable-expada \
	--enable-rtemsbsp=pc386 \
	USE_COM1_AS_CONSOLE=1 BSP_PRESS_KEY_FOR_RESET=0
make all
make install
