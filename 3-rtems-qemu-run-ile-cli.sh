#!/bin/bash

export WORKSPACE=$(pwd)/rtems-rtos

qemu-system-i386 -machine type=q35 \
	-m 128 -no-reboot \
	-append "--video=off --console=/dev/com1" \
	-nographic \
	-kernel ./build/i386-rtems5-pc386/ile-cli-test.exe
