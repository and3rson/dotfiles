-- Standard awesome library
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
local common = require("awful.widget.common")

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
local openweathermap = require("widgets.openweathermap")
local df = require("widgets.df")
local date = require("widgets.date")
local battery = require("widgets.battery")

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
terminal = "termite"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.fair
}
-- }}}

awful.screen.connect_for_each_screen(function(s)
    -- {{{ Wallpaper
    if beautiful.wallpaper then
        gears.wallpaper.maximized(beautiful.wallpaper, s, false)
    end
    -- }}}

    -- {{{ Tags
    -- Each screen has its own tag table.
    for i, char in pairs({'Q', 'W', 'I', 'M'}) do
        local sel = i == 1
        awful.tag.add(char, {
            --icon_only=true,
            --icon='/home/anderson/.icons/tags/bullet.png',
            selected=sel,
            screen=s,
            layout=layouts[1]
        })
    end
    --awful.tag({ "Q", "W", "I", "M", "A", "G" }, s, layouts[1])
    -- }}}
end)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox

--local taglist_label_orig = awful.widget.taglist.taglist_label
--print(awful.widget.taglist.taglist_label)
--awful.widget.taglist = function(t, args)
    --local text, bgc, bgi, icon, other = taglist_label_orig(t, args)
    --return text, bgc, bgi, icon, other
--end


