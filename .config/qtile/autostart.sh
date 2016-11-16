#!/bin/bash

pulseaudio --start -D
setxkbmap -layout 'us,ru,ua' -option grp:alt_shift_toggle
xset r rate 200 25
# xss-lock -- /sh/i3lock.sh &
nm-applet &

hsetroot -solid "#000000" &
compton -I 0.04 -O 0.04 -f --unredir-if-possible -b
