while read line
do
    IFS='.' read -r -a PARTS <<< $line
    HEADER=`echo ${PARTS[0]} | base64 -di | yq -y`
    BODY=`echo ${PARTS[1]} | base64 -di | yq -y`
    DATA="$HEADER"$'\n---\n'"$BODY"
    # printf -- '-%.0s' {1..48}
    echo "$DATA" | highlight -S yaml -O xterm256 -s molokai
done < /dev/stdin
