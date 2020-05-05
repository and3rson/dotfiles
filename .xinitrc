#!/usr/bin/env /bin/bash

export TERM=screen-256color
export LANG=uk_UA.UTF8

dbus-update-activation-environment --all

awesome > ~/.awesome.log

# $SHELL $HOME/.init 2>&1 > /tmp/xinitrc.log
