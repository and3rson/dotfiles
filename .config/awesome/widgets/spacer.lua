local awful = require('awful')
local wibox = require('wibox')

--local spacer_widget = wibox.widget{
--    font='Monospace 12',
--    markup='<span color="#2D2D2D"> │ </span>',
--    widget=wibox.widget.textbox
--}

--return spacer_widget

--return wibox.container.margin(
--    spacer_widget,
--    1, 1, 0, 0
--)
return function()
    if awesome.hostname == 'vinga' then
        return wibox.container.margin(
            wibox.widget{},
            8, 8, 0, 0,
            'FF0000'
        )
    else
        return wibox.container.margin(
            wibox.widget{},
            12, 12, 0, 0,
            'FF0000'
        )
    end
end
