local wibox = require('wibox')
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local gears = require("gears")
local utils = require("../utils")

local CMD = [[stat -f / --format "%b %a %s"]]

local progressbar = wibox.widget {
    forced_width=10,
    max_value=100,
    value=0,
    background_color=beautiful.bg_minimize,
    color=beautiful.fg_term,
    widget=wibox.widget.progressbar,
    margins={
        bottom=22
    }
}

local df_widget = wibox.widget{
    paddings=2,
    markup='~',
    widget=wibox.widget.textbox
}

local update_widget = function()
    local cur_state = tonumber(utils.getline('/sys/class/thermal/cooling_device0/cur_state'))
    local max_state = tonumber(utils.getline('/sys/class/thermal/cooling_device0/max_state'))
    local icon = ''

    local percentage = cur_state / max_state * 100

    df_widget.markup = '<span size="14000">' .. icon .. '</span> <span>' .. cur_state .. '/' .. max_state .. '</span>'
    progressbar.value = percentage
end

gears.timer {
    timeout=0.2,
    autostart=true,
    callback=update_widget
}

return wibox.widget{
    progressbar,
    df_widget,
    layout=wibox.layout.stack
}

