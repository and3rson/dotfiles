#!/bin/bash

#. ~/.bashrc.d/00_colors
function fore() {
    echo -n "\[\e[38;5;$1m\]"
}

function back() {
    echo -n "\[\e[48;5;$1m\]"
}

RST="\[\e[0m\]"

function date_part() {
    fore 255
    back 125
    date +" %H:%M:%S $RST"
}

function git_part() {
    false
}

function pwd_part() {
    false
}

function venv_part() {
    if [[ ! -z "$VIRTUAL_ENV" ]]
    then
        back 22
        echo -n " "
        echo -en "$VIRTUAL_ENV $RST" | awk -F/ '{print $(NF-1)"/"$NF}' | tr -d '\n'
    elif [[ -f ".env/bin/activate" ]]
    then
        VIRTUAL_ENV=$( . .env/bin/activate; echo $VIRTUAL_ENV )
        back 160
        echo -n " "
        echo -en "$VIRTUAL_ENV $RST" | awk -F/ '{print $(NF-1)"/"$NF}' | tr -d '\n'
    fi
}

echo -n "$(date_part)$(venv_part)$(git_part)\n$(pwd_part) "

