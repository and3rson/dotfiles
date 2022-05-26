while read line
do
    IFS='.' read -r -a PARTS <<< $line
    HEADER=`echo ${PARTS[0]} | base64 -di | jq`
    BODY=`echo ${PARTS[1]} | base64 -di | jq`
    DATA="$HEADER"$'\n---\n'"$BODY"
    # printf -- '-%.0s' {1..48}
    echo "$DATA" | highlight -S json -O xterm256 -s molokai
done < /dev/stdin
