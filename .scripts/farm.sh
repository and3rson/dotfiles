#!/bin/bash

function left_down {
    xdotool mousedown 1
}

function left_up {
    xdotool mouseup 1
}

function right_down {
    xdotool mousedown 3
}

function right_up {
    xdotool mouseup 3
}

while true
do
    right_up
    sleep 0.05
    left_down
    sleep 0.05
    left_up
    right_down
    sleep 0.55
done