for s = 1, screen.count() do
    -- Create the wibox
    local mywibox = awful.wibox({ position = "top", screen = s, height = 18 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(awful.widget.layoutbox(s))
    left_layout:add(awful.widget.taglist(s, awful.widget.taglist.filter.all, nil))

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then
        local systray = wibox.widget.systray()
        systray:set_base_size(12)
        right_layout:add(wibox.container.margin(systray, 0, 6, 2, 0))
        right_layout:add(spacer)
        right_layout:add(clay)
        right_layout:add(spacer)
        right_layout:add(cpuwidget)
        right_layout:add(spacer)
        right_layout:add(memwidget)
        right_layout:add(spacer)
        right_layout:add(volume)
        right_layout:add(spacer)
        right_layout:add(df)
        right_layout:add(spacer)
        right_layout:add(openweathermap)
    end
    right_layout:add(spacer)
    right_layout:add(date)
    right_layout:add(spacer)
    right_layout:add(battery)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(awful.widget.tasklist(
        s,
        awful.widget.tasklist.filter.currenttags,
        nil,
        nil,
        function(w, buttons, label, data, objects)
            common.list_update(w, buttons, label, data, objects)
            w:set_max_widget_size(28)
        end,
        wibox.layout.flex.horizontal()
    ))
    layout:set_right(right_layout)

    mywibox:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    --awful.button({ }, 3, function () mymainmenu:toggle() end),
    --awful.button({ }, 4, awful.tag.viewnext),
    --awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Page_Up",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Page_Down",  awful.tag.viewnext       ),
    --awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    --awful.key({ modkey,           }, "Left",
    --    function ()
    --        awful.client.focus.byidx( 1)
    --        if client.focus then client.focus:raise() end
    --    end),
    --awful.key({ modkey,           }, "Right",
    --    function ()
    --        awful.client.focus.byidx(-1)
    --        if client.focus then client.focus:raise() end
    --    end),
    --awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ 'Mod1',           }, "Tab",
        function ()
            current_screen = awful.screen.focused().index
            next_screen = current_screen + 1
            if next_screen > screen:count() then
                next_screen = 1
            end
            awful.screen.focus(next_screen)
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Control" }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    --awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    awful.key({modkey}, "r", function() awful.util.spawn('rofi -show run -terminal termite') end),

    --awful.key({ modkey }, "x",
    --          function ()
    --              awful.prompt.run({ prompt = "Run Lua code: " },
    --              mypromptbox[mouse.screen].widget,
    --              awful.util.eval, nil,
    --              awful.util.getdir("cache") .. "/history_eval")
    --          end),

    --awful.key({}, 'XF86AudioRaiseVolume', function() awful.util.spawn('amixer set Master 2%+') end),
    --awful.key({}, 'XF86AudioLowerVolume', function() awful.util.spawn('amixer set Master 2%-') end)
    awful.key({}, 'XF86AudioRaiseVolume', function() volume.increase_volume() end),
    awful.key({}, 'XF86AudioLowerVolume', function() volume.decrease_volume() end),
    -- Backlight
    awful.key({}, 'XF86MonBrightnessUp', function() awful.util.spawn('xbacklight +10%') end),
    awful.key({}, 'XF86MonBrightnessDown', function() awful.util.spawn('xbacklight -10%') end),
    -- Lock screen
    awful.key({'Ctrl', 'Mod1'}, 'l', function() awful.util.spawn('/sh/i3lock.sh') end),
    -- Notifications
    awful.key({modkey}, 'Escape', function() naughty.destroy_all_notifications() end),
    -- Client management
    awful.key({modkey}, 'Left', awful.client.movetoscreen),
    awful.key({modkey}, 'Right', function(client)
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
    awful.key({modkey}, "'", function() awful.util.spawn('networkmanager_dmenu') end)
    -- Tag management
    --awful.key({ modkey }, "Left",
    --                 function()
    --                    local current_screen = awful.screen.focused()
    --                    local screens_count = screen:count()
    --                    if current_screen == nil or current_screen == '' then
    --                       return
    --                    end
    --                    if awful.tag.selected(current_screen.index) == nil then
    --                       return
    --                    end
    --                    local selected_screen_index = awful.tag.selected(current_screen.index).screen.index
    --                    if selected_screen_index < screens_count then
    --                        local target_screen = selected_screen_index + 1
    --                        local current_tag = awful.tag.selected(current_screen.index)
    --                        current_tag.screen = target_screen

    --                        awful.screen.focus(target_screen)
    --                        current_tag:view_only()
    --                    end
    --                 end,
    --           {description = "move tag to the screen to left", group = "tag"}),
    --awful.key({ modkey }, "Right",
    --                 function()
    --                    local current_screen = awful.screen.focused()
    --                    local screens_count = screen:count()
    --                    if current_screen == nil or current_screen == '' then
    --                       return
    --                    end
    --                    if awful.tag.selected(current_screen.index) == nil then
    --                       return
    --                    end
    --                    local selected_screen_index = awful.tag.selected(current_screen.index).screen.index
    --                    if selected_screen_index > 1 then
    --                        local target_screen = selected_screen_index - 1
    --                        local current_tag = awful.tag.selected(current_screen.index)
    --                        current_tag.screen = target_screen

    --                        awful.screen.focus(target_screen)
    --                        current_tag:view_only()
    --                    end
    --                 end,
    --           {description = "move tag to the screen to left", group = "tag"})
    -- Menubar
    --awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ 'Mod1'            }, "F4",     function (c) print(c); c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end)
    --awful.key({ modkey,           }, "m",
    --    function (c)
    --        c.maximized_horizontal = not c.maximized_horizontal
    --        c.maximized_vertical   = not c.maximized_vertical
    --    end),
    --awful.key({ modkey, "Shift",  }, "F2",    function ()
    --                awful.prompt.run({ prompt = "Rename tab: ", text = awful.tag.selected().name, },
    --                mypromptbox[mouse.screen].widget,
    --                function (s)
    --                    awful.tag.selected().name = s
    --                end)
    --        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for key, index in pairs({Q=1, W=2, I=3, M=4, A=5, G=6}) do
    globalkeys = awful.util.table.join(
        globalkeys,
        awful.key({modkey}, key:lower(), function()
            for _, tag in pairs(awful.tag.gettags(mouse.screen)) do
                if tag.name == key then
                    awful.tag.viewonly(tag)
                end
            end
            --awful.tag.viewonly(awful.tag.gettags(mouse.screen)[index])
        end)
    )
end

--awful.client.focus.history.disable_tracking()

for i = 1, 9 do
    globalkeys = awful.util.table.join(
        globalkeys,
        awful.key({modkey}, tostring(i), function(c)
            clients = awful.screen.focused().selected_tag:clients()
            if clients[i] ~= nil then
                clients[i]:jump_to()
            end
        end)
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

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
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    --{ rule = { class = "gimp" },
    --  properties = { floating = true } },
    {
        rule_any = { class = {"HomeTerm"} },
        properties = { tag = "Q" }
    },
    {
        rule = { class = "Chromium" },
        properties = { tag = "W" }
    },
    {
        rule_any = { class = {"TelegramDesktop"} },
        properties = { tag = "I" }
    },
    {
        rule_any = { class = {"Evolution"} },
        properties = { tag = "M" }
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
    -- Enable sloppy focus
    --c:connect_signal("mouse::enter", function(c)
    --    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    --        and awful.client.focus.filter(c) then
    --        client.focus = c
    --    end
    --end)

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

