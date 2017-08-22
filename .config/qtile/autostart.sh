#!/bin/bash

PWD=`dirname $0`

# pulseaudio --start -D
start-pulseaudio-x11-mod
$PWD/bin/kbfix.sh
$PWD/bin/qoverlay.py -d
xbanish &
# xss-lock -- /sh/i3lock.sh &
nm-applet &
blueman-applet &
# deluged -l /tmp/deluged.log &

# sudo pritunl-client-gtk &

# xscreensaver &

# hsetroot -solid "#000000" &
# hsetroot -center 86ffb87572d657f335cd7cd828c70de3.jpg &
# hsetroot -fill ~/.wallpapers/new/can2.jpg &
# feh --bg-fill ~/.wallpapers/new/can2.jpg &
# feh --bg-fill ~/.wallpapers/new/zbFCJbj.jpg &
# compton -I 0.04 -O 0.04 -f --unredir-if-possible -b
compton --config ~/.compton.conf -b -f
# [[ "$HOSTNAME" != "spawn" ]] && xwinwrap -b -fs -sp -fs -nf -o 0.70 -ov  -- /usr/lib/xscreensaver/colorfire -root -window-id WID &
[[ "$HOSTNAME" == "spawn" ]] && xwinwrap -b -fs -sp -fs -nf -o 0.70 -ov  -- /usr/lib/xscreensaver/pixelcity -b -root -window-id WID &

# colorfire, euphoria, flux, lockward, pixelcity

$PWD/bin/set_bg.sh

