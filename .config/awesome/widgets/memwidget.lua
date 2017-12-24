local watch = require("awful.widget.watch")
local wibox = require("wibox")

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

watch("free", 0.25,
    function(widget, stdout, stderr, exitreason, exitcode)
        local total = split(stdout)[8]
        local used = split(stdout)[9]
        total, _ = tonumber(total)
        used, _ = tonumber(used)
        diff_usage = used / total * 100
        if diff_usage > 80 then
            widget:set_color('#ff4136')
        else
            widget:set_color('#74fe7b')
        end
        widget:add_value(used / total * 100)
    end,
    memgraph_widget
)

return mem_widget

