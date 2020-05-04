local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')

local headsup = awful.popup{
    widget={
        widget=wibox.container.margin,
        top=64,
        {
            widget=wibox.container.background,
            id='bg',
            bg='#222222CC',
            {
                widget=wibox.container.margin,
                id='margin',
                left=32,
                right=32,
                top=10,
                bottom=10,
                {
                    widget=wibox.layout.align.horizontal,
                    id='layout_h',
                    {
                        widget=wibox.container.margin,
                        id='margin',
                        -- left=16,
                        right=32,
                        {
                            widget=wibox.widget.textbox,
                            id='icon',
                            text='Icon',
                            font='DejaVu Sans 80'
                        }
                    },
                    {
                        widget=wibox.layout.align.vertical,
                        id='layout_v',
                        spacing=0,
                        {
                            widget=wibox.widget.textbox,
                            id='textbox',
                            text='Foo bar askj lk adjkajdk aslkd aj lk asjdsa\nasdasd\nasd',
                            font='DejaVu Sans 48'
                        },
                        {
                            widget=wibox.widget.textbox,
                            id='textbox2',
                            text='Foo bar askj lk adjkajdk aslkd aj lk asjdsa\nasdasd\nasd',
                            font='DejaVu Sans 24'
                        }
                    }
                }
            }
        }
    },
    -- placement=awful.placement.top + awful.placement.centered_horizontal,
    placement=awful.placement.centered,
    ontop=true,
    visible=false,
    bg='#00000000',
    -- border_color='#FF0000',
    -- border_width=30
}
local headsup_timer = gears.timer{
    timeout=1,
    autostart=false,
    call_now=false,
    callback=function()
        headsup.visible = false
    end
}
function show_headsup(opts)
    local timeout = opts.timeout
    if timeout == nil then
        timeout = 1
    end
    headsup_timer.timeout = timeout
    headsup_timer:again()
    headsup.visible = true
    headsup.widget.bg.margin.layout_h.layout_v.textbox.text = opts.text
    if opts.text2 ~= nil then
        headsup.widget.bg.margin.layout_h.layout_v.textbox2.visible = true
        headsup.widget.bg.margin.layout_h.layout_v.textbox2.text = opts.text2
        headsup.widget.bg.margin.layout_h.forced_height = nil
    else
        headsup.widget.bg.margin.layout_h.layout_v.textbox2.visible = false
        headsup.widget.bg.margin.layout_h.layout_v.textbox2.text = ''
        headsup.widget.bg.margin.layout_h.forced_height = 64
        -- print(headsup.widget.bg.margin.layout_h.layout_v.textbox2)
    end
    if opts.icon ~= nil then
        headsup.widget.bg.margin.layout_h.margin.icon.visible = true
        headsup.widget.bg.margin.layout_h.margin.icon.text = opts.icon
    else
        headsup.widget.bg.margin.layout_h.margin.icon.visible = false
    end
end
return headsup
