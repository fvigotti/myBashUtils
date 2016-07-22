#!/bin/bash
set -xe

export SUT=rsync_loop.sh
export TEST_CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

## ensure safe environment
[ -w $0 ] && {
  echo "test should have read only permission on this filesystem! ( use docker to run test )"
  exit 1
}







exit 0