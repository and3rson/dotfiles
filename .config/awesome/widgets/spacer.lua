local awful = require('awful')
local wibox = require('wibox')

local spacer_widget = wibox.widget{
    font='Monospace 12',
    markup='<span color="#2D2D2D">│</span>',
    widget=wibox.widget.textbox
}

--return wibox.container.margin(
--    spacer_widget,
--    1, 1, 0, 0
--)
return wibox.container.margin(
    wibox.widget{},
    10, 10, 0, 0
)
