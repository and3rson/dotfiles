local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local watch = require("awful.widget.watch")

local CMD = "bash -c \"amixer -D pulse get Master -c 1 -M | grep -o -E '[[:digit:]]+%'\""

--local volume_widget = wibox.widget{
--    markup='~',
--    widget=wibox.widget.textbox
--}

local icon = wibox.widget{
    text=' ',
    widget=wibox.widget.textbox
}

local volume_widget = wibox.widget{
    widget=wibox.widget.progressbar,
    forced_width=40,
    clip=true,
    max_value=100,
    value=0,
    shape=gears.shape.bar,
    background_color=beautiful.bg_minimize,
    color=beautiful.bg_focus,
    margins={
        top=7,
        bottom=7
    }
}

local volume_value = wibox.widget{
    text='~',
    widget=wibox.widget.textbox
}

local update_widget = function(widgets, stdout, _, _, _)
    local value = stdout:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%%", "")
    local n, _ = tonumber(value)
    widgets[1].value = n
    widgets[2].text = value .. '%'
    --widget.markup = '<b><span>  ' .. value .. '</span></b>'
end

watch(CMD, 0.5, update_widget, {volume_widget, volume_value})

--return wibox.container.margin(volume_widget, 2, 2, 2, 2)
local layout = wibox.layout.fixed.horizontal()
layout.spacing = 8
local widget = wibox.widget{
    icon,
    volume_widget,
    volume_value,
    layout=layout
}

widget:connect_signal('button::press', function(lx, ly, button, mods, find_widgets_result)
    awful.util.spawn('pavucontrol')
end)

return widget

