local wibox = require('wibox')
local gears = require("gears");
local beautiful = require('beautiful')
local json = require("json");
local inotify = require("inotify");

local FILE = '/tmp/clay.json'

local progressbar = wibox.widget {
    forced_width=10,
    max_value=100,
    value=0,
    background_color=beautiful.bg_minimize,
    color=beautiful.bg_focus,
    widget=wibox.widget.progressbar,
    margins={
        bottom=15
    }
}

local clay_widget = wibox.widget {
    markup='Clay not running',
    widget=wibox.widget.textbox
}

local update_widget = function()
    local content = ''
    f = io.open(FILE)
    if f == nil then
        clay_widget.markup = 'Clay not running'
    else
        for line in f:lines() do
            content = content .. line
        end
    end
    local data = json.decode(content)
    local color, icon, total, progress
    if data.playing then
        color = '#44FF77'
        icon = ''
        --icon = '▷'
    else
        color = '#FFCC77'
        icon = ''
        --icon = '◫'
    end
    if data.title == nil then
        clay_widget.markup = '?'
        progressbar.value = 0
        return
    end
    progress = data.progress / data.length * 100
    total = string.format('%02d:%02d', math.floor(data.length / 60), data.length % 60)
    progressbar.value = progress
    progressbar.color = color
    clay_widget.markup = '<span color="' .. color ..
        '" size="8000">' .. icon ..
        ' ' ..
        data.artist .. ' - ' .. data.title ..
        ' ' ..
        '[' .. total .. ']' ..
        '</span>'
end

gears.timer {
    timeout=0.5,
    autostart=true,
    callback=update_widget
}

return wibox.widget{
    progressbar,
    clay_widget,
    layout=wibox.layout.stack
}

