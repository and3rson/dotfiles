#!/bin/bash

PWD=`dirname $0`

xrandr --output VGA1 --auto --output HDMI1 --auto --output HDMI1 --left-of eDP1

$PWD/set_bg.sh

