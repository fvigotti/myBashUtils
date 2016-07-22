#!/bin/bash
set -xe

export TEST_CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export SUT=$TEST_CURRENT_DIR'/'rsync_loop.sh

## ensure read-only environment
[ -w $0 ] && {
  echo "test should have read only permission on this filesystem! ( use docker to run test )"
  exit 1
}


executeAsync() {
  TIMEOUT=$1
  shift
  COMMAND=$@

  # execute
  $COMMAND &

  # wait
  ASYNC_PID=$!
  echo "async pid = $ASYNC_PID"
  wait $ASYNC_PID

}

## tests


test_no_args_return_errors(){
  ## expectfail
  $SUT && exit 1 || { echo "passed ${FUNCNAME[0]}"; }
}
test_no_args_return_errors


test_rsync_copyfile(){
  ## prepare env
  srcDir=$(mktemp -d)
  dstDir=$(mktemp -d)

  echo "a" > $srcDir/AA
  executeAsync 10 $SUT --src $srcDir/ --dest $dstDir/ --pauseSeconds 0 --maxIterations 1
  ls $dstDir/
  [ -f "$dstDir/AA" ] || { exit 1 ; } ## file has been copyed

  #sleep 10

#  $SUT && exit 1 || { echo "passed ${FUNCNAME[0]}"; }
}
test_rsync_copyfile


exit 0