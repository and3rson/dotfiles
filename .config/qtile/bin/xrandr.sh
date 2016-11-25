#!/bin/bash

function do_xrandr {
    xrandr --output VGA1 --auto --output HDMI1 --auto --right-of eDP1
}

function setup_1_screen {
    do_xrandr
    synclient AccelFactor=0.08
}

function setup_2_screens {
    do_xrandr
    synclient AccelFactor=0.03
}

MON_COUNT=$(xrandr --listactivemonitors | grep Monitors --color=never | egrep -o "([0-9]+)")

case $MON_COUNT in
    "1")
        setup_1_screen
        ;;
    "2")
        setup_2_screens
        ;;
esac
