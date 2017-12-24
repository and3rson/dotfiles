local wibox = require('wibox')
local gears = require("gears")
local json = require("json")
local http = require("socket.http")

local APPID = '5041ca48d55a6669fe8b41ad1a8af753'
local CITY = 'Lviv,Ukraine'
local LANG='ua'
local URL = 'http://api.openweathermap.org/data/2.5/weather?appid=' .. APPID .. '&q=' .. CITY .. '&lang=' .. LANG
local CACHE_DIR = gears.filesystem.get_cache_dir() .. 'weather_icons/'

gears.filesystem.make_directories(CACHE_DIR)

local openweathermap_widget = wibox.widget{
    paddings=2,
    --forced_width=64,
    markup='~',
    widget=wibox.widget.textbox
}

local icon_widget = wibox.widget{
    forced_width=16,
    forced_height=16,
    widget=wibox.widget.imagebox
}

local download_icon = function(id)
    local response = http.request('http://openweathermap.org/img/w/' .. id .. '.png')
    if response ~= nil then
        local filename = CACHE_DIR .. id .. '.png'
        local f = io.open(filename, 'w')
        f:write(response)
        f:close()
        return filename
    end
    return nil
end

timer = gears.timer {
    timeout=5,
    autostart=true,
    callback=function()
        local response = http.request(URL)
        if response ~= nil then
            local data = json.decode(response)
            local temp = tonumber(data.main.temp) - 273.15
            --local icon = ''
            --if temp <= 0 then
            --    icon = ''
            --end
            local filepath = download_icon(data.weather[1].icon)
            icon_widget.image = filepath
            local weathers = {}
            for _, value in pairs(data.weather) do
                weathers[#weathers + 1] = value.description
            end
            openweathermap_widget.text = math.floor(tostring(temp)) .. '°' ..
            ' ' ..
            '(' .. table.concat(weathers, ", ") .. ')'
        end
    end
}
timer:emit_signal('timeout')

return wibox.widget{
    wibox.container.margin(icon_widget, 0, 4, 2, 0),
    openweathermap_widget,
    layout=wibox.layout.fixed.horizontal
}

