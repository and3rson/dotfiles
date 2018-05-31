local wibox = require('wibox')
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local gears = require("gears")

local CMD = [[stat -f / --format "%b %a %s"]]

local progressbar = wibox.widget {
    forced_width=10,
    max_value=100,
    value=0,
    background_color=beautiful.bg_minimize,
    color=beautiful.fg_term,
    widget=wibox.widget.progressbar,
    margins={
        bottom=14
    }
}

local df_widget = wibox.widget{
    paddings=2,
    markup='~',
    widget=wibox.widget.textbox
}

local update_widget = function()
    local temp = tonumber(io.lines('/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input')()) / 1000
    local temp_max = tonumber(io.lines('/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_max')()) / 1000
    --local parts = stdout:gmatch('%S+')
    --local blocks_total = tonumber(parts())
    --local blocks_free = tonumber(parts())
    --local block_size = tonumber(parts())

    local percentage = temp / temp_max * 100

    df_widget.markup = string.format(
        '<span color="' .. beautiful.fg_term .. '">%d°C</span>',
        temp
    )
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

