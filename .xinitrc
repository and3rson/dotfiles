#!/usr/bin/env /bin/bash

export TERM=screen-256color
export LANG=uk_UA.UTF8

dbus-update-activation-environment --all

if [[ -z "$1" ]]
then
    echo Starting AwesomeWM

    # https://github.com/tryone144/compton
    #compton --config ~/.compton.conf -b -f --backend glx --blur-background --blur-kern=3x3gaussian --inactive-dim-fixed
    compton --config ~/.compton.conf -b -f
    xbanish &
    xsetroot -cursor_name X_cursor
    xcape -e 'Overlay1_Enable=Escape' -t 90
    ~/.scripts/init_kb.sh
    ~/.scripts/init_mouse.sh
    #python3 ~/.scripts/not.py &

    # Daemons
    start-pulseaudio-x11 &
    nm-applet &
    blueman-applet &
    dunst &

    # Apps
    termite --class HomeTerm -e ~/.scripts/stmux.sh &
    firefox-developer-edition &
    telegram-desktop &
    slack &
    #irccloud &
    /opt/Todoist/todoist &

    systemctl --user start not

    awesome > ~/.awesome.log
else
    echo Starting ${@}
    ${@}
fi
