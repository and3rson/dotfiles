-- My AwesomeWM config
-- vim:foldmethod=marker
-- luacheck: ignore dbus
-- luacheck: globals root awesome screen dbus client mouse

-- Core includes {{{
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local _dbus = dbus; dbus = nil
local naughty = require("naughty")
dbus = _dbus
--local naughty = require("naughty")
local menubar = require("menubar")
-- }}}
-- Theme {{{
beautiful.init("/home/anderson/.config/awesome/themes/custom.lua")
-- }}}
-- Local includes {{{
--local volume = require("utils.volume")
local tags_fn = require("utils.tags")
-- }}}

-- Naughty config {{{
naughty.config.padding = 20
naughty.config.spacing = 10
--naughty.config.defaults.border_width = 0
naughty.config.presets.critical.bg = beautiful.bg_focus
-- }}}
-- Error handling {{{
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
--if awesome.startup_errors then
--    awful.spawn({'notify-send', 'AwesomeWM error', awesome.startup_errors})
--end
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        --awful.spawn({'notify-send', 'AwesomeWM error', err})
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}
-- Layouts {{{
-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.fair
}
-- }}}

-- Global tags definition {{{
local all_tags = {'Q', 'W', 'I', 'M', 'A'}
-- }}}

-- qTile-like tag switching {{{
local sort_tags = function()
    for s = 1, screen.count() do
        for i, name in pairs(all_tags) do
            local tag = awful.tag.find_by_name(name)
            if tag then
                awful.tag.move(i, tag)
            end
            --for
        end
    end
end
local activate_tag = function(name)
    local tag = tags_fn.find_by_name(name)
    if tag.screen ~= awful.screen.focused() then
        if tag.selected then
            -- Swap
            local current_tag = awful.screen.focused().selected_tag
            if current_tag == nil then
                -- Current screen has no tags yet
                tag.screen = awful.screen.focused().index
            else
                current_tag.screen, tag.screen = tag.screen, current_tag.screen
                current_tag:view_only()
            end
        else
            -- Move
            tag.screen = awful.screen.focused()
        end
    else
        -- Tag found on current screen
    end
    tag:view_only()
    --sort_tags()
end
-- }}}

-- Wallpapers, tags & wiboxes for each screen. {{{
local volume
local tray
local first_screen
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper.
    if beautiful.wallpapers then
        gears.wallpaper.maximized(beautiful.wallpapers[s.index], s, false)
    end

    if s.index == 1 then
        for i, char in pairs(all_tags) do
            local sel = i == 1
            awful.tag.add(char, {
                selected=sel,
                screen=i,
                layout=layouts[1]
            })
        end
        screen[s].tags[1]:view_only()
        awful.screen.focus(1)
    end

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all
    }

    s.panel = awful.wibar({
        position="top",
        screen=s,
        ontop=true,
        --bg='#00000000',
        height=20,
        stretch=true
    })
    first_screen = s
    local config
    if s.index == 1 then
        volume = require('widgets.volume')(s)
        tray = wibox.widget.systray()
        tray.visible = false
        config = {
            layout=wibox.layout.align.horizontal,
            {
                layout=wibox.layout.fixed.horizontal,
                s.mytaglist
            },
            nil,
            {
                layout=wibox.layout.fixed.horizontal,
                require('widgets.gpmdp'),
                require('widgets.spacer')(),
                require('widgets.openweathermap')(),
                require('widgets.spacer')(),
                require('widgets.ping')(),
                require('widgets.spacer')(),
                volume,
                require('widgets.spacer')(),
                require('widgets.cpuwidget')(s),
                require('widgets.spacer')(),
                require('widgets.memwidget')(s),
                require('widgets.spacer')(),
                require('widgets.term')(),
                require('widgets.spacer')(),
                require('widgets.battery')(),
                require('widgets.spacer')(),
                require('widgets.date')(),
                tray,
            }
        }
    else
        config = {
            layout=wibox.layout.align.horizontal,
            {
                layout=wibox.layout.fixed.horizontal,
                s.mytaglist
            },
            nil,
            {
            layout=wibox.layout.fixed.horizontal,
                require('widgets.date')(),
            }
        }
    end
    s.panel:setup(config)
    --s.panel:struts({left=0, right=0, top=0, bottom=0})
end)
-- }}}

