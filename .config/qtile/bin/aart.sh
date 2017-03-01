#!/bin/bash

DIR=~/.cache/aart

URL=$1
# FILE=$(mktemp --suffix=.jpg)
# CONVERTED=$(mktemp --suffix=.png)
HASH=$(echo -n $URL | md5sum | cut -d ' ' -f 1)
FILE=$DIR/$HASH.jpg
CONVERTED=$DIR/$HASH.png

if [[ -f $CONVERTED ]]
then
    echo $CONVERTED
    exit
fi

mkdir -p $DIR

wget -qO- $URL > $FILE
convert $FILE -scale 128 $CONVERTED

rm -f $FILE

echo $CONVERTED
