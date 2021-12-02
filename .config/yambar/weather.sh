#!/bin/bash

set -e

. ~/.config/env.conf

OWM_URL='http://api.openweathermap.org/data/2.5/weather?appid='$OWM_APPID'&q=Lviv,Ukraine&lang=ua'

echo "icon|string|..."
echo "temp|int|0"
echo "feels_like|int|0"
echo

while true
do
    read -r id temp feels_like < <(curl -s $OWM_URL | jq -r '[.weather[0].id, (.main.temp - 273.15 | round), (.main.feels_like - 273.15 | round)] | @tsv')
    icon=$((60000+$id))
    echo "icon|string|$(builtin echo -e \\u`builtin printf %x $icon`)"
    echo "temp|int|$temp"
    echo "feels_like|int|$feels_like"
    echo
    sleep 60
done
