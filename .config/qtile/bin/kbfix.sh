#!/bin/bash

setxkbmap -layout 'us,ru,ua' -option grp:alt_shift_toggle
xmodmap ~/.Xmodmap
xset r rate 167 25
kbd_mode -s

