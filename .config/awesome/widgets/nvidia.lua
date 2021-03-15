-------------------------------------------------
-- CPU Widget for Awesome Window Manager
-- Shows the current CPU utilization
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/cpu-widget

-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local utils = require("utils")
local fs = require('path.fs')

return function(s)
    local icon = wibox.widget{
        markup='<span size="14000">ﳻ</span>',
        widget=wibox.widget.textbox
    }

    local text = wibox.widget{
        markup='NV: ...',
        widget=wibox.widget.textbox
    }

    local loaded = false
    local enabled = false

    function update()
        -- Probe kernel module
        loaded = fs.exists('/sys/module/nvidia')

        -- Probe bbswitch
        local busid, state = utils.getline('/proc/acpi/bbswitch'):match('(.*) (.*)')
        enabled = false
        if state == 'ON' then
            enabled = true
        end

        local color = beautiful.fg_text
        if loaded or enabled then
            color = beautiful.fg_danger
        end

        local loaded_state = 'unloaded'
        if loaded then
            loaded_state = 'loaded'
        end
        local enabled_state = 'OFF'
        if enabled then
            enabled_state = 'ON'
        end

        icon.markup = string.format('<span size="14000" color="%s">ﳻ</span>', color)
        text.markup = string.format('<span color="%s">%s (%s)</span>', color, enabled_state, loaded_state)
    end

    gears.timer {
        timeout=1,
        autostart=true,
        callback=update
    }
    update()
    -- text:connect_signal('button::press', function(lx, ly, button, mods, find_widgets_result)
    --     if enabled then
    --         awful.util.spawn('sudo ~/.scripts/nvidia_unload.sh')
    --     else
    --         awful.util.spawn('sudo ~/.scripts/nvidia_load.sh')
    --     end
    -- end)

    local layout = wibox.layout.stack
    local widget = utils.make_row{
        icon,
        text
    }
    return widget
end
