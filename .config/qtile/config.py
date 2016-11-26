# Copyright (c) 2016 Andrew Dunai
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
import re
import subprocess
from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
import commands
import widgets

BIN_DIR = os.path.expanduser('~/.config/qtile/bin')

TERM_APP = 'roxterm'
HOME_TERM_CMD = 'roxterm -e {}'.format(os.path.join(BIN_DIR, 'stmux.sh'))

ctrl = 'control'
alt = 'mod1'
lock = 'mod3'  # I have CapsLock remapped to mod3. Didn't use it much yet.
mod = 'mod4'
shift = 'shift'

# Psst: I use nerd-fonts package for icons.


class WidgetOpts:
    LOCATION = 'Lviv, Ukraine'
    MONOSPACE_FONT = 'DejaVu Sans Mono'
    HIGHLIGHT_COLOR = '#F05040'


keys = [
    # Switch between windows in current group
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

    # Grow/shrink MonadTall layout items
    Key(
        [mod], 'plus',
        lazy.layout.grow()
    ),
    Key(
        [mod], 'equal',
        lazy.layout.grow()
    ),
    Key(
        [mod], 'minus',
        lazy.layout.shrink()
    ),

    # Grow columns
    Key(
        [mod], "bracketleft",
        lazy.layout.grow(),
    ),
    Key(
        [mod], "bracketright",
        lazy.layout.shrink(),
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

    # Switch to other screen (when using two monitors)
    Key(
        [mod], "space",
        lazy.function(commands.SwitchScreen())
    ),
    Key(
        [alt], "Tab",
        lazy.function(commands.SwitchScreen())
    ),

    Key([mod], "Return", lazy.spawn(TERM_APP)),

    # Switch to next layout
    Key([mod], "z", lazy.next_layout()),

    # Kill window
    Key([alt], "F4", lazy.window.kill()),

    # Restart Qtile
    Key([mod, "control"], "r", lazy.restart()),
    # Quit Qtile
    Key([mod, "control"], "q", lazy.shutdown()),

    # Run window selector script
    Key([mod], "p", lazy.function(commands.WindowSelector())),

    # Run dmenu launcher for apps
    Key([mod], "r", lazy.spawn("dmenu_run -fn 'DejaVu Sans Mono-10' -sb {} -sf '#000' -nb black -dim 0.5 -p '>' -l 10".format(
        WidgetOpts.HIGHLIGHT_COLOR
    ))),
    Key([lock], 'r', lazy.spawn(os.path.join(BIN_DIR, 'menu.py'))),

    # Open config editor
    Key([mod], "c", lazy.spawn('{} -e "nano /home/anderson/.config/qtile/config.py"'.format(TERM_APP))),

    # Capture screenshot
    Key([mod], "Print", lazy.spawn(os.path.expanduser('~/.config/qtile/bin/sshot.py'))),

    # Toggle to terminal pane and back. Yeah, I cannot stop using the F12 hotkey since Guake times. Good old Guake.
    Key([], 'F12', lazy.function(commands.ToggleTerm())),

    # Volume management
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('amixer -q sset Master 4%+')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('amixer -q sset Master 4%-')),
    Key([], 'XF86AudioMute', lazy.spawn('amixer -q sset Master toggle')),

    # Brightness management
    Key([], 'XF86MonBrightnessUp', lazy.spawn('xbacklight -inc 10')),
    Key([], 'XF86MonBrightnessDown', lazy.spawn('xbacklight -dec 10')),

    # Run screen locker
    Key([ctrl, alt], "l", lazy.spawn("/sh/i3lock.sh")),

    # I hit this when a window gets to a wrong group despite filters. Happens to some apps.
    Key([ctrl, mod], "g", lazy.function(commands.FixGroups())),

    # Just a test for my custom mod3 key (I have CapsLock remapped for this, set by xmodman in autorun.sh)
    Key([lock], 'space', lazy.function(commands.WindowSelector())),
]

