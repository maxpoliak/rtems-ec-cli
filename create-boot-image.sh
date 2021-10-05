#!/bin/bash -eu

IMAGE_NAME=
ROOT_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
OUT_EXE_NAME="rtems-ec-cli.exe"
MOUNT_DIR_NAME="rtems-boot-disk-image"

function print_help
{
    echo "Use $0 OPTIONS..."
    echo "  -f | --file       Set the path to the image file"
    echo "  -v | --verbose    Print verbosity info"
    echo "  -h | --help       Print help"
}

if (( $(id -u) != 0 ))
then
    echo "Must be run as root" 1>&2
    echo "==================="
    exit 1
fi

if [[ $# -eq 0 ]]; then
    print_help
    exit 0
fi

while [ "${1:-}" != "" ]; do
    case "$1" in
        "-f" | "--file")
            IMAGE_NAME=$2
            echo "Use ${IMAGE_NAME} to create a bootable image"
            shift 2
            ;;
        "-v" | "--verbose")
            set -v
            shift 1
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

loopdev0=$(/sbin/losetup -f)
echo "1. Use $loopdev0 to mount ${IMAGE_NAME}"
losetup $loopdev0 ${IMAGE_NAME}

echo "2. Create the partition table"
set +e
fdisk $loopdev0 << EOF
o
n
p
1


a
w
EOF
set -e
devmap=$(echo $(/sbin/kpartx -l $loopdev0) | awk '{ print $1 }')
echo "3. Add partition mappings ($devmap)"
kpartx -av $loopdev0

loopdev1=$(/sbin/losetup -f)
echo "4. Use $loopdev1 to mount this partition (/dev/mapper/$devmap)"
losetup $loopdev1 /dev/mapper/${devmap}

echo "5. Create a file system on the first partition"
mkfs.ext2 $loopdev1

echo "6. Mount to /mnt/rtems-boot-img"
mkdir -p /mnt/${MOUNT_DIR_NAME}
mount $loopdev1 /mnt/${MOUNT_DIR_NAME}

echo "7. Add a config file"
mkdir -p /mnt/${MOUNT_DIR_NAME}/boot/grub
cat > /mnt/${MOUNT_DIR_NAME}/boot/grub/grub.cfg << EOF
set default=0
set timeout=5

insmod ext2
insmod multiboot
set root=(hd0,msdos1)

menuentry "RTEMS RTOS : ${OUT_EXE_NAME}" {
    multiboot (hd0,msdos1)/${OUT_EXE_NAME}
}

EOF

echo "8. Install GRUB2"
grub-install --allow-floppy \
    --boot-directory=/mnt/${MOUNT_DIR_NAME}/boot \
    --disk-module=biosdisk \
    --modules="cbfs ext2 part_msdos" \
    --force $loopdev0

echo "9. Copy the RTEMS applacation to the image"
cp ${ROOT_DIR}/${OUT_EXE_NAME} /mnt/${MOUNT_DIR_NAME}

echo "10. Unmount /mnt/${MOUNT_DIR_NAME} and release $loopdev1 $loopdev0"
umount /mnt/${MOUNT_DIR_NAME}
losetup -d $loopdev1
kpartx -dv $loopdev0
losetup -d $loopdev0
