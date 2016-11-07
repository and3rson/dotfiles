from libqtile.widget import base
from libqtile.log_utils import logger
from libqtile import bar
import feedparser
from urllib import urlencode
import urllib2
import json
from subprocess import Popen, PIPE
from threading import Thread, current_thread
from re import findall
# import dbus
import time
import socket
import iwlib
from select import select
# from dbus.mainloop.glib import DBusGMainLoop
# from gi.repository import GObject
# import gobject
from weakref import proxy
from truck import BusObject


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


class Ping(base._TextBox):
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        config['update_interval'] = 3
        # config['foreground'] = '#F05040'
        # config['font'] = 'DejaVu Sans Medium'
        # self.text = '???'
        self.ping = '?'
        self.last_text = ''
        self.wlan_name = '-'
        # self.foreground = '#FFFFFF'
        base._TextBox.__init__(self, **config)

    def timer_setup(self):
        self._ready()

    def button_press(self, x, y, button):
        pass

    def _update(self):
        out, err = Popen(['ping', '-c', '1', '8.8.8.8'], stdout=PIPE, stderr=PIPE).communicate()
        try:
            ping = int(float(findall('icmp_seq=[\d]+ ttl=[\d]+ time=([\d\.]+)', out)[0]))
            if ping > 999:
                ping = 999
            if ping > 100:
                self.foreground = '#FF0000'
            elif ping < 50:
                self.foreground = '#00FF00'
            else:
                factor = float(ping - 50) / 50
                self.foreground = '#%02x%02x00' % (factor * 255, (1 - factor) * 255)
            ping = str(ping).rjust(3, ' ')
        except Exception as e:
            logger.exception(e.message)
            ping = '???'

        self.ping = ping
        iwconfig = iwlib.get_iwconfig('wlp3s0')
        self.wlan_name = iwconfig['ESSID'] if iwconfig['Access Point'] != '00:00:00:00:00:00' else 'Offline'
        self.timeout_add(0, self._ready)
        # self.ping = str(self.layout)
        # self._user_config['foreground'] = '#00FF00'

    def _ready(self):
        self.text = u'{}: {}ms'.format(self.wlan_name, self.ping)
        if len(self.text) != len(self.last_text):
            self.bar.draw()
        else:
            self.draw()
        self.last_text = self.text
        self.timeout_add(2, lambda: Thread(target=self._update).start())


class OpenWeatherMap(base.ThreadedPollText):
    orientations = base.ORIENTATION_HORIZONTAL

    ABS_ZERO = 273.15
    URL = 'http://api.openweathermap.org/data/2.5/weather'

    def __init__(self, **config):
        self.url = None
        for key in ('appid', 'location'):
            if key not in config:
                logger.error('Missing "{}" config parameter!'.format(key))
                return
        config['update_interval'] = 300
        self.url = OpenWeatherMap.URL + '?' + urlencode(dict(
            q=config.pop('location'),
            appid=config.pop('appid')
        ))
        base.ThreadedPollText.__init__(self, **config)

    def poll(self):
        if self.url is None:
            return 'N/A'
        try:
            response = json.loads(urllib2.urlopen(self.url).read())
            return u'{}: {}\u00B0C'.format(
                response['name'],
                response['main']['temp'] - OpenWeatherMap.ABS_ZERO
            )
        except Exception as e:
            logger.exception(e.message)
            return 'ERROR'


class NowPlayingWidget(base._TextBox):
    orientations = base.ORIENTATION_HORIZONTAL

    # class Poller(Thread):
    #     def __init__(self, on_song_changed):
    #         Thread.__init__(self)
    #         self.on_song_changed = on_song_changed

    #     def run(self):
    #         self.sock = None
    #         self._connect()
    #         while True:
    #             try:
    #                 i, o, e = select([self.sock], [], [], 1)
    #                 if self.sock in i:
    #                     data = self.sock.recv(1024).strip()
    #                     if not data:
    #                         print 'Connection dropped, reconnecting...'
    #                         self._connect()
    #                         continue
    #                     else:
    #                         for line in data.split('\n'):
    #                             args = line.split(':::')
    #                             if args[0] == 'current_song':
    #                                 self.on_song_changed(bool(int(args[1])), args[2])
    #             except Exception as e:
    #                 logger.exception(e.message)
    #                 self._connect()

    #     def _connect(self):
    #         connected = False
    #         while not connected:
    #             try:
    #                 self.sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    #                 self.sock.connect('/tmp/vkplayer.sock')
    #                 self.sock.send('get_current_song\n\n')
    #             except:
    #                 logger.error('Failed to connect to VKPlayer, reconnecting in 1s...')
    #                 time.sleep(1)
    #             else:
    #                 connected = True

    #     def send(self, cmd):
    #         self.sock.send(cmd + '\n')

    class VKPlayer(BusObject):
        def __init__(self, widget):
            self.widget = proxy(widget)
            super(NowPlayingWidget.VKPlayer, self).__init__('org.dunai.vkplayer')

        def on_state_changed_handler(self, data):
            self.widget._update_text(*data)

    def __init__(self, **config):
        config['font'] = 'DejaVu Sans Mono Bold'
        self.max_len = 28
        base._TextBox.__init__(self, **config)

        self.vkplayer = NowPlayingWidget.VKPlayer(self)
        self.vkplayer.start()
        self.vkplayer.broadcast('request_state')

        # self.bus = dbus.SessionBus()

    # def _on_song_changed(self, is_playing, current_song):
    #     self._update_text()
        # logger.error('INFO: {} {}'.format(is_playing, current_song))

    # def timer_setup(self):
    #     self._get_current_song()
    #     self.timeout_add(5, self.timer_setup)

    # def _get_current_song(self):
    #     try:
    #         # logger.error('GET CURRENT')
    #         vkplayer = self.bus.get_object('org.dunai.vkplayer', '/org/dunai/vkplayer')
    #         get_current_song = vkplayer.get_dbus_method('get_current_song', 'org.dunai.vkplayer')
    #         is_playing, current_song = get_current_song()
    #         self._update_text(is_playing, current_song)
    #     except Exception as e:
    #         logger.exception(e.message)

    def _update_text(self, is_playing, current_song):
        current_song = current_song.decode('utf-8')
        logger.error(u'UPDATE {} {}'.format(is_playing, current_song))
        try:
            s = u'{} {}'.format(u'\uF04B' if is_playing else u'\uF04C', current_song)
            if len(current_song) > self.max_len:
                self.text = s[:self.max_len]
            else:
                self.text = s.ljust(self.max_len, ' ')
            if is_playing:
                self.foreground = '#55CC55'
            else:
                self.foreground = '#AAAA55'
        except:
            self.text = 'N/A'

        self.timeout_add(0, self.draw)

    def button_press(self, x, y, button):
        if button == 1:
            # Left: play/pause
            self.vkplayer.broadcast('play_pause')

        elif button == 2:
            # Middle: random next
            self.vkplayer.broadcast('play_random')
