local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local utils = require('../utils')

local ICONS = {
    normal = {
        speaker='',
        headphones='',
    },
    muted = {
        speaker='婢',
        headphones='ﳌ',
    },
}

return function(s)
    local volume
    local mute
    local default_sink

    local icon = wibox.widget{
        markup=' ~',
        widget=wibox.widget.textbox
    }

    local volume_widget = wibox.widget{
        widget=wibox.widget.progressbar,
        forced_width=1,
        clip=true,
        max_value=100,
        value=0,
        shape=gears.shape.bar,
        background_color=beautiful.bg_weak,  -- .. '80',
        --color=beautiful.bg_focus,
        color=beautiful.fg_volume_text,  -- .. '80',
        --color=beautiful.fg_normal,
        --color='#7777FF',
        --border_color=beautiful.bg_minimize,
        --border_width=1,
        --ticks=true,
        --ticks_size=2,
        --ticks_gap=1,
        --margins={top=10, bottom=10},
        --forced_width=32
        margins=beautiful.progressbar_margins
    }

    local volume_value = wibox.widget{
        text='~',
        widget=wibox.widget.textbox,
        --visible=false
    }

    local update_widget = function()
        local f = io.popen('pacmd dump')

        if f == nil then
            return false
        end

        local stdout = f:read("*a")
        f:close()

        default_sink = stdout:match('set%-default%-sink (%S+)\n')
        if default_sink == nil then
            return
        end
        volume = stdout:match('set%-sink%-volume ' .. default_sink:gsub('%.', '%%.'):gsub('%-', '%%-') .. ' (%S+)\n')
        volume = tonumber(volume)
        local mute_value = stdout:match('set%-sink%-mute ' .. default_sink:gsub('%.', '%%.'):gsub('%-', '%%-') .. ' (%S+)\n')
        mute = mute_value == 'yes'
        local value = math.floor(volume / 0x10000 * 100)
        --local value = stdout:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%%", "")
        --local n, _ = tonumber(value)

        local icon_group
        if mute then
            icon_group = ICONS['muted']
        else
            icon_group = ICONS['normal']
        end
        if default_sink:match('bluez') then
            icon_str = icon_group.headphones
        else
            icon_str = icon_group.speaker
        end
        local icon_color = beautiful.fg_volume_icon
        local text_color = beautiful.fg_volume_icon
        if mute then
            icon_color = beautiful.fg_volume_muted
            text_color = beautiful.fg_volume_muted
        end
        icon.markup = '<span size="2000"> </span><span color="' .. icon_color .. '" size="'..math.floor(s.panel.height*1000/2)..'">' .. icon_str .. '</span>'
        volume_widget.value = value
        volume_value.markup = '<span color="' .. text_color .. '">' .. value .. '%</span>'
        --widget.markup = '<b><span>  ' .. value .. '</span></b>'
    end

    local modify_volume = function(diff)
        volume = math.floor(volume + diff / 100 * 0x10000)
        awful.spawn.with_line_callback('pacmd set-sink-volume ' .. default_sink .. ' ' .. string.format('0x%x', math.floor(volume)), {})
        local volume_text = math.floor(volume / 0x10000 * 100) -- .. '%'
        --awful.spawn('/home/anderson/.scripts/osd.sh "' .. volume_text .. '"')
        --awful.spawn('/home/anderson/.scripts/not.sh "' .. volume_text .. ' ' .. utf8.char(0xFC58) .. '~'..default_sink..'~0.25"')
        awful.spawn('/home/anderson/.scripts/not.sh \'{"icon_code":'..tostring(0xFC58)..',"timeout":0.25,"message":"' .. tostring(volume_text) .. '","submessage":"' .. default_sink .. '"}\'')

        update_widget()
    end

    local toggle_mute = function()
        -- Using pactl here, not pacmd
        awful.spawn.with_line_callback('pactl set-sink-mute ' .. default_sink .. ' toggle', {})
        update_widget()
    end

    update_widget()

    gears.timer {
        timeout=1,
        autostart=true,
        callback=update_widget
    }

    local widget = utils.make_row{
        wibox.layout.margin(icon, 0, 0, 0, 2),
        wibox.widget{
            volume_widget,
            wibox.container.margin(volume_value, 0, 0, 0, 2),
            layout=wibox.layout.stack
        },
    }

    widget.increase_volume = function() modify_volume(2) end
    widget.decrease_volume = function() modify_volume(-2) end
    widget.toggle_mute = toggle_mute
    widget.modify_volume = modify_volume

    widget:connect_signal('button::press', function(lx, ly, button, mods, find_widgets_result)
        awful.util.spawn('pavucontrol')
    end)

    local tooltip = awful.tooltip({
        objects={widget},
        markup='<span>Loading</span>',
    })
    tooltip:connect_signal('property::visible', function()
        if tooltip:get_visible() then
            awful.spawn.easy_async('pactl list sinks short', function(stdout, stderr, reason, exit_code)
                tooltip:set_markup(stdout)
                --stdout, _ = stdout:gsub('^\n*([^\n]*)\n*$', '%1')
                --local stdout, _ = stdout:gsub('^\n*(.-)[\n ]*$', '%1')
                --local beautiful = require('beautiful')
                --stdout = stdout:gsub('\x1b%[3m', '<span color="' .. beautiful.fg_date_today .. '" bgcolor="' .. beautiful.bg_date_today .. '">')
                --stdout = stdout:gsub('\x1b%[23m', '</span>')
                --tooltip:set_markup('<span size="11000">' .. stdout .. '</span>')
            end)
        end
    end)

    return widget
end
