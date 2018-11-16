local wibox = require('wibox')
local watch = require("awful.widget.watch")
local awful = require('awful')
local beautiful = require("beautiful")
local gears = require("gears")
local utils = require("../utils")

local DEVICE = 'wlp5s0'

local ICONS = {'', '', '', ''}
local ICONS_COUNT = 4

local progressbar = wibox.widget({
    forced_width=10,
    max_value=100,
    value=0,
    background_color=beautiful.bg_minimize .. '80',
    color=beautiful.fg_term .. '80',
    widget=wibox.widget.progressbar,
    margins=beautiful.progressbar_margins
})

local icon_widget = wibox.widget({
    paddings=2,
    markup='',
    color=beautiful.fg_ping,
    widget=wibox.widget.textbox
})

local row1_widget = wibox.widget({
    paddings=2,
    markup='checking',
    forced_width=52,
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

local update_widget = function(widget, stdout)
    awful.spawn.easy_async('nmcli -m multiline -o -t d show ' .. DEVICE, function(stdout, stderr, reason, exit_code)
        local conn = nil
        for key, value in stdout:gmatch('(%S+):(%S+)') do
            if key == 'GENERAL.CONNECTION' then
                conn = value
            end
        end
        if conn == nil then
            row2_widget.markup = '<span color="' .. beautiful.fg_ping_warning .. '">@ unknown</span>'
        else
            row2_widget.markup = '<span color="#FFFFFF">@ ' .. conn .. '</span>'
        end
        awful.spawn.easy_async('fping -c1 -t500 google.com', function(stdout, stderr, reason, exit_code)
            local latency = stdout:match('([0-9\\.]+) ms')
            if latency ~= nil then
                latency = tonumber(latency)
            end
            if latency == nil or latency > 100 then
                if latency ~= nil then
                    latency = math.min(latency, 999)
                    row1_widget.markup = '<span color="' .. beautiful.fg_ping_warning .. '">' .. latency .. ' ms</span>'
                else
                    row1_widget.markup = '<span color="' .. beautiful.fg_ping_warning .. '">offline</span>'
                end
                progressbar.color = beautiful.fg_ping_warning .. '80'
                progressbar.value = 100
                icon_widget.markup = '<span color="' .. beautiful.fg_ping_warning .. '" size="14000"></span>'
            else
                row1_widget.markup = '<span color="' .. '#FFFFFF' .. '">' .. latency .. ' ms</span>'
                progressbar.color = beautiful.fg_ping .. '80'
                progressbar.value = latency
                icon_widget.markup = '<span color="' .. beautiful.fg_ping .. '" size="14000"></span>'
            end
        end)
    end)
end

update_widget()
gears.timer{
    timeout=2,
    autostart=true,
    callback=update_widget
}
--awful.widget.watch('fping -c1 -t500 google.com', 2, update_widget)

local widget = utils.make_row({
    wibox.layout.margin(icon_widget, 0, 0, 0, 2),
    wibox.widget({
        --progressbar,
        wibox.container.margin(
            wibox.layout.margin(
                utils.make_row({
                    row1_widget,
                    row2_widget
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

return widget
