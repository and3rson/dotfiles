local wibox = require('wibox')
local watch = require("awful.widget.watch")

CMD = [[bash -c "curl 'http://api.openweathermap.org/data/2.5/weather?appid=5041ca48d55a6669fe8b41ad1a8af753&q=Lviv,+Ukraine' | jq -r '((.main.temp - 273.15) | tostring) + \"\u00b0 (\" + (.weather | map(.main) | join(\", \")) + \")\"'"]]

local openweathermap_widget = wibox.widget{
    paddings=2,
    markup='~',
    widget=wibox.widget.textbox
}

local upopenweathermap_widget = function(widget, stdout, _, _, _)
    if stdout:sub(1, 1) == '-' then
        widget.text = '  ' .. stdout
    else
        widget.text = '  ' .. stdout
    end
end

watch(CMD, 900, upopenweathermap_widget, openweathermap_widget)

--return wibox.container.margin(openweathermap_widget, 2, 2, 2, 2)
return openweathermap_widget

