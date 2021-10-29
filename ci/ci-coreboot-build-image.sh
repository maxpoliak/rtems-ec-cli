#!/bin/bash

CI_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
ROOT_DIR="${CI_DIR}/.."
COREBOOT_DIR="${ROOT_DIR}/coreboot"
build_on_cpus=8

function print_help() {
    echo "Use $0 COMMANDS [OPTIONS...]"
    echo "  Build coreboot image"
    echo " "
    echo "       --cpus <number of cores>"
    echo "  -h | --help         Print help"
}

while [ "${1:-}" != "" ]; do
    case "$1" in
        "--cpus")
            build_on_cpus=$2
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

git clone https://review.coreboot.org/coreboot ${COREBOOT_DIR} && cd ${COREBOOT_DIR}
git submodule update --init --checkout
make crossgcc-i386 CPUS=$build_on_cpus
make distclean
touch .config
./util/scripts/config --enable CONFIG_VENDOR_EMULATION
./util/scripts/config --enable CONFIG_BOARD_EMULATION_QEMU_X86_Q35
make olddefconfig
make
cversion=$(git -C ${COREBOOT_DIR} describe --tag)
cp ${COREBOOT_DIR}/build/coreboot.rom ${ROOT_DIR}/${cversion}-x86-p35-coreboot.rom
