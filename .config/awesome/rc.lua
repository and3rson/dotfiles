-- My AwesomeWM config
-- vim:foldmethod=marker
-- luacheck: ignore dbus
-- luacheck: globals root awesome screen dbus client mouse
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

-- Variable definitions {{{
beautiful.init("/home/anderson/.config/awesome/themes/custom.lua")
-- }}}

-- Naughty config {{{
naughty.config.padding = 20
naughty.config.spacing = 10
naughty.config.defaults.border_width = 0
naughty.config.presets.critical.bg = beautiful.bg_focus
-- }}}

-- Widgets {{{
--local spacer = require("widgets.spacer")
--local taglistline = require("widgets.taglistline")
--local clay = require("widgets.clay")
--local cpuwidget = require("widgets.cpuwidget")
--local memwidget = require("widgets.memwidget")
local volume_widget = require("widgets.volume")()
--local openweathermap = require("widgets.openweathermap")
----local df = require("widgets.df")
--local date = require("widgets.date")
--local battery = require("widgets.battery")
----local battery2 = require("widgets.battery2")
----local assault = require("widgets.assault")
--local term = require("widgets.term")
----local fan = require("widgets.fan")
----local bbswitch = require("widgets.bbswitch")
--local brightness = require("widgets.brightness")
--local ping = require("widgets.ping")
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

-- General veriables {{{
-- This is used later as the default terminal and editor to run.
local terminal = "termite"
-- }}}

-- Layouts {{{
-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.fair
}
-- }}}

-- Wallpaper & tags for each screen. {{{
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper.
    if beautiful.wallpapers then
        gears.wallpaper.maximized(beautiful.wallpapers[s.index], s, false)
    end

    -- Tags.
    local screen_tags
    if s.index == 1 then
        screen_tags = {'Q', 'W', 'I', 'M', 'A'}
    else
        screen_tags = {'X'}
    end
    --icons = ''
    for i, char in pairs(screen_tags) do
        local sel = i == 1
        awful.tag.add(char, {
            --icon_only=true,
            --icon='/home/anderson/.icons/tags/bullet.png',
            selected=sel,
            screen=s,
            layout=layouts[1],
            --icon='',
            icon='/home/anderson/.icons/q.png',
            icon_only=true
        })
    end

    local update_tag_icons = function ()
        -- get a list of all tags
        local atags = awful.tag.gettags(s)
        -- set the standard icon
        for i, t in ipairs(atags) do
            awful.tag.seticon('/home/anderson/.icons/tags/' .. t.name:lower() .. '_empty.png', t)
            --if t.selected then
            --    awful.tag.seticon('/home/anderson/.config/awesome/themes/layouts/' .. t.layout.name .. '_active.png', t)
            --else
            --    awful.tag.seticon('/home/anderson/.config/awesome/themes/layouts/' .. t.layout.name .. '_inactive.png', t)
            --end
        end
        -- get a list of all running clients
        local clist = client.get(s)
        for i, c in ipairs(clist) do
            -- get the tags on which the client is displayed
            local ctags = c:tags()
            for i, t in ipairs(ctags) do
                awful.tag.seticon('/home/anderson/.icons/tags/' .. t.name:lower() .. '.png', t)
            end
        end
    end
    s:connect_signal("tag::history::update", update_tag_icons)
    tag.connect_signal("property::layout", update_tag_icons)
    tag.connect_signal("tagged", update_tag_icons)
    tag.connect_signal("untagged", update_tag_icons)
end)

-- }}}

-- Wiboxes {{{
local wiboxes = {}

for s = 1, screen.count() do
    -- Create the wibox
    local mywibox = awful.wibar({ position = "top", screen = s, height = 24 })
    mywibox.visible = false
    wiboxes[s] = mywibox

    local layout = wibox.layout.align.horizontal()
    layout.expand = 'none'
    mywibox:set_widget(layout)

    local left_layout = wibox.layout.fixed.horizontal()

    --if s == 1 then
    --    left_layout:add(wibox.widget{
    --        taglistline(s, 2),
    --        layout=wibox.layout.stack
    --    })
    --    left_layout:add(spacer())
    --    left_layout:add(clay())
    --end

    local right_layout = wibox.layout.fixed.horizontal()
    local center_layout = wibox.layout.fixed.horizontal()
    --center_layout:add(date())
    if s == 1 then
        local systray = wibox.widget.systray()
        systray:set_base_size(20)
        --systray.forced_width = 0
        right_layout:add(wibox.container.margin(systray, 2, 2, 2, 2))

        --right_layout:add(spacer())
        --right_layout:add(cpuwidget())
        --right_layout:add(spacer())
        --right_layout:add(memwidget())
        --right_layout:add(spacer())
        ----right_layout:add(bbswitch)
        ----right_layout:add(spacer)
        --right_layout:add(openweathermap())
        --right_layout:add(spacer())
        --right_layout:add(ping())
        --right_layout:add(spacer())
        ----right_layout:add(fan)
        ----right_layout:add(spacer)
        --right_layout:add(brightness())
        --right_layout:add(spacer())
        --right_layout:add(term())
        --right_layout:add(spacer())
        right_layout:add(volume_widget)
    end
    --right_layout:add(spacer())
    --right_layout:add(battery())
    --right_layout:add(spacer())
    --right_layout:add(date())

    --right_layout:add(assault({
    --    normal_color=beautiful.fg_battery,
    --    critical_color=beautiful.fg_battery_warning,
    --    charging_color=beautiful.fg_battery_charging,
    --    stroke_width=1,
    --    font='DejaVu Sans Mono Bold 10',
    --    peg_width=2
    --}))

    layout:set_left(left_layout)
    --layout:set_middle(center_layout)
    layout:set_right(right_layout)
end

-- }}}

-- Visual effect when switching screens {{{
local original_focus = awful.screen.focus

awful.screen.focus = function(index)
    if type(index) == 'screen' then
        index = index.index
    end
    original_focus(index)
    local mywibox = wiboxes[index]
    -- Blink twice (change color 4 times)
    mywibox.bg = beautiful.bg_lit
    local i = 3
    gears.timer.start_new(0.04, function()
        i = i - 1
        if i % 2 == 1 then
            mywibox.bg = beautiful.bg_lit
        else
            mywibox.bg = beautiful.bg_normal
        end
        return i > 0
    end)
end

local alt_tab = function ()
    local current_screen = awful.screen.focused().index
    local next_screen = current_screen + 1
    if next_screen > screen:count() then
        next_screen = 1
    end
    awful.screen.focus(next_screen)
end

-- }}}

-- Key bindings {{{
-- Modifier keys.
local alt = "Mod1"
local super = "Mod4"
local ctrl = "Ctrl"

local globalkeys = awful.util.table.join(
    -- Switch screen
    awful.key({alt}, "Tab", alt_tab),
    awful.key({super}, "Tab", alt_tab),

    -- Layouts
    awful.key({super}, "space", function () awful.layout.inc(layouts,  1) end),

    -- Standard program
    awful.key({super}, "Return", function () awful.util.spawn(terminal) end),
    awful.key({super, ctrl}, "r", awesome.restart),
    awful.key({super, ctrl}, "q", awesome.quit),

    -- Run rofi
    awful.key({super}, "r", function() awful.util.spawn('rofi -show run -terminal termite') end),

    -- Volume control
    awful.key({}, 'XF86AudioRaiseVolume', function() volume_widget.increase_volume() end),
    awful.key({}, 'XF86AudioLowerVolume', function() volume_widget.decrease_volume() end),

    -- Backlight
    awful.key({}, 'XF86MonBrightnessUp', function() brightness.increase() end),
    awful.key({}, 'XF86MonBrightnessDown', function() brightness.decrease() end),

    -- Media keys
    awful.key({}, 'XF86AudioPlay', function() awful.util.spawn_with_shell('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.clay /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause') end),
    awful.key({}, 'XF86AudioNext', function() awful.util.spawn_with_shell('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.clay /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next') end),
    awful.key({}, 'XF86AudioPrev', function() awful.util.spawn_with_shell('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.clay /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous') end),

    -- Lock screen
    awful.key({ctrl, alt}, 'l', function() awful.util.spawn('/home/anderson/.scripts/i3lock.sh') end),

    -- Notifications
    awful.key({super}, 'Escape', function() naughty.destroy_all_notifications() end),

    -- Client management
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
    awful.key({super}, "j", function () awful.client.focus.byidx(1) end),
    awful.key({super}, "Page_Up", function () awful.client.focus.byidx(1) end),
    awful.key({super}, "k", function () awful.client.focus.byidx(-1) end),
    awful.key({super}, "Page_Down", function () awful.client.focus.byidx(-1) end),

    -- NetworkManager DMenu
    awful.key({super}, "n", function() awful.util.spawn('networkmanager_dmenu') end),

    -- Bluetooth menu
    awful.key({super}, "b", function() awful.util.spawn('blueman-manager') end),

    -- Screenshot
    awful.key({super}, "p", function() awful.util.spawn('/home/anderson/.scripts/sshot.sh') end),

    -- HPC YouTube player control
    awful.key({super}, ",", function() awful.util.spawn('curl -X POST 127.0.0.1:6565/playback --data \'{"op": "prev"}\'') end),
    awful.key({super}, ".", function() awful.util.spawn('curl -X POST 127.0.0.1:6565/playback --data \'{"op": "play"}\'') end),
    awful.key({super}, "/", function() awful.util.spawn('curl -X POST 127.0.0.1:6565/playback --data \'{"op": "next"}\'') end)

    --awful.key({ super }, "x", function() menubar.show() end)
)

local clientkeys = awful.util.table.join(
    awful.key({alt}, 'F4', function(c) c:kill() end),
    awful.key({super}, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({super}, "x",  awful.client.floating.toggle),
    awful.key({super}, "o",      awful.client.movetoscreen)
    --awful.key({super}, "t",      function (c) c.ontop = not c.ontop end)
)

-- Bind all key numbers to tags.
for key, tag_name in pairs({Q='Q', W='W', I='I', E='I', M='M', T='M', A='A', G='A'}) do
    globalkeys = awful.util.table.join(
        globalkeys,
        awful.key({super}, key:lower(), function()
            for _, tag in pairs(awful.tag.gettags(mouse.screen)) do
                if tag.name == tag_name then
                    awful.tag.viewonly(tag)
                end
            end
        end)
    )
end

--awful.client.focus.history.disable_tracking()

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
        rule_any = { class = {"Chromium", "Firefox"} },
        properties = { screen = 1, tag = "W" }
    },
    {
        rule_any = { class = {"TelegramDesktop", "IRCCloud", "ViberPC", "Slack", "discord"} },
        properties = { screen = 1, tag = "I" }
    },
    {
        rule_any = { class = {"Evolution"} },
        properties = { screen = 1, tag = "M" }
    }
}
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
    end
end)

function configure_borders(t)
    local count = 0
    for _, client in pairs(t:clients()) do
        count = count + 1
    end
    for _, client in pairs(t:clients()) do
        if count > 1 and t.layout.name ~= 'max' then
            client.border_width = 2
        else
            client.border_width = 0
        end
    end
end

client.connect_signal("focus", function(c)
    local current_tag = awful.tag.selected(c.screen)
    configure_borders(current_tag)
    c.border_color = beautiful.border_focus
    --c.border_width = 1
end)
tag.connect_signal('property::layout', function(t)
    configure_borders(t)
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    --c.border_width = 0
end)
-- }}}

--awful.util.spawn('chromium')
--awful.util.spawn('start-pulseaudio-x11-mod')
