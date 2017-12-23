local awful = require('awful')
local wibox = require('wibox')

local spacer_widget = wibox.widget{
    markup='<span color="#535353"> | </span>',
    widget=wibox.widget.textbox
}

return spacer_widget

