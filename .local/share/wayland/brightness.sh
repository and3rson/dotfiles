#!/bin/bash

BRIGHTNESS=${1:-0%+}
BRIGHTNESS=`brightnessctl s $BRIGHTNESS | egrep -o '[0-9]+%'`
BRIGHTNESS=${BRIGHTNESS//%/}
INDEX=$((($BRIGHTNESS-1)*5/100))
ICONS=(off low medium high full)
echo $BRIGHTNESS

# -i /usr/share/icons/menta/48x48/devices/display.png \
notify-send \
    --hint=string:x-dunst-stack-tag:brightness -t 300 -a brightness \
    -i /usr/share/icons/Numix/48/notifications/notification-display-brightness-${ICONS[$INDEX]}.svg \
    "$BRIGHTNESS%"
