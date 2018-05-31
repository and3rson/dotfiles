--local beautiful = require('beautiful')
local wibox = require('wibox')
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")

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
    if hour < 6 or hour >= 18 then
        icon_name = 'night'
        --icon_color = '#AAAAFF'
        icon_color = beautiful.fg_date
    else
        icon_name = 'day'
        --icon_color = beautiful.fg_normal
        --icon_color = '#FFFF77'
        icon_color = beautiful.fg_date
    end
    --icon_color = beautiful.bg_focus
    --icon_color = beautiful.fg_normal
    widget.markup = '<span size="2000"> </span><span color="' .. icon_color .. '">' ..
        ICONS[icon_name] ..
        ' ' ..
        stdout .. '</span>'
end

-- TODO: Replace with os.date
watch(CMD, 1, update_widget, date_widget)

--return wibox.container.margin(date_widget, 2, 2, 2, 2)
return date_widget

