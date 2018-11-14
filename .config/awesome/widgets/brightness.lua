local wibox = require('wibox')
local watch = require("awful.widget.watch")
local awful = require('awful')
local beautiful = require("beautiful")
local gears = require("gears")
local utils = require("../utils")

local ICONS = {'', '', '', ''}
local ICONS_COUNT = 4

local progressbar = wibox.widget {
    forced_width=10,
    max_value=100,
    value=0,
    background_color=beautiful.bg_minimize .. '80',
    color=beautiful.fg_term .. '80',
    widget=wibox.widget.progressbar,
    margins=beautiful.progressbar_margins
    --margins={
    --    top=23
    --}
}

local icon_widget = wibox.widget{
    paddings=2,
    markup='~ ',
    widget=wibox.widget.textbox
}

local text_widget = wibox.widget{
    paddings=2,
    markup='~',
    --forced_width=36,
    align='right',
    widget=wibox.widget.textbox
}

local update_widget = function()
    local brightness = tonumber(utils.getline('/sys/class/backlight/intel_backlight/brightness'))
    local brightness_max = tonumber(utils.getline('/sys/class/backlight/intel_backlight/max_brightness'))

    local ratio = brightness / brightness_max

    local icon = ICONS[math.floor(ratio * (ICONS_COUNT - 1)) + 1]

    icon_widget.markup = '<span color="' .. beautiful.fg_term .. '" size="16000">' .. icon .. '</span>'
    text_widget.markup = '<span color="' .. '#FFFFFF' .. '">' .. math.floor(ratio * 100) .. '%</span>'
    progressbar.value = ratio * 100
end

update_widget()

gears.timer {
    timeout=2,
    autostart=true,
    callback=update_widget
}

local widget = utils.make_row({
    icon_widget,
    wibox.widget{
        progressbar,
        wibox.container.margin(text_widget, 4, 4),
        layout=wibox.layout.stack
    }
})

widget.increase = function()
    awful.util.spawn('xbacklight +10%')
    update_widget()
end
widget.decrease = function()
    awful.util.spawn('xbacklight -10%')
    update_widget()
end

return widget
