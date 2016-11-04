#!/bin/bash

pulseaudio -D
setxkbmap -layout 'us,ru,ua' -option grp:alt_shift_toggle
xset r rate 200 25
xss-lock -- /sh/i3lock.sh &
nm-applet &
