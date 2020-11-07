local wibox = require('wibox')
local watch = require("awful.widget.watch")
local awful = require('awful')
local beautiful = require("beautiful")
local gears = require("gears")
local utils = require("../utils")

local net_linux = require('vicious.contrib.net_linux')

local DEVICE = 'wlan0'

local ICONS = {'', '', '', ''}
local ICONS_COUNT = 4

return function(s)
    local progressbar = wibox.widget({
        forced_width=10,
        max_value=100,
        value=0,
        background_color=beautiful.bg_weak,
        color=beautiful.fg_ping_text,
        widget=wibox.widget.progressbar,
        margins=beautiful.progressbar_margins
    })

    local icon_widget = wibox.widget({
        paddings=2,
        markup='',
        color=beautiful.fg_ping_icon,
        widget=wibox.widget.textbox
    })

    local row1_widget = wibox.widget({
        paddings=2,
        markup='checking',
        --forced_width=42,
        align='left',
        widget=wibox.widget.textbox
    })

    local row2_widget = wibox.widget({
        paddings=2,
        markup='checking',
        --forced_width=36,
        align='left',
        widget=wibox.widget.textbox
    })

    --local update_network = function(widget, stdout)
    --    awful.spawn.easy_async('nmcli -m multiline -o -t d show ' .. DEVICE, function(stdout, stderr, reason, exit_code)
    --        local conn = nil
    --        for key, value in stdout:gmatch('(%S+):(%S+)') do
    --            if key == 'GENERAL.CONNECTION' then
    --                conn = value
    --            end
    --        end
    --        if conn == nil then
    --            row2_widget.markup = '<span color="' .. beautiful.fg_ping_warning .. '">@ unknown</span>'
    --        else
    --            row2_widget.markup = '<span color="' .. beautiful.fg_ping_text .. '">@ ' .. conn .. '</span>'
    --        end
    --    end)
    --end
    --local update_ping = function(widget, stdout)
    --    awful.spawn.easy_async('fping -c1 -t500 google.com', function(stdout, stderr, reason, exit_code)
    --        local latency = stdout:match('([0-9\\.]+) ms')
    --        if latency ~= nil then
    --            latency = math.floor(tonumber(latency))
    --        end
    --        if latency == nil or latency >= 100 then
    --            if latency ~= nil then
    --                latency = math.min(latency, 99)
    --                --row1_widget.markup = '<span color="' .. beautiful.fg_ping_warning .. '">' .. string.format('%.1f', latency) .. ' ms</span>'
    --                row1_widget.markup = '<span color="' .. beautiful.fg_ping_warning .. '">' .. latency .. 'ms</span>'
    --            else
    --                row1_widget.markup = '<span color="' .. beautiful.fg_ping_warning .. '">offline</span>'
    --            end
    --            progressbar.color = beautiful.fg_ping_warning
    --            progressbar.value = 100
    --            icon_widget.markup = '<span color="' .. beautiful.fg_ping_warning .. '" size="'..math.floor((s.panel.height+4)*1000/2)..'"></span>'
    --        else
    --            local latency_str = 'a'
    --            --if latency < 10 then
    --            --    latency_str = string.format('%.3f', latency)
    --            --else
    --            --    latency_str = string.format('%.2f', latency)
    --            --end
    --            row1_widget.markup = '<span color="' .. beautiful.fg_ping_text .. '">' .. string.format('%-2d', latency) .. 'ms</span>'
    --            progressbar.color = beautiful.fg_ping_text
    --            progressbar.value = latency
    --            icon_widget.markup = '<span color="' .. beautiful.fg_ping_icon .. '" size="'..math.floor((s.panel.height+4)*1000/2)..'"></span>'
    --        end
    --    end)
    --end

    local widget

    local update_widget = function(_, essid)
        essid = string.gsub(essid, '^%s*(.-)%s*$', '%1')
        local color = beautiful.fg_ping_icon
        if string.len(essid) == 0 then
            color = beautiful.fg_ping_warning
            essid = 'Offline'
        end
        -- local net_info = net_linux()
        -- local tx_b = math.floor(tonumber(net_info[string.format('{%s tx_mb}', DEVICE)]))
        -- local rx_b = math.floor(tonumber(net_info[string.format('{%s rx_mb}', DEVICE)]))
        icon_widget.markup = '<span color="' .. color .. '" size="'..math.floor((s.panel.height+4-6)*1000/2)..'"> </span>'
        row1_widget.markup = '<span color="' .. color .. '">' .. essid .. '</span>'
        -- row2_widget.markup = string.format('  %dM  %dM', rx_b, tx_b)
    end

    --update_widget()
    --update_ping()
    --gears.timer{
    --    timeout=5,
    --    autostart=true,
    --    callback=update_widget
    --}
    --gears.timer{
    --    timeout=2,
    --    autostart=true,
    --    callback=update_ping
    --}
    awful.widget.watch('iwgetid -r', 2, update_widget)

    widget = utils.make_row({
        -- wibox.container.margin(icon_widget, 0, 0, 0, 2),
        wibox.widget({
            -- progressbar,
            wibox.container.margin(
                wibox.container.margin(
                    utils.make_row({
                        row1_widget,
                        -- row2_widget
                    }),
                    0,
                    0,
                    0,
                    2
                ),
                0,
                0
            ),
            layout=wibox.layout.stack
        })
    })

    widget:connect_signal('button::press', function(lx, ly, button, mods, find_widgets_result)
        awful.spawn.easy_async_with_shell('iwgetid -r', function(out) update_widget(nil, out) end)
        --update_ping()
        --awful.util.spawn('pavucontrol')
    end)

    return widget
end
