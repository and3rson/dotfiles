#!/usr/bin/bash

set -e

[[ -z "$1" ]] && (echo 'Usage: rec.sh <FILENAME>' && exit 1)

FNAME=$1
FNAME_NO_EXT=${FNAME%.*}
FNAME_OGV="$FNAME_NO_EXT.ogv"
FNAME_MP4="$FNAME_NO_EXT.mp4"

VARS=(`xmeasure 2>&1 | awk -F': ' '{ print $2 }'`)
read X Y W H <<< "${VARS[*]}"

recordmydesktop --no-sound -x $X -y $Y --width $W -height $H --fps 30 --overwrite -o $FNAME_OGV
ffmpeg -y -i $FNAME_OGV $FNAME_MP4
