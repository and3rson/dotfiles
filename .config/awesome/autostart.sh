#!/usr/bin/env /bin/bash

set -x

echo "Display: $DISPLAY"

(
    if [[ -z "$1" ]]
    then
        echo Starting AwesomeWM

        # https://github.com/tryone144/compton
        #compton --config ~/.compton.conf -b -f --backend glx --blur-background --blur-kern=3x3gaussian --inactive-dim-fixed
        picom --config ~/.compton.conf -b -f
        xbanish &
        xsetroot -cursor_name X_cursor
        xcape -e 'Overlay1_Enable=Escape' -t 90
        ~/.scripts/init_kb.sh
        ~/.scripts/init_mouse.sh
        # touchegg &
        (sleep 5 && touchegg) &
        # echo $?
        # strace /usr/bin/touhegg
        # echo $?
        # strace ls
        # echo $?
        #python3 ~/.scripts/not.py &
        # ~/.scripts/iio.sh &

        # Daemons
        start-pulseaudio-x11 &
        nm-applet 2>&1 > /dev/null &
        blueman-applet 2>&1 > /dev/null &
        dunst &

        # Apps
        termite --class HomeTerm -e ~/.scripts/stmux.sh &
        firefox-developer-edition 2>&1 > /dev/null &
        telegram-desktop &
        slack &
        #irccloud &
        /opt/Todoist/todoist &
        #~/.scripts/media_notifier.sh &
        export GPMDP_API_PORT=5673 gpmdp &
        #termite -c ~/.config/termite/config.cava -e cava &

        systemctl --user start not

    #     awesome > ~/.awesome.log
    # else
    #     echo Starting ${@}
    #     ${@}
    fi
) 2>&1 | tee > /tmp/autostart.log
