# Check for an interactive session
[ -z "$PS1" ] && return

SH=$0

# for script in ~/.bashrc.d/*
for script in `run-parts ~/.bashrc.d --test`
do
    . $script
done

#set -o vi

