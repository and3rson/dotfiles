#!/bin/bash

PARAMS=(
    --indicator
    --keylayout=0
    -k
    --insidecolor=000000c0
    --radius 120
    --ring-width=10
    --datecolor=1177ff40
    --timecolor=1177ffff
    --linecolor=1177ff00
    --ringcolor=1177ff80
    --keyhlcolor=1177ffff
    --layoutcolor=1177ff40
    --datestr="%d %B %Y"
)
WP="/home/anderson/.wallpapers/lights1920.png"
#WP="/home/anderson/.wallpapers/sw/isnow.jpg"

#SSNAME="/tmp/screenshot.jpg"

#for pid in `pidof -x i3lock`; do
#    if [[ "$pid" != "$$" ]]
#    then
#        echo "Already running"
#        exit 1
#    fi
#done

#i3lock ${PARAMS[@]} -B 5
#sleep 0.2

i3lock ${PARAMS[@]} -t -i ${WP}
sleep 0.2
