local awful = require('awful')
local wibox = require('wibox')
local gears = require("gears");
local beautiful = require('beautiful')
local json = require("json");
local inotify = require("inotify");

local update_widget
return function()
    local FILE = '/tmp/clay.json'

    --local progressbar = wibox.widget {
    --    forced_width=10,
    --    max_value=100,
    --    value=0,
    --    background_color=beautiful.bg_weak,
    --    color=beautiful.bg_focus,
    --    widget=wibox.widget.progressbar,
    --    margins=beautiful.progressbar_margins
    --}

    local clay_widget = wibox.widget {
        markup='',
        widget=wibox.widget.textbox
    }

    update_widget = function()
        awful.spawn.easy_async('curl 127.0.0.1:9191/notifications', function(stdout, stderr, reason, exit_code)
            if exit_code == 0 then
                local response = json.decode(stdout)
                --local text = response['body']['subtitle'] .. ' - ' .. response['body']['title']
                local color
                --color = beautiful.bg_focus
                local icon
                --if response['body']['playing'] then
                    icon = ''
                    color = beautiful.fg_clay_playing
                --else
                --    icon = ''
                --    color = beautiful.fg_clay_paused
                --end

                local text = '<span color="' .. color ..
                    '">' .. icon .. '</span>' ..
                    ' ' ..
                    response['body']['subtitle'] .. ' - ' .. response['body']['title'] ..
                    --' ' ..
                    --'[' .. total .. ']' ..
                    --'</span>' ..
                    ''
                text = text:gsub('&', '&amp;')

                clay_widget.markup = text
            end
            update_widget()
        end)
        --local content = ''
        --f = io.open(FILE)
        --if f == nil then
        --    --root_widget.visible = false
        --    clay_widget.markup = 'Clay not running'
        --else
        --    --root_widget.visible = true
        --    for line in f:lines() do
        --        content = content .. line
        --    end
        --end
        --if content == '' then
        --    return
        --end
        --local data = json.decode(content)
        --local color, icon, total, progress
        ----if data.playing then
        --    color = beautiful.fg_clay_playing
        --    --color = beautiful.bg_focus
        --    icon = ''
        --    --icon = '▷'
        ----else
        ----    color = beautiful.fg_clay_paused
        ----    --color = beautiful.fg_normal
        ----    icon = ''
        ----    --icon = '◫'
        ----end
        --if data.title == nil then
        --    clay_widget.markup = '?'
        --    --progressbar.value = 0
        --    return
        --end
        --progress = data.progress / data.length * 100
        --total = string.format('%02d:%02d', math.floor(data.length / 60), data.length % 60)
        ----progressbar.value = progress
        ----progressbar.color = color
        --local text = '<span color="' .. color ..
        --    '">' .. icon ..
        --    ' ' ..
        --    data.artist .. ' - ' .. data.title ..
        --    ' ' ..
        --    '[' .. total .. ']' ..
        --    '</span>'
        --text = text:gsub('&', '&amp;')
        --clay_widget.markup = text
    end

    --gears.timer {
    --    timeout=0.5,
    --    autostart=true,
    --    callback=update_widget
    --}
    update_widget()

    root_widget = wibox.widget{
        --progressbar,
        clay_widget,
        layout=wibox.layout.stack
    }
    return root_widget
end
