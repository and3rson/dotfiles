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
xrandr --output HDMI1 --auto --output HDMI1 --$POS eDP1

$PWD/set_bg.sh

