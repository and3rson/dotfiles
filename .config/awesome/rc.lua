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
local utils = require('utils')
local socket = require('socket')
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

-- Wallpapers, tags, wiboxes & other stuff for each screen. {{{
local volume
local tray
local first_screen
awful.screen.connect_for_each_screen(function(s)
    -- Panel color timer.
    local color_started = 0
    local color_from = '#000000FF'
    local color_to = '#000000FF'
    local duration = 0.15
    local panel_color_timer
    panel_color_timer = gears.timer{
        timeout=0.01,
        autostart=false,
        call_now=false,
        callback=function()
            local time_passed = socket.gettime() - color_started
            local progress = time_passed / duration
            local color
            if progress >= 1 then
                color = color_to
                if panel_color_timer.started then
                    panel_color_timer:stop()
                end
            else
                color = utils.mix_colors(color_from, color_to, progress)
            end
            print(progress, color)
            s.panel.bg = color
        end,
        single_shot=false
    }
    s.panel_color_timer = panel_color_timer
    s.panel_color_start = function(new_color_to)
        print('C', color_from, color_to)
        if color_from ~= nil then
            local time_passed = socket.gettime() - color_started
            local progress = time_passed / duration
            local color
            if progress >= 1 then
                color = color_to
                if panel_color_timer.started then
                    panel_color_timer:stop()
                end
            else
                color = utils.mix_colors(color_from, color_to, progress)
            end
            color_from = color
        else
            color_from = color_to
        end
        color_to = new_color_to
        color_started = socket.gettime()
        panel_color_timer:again()
    end

    -- Wallpaper.
    if beautiful.wallpapers then
        gears.wallpaper.maximized(beautiful.wallpapers[s.index], s, false)
    end

    if s.index == 1 then
        for i, char in pairs(all_tags) do
            print(i, char)
            local sel = i == 1
            awful.tag.add(char, {
                selected=sel,
                -- screen=i,  -- Meant 1?
                layout=layouts[1],
                icon_only=true,
                icon='/home/anderson/.icons/bullet.png'
            })
        end
        screen[s].tags[1]:view_only()
        awful.screen.focus(1)
    end

    -- s.mytaglist = awful.widget.taglist {
    --     screen  = s,
    --     filter  = awful.widget.taglist.filter.all
    -- }

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
            layout=wibox.layout.ratio.horizontal,
            id='ratio',
            {
                layout=wibox.layout.fixed.horizontal,
                -- s.mytaglist,
                -- require('widgets.spacer')(),
                require('widgets.gpmdp'),
            },
            {
                layout=wibox.layout.align.horizontal,
                expand='outside',
                nil,
                {
                    layout=wibox.layout.fixed.horizontal,
                    require('widgets.date')(),
                    require('widgets.spacer')(),
                    require('widgets.openweathermap')(),
                },
                nil,
            },
            -- nil,
            {
                layout=wibox.layout.align.horizontal,
                nil,
                nil,
                {
                    layout=wibox.layout.fixed.horizontal,
                    -- require('widgets.spacer')(),
                    -- require('widgets.mqtt')(s),
                    -- require('widgets.spacer')(),
                    require('widgets.ping')(s),
                    require('widgets.spacer')(),
                    volume,
                    require('widgets.spacer')(),
                    require('widgets.cpuwidget')(s),
                    require('widgets.spacer')(),
                    require('widgets.memwidget')(s),
                    require('widgets.spacer')(),
                    -- require('widgets.term')(),
                    -- require('widgets.spacer')(),
                    require('widgets.battery')(),
                    -- require('widgets.spacer')(),
                    tray,
                }
            }
        }
    else
        config = {
            layout=wibox.layout.align.horizontal,
            {
                layout=wibox.layout.fixed.horizontal,
                -- s.mytaglist
            },
            nil,
            {
            layout=wibox.layout.fixed.horizontal,
                require('widgets.date')(),
            }
        }
    end
    s.panel:setup(config)
    s.panel.ratio:ajust_ratio(2, 0.4, 0.2, 0.4)
    s.panel.ratio.inner_fill_strategy = 'justify'
    -- s.panel:ajust_ratio(2, 0.25, 0.5, 0.25)
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
    awful.key({}, 'XF86AudioMute', function() volume.toggle_mute() end),
    awful.key({super}, 'v', function() awful.util.spawn('pavucontrol') end),

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
        rule_any = { class = {"TelegramDesktop", "IRCCloud", "ViberPC", "Slack", "discord", "Hexchat"} },
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
    },
    {
        rule_any = { class = {'Pavucontrol'} },
        properties = { floating = true, placement = awful.placement.centered, sticky = true }
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

-- function configure_borders(t)
--     local count = 0
--     for _, client in pairs(t:clients()) do
--         count = count + 1
--     end
--     for _, client in pairs(t:clients()) do
--         if count > 1 and t.layout.name ~= 'max' then
--             client.border_width = 0
--         else
--             client.border_width = 0
--         end
--     end
-- end

local client_colors = {
    HomeTerm='#000000FF',
    Termite='#000000FF',
    -- firefoxdeveloperedition='linear:0,0:1920,24:0,#A97E64:0.25,#BF6969:0.5,#A77B68:0.7,#BF5675:0.8,#B85A6F:0.85,#973571:0.95,#663185,1,#5E4389',
    -- firefoxdeveloperedition='linear:0,0:1920,24:0,#1F4349:0.25,#3A4A42:0.5,#A77B68:0.6,#C46A67:0.7,#BF5675:0.8,#B85A6F:0.85,#973571:0.95,#663185,1,#5E4389',
    firefoxdeveloperedition='#333333FF',
    TelegramDesktop='#0E1621FF',
    ['Google Play Music Desktop Player']='#1D1D1DFF',
    Slack='#222222FF',
}
local prev_tag = nil
local src_color = '#000000'
local target_color = nil
client.connect_signal("focus", function(c)
    local current_tag = awful.tag.selected(c.screen)
    -- configure_borders(current_tag)
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

    -- print(c.class)
    local color = client_colors[c.class]
    if color == nil then
        color = '#000000FF'
    end
    c.screen.panel_color_start(color)
    -- if color ~= nil then
    --     c.screen.panel.bg = color
    -- else
    --     c.screen.panel.bg = '#000000'
    -- end
    -- print(utils.mix_colors('#000000', '#FFFFFF', 0.3))

    if c.class == 'Pavucontrol' then
        -- workarea = awful.screen.focused().workarea
        workarea = c.screen.workarea
        -- hints = awful.placement.centered(c)
        -- hints.width = workarea.width * 0.5
        -- hints.height = workarea.height * 0.5
        c.placement = awful.placement.centered
        c.width = workarea.width * 0.8
        c.height = workarea.height * 0.7
        c.border_width = 2
    end

    -- local panel_color_timer = gears.timer{
    --     callback=function()
    --         -- local client = nil
    --         -- for i, c in pairs(s.clients) do
    --         --     print(i, c)
    --         --     client = c
    --         -- end
    --         if c ~= nil then
    --             -- print('x', string.format('grabc -l +0+%d -w %d', c.screen.panel.height, c.window))  -- -w `xdotool getwindowfocus`
    --             awful.spawn.easy_async(
    --                 string.format('grabc -l +0+%d -w %d', c.screen.panel.height, c.window),  -- -w `xdotool getwindowfocus`
    --                 function(stdout)
    --                     stdout = stdout:gsub("^%s*(.-)%s*$", "%1")
    --                     -- print(stdout)
    --                     c.screen.panel.bg = stdout
    --                     -- print('bg', s.panel.bg)
    --                 end
    --             )
    --         end
    --     end,
    --     timeout=0.2,
    --     autostart=true,
    --     single_shot=true
    -- }
end)
--tag.connect_signal('property::layout', function(t)
--    configure_borders(t)
--end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    c.screen.panel_color_start('#00000000')
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
-- client.disconnect_signal("request::geometry", awful.ewmh.client_geometry_requests)
-- client.connect_signal("request::geometry", function(c, context, hints)
--     print(c)
--     if c.class == "Pavucontrol" then
--         workarea = awful.screen.focused().workarea
--         hints = awful.placement.centered(c)
--         hints.width = workarea.width * 0.5
--         hints.height = workarea.height * 0.5
--         print(hints)
--     end
--     awful.ewmh.client_geometry_requests(c, context, hints)
-- end)
-- }}}

--awful.util.spawn('chromium')
--awful.util.spawn('start-pulseaudio-x11-mod')
