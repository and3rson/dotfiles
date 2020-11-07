#!/usr/bin/env /bin/bash

set -x

echo "Display: $DISPLAY"

# xrandr --output HDMI-1 --newmode "360x720_50.03"   16.75  360 376 408 456  720 723 733 744 -hsync +vsync
# xrandr --addmode HDMI1 360x720_50.03
# xrandr --output HDMI1 --mode 1080x2160 --rotate right --scale 0.35x0.35 --pos 1920x1078

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

        # systemctl --user start not

        spotify &

        if [[ "`cat /etc/hostname`" == "vivo" ]]
        then
            # GDK_DPI_SCALE=3
            termite --class PadTerm -e 'htop -d 5' &
        fi

    #     awesome > ~/.awesome.log
    # else
    #     echo Starting ${@}
    #     ${@}
    fi
) 2>&1 | tee > /tmp/autostart.log
