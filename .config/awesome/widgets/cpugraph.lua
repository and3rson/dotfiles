local gears = require("gears")

local get_lines = function(file)
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

local split = function(s)
    local parts = {}
    for part in string.gmatch(s, '%S+') do
        parts[#parts + 1] = part
    end
    return parts
end

local get_values = function()
    local lines = get_lines('/proc/stat')
    local parts = split(lines[2])
    return {parts[2], parts[3], parts[4], parts[5]}
end

local oldvalues = get_values()

local update_values = function()
    local nval = get_values()
    local oval = oldvalues

    local busy = nval[1] + nval[2] + nval[3] - oval[1] - oval[2] - oval[3]
    local total = busy + nval[4] - oval[4]

    local value = 0
    if total > 0 then
        value = busy * 100.0 / total
    end
    oldvalues = nval
end

gears.timer {
    timeout=0.1,
    autostart=true,
    callback=update_values
}

