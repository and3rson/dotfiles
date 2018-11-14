local wibox = require('wibox')
local beautiful = require('beautiful')
local gears = require('gears')

local taglistline = {mt={}}

local last_pos = 0

function taglistline:fit(_, width, height)
    local count = 0
    for _, _ in pairs(self.screen.tags) do count = count + 1 end
    --local m = math.min(width, height)
    --return m, m
    return count * (height + self.margin * 2), height
end

function taglistline:draw(_, cr, width, height)
    local count = 0
    for _, _ in pairs(self.screen.tags) do count = count + 1 end
    local tag_width = width / count
    cr:set_source(gears.color(beautiful.fg_bright))
    for index, tag in pairs(self.screen.tags) do
        if tag.selected then
            local start = (index - 1) * tag_width
            start = tonumber(string.format('%.1f', (start + last_pos) / 2))
            if start == last_pos then
                if self.t.started then self.t:stop() end
            else
                if not self.t.started then self.t:start() end
                last_pos = start
            end
            cr:rectangle(start, 0, tag_width, height)
        end
    end
    cr:fill()
    for index, tag in pairs(self.screen.tags) do
        local icon = self.tag_icons[tag.name].nonempty
        local client_count = 0
        for _, _ in pairs(tag:clients()) do client_count = client_count + 1 end
        --if next(tag:clients()) == nil then
        --    icon = self.tag_icons[tag.name].empty
        --end
        if client_count == 0 then
            icon = self.tag_icons[tag.name].empty
        end
        cr:set_source_surface(icon, (index - 1) * tag_width + self.margin, 0)
        cr:paint()
        cr:set_source(gears.color('#FFFFFF'))
        cr:set_line_width(2)
        for i=1,client_count,1 do
            local center = (index - 1) * tag_width + (tag_width + self.margin - 1) / 2
            local left = center - ((client_count - 1) / 2) * 4 + ((i - 1) * 4)
            cr:move_to(left, 0)
            cr:line_to(left, 3)
            cr:stroke()
        end
    end
end

function taglistline:request_redraw(_)
    self:emit_signal('widget::redraw_needed')
end

function taglistline.mt:__call(s, margin)
    local widget = wibox.widget.base.make_widget()

    gears.table.crush(widget, taglistline, true)

    widget.screen = screen[s]
    widget.margin = margin or 0
    widget.tag_icons = {}
    for _, tag in pairs(widget.screen.tags) do
        widget.tag_icons[tag.name] = {
            nonempty=gears.surface.load('/home/anderson/.icons/tags/' .. tag.name:lower() .. '.png'),
            empty=gears.surface.load('/home/anderson/.icons/tags/' .. tag.name:lower() .. '_empty.png')
        }
    end

    widget.t = gears.timer{
        timeout=0.02,
        autostart=false,
        callback=function()
            widget:emit_signal('widget::redraw_needed')
        end
    }

    widget.screen:connect_signal("tag::history::update", function() widget:request_redraw() end)
    for _, tag in pairs(widget.screen.tags) do
        tag:connect_signal("tagged", function() widget:request_redraw() end)
        tag:connect_signal("untagged", function() widget:request_redraw() end)
    end

    return widget
end

return setmetatable(taglistline, taglistline.mt)
--return widget
