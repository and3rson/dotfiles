local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local utils = require('../utils')

local ICONS = {
    speaker='',
    headphones=''
}

return function()
    local volume
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
        --margins=beautiful.progressbar_margins
        margins={
            bottom=22,
            --top=7,
            --bottom=6
        }
    }

    local volume_value = wibox.widget{
        text='~',
        widget=wibox.widget.textbox
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
        local value = math.floor(volume / 0x10000 * 100)
        --local value = stdout:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%%", "")
        --local n, _ = tonumber(value)
        if default_sink:match('bluez') then
            icon_str = ICONS.headphones
        else
            icon_str = ICONS.speaker
        end
        icon.markup = '<span size="2000"> </span><span color="' .. beautiful.fg_volume_icon .. '" size="12000">' .. icon_str .. '</span>'
        volume_widget.value = value
        volume_value.markup = '<span color="' .. beautiful.fg_volume_text.. '">' .. value .. '%</span>'
        --widget.markup = '<b><span>  ' .. value .. '</span></b>'
    end

    local modify_volume = function(diff)
        volume = math.floor(volume + diff / 100 * 0x10000)
        awful.spawn.with_line_callback('pacmd set-sink-volume ' .. default_sink .. ' ' .. string.format('0x%x', math.floor(volume)), {})
        update_widget()
    end

    update_widget()

    --gears.timer {
    --    timeout=1,
    --    autostart=true,
    --    callback=update_widget
    --}

    local widget = utils.make_row{
        wibox.layout.margin(icon, 0, 0, 0, 2),
        wibox.widget{
            --volume_widget,
            wibox.container.margin(volume_value, 0, 0, 0, 2),
            layout=wibox.layout.stack
        },
    }

    widget.increase_volume = function() modify_volume(2) end
    widget.decrease_volume = function() modify_volume(-2) end

    widget:connect_signal('button::press', function(lx, ly, button, mods, find_widgets_result)
        awful.util.spawn('pavucontrol')
    end)

    return widget
end
