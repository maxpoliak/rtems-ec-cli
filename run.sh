#!/bin/bash -eu
ROOT_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"

qemu-system-i386 -machine type=q35 \
	-m 128 -no-reboot \
	-append "--video=off --console=/dev/com1" \
	-nographic \
	-kernel ${ROOT_DIR}/ile-cli-test.exe
