#!/bin/bash

PWD=`dirname $0`

xrandr --output HDMI1 --auto --left-of eDP1
xrandr --output DP1 --auto --left-of HDMI1 --rotate right
synclient AccelFactor=0.03

$PWD/set_bg.sh

