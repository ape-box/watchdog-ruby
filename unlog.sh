#!/bin/bash -
PID=$(cat $HOME/watchdog-ruby/rdog_logger.pid)
kill -2 $PID
echo "kill signal sent to :" $PID
