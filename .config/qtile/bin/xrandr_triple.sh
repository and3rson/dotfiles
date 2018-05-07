#!/bin/bash

PWD=`dirname $0`

if [[ "$1" == "norotate" ]]
then
    ROTATE="normal"
else
    ROTATE="right"
fi

xrandr --output HDMI1 --auto --left-of eDP1
xrandr --output DP1 --auto --left-of HDMI1 --rotate $ROTATE
xrandr --output eDP1 --pos +3840x$((1080-768))
synclient AccelFactor=0.01

$PWD/set_bg.sh

