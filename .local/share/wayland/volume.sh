#!/bin/bash

VOLUME=${1:-0%+}
VOLUME=`amixer -D pulse sset Master $VOLUME | grep Left: | awk -F'[][]' '{ print $2 }'`
VOLUME=${VOLUME//%/}
INDEX=$((($VOLUME-1)*4/100))
ICONS=(off low medium high)

notify-send \
    --hint=string:x-dunst-stack-tag:volume -t 300 -a Volume \
    -i /usr/share/icons/Numix/48/notifications/notification-audio-volume-${ICONS[$INDEX]}.svg \
    "$VOLUME%" \
    `pacmd dump | grep default-sink | awk -F ' ' '{print $2}'`
