local awful = require('awful')
local wibox = require('wibox')

local exports = {}
exports = {
    getline = function(filename)
        local file = io.open(filename)
        local line = file:read()
        file:close()
        return line
    end,
    notify = function(icon, title, text)
        icon = '/usr/share/icons/elementary/status/48/' .. icon .. '.svg'
        awful.spawn({'notify-send', '-i', icon, title, text, '-a', 'AwesomeWM'})
    end,
    make_row = function(options, spacing)
        local row = wibox.layout.fixed.horizontal()
        if spacing == nil then
            spacing = 6
        end
        row.spacing = spacing
        options.layout = row
        return wibox.widget(options)
    end,
    make_col = function(options)
        local col = wibox.layout.fixed.vertical()
        col.spacing = 0
        options.layout = col
        return wibox.widget(options)
    end,
    dec2hex = function(nValue) -- http://www.indigorose.com/forums/threads/10192-Convert-Hexadecimal-to-Decimal
        if type(nValue) == "string" then
            nValue = String.ToNumber(nValue);
        end
        nHexVal = string.format("%X", nValue);  -- %X returns uppercase hex, %x gives lowercase letters
        sHexVal = nHexVal.."";
        if nValue < 16 then
            return "0"..tostring(sHexVal)
        else
            return sHexVal
        end
    end,
    mix_colors = function(colour1, colour2, value)
        local a1, r1, g1, b1 = string.match(colour1, "#([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])")
        local a2, r2, g2, b2 = string.match(colour2, "#([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])")
        local a3 = math.floor(tonumber(a1, 16) + (tonumber(a2, 16) - tonumber(a1, 16)) * value)
        local r3 = math.floor(tonumber(r1, 16) + (tonumber(r2, 16) - tonumber(r1, 16)) * value)
        local g3 = math.floor(tonumber(g1, 16) + (tonumber(g2, 16) - tonumber(g1, 16)) * value)
        local b3 = math.floor(tonumber(b1, 16) + (tonumber(b2, 16) - tonumber(b1, 16)) * value)
        return "#" .. exports.dec2hex(a3) .. exports.dec2hex(r3) .. exports.dec2hex(g3) .. exports.dec2hex(b3)
    end,
}
return exports
