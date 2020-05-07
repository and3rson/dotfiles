local awful = require('awful')
local wibox = require('wibox')
local gears = require("gears")
local beautiful = require('beautiful')
local json = require("json")
local inotify = require("inotify")
local md5 = require("md5")
local utils = require("utils")
local color = require("utils.color")
local gfs = require("gears.filesystem")

local FILE = os.getenv('HOME') .. '/.config/Google Play Music Desktop Player/json_store/playback.json'
local CAVA_CONF = os.getenv('HOME') .. '/.config/cava/config.awesome'
local AART_DIR = gfs.get_xdg_cache_home() .. 'aart/'

awful.spawn(string.format('mkdir -p %s', AART_DIR))

local widget

local graph = wibox.widget {
    max_value = 32,
    color = beautiful.fg_mem_graph .. '80',
    background_color = '#00000000',
    --color = '#7777FF',
    --background_color = "#1e252c",
    --border_width = 1,
    --border_color = beautiful.fg_mem,
    forced_width = 279,
    forced_height = 24,
    step_width = 6,
    step_spacing = 1,
    widget = wibox.widget.graph
}
local graph_flipped = wibox.container.margin(wibox.container.mirror(graph, { horizontal = true }), 0, 1, 0, 0)

local progressbar = wibox.widget {
    forced_width=10,
    max_value=100,
    value=0,
    background_color=beautiful.bg_weak,
    color=beautiful.bg_focus,
    widget=wibox.widget.progressbar,
    margins=beautiful.progressbar_margins
}

local gpmdp_widget = wibox.widget {
    markup='~',
    widget=wibox.widget.textbox
}

local prev_track = nil
local last_id = nil

local update_widget = function()
    local content = ''
    if gears.filesystem.file_readable(FILE) then
        for line in io.lines(FILE) do
            content = content .. line
        end
    else
        -- content = '{"playing": false, "song": {"artist": "None", "title": "None"}}'
        gpmdp_widget.markup = ' <span color="' .. beautiful.fg_gpmdp_paused .. '"> GMPDP not running.</span>'
        return
    end
    local data = json.decode(content)
    local color, icon, current, total, progress
    if data.playing then
        color = beautiful.fg_gpmdp_playing
        icon = ''
        --icon = '▷'
    else
        color = beautiful.fg_gpmdp_paused
        icon = ''
        --icon = '◫'
    end
    if data.song.title == nil then
        widget.visible = false
        gpmdp_widget.markup = '?'
        progressbar.value = 0
        return
    else
        widget.visible = true
    end
    local this_track = (data.song.artist .. ' - ' .. data.song.title)
    if this_track ~= prev_track then
        local args = '-p -t 1500'
        if last_id ~= nil then
            args = args .. ' -r ' .. tostring(last_id)
        end
        local aart_url = data.song.albumArt:gmatch('(.*)?')()
        local aart_file = nil
        if aart_url ~= nil then
            local hash = md5.sumhexa(aart_url)
            aart_file = AART_DIR .. hash .. '.jpg'
            args = args .. ' -i ' .. aart_file
        end
        local notify = function()
            --awful.spawn(string.format('feh --bg-scale "%s"', aart_file))
            awful.spawn.easy_async(string.format('dunstify "%s" "%s" %s', data.song.title, data.song.artist, args), function(stdout, stderr, reason, exit_code)
            -- args=''
            -- awful.spawn.easy_async(string.format('notify-send "%s" "%s" %s', data.song.title, data.song.artist, args), function(stdout, stderr, reason, exit_code)
                last_id = stdout:gsub("^%s*(.-)%s*$", "%1")
                --last_id = stdout
            end)
        end
        if aart_file and gfs.file_readable(aart_file) then
            notify()
        else
            awful.spawn.easy_async(string.format('wget "%s" -O %s', data.song.albumArt, aart_file), function(stdout, stderr, reason, exit_code)
                notify()
            end)
        end
    end
    prev_track = this_track
    progress = data.time.current / data.time.total * 100
    --current = math.floor(data.time.current / 1000)
    total = math.floor(data.time.total / 1000)
    --current = string.format('%02d:%02d', math.floor(current / 60), current % 60)
    total = string.format('%02d:%02d', math.floor(total / 60), total % 60)
    progressbar.value = progress
    progressbar.color = color

    local max_len = 48
    local caption = this_track
    if string.len(this_track) > max_len then
        caption = string.sub(this_track, 0, utf8.offset(this_track, max_len - 3)) .. '...'
    end
    caption = caption:gsub('&', '&amp;')
    gpmdp_widget.markup = ' <span color="' .. color ..
        '">' .. icon ..
        ' ' ..
        caption ..
        -- '<span size="8000">' .. caption .. '</span>' ..
        ' ' ..
        '[' .. total .. ']' ..
        '</span> '
end

awful.spawn.with_line_callback('cava -p ' .. CAVA_CONF, {
    stdout=function(line)
        local i = 0
        local total = 0
        local max = 0
        for v in line:gmatch('%d+') do
            if i % 1 == 0 then
                v = tonumber(v)
                max = math.max(max, v)
                total = total + v
                --v = ((v / 32) ^ 0.5) * 32
                graph:add_value(v)
            end
            i = i + 1
        end
        --print(
        --print(i, total / i, max)
        if max == 32 then
            graph.color = beautiful.fg_mem_graph .. 'FF'
        else
            graph.color = beautiful.fg_mem_graph .. '80'
        end
        local avg = total / i
        graph.color = beautiful.fg_mem_graph .. string.format('%02x', math.floor((avg / 64 + 0.5) * 255))
        local r, g, b = color.hslToRgb((avg / 32 * 2.0) % 1.0, 1.0, 0.5, 1.0)
        graph.color = '#' .. string.format('%02x%02x%02x%02x', math.floor(r), math.floor(g), math.floor(b), math.floor((avg / 64 + 0.5) * 255))
    end
})

local inot, errno, errstr
function poll()
    local events, nread, errno, errstr = inot:read()
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
    timeout=0.25,
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
local underlay = wibox.widget{
    graph_flipped,
    --wibox.container.margin(graph_flipped, 0, 0, 0, 12),
    --wibox.container.mirror(wibox.container.margin(graph_flipped, 0, 0, 0, 12), {vertical=true}),
    layout=wibox.layout.stack
}
widget = utils.make_row{
    wibox.widget{
        wibox.container.place(underlay),
        progressbar,
        gpmdp_widget,
        layout=wibox.layout.stack
    }
}
return widget
