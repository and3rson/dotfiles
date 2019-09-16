#!/bin/bash

PWD=`dirname $0`

xrandr --output HDMI-1 --off --output DP-1 --off
synclient AccelFactor=0.08

$PWD/set_bg.sh

