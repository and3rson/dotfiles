#!/bin/bash

VOLUME=${1:-0%+}
VOLUME=`amixer -D pulse sset Master $VOLUME | grep Left: | awk -F'[][]' '{ print $2 }'`
VOLUME=${VOLUME//%/}
INDEX=$((($VOLUME-1)*4/100))
ICONS=(off low medium high)

# -i /usr/share/icons/Numix/48/notifications/notification-audio-volume-${ICONS[$INDEX]}.svg \
notify-send \
    --hint=string:x-dunst-stack-tag:volume -t 300 -a volume \
    -i audio-volume-${ICONS[$INDEX]}-symbolic \
    "$VOLUME%" \
    `pactl info | grep "Default Sink:" | awk -F ' ' '{print $3}'`
