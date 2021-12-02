#!/bin/bash

while true
do
    [[ `df -h / --output=avail` =~ ([0-9]+)([A-Z]) ]]
    echo -e "icon|string|\uF7C9"
    if (( ${BASH_REMATCH[1]} < 10 ))
    then
        echo "low|bool|true"
    else
        echo "low|bool|false"
    fi
    echo "value|string|${BASH_REMATCH[0]}"
    echo
    sleep 10
done
