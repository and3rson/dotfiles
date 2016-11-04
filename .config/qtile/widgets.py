from libqtile.widget import base
import feedparser
from subprocess import Popen, PIPE
from threading import Thread
from re import findall


class RSS(base.ThreadedPollText):
    """Display RSS feeds updates using the canto console reader"""
    orientations = base.ORIENTATION_HORIZONTAL
#    defaults = [
#        ("fetch", False, "Whether to fetch new items on update"),
#        ("feeds", [], "List of feeds to display, empty for all"),
#        ("one_format", "{name}: {number}", "One feed display format"),
#        ("all_format", "{number}", "All feeds display format"),
#    ]

    def __init__(self, **config):
        config['update_interval'] = 0.25
        config['font'] = 'DejaVu Sans Mono'
        self.last_entry = None
        self.pos = -1
        base.ThreadedPollText.__init__(self, **config)
#        self.add_defaults(Canto.defaults)

    def button_press(self, x, y, button):
        if self.last_entry is not None:
            pass
#            subprocess.Popen([])

    def _update(self):
        feed = feedparser.parse('http://www.pravda.com.ua/rss/view_mainnews/')
        entry = feed.entries[0]
        self.last_entry = entry
        # self.pos = -1

    def poll(self):
        if self.last_entry is None or self.pos >= len(self.last_entry.title) + 2:
            self._update()
            self.pos = -1
        self.pos += 1
        return (self.last_entry.title + ' | ' + self.last_entry.title)[self.pos:self.pos + 40]


class KBLayout(base.ThreadedPollText):
    """Display RSS feeds updates using the canto console reader"""
    orientations = base.ORIENTATION_HORIZONTAL
#    defaults = [
#        ("fetch", False, "Whether to fetch new items on update"),
#        ("feeds", [], "List of feeds to display, empty for all"),
#        ("one_format", "{name}: {number}", "One feed display format"),
#        ("all_format", "{number}", "All feeds display format"),
#    ]

    def __init__(self, **config):
        config['update_interval'] = 0.5
        base.ThreadedPollText.__init__(self, **config)
#        self.add_defaults(Canto.defaults)

    def button_press(self, x, y, button):
        pass

    def poll(self):
        out, err = Popen(['xkblayout-state', 'print', '%s'], stdout=PIPE, stderr=PIPE).communicate()
        return out.strip().upper()


class Ping(base.ThreadedPollText):
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        config['update_interval'] = 3
        config['foreground'] = '#AAAAAA'
        config['font'] = 'DejaVu Sans Bold'
        self.ping = '???'
        base.ThreadedPollText.__init__(self, **config)

    def button_press(self, x, y, button):
        pass

    def _update(self):
        out, err = Popen(['ping', '-c', '1', '8.8.8.8'], stdout=PIPE, stderr=PIPE).communicate()
        try:
            self.ping = findall('icmp_seq=[\d]+ ttl=[\d]+ time=([\d\.]+)', out)[0]
        except:
            self.ping = '???'
        # self.ping = str(self.layout)
        # self._user_config['foreground'] = '#00FF00'

    def poll(self):
        Thread(target=self._update).start()
        return self.ping
