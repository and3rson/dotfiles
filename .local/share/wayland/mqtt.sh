#!/bin/bash

mkdir -p ~/.mqtt

mosquitto_sub -h server.lan -u anderson -P 11235813 -t 'devices/note8pro/#' -v | while read key value
do
    fname=${key//\//_}
    echo -n $value > ~/.mqtt/$fname
done
