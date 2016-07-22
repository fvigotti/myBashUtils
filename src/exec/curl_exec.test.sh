#!/usr/bin/env bash

set -xe

export TEST_CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export SUT=$TEST_CURRENT_DIR'/'curl_exec.sh

## ensure read-only environment
[ -w $0 ] && {
  echo "test should have read only permission on this filesystem! ( use docker to run test )"
  exit 1
}

GIST_URL='https://gist.githubusercontent.com/fvigotti/384fce7ec5068ee7052f495bc3af8648/raw/7833b8dffedcab76429161d45abcd6787a55b84a/print_args.sh'

## non automated test
$SUT $GIST_URL a 'b c' d2