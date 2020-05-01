local awful = require("awful")

local get_sink_volume = function()
    local f = io.popen('pacmd dump')

    if f == nil then
        return false
    end

    local stdout = f:read("*a")
    f:close()

    local default_sink = stdout:match('set%-default%-sink (%S+)\n')
    if default_sink == nil then
        return
    end

    local volume = stdout:match('set%-sink%-volume ' .. default_sink:gsub('%.', '%%.'):gsub('%-', '%%-') .. ' (%S+)\n')
    return default_sink, tonumber(volume)
end

local modify_volume = function(diff)
    local default_sink, volume = get_sink_volume()
    volume = math.floor(volume + diff / 100 * 0x10000)
    awful.spawn.with_line_callback(
        'pacmd set-sink-volume ' .. default_sink .. ' ' .. string.format('0x%x', math.floor(volume)),
        {}
    )
    local volume_text = math.floor(volume / 0x10000 * 100) -- .. '%'

    local icon = tostring(0xFC58)
    if default_sink:match('bluez') then
        icon = tostring(0xF025)
    end

    awful.spawn(
        '/home/anderson/.scripts/not.sh \'{"icon_code":' .. icon ..
        ',"timeout":0.25,"message":"' .. tostring(volume_text) ..
        '","submessage":"' .. default_sink ..
        '"}\''
    )
end

return {
    get_sink_volume=get_sink_volume,
    modify_volume=modify_volume
}
