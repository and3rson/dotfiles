#!/bin/bash

. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

if [[ -z "$1" ]]; then
    qtile > ~/.qtile.log
#    startxfce4
else
    $1
fi

# startxfce4
# i3
# deepin-wm
# awesome
# $1
