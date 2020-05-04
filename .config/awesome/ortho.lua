local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')

local groups = {
    nav={
        color='#001122'
    },
    num={
        color='#002211'
    },
    ascii={
        color='#111111'
    },
    mod={
        color='#220011'
    },
    action={
        color='#221100'
    },
    char={
        color='#220022'
    }
}

local def_rows = {
    {
        {c='grave', n='`', n2='~', g='action'},
        {c='1', n2='!', g='num'},
        {c='2', n2='@', g='num'},
        {c='3', n2='#', g='num'},
        {c='4', n2='$', g='num'},
        {c='5', n2='%', g='num'},
        {c='6', n2='^', g='num'},
        {c='7', n2='&', g='num'},
        {c='8', n2='*', g='num'},
        {c='9', n2='(', g='num'},
        {c='0', n2=')', g='num'},
        {c='minus', n='-', n2='-', g='num'},
        {c='equal', n='=', n2='=', g='num'},
        {c='BackSpace', n='', z=100, g='action'}
    },
    {
        {c='Tab', n='', z=150, g='action'},
        'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',
        {c='bracketleft', n='[', n2='{', g='char'},
        {c='bracketright', n=']', n2=']', g='char'},
        {c='backslash', n='\\', n2='|', g='char'}
    },
    {
        {c='Escape', n='Esc', g='action'},
        'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L',
        {c='semicolon', n=';', s='colon', n2=':', g='char'},
        {c='apostrophe', n='\'', n2='"', g='char'},
        {c='Return', n='', z=150, g='action', j=2}
    },
    {
        {c='Shift', n='וּ', t=true, z=150, g='mod'},
        'Z', 'X', 'C', 'V', 'B', 'N', 'M',
        {c='comma', n=',', n2='&lt;', g='char'},
        {c='period', n='.', n2='&gt;', g='char'},
        {c='slash', n='/', n2='?', g='char'},
        {c='Page_Up', n='', z=125, g='nav'},
        {c='Up', n='ﰵ', g='nav'},
        {c='Page_Down', n='', z=125, g='nav'}
    },
    {
        {c='Control', n='CONTROL', z=60, t=true, g='mod'},
        {c='Alt', n='ALT', z=60, t=true, g='mod'},
        {c='Super', n='SUPER', z=60, t=true, g='mod'},
        {c='FKey', n='FX', z=60, t=true, g='mod'},
        {c='XF86AudioLowerVolume', n='ﱜ', z=150, g='action'},
        {c='XF86AudioRaiseVolume', n='ﱛ', z=150, g='action'},
        {c='space', n='␣', z=150, j=2},
        {c='Delete', n='DEL', z=150, g='action', z=60},
        {c='Home', n='', z=150, g='nav'},
        {c='End', n='', z=150, g='nav'},
        {c='Left', n='ﰯ', g='nav'},
        {c='Down', n='ﰬ', g='nav'},
        {c='Right', n='ﰲ', g='nav'}
    }
}

for y, def_row in pairs(def_rows) do
    for x, def in pairs(def_row) do
        if type(def) == 'string' then
            def = {c=def, n=def, g='ascii'}
        end
        if def.n == nil then
            def.n = def.c
        end
        if def.z == nil then
            def.z = 100
        end
        if #def.c == 1 then
            def.c = def.c:lower()
        end
        def_rows[y][x] = def
        def.pressed = false
    end
end

