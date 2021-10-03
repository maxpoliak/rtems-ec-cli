#!/bin/bash

ROOT_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
RTEMS_DIR="${ROOT_DIR}/rtems-rtos"
RTEMS_VERSION="5.1"

git submodule update --init --checkout
curl https://waf.io/waf-2.0.19 > ${ROOT_DIR}/waf
chmod +x ${ROOT_DIR}/waf
${ROOT_DIR}/waf --version

mkdir -p ${RTEMS_DIR}; cd ${RTEMS_DIR}
git clone git://git.rtems.org/rtems-source-builder.git -b ${RTEMS_VERSION}
# git clone git://git.rtems.org/rtems.git -b ${RTEMS_VERSION}
git clone https://github.com/maxpoliak/rtems.git -b ile-cli
