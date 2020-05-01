-------------------------------------------------
-- CPU Widget for Awesome Window Manager
-- Shows the current CPU utilization
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/cpu-widget

-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov
-------------------------------------------------

local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local utils = require("utils")

return function(s)
    local icon = wibox.widget{
        --markup='<span size="2000"> </span><span size="8000" color="#74aeab"></span>',
        markup='<span size="2000"> </span><span size="'..math.floor(s.panel.height*1000/3)..'" color="#7777FF"></span>',
        widget=wibox.widget.textbox
    }

    local cpugraph_widget = wibox.widget {
        max_value = 100,
        --color = '#74aeab',
        --color = '#7777FF',
        color = beautiful.fg_cpu_graph,
        background_color = '#00000000',
        --background_color = "#1e252c",
        --border_width = 1,
        --border_color = beautiful.fg_cpu,
        forced_width = 24,
        forced_height = 24,
        step_width = 2,
        step_spacing = 1,
        widget = wibox.widget.graph
    }

    -- mirror and pushs up a bit
    local cpu_widget = wibox.container.margin(wibox.container.mirror(cpugraph_widget, { horizontal = true }), 0, 1, 0, 0)

    local total_prev = 0
    local idle_prev = 0

    gears.timer {
        timeout=0.25,
        autostart=true,
        callback=function()
            local lines = {}
            for line in io.lines('/proc/stat') do
                lines[#lines + 1] = line
            end
            local info = lines[1]
            local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
            info:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)')

            local total = user + nice + system + idle + iowait + irq + softirq + steal

            local diff_idle = idle - idle_prev
            local diff_total = total - total_prev
            local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

            --icon = ''

            --local color = beautiful.fg_cpu_graph

            local color = beautiful.fg_cpu_graph

            if diff_usage > 80 then
                color = beautiful.fg_cpu_warning
                --cpugraph_widget:set_color(beautiful.bg_focus)
            end

            cpugraph_widget:set_color(color)
            icon.markup = string.format(
                --'<span color="%s"><span size="2000"> </span><span size="10000"></span> %2.0f</span>',
                '<span color="%s">%2.0f</span>',
                color,
                diff_usage
            )

            cpugraph_widget:add_value(diff_usage)

            total_prev = total
            idle_prev = idle
        end
    }
    --watch("cat /proc/stat | grep '^cpu '", 0.25,
    --    cpugraph_widget
    --)

    --local layout = wibox.layout.fixed.horizontal()
    local layout = wibox.layout.stack
    layout.spacing = 8
    local widget = utils.make_row{
        icon,
        wibox.widget{
            wibox.container.margin(cpu_widget, 0, 0, 0, s.panel.height / 2),
            wibox.container.mirror(wibox.container.margin(cpu_widget, 0, 0, 0, s.panel.height / 2), {vertical=true}),
            layout=layout
        }
    }
    return widget
end
