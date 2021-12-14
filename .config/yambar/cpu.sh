#!/bin/bash

enable -f /usr/lib/bash/sleep sleep

GRAPH=""
for i in `seq 16`
do
    GRAPH="$GRAPH、　"
done

echo "high|bool|false"
echo "value|string|`builtin printf %2d $value`"
echo "bar|string|$GRAPH"
echo

while true
do
    read cpu user nice system idle iowait irq softirq steal guest< /proc/stat
    cpu_active_prev=$((user+system+nice+softirq+steal))
    cpu_total_prev=$((user+system+nice+softirq+steal+idle+iowait))
    sleep 0.25
    read cpu user nice system idle iowait irq softirq steal guest< /proc/stat
    cpu_active_cur=$((user+system+nice+softirq+steal))
    cpu_total_cur=$((user+system+nice+softirq+steal+idle+iowait))
    cpu_util=$((100*( cpu_active_cur-cpu_active_prev ) / (cpu_total_cur-cpu_total_prev) ))

    value=$cpu_util
    if (( $value > 99 ))
    then
        value=99
    elif (( value < 0 ))
    then
        value=0
    fi
    CHARS='、。〃〄々〆〇〈'
    I=$((value*8/100))
    if (( $I > 7 ))
    then
        I=7
    fi
    CH=${CHARS:$I:1}
    GRAPH="$GRAPH$CH　"
    if (( ${#GRAPH} > 32 ))
    then
        GRAPH=${GRAPH: -32}
    fi
    if (( $value > 50 ))
    then
        echo "high|bool|true"
    else
        echo "high|bool|false"
    fi
    echo "value|string|`builtin printf %2d $value`"
    echo "bar|string|$GRAPH"
    echo

    # if [ $(($cpu_fraction > 50)) -eq "1" ]
    # then
    #     color "$graph `printf %3s $cpu_fraction%`" 0
    # else
    #     color "$graph `printf %3s $cpu_fraction%`" 1
    # fi
done
