local awful = require('awful')
local wibox = require('wibox')

return {
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
    make_row = function(options)
        local row = wibox.layout.fixed.horizontal()
        row.spacing = 6
        options.layout = row
        return wibox.widget(options)
    end,
    make_col = function(options)
        local col = wibox.layout.fixed.vertical()
        col.spacing = 0
        options.layout = col
        return wibox.widget(options)
    end,
}
