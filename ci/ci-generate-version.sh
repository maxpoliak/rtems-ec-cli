#!/bin/bash -eu

RTEMS_ARCH="i386"
RTEMS_BSP="pc386"

CI_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
ROOT_DIR="${CI_DIR}/.."
RTEMS_DIR="${ROOT_DIR}/rtems_rtos"
FLAG_RTEMS_VERSION=0

function print_help() {
    echo "Use $0 COMMANDS [OPTIONS...]"
    echo "Generates a project version label according to the following rules:"
    echo "  <architecture>-<bsp>-<rtems git tag>-<current branch>-<git tag>"
    echo " "
    echo "  rtems                    Generate RTEMS version lable"
    echo "                           <architecture>-<bsp>-<builder git tag>-<current branch>-<rtems git tag>"
    echo "  --arch   <architecture>  Set CPU architecture (${RTEMS_ARCH} by default)"
    echo "  --bsp    <bsp>           Set board support package (${RTEMS_BSP} by default)"
    echo "  --branch <git-branch>    Set current git branch name for workflow action"
    echo "  --help                   Print help"
}

function get_version_lable_rtems_os() {
    base=$(git -C ${RTEMS_DIR}/rtems describe --tags --dirty)
    branch=$(git -C ${RTEMS_DIR}/rtems symbolic-ref -q --short HEAD)
    builder=$(git -C ${RTEMS_DIR}/rtems-source-builder describe --always --dirty)
    echo ${RTEMS_ARCH}"-"${RTEMS_BSP}"-"$builder"-"$1"-"$base
}

function get_version_lable_proj() {
    version_rtems=$(git -C ${RTEMS_DIR}/rtems describe --always --abbrev=6)
    version_base=$(git -C ${ROOT_DIR} describe --tags --dirty --abbrev=4)
    echo ${RTEMS_ARCH}"-"${RTEMS_BSP}"-"$version_rtems"-"$1"-"$version_base
}

branch=$(git -C ${ROOT_DIR} symbolic-ref -q --short HEAD)

while [ "${1:-}" != "" ]; do
    case "$1" in
        "rtems")
            FLAG_RTEMS_VERSION=1
            branch=$(git -C ${RTEMS_DIR}/rtems symbolic-ref -q --short HEAD)
            shift 1
            ;;
        "--arch")
            RTEMS_ARCH=$2
            shift 2
            ;;
        "--bsp")
            RTEMS_BSP=$2
            shift 2
            ;;
        "--branch")
            branch=$2
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

if [[ ${FLAG_RTEMS_VERSION} -eq 1 ]] ; then
    get_version_lable_rtems_os ${branch}
else
    get_version_lable_proj ${branch}
fi;
