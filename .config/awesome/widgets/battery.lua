local awful = require('awful')
local wibox = require('wibox')
local watch = require("awful.widget.watch")

--CMD = "bash -c \"acpi -b | grep -o -E '[[:digit:]]+%'\""
CMD = 'acpi -b'

local battery_widget = wibox.widget{
    markup='~ ',
    widget=wibox.widget.textbox
}

local update_widget = function(widget, stdout, _, _, _)
    status, charge = string.match(stdout, '(%w+), (%d+%%)')
    n, _ = charge:gsub("%%", "")
    n = tonumber(n)
    local style = ''
    icons = {'', '', '', '', ''}
    icon = ' ' .. icons[math.floor((n - 1) / 20) + 1] .. ' '
    message = ' ' .. charge
    if status ~= 'Charging' then
        if n <= 10 then
            style = 'color="#D64937"'
        end
    else
        icon = ' '  -- '
        style = 'color="#44FF77"'
    end
    widget.markup = '<b><span ' .. style .. '>' .. icon .. charge .. '</span></b> '
end

watch(CMD, 10, update_widget, battery_widget)

--return wibox.container.margin(battery_widget, 2, 2, 2, 2)
return battery_widget

