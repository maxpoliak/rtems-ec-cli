#!/bin/bash

CI_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
ROOT_DIR="${CI_DIR}/.."

disk_img_name=$(basename ${ROOT_DIR}/*.img)
coreboot_img_name=$(basename ${ROOT_DIR}/*.rom)
echo "Use ${disk_img_name} disk image file and ${coreboot_img_name} to test on QEMU"
qemu-system-i386 -m 128 \
    -bios ${ROOT_DIR}/${coreboot_img_name} \
    -hda ${ROOT_DIR}/${disk_img_name} \
    -M q35 \
    -nographic
