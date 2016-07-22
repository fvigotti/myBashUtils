#!/bin/bash
set -xe
export TEST_CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


export SRC=""
export DST=""
export ARGS="-avz --delete-after"
export PAUSE="300"
export MAX_ITERATIONS="-1"

export DO_CHECK_TRAILING_SLASH="1"
export DO_CHECK_DESTINATION_EXIST="0"
export DO_PAUSE_AFTER="0" # if 0 will pause before


while [[ $# > 0 ]]
do
key="$1"

case $key in
    #######################        multiple args params

    --src)
    export SRC="$2"
    shift
    ;;

    --dest)
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

    --maxIterations)
    export MAX_ITERATIONS="$2"
    shift
    ;;

    #######################            single arg params
    --disableDirTrailingCheck)
    DO_CHECK_TRAILING_SLASH="1"
    ;;

    --destinationMustExist)
    export DO_CHECK_DESTINATION_EXIST="1"
    ;;

    --pauseAfter)
    export DO_PAUSE_AFTER="1"
    ;;

    *)  # unknown option

    ;;
esac
shift
done

print_help() {
  echo $0' --src [SOURCEPATH] --dest [DESTINATION] --args [additional args for rsync] --pauseSeconds [pause between loops]'
  echo ' --src [SOURCEPATH]'
  echo ' --dest [DESTINATION]'
  echo ' --args [args for rsync] , default = "-avz --delete-after" '
  echo ' --pauseSeconds [pause between loops], default= "300" '
  echo ' --maxIterations [max number of rsync executions, -1= infinite], default= "-1" '
  echo ''
  echo "OPTIONAL PARAMS: "
  echo "   --disableDirTrailingCheck / disable check for missing trailing slash to paths "
}

validationExit(){
  print_help
  exit 1
}

validate_execution_params() {

  [ -z "${SRC}" ] && {  echo 'src not provided ' ; validationExit ; } || true
  [ -z "${DST}" ] && { echo 'dest not provided ' ; validationExit ; } || true
  [ -z "${PAUSE}" ] && { echo 'pauseSeconds provided ' ; validationExit ; } || true
  [ -z "${ARGS}" ] && { echo 'args not provided ' ; validationExit ; } || true

}

clean_up() {
# Perform program exit housekeeping
echo '[TRAPPED] '$1' closing ';
exit 0

}

do_backup(){
  rsync $ARGS  $SRC $DST
}

# REGISTER TRAPS
trap "clean_up SIGHUP" SIGHUP
trap "clean_up SIGINT" SIGINT
trap "clean_up SIGTERM" SIGTERM

## PROGRAM EXECUTION START HERE

validate_execution_params

COUNTER=0;

# loop
while [ $COUNTER -lt $MAX_ITERATIONS ] || [ $MAX_ITERATIONS -eq "-1" ]; do

  [ $DO_PAUSE_AFTER -eq "1" ]  || sleep $PAUSE ;


  do_backup ;
  let COUNTER=COUNTER+1

  [ $DO_PAUSE_AFTER -eq "1" ]  && sleep $PAUSE ;

done

exit 0
