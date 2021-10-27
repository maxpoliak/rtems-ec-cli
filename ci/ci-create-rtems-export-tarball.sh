#!/bin/bash -eu

RTEMS_ARCH="i386"
RTEMS_BSP="pc386"

CI_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
ROOT_DIR="${CI_DIR}/.."
RTEMS_DIR="${ROOT_DIR}/rtems_rtos"
EXPORT_DIR="${ROOT_DIR}/rtems_export"

mkdir -p ${EXPORT_DIR}
rtems_os_version_lable=$(bash ${CI_DIR}/ci-generate-version.sh rtems --arch ${RTEMS_ARCH} --bsp ${RTEMS_BSP})
echo "Export cross-tools and RTEMS object files to "
echo "${EXPORT_DIR}/rtems-export-${rtems_os_version_lable}.tar.xz"
ls ${RTEMS_DIR}/build-${rtems_os_version_lable}
tar -C ${RTEMS_DIR} -cvJf \
    ${ROOT_DIR}/rtems_export/rtems-export-${rtems_os_version_lable}.tar.gz \
    ./build-${rtems_os_version_lable} \
    ./rtems-exe
