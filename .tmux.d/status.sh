#!/bin/bash
# vim: foldmethod=marker
# Colors {{{
ICON_COLOR=197
#ICON_COLOR=203
#ICON_COLOR=33
#ICON_COLOR=255
TEXT_COLOR=250
# }}}
# Functions {{{
function sep() {
    echo -en "#[fg=colour236] \u2502 "
    #echo -en "#[fg=colour240]   "
}

function icon() {
    echo -en "#[fg=colour$ICON_COLOR]$1"
}

function text() {
    echo -en "#[fg=colour$TEXT_COLOR]$1"
}
# }}}

# Date {{{
DATE=`date +"%A, %d %b, %H:%M:%S" | sed -re "s/([0-9]+:[0-9]+)/#[fg=colour$ICON_COLOR]\1#[fg=colour$TEXT_COLOR]/g"`
echo -en "#[fg=colour$TEXT_COLOR] $DATE"
sep
# }}}
# Disk space {{{
icon "\uF7C9 "
text "`df -h / --output=avail | tail -n 1 | tr -d "\n " | sed -re 's/([0-9])([A-Z])/\1 \2iB/g'`"
sep
# }}}
# Core temp {{{
TEMP=$((`cat /sys/class/thermal/thermal_zone0/temp` / 1000))
icon "\uF2CB "
text "$TEMP\u00B0C"
sep
# }}}
# Volume {{{
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

icon "$ICON "
text $((`printf %d $VOLUME` * 100 / 0x10000))'%'
sep
# }}}
# Power status {{{
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
CHARGE=`printf %-3d $CHARGE`
icon "$ICON "
text "$CHARGE"
sep
# }}}
# Network status {{{
NET=`LANG=en nmcli dev | grep -w connected | grep -v bridge | awk '{print $4s}' | sed -re ':a;N;$!ba;s/\n/, /g'`
icon "\uFAA8 "
text "$NET"
# }}}
