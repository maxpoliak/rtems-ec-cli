#!/bin/bash

export WORKSPACE=$(pwd)/rtems-rtos

git clone git://git.rtems.org/rtems_waf.git
curl https://waf.io/waf-2.0.19 > waf
chmod +x waf

./waf configure --rtems=$WORKSPACE/build \
	--rtems-tools=$WORKSPACE/rtems-exe \
	--rtems-bsps=i386/pc386
./waf
