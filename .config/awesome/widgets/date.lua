--local beautiful = require('beautiful')
local awful = require('awful')
local wibox = require('wibox')
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local gears = require("gears")

local CMD = [[date +"%-d %B%n%H:%M%n%H"]]

local ICONS = {
    day='盛',
    night='望'
}

return function()
    local date_icon = wibox.widget {
        markup='~ ',
        widget=wibox.widget.textbox,
        visible=false
    }

    local clock = wibox.widget.base.make_widget()

    function clock:fit(context, width, height)
        local m = math.min(width, height)
        context.width = m
        context.height = m
        return m, m
    end

    function clock:draw(context, cr, width, height)
        print('a')
        --local nanos = tonumber(os.date('%N')) / 1000000000
        local nanos = os.clock()
        print(nanos)

        cr:set_line_width(1)
        cr:set_source_rgb(0.8, 0.8, 0.8)
        local half = math.floor(context.width / 2)
        --local second_radius = math.floor(half * 0.9)
        local minute_radius = math.floor(half * 0.6)
        local hour_radius = math.floor(half * 0.4)

        --cr:move_to(half, half)
        --local second_progress = tonumber(os.date('%S')) / 60
        --local dx = math.sin(second_progress * math.pi * 2)
        --local dy = math.cos(second_progress * math.pi * 2)
        --cr:line_to(half + second_radius * dx, half - second_radius * dy)
        --cr:stroke()

        cr:move_to(half, half)
        local minute_progress = tonumber(os.date('%M')) / 60
        local dx = math.sin(minute_progress * math.pi * 2)
        local dy = math.cos(minute_progress * math.pi * 2)
        cr:line_to(half + minute_radius * dx, half - minute_radius * dy)
        cr:stroke()

        cr:move_to(half, half)
        local hour_progress = (tonumber(os.date('%H')) + minute_progress) / 12
        local dx = math.sin(hour_progress * math.pi * 2)
        local dy = math.cos(hour_progress * math.pi * 2)
        cr:line_to(half + hour_radius * dx, half - hour_radius * dy)
        cr:stroke()

        gears.shape.transform(gears.shape.rounded_bar):translate(context.width * 0.15, context.width * 0.15)(cr, context.width * 0.7, context.height * 0.7)
        cr:stroke()
    end

    local date_widget = wibox.widget{
        paddings=2,
        markup='~',
        --font=beautiful.pixel_font,
        widget=wibox.widget.textbox
    }

    local date_progressbar = wibox.widget {
        forced_width=10,
        max_value=23,
        value=0,
        background_color=beautiful.bg_weak,
        color=beautiful.fg_date_text,
        widget=wibox.widget.progressbar,
        margins=beautiful.progressbar_margins
        --margins={
        --    top=23
        --}
    }

    local update_widget = function(widget, stdout, _, _, _)
        local icon_name
        local icon_color
        stdout = stdout:gsub('%s+$', '')
        local parts_fn = stdout:gmatch('[^\n]+')
        local date = parts_fn()
        local time = parts_fn()
        local hour = tonumber(parts_fn())
        --local hour = tonumber(os.date('%H'))
        if hour < 6 or hour >= 18 then
            icon_name = 'night'
            --icon_color = '#AAAAFF'
            icon_color = beautiful.fg_date_icon
        else
            icon_name = 'day'
            --icon_color = beautiful.fg_normal
            --icon_color = '#FFFF77'
            icon_color = beautiful.fg_date_icon
        end
        widget[1].markup = '<span size="2000"> </span><span color="' .. icon_color .. '" size="14000">' .. ICONS[icon_name] .. '</span> '
        widget[2].markup = '<span color="' .. beautiful.fg_date_text .. '" size="11000" weight="300">' .. date .. ' ─  <span size="11000" weight="500">' .. time .. '</span></span>'
    end

    -- TODO: Replace with os.date
    -- TODO: Nope. os.date does not return text in Ukrainian for some reason.
    watch(CMD, 1, update_widget, {date_icon, date_widget, date_progressbar})

    --gears.timer{timeout=30, autostart=true, callback=function()
    --    clock:emit_signal('widget::redraw_needed')
    --end}

    --return wibox.container.margin(date_widget, 2, 2, 2, 2)
    local widget = wibox.widget{
        --date_progressbar,
        wibox.widget{
            -- wibox.layout.margin(date_icon, 0, 0, 0, 2),
            --clock,
            wibox.layout.margin(date_widget, 0, 0, 0, 2),
            layout=wibox.layout.fixed.horizontal
        },
        layout=wibox.layout.stack
    }

    --local calendar = awful.widget.calendar_popup.year({position='tr'})
    --calendar:attach(widget, 'tr')
    --awful.widget.calendar.month:attach(widget, 'tr')

    local tooltip = awful.tooltip({
        objects={widget},
        markup='<span>Loading</span>',
    })

    tooltip:connect_signal('property::visible', function()
        if tooltip:get_visible() then
            awful.spawn.easy_async('cal -n 3 --color=always', function(stdout, stderr, reason, exit_code)
                --stdout, _ = stdout:gsub('^\n*([^\n]*)\n*$', '%1')
                local stdout, _ = stdout:gsub('^\n*(.-)[\n ]*$', '%1')
                local beautiful = require('beautiful')
                stdout = stdout:gsub('\x1b%[3m', '<span color="' .. beautiful.fg_date_today .. '" bgcolor="' .. beautiful.bg_date_today .. '">')
                stdout = stdout:gsub('\x1b%[23m', '</span>')
                tooltip:set_markup('<span size="11000">' .. stdout .. '</span>')
            end)
        end
    end)

    return widget
end