# Definitions of groups. The parts are:
# - name & activation key
# - full name (not sure if it's still used somewhere)
# - commands to spawn here initially
# - default layout
# - arguments for `Match`es
GROUP_DEFS = (
    ('t', 'term', [HOME_TERM_CMD], 'max', dict()),
    ('w', 'web', ['chromium', 'firefox'], 'max', dict(wm_class=['chromium', 'Firefox'])),
    ('i', 'im', ['telegram-desktop', 'slack'], 'zoomy', dict(wm_class=[
        'telegram-desktop', 'TelegramDesktop', 'Slack', 'www.flowdock.com__app_redeapp_main'
    ], title=['Messenger', 'Flowdock', re.compile(r'^.* - Chat$')])),
    ('m', 'mail', ['thunderbird'], 'monadtall', dict(wm_class=['Thunderbird'])),
    ('d', 'dev', ['subl3'], 'monadtall', dict(wm_class=['Subl3'])),
    ('a', 'audio', ['vkplayer'], 'monadtall', dict(title=['VK audio player'])),
    ('g', 'games', ['steam'], 'max', dict(wm_class=[
        re.compile('^Steam|csgo_linux64$')
    ], title=[
        re.compile('^Steam$')
    ])),
    ('v', 'var', [], 'monadtall', dict()),
    ('n', 'notes', ['peek-desktop'], 'max', dict(title=['Peek App'])),
)

groups = [
    Group('{name}'.format(id=i + 1, name=g_name[0]), spawn=g_startup, layout=g_layout, matches=[Match(**g_match_kwargs)])
    for i, (g_hotkey, g_name, g_startup, g_layout, g_match_kwargs)
    in enumerate(GROUP_DEFS)
]

for g_hotkey, g_name, g_startup, g_layout, g_match_kwargs in GROUP_DEFS:
    keys.append(
        Key([mod], g_hotkey, lazy.group[g_name[0]].toscreen())
    )
    keys.append(
        Key([mod, shift], g_hotkey, lazy.window.togroup(g_name[0]))
    )

# I have three layouts here: MonadTall, Max & Zoomy
layouts = [
    layout.MonadTall(
        border_normal='#000000',
        border_focus=WidgetOpts.HIGHLIGHT_COLOR,
        border_width=0,
        grow_amount=0
    ),
    layout.Max(),
    layout.Zoomy(
        columnwidth=300
    )
]

# Default args for widgets
widget_defaults = dict(
    font='Roboto Medium',
    fontsize=12,
    padding=6,
    margin_y=0
)

# Config for group box to avoid duplication.
group_box_config = dict(
    background='#000000',
    borderwidth=2, disable_drag=True,
    inactive='#888888', highlight_method='block',
    rounded=False,
    this_screen_border=WidgetOpts.HIGHLIGHT_COLOR, this_current_screen_border='#703020',
    other_screen_border='#703020', other_current_screen_border=WidgetOpts.HIGHLIGHT_COLOR,
    urgent_border='#0077FF',
    current_highlight_method='block',
    other_highlight_method='border',
    font='Roboto Sans Bold',
    padding_x=1,
    margin_x=0
)

# Screens config
# You will see a lot of widget classes that end with "2".
# These are the classes that I overrided in my `widgets.py` file
# to tweak their behavior to what I want. Most of them include adding
# custom icon font characters and colors, but some of them (e. g. GroupBox2)
# have more things changed. See my `widgets.py` file for more info.
def make_current_layout_widget():
    w = widget.CurrentLayoutIcon(scale=0.8)
    w._update_icon_paths()
    if w.find_icon_file_path('max'):
        return w
    else:
        return widget.CurrentLayout()

