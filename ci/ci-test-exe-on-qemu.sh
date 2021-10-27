#!/bin/bash

CI_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
ROOT_DIR="${CI_DIR}/.."

filename=$(basename ${ROOT_DIR}/*.exe)
echo "Run ${filename} on QEMU"
qemu-system-i386 -machine type=q35 -m 128 -no-reboot -append "--video=off --console=/dev/com1" -nographic -kernel ${ROOT_DIR}/$filename
