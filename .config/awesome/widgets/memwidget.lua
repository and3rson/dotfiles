local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

return function()
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
        forced_width = 32,
        --forced_height = 12,
        step_width = 1,
        step_spacing = 2,
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
        timeout=0.2,
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
            diff_usage = used / total * 100
            if diff_usage > 80 then
                --icon.markup = '<span size="2000"> </span><span size="10000" color="#ff4136"></span>'
                memgraph_widget:set_color(beautiful.fg_mem_warning)
                --memgraph_widget:set_color(beautiful.bg_focus)
            else
                --icon.markup = '<span size="2000"> </span><span size="10000" color="#74fe7b"></span>'
                memgraph_widget:set_color(beautiful.fg_mem_graph)
                --memgraph_widget:set_color(beautiful.fg_normal)
            end
            memgraph_widget:add_value(used / total * 100)
        end
    }

    local layout = wibox.layout.fixed.horizontal()
    layout.spacing = 8
    local widget = wibox.widget{
        --icon,
        wibox.container.mirror(mem_widget, {vertical=true}),
        layout=layout
    }
    return widget
end
