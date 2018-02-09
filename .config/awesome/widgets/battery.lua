local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local watch = require("awful.widget.watch")

--CMD = "bash -c \"acpi -b | grep -o -E '[[:digit:]]+%'\""
local CMD = 'acpi -b'

local battery_widget = wibox.widget{
    widget=wibox.widget.progressbar,
    forced_width=16,
    max_value=100,
    value=0,
    shape=gears.shape.bar,
    background_color=beautiful.bg_minimize,
    color=beautiful.bg_focus,
    margins={
        bottom=15
    }
}

--local battery_widget = wibox.widget{
--    border_width=0,
--    colors={beautiful.bg_normal, beautiful.bg_focus},
--    widget=wibox.widget.piechart,
--    forced_width=20,
--    forced_height=16
--}
battery_widget.display_labels = false

local battery_value = wibox.widget{
    text='~ ',
    --font=beautiful.pixel_font,
    widget=wibox.widget.textbox
}

local update_widget = function(widgets, stdout, _, _, _)
    local status, charge = string.match(stdout, '(%w+), (%d+%%)')
    local n, _ = charge:gsub("%%", "")
    local color
    n = tonumber(n)
    if status == 'Charging' or status == 'Full' then
        color = '#4477FF'
    else
        if n <= 10 then
            color = '#D64937'
        else
            color = beautiful.fg_normal
        end
    end
    --widgets[1].colors = {beautiful.bg_normal, color}
    --widgets[1].data_list = {{'Used', 100 - n}, {'Remaining', n}}
    widgets[1].color = color
    widgets[1].value = n
    widgets[2].markup = '<span color="' .. color .. '">' .. charge .. '</span>'
    --n, _ = charge:gsub("%%", "")
    --n = tonumber(n)
    --local style = ''
    --icons = {'', '', '', '', ''}
    --icon = ' ' .. icons[math.floor((n - 1) / 20) + 1] .. ' '
    --message = ' ' .. charge
    --if status ~= 'Charging' then
    --    if n <= 10 then
    --        style = 'color="#D64937"'
    --    end
    --else
    --    icon = ' '  -- '
    --    style = 'color="#44FF77"'
    --end
    --widget.markup = '<b><span ' .. style .. '>' .. icon .. charge .. '</span></b> '
end

watch(CMD, 10, update_widget, {battery_widget, battery_value})

--return wibox.container.margin(battery_widget, 2, 2, 2, 2)
local layout = wibox.layout.fixed.horizontal()
layout.spacing = 8
return wibox.widget{
    wibox.widget{
        battery_widget,
        battery_value,
        layout=wibox.layout.stack
    },
    right=8,
    layout=wibox.layout.margin
}
