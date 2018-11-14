-------------------------------------------------
-- CPU Widget for Awesome Window Manager
-- Shows the current CPU utilization
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/cpu-widget

-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov
-------------------------------------------------

local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local utils = require("../utils")

local icon = wibox.widget{
    --markup='<span size="2000"> </span><span size="8000" color="#74aeab"></span>',
    markup='<span size="8000" color="#7777FF">ﳻ</span>',
    widget=wibox.widget.textbox
}

local value = wibox.widget{
    markup='~',
    widget=wibox.widget.textbox
}

local update = function()
    local busid, state = utils.getline('/proc/acpi/bbswitch'):match('(.*) (.*)')
    fg = beautiful.fg_bright
    if state == 'ON' then
        fg = beautiful.fg_urgent
    end
    icon.markup = string.format('<span size="8000" color="%s">ﳻ</span>', fg)
    value.markup = string.format('<span color="%s">%s</span>', fg, state)
end

gears.timer {
    timeout=1,
    autostart=true,
    callback=update
}

update()

local layout = wibox.layout.fixed.horizontal()
layout.spacing = 8
local widget = wibox.widget{
    icon,
    value,
    layout=layout
}
return widget

