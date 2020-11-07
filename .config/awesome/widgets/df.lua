local wibox = require('wibox')
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")

local CMD = [[stat -f / --format "%b %a %s"]]

return function(s)
    local progressbar = wibox.widget {
        forced_width=10,
        max_value=100,
        value=0,
        background_color=beautiful.bg_weak,
        color=beautiful.fg_normal,
        widget=wibox.widget.progressbar,
        margins=beautiful.progressbar_margins
    }

    local df_widget = wibox.widget{
        paddings=2,
        markup='~',
        widget=wibox.widget.textbox
    }

    local update_widget = function(widget, stdout, _, _, _)
        local parts = stdout:gmatch('%S+')
        local blocks_total = tonumber(parts())
        local blocks_free = tonumber(parts())
        local block_size = tonumber(parts())

        local percentage = (1 - blocks_free / blocks_total) * 100

        widget.markup = string.format(
            '%.1f',
            block_size * blocks_free / (1024 ^ 3)
        ) .. ' GB'
        if percentage > 90 then
            widget.markup = '<span color="' .. beautiful.bg_focus .. '">' .. widget.markup .. '</span>'
            progressbar.color = beautiful.bg_focus
        else
            progressbar.color = beautiful.fg_normal
        end
        progressbar.value = percentage
    end

    watch(CMD, 10, update_widget, df_widget)

    return wibox.widget{
        progressbar,
        df_widget,
        layout=wibox.layout.stack
    }
end
