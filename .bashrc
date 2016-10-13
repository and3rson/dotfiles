# Check for an interactive session
[ -z "$PS1" ] && return

for script in ~/.bashrc.d/*
do
    . $script
done
