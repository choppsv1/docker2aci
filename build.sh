#!/usr/bin/env bash

set -e

ORG_PATH="github.com/appc"
REPO_PATH="${ORG_PATH}/docker2aci"
# TODO: use "git describe --dirty" when we actually have tags pushed
VERSION=$(git rev-parse --short HEAD)
GLDFLAGS="-X github.com/appc/docker2aci/lib.Version=${VERSION}"

if [ ! -h gopath/src/${REPO_PATH} ]; then
	mkdir -p gopath/src/${ORG_PATH}
	ln -s ../../../.. gopath/src/${REPO_PATH} || exit 255
fi

export GOBIN=${PWD}/bin
export GOPATH=${PWD}/gopath:${PWD}/Godeps/_workspace

eval $(go env)

echo "Fetching dependencies..."
go get -d -v ./...
echo "Building docker2aci..."
go build -o $GOBIN/docker2aci -ldflags "${GLDFLAGS}" ${REPO_PATH}/
