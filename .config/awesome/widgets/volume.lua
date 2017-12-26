local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local ICONS = {
    speaker=' ',
    headphones=' '
}

local volume
local default_sink

local icon = wibox.widget{
    text=' ~',
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

local update_widget = function()
    local f = io.popen('pacmd dump')

    if f == nil then
        return false
    end

    local stdout = f:read("*a")
    f:close()

    default_sink = stdout:match('set%-default%-sink (%S+)\n')
    volume = stdout:match('set%-sink%-volume ' .. default_sink:gsub('%.', '%%.'):gsub('%-', '%%-') .. ' (%S+)\n')
    volume = tonumber(volume)
    local value = math.floor(volume / 0x10000 * 100)
    --local value = stdout:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%%", "")
    --local n, _ = tonumber(value)
    if default_sink:match('bluez') then
        icon.text = ICONS.headphones
    else
        icon.text = ICONS.speaker
    end
    volume_widget.value = value
    volume_value.text = value .. '%'
    --widget.markup = '<b><span>  ' .. value .. '</span></b>'
end

local modify_volume = function(diff)
    volume = math.floor(volume + diff / 100 * 0x10000)
    awful.util.spawn('pacmd set-sink-volume ' .. default_sink .. ' ' .. string.format('0x%x', math.floor(volume)))
    update_widget()
end

gears.timer {
    timeout=1,
    autostart=true,
    callback=update_widget
}

local layout = wibox.layout.fixed.horizontal()
layout.spacing = 8
local widget = wibox.widget{
    icon,
    volume_widget,
    volume_value,
    layout=layout
}

widget.increase_volume = function() modify_volume(2) end
widget.decrease_volume = function() modify_volume(-2) end

widget:connect_signal('button::press', function(lx, ly, button, mods, find_widgets_result)
    awful.util.spawn('pavucontrol')
end)

return widget

