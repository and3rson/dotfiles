--local beautiful = require('beautiful')
local awful = require('awful')
local wibox = require('wibox')
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")

local CMD = [[date +"%a ─ %d %b ─ %H:%M"]]
--local CMD = [[date +"%d %B %Y, %H:%M"]]
--local CMD = [[date +"%d %B %Y, %H:%M"]]

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
    margins=beautiful.progressbar_margins
    --margins={
    --    top=23
    --}
}

local update_widget = function(widget, stdout, _, _, _)
    local icon_name
    local icon_color
    stdout = stdout:gsub('%s+$', '')
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
    widget[2].markup = '<span color="' .. icon_color .. '">' .. stdout .. '  </span>'
    widget[3].value = hour
end

-- TODO: Replace with os.date
watch(CMD, 1, update_widget, {date_icon, date_widget, date_progressbar})

--return wibox.container.margin(date_widget, 2, 2, 2, 2)
local widget = wibox.widget{
    --date_progressbar,
    wibox.widget{
        date_icon,
        date_widget,
        layout=wibox.layout.fixed.horizontal
    },
    layout=wibox.layout.stack
}

--local calendar = awful.widget.calendar_popup.year({position='tr'})
--calendar:attach(widget, 'tr')
--awful.widget.calendar.month:attach(widget, 'tr')

local tooltip = awful.tooltip({
    objects={widget},
    markup='<span>Loading</span>',
})

tooltip:connect_signal('property::visible', function()
    if tooltip:get_visible() then
        awful.spawn.easy_async('cal -n 3 --color=always', function(stdout, stderr, reason, exit_code)
            --stdout, _ = stdout:gsub('^\n*([^\n]*)\n*$', '%1')
            local stdout, _ = stdout:gsub('^\n*(.-)[\n ]*$', '%1')
            local beautiful = require('beautiful')
            stdout = stdout:gsub('\x1b%[3m', '<span color="' .. beautiful.fg_date_today .. '" bgcolor="' .. beautiful.bg_date_today .. '">')
            stdout = stdout:gsub('\x1b%[23m', '</span>')
            tooltip:set_markup('<span size="11000">' .. stdout .. '</span>')
        end)
    end
end)

return widget