function create_button(s, def)
    local workarea = s.workarea
    local text = wibox.widget.textbox('a')
    text.align = 'center'
    text.font = 'RobotoMono Nerd Font Light'
    local bg = wibox.container.background(text, '#00000000')
    bg.def = def
    bg.shape = gears.shape.rectangle
    bg.shape_border_color = '#222222'
    bg.shape_border_width = 1
    local text2 = wibox.widget.textbox('')
    text2.align = 'right'
    text2.valign = 'top'
    local stack = wibox.widget{layout=wibox.layout.stack, bg, wibox.container.margin(text2, workarea.width / 12 / 4, workarea.width / 12 / 4, 12, 12)}
    local button = stack

    button.text = ''
    button.text2 = ''
    button.color = '#FFFFFFFF'
    button.bgcolor = '#00000000'
    button.initial_bgcolor = '#00000000'
    if def.g then
        button.bgcolor = groups[def.g]
        button.initial_bgcolor = groups[def.g]
    end

    function button:update()
        text.markup = '<span size="' .. math.floor(32000 / 100 * def.z) .. '" color="' .. self.color .. '">' .. self.text .. '</span>'
        text2.markup = '<span size="' .. math.floor(16000) .. '" color="' .. self.color .. '">' .. self.text2 .. '</span>'
        bg.bg = self.bgcolor
    end

    function button:activate()
        self.bgcolor = '#777777FF'
        self:update()
    end
    function button:deactivate()
        self.bgcolor = button.initial_bgcolor
        self:update()
    end
    function button:set_text(s)
        self.text = s
        self:update()
    end
    function button:set_text2(s)
        self.text2 = s
        self:update()
    end
    button:set_text(def.n)
    if def.n2 then
        button:set_text2(def.n2)
    end
    return stack
end

return function(s)
    local workarea = s.workarea
    local ortho = awful.wibar({
        position="bottom",
        screen=s,
        ontop=true,
        --bg='#00000000',
        height=workarea.height * 0.4,
        stretch=true,
        visible=false
    })
    ortho:setup{
        layout=wibox.layout.grid,
        id='grid',
        expand=true
    }
    ortho.toggle = function()
        ortho.visible = not ortho.visible
    end

    -- button:connect_signal('button::press', function()
    --     if def.t then
    --     end
    -- end)
    -- button:connect_signal('button::release', function()
    --     if def.t then
    --     end
    -- end)

    local mods = {Control=nil, Alt=nil, Shift=nil, Super=nil, FKey=nil}
    -- mods.activate = function(mod)
    --     if mods[mod] == nil then
    --     end
    -- end
    -- mods.deactivate = function(mod)
    --     if mods[mod] ~= nil then
    --     end
    -- end

    function press(code)
        awful.spawn('xdotool keydown ' .. code)
        -- show_popup{icon='', text=code, text2='', timeout=0.2}
    end

    function release(code)
        awful.spawn('xdotool keyup ' .. code)
    end

    for y, def_row in pairs(def_rows) do
        local offset = 0
        for x, def in pairs(def_row) do
            x = x + offset
            local button = create_button(s, def)
            ortho.grid:add_widget_at(button, y, x, 1, def.j or 1)
            offset = offset + (def.j or 1) - 1

            function button_press()
                def.pressed = true
                if def.t then
                    if mods[def.c] == nil then
                        mods[def.c] = button
                        button:activate()
                        press(def.c)
                    else
                        button:deactivate()
                        release(def.c)
                        mods[def.c] = nil
                    end
                else
                    local code = def.c
                    if mods.FKey then
                        code = 'F' .. code
                    elseif mods.Shift and def.s then
                        code = def.s
                    end
                    press(code)
                    button:activate()
                end
            end

            function button_release()
                if not def.pressed then
                    return
                end
                def.pressed = false
                if def.t then
                    -- mods[def.c] = nil
                else
                    button:deactivate()

                    local code = def.c
                    if mods.FKey then
                        code = 'F' .. code
                    elseif mods.Shift and def.s then
                        code = def.s
                    end
                    release(code)

                    for c, other in pairs(mods) do
                        if other ~= nil then
                            other:deactivate()
                            release(c)
                            mods[c] = nil
                        end
                    end
                end
            end

            button:connect_signal('button::press', button_press)
            button:connect_signal('button::release', button_release)
            button:connect_signal('mouse::leave', button_release)
        end
    end

    return ortho
end
