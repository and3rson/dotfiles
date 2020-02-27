#!/bin/bash

PWD=`dirname $0`
echo $1
#if [[ "$1" == "above" ]]
#then
#    POS="above"
#else
#    POS="left-of"
#fi
#echo $POS
POS=left-of
if [[ "$1" == "rotate" ]]
then
    ROT="left"
else
    ROT="normal"
fi
xrandr --output HDMI1 --auto --output HDMI1 --$POS eDP1 --rotate $ROT
synclient AccelFactor=0.015
#xrandr --output eDP-1 --pos 1920x1080+1920+840

#xrandr --output HDMI-1 --auto --pos 1920x1080+0+0 --rotate left
#xrandr --output eDP-1 --auto --pos 1920x1080+1080+0

#$PWD/set_bg.sh

