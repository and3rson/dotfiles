#!/bin/bash

pulseaudio --start -D
setxkbmap -layout 'us,ru,ua' -option grp:alt_shift_toggle
xmodmap -e ~/.Xmodmap
xset r rate 200 25
# xss-lock -- /sh/i3lock.sh &
nm-applet &

# hsetroot -solid "#000000" &
# hsetroot -center 86ffb87572d657f335cd7cd828c70de3.jpg &
# hsetroot -fill ~/.wallpapers/new/can2.jpg &
feh --bg-fill ~/.wallpapers/new/can2.jpg &
# compton -I 0.04 -O 0.04 -f --unredir-if-possible -b
compton --config ~/.compton.conf -b -f
