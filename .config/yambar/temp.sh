#!/bin/bash

export PATH=""

enable -f /usr/lib/bash/sleep sleep

if [[ "$HOSTNAME" == "a13" ]]
then
    DEV=/sys/class/thermal/thermal_zone0/temp
else
    DEV=/sys/class/thermal/thermal_zone0/temp
fi

while true
do
TEMP=$(($(<$DEV)/1000))
echo "temp|string|$TEMP"
echo
sleep 1
done
