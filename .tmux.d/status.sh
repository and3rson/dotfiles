#!/bin/bash

function sep() {
    echo -en "#[fg=colour240] \u2502 "
}

CURRENT=`/bin/cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json | jq -r '.time.current'`
TOTAL=`/bin/cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json | jq -r '.time.total'`
CURRENT=$((CURRENT/1000))
TOTAL=$((TOTAL/1000))
if [[ `/bin/cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json | jq -r .playing` == "true" ]]
then
    COLOR=32
else
    COLOR=3
fi
echo -n "#[fg=colour${COLOR}]"
echo -n `/bin/cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json | jq -r '.song.artist + " - " + .song.title'`
printf "#[bold]#[fg=colour${COLOR}] [%02d:%02d / %02d:%02d]#[default]" $((CURRENT / 60)) $((CURRENT % 60)) $((TOTAL / 60)) $((TOTAL % 60))

sep

echo -n '#[fg=colour47]'`date +"%A, %d %b, %H:%M:%S"`

sep

echo -n '#[fg=colour32]'`df -h / --output=avail | tail -n 1 | tr -d "\n " | sed -re 's/([0-9])([A-Z])/\1 \2iB/g'`

sep

TEMP=`acpi -b | egrep -o '[0-9]+%'`
echo -en '#[fg=colour198]'"\uF0E7 $TEMP"

#sep

#NET=`LANG=en nmcli dev | grep -w connected | grep -v bridge | awk '{print $4s}' | sed -re ':a;N;$!ba;s/\n/, /g'`
#echo -n $NET

