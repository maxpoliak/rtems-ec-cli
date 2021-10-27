#!/bin/bash

CI_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
ROOT_DIR="${CI_DIR}/.."

filename=$(basename ${ROOT_DIR}/*.img)
echo "Use ${filename} disk image file to test on QEMU"
qemu-system-i386 -m 128 -hda ${ROOT_DIR}/${filename} -M q35 -nographic
