local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local watch = require("awful.widget.watch")

--CMD = "bash -c \"acpi -b | grep -o -E '[[:digit:]]+%'\""
local CMD = 'acpi -b'

local ICONS = {
    discharging={
        icons={'', '', '', '', '', '', '', '', '', ''},
        count=10,
        icon_size=11000
    },
    charging={
        icons={''},
        count=1,
        icon_size=16000
    }
    --charging={
    --    icons={'', '', '', '', '', '', ''},
    --    count=7,
    --    icon_size=16000
    --}
}

local battery_widget = wibox.widget{
    widget=wibox.widget.progressbar,
    forced_width=17,
    max_value=100,
    value=0,
    shape=gears.shape.bar,
    background_color=beautiful.bg_minimize,
    color=beautiful.bg_focus,
    --ticks=true,
    --ticks_size=2,
    --ticks_gap=1,
    margins={
        --top=7,
        top=22
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

local battery_icon = wibox.widget{
    text='~ ',
    widget=wibox.widget.textbox
}

local battery_value = wibox.widget{
    text='~ ',
    --font=beautiful.pixel_font,
    widget=wibox.widget.textbox
}

local update_widget = function(widgets, stdout, _, _, _)
    local status, charge = string.match(stdout, '(%w+), (%d+%%)')
    local n, _ = charge:gsub("%%", "")
    local color
    local icon = ''
    local icons = widgets[4]
    n = tonumber(n)
    --n = 30
    local icon_set
    if status == 'Charging' or status == 'Full' then
        icon_set = icons.charging
        color = beautiful.fg_battery_charging
    else
        icon_set = icons.discharging
        if n <= 10 then
            --prefix = ''
            --color = beautiful.bg_focus
            color = beautiful.fg_battery_warning
        else
            --prefix = ''
            color = beautiful.fg_battery
        end
    end
    if n == 100 then
        color = beautiful.fg_battery_charging
    end
    local icon_index = math.min(math.floor(n / 100 * icon_set.count), icon_set.count - 1) + 1
    icon = icon_set.icons[icon_index]
    --prefix = prefix .. BATTERY[icon_index]
    --widgets[1].colors = {beautiful.bg_normal, color}
    --widgets[1].data_list = {{'Used', 100 - n}, {'Remaining', n}}
    widgets[1].color = color
    widgets[1].value = n
    widgets[2].markup = '<span color="' .. color .. '">' .. '<span size="' .. icon_set.icon_size .. '">' .. icon .. '</span></span> '
    widgets[3].markup = '<span color="' .. color .. '">' .. charge .. '</span>'
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

watch(CMD, 5, update_widget, {battery_widget, battery_icon, battery_value, ICONS})

--return wibox.container.margin(battery_widget, 2, 2, 2, 2)
local layout = wibox.layout.fixed.horizontal()
layout.spacing = 8
return wibox.widget{
    wibox.widget{
        battery_widget,
        wibox.widget{
            battery_icon,
            battery_value,
            layout=wibox.layout.fixed.horizontal
        },
        layout=wibox.layout.stack
    },
    --right=8,
    layout=wibox.container.margin
}
