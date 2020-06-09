local wibox = require('wibox')
local gears = require('gears')
local beautiful = require("beautiful")
local PATH = require('path')
local utils = require("../utils")

-- local CMD = [[stat -f / --format "%b %a %s"]]
local cpu = '/sys/devices/system/cpu/cpu0/cpufreq'
local cur_freq_file = PATH.join(cpu, 'scaling_cur_freq')
local max_freq_file = PATH.join(cpu, 'scaling_max_freq')

local get_lines = function(file)
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

return function(s)
    local progressbar = wibox.widget {
        forced_width=10,
        max_value=100,
        value=0,
        background_color=beautiful.bg_weak,
        color=beautiful.fg_normal,
        widget=wibox.widget.progressbar,
        margins=beautiful.progressbar_margins
    }

    local cpuclock_freq = wibox.widget{
        paddings=2,
        markup='~',
        widget=wibox.widget.textbox
    }

    local cpuclock_unit = wibox.widget{
        paddings=2,
        markup='~',
        font=beautiful.font_smaller,
        valign='center',
        widget=wibox.widget.textbox
    }

    local max_freq = tonumber(get_lines(max_freq_file)[1])
    progressbar.max_value = max_freq

    panel_color_timer = gears.timer{
        timeout=0.5,
        autostart=true,
        call_now=true,
        callback=function()
            local cur_freq = tonumber(get_lines(cur_freq_file)[1])
            progressbar.value = cur_freq
            if cur_freq >= 1000000 then
                cpuclock_freq.text = string.format('%.1f', cur_freq / 1000000)
                cpuclock_unit.text = 'GHz'
            else
                cpuclock_freq.text = string.format('%d', math.floor(cur_freq / 1000))
                cpuclock_unit.text = 'MHz'
            end
        end
    }

    -- local update_widget = function(widget, stdout, _, _, _)
    --     local parts = stdout:gmatch('%S+')
    --     local blocks_total = tonumber(parts())
    --     local blocks_free = tonumber(parts())
    --     local block_size = tonumber(parts())



    --     local percentage = (1 - blocks_free / blocks_total) * 100

    --     widget.markup = string.format(
    --         '%.1f',
    --         block_size * blocks_free / (1024 ^ 3)
    --     ) .. ' GB'
    --     progressbar.value = percentage
    -- end

    -- watch(CMD, 10, update_widget, df_widget)

    return wibox.widget{
        progressbar,
        utils.make_row({
            cpuclock_freq,
            cpuclock_unit
        }, 2),
        layout=wibox.layout.stack
    }
end
