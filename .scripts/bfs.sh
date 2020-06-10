#!/bin/bash
echo
CHARS=' ▁▂▃▄▅▆▇█'
while read line
do
    # echo $line > /dev/udp/192.168.0.137/1337
    echo -n $line | netcat -w0 -u 192.168.0.137 1337
    IFS=';'
    echo -en '\r'
    for c in $line
    do
        echo -n ${CHARS:$c:1}
    done
    echo -n ' '
    # echo $line
done < <(cava -p ~/.config/cava/config.bfs)
