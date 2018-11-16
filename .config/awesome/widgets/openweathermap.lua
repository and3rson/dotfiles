local awful = require('awful')
local wibox = require('wibox')
local gears = require("gears")
local beautiful = require("beautiful")
local json = require("json")
local utils = require("utils")
local owfont = require('../owfont')
--local http = require("socket.http")

local IPINFO_TOKEN = '7a7b7d106c9490'
local IPINFO_URL = 'http://ipinfo.io/?token=' .. IPINFO_TOKEN
local OWM_APPID = '5041ca48d55a6669fe8b41ad1a8af753'
local OWM_LANG = 'ua'
local OWM_URL = 'http://api.openweathermap.org/data/2.5/weather?appid=' .. OWM_APPID .. '&q=%s&lang=' .. OWM_LANG

--gears.filesystem.make_directories(CACHE_DIR)

local weather_data = nil

local openweathermap_widget = wibox.widget{
    paddings=2,
    --forced_width=64,
    markup='~',
    widget=wibox.widget.textbox
}

local icon_widget = wibox.widget{
    --forced_width=24,
    --forced_height=24,
    markup='~',
    widget=wibox.widget.textbox
}

local fetch_weather = function()
    awful.spawn.easy_async('curl "' .. IPINFO_URL .. '"', function(stdout, stderr, reason, exit_code)
        if exit_code ~= 0 then
            weather_timer.timeout = 5
            weather_timer:again()
            return
        else
            weather_timer.timeout = 900
            weather_timer:again()
        end
        local data = json.decode(stdout)
        local location = data.city .. ',' .. data.country
        awful.spawn.easy_async('curl "' .. OWM_URL:format(location) .. '"', function(stdout, stderr, reason, exit_code)
            local data = json.decode(stdout)
            weather_data = data
            local temp = tonumber(data.main.temp) - 273.15
            openweathermap_widget.markup = '<span color="#FFFFFF">' .. data.name .. ', ' .. math.floor(temp) .. '°C</span>'
            icon_widget.markup = '<span size="16000" color="' .. beautiful.fg_bright .. '">' .. utf8.char(owfont[data.weather[1].id]) .. '</span>'
            --fetch_icon(data.weather[1].icon)
        end)
    end)
    return false
end

--fetch_weather()
weather_timer = gears.timer.start_new(0, fetch_weather)

--timer = gears.timer {
--    timeout=1,
--    autostart=true,
--    callback=function()
--        return fetch_weather()
--        --local response = http.request(URL)
--        --if response ~= nil then
--        --    local data = json.decode(response)
--        --    local temp = tonumber(data.main.temp) - 273.15
--        --    --local icon = ''
--        --    --if temp <= 0 then
--        --    --    icon = ''
--        --    --end
--        --    weather_data = data
--        --    local filepath = download_icon(data.weather[1].icon)
--        --    icon_widget.image = filepath
--        --    local weathers = {}
--        --    for _, value in pairs(data.weather) do
--        --        weathers[#weathers + 1] = value.description
--        --    end
--        --    openweathermap_widget.markup = '<span size="8000">' .. math.floor(tostring(temp)) .. '°</span>'
--        --    -- ..
--        --    -- ' ' ..
--        --    -- '(' .. table.concat(weathers, ", ") .. ')'
--        --else
--        --    openweathermap_widget.markup = '<span size="8000">No info</span>'
--        --    icon_widget.image = DEFAULT_ICON
--        --end
--    end
--}
--timer:emit_signal('timeout')

widget = utils.make_row{
    --wibox.container.margin(icon, 0, 4, 2, 0),
    icon_widget,
    wibox.layout.margin(openweathermap_widget, 0, 0, 0, 2)
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

