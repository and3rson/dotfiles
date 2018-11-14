-------------------------------------------------
-- @author Gregor Best <farhaven@googlemail.com>
-- @copyright 2009 Gregor Best
-- @release v3.4.11
-------------------------------------------------

-- Grab environment
local ipairs = ipairs
local type = type
local table = table
local math = math
local util = require("awful.util")
local default = require("awful.widget.layout.default")
local margins = awful.widget.layout.margins

local print = print
local assert = assert

--- Horizontal widget layout
module("horizontal")

function center(bounds, widgets, screen)
    print("center-layout")

    local keys = util.table.keys_filter(widgets, "table", "widget")

    local geometries = { }
    local x = 0

    print("Number of widgets:")
    print(#keys)

    assert(#keys == 3)

    -------------------

    center_widget = widgets[keys[2]]

    print("Center widget type:")
    print(type(center_widget))

    assert(type(center_widget) == "widget")

    center_geometry = center_widget:extents(screen)

    center_geometry.height = bounds.height
    center_geometry.x = bounds.width/2-center_geometry.width/2
    center_geometry.y = 0

    -------------------

    left_widget = widgets[keys[1]]

    print("Left widget type:")
    print(type(left_widget))

    left_bounds = {
        x = 0,
        y = 0,
        width = center_geometry.x,
        height = bounds.height
    }

    if type(left_widget) == "table" then
        left_geometries = left_widget.layout(left_bounds, left_widget, screen)

        for _, v in ipairs(left_geometries) do
          table.insert(geometries, v)
        end
    elseif type(left_widget) == "widget" then
        left_geometry = {
            x = 0,
            y = 0,
            width = left_bounds.width,
            height = bounds.height
        }

        print("======")

        table.insert(geometries, left_geometry)
    end

    -------------------

    table.insert(geometries, center_geometry)

    -------------------

    right_widget = widgets[keys[3]]

    print("Right widget type:")
    print(type(right_widget))

    right_offset=center_geometry.x+center_geometry.width

    right_bounds = {
        x = right_offset,
        y = 0,
        width = bounds.width-right_offset,
        height = bounds.height
    }

    if type(right_widget) == "table" then

        right_geometries = right_widget.layout(right_bounds, right_widget, screen)

        for _, v in ipairs(right_geometries) do
          v.x = v.x + right_offset + right_geometries.free.width
          table.insert(geometries, v)
        end
    elseif type(right_widget) == "widget" then
        right_geometry = right_widget:extents(screen)

        right_geometry.x = bounds.width-right_geometry.width
        right_geometry.height = bounds.height

        table.insert(geometries, right_geometry)
    end

    return geometries
end

local function horizontal(direction, bounds, widgets, screen)
    local geometries = { }
    local x = 0

    -- we are only interested in tables and widgets
    local keys = util.table.keys_filter(widgets, "table", "widget")

    for _, k in ipairs(keys) do
        local v = widgets[k]
        if type(v) == "table" then
            local layout = v.layout or default
            if margins[v] then
                bounds.width = bounds.width - (margins[v].left or 0) - (margins[v].right or 0)
                bounds.height = bounds.height - (margins[v].top or 0) - (margins[v].bottom or 0)
            end
            local g = layout(bounds, v, screen)
            if margins[v] then
                x = x + (margins[v].left or 0)
            end
            for _, v in ipairs(g) do
                v.x = v.x + x
                v.y = v.y + (margins[v] and (margins[v].top and margins[v].top or 0) or 0)
                table.insert(geometries, v)
            end
            bounds = g.free
            if margins[v] then
                x = x + g.free.x + (margins[v].right or 0)
                bounds.width = bounds.width - (margins[v].right or 0) - (margins[v].left or 0)
            else
                x = x + g.free.x
            end
        elseif type(v) == "widget" then
            local g
            if v.visible then
                g = v:extents(screen)
                if margins[v] then
                    g.width = g.width + (margins[v].left or 0) + (margins[v].right or 0)
                    g.height = g.height + (margins[v].top or 0) + (margins[v].bottom or 0)
                end
            else
                g = {
                    width  = 0,
                    height = 0,
                }
            end

            if v.resize and g.width > 0 and g.height > 0 then
                local ratio = g.width / g.height
                g.width = math.floor(bounds.height * ratio)
                g.height = bounds.height
            end

            if g.width > bounds.width then
                g.width = bounds.width
            end
            g.height = bounds.height

            if margins[v] then
                g.y = (margins[v].top or 0)
            else
                g.y = 0
            end

            if direction == "leftright" then
                if margins[v] then
                    g.x = x + (margins[v].left or 0)
                else
                    g.x = x
                end
                x = x + g.width
            else
                if margins[v] then
                    g.x = x + bounds.width - g.width + (margins[v].left or 0)
                else
                    g.x = x + bounds.width - g.width
                end
            end
            bounds.width = bounds.width - g.width

            table.insert(geometries, g)
        end
    end

    geometries.free = util.table.clone(bounds)
    geometries.free.x = x
    geometries.free.y = 0

    return geometries
end

function flex(bounds, widgets, screen)
    local geometries = {
        free = util.table.clone(bounds)
    }
    -- the flex layout always uses the complete available place, thus we return
    -- no usable free area
    geometries.free.width = 0

    -- we are only interested in tables and widgets
    local keys = util.table.keys_filter(widgets, "table", "widget")
    local nelements = 0

    for _, k in ipairs(keys) do
        local v = widgets[k]
        if type(v) == "table" then
            nelements = nelements + 1
        elseif type(v) == "widget" then
            local g = v:extents()
            if v.resize and g.width > 0 and g.height > 0 then
                bounds.width = bounds.width - bounds.height
            elseif g.width > 0 and g.height > 0 then
                nelements = nelements + 1
            end
        end
    end

    nelements = (nelements == 0) and 1 or nelements

    local x = 0
    local width = bounds.width / nelements

    for _, k in ipairs(util.table.keys(widgets)) do
        local v = widgets[k]
        if type(v) == "table" then
            local layout = v.layout or default
            local g = layout(bounds, v, screen)
            for _, v in ipairs(g) do
                v.x = v.x + x
                table.insert(geometries, v)
            end
            bounds = g.free
        elseif type(v) == "widget" then
            local g = v:extents(screen)
            g.resize = v.resize

            if v.resize and g.width > 0 and g.height > 0 then
                g.width = bounds.height
                g.height = bounds.height
                g.x = x
                g.y = bounds.y
                x = x + g.width
            elseif g.width > 0 and g.height > 0 then
                g.x = x
                g.y = bounds.y
                g.width = math.floor(width + 0.5)
                g.height = bounds.height
                x = x + width
            else
                g.x = 0
                g.y = 0
                g.width = 0
                g.height = 0
            end

            table.insert(geometries, g)
        end
    end

    return geometries
end

function leftright(...)
    return horizontal("leftright", ...)
end

function rightleft(...)
    return horizontal("rightleft", ...)
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
