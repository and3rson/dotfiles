#!/bin/bash

CURRENT=$(pactl info | grep 'Default Sink:' | cut -d' ' -f3)
SINKS=( $(pactl list sinks | grep Name: | cut -d' ' -f2) )
SINK_NAMES=()
while IFS= read -r line; do SINK_NAMES+=("$line"); done <<< $(pactl list sinks | grep Description: | cut -d' ' -f2-)
for i in "${!SINKS[@]}"
do
    if [[ "${SINKS[$i]}" == $CURRENT ]]
    then
        INDEX=$i
    fi
done
echo $INDEX
INDEX=$((INDEX + 1))
if (( $INDEX == ${#SINKS[@]} ))
then
    INDEX=0
fi
echo $INDEX
NEW_SINK=${SINKS[$INDEX]}
NEW_SINK_NAME=${SINK_NAMES[$INDEX]}
pactl set-default-sink $NEW_SINK

# ICON=audio-speakers
ICON=system-config-soundcard
case "$NEW_SINK" in
    *usb*)
        ICON=headphones
        ;;
esac

notify-send \
    --hint=string:x-dunst-stack-tag:sink -t 700 -a Volume \
    -i /usr/share/icons/Numix/48/devices/$ICON.svg \
    "Sink switched" \
    "$NEW_SINK_NAME"

# VOLUME=${1:-0%+}
# VOLUME=`amixer -D pulse sset Master $VOLUME | grep Left: | awk -F'[][]' '{ print $2 }'`
# VOLUME=${VOLUME//%/}
# INDEX=$((($VOLUME-1)*4/100))
# ICONS=(off low medium high)

# notify-send \
#     --hint=string:x-dunst-stack-tag:volume -t 300 -a Volume \
#     -i /usr/share/icons/Numix/48/notifications/notification-audio-volume-${ICONS[$INDEX]}.svg \
#     "$VOLUME%" \
#     `pactl info | grep "Default Sink:" | awk -F ' ' '{print $3}'`
