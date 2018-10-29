--local beautiful = require('beautiful')
local wibox = require('wibox')
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")

--local CMD = [[date +"%a ─ %d %b ─ %H:%M:%S"]]
local CMD = [[date +"%H:%M"]]

local ICONS = {
    day='盛',
    night='望'
}

local date_icon = wibox.widget {
    markup='~ ',
    widget=wibox.widget.textbox
}

local date_widget = wibox.widget{
    paddings=2,
    markup='~',
    --font=beautiful.pixel_font,
    widget=wibox.widget.textbox
}

local date_progressbar = wibox.widget {
    forced_width=10,
    max_value=23,
    value=0,
    background_color=beautiful.bg_minimize,
    color=beautiful.fg_date,
    widget=wibox.widget.progressbar,
    margins={
        top=22
    }
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
    widget[1].markup = '<span size="2000"> </span><span color="' .. icon_color .. '" size="14000">' .. ICONS[icon_name] .. '</span> '
    widget[2].markup = '<span color="' .. icon_color .. '">' .. stdout .. '</span>'
    widget[3].value = hour
end

-- TODO: Replace with os.date
watch(CMD, 1, update_widget, {date_icon, date_widget, date_progressbar})

--return wibox.container.margin(date_widget, 2, 2, 2, 2)
return wibox.widget{
    date_progressbar,
    wibox.widget{
        date_icon,
        date_widget,
        layout=wibox.layout.fixed.horizontal
    },
    layout=wibox.layout.stack
}
