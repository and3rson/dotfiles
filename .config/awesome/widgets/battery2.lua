local wibox = require('wibox')
local awful = require('awful')

local battery = wibox.widget.base.make_widget()

local status, charge

local TOP = 0.3
local BOTTOM = 0.7
local PIN_WIDTH = 2
local PIN_TOP = 0.4
local PIN_BOTTOM = 0.6

function battery:fit(context, width, height)
    local m = math.min(width, height)
    context.width = m
    context.height = m
    return m, m
end

function battery:draw(context, cr, width, height)
    cr:set_line_width(1)
    cr:set_source_rgb(0.84, 0.29, 0.22)
    cr:move_to(1, context.height * TOP)
    cr:line_to(1, context.height  * BOTTOM)
    cr:line_to(context.width - PIN_WIDTH - 1, context.height * BOTTOM)
    cr:line_to(context.width - PIN_WIDTH - 1, context.height * TOP)
    cr:line_to(1, context.height * TOP)
    cr:stroke()

    local fraction = charge / 100

    cr:move_to(1, context.height * TOP)
    cr:line_to(1, context.height * BOTTOM)
    cr:line_to(context.width * fraction - PIN_WIDTH - 1, context.height * BOTTOM)
    cr:line_to(context.width * fraction - PIN_WIDTH - 1, context.height * TOP)
    cr:line_to(1, context.height * TOP)
    cr:fill()

    cr:move_to(context.width - PIN_WIDTH - 1, context.height * PIN_TOP)
    cr:line_to(context.width - PIN_WIDTH - 1, context.height * PIN_BOTTOM)
    cr:line_to(context.width - 1, context.height * PIN_BOTTOM)
    cr:line_to(context.width - 1, context.height * PIN_TOP)
    cr:line_to(context.width - PIN_WIDTH, context.height * PIN_TOP)
    cr:fill()
end

function update_data(_, stdout, _, _, _)
    status, charge = string.match(stdout, ': ([%w ]+), (%d+%%)')
    charge, _ = charge:gsub("%%", "")
    battery:emit_signal('widget::redraw_needed')
end

awful.widget.watch('acpi -b', 5, update_data)

return battery
