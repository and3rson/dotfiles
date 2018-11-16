#!/bin/bash

. ~/.bashrc.d/91_secure

API=http://kv.dun.ai
PASSWORD=${TODO_PASS}

curl $API/docs/todo?password=$PASSWORD > /tmp/todo
perl -i -p -e 's/\\n/\n/g' /tmp/todo
# perl -i -p -e 's/\n+$/\n/g' /tmp/todo
vim /tmp/todo
perl -i -p -e 's/\n/\\n/g' /tmp/todo
curl -X POST $API/docs/todo?password=$PASSWORD --data-urlencode "value=`cat /tmp/todo`"
