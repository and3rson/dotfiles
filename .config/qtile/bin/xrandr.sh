#!/bin/bash

PWD=`dirname $0`

function setup_1_screen {
    xrandr --output HDMI1 --off --output eDP1 --auto
    synclient AccelFactor=0.08
}

function setup_2_screens {
    xrandr --output HDMI1 --auto --left-of eDP1
    synclient AccelFactor=0.03
}

# MON_COUNT=$(xrandr --listactivemonitors | grep Monitors --color=never | egrep -o "([0-9]+)")
MON_COUNT=$(xrandr | grep 'HDMI1 conn' > /dev/null && echo 2 || echo 1)

echo "Monitors: ${MON_COUNT}"

case $MON_COUNT in
    "1")
        setup_1_screen
        ;;
    "2")
        setup_2_screens
        ;;
esac

$PWD/set_bg.sh
