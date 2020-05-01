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
local FORCE_CITY = 'Lviv,Ukraine'

--gears.filesystem.make_directories(CACHE_DIR)

return function()
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
        openweathermap_widget.markup = 'Fetching'
        awful.spawn.easy_async('curl "' .. IPINFO_URL .. '"', function(stdout, stderr, reason, exit_code)
            if exit_code ~= 0 then
                openweathermap_widget.markup = 'Error'
                weather_timer.timeout = 5
                weather_timer:again()
                return
            else
                weather_timer.timeout = 900
                weather_timer:again()
            end
            local data = json.decode(stdout)
            local city, _ = data.city:gsub('\'', '')
            if city == 'Lvov' then
                -- >:(
                -- Update: seems not to reproduce anymore :)
                city = 'Lviv'
            end
            local location = city .. ',' .. data.country
            if FORCE_CITY ~= nil then
                location = FORCE_CITY
            end
            awful.spawn.easy_async('curl "' .. OWM_URL:format(location) .. '"', function(stdout, stderr, reason, exit_code)
                local data = json.decode(stdout)
                if data.message then
                    openweathermap_widget.markup = data.message
                    return
                end
                weather_data = data
                local temp = tonumber(data.main.temp) - 273.15
                local city_name = data.name
                if city == 'Lviv' then
                    city_name = 'Львів'
                end
                openweathermap_widget.markup = '<span color="' .. beautiful.fg_owm_text .. '">' .. city_name .. ', ' .. math.floor(temp) .. '°C</span>'
                icon_widget.markup = '<span size="14000" color="' .. beautiful.fg_owm_icon .. '">' .. utf8.char(owfont[data.weather[1].id]) .. '</span>'
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

    local widget = utils.make_row{
        --wibox.container.margin(icon, 0, 4, 2, 0),
        icon_widget,
        wibox.layout.margin(openweathermap_widget, 0, 0, 0, 2)
    }

    widget:connect_signal('button::press', function(lx, ly, button, mods, find_widgets_result)
        fetch_weather()
        --awful.util.spawn('pavucontrol')
    end)

    widget_t = awful.tooltip{
        objects={widget},
        timer_function=function()
            if weather_data == nil then
                return nil
            end
            local s = '<span size="12000" font="Roboto Regular">'
            s = s .. 'Температура: ' .. math.floor(weather_data.main.temp - 273.15) .. '°\n'
            s = s .. 'Умови:\n'
            for _, value in pairs(weather_data.weather) do
                s = s .. '  - ' .. value.description .. '\n'
            end
            local wind_str = ''
            if weather_data.wind.deg then
                wind_str = ' (' .. weather_data.wind.deg .. '°)'
            end
            s = s .. 'Вологість: ' .. weather_data.main.humidity .. '%\n'
            --s = s .. 'Видимість: ' .. weather_data.visibility .. '\n'
            s = s .. 'Вітер: ' .. weather_data.wind.speed .. ' м/с' .. wind_str
            s = s .. '</span>'
            return s
        end
    }
    return widget
end
