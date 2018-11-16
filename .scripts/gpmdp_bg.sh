#!/bin/bash

set -e

while :
do
    URL=$(cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json | jq .song.albumArt | sed -re 's/"//g')
    test -f /tmp/current-url && CURRENT_URL=$(cat /tmp/current-url) || CURRENT_URL=''

    if [[ "$CURRENT_URL" != "$URL" ]]
    then
        echo -n $URL > /tmp/current-url
        /bin/feh --bg-fill $URL
    fi
    sleep 1
done

