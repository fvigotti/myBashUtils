#!/usr/bin/env bash

export CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $CURRENT_DIR

REPO=${REPO:-fvigotti}
VERSION=${VERSION:-latest}
IMAGENAME="mybashutils"

docker build -t $REPO'/'$IMAGENAME':'$VERSION .