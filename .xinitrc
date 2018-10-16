#!/bin/bash

export TERM=screen-256color

if [[ "$HOSTNAME" == "envy" ]]
then
    pacman -Ss lib32-nvidia-libgl | grep '\[' > /dev/null
    #NVIDIA_LIBGL=$?
    #NVIDIA_LIBGL=0

    if [[ $NVIDIA_LIBGL -eq 0 ]]
    then
        # NVIDIA LIBGL
        xrandr --setprovideroutputsource modesetting NVIDIA-0
        xrandr --setprovideroffloadsink nouveau Intel
        xrandr --auto
        xrandr --output VGA-1-0 --addmode VGA-1-0 1920x1080
    else
        # MESA WITH BUMBLEBEE
    #   echo a
    #   xcompmgr
        xrandr --output VGA1 --addmode VGA1 1920x1080
    fi

fi
# setxkbmap 'us,ru,ua' -option grp:lalt_lshift_toggle -option numpad:microsoft

dbus-update-activation-environment --all

export LANG=uk_UA.UTF8

#if [[ -z "$1" ]]
#then
#    echo Starting qTile
#    qtile > ~/.qtile.log
#else
#    ${@}
#    echo Starting ${@}
#fi

if [[ -z "$1" ]]
then
    echo Starting AwesomeWM
    start-pulseaudio-x11-mod
    compton --config ~/.compton.conf -b -f
    xbanish &
    ~/.config/qtile/bin/kbfix.sh
    ~/.config/qtile/bin/set_bg.sh

    nm-applet &
    blueman-applet &

    termite --class HomeTerm -e /sh/stmux.sh &
    #chromium &
    firefox-developer-edition &
    telegram-desktop &
    slack &
    irccloud &
    #evolution &
    #gpmdp &
    #/sh/xclay.sh &

    awesome > ~/.awesome.log
else
    ${@}
    echo Starting ${@}
fi

exit


# Old commands - just in case...
# xrandr --output VGA1 --right-of LVDS-1-0 --pos 1366x432
# nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUCurrentFanSpeed=n"
# mate-session

