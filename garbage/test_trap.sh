#!/usr/bin/env bash

echo 'PID='$$

clean_up() {
echo "wait return = "$WAIT_RETURN
# Perform program exit housekeeping
echo '[TRAPPED] '$1' closing ';
exit 0

}
# REGISTER TRAPS
trap "clean_up SIGHUP" SIGHUP
trap "clean_up SIGINT" SIGINT
trap "clean_up SIGTERM" SIGTERM

echo "start sleep";
sleep 1000 &
SLEEP_PID=$!
echo 'waiting for sleep pid = '$SLEEP_PID

#wait $SLEEP_PID
wait $SLEEP_PID

export WAIT_RETURN=$?
echo 'wait returned '$WAIT_RETURN

echo "end sleep";