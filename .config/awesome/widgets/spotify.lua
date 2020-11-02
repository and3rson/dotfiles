local awful = require('awful');
local wibox = require('wibox');
local gears = require("gears");
local beautiful = require('beautiful')
local json = require("json");
local inotify = require("inotify");
local utils = require("utils");

return function()
    local icon_widget = wibox.widget {
        markup=' ',
        widget=wibox.widget.textbox
    }
    local text_widget = wibox.widget {
        markup=' ',
        widget=wibox.widget.textbox
    }

    dbus.add_match("session", "interface='org.freedesktop.DBus.Properties', member='PropertiesChanged', path='/org/mpris/MediaPlayer2'")
    dbus.connect_signal('org.freedesktop.DBus.Properties', function(info, source, data)
        local playing = data.PlaybackStatus == 'Playing'
        local artists = table.concat(data.Metadata['xesam:artist'], ". ")
        local title = data.Metadata['xesam:title']
        local length = tonumber(data.Metadata['mpris:length'])
        local length_seconds = length // 1000000
        local minutes, seconds = length_seconds // 60, length_seconds % 60
        local color = beautiful.fg_spotify_paused
        local icon = ''
        if playing then
            color = beautiful.fg_spotify_playing
            icon = ''
        end
        icon_widget.markup = string.format('<span color="%s">%s </span>', color, icon)
        text_widget.markup = string.format('<span color="%s">%s - %s (%d:%02d)</span>', color, artists, title, minutes, seconds):gsub("%&","&amp;")
    end)

    for i=1,2 do
        awful.util.spawn_with_shell('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause')
    end

    -- local update_widget = function()
    --     local content = ''
    --     f = io.open(FILE)
    --     if f == nil then
    --         root_widget.visible = false
    --         clay_widget.markup = 'Clay not running'
    --     else
    --         root_widget.visible = true
    --         for line in f:lines() do
    --             content = content .. line
    --         end
    --     end
    --     if content == '' then
    --         return
    --     end
    --     local data = json.decode(content)
    --     local color, icon, total, progress
    --     if data.playing then
    --         color = beautiful.fg_clay_playing
    --         --color = beautiful.bg_focus
    --         icon = ''
    --         --icon = '▷'
    --     else
    --         color = beautiful.fg_clay_paused
    --         --color = beautiful.fg_normal
    --         icon = ''
    --         --icon = '◫'
    --     end
    --     if data.title == nil then
    --         clay_widget.markup = '?'
    --         progressbar.value = 0
    --         return
    --     end
    --     progress = data.progress / data.length * 100
    --     total = string.format('%02d:%02d', math.floor(data.length / 60), data.length % 60)
    --     progressbar.value = progress
    --     progressbar.color = color
    --     local text = '<span color="' .. color ..
    --         '">' .. icon ..
    --         ' ' ..
    --         data.artist .. ' - ' .. data.title ..
    --         ' ' ..
    --         '[' .. total .. ']' ..
    --         '</span>'
    --     text = text:gsub('&', '&amp;')
    --     clay_widget.markup = text
    -- end

    -- gears.timer {
    --     timeout=0.5,
    --     autostart=true,
    --     callback=update_widget
    -- }

    root_widget = utils.make_row{
        icon_widget,
        text_widget,
    }
    return root_widget
end
