# Check for an interactive session
[ -z "$PS1" ] && return

SH=$0

for script in ~/.bashrc.d/*
do
    . $script
done

