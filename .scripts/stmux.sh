#!/bin/bash

# tmux ls && (tmux setenv -g SWAYSOCK $SWAYSOCK && tmux a) || tmux
tmux ls && tmux a || tmux
