-- My AwesomeWM config
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

-- {{{ Variable definitions
beautiful.init("/home/anderson/.config/awesome/themes/custom.lua")

beautiful.taglist_squares_sel = beautiful.taglist_squares_unsel_empty
beautiful.taglist_squares_unsel = beautiful.taglist_squares_unsel_empty
beautiful.taglist_squares_sel_empty = beautiful.taglist_squares_unsel_empty

-- Naughty config
naughty.config.padding = 20
naughty.config.spacing = 10
naughty.config.defaults.border_width = 0
naughty.config.presets.critical.bg = beautiful.bg_focus

-- Widgets
local spacer = require("widgets.spacer")
local clay = require("widgets.clay")
local cpuwidget = require("widgets.cpuwidget")
local memwidget = require("widgets.memwidget")
local volume = require("widgets.volume")
--local openweathermap = require("widgets.openweathermap")
--local df = require("widgets.df")
local date = require("widgets.date")
local battery = require("widgets.battery")
local term = require("widgets.term")

-- {{{ Error handling
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

-- This is used later as the default terminal and editor to run.
local terminal = "termite"

-- Modifier keys.
local alt = "Mod1"
local super = "Mod4"
local ctrl = "Ctrl"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.fair
}

-- Wallpaper & tags for each screen.
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper.
    if beautiful.wallpapers then
        gears.wallpaper.maximized(beautiful.wallpapers[s.index], s, false)
    end

    -- Tags.
    local screen_tags
    if s.index == 1 then
        screen_tags = {'Q', 'W', 'I', 'M'}
    else
        screen_tags = {'X'}
    end
    for i, char in pairs(screen_tags) do
        local sel = i == 1
        awful.tag.add(char, {
            --icon_only=true,
            --icon='/home/anderson/.icons/tags/bullet.png',
            selected=sel,
            screen=s,
            layout=layouts[1]
        })
    end
end)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Wiboxes
local wiboxes = {}

for s = 1, screen.count() do
    -- Create the wibox
    local mywibox = awful.wibar({ position = "top", screen = s, height = 16 })
    wiboxes[s] = mywibox

    local layout = wibox.layout.align.horizontal()
    mywibox:set_widget(layout)

    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(awful.widget.layoutbox(s))

    left_layout:add(wibox.container.margin(
        awful.widget.layoutbox(s),
        0, 3, 0, 0
    ))

    if s == 1 then
        left_layout:add(awful.widget.taglist(s, awful.widget.taglist.filter.all, nil))
    end

    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then
        left_layout:add(wibox.container.margin(
            clay,
            3, 3, 0, 0
        ))
        --left_layout:add(clay)
        --left_layout:add(spacer)

        --right_layout:add(clay)
        local systray = wibox.widget.systray()
        systray:set_base_size(12)
        right_layout:add(wibox.container.margin(systray, 0, 6, 2, 0))

        right_layout:add(spacer)
        right_layout:add(cpuwidget)
        right_layout:add(spacer)
        right_layout:add(memwidget)
        right_layout:add(spacer)
        right_layout:add(term)
        right_layout:add(spacer)
        right_layout:add(volume)
    end
    right_layout:add(spacer)
    right_layout:add(date)
    right_layout:add(spacer)
    right_layout:add(battery)

    layout:set_left(left_layout)
    layout:set_right(right_layout)
end

-- Visual effect when switching screens
local original_focus = awful.screen.focus

awful.screen.focus = function(index)
    if type(index) == 'screen' then
        index = index.index
    end
    original_focus(index)
    local mywibox = wiboxes[index]
    -- Blink twice (change color 4 times)
    mywibox.bg = '#D64937'
    local i = 3
    gears.timer.start_new(0.04, function()
        i = i - 1
        if i % 2 == 1 then
            mywibox.bg = '#D64937'
        else
            mywibox.bg = nil
        end
        return i > 0
    end)
end

-- Mouse bindings
root.buttons(awful.util.table.join(
    --awful.button({ }, 3, function () mymainmenu:toggle() end),
    --awful.button({ }, 4, awful.tag.viewnext),
    --awful.button({ }, 5, awful.tag.viewprev)
))

local alt_tab = function ()
    local current_screen = awful.screen.focused().index
    local next_screen = current_screen + 1
    if next_screen > screen:count() then
        next_screen = 1
    end
    awful.screen.focus(next_screen)
end

-- Key bindings
local globalkeys = awful.util.table.join(
    -- Switch tag
    awful.key({super}, "Page_Up", awful.tag.viewprev),
    awful.key({super}, "Page_Down", awful.tag.viewnext),

    -- Switch screen
    awful.key({alt}, "Tab", alt_tab),
    awful.key({super}, "Tab", alt_tab),

    -- Layouts
    awful.key({super}, "space", function () awful.layout.inc(layouts,  1) end),

    -- Standard program
    awful.key({super}, "Return", function () awful.util.spawn(terminal) end),
    awful.key({super, ctrl}, "r", awesome.restart),

    -- Run rofi
    awful.key({super}, "r", function() awful.util.spawn('rofi -show run -terminal termite') end),

    awful.key({}, 'XF86AudioRaiseVolume', function() volume.increase_volume() end),
    awful.key({}, 'XF86AudioLowerVolume', function() volume.decrease_volume() end),

    -- Backlight
    awful.key({}, 'XF86MonBrightnessUp', function() awful.util.spawn('xbacklight +10%') end),
    awful.key({}, 'XF86MonBrightnessDown', function() awful.util.spawn('xbacklight -10%') end),

    -- Lock screen
    awful.key({ctrl, alt}, 'l', function() awful.util.spawn('/sh/i3lock.sh') end),

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
        print(awful.screen.focused().index, '->', index)
        awful.client.movetoscreen(client, index)
    end),

    -- NetworkManager DMenu
    awful.key({super}, "n", function() awful.util.spawn('networkmanager_dmenu') end),

    -- Screenshot
    awful.key({super}, "p", function() awful.util.spawn('/sh/sshot.sh') end)

    --awful.key({ super }, "p", function() menubar.show() end)
)

local clientkeys = awful.util.table.join(
    awful.key({alt}, 'F4', function(c) c:kill() end),
    awful.key({super}, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    --awful.key({super}, "p",  awful.client.floating.toggle                     ),
    awful.key({super}, "o",      awful.client.movetoscreen                        ),
    awful.key({super}, "t",      function (c) c.ontop = not c.ontop            end)
)

-- Bind all key numbers to tags.
for key, tag_name in pairs({Q='Q', W='W', I='I', E='I', M='M', T='M'}) do
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

local clientbuttons = awful.util.table.join(
    awful.button({}, 1, function (c) client.focus = c; c:raise() end),
    awful.button({super}, 1, awful.mouse.client.move),
    awful.button({super}, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
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
        rule = { class = "Chromium" },
        properties = { screen = 1, tag = "W" }
    },
    {
        rule_any = { class = {"TelegramDesktop", "IRCCloud", "ViberPC"} },
        properties = { screen = 1, tag = "I" }
    },
    {
        rule_any = { class = {"Evolution"} },
        properties = { screen = 1, tag = "M" }
    },
    --{
    --    --rule_any = { class = {"Google Play Music Desktop Player"} },
    --    rule_any = { class = {"Clay"} },
    --    properties = { tag = "A" }
    --},
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
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

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

--awful.util.spawn('chromium')
--awful.util.spawn('start-pulseaudio-x11-mod')
