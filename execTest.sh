#!/usr/bin/env bash
set -xe

export TEST_CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


export SUT=$1


docker run --rm -ti  -v "${TEST_CURRENT_DIR}/src:/myBashUtils:ro" fvigotti/env-fatubuntu bash /myBashUtils/$SUT

echo 'EXIT_CODE = '$?
