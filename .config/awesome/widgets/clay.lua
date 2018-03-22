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
        top=1,
        bottom=14
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
        root_widget.visible = false
        clay_widget.markup = 'Clay not running'
    else
        root_widget.visible = true
        for line in f:lines() do
            content = content .. line
        end
    end
    local data = json.decode(content)
    local color, icon, total, progress
    if data.playing then
        color = '#44FF77'
        --color = beautiful.bg_focus
        icon = ''
        --icon = '▷'
    else
        color = '#FFCC77'
        --color = beautiful.fg_normal
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
    local text = '<span color="' .. color ..
        '">' .. icon ..
        ' ' ..
        data.artist .. ' - ' .. data.title ..
        ' ' ..
        '[' .. total .. ']' ..
        '</span>'
    text = text:gsub('&', '&amp;')
    clay_widget.markup = text
end

gears.timer {
    timeout=0.5,
    autostart=true,
    callback=update_widget
}

root_widget = wibox.widget{
    progressbar,
    clay_widget,
    layout=wibox.layout.stack
}
return root_widget
