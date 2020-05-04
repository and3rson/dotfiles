#!/bin/bash

export DISPLAY=:0

while read -r line
do
    or=`echo $line | grep -Po '(?<=: )(.[\w-]+)'`
    device=pointer:`xinput list --name-only | grep -i silead | head -n 1`
    if [[ "$or" == "bottom-up" ]]
    then
        xrandr --output eDP1 --rotate inverted
        xinput set-prop "$device" 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1
        # xinput set-prop 'HTIX5288:00 0911:5288 Touchpad' 'Device Enabled' 0
    elif [[ "$or" == "left-up" ]]  # Actually right-up
    then
        xrandr --output eDP1 --rotate right
        xinput set-prop $device 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
        # xinput set-prop 'HTIX5288:00 0911:5288 Touchpad' 'Device Enabled' 0
    elif [[ "$or" == "right-up" ]]  # Actually left-up
    then
        xrandr --output eDP1 --rotate left
        xinput set-prop $device 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1
        # xinput set-prop 'HTIX5288:00 0911:5288 Touchpad' 'Device Enabled' 0
    elif [[ "$or" == "normal" ]]
    then
        xrandr --output eDP1 --rotate normal
        xinput set-prop $device 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1
        # xinput set-prop 'HTIX5288:00 0911:5288 Touchpad' 'Device Enabled' 1
    fi
done < <(monitor-sensor)
