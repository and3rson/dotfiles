#!/bin/bash

enable -f /usr/lib/bash/sleep sleep

GRAPH=""
for i in `seq 8`
do
    GRAPH="$GRAPH、"
done

# echo "high|bool|false"
# echo "value|string|`builtin printf %2d $value`"
# echo "bar|string|$GRAPH"
# echo

while true
do
    IFS=' ' read total used <<< `free -b | sed '2q;d' | awk '{print $2" "$3}'`
    mem_fraction=$((used*100/total))

    value=$mem_fraction
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
    GRAPH="$GRAPH$CH"
    if (( ${#GRAPH} > 8 ))
    then
        GRAPH=${GRAPH: -8}
    fi
    high=false
    if (( $value > 80 ))
    then
        high=true
    fi
    echo -e "high|bool|$high\nvalue|string|`builtin printf %2d $value`\nbar|string|$GRAPH\n"

    # sleep 0.5
    sleep 1

    # if [ $(($cpu_fraction > 50)) -eq "1" ]
    # then
    #     color "$graph `printf %3s $cpu_fraction%`" 0
    # else
    #     color "$graph `printf %3s $cpu_fraction%`" 1
    # fi
done
