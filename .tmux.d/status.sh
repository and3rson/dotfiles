#!/bin/bash

function sep() {
    echo -en "#[fg=colour238] \u2502 "
    #echo -en "#[fg=colour240]   "
}

ICON_COLOR=197
#ICON_COLOR=203
#ICON_COLOR=33
#ICON_COLOR=255
TEXT_COLOR=250

#CURRENT=`/bin/cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json | jq -r '.time.current'`
#TOTAL=`/bin/cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json | jq -r '.time.total'`
#CURRENT=$((CURRENT/1000))
#TOTAL=$((TOTAL/1000))
#if [[ `/bin/cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json | jq -r .playing` == "true" ]]
#then
#    COLOR=32
#else
#    COLOR=3
#fi
#echo -n "#[fg=colour${COLOR}]"
#echo -n `/bin/cat ~/.config/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json | jq -r '.song.artist + " - " + .song.title'`
#printf "#[bold]#[fg=colour${COLOR}] [%02d:%02d / %02d:%02d]#[default]" $((CURRENT / 60)) $((CURRENT % 60)) $((TOTAL / 60)) $((TOTAL % 60))

#sep

#echo -en "#[fg=colour$ICON_COLOR]\uf64f#[fg=colour$TEXT_COLOR] "`date +"%A, %d %b, %H:%M:%S"`
echo -en "#[fg=colour$TEXT_COLOR] "`date +"%A, %d %b, %H:%M:%S"`

sep

echo -en "#[fg=colour$ICON_COLOR]\uF7C9#[fg=colour$TEXT_COLOR] "`df -h / --output=avail | tail -n 1 | tr -d "\n " | sed -re 's/([0-9])([A-Z])/\1 \2iB/g'`

sep

TEMP=$((`cat /sys/class/thermal/thermal_zone0/temp` / 1000))
echo -en "#[fg=colour$ICON_COLOR]\uF2CB#[fg=colour$TEXT_COLOR] $TEMP\u00B0C"

sep

DUMP=`pacmd dump`
[[ $DUMP =~ set-default-sink\ ([a-zA-Z0-9_\.-]+) ]]
SINK=${BASH_REMATCH[1]}
[[ $DUMP =~ set-sink-volume\ $SINK\ ([0-9a-fx]+) ]]
VOLUME=${BASH_REMATCH[1]}

if [[ $SINK == *"bluez"* ]]
then
    ICON='\uF7CA'
else
    ICON='\uF027'
fi

echo -en "#[fg=colour$ICON_COLOR]$ICON#[fg=colour$TEXT_COLOR]" $((`printf %d $VOLUME` * 100 / 0x10000))'%'

sep

BATT=`acpi -b`
[[ $BATT =~ Battery\ ([0-9]):\ ([a-zA-Z\ ]+),\ ([0-9]+) ]]
STATE=${BASH_REMATCH[2]}
CHARGE=${BASH_REMATCH[3]}
ICON='\uF578'
if [ "$STATE" == "Charging" ] || [ "$STATE" == "Full" ] || [ "$STATE" == "Not charging" ]
then
    ICON='\uF0E7'
else
    ICON='\uF578'
fi
echo -en "#[fg=colour$ICON_COLOR]$ICON#[fg=colour$TEXT_COLOR] $CHARGE"

sep

NET=`LANG=en nmcli dev | grep -w connected | grep -v bridge | awk '{print $4s}' | sed -re ':a;N;$!ba;s/\n/, /g'`
echo -en "#[fg=colour$ICON_COLOR]\uFAA8#[fg=colour$TEXT_COLOR] $NET"