screens = [
    Screen(
        top=bar.Bar(
            [
                make_current_layout_widget(),
                widgets.GroupBox2(**group_box_config),
                widget.Prompt(
                    background=WidgetOpts.HIGHLIGHT_COLOR,
                    font=WidgetOpts.MONOSPACE_FONT,
                    fontsize=12
                ),
                widgets.TaskList2(
                    rounded=False,
                    max_title_width=200,
                    highlight_method='block',
                    border=WidgetOpts.HIGHLIGHT_COLOR
                ),
                widget.Systray(),
                widget.Sep(padding=10),
                widget.Clock(format='%Y-%m-%d %H:%M'),
            ],
            26
        ),
        bottom=bar.Bar(
            [
                widgets.ArchLogo(scale=0.8),
                widgets.UnreadMail(
                    font=WidgetOpts.MONOSPACE_FONT
                ),
                widgets.NextEvent(
                    font=WidgetOpts.MONOSPACE_FONT
                ),
                widget.Sep(padding=10),
                widgets.Battery2(
                    charge_char='+',
                    discharge_char='-',
                    foreground='#5090F0',
                    format=u'{char} {percent:2.0%}'
                ),
                widgets.ThermalSensor2(
                    font=WidgetOpts.MONOSPACE_FONT,
                    foreground='#FFFFCC',
                    foreground_alert='#FF0000'
                ),
                widget.Sep(padding=10),
                widgets.KBLayout(
                    font=WidgetOpts.MONOSPACE_FONT,
                    foreground='#CCFFCC'
                ),
                widgets.Volume2(
                    font=WidgetOpts.MONOSPACE_FONT,
                    foreground='#CCFFFF',
                    update_interval=0.5
                ),
                widgets.OpenWeatherMap(
                    appid='5041ca48d55a6669fe8b41ad1a8af753',
                    # I hereby disclose my OpenWeatherMap API token.
                    # Please show me some respect and do not abuse it. <3
                    location=WidgetOpts.LOCATION,
                    font=WidgetOpts.MONOSPACE_FONT,
                    foreground='#77CCFF'
                ),
                widget.Sep(padding=10),
                widget.CPUGraph(
                    border_color='#11BBEE.3',
                    border_width=1,
                    graph_color='#11BBEE',
                    fill_color='#11BBEE.3',
                    samples=60,
                    frequency=0.25,
                    line_width=2,
                    type='linefill',
                    width=50
                ),
                widget.MemoryGraph(
                    border_color='#22CC77.3',
                    border_width=1,
                    graph_color='#22CC77',
                    fill_color='#22CC77.3',
                    samples=60,
                    frequency=0.25,
                    line_width=2,
                    type='linefill',
                    width=50
                ),
                widget.Sep(
                    padding=10
                ),
                widgets.NowPlayingWidget(
                    foreground='#F0F040',
                    font=WidgetOpts.MONOSPACE_FONT
                ),
                widget.Spacer(),
                widgets.DiskUsage(
                    root='/',
                    font=WidgetOpts.MONOSPACE_FONT
                ),
                widget.Sep(padding=10),
                widgets.Ping(font=WidgetOpts.MONOSPACE_FONT),
            ],
            22
        )
    ),
    Screen(
        top=bar.Bar(
            [
                make_current_layout_widget(),
                widgets.GroupBox2(**group_box_config),
                widgets.TaskList2(
                    rounded=False,
                    max_title_width=600,
                    highlight_method='block',
                    border=WidgetOpts.HIGHLIGHT_COLOR
                ),
            ],
            22
        )
    ),
]

# Make floating layouts draggable
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]


# Make dialogs float & appear at the middle of the screen
@hook.subscribe.client_new
def floating_dialogs(window):
    dialog = window.window.get_wm_type() == 'dialog'
    transient = window.window.get_wm_transient_for()
    if dialog or transient:
        window.floating = True
        window.float_x = 0
        window.float_y = 0


# Always keep at least one terminal app instance running on the first tab
@hook.subscribe.client_killed
def respawn_term(window):
    if window.group.name == 't':
        terminals = [
            w
            for w
            in window.qtile.cmd_windows()
            if w['group'] == 't' and w['id'] != window.cmd_info()['id']
        ]
        if len(terminals) == 0:
            window.qtile.cmd_spawn('{}'.format(HOME_TERM_CMD))


# Run autostart.sh & xrandr.sh
@hook.subscribe.startup_once
def autostart():
    subprocess.call(os.path.expanduser('~/.config/qtile/autostart.sh'))
    subprocess.call(os.path.expanduser('~/.config/qtile/bin/xrandr.sh'))


# Look for new monitor and call xrandr.sh to reconfigure stuff once screen config changes
@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
    subprocess.call(os.path.expanduser('~/.config/qtile/bin/xrandr.sh'))
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
# wmname = "LG3D"
# Nope, I want everyone know I use Qtile :>
wmname = 'QTile'
