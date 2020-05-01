local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local watch = require("awful.widget.watch")
local utils = require("../utils")

--CMD = "bash -c \"acpi -b | grep -o -E '[[:digit:]]+%'\""
return function()
    local CMD = 'acpi -b'

    local ICONS = {
        discharging={
            icons={'', '', '', '', '', '', '', '', '', ''},
            count=10,
            icon_size=13000 -- +5000
        },
        charging={
            icons={''},
            count=1,
            icon_size=10000 -- +5000
        }
        --charging={
        --    icons={'', '', '', '', '', '', ''},
        --    count=7,
        --    icon_size=16000
        --}
    }

    local last_value = 0
    local last_charging = -1

    local battery_widget = wibox.widget{
        widget=wibox.widget.progressbar,
        forced_width=17,
        max_value=100,
        value=0,
        shape=gears.shape.bar,
        background_color=beautiful.bg_weak,
        color=beautiful.fg_battery_text,
        --ticks=true,
        --ticks_size=2,
        --ticks_gap=1,
        margins=beautiful.progressbar_margins
        --margins={top=10, bottom=10},
        --forced_width=32
        --margins={
        --    --top=7,
        --    top=23
        --}
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
        align='center',
        widget=wibox.widget.textbox,
        --visible=false
    }

    local battery_state = wibox.widget{
        text='~ ',
        --font=beautiful.pixel_font,
        align='center',
        widget=wibox.widget.textbox
    }

    local update_widget = function(widgets, stdout, _, _, _)
        local status, charge = string.match(stdout, ': ([%w ]+), (%d+%%)')
        local n, _ = charge:gsub("%%", "")
        local icon_color
        local text_color
        local icon = ''
        local icons = widgets[5]
        n = tonumber(n)
        local charging
        --n = 30
        local icon_set
        if status == 'Charging' or status == 'Full' or status == 'Not charging' then
            charging = true
            icon_set = icons.charging
            icon_color = beautiful.fg_battery_charging
            text_color = beautiful.fg_battery_charging
        else
            charging = false
            icon_set = icons.discharging
            if n <= 10 then
                --prefix = ''
                --color = beautiful.bg_focus
                icon_color = beautiful.fg_battery_warning
                text_color = beautiful.fg_battery_warning
            else
                --prefix = ''
                icon_color = beautiful.fg_battery_icon
                text_color = beautiful.fg_battery_text
            end
        end
        if n == 100 then
            icon_color = beautiful.fg_battery_charging
            text_color = beautiful.fg_battery_charging
        end
        local icon_index = math.min(math.floor(n / 100 * icon_set.count), icon_set.count - 1) + 1
        icon = icon_set.icons[icon_index]

        --if charging ~= last_charging then
        --    if last_charging == false then
        --        utils.notify('battery-ac-adapter', 'On AC power', 'AC adapter was just plugged in.')
        --    elseif last_charging == true then
        --        utils.notify('battery-full', 'On battery power', 'AC adapter was just plugged out.')
        --    end
        --    last_charging = charging
        --end

        if last_value ~= n then
            if not charging then
                if n == 15 then
                    utils.notify('battery-caution', 'Low power', string.format('Battery has %s%% remaining.', n))
                elseif n == 5 then
                    utils.notify('battery-empty', 'Critically low power', string.format('Battery has %s%% remaining.', n))
                end
            else
                if n == 99 and last_value ~= 100 then
                    utils.notify('battery-full-charged', 'Battery is charged', 'The battery is fully charged.')
                end
            end
            last_value = n
        end
        --prefix = prefix .. BATTERY[icon_index]
        --widgets[1].colors = {beautiful.bg_normal, color}
        --widgets[1].data_list = {{'Used', 100 - n}, {'Remaining', n}}
        widgets[1].color = icon_color
        widgets[1].value = n
        widgets[2].markup = '<span color="' .. icon_color .. '">' .. '<span size="' .. icon_set.icon_size .. '">' .. icon .. '</span></span>'
        --if charging then
        --    widgets[3].markup = '<span color="' .. '#FFFFFF' .. '" size="10000">  </span>'
        --else
            widgets[3].markup = '<span color="' .. text_color .. '" size="10000">' .. charge .. '</span>'
        --end
        widgets[4].markup = '<span color="#FFFFFF" size="14000">' .. text_color .. '</span>'
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

    watch(CMD, 5, update_widget, {battery_widget, battery_icon, battery_value, battery_state, ICONS})

    return wibox.widget{
        utils.make_row{
            wibox.layout.margin(battery_icon, 0, 0, 0, 2),
            wibox.widget{
                battery_widget,
                --wibox.container.margin(
                    wibox.layout.margin(battery_value, 0, 0, 0, 2),
                    --utils.make_col({
                    --    battery_value,
                    --    battery_state
                    --}),
                    --8,
                    --8
                --),
                layout=wibox.layout.stack
            },
        },
        --right=8,
        layout=wibox.container.margin
    }
end
