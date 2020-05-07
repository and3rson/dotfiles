local wibox = require('wibox')
local watch = require("awful.widget.watch")
local awful = require('awful')
local beautiful = require("beautiful")
local gears = require("gears")
local utils = require("../utils")

local MQTT_HOST = 'dun.ai'
local MQTT_PORT = 1983
-- local MQTT_USER = os.getenv('MQTT_USER')
-- local MQTT_PASS = os.getenv('MQTT_PASS')
local MQTT_USER = 'anderson'
local MQTT_PASS = '11235813'

local CMD = string.format('mosquitto_sub -t "devices/#" -h "%s" -p %d -u "%s" -P "%s" -v', MQTT_HOST, MQTT_PORT, MQTT_USER, MQTT_PASS)

local ICON = '泌'

return function(s)
    local icon_widget = wibox.widget({
        paddings=2,
        markup=ICON,
        color=beautiful.fg_ping_icon,
        widget=wibox.widget.textbox
    })

    local text_widget = wibox.widget({
        paddings=2,
        markup='loading',
        --forced_width=42,
        align='left',
        widget=wibox.widget.textbox
    })

    local widget

    -- local update_widget = function(_, essid)
    --     essid = string.gsub(essid, '^%s*(.-)%s*$', '%1')
    --     local color = beautiful.fg_ping_icon
    --     if string.len(essid) == 0 then
    --         color = beautiful.fg_ping_warning
    --         essid = 'Offline'
    --     end
    --     -- local net_info = net_linux()
    --     -- local tx_b = math.floor(tonumber(net_info[string.format('{%s tx_mb}', DEVICE)]))
    --     -- local rx_b = math.floor(tonumber(net_info[string.format('{%s rx_mb}', DEVICE)]))
    --     icon_widget.markup = '<span color="' .. color .. '" size="'..math.floor((s.panel.height+4)*1000/2)..'"></span>'
    --     row1_widget.markup = '<span color="' .. color .. '">' .. essid .. '</span>'
    --     -- row2_widget.markup = string.format('  %dM  %dM', rx_b, tx_b)
    -- end

    local devices = {}
    awful.spawn.with_line_callback(
        CMD,
        {
            stdout=function(line)
                local sep1 = line:find('/')
                local sep2 = line:find(' ')
                local device = line:sub(sep1 + 1, sep2)
                local value = line:sub(sep2 + 1)
                local on_air = false
                if value == 'ON AIR' then
                    on_air = true
                end
                devices[device] = on_air

                local count = 0
                local on_air_count = 0
                for device, on_air in pairs(devices) do
                    count = count + 1
                    if on_air then
                        on_air_count = on_air_count + 1
                    end
                end
                local color = beautiful.fg_mqtt_ok
                if count ~= on_air_count then
                    color = beautiful.fg_mqtt_warning
                end
                icon_widget.markup = string.format('<span color="%s">%s</span>', color, ICON)
                text_widget.markup = string.format('<span color="%s">%d/%d on air</span>', color, on_air_count, count)
            end
        }
    )

    widget = utils.make_row({
        wibox.container.margin(icon_widget, 0, 0, 0, 2),
        text_widget
    })

    local tooltip = awful.tooltip({
        objects={widget},
        markup='<span>Loading</span>',
        timer_function=function()
            local text = ''
            for device, on_air in pairs(devices) do
                local label = 'On Air'
                if not on_air then
                    label = 'OFFLINE'
                end
                local color = beautiful.fg_mqtt_ok
                if not on_air then
                    color = beautiful.fg_mqtt_warning
                end
                text = text .. string.format('%s: <span color="%s">%s</span>\n', device, color, label)
            end
            return '<span size="11000">' .. text .. '</span>'
        end
    })

    -- tooltip:connect_signal('property::visible', function()
    --     if tooltip:get_visible() then
    --         local text = ''
    --         for device, on_air in pairs(devices) do
    --             local label = 'On Air'
    --             if not on_air then
    --                 label = 'OFFLINE'
    --             end
    --             local color = beautiful.fg_mqtt_ok
    --             if not on_air then
    --                 color = beautiful.fg_mqtt_warning
    --             end
    --             text = text .. string.format('%s: <span color="%s">%s</span>\n', device, color, label)
    --         end
    --         tooltip:set_markup('<span size="11000">' .. text .. '</span>')
    --     end
    -- end)


    return widget
end
