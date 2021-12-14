#!/bin/bash

LC_ALL=C nmcli monitor | egrep -v 'connection profile|device created|device removed' --line-buffered | while read -r line
do
    notify-send --hint=string:x-dunst-stack-tag:nm "$line" -t 2000 -i /usr/share/icons/Numix/48/notifications/notification-network-wireless-connected.svg
done
