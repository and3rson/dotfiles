local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local utils = require("utils")

return function(s)
    local icon = wibox.widget{
        --markup='<span size="2000"> </span><span color="#74fe7b"></span>',
        markup='<span size="2000"> </span><span color="#74fe7b"></span>',
        widget=wibox.widget.textbox
    }

    local memgraph_widget = wibox.widget {
        max_value = 100,
        color = beautiful.fg_mem_graph,
        background_color = '#00000000',
        --color = '#7777FF',
        --background_color = "#1e252c",
        --border_width = 1,
        --border_color = beautiful.fg_mem,
        forced_width = 48,
        forced_height = 24,
        step_width = 2,
        step_spacing = 1,
        widget = wibox.widget.graph
    }

    -- mirror and pushs up a bit
    local mem_widget = wibox.container.margin(wibox.container.mirror(memgraph_widget, { horizontal = true }), 0, 1, 0, 0)

    local total_prev = 0
    local idle_prev = 0

    local split = function(s)
        local parts = {}
        for part in string.gmatch(s, '%S+') do
            parts[#parts + 1] = part
        end
        return parts
    end

    gears.timer {
        timeout=0.25,
        autostart=true,
        callback=function()
            local lines = {}
            for line in io.lines('/proc/meminfo') do
                lines[#lines + 1] = line
            end
            local total = split(lines[1])[2]
            local available = split(lines[3])[2]
            total, _ = tonumber(total)
            available, _ = tonumber(available)
            local used = total - available
            local diff_usage = used / total * 100

            local color = beautiful.fg_mem_graph

            if diff_usage > 80 then
                color = beautiful.fg_mem_warning
            end

            memgraph_widget:set_color(color)
            icon.markup = string.format(
                --'<span color="%s"><span size="2000"> </span><span color="#74fe7b"></span> %2.0f</span>',
                '<span color="%s">%2.0f</span>',
                color,
                diff_usage
            )

            memgraph_widget:add_value(used / total * 100)
        end
    }

    --local layout = wibox.layout.fixed.horizontal()
    local layout = wibox.layout.stack
    layout.spacing = 8
    local offset = 0
    if awesome.hostname == 'vinga' then
        offset = 3
    end
    local widget = utils.make_row{
        icon,
        wibox.widget{
            -- icon,
            --wibox.container.mirror(cpu_widget, {vertical=true}),
            wibox.container.margin(mem_widget, 0, 0, 0, s.panel.height / 2 - offset),
            wibox.container.mirror(wibox.container.margin(mem_widget, 0, 0, 0, s.panel.height / 2 - offset), {vertical=true}),
            layout=layout
        }
    }
    return widget
end
