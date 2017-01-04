#!/bin/bash

if ! [[ `test -f /etc/issue && cat /etc/issue | grep "Arch Linux"` ]]
then
    echo "This script can only run on Arch Linux. :("
    exit 1
fi

if ! [[ `id -u` -eq "0x" ]]
then
   echo "I am not root!"
   exit 1
fi

if [[ -z "$1" ]]
then
    echo -e "Usage:\n    sudo ./install-deps.sh USERNAME"
    exit 0
fi

USERNAME=$1

id ${USERNAME} > /dev/null 2>&1

if ! [[ "$?" -eq "0" ]]
then
    echo "Unknown user: ${USERNAME}"
    exit 1
fi

pacman --noconfirm -S \
    powerline-common \
    powerline-fonts \
    python2-powerline \
    python2-cairocffi \
    python2-virtualenv \
    git \
    compton \
    redis \
    feh \
    roxterm \
    bluez bluez-firmware bluez-libs bluez-plugins bluez-utils bluez-utils \
    pulseaudio-bluetooth \
    hexchat \
    xorg-xbacklight \
    python2-pyudev \
    xscreensaver-arch-logo \
    faenza-icon-theme \
    adwaita-icon-theme \
    dunst \
&& \
sudo systemctl daemon-reload \
&& \
sudo systemctl enable redis \
&& \
sudo systemctl start redis \
&& \
sudo -u ${USERNAME} yaourt --noconfirm -S \
    nerd-fonts-git \
    qtile-git \
    xkblayout-state \
    hsetroot \
    xlogin-git \
    dmenu2 \
    simplenote-electron-bin \
    rofi-git \
    numix-circle-icon-theme-git \
    xseticon \
    paper-icon-theme-git \
&& \
pip2.7 install \
    google-api-python-client \
    Babel \
    pytz \
    feedparser \
    iwlib \
    redis==2.10.5 \
    pulsectl \
    python-dateutil==2.6.0 \
    -U \
&& \
echo "All done!"
