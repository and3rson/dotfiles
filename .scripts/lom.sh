#!/bin/bash
echo
CHARS=' ▁▂▃▄▅▆▇█'
IP=`dig +short lom.lan`
while read line
do
    # echo $line > /dev/udp/192.168.0.138/1337
    # 2C:3A:E8:0C:47:D0
    echo -n $line | netcat -w0 -u $IP 1337
    IFS=';'
    echo -en '\r'
    for c in $line
    do
        echo -n ${CHARS:$c:1}
    done
    echo -n ' '
    # echo $line
done < <(cava -p ~/.config/cava/config.lom)
