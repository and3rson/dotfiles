# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.layout.columns import Columns
from libqtile.layout.tree import TreeTab
from libqtile.log_utils import logger
import commands
import widgets
# from powerline.bindings.qtile.widget import PowerlineTextBox

ctrl = 'control'
alt = 'mod1'
mod = "mod4"

keys = [
    # Switch between windows in current stack pane
    Key(
        [mod], "Down",
        lazy.layout.down()
    ),
    Key(
        [mod], "Up",
        lazy.layout.up()
    ),
    Key(
        [mod], "Left",
        lazy.layout.left()
    ),
    Key(
        [mod], "Right",
        lazy.layout.right()
    ),

    # Switch window focus to other pane(s) of stack
    Key(
        [mod], "space",
        lazy.layout.next()
    ),

    # Swap panes of split stack
    Key(
        [mod, "shift"], "space",
        lazy.layout.rotate()
    ),

    # Move between groups
    Key(
        [mod], "Page_Up",
        lazy.screen.prev_group()
    ),
    Key(
        [mod], "Page_Down",
        lazy.screen.next_group()
    ),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
#    Key(
#        [mod, "shift"], "Return",
#        lazy.layout.toggle_split()
#    ),
    Key([mod], "Return", lazy.spawn("sakura -e stmux")),

    # Toggle between different layouts as defined below
    Key([mod], "z", lazy.next_layout()),
    Key([alt], "F4", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),

    Key([mod], "c", lazy.spawn('sakura -e "nano /home/anderson/.config/qtile/config.py"')),
    Key([mod], "Print", lazy.spawn('/sh/sshot.py')),

    Key([], 'F12', lazy.function(commands.ToggleTerm())),

    Key([], 'XF86AudioRaiseVolume', lazy.spawn('amixer -q sset Master 4%+')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('amixer -q sset Master 4%-')),
    Key([], 'XF86AudioMute', lazy.spawn('amixer -q sset Master toggle')),

    Key([], 'XF86MonBrightnessUp', lazy.spawn('xbacklight -inc 10')),
    Key([], 'XF86MonBrightnessDown', lazy.spawn('xbacklight -dec 10')),

    Key([ctrl, alt], "l", lazy.spawn("/sh/i3lock.sh")),
    Key([ctrl, mod], "g", lazy.function(commands.FixGroups()))
]

GROUP_DEFS = (
    ('t', 'term', ['sakura -e stmux'], 'max', dict(wm_class=['Sakura'])),
    ('w', 'web', ['chromium', 'firefox'], 'max', dict(wm_class=['chromium', 'Firefox'])),
    ('i', 'im', ['telegram-desktop', 'slack', 'messengerfordesktop'], 'treetab', dict(wm_class=['telegram-desktop', 'TelegramDesktop', 'Slack'], title=['Messenger'])),
    ('m', 'mail', ['thunderbird'], 'columns', dict(wm_class=['Thunderbird'])),
    ('d', 'dev', ['subl3'], 'columns', dict(wm_class=['Subl3'])),
    ('a', 'audio', ['vkplayer'], 'columns', dict(title=['VK audio player'])),
    ('g', 'games', [], 'columns', dict()),
    ('v', 'var', [], 'columns', dict()),
)

groups = [
    Group('{name}'.format(id=i + 1, name=g_name), spawn=g_startup, layout=g_layout, matches=[Match(**g_match_kwargs)])
    for i, (g_hotkey, g_name, g_startup, g_layout, g_match_kwargs)
    in enumerate(GROUP_DEFS)
]

#    # mod1 + shift + letter of group = switch to & move focused window to group
for g_hotkey, g_name, g_startup, g_layout, g_match_kwargs in GROUP_DEFS:
    keys.append(
        Key([mod], g_hotkey, lazy.group[g_name].toscreen())
    )

layouts = [
    Columns(),
    # layout.Stack(num_stacks=2),
    layout.Max(),
    TreeTab(
        bg_color='#000000',
        active_bg='#F05040',
        active_fg='#FFFFFF',
        font='DejaVu Sans',
        inactive_bg='#000000',
        inactive_fg='#FFFFFF',
        fontsize=12,
        panel_width=160,
        margin_left=0,
        padding_left=0,
        border_width=0,
        padding_x=5,
        padding_y=5,
        sections=['Default'],
        section_fontsize=0,
        section_top=0,
        section_padding=0
    )
]

widget_defaults = dict(
    # font='FuraCode Nerd Font Medium',
    font='Roboto Medium',
    fontsize=12,
    padding=5,
)

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    background='#000000',
                    borderwidth=0, disable_drag=True,
                    inactive='#888888', highlight_method='block',
                    rounded=False, highlight_color=['#FF1177', '#FF1177'],
                    this_screen_border='#00FF00', this_current_screen_border='#F05040',
                    font='Roboto Sans Bold'
                ),
                widget.Sep(padding=5),
                widget.Prompt(background='#F05040', font='DejaVu Sans Mono Bold', fontsize=12),
                # PowerlineTextBox(),
                widget.TaskList(rounded=False, max_title_width=120, highlight_method='block', border='#F05040'),
                # widget.TextBox("default config", name="default"),
                widget.Systray(),
                # widget.LaunchBar([('firefox', 'firefox')]),
                widget.Sep(padding=5),
                widget.Battery(charge_char='+', discharge_char='-', foreground='#5090F0'),
                widget.Sep(padding=5),
                # widget.CPUGraph(border_color='#000000', samples=50, frequency=0.1, line_width=2, type='line'),
                # widget.BatteryIcon(),
                # widget.Backlight(),
                # widget.Clipboard(),
                widget.ThermalSensor(),
                # widget.Notify(),
                # widget.Pacman(),
                # widget.DF(),
                # widget.Sep(padding=5),
                # widget.KeyboardLayout(configured_keyboards=['us', 'ru', 'ua']),
                widgets.KBLayout(),
                widget.Volume(),  # theme_path='/usr/share/icons/Faenza/status/64/'),
                widget.Sep(padding=5),
                widgets.OpenWeatherMap(appid='5041ca48d55a6669fe8b41ad1a8af753', location='Lviv, Ukraine'),
                widget.Sep(padding=5),
                widgets.NowPlayingWidget(foreground='#F0F040'),
                #widget.KeyboardKbdd(),
                # widget.Mpris(),
                widget.Sep(padding=5),
                # widgets.RSS(),
                widgets.Ping(),
                # widget.Sep(padding=5),
                # widgets.TestWidget(),
                widget.Sep(padding=5),
                widget.CurrentLayout(),
                widget.Sep(padding=5),
                widget.Clock(format='%Y-%m-%d %H:%M'),
            ],
            28
            # background='#222222'
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]


@hook.subscribe.client_new
def floating_dialogs(window):
    dialog = window.window.get_wm_type() == 'dialog'
    transient = window.window.get_wm_transient_for()
    if dialog or transient:
        window.floating = True
        window.float_x = 0
        window.float_y = 0
#        raise Exception(str(window.group))
#        window.tweak_float(w=500, h=600, x=700, y=800, dw=500, dh=500, dx=700, dy=800)
#        window.tweak_float(x=300, y=400)
#        window.cmd_set_size_floating(1000, 1000, 0, 0)
#        window.cmd_set_position_floating(100, 200, 0, 0)
#        raise Exception(str(window.get_position()))
#        window.place(
#            100, 200,
#            window.width, window.height,
#            window.borderwidth, window.bordercolor
#        )


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])


# look for new monitor
@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
#    call("setup_screens")
    qtile.cmd_restart()


dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating()
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, github issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

