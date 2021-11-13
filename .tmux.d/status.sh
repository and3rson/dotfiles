#!/bin/bash
# vim: foldmethod=marker
# Colors {{{
NORMAL_COLOR=253
#STRONG_COLOR=33
WARN_COLOR=197
STRONG_COLOR=197
COLOR_0=197
COLOR_1=81
COLOR_2=154
COLOR_3=141
COLOR_4=222
#STRONG_COLOR=205
#STRONG_COLOR=33
#STRONG_COLOR=255
MODE='tmux'
if [[ "$1" != '' ]]
then
    MODE=$1
fi
# }}}

set -a

DEBUG=0

# Functions {{{
function sep() {
    if [[ "$MODE" == "ansi" ]]
    then
        echo -en "\e[38;5;236m \u2502 "
    elif [[ "$MODE" == "pango" ]]
    then
        echo -en "<span foreground=\"#CCCCCC\"> \u2502 </span>"
    else
        echo -en "#[fg=colour236] \u2502 "
    fi
    #echo -en "#[fg=colour242] \uE0BF  "
    #echo -en "#[fg=colour240]   "
}

function normal() {
    if [[ "$MODE" == "ansi" ]]
    then
        echo -en "\e[38;5;${NORMAL_COLOR}m$1"
    elif [[ "$MODE" == "pango" ]]
    then
        echo -en "<span foreground=\"#F5F5F5\"> $1 </span>"
    else
        echo -en "#[default,fg=colour$NORMAL_COLOR]$1"
    fi
    # ,underscore #[fg=default,default]"
}

function strong() {
    if [[ "$MODE" == "ansi" ]]
    then
        echo -en "\e[38;5;${STRONG_COLOR}m$1"
    elif [[ "$MODE" == "pango" ]]
    then
        echo -en "<span foreground=\"#FF1177\"> $1 </span>"
    else
        echo -en "#[fg=colour$STRONG_COLOR,bold]$1"
    fi
}

function warn() {
    if [[ "$MODE" == "ansi" ]]
    then
        echo -en "\e[38;5;${WARN_COLOR}m$1"
    elif [[ "$MODE" == "pango" ]]
    then
        echo -en "<span foreground=\"#FF1177\"> $1 </span>"
    else
        echo -en "#[default,fg=colour$WARN_COLOR]$1"
    fi
}

function color() {
    varname="COLOR_$2"
    if [[ "$MODE" == "ansi" ]]
    then
        echo -en "\e[38;5;${!varname}m$1"
    else
        echo -en "#[default,fg=colour${!varname}]$1"
    fi
}

function strength() {
    value=$1
    if (( $value > 99 ))
    then
        value=99
    elif (( value < 0 ))
    then
        value=0
    fi
    CHARS='▁▂▃▄▅▆▇█'
    I=$((value*8/100))
    if (( $I > 7 ))
    then
        I=7
    fi
    CH=${CHARS:$I:1}
    echo -en $CH
}

function render() {
    FIRST=1
    for part in $@
    do
        if [[ "$DEBUG" == "1" ]]
        then
            START=`$BIN/date +%s.%N`
            OUT=$($part)
            END=`$BIN/date +%s.%N`
            DIFF=$(LANG=en_US printf %.3fms `$BIN/bc <<< "($END-$START)*1000"`)
            OUT="$OUT ($DIFF)"
        else
            OUT=$($part)
        fi
        if [[ "$?" -eq "0" ]]
        then
            [[ "$FIRST" -eq "0" ]] && sep
            echo -n "$OUT"
            # echo -n `echo $ERR | $BIN/grep a`
            FIRST=0
        fi
    done
}

# }}}

enable -f /usr/lib/bash/sleep sleep

PATH="."
BIN=/usr/bin
# trap 'echo -n "CHLD $1"' SIGCHLD

