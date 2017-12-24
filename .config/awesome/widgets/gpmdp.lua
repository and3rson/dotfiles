local wibox = require('wibox')
local gears = require("gears");
local beautiful = require('beautiful')
local json = require("json");

local progressbar = wibox.widget {
    forced_width=10,
    max_value=100,
    value=30,
    background_color=beautiful.bg_minimize,
    color=beautiful.bg_focus,
    widget=wibox.widget.progressbar,
    margins={
        bottom=16
    }
}

local gpmdp_widget = wibox.widget {
    markup='~',
    widget=wibox.widget.textbox
}

local update_widget = function()
    local content = ''
    for line in io.lines('/home/anderson/.config/Google Play Music Desktop Player/json_store/playback.json') do
        content = content .. line
    end
    local data = json.decode(content)
    local color, icon, current, total, progress
    if data.playing then
        color = '#44FF77'
        icon = ''
        --icon = '▷'
    else
        color = '#FFCC77'
        icon = ''
        --icon = '◫'
    end
    progress = data.time.current / data.time.total * 100
    --current = math.floor(data.time.current / 1000)
    total = math.floor(data.time.total / 1000)
    --current = string.format('%02d:%02d', math.floor(current / 60), current % 60)
    total = string.format('%02d:%02d', math.floor(total / 60), total % 60)
    progressbar.value = progress
    progressbar.color = color
    gpmdp_widget.markup = '<span color="' .. color ..
        '">' .. icon ..
        ' ' ..
        data.song.artist .. ' - ' .. data.song.title ..
        ' ' ..
        '[' .. total .. ']' ..
        '</span>'
end

gears.timer {
    timeout=1,
    autostart=true,
    callback=update_widget
}
--watch(CMD, 1, update_widget, gpmdp_widget)

--return wibox.container.margin(gpmdp_widget, 2, 2, 2, 2)
return wibox.widget{
    progressbar,
    gpmdp_widget,
    layout=wibox.layout.stack
}

