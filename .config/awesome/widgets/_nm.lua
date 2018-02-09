local gears = require('gears')
local watch = require('awful.widget.watch')

CMD = 'bash -c "LANG=en_US nmcli d"'

watch(CMD, 2)

