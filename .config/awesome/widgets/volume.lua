local awful = require('awful')
local wibox = require('wibox')
local watch = require("awful.widget.watch")

CMD = "bash -c \"amixer -D pulse get Master -c 1 -M | grep -o -E '[[:digit:]]+%'\""

local volume_widget = wibox.widget{
    markup='~',
    widget=wibox.widget.textbox
}

local update_widget = function(widget, stdout, _, _, _)
    widget.markup = '<b><span>  ' .. stdout:gsub("^%s+", ""):gsub("%s+$", "") .. '</span></b>'
end

watch(CMD, 1, update_widget, volume_widget)

--return wibox.container.margin(volume_widget, 2, 2, 2, 2)
return volume_widget

