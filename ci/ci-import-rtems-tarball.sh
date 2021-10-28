#!/bin/bash -eu

RTEMS_ARCH="i386"
RTEMS_BSP="pc386"

CI_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
ROOT_DIR="${CI_DIR}/.."
RTEMS_DIR="${ROOT_DIR}/rtems_rtos"

rtems_os_version=$(bash ${CI_DIR}/ci-generate-version.sh rtems --arch ${RTEMS_ARCH} --bsp ${RTEMS_BSP})
proj_version=$(bash ${CI_DIR}/ci-generate-version.sh --arch ${RTEMS_ARCH} --bsp ${RTEMS_BSP})
proj_release=$(git -C ${ROOT_DIR} describe --abbrev=0 --tags)
url="https://github.com/maxpoliak/rtems-ec-cli/releases/download/${proj_release}/rtems-export-${rtems_os_version}.tar.xz"
rtems_tarball_path="${RTEMS_DIR}/rtems-export-${rtems_os_version}.tar.xz"

function print_help() {
    echo "Use $0 COMMANDS [OPTIONS...]"
    echo "  Check the url $url"
    echo "  If it exists and contains a tarball with RTEMS binary files and cross-compiler,"
    echo "  then download the archive with this and install it in the last project."
    echo " "
    echo "  Returns <does-not-exist> if the tarball does not exist otherwise path to the tarball"
    echo " "
    echo "    --arch   <architecture>  Set CPU architecture (${RTEMS_ARCH} by default)"
    echo "    --bsp    <bsp>           Set board support package (${RTEMS_BSP} by default)"
    echo "    --help                   Print help"
}

while [ "${1:-}" != "" ]; do
    case "$1" in
        "--arch")
            RTEMS_ARCH=$2
            shift 2
            ;;
        "--bsp")
            RTEMS_BSP=$2
            shift 2
            ;;
       "-h" | "--help")
            print_help
            exit 0
            ;;
        *)
            echo "invalid command or option ($1)"
            print_help
            exit 1
            ;;
    esac
done

if [ -f "$rtems_tarball_path" ]; then
    echo "exist"
elif wget --quiet --spider "${url}"; then
    mkdir -p ${RTEMS_DIR} && cd ${RTEMS_DIR}
    wget --quiet ${url}
    echo "${rtems_tarball_path}"
else
    echo "does-not-exist"
fi
