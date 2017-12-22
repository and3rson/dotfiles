#!/bin/bash

# exec tmux
tmux ls 2> /dev/null && tmux attach || tmux -2

