#!/bin/bash -eu

CI_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
ROOT_DIR="${CI_DIR}/.."

proj_release=$(git -C ${ROOT_DIR} describe --abbrev=0 --tags)
coreboot_img_zip_name="x86-p35-coreboot-test-artifact.zip"
url="https://github.com/maxpoliak/rtems-ec-cli/releases/download/${proj_release}/${coreboot_img_zip_name}"
coreboot_img_zip_path="${ROOT_DIR}/${coreboot_img_zip_name}"

function print_help() {
    echo "Use $0 COMMANDS [OPTIONS...]"
    echo "  Import a coreboot artifact for testing from the release archive"
    echo " "
    echo "  Returns <does-not-exist> if the artifact does not exist otherwise path to file"
    echo " "
    echo "       --name <name>  Artifact name (${coreboot_img_zip_name} by default)"
    echo "       --url  <url>   Set url (${url} by default)"
    echo "  -h | --help         Print help"
}

while [ "${1:-}" != "" ]; do
    case "$1" in
        "--name")
            coreboot_img_zip_name=$2
            shift 2
            ;;
        "--url")
            url=$2
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

if [ -f "$coreboot_img_zip_path" ]; then
    echo "exist"
elif wget --quiet --spider "${url}"; then
    wget --quiet ${url}
    echo "${coreboot_img_zip_path}"
else
    echo "does-not-exist"
fi
