local awful = require('awful')
local wibox = require('wibox')
local gears = require("gears")
local beautiful = require("beautiful")
local json = require("json")
local http = require("socket.http")

local APPID = '5041ca48d55a6669fe8b41ad1a8af753'
local CITY = 'Lviv,Ukraine'
local LANG='ua'
local URL = 'http://api.openweathermap.org/data/2.5/weather?appid=' .. APPID .. '&q=' .. CITY .. '&lang=' .. LANG
local CACHE_DIR = gears.filesystem.get_cache_dir() .. 'weather_icons/'
local DEFAULT_ICON = '/usr/share/icons/gnome/48x48/status/weather-few-clouds-night.png'

gears.filesystem.make_directories(CACHE_DIR)

local weather_data

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
    timeout=900,
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
            weather_data = data
            local filepath = download_icon(data.weather[1].icon)
            icon_widget.image = filepath
            local weathers = {}
            for _, value in pairs(data.weather) do
                weathers[#weathers + 1] = value.description
            end
            openweathermap_widget.markup = '<span size="8000">' .. math.floor(tostring(temp)) .. '°</span>'
            -- ..
            -- ' ' ..
            -- '(' .. table.concat(weathers, ", ") .. ')'
        else
            openweathermap_widget.markup = '<span size="8000">No info</span>'
            icon_widget.image = DEFAULT_ICON
        end
    end
}
timer:emit_signal('timeout')

widget = wibox.widget{
    wibox.container.margin(icon_widget, 0, 4, 2, 0),
    openweathermap_widget,
    layout=wibox.layout.fixed.horizontal
}
widget_t = awful.tooltip{
    objects={widget},
    timer_function=function()
        if weather_data == nil then
            return nil
        end
        local s = ''
        s = s .. 'Температура: ' .. math.floor(weather_data.main.temp - 273.15) .. '°\n'
        s = s .. 'Умови:\n'
        for _, value in pairs(weather_data.weather) do
            s = s .. '  - ' .. value.description .. '\n'
        end
        s = s .. 'Вологість: ' .. weather_data.main.humidity .. '%\n'
        s = s .. 'Видимість: ' .. weather_data.visibility .. '\n'
        s = s .. 'Вітер: ' .. weather_data.wind.speed .. 'м/с (' .. weather_data.wind.deg .. '°)'
        return s
    end
}
return widget

