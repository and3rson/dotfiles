local awful = require('awful')
local wibox = require('wibox')
local watch = require("awful.widget.watch")

CMD = "date +\"%A, %d %b, %H:%M:%S\""

local date_widget = wibox.widget{
    paddings=2,
    markup='~',
    widget=wibox.widget.textbox
}

local update_widget = function(widget, stdout, _, _, _)
    widget.text = stdout
end

watch(CMD, 1, update_widget, date_widget)

--return wibox.container.margin(date_widget, 2, 2, 2, 2)
return date_widget

