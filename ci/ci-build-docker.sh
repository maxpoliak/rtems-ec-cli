#!/bin/bash -eu

THIS_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
ROOT_DIR="$(realpath ${THIS_DIR}/..)"
CNT_IMAGE="rtems-builder"

docker build --tag ${CNT_IMAGE} --build-arg UID=${UID} ${THIS_DIR}
exec docker run \
	--interactive --tty --rm --init \
	--volume ${ROOT_DIR}:/src \
	--workdir /src \
	${CNT_IMAGE} \
	"$@"
