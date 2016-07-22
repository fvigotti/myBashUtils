#!/bin/bash
set -xe
export TEST_CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


export SRC=""
export DST=""
export ARGS="-avz --delete-after"
export PAUSE="300"
export DO_CHECK_TRAILING_SLASH="1"
export DO_CHECK_DESTINATION_EXIST="0"


while [[ $# > 0 ]]
do
key="$1"

case $key in
    --src)
    export SRC="$2"
    shift
    ;;

    --dst)
    export DST="$2"
    shift
    ;;

    --args)
    export ARGS="$2"
    shift
    ;;

    --pauseSeconds)
    export PAUSE="$2"
    shift
    ;;

    --disableDirTrailingCheck)
    DO_CHECK_TRAILING_SLASH="1"
    ;;

    --destinationMustExist)
    export DO_CHECK_DESTINATION_EXIST="1"
    ;;

    *)  # unknown option
    ;;
esac
shift
done

print_help() {
  echo $0' --src [SOURCEPATH] --dst [DESTINATION] --args [additional args for rsync] --pauseSeconds [pause between loops]'
  echo ' --src [SOURCEPATH]'
  echo ' --dst [DESTINATION]'
  echo ' --args [additional args for rsync] , default = "-avz --delete-after" '
  echo ' --pauseSeconds [pause between loops], default= "300" '
  echo ''
  echo "OPTIONAL PARAMS: "
  echo "   --disableDirTrailingCheck / disable check for missing trailing slash to paths "
}
validationExit(){
  print_help
  exit 1
}

validate_execution_params() {

  [ -z "${SRC}" ] && { echo 'src not provided '; validationExit }
  [ -z "${DST}" ] && { echo 'dst not provided ' ; validationExit }
  [ -z "${PAUSE}" ] && { echo 'pauseSeconds provided ' ; validationExit }
  [ -z "${ARGS}" ] && { echo 'args not provided ' ; validationExit }

}

clean_up() {
# Perform program exit housekeeping
echo '[TRAPPED] '$1' closing ';
exit 0
}

do_backup(){
  rsync $ARGS --exclude='.trashcan'  $SRC $DST
}

# REGISTER TRAPS
trap "clean_up SIGHUP" SIGHUP
trap "clean_up SIGINT" SIGINT
trap "clean_up SIGTERM" SIGTERM


validate_execution_params

# loop
while : ; do sleep 300 ; do_backup ; done  