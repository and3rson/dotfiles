#!/bin/bash

API=http://kv.dun.ai
PASSWORD=${TODO_PASS}

curl $API/docs/todo?password=$PASSWORD > /tmp/todo
perl -i -p -e 's/\\n/\n/g' /tmp/todo
# perl -i -p -e 's/\n+$/\n/g' /tmp/todo
nano /tmp/todo
perl -i -p -e 's/\n/\\n/g' /tmp/todo
curl -X POST $API/docs/todo?password=$PASSWORD --data value=`cat /tmp/todo | head -c -2`
