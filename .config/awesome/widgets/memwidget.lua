local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gears = require("gears")

local memgraph_widget = wibox.widget {
    max_value = 100,
    color = '#74fe7b',
    --background_color = "#1e252c",
    forced_width = 32,
    step_width = 2,
    step_spacing = 1,
    widget = wibox.widget.graph
}

-- mirros and pushs up a bit
local mem_widget = wibox.container.margin(wibox.container.mirror(memgraph_widget, { horizontal = true }), 0, 0, 0, 2)

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
        diff_usage = used / total * 100
        if diff_usage > 80 then
            memgraph_widget:set_color('#ff4136')
        else
            memgraph_widget:set_color('#74fe7b')
        end
        memgraph_widget:add_value(used / total * 100)
    end
}

return mem_widget

