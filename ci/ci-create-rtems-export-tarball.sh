#!/bin/bash -eu

RTEMS_ARCH="i386"
RTEMS_BSP="pc386"

CI_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
ROOT_DIR="${CI_DIR}/.."
RTEMS_DIR="${ROOT_DIR}/rtems_rtos"
EXPORT_DIR="${ROOT_DIR}/rtems_export"

function get_version_lable_rtems_os
{
   base=$(git -C ${RTEMS_DIR}/rtems describe --tags --dirty)
   branch=$(git -C ${RTEMS_DIR}/rtems branch | grep \* | cut -d ' ' -f2-)
   echo ${RTEMS_ARCH}"-"${RTEMS_BSP}"-"$branch"-"$base
}

mkdir -p ${EXPORT_DIR}
echo "Export cross-tools and RTEMS object files to "
echo "${EXPORT_DIR}/rtems-export-$(get_version_lable_rtems_os).tar.gz"
ls ${RTEMS_DIR}/build-$(get_version_lable_rtems_os)
tar -C ${RTEMS_DIR} -zcvf \
    ${ROOT_DIR}/rtems_export/rtems-export-$(get_version_lable_rtems_os).tar.gz \
    ./build-$(get_version_lable_rtems_os) \
    ./rtems-exe
