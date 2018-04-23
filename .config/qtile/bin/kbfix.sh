#!/bin/bash

set -e

export DISPLAY=:0
export HOME=/home/anderson
#export XAUTHORITY=/home/anderson/.Xauthority

setxkbmap -layout 'us,ua' -option grp:alt_shift_toggle
xmodmap ~/.Xmodmap
xset r rate 167 25
kbd_mode -s

