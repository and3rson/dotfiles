local wibox = require('wibox')
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local gears = require("gears")
local utils = require("../utils")

local CMD = [[stat -f / --format "%b %a %s"]]

return function()
    local progressbar = wibox.widget {
        forced_width=10,
        max_value=100,
        value=0,
        background_color=beautiful.bg_weak,
        color=beautiful.fg_term_icon,
        widget=wibox.widget.progressbar,
        margins=beautiful.progressbar_margins
        --margins={
        --    top=23
        --}
    }

    local icon = wibox.widget{
        paddings=2,
        markup='<span color="' .. beautiful.fg_term_icon .. '"><span size="12000"></span></span>',
        widget=wibox.widget.textbox
    }

    local widget = wibox.widget{
        paddings=2,
        markup='~',
        widget=wibox.widget.textbox
    }

    local update_widget = function()
        local temp = tonumber(utils.getline('/sys/class/thermal/thermal_zone0/temp')) / 1000
        local temp_max = 100
        --local temp_max = tonumber(io.lines('/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_max')()) / 1000
        --local parts = stdout:gmatch('%S+')
        --local blocks_total = tonumber(parts())
        --local blocks_free = tonumber(parts())
        --local block_size = tonumber(parts())

        local percentage = temp / temp_max * 100

        widget.markup = '<span color="' .. beautiful.fg_term_text .. '">' .. temp .. '°C</span>'
        progressbar.value = percentage
    end

    gears.timer {
        timeout=1,
        autostart=true,
        callback=update_widget
    }

    return utils.make_row({
        -- icon,
        wibox.widget({
            progressbar,
            wibox.container.margin(widget, 0, 0, 0, 2),
            layout=wibox.layout.stack
        })
    })
end
