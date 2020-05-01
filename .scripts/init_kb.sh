#!/bin/bash

set -e

## TODO: Display
export DISPLAY=:0
export HOME=/home/anderson
##export XAUTHORITY=/home/anderson/.Xauthority

##setxkbmap -layout 'us,ua' -option grp:alt_shift_toggle
#echo 1 > /tmp/foo
setxkbmap -layout 'us,ua' -option grp:alt_space_toggle
#echo 2 > /tmp/foo
xmodmap ~/.Xmodmap
#echo 3 > /tmp/foo
xset r rate 167 25
#echo 4 > /tmp/foo
kbd_mode -s
python3 /home/anderson/.scripts/not.py "40% connected~~0.5"
