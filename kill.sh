#!/bin/bash -
PID=$(cat /var/run/rdog.pid)
kill -2 $PID
echo "kill signal sent to :" $PID
