#!/bin/bash -eu

RTEMS_ARCH="i386"
RTEMS_BSP="pc386"

ROOT_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
RTEMS_DIR="${ROOT_DIR}/rtems_rtos"
RTEMS_VERSION="5.1"
OUT_EXE_NAME="rtems-ec-cli.exe"
FLAG_BUILD_ALL=0
FLAG_CLEAR_ALL=0
FLAG_REBUILD_APP=0
FLAG_BUILD_RTEMS=0
FLAG_BUILD_CROSS=0

function get_version_lable_proj
{
   version_rtems=$(git -C ${RTEMS_DIR}/rtems describe --always --abbrev=6)
   version_base=$(git -C ${ROOT_DIR} describe --tags --dirty --abbrev=4)
   branch=$(git -C ${ROOT_DIR} branch --show-current)
   echo ${RTEMS_ARCH}"-"${RTEMS_BSP}"-"$version_rtems"-"$branch"-"$version_base
}

function build_cross_compiler
{
    rm -Rf ${RTEMS_DIR}/rtems-exe
    echo "#########################################################"
    echo "  Build cross-compiler ..."
    echo "#########################################################"
    cd ${RTEMS_DIR}/rtems-source-builder
    source-builder/sb-check
    cd rtems
    ../source-builder/sb-set-builder \
        --log=log-${RTEMS_ARCH}.txt \
        --prefix=${RTEMS_DIR}/rtems-exe \
        5/rtems-${RTEMS_ARCH}.bset

    export PATH=${RTEMS_DIR}/rtems-exe/bin:$PATH
    export PATH=${RTEMS_DIR}/rtems-exe/${RTEMS_ARCH}-rtems5/bin:$PATH
}

function build_rtems_os
{
    rm -Rf ${RTEMS_DIR}/tmp ${RTEMS_DIR}/build
    export PATH=${RTEMS_DIR}/rtems-exe/bin:$PATH
    export PATH=${RTEMS_DIR}/rtems-exe/${RTEMS_ARCH}-rtems5/bin:$PATH
    echo "#########################################################"
    echo "  Build RTEMS OS  ..."
    echo "#########################################################"
    cd ${RTEMS_DIR}/rtems
    export LC_ALL="en_US.UTF-8"
    ./bootstrap -c
    ./bootstrap -H && ${RTEMS_DIR}/rtems-source-builder/source-builder/sb-bootstrap
    mkdir -p ${RTEMS_DIR}/tmp; cd ${RTEMS_DIR}/tmp
    ${RTEMS_DIR}/rtems/rtems-bsps
    ${RTEMS_DIR}/rtems/configure --target=${RTEMS_ARCH}-rtems5 \
        --prefix=${RTEMS_DIR}/build \
        --disable-multiprocessing \
        --disable-cxx \
        --disable-rdbg \
        --enable-maintainer-mode \
        --enable-tests \
        --enable-networking \
        --enable-posix \
        --disable-itron \
        --disable-deprecated \
        --disable-ada \
        --disable-expada \
        --enable-rtemsbsp=${RTEMS_BSP} \
        USE_COM1_AS_CONSOLE=1 \
        BSP_PRESS_KEY_FOR_RESET=0
    make all
    make install
}

function build_application
{
    cd ${ROOT_DIR}
    ${ROOT_DIR}/waf --project-version=$(get_version_lable_proj) \
        configure --rtems=${RTEMS_DIR}/build \
        --rtems-tools=${RTEMS_DIR}/rtems-exe \
        --rtems-bsps=${RTEMS_ARCH}/${RTEMS_BSP}
    ${ROOT_DIR}/waf --version
    ${ROOT_DIR}/waf -vvv
    cp ${ROOT_DIR}/build/${RTEMS_ARCH}-rtems5-${RTEMS_BSP}/${OUT_EXE_NAME} \
        ${ROOT_DIR}/${OUT_EXE_NAME}
    tar -C ${ROOT_DIR} -zcvf ${ROOT_DIR}/$(get_version_lable_proj).tar.gz ${OUT_EXE_NAME}
}

function print_help
{
    echo "Use $0 [COMMANDS...]"
    echo "  all         Build all: cross-compiler, RTEMS OS and ile-cli application"
    echo "  rtems       Build RTEMS OS"
    echo "  cross       Build cross-compiler"
    echo "  cleanall    Clear all"
    echo "  rebuild     Set rebuils flag"
    echo "              Delete the application's object files before building it"
    echo "  help        Print help"
}

while [ "${1:-}" != "" ]; do
    case "$1" in
        "all")
            FLAG_BUILD_ALL=1
            break
            ;;
        "rtems")
            FLAG_BUILD_RTEMS=1
            break
            ;;
        "cross")
            FLAG_BUILD_CROSS=1
            break
            ;;
        "cleanall")
            FLAG_CLEAR_ALL=1
            break
            ;;
        "rebuild")
            FLAG_REBUILD_APP=1
            break
            ;;
        "help")
            print_help
            exit 0
            ;;
        *)
            echo "invalid command ($1)"
            print_help
            exit 1
            ;;
    esac
done

if [[ ${FLAG_CLEAR_ALL} -eq 1 ]] ; then
    echo "#########################################################"
    echo "  Clean all ..."
    echo "#########################################################"
    rm -rf ${ROOT_DIR}/${OUT_EXE_NAME} ${ROOT_DIR}/build/ ${RTEMS_DIR}
    exit 0
fi;

if [[ ${FLAG_BUILD_CROSS} -eq 1 ]] ; then
    build_cross_compiler
    exit 0
fi;

if [[ ${FLAG_BUILD_RTEMS} -eq 1 ]] ; then
    build_rtems_os
    exit 0
fi;

if [[ ${FLAG_BUILD_ALL} -eq 1 ]] ; then
    build_cross_compiler
    build_rtems_os
fi;

if [[ ${FLAG_REBUILD_APP} -eq 1 ]] ; then
    rm -rf ${ROOT_DIR}/${OUT_EXE_NAME} \
        ${ROOT_DIR}/build/ \
        ${ROOT_DIR}/$(get_version_lable_proj).tar.gz
fi;

build_application

exit 0
