#!/usr/bin/bash

set -e

sleep 3

[[ -z "$1" ]] && (echo 'Usage: rec.sh <FILENAME>' && exit 1)

FNAME=$1
FNAME_NO_EXT=${FNAME%.*}
FNAME_OGV="$FNAME_NO_EXT.ogv"
FNAME_MP4="$FNAME_NO_EXT.mp4"

VARS=(`xmeasure 2>&1 | awk -F': ' '{ print $2 }'`)
read X Y W H <<< "${VARS[*]}"

#sleep 1

sleep 0.5

#CMD="recordmydesktop --channels 2 --freq 44100 -x $X -y $Y --width $W -height $H --fps 30 --overwrite -o $FNAME_OGV --stop-shortcut Control+s"
CMD="recordmydesktop --device pulse -x $X -y $Y --width $W -height $H --fps 30 --overwrite -o $FNAME_OGV --stop-shortcut Control+s"
echo $CMD
$CMD
ffmpeg -y -i $FNAME_OGV $FNAME_MP4
rm -f $FNAME_OGV

notify-send 'Encoding complete' "Saved as $FNAME_MP4"
