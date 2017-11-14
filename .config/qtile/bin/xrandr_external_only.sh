#!/bin/bash

PWD=`dirname $0`

xrandr --output VGA1 --auto --output HDMI1 --auto --output eDP1 --off

$PWD/set_bg.sh

