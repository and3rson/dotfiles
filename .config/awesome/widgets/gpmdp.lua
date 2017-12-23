local awful = require('awful')
local wibox = require('wibox')
--local watch = require("awful.widget.watch")
local gears = require("gears");
local json = require("json");

--CMD = "bash -c \"/bin/cat ~/.config/Google\\ Play\\ Music\\ Desktop\\ Player/json_store/playback.json | jq -r '.song.artist + \\\" - \\\" + .song.title'\""

local gpmdp_widget = wibox.widget {
    markup='~',
    widget=wibox.widget.textbox
}

local update_widget = function()
    content = ''
    for line in io.lines('/home/anderson/.config/Google Play Music Desktop Player/json_store/playback.json') do
        content = content .. line
    end
    data = json.decode(content)
    if data.playing then
        color = '#44FF77'
        icon = ''
    else
        color = '#FFCC77'
        icon = ''
    end
    gpmdp_widget.markup = '<span color="' .. color .. '">' .. icon .. ' ' .. data.song.artist .. ' - ' .. data.song.title .. '</span>'
end

gears.timer {
    timeout=1,
    autostart=true,
    callback=update_widget
}
--watch(CMD, 1, update_widget, gpmdp_widget)

--return wibox.container.margin(gpmdp_widget, 2, 2, 2, 2)
return gpmdp_widget

