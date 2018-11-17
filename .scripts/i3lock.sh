#!/bin/bash

SSNAME="/tmp/screenshot.jpg"

for pid in `pidof -x i3lock`; do
    if [[ "$pid" != "$$" ]]
    then
        echo "Already running"
        exit 1
    fi
done

#scrot ${SSNAME} -q 100
#convert -blur 0x5 ${SSNAME} ${SSNAME}
#convert ${SSNAME} ~/.wallpapers/arch/neon1920_50.png -compose blend -composite ${SSNAME}

#-i /tmp/screenshot.jpg \

i3lock -B 5 \
    --indicator \
    --keylayout=0 \
    -k \
    --insidecolor=000000c0 \
    --radius 120 \
    --ring-width=10 \
    --datecolor=1177ff40 \
    --timecolor=1177ffff \
    --linecolor=1177ff00 \
    --ringcolor=1177ff80 \
    --keyhlcolor=1177ffff \
    --layoutcolor=1177ff40 \
    --datestr="%d %B %Y"

sleep 0.2
