#!/bin/bash

PWD=`dirname $0`

xrandr --output HDMI1 --off --output DP1 --off
synclient AccelFactor=0.08

$PWD/set_bg.sh