-- Key bindings {{{
-- Modifier keys.
local alt = "Mod1"
local super = "Mod4"
local ctrl = "Ctrl"

local globalkeys = awful.util.table.join(
    -- Switch screen
    awful.key({alt}, "Tab", function (c)
        local current_screen = awful.screen.focused().index
        local next_screen = current_screen + 1
        if next_screen > screen:count() then
            next_screen = 1
        end
        awful.screen.focus(next_screen)
        awful.spawn('/home/anderson/.scripts/not.sh \'{"timeout":0.3,"message":":' .. tostring(current_screen) .. '"}\'')
    end),

    -- Layouts
    awful.key({super}, "space", function () awful.layout.inc(layouts,  1) end),

    -- Standard program
    awful.key({super}, "Return", function () awful.util.spawn('termite') end),
    awful.key({ctrl, alt}, "t", function () awful.util.spawn('termite') end),
    awful.key({super, ctrl}, "r", awesome.restart),
    awful.key({super, ctrl}, "q", awesome.quit),

    -- Run rofi
    awful.key({super}, "r", function() awful.util.spawn('rofi -show run -terminal termite') end),

    -- Volume control
    awful.key({}, 'XF86AudioRaiseVolume', function() volume.modify_volume(2) end),
    awful.key({}, 'XF86AudioLowerVolume', function() volume.modify_volume(-2) end),

    -- Backlight
    awful.key({}, 'XF86MonBrightnessUp', function() awful.util.spawn('xbacklight -inc 10') end),
    awful.key({}, 'XF86MonBrightnessDown', function() awful.util.spawn('xbacklight -dec 10') end),

    -- Media keys
    --awful.key({}, 'XF86AudioPlay', function()
    --    awful.util.spawn_with_shell('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.clay /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause')
    --    awful.util.spawn_with_shell('curl 127.0.0.1:9191/media -F action=play-pause')
    --end),
    --awful.key({}, 'XF86AudioNext', function()
    --    awful.util.spawn_with_shell('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.clay /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next')
    --    awful.util.spawn_with_shell('curl 127.0.0.1:9191/media -F action=next')
    --end),
    --awful.key({}, 'XF86AudioPrev', function()
    --    awful.util.spawn_with_shell('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.clay /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous')
    --    awful.util.spawn_with_shell('curl 127.0.0.1:9191/media -F action=prev')
    --end),
    --awful.key({super}, '[', function()
    --    awful.util.spawn_with_shell('curl 127.0.0.1:9191/media -F action=seek-backward')
    --end),
    --awful.key({super}, ']', function()
    --    awful.util.spawn_with_shell('curl 127.0.0.1:9191/media -F action=seek-forward')
    --end),

    -- Lock screen
    awful.key({ctrl, alt}, 'l', function() awful.util.spawn('/home/anderson/.scripts/i3lock.sh') end),

    -- Notifications
    awful.key({super}, 'Escape', function() naughty.destroy_all_notifications() end),

    -- Client management
    awful.key({super}, "j", function () awful.client.focus.byidx(1) end),
    awful.key({super}, "Page_Up", function () awful.client.focus.byidx(1) end),
    awful.key({super}, "k", function () awful.client.focus.byidx(-1) end),
    awful.key({super}, "Page_Down", function () awful.client.focus.byidx(-1) end),

    -- Client management (multihead)
    awful.key({super}, 'Left', awful.client.movetoscreen),
    awful.key({super}, 'Right', function(client)
        if awful.client.focus == nil then
            return
        end
        local index = awful.screen.focused().index - 1
        if index == 0 then
            index = screen:count()
        end
        awful.client.movetoscreen(client, index)
    end),
    awful.key({super}, "o",      awful.client.movetoscreen),

    -- NetworkManager DMenu
    awful.key({super}, "n", function() awful.util.spawn('networkmanager_dmenu') end),

    -- Bluetooth menu
    awful.key({super}, "b", function() awful.util.spawn('blueman-manager') end),

    -- Screenshot
    awful.key({super}, "p", function() awful.util.spawn('/home/anderson/.scripts/sshot.sh') end),

    -- System tray toggle
    awful.key({super}, "=", function() tray.visible = not tray.visible end),

    -- Panel toggle
    awful.key({super}, "-", function() first_screen.panel.visible = not first_screen.panel.visible end),

    -- HPC YouTube player control
    --awful.key({super}, ",", function() awful.util.spawn('curl -X POST 127.0.0.1:6565/playback --data \'{"op": "prev"}\'') end),
    --awful.key({super}, ".", function() awful.util.spawn('curl -X POST 127.0.0.1:6565/playback --data \'{"op": "play"}\'') end),
    --awful.key({super}, "/", function() awful.util.spawn('curl -X POST 127.0.0.1:6565/playback --data \'{"op": "next"}\'') end),

    -- Vim edit
    awful.key({super}, "e", function() awful.util.spawn('/home/anderson/.scripts/vime.sh') end)

    --awful.key({ super }, "x", function() menubar.show() end)
)

local clientkeys = awful.util.table.join(
    awful.key({alt}, 'F4', function(c) c:kill() end),
    awful.key({super}, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({super}, "x",  awful.client.floating.toggle)
    --awful.key({super}, "t",      function (c) c.ontop = not c.ontop end)
)

-- Bind keys to tags.
for key, tag_name in pairs({Q='Q', W='W', I='I', M='M', T='M', A='A', G='A'}) do
    globalkeys = awful.util.table.join(
        globalkeys,
        awful.key({super}, key:lower(), function()
            --for _, tag in pairs(awful.tag.gettags(mouse.screen)) do
            --    if tag.name == tag_name then
            --        awful.tag.viewonly(tag)
            --    end
            --end
            activate_tag(tag_name)
        end)
    )
end

--awful.client.focus.history.disable_tracking()

-- Bind numbers to clients.
for i = 1, 9 do
    globalkeys = awful.util.table.join(
        globalkeys,
        awful.key({super}, tostring(i), function()
            local clients = awful.screen.focused().selected_tag:clients()
            if clients[i] ~= nil then
                clients[i]:jump_to()
            end
        end)
    )
end
-- }}}
-- Mouse buttons {{{
local clientbuttons = awful.util.table.join(
    awful.button({}, 1, function (c) client.focus = c; c:raise() end),
    awful.button({super}, 1, awful.mouse.client.move),
    awful.button({super}, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- Window matching rules {{{
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     screen = awful.screen.preferred,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { screen = 1, floating = true } },
    { rule = { class = "pinentry" },
      properties = { screen = 1, floating = true } },
    { rule = { class = "Godot" },
      properties = { tag = "M", floating = true } },
    --{ rule = { class = "gimp" },
    --  properties = { floating = true } },
    {
        rule_any = { class = {"HomeTerm"} },
        properties = { screen = 1, tag = "Q" }
    },
    {
        rule_any = { class = {"Chromium", "Firefox", "Navigator", "firefoxdeveloperedition"} },
        properties = { screen = 1, tag = "W" }
    },
    {
        rule_any = { class = {"TelegramDesktop", "IRCCloud", "ViberPC", "Slack", "discord"} },
        properties = { screen = 1, tag = "I" }
    },
    {
        rule_any = { class = {"Evolution", "Steam", "Wine", "minecraft-launcher", "Minecraft 1.14.4", "Google Play Music Desktop Player"} },
        properties = { screen = 1, tag = "M" }
    },
    {
        rule_any = { class = {"Todoist"} },
        properties = { screen = 1, tag = "A" }
    },
    {
        rune_any = { class = {'Not'} },
        properties = { sticky = true, ontop = true, focusable = false, tag = "M" }
    },
    {
        rule_any = { name = {'cava'} },
        properties = { focusable = false, below = true }
    }
}
-- }}}
-- Visual effect when switching screens (old) {{{
--local original_focus = awful.screen.focus

--awful.screen.focus = function(index)
--    if type(index) == 'screen' then
--        index = index.index
--    end
--    original_focus(index)
--    local mywibox = wiboxes[index]
--    -- Blink twice (change color 4 times)
--    mywibox.bg = beautiful.bg_lit
--    local i = 3
--    gears.timer.start_new(0.04, function()
--        i = i - 1
--        if i % 2 == 1 then
--            mywibox.bg = beautiful.bg_lit
--        else
--            mywibox.bg = beautiful.bg_normal
--        end
--        return i > 0
--    end)
--end

-- }}}
-- Signals {{{
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end

        --naughty.notify({ preset = naughty.config.presets.critical,
        --                 title = c.role,
        --                 text = 'foo' })
        --if c.role == 'Not' then
        --    c.focusable = false
        --    c.focus = false
        --    c.sticky = true
        --    --c:lower()
        --end
    end
end)

function configure_borders(t)
    local count = 0
    for _, client in pairs(t:clients()) do
        count = count + 1
    end
    for _, client in pairs(t:clients()) do
        if count > 1 and t.layout.name ~= 'max' then
            client.border_width = 0
        else
            client.border_width = 0
        end
    end
end

local prev_tag = nil
client.connect_signal("focus", function(c)
    local current_tag = awful.tag.selected(c.screen)
    configure_borders(current_tag)
    c.border_color = beautiful.border_focus
    if c.first_tag.name == prev_tag then
        local index_in_tag = 0
        for index, value in pairs(c.first_tag:clients()) do
            if value == c then
                index_in_tag = index
            end
        end
        local client_name = '(Unnamed client)'
        if c.name then
            client_name = c.name
        end
        --awful.spawn('/home/anderson/.scripts/not.sh "' .. index_in_tag .. '~' .. client_name .. '~0.3"')
    end
    prev_tag = c.first_tag.name
    --c.border_width = 1
end)
--tag.connect_signal('property::layout', function(t)
--    configure_borders(t)
--end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    --c.border_width = 0
end)
tag.connect_signal('property::selected', function(t)
    --for k, v in pairs(t) do
    --    print(k, v)
    --end
    local client_name = ''
    for index, c in pairs(t:clients()) do
        if c.first_tag == t and c.name then
            client_name = c.name
        end
    end
    --print(client.focus)
    --awful.spawn('/home/anderson/.scripts/not.sh "' .. t.name .. '~' .. client_name .. '~0.3"')
end)
-- }}}

--awful.util.spawn('chromium')
--awful.util.spawn('start-pulseaudio-x11-mod')
