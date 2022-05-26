#!/bin/bash

enable -f /usr/lib/bash/sleep sleep

CPUS=`cat /proc/stat | grep -o 'cpu[0-9]\+'`
CPU_COUNT=`echo $CPUS | wc -w`
# echo $CPU_COUNT

GRAPH=""
for i in $CPUS
do
    GRAPH="$GRAPH、　"
done

echo "high|bool|false"
echo "value|string|`builtin printf %2d $value`"
echo "bar|string|$GRAPH"
echo

while true
do
    declare -A cpu_active_prev cpu_total_prev cpu_util
    for cpu in $CPUS
    do
        read cpu user nice system idle iowait irq softirq steal guest <<<$(grep $cpu /proc/stat)
        cpu_active_prev[$cpu]=$((user+system+nice+softirq+steal))
        cpu_total_prev[$cpu]=$((user+system+nice+softirq+steal+idle+iowait))
    done
    sleep 0.25
    total=0
    for cpu in $CPUS
    do
        read cpu user nice system idle iowait irq softirq steal guest <<<$(grep $cpu /proc/stat)
        cpu_active_cur=$((user+system+nice+softirq+steal))
        cpu_total_cur=$((user+system+nice+softirq+steal+idle+iowait))
        cpu_util[$cpu]=$((100*( cpu_active_cur-${cpu_active_prev[$cpu]} ) / (cpu_total_cur-${cpu_total_prev[$cpu]}) ))
        total=$(($total+${cpu_util[$cpu]}))
    done
    total=$(($total/$CPU_COUNT))

    GRAPH=""
    for cpu in $CPUS
    do
        value=${cpu_util[$cpu]}

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
    done

    echo "value|string|`builtin printf %2d $total`"
    echo "bar|string|$GRAPH"
    if (( $total > 50 ))
    then
        echo "high|bool|true"
    else
        echo "high|bool|false"
    fi
    echo
    continue

    CH=${CHARS:$I:1}
    GRAPH="$GRAPH$CH　"
    if (( ${#GRAPH} > 8 ))
    then
        GRAPH=${GRAPH: -8}
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
