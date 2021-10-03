#!/bin/bash -e

PROJECT_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"

if which docker &>/dev/null; then
    ${PROJECT_DIR}/ci/ci-build-docker.sh "$@"
else
    echo "Please install docker" >&2
    exit 1
fi
