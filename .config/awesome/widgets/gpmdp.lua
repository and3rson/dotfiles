local wibox = require('wibox')
local gears = require("gears");
local beautiful = require('beautiful')
local json = require("json");
local inotify = require("inotify");

local FILE = os.getenv('HOME') .. '/.config/Google Play Music Desktop Player/json_store/playback.json'
print(FILE)

local progressbar = wibox.widget {
    forced_width=10,
    max_value=100,
    value=0,
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
    for line in io.lines(FILE) do
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
    if data.song.title == nil then
        gpmdp_widget.markup = '?'
        progressbar.value = 0
        return
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

local inot, errno, errstr
function poll()
    print(inot)
    local events, nread, errno, errstr = inot:read()
    print(events)
    if events then
        for i, event in ipairs(events) do
            for k, v in pairs(event) do
                if event.mask & inotify.IN_CLOSE then
                    update_widget()
                    --print('close', event.mask)
                end
            end
        end
    end
end

gears.timer {
    timeout=0.2,
    autostart=true,
    callback=update_widget
}
--inot, errno, errstr = inotify.init(false)
--if errno ~= nil then
--    print(errno, errstr)
--end
--inot:addwatch(FILE, inotify.IN_CLOSE)
--gears.timer {
--    timeout=0.2,
--    autostart=true,
--    callback=poll
--}
--watch(CMD, 1, update_widget, gpmdp_widget)

--return wibox.container.margin(gpmdp_widget, 2, 2, 2, 2)
return wibox.widget{
    progressbar,
    gpmdp_widget,
    layout=wibox.layout.stack
}

