#!/bin/bash -e

if which docker &>/dev/null; then
    ./ci/ci-build-docker.sh ./build.sh "$@"
else
    echo "Please install docker" >&2
    exit 1
fi