# phonebattery: Display Note 8 Pro battery charge {{{
function phonebattery() {
    CHARGE=$(<~/.mqtt/devices_note8pro_battery)
    if (( $CHARGE < 20 ))
    then
        COLOR=0
    else
        COLOR=2
    fi
    color "\uF8F1 " $COLOR
    color "$CHARGE%" $COLOR
}
# }}}
# clay: Clay {{{
function clay() {
    if [[ -f /tmp/clay.json ]]
    then
       #CLAY_STR=`cat /tmp/clay.json | jq -r '.artist + " - " + .title + " [" + .progress_str + " / " + .length_str + "]"'`
       #normal "$CLAY_STR"
       TRACK_STR=`cat /tmp/clay.json | jq -r '.artist + " - " + .title'`
       PROGRESS_STR=`cat /tmp/clay.json | jq -r '"[" + .progress_str + " / " + .length_str + "]"'`
       strong "\uFC58 "
       normal "$TRACK_STR "
       warn "$PROGRESS_STR"
    fi
}
# }}}
# current_dir: Current dir {{{
function current_dir() {
    echo -n "#{pane_current_path}"
}
# }}}
# player: Playerctl {{{
function player() {
    TEXT="`$BIN/playerctl metadata --format '[{{playerName}}] {{artist}} - {{title}}' 2> /dev/null`"
    STATUS="`$BIN/playerctl metadata --format '{{lc(status)}}' 2> /dev/null`"
    if (( ${#TEXT} > 64 ))
    then
        TEXT=${TEXT:0:64}`printf "\u2026"`
    fi
    if [[ "$STATUS" == "playing" ]]
    then
        ICON="\uF04B"
        # strong "$ICON "
        # color "$TEXT" 2
        color "$ICON $TEXT" 0
    elif [[ "$STATUS" == "stopped" ]]
    then
        return 1
    else
        ICON="\uF04C"
        # strong "$ICON "
        # normal "$TEXT"
        color "$ICON $TEXT" 4
    fi
}
# }}}
# netstatus: Network status {{{
function netstatus() {
    NET=`LANG=en $BIN/nmcli dev | $BIN/grep -w connected | $BIN/grep -v bridge | $BIN/awk '{print $4s}' | $BIN/sed -re ':a;N;$!ba;s/\n/, /g'`
    if [[ "$NET" == "" ]]
    then
        # warn "\uFAA8 "
        # warn "Offline"
        color "\uFAA8 Offline" 0
    else
        # strong "\uFAA8 "
        # color "$NET" 1
        color "\uFAA8 $NET" 1
    fi
}
# }}}
# kblayout: Keyboard layout {{{
function kblayout() {
    LAYOUT=`xkblayout-state print %n`
    LAYOUT=`xkblayout-state print %s`
    if [[ -f /tmp/kblayout.txt ]]
    then
       PREV=`cat /tmp/kblayout.txt`
    else
       PREV=''
    fi
    if [[ "$LAYOUT" != "$PREV" ]]
    then
       echo $LAYOUT > /tmp/kblayout.txt
       # ~/.scripts/not.sh "{\"icon_code\":61724,\"message\":\"$LAYOUT\",\"submessage\":\"\",\"timeout\":0.3}"
    fi
    normal $LAYOUT
}
# }}}
# volume: Volume {{{
function volume() {
    DUMP=`/usr/bin/pacmd dump`
    [[ $DUMP =~ set-default-sink\ ([a-zA-Z0-9_\.-]+) ]]
    SINK=${BASH_REMATCH[1]}
    [[ $DUMP =~ set-sink-volume\ $SINK\ ([0-9a-fx]+) ]]
    VOLUME=${BASH_REMATCH[1]}

    if [[ $SINK == *"bluez"* ]]
    then
        ICON='\uF7CA'
        ICON_CODE=$((0xF7CA))
    else
        # ICON='\uF027'
        ICON='\uF886'
        # ICON='\uFC58'
        ICON_CODE=$((0xFC58))
    fi

    # strong "$ICON "
    # normal $((`printf %d $VOLUME` * 100 / 0x10000))'%'
    color "$ICON $((`printf %d $VOLUME` * 100 / 0x10000))%" 3
}

# PREV=`cat /tmp/sink.txt 2> /dev/null || true`

# if [[ "$SINK" != "$PREV" ]]
# then
#     #~/.scripts/not.sh "`echo -e $ICON`~$SINK~0.5"
#     ~/.scripts/not.sh "{\"icon_code\":$ICON_CODE,\"message\":\"\",\"submessage\":\"$SINK\",\"timeout\":0.5}"
#     echo $SINK > /tmp/sink.txt
# fi

# }}}
# cpu: CPU utilization {{{
function cpu() {
    if (( 0 == 1 ))
    then
        # A=($($BIN/sed -n '1p' /proc/stat))
        read -r A < /proc/stat
        A=($A)
        # user         + nice     + system   + idle
        B=$((${A[1]}  + ${A[2]}  + ${A[3]}  + ${A[4]}))
        sleep 0.25
        # user         + nice     + system   + idle
        # C=($($BIN/sed -n '1p' /proc/stat))
        read -r C < /proc/stat
        C=($C)
        D=$((${C[1]}  + ${C[2]}  + ${C[3]}  + ${C[4]}))
        # cpu usage per core
        E=$((100 * (B - D - ${A[4]}  + ${C[4]})  / (B - D)))
        #echo $E0
    fi

    read cpu user nice system idle iowait irq softirq steal guest< /proc/stat
    cpu_active_prev=$((user+system+nice+softirq+steal))
    cpu_total_prev=$((user+system+nice+softirq+steal+idle+iowait))
    sleep 0.25
    read cpu user nice system idle iowait irq softirq steal guest< /proc/stat
    cpu_active_cur=$((user+system+nice+softirq+steal))
    cpu_total_cur=$((user+system+nice+softirq+steal+idle+iowait))
    cpu_util=$((100*( cpu_active_cur-cpu_active_prev ) / (cpu_total_cur-cpu_total_prev) ))

    ##E=$((E0+E1+E2+E3/4))
    # if [ $(($E > 99)) -eq "1" ]
    # then
    #     E=99
    # fi

    # cpu_fraction=$E
    cpu_fraction=$cpu_util
    ch=`strength $cpu_fraction`
    # touch /tmp/cpu_graph.txt
    # graph=`tail /tmp/cpu_graph.txt -c 9`
    # graph="$graph$ch"
    # echo -n $graph > /tmp/cpu_graph.txt
    graph=$ch

    #G=`cat /tmp/cpud_graph.txt`
    #V=`cat /tmp/cpud_value.txt`

    if [ $(($cpu_fraction > 50)) -eq "1" ]
    then
        #warn "\uE266  "
        # warn $graph
        #warn `tail -c32 /tmp/cpu.txt`
        # warn " `printf %3s $cpu_fraction%`"
        color "$graph `printf %3s $cpu_fraction%`" 0
    else
        #strong "\uE266  "
        # strong $graph
        #strong `tail -c32 /tmp/cpu.txt`
        # normal " `printf %3s $cpu_fraction%`"
        color "$graph `printf %3s $cpu_fraction%`" 1
    fi
}
# }}}
# mem: Memory {{{
function mem() {
    IFS=' ' read total used <<< `$BIN/free -b | $BIN/sed '2q;d' | $BIN/awk '{print $2" "$3}'`
    mem_fraction=$((used*100/total))
    ch=`strength $mem_fraction`
    # touch /tmp/mem_graph.txt
    # graph=`tail /tmp/mem_graph.txt -c 9`
    # graph="$graph$ch"
    # echo -n $graph > /tmp/mem_graph.txt
    graph=$ch
    if (( $mem_fraction > 50 ))
    then
        #warn "\uF85A "
        #warn "\uF471  "
        # warn "$graph"
        # warn " `printf %3s $mem_fraction%`"
        color "$graph `printf %3s $mem_fraction%`" 0
    else
        #strong "\uF85A "
        #strong "\uF471  "
        # strong "$graph"
        # normal " `printf %3s $mem_fraction%`"
        color "$graph `printf %3s $mem_fraction%`" 2
    fi
}
# }}}
# diskfree: Disk space {{{
function diskfree() {
    # strong "\uF7C9 "
    # normal `df -h / --output=avail | tail -n 1 | tr -d "\n "`
    [[ `$BIN/df -h / --output=avail` =~ [0-9]+[A-Z] ]]
    color "\uF7C9 ${BASH_REMATCH[0]}" 4
    # color "\uF7C9 "`$BIN/df -h / --output=avail | $BIN/tail -n 1 | $BIN/tr -d "\n "` 4
    #sed -re 's/([0-9])([A-Z])/\1 \2iB/g'
}
# }}}
# temp: Core temp {{{
function temp() {
    TEMP=$((`cat /sys/class/thermal/thermal_zone0/temp` / 1000))
    strong "\uF2CB "
    normal "$TEMP\u00B0C"
}
# }}}
# now: Date {{{
function now() {
    if (( $ANSI ))
    then
        #DATE=`date +"%a, %d %b, %H:%M:%S"`
        # DATE=`date +"%d %b, %H:%M"`
        DATE=`builtin printf '%(%d %b, %H:%M)T' -1`
    else
        #DATE=`date +"%a, %d %b, %H:%M:%S" | sed -re "s/([0-9]+:[0-9]+)/#[fg=colour$STRONG_COLOR,bold]\1\#[default,fg=colour$NORMAL_COLOR]/g"`
        #DATE=`date +"%H:%M" | sed -re "s/([0-9]+:[0-9]+)/#[fg=colour$STRONG_COLOR,bold]\1\#[default,fg=colour$NORMAL_COLOR]/g"`
        # DATE=`date +"%d %b, %H:%M"`
        DATE=`builtin printf '%(%d %b, %H:%M)T' -1`
    fi
    HOUR=`builtin printf '%(%l)T' -1`
    # HOUR=`date +"%I" | sed -re 's/^0//g'`
    if (( "$HOUR" == 12 ))
    then
        HOUR=0
    fi
    CHR=$((0xE381+HOUR))
    ICON=$(printf "\u"`printf %x $CHR`)
    # color "$ICON " 4
    color "$DATE" 4
}
#echo -en " #[default,fg=colour$NORMAL_COLOR]$DATE#[default]"
# }}}
# battery: Battery status {{{
function battery() {
    if ! test -d /sys/class/power_supply/BAT0
    then
        return 1
    fi
    # BATT=`acpi -b`
    # [[ $BATT =~ Battery\ ([0-9]):\ ([a-zA-Z\ ]+),\ ([0-9]+) ]]
    # STATE=${BASH_REMATCH[2]}
    # CHARGE=${BASH_REMATCH[3]}
    STATE=$(</sys/class/power_supply/BAT0/status)
    CHARGE=$(</sys/class/power_supply/BAT0/capacity)
    ICON='\uF578'
    if [ "$STATE" == "Charging" ] || [ "$STATE" == "Full" ] || [ "$STATE" == "Not charging" ]
    then
        CHARGING=1
        ICON='\uF0E7'
    else
        CHARGING=0
        ICON='\uF578'
        ICON='\u2665'
    fi
    CHARGE_ALIGNED=`printf %-3d $CHARGE`
    if (( $CHARGE < 10 )) && (( $CHARGING == 0 ))
    then
        # warn "$ICON $CHARGE_ALIGNED%"
        color "$ICON $CHARGE_ALIGNED%" 0
        # ~/.scripts/not.sh "{\"message\":\"$CHARGE\"}"
    else
        color "$ICON " 2
        color "$CHARGE_ALIGNED%" 2
    fi
}
# }}}

# render player diskfree cpu mem netstatus now battery
render player diskfree cpu netstatus volume now battery
