#!/bin/bash

sleep 1
WID=`xdotool getactivewindow`

# Chests

sx=144
sy=136

x1=316
y1=420
x2=1603
y2=693

x3=949
y3=986

# Bonus stages

x4=682
y4=880
x5=1218
y5=880
x4a=682
y4a=840
x5a=1218
y5a=840

x6=1078
y6=823

# Super boxes

x7=964
y7=25

DO=xdotool
OPTS="--window=$WID"

function click {
    $DO mousedown $OPTS $1
    # sleep 0.005
    $DO mouseup $OPTS $1
    # sleep 0.005
}

i=0
while true
do
    # Chests
    # $DO keydown space
    # sleep 0.15
    for yi in `seq 0 2`
    do
        for xi in `seq 0 9`
        do
            $DO mousemove $OPTS $((x1 + sx * xi)) $((y1 + sy * yi))
            click 1
        done
    done
    $DO mousemove $OPTS $x3 $y3
    click 1
    # $DO keyup space

    # Bonus stages
    $DO mousemove $OPTS $x4 $y4
    $DO mousedown $OPTS 1
    $DO mousemove $OPTS $x5 $y5
    $DO mouseup $OPTS 1
    $DO mousedown $OPTS 1
    $DO mousemove $OPTS $x4 $y4
    $DO mouseup $OPTS 1

    $DO mousemove $OPTS $x4a $y4a
    $DO mousedown $OPTS 1
    $DO mousemove $OPTS $x5a $y5a
    $DO mouseup $OPTS 1
    $DO mousedown $OPTS 1
    $DO mousemove $OPTS $x4a $y4a
    $DO mouseup $OPTS 1

    $DO mousemove $OPTS $x6 $y6
    click 1

    # Acceleration
    click 3
    # Superbox
    $DO mousemove $OPTS $x7 $y7
    click 1
    # $DO click 1
    # sleep 0.2
done
