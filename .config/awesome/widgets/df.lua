local wibox = require('wibox')
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")

local CMD = [[stat -f / --format "%b %a %s"]]

local progressbar = wibox.widget {
    forced_width=10,
    max_value=100,
    value=0,
    background_color='#44FF77',
    color=beautiful.bg_focus,
    widget=wibox.widget.progressbar,
    margins={
        bottom=15
    }
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
    progressbar.value = percentage
end

watch(CMD, 10, update_widget, df_widget)

return wibox.widget{
    progressbar,
    df_widget,
    layout=wibox.layout.stack
}

