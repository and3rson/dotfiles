#!/bin/bash
WALLPAPER="$HOME/.wallpapers/lights1920.png"
insidecolor=00000000
ringcolor=ffffff10
keyhlcolor=ff0033ff
bshlcolor=ff0033ff
separatorcolor=00000000
insidevercolor=00000000
insidewrongcolor=ff0033ff
ringvercolor=ff0033ff
ringwrongcolor=ff0033ff
verifcolor=ffffff80
timecolor=ffffffff
datecolor=ffffffff
loginbox=00000066
font="Sans"
locktext='Who are you?'
i3lock \
    -t -i "$WALLPAPER" \
    --timepos='x+110:h-70' \
    --datepos='x+43:h-45' \
    --clock --date-align 1 --datestr "$locktext" \
    --insidecolor=$insidecolor --ringcolor=$ringcolor --line-uses-inside \
    --keyhlcolor=$keyhlcolor --bshlcolor=$bshlcolor --separatorcolor=$separatorcolor \
    --insidevercolor=$insidevercolor --insidewrongcolor=$insidewrongcolor \
    --ringvercolor=$ringvercolor --ringwrongcolor=$ringwrongcolor --indpos='x+280:h-70' \
    --radius=20 --ring-width=4 --veriftext='' --wrongtext='' \
    --verifcolor="$verifcolor" --timecolor="$timecolor" --datecolor="$datecolor" \
    --time-font="$font" --date-font="$font" --layout-font="$font" --verif-font="$font" --wrong-font="$font" \
    --noinputtext='' --force-clock --pass-media-keys $lockargs
