#!/bin/bash

PWD=`dirname $0`
echo $1
if [[ "$1" == "above" ]]
then
    POS="above"
else
    POS="left-of"
fi
echo $POS
xrandr --output HDMI-1 --auto --output HDMI-1 --$POS eDP-1

#$PWD/set_bg.sh

