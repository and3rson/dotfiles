--local beautiful = require('beautiful')
local wibox = require('wibox')
local watch = require("awful.widget.watch")

local CMD = [[date +"%a ─ %d %b ─ %H:%M:%S"]]

local ICONS = {
    day='',
    night=''
}

local date_widget = wibox.widget{
    paddings=2,
    markup='~',
    --font=beautiful.pixel_font,
    widget=wibox.widget.textbox
}

local update_widget = function(widget, stdout, _, _, _)
    local icon_name
    local icon_color
    local hour = tonumber(os.date('%H'))
    if hour < 6 or hour > 18 then
        icon_name = 'night'
        icon_color = '#7777FF'
    else
        icon_name = 'day'
        icon_color = '#FFFF77'
    end
    widget.markup = '<span size="2000"> </span><span color="' .. icon_color .. '" size="8000">' ..
        ICONS[icon_name] ..
        ' ' ..
        stdout ..
        '</span> '
end

-- TODO: Replace with os.date
watch(CMD, 1, update_widget, date_widget)

--return wibox.container.margin(date_widget, 2, 2, 2, 2)
return date_widget

