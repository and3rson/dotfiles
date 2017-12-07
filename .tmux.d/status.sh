#!/bin/bash

function sep() {
    echo -en " \u2502 "
}

echo -n `date +"%A, %d %b, %H:%M:%S"`

sep

TEMP=`acpi -b | egrep -o '[0-9]+%'`
echo -n $TEMP

sep

NET=`LANG=en nmcli dev | grep -w connected | grep -v bridge | awk '{print $4s}' | sed -re ':a;N;$!ba;s/\n/, /g'`
echo -n $NET

