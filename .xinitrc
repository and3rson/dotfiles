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
        xrandr --setprovideroutputsource modesetting nvidia-0
        xrandr --setprovideroffloadsink nouveau intel
        xrandr --auto
        xrandr --output vga-1-0 --addmode vga-1-0 1920x1080
    else
        # MESA WITH BUMBLEBEE
    #   echo a
    #   xcompmgr
        xrandr --output VGA1 --addmode VGA1 1920x1080
    fi

fi
# setxkbmap 'us,ru,ua' -option grp:lalt_lshift_toggle -option numpad:microsoft


#xrandr --setprovideroutputsource modesetting NVIDIA-0
#xrandr --auto

#xrandr --setprovideroutputsource modesetting nvidia-0
#xrandr --setprovideroffloadsink nouveau intel
#xrandr --auto
#xrandr --output vga-1-0 --addmode vga-1-0 1920x1080

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
    start-pulseaudio-x11 &
    #compton --config ~/.compton.conf -b -f --backend glx --blur-background --blur-kern=3x3gaussian --inactive-dim-fixed
    # https://github.com/tryone144/compton
    compton --config ~/.compton.conf -b -f
    xbanish &
    #xcape -e 'Overlay1_Enable=Escape'
    ~/.scripts/kbfix.sh
    ~/.scripts/set_bg.sh

    #xinput set-prop 'TPPS/2 IBM TrackPoint' 323 -0.5
    xinput set-prop 'TPPS/2 IBM TrackPoint' 'Device Accel Constant Deceleration' 1.8
    xinput set-prop 'TPPS/2 IBM TrackPoint' 'Device Accel Velocity Scaling' 5

    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200

    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5

    xinput set-prop 'TPPS/2 IBM TrackPoint' 'Evdev Wheel Emulation Inertia' 25

    synclient CoastingSpeed=0 VertScrollDelta=500 HorizScrollDelta=500

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

