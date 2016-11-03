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

import os, subprocess
from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.layout.columns import Columns
from libqtile.layout.tree import TreeTab
import commands
import widgets

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
#    Key(
#        [mod], "Left",
#        lazy.layout.up()
#    ),
#    Key(
#        [mod], "Right",
#        lazy.layout.down()
#    ),

    # Move windows up or down in current stack
#    Key(
#        [mod, "control"], "Up",
#        lazy.layout.shuffle_down()
#    ),
#    Key(
#        [mod, "control"], "Down",
#        lazy.layout.shuffle_up()
#    ),

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
    Key(
        [mod, "shift"], "Return",
        lazy.layout.toggle_split()
    ),
    Key([mod], "Return", lazy.spawn("sakura -e stmux")),

    # Toggle between different layouts as defined below
    Key([mod], "z", lazy.next_layout()),
    Key([alt], "F4", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),

    Key([], 'F12', lazy.function(commands.ToggleTerm())),

    Key([ctrl, alt], "l", lazy.spawn("/sh/i3lock.sh")),
]

# groups = [Group(i) for i in "asdfuiop"]
groups = [
    Group("term", spawn=['sakura -e stmux']),
    Group("web", spawn=['chromium']),  # , matches=Match(title=["Firefox", "Chromium"]))
    Group("im", spawn=[
        'telegram-desktop',
        'slack',
        '/sh/flowdock'
    ], layout='treetab'),
    Group("mail", spawn=['thunderbird']),
    Group("dev", spawn=['subl3']),
    Group("games"),  # , spawn=['steam']),
    Group("misc", layout="treetab")
]

for i, group in enumerate(groups):
    # mod1 + letter of group = switch to group
    group.name = '{} {}'.format(i + 1, group.name)
    keys.append(
        Key([mod], str(i + 1), lazy.group[group.name].toscreen())
    )

#    # mod1 + shift + letter of group = switch to & move focused window to group
#    keys.append(
#        Key([mod, "shift"], i.name, lazy.window.togroup(i.name))
#    )

layouts = [
    Columns(),
#    layout.Stack(num_stacks=2),
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
                    inactive='#888888', highlight_method='text',
                    rounded=False, highlight_color=['#FF1177', '#FF1177'],
                    this_screen_border='#00FF00', this_current_screen_border='#F05040'
                ),
                widget.Sep(padding=5),
                widget.Prompt(background='#F05040', font='DejaVu Sans Mono Bold', fontsize=12),
                widget.WindowName(),
#                widget.TextBox("default config", name="default"),
                widget.Systray(),
#                widget.LaunchBar([('firefox', 'firefox')]),
                widget.Sep(padding=5),
                widget.Battery(),
                widget.Sep(padding=5),
#                widget.CPUGraph(border_color='#000000', samples=50, frequency=0.1, line_width=2, type='line'),
#                widget.BatteryIcon(),
#                widget.Backlight(),
#                widget.Clipboard(),
                widget.ThermalSensor(),
#                widget.Notify(),
#                widget.Pacman(),
#                widget.DF(),
#                widget.Sep(padding=5),
                # widget.KeyboardLayout(configured_keyboards=['us', 'ru', 'ua']),
                widgets.KBLayout(),
                widget.Volume(),
                widget.Sep(padding=5),
                widgets.RSS(),
                widget.Sep(padding=5),
                widget.CurrentLayout(),
                widget.Sep(padding=5),
                widget.Clock(format='%Y-%m-%d %H:%M'),
            ],
            28
#            background='#222222'
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]


@hook.subscribe.client_new
def floating_dialogs(window):
    dialog = window.window.get_wm_type() == 'dialog'
    transient = window.window.get_wm_transient_for()
    if dialog or transient:
        window.floating = True


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])


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
