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
xrandr --output HDMI-1 --auto --output HDMI-1 --$POS eDP-1 --rotate $ROT
#xrandr --output eDP-1 --pos 1920x1080+1920+840

#xrandr --output HDMI-1 --auto --pos 1920x1080+0+0 --rotate left
#xrandr --output eDP-1 --auto --pos 1920x1080+1080+0

#$PWD/set_bg.sh

