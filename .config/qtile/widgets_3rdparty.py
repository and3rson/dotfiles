#!/usr/bin/env python
# vim:fileencoding=utf-8
from __future__ import (unicode_literals, division, absolute_import,
                        print_function)

__license__ = 'GPL v3'
__copyright__ = '2013, Kovid Goyal <kovid at kovidgoyal.net>'

import re
import os

from libqtile import bar, hook
from libqtile.widget import base

from powerline import Powerline

core = Powerline(ext='wm', renderer_module='pango_markup')
basedir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


class PowerlineRight(base._TextBox):

    SIDE = 'right'

    def __init__(self, timeout=1, **config):
        base._TextBox.__init__(self, ' ', bar.CALCULATED, **config)
        self.timeout_add(timeout, self.update)  # redraw every timeout seconds

    def update(self):
        if not self.configured:
            return True
        self.text = core.render(side=self.SIDE, segment_info={'qtile': self.qtile, 'bar': self.bar})
        self.bar.draw()
        return True

    def cmd_update(self, text):
        self.update(text)

    def cmd_get(self):
        return self.text

    def _configure(self, qtile, bar):
        base._TextBox._configure(self, qtile, bar)
        self.layout = self.drawer.textlayout(
            self.text,
            self.foreground,
            self.font,
            self.fontsize,
            self.fontshadow,
            markup=True)

    def button_press(self, x, y, button):
        try:
            segment = self.get_clicked_segment(x)
        except:
            import traceback
            traceback.print_exc()
        else:
            if segment is not None:
                try:
                    self.handle_click(segment, button)
                except:
                    import traceback
                    traceback.print_exc()

    def handle_click(self, segment, button):
        import gobject
        import glib

        def p(*args):
            return gobject.spawn_async([x.encode('utf-8') for x in args], flags=glib.SPAWN_SEARCH_PATH)

        name = segment['name']
        if name == 'date':
            p('plasma-windowed', 'calendar')
        elif name == 'weather':
            p('xdg-open', 'https://www.google.co.in/search?q=weather')
        elif name in {'uptime', 'system_load'}:
            p('ksysguard')

    def get_clicked_segment(self, xpos):
        parts = []
        d = core.common_config['dividers'][self.SIDE]
        hard, soft = d['hard'].strip(), d['soft'].strip()
        for x in self.text.split(hard):
            subparts = x.split(soft)
            for y in subparts[:-1]:
                parts.append(y + soft)
            parts.append(subparts[-1] + hard)
        newwidth = width = 0
        segment_number = None
        for i, text in enumerate(parts):
            text = re.sub(r'</?span.*?>', '', text)
            newwidth += self.drawer.max_layout_size([text], self.font, self.fontsize)[0]
            if width <= xpos < newwidth:
                segment_number = i
                break
            width = newwidth

        if segment_number is not None:
            segment_number = max(0, segment_number - 1)  # The first part is a &nbsp; blank

            segments = core.renderer.theme.segments[self.SIDE]
            if segment_number < len(segments):
                return segments[segment_number]


class PowerlineLeft(base._TextBox):
    SIDE = 'left'

    def __init__(self, **config):
        base._TextBox.__init__(self, ' ', bar.CALCULATED, **config)

    def setup_hooks(self):
        def hook_response(*args, **kwargs):
            self.update()

        hook.subscribe.client_managed(hook_response)
        hook.subscribe.client_urgent_hint_changed(hook_response)
        hook.subscribe.client_killed(hook_response)
        hook.subscribe.setgroup(hook_response)
        hook.subscribe.group_window_add(hook_response)
        hook.subscribe.window_name_change(self.update)
        hook.subscribe.focus_change(self.update)
        hook.subscribe.float_change(self.update)

    def update(self):
        if not self.configured:
            return True
        self.text = core.render(side='left', segment_info={'qtile': self.qtile, 'bar': self.bar})
        self.bar.draw()
        return True

    def cmd_get(self):
        return self.text

    def cmd_update(self, text):
        self.update(text)

    def _configure(self, qtile, bar):
        base._TextBox._configure(self, qtile, bar)
        self.layout = self.drawer.textlayout(
            self.text,
            self.foreground,
            self.font,
            self.fontsize,
            self.fontshadow,
            markup=True)
        self.setup_hooks()
