from libqtile.widget import base, Volume, ThermalSensor, Battery
from libqtile.log_utils import logger
from libqtile import bar, hook
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
from redtruck import RedObject
from cal import get_next_event
import os
import cairocffi


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
        return u'\uf0ac {}'.format(out.strip().upper())


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
        self._update()

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
        except:
            # logger.exception(e.message)
            ping = '???'

        self.ping = ping
        iwconfig = iwlib.get_iwconfig('wlp3s0')
        is_connected = iwconfig['Access Point'] != '00:00:00:00:00:00'
        if is_connected:
            self.wlan_name = iwconfig['ESSID']
        else:
            self.wlan_name = 'Offline'
            self.foreground = '#FF0000'
        self.timeout_add(0, self._ready)
        # self.ping = str(self.layout)
        # self._user_config['foreground'] = '#00FF00'

    def _ready(self):
        # \uf1eb
        self.text = u'\uf072  {}: {}ms'.format(self.wlan_name, self.ping)
        if len(self.text) != len(self.last_text):
            self.bar.draw()
        else:
            self.draw()
        self.last_text = self.text
        # self.timeout_add(2, lambda: Thread(target=self._update).start())
        self.timeout_add(2, self._update)


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
            return u'\uF0C2  {name} {temp}\u00B0C'.format(
                city=response['name'],
                temp=int(response['main']['temp'] - OpenWeatherMap.ABS_ZERO),
                name=response['weather'][0]['main']
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

    class VKPlayer(RedObject):
        def __init__(self, widget):
            self.widget = proxy(widget)
            super(NowPlayingWidget.VKPlayer, self).__init__('org.dunai.vkplayer', logger)

        def on_connected_handler(self):
            self.broadcast('request_state')

        # def on_state_changed_handler(self, data):
        #     logger.error('INIT')
        #     self.widget._update_text(*data)

    def __init__(self, **config):
        self.is_downloading = False
        self.is_playing = False
        self.current_icon = '?'
        self.current_song = 'Empty'
        try:
            # config['font'] = 'DejaVu Sans Mono Bold'
            self.max_len = 18
            self.prev_len = 0
            self.shifted = 0
            self.sep = '  ***  '
            base._TextBox.__init__(self, **config)

            self.vkplayer = NowPlayingWidget.VKPlayer(self)
            # self.vkplayer.start()
        except Exception as e:
            logger.exception(e.message)

    def _configure(self, *args):
        super(NowPlayingWidget, self)._configure(*args)
        self.timeout_add(0.2, self._shift)

    def timer_setup(self):
        def on_done(future):
            try:
                event = future.result()
            except Exception:
                self._update_state(False, False, 'Player is offline')
                logger.exception('next_event() raised exceptions')
            else:
                if event is not None:
                    if event.name == 'state_changed':
                        self._update_state(*event.data)
                    else:
                        logger.error('Unknown event received: {}'.format(event))
            self.timer_setup()

        future = self.qtile.run_in_executor(self.vkplayer.next_event)
        future.add_done_callback(on_done)

    def _shift(self, *args):
        self.timeout_add(0.2, self._shift)

        # self.text = u'{} {}'.format(self.current_icon, self.current_song)
#        self.current_song = self.current_song[1:] + self.current_song[:1]
        self._draw()
#        if self.prev_len == len(self.current_song):
        self.shifted += 1
        if (self.shifted >= len(self.current_song) + len(self.sep)) or (len(self.current_song) != self.prev_len):
            self.shifted = 0
        self.prev_len = len(self.current_song)

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

    def _update_state(self, is_downloading, is_playing, current_song):
        try:
            self.is_downloading = is_downloading
            self.is_playing = is_playing

            self.current_icon = u'\uF019' if is_downloading else u'\uF04B' if is_playing else u'\uF04C'

            current_song = current_song.decode('utf-8')
            self.current_song = current_song
            """
            try:
                # s = u'{} {}'.format(u'\uF019' if is_downloading else u'\uF04B' if is_playing else u'\uF04C', current_song)
                self.current_icon = u'\uF019' if is_downloading else u'\uF04B' if is_playing else u'\uF04C'
                self.is_downloading = is_downloading
                self.is_playing = is_playing
                if len(current_song) > self.max_len:
                    self.current_song = s[:self.max_len]
                else:
                    self.current_song = s.ljust(self.max_len, ' ')
                # if is_playing:
                #     self.foreground = '#55CC55'
                # else:
                #     self.foreground = '#AAAA55'
            except:
                self.current_icon = '!'
                self.is_downloading = False
                self.is_playing = False
                self.current_song = 'N/A'
            """

            self._draw()
        except Exception as e:
            logger.exception(e.message)

    def _draw(self, redraw=False):
        shifted_title = self.sep.join([self.current_song] * 10)[self.shifted:self.shifted + self.max_len + 3]
        self.text = u'{} {}'.format(self.current_icon, shifted_title)
        if self.is_downloading:
            self.foreground = '#5555CC'
        elif self.is_playing:
            self.foreground = '#55CC55'
        else:
            self.foreground = '#AAAA55'
#        if redraw:
#            self.bar.draw()
#        else:
        self.draw()

    def button_press(self, x, y, button):
        if button == 1:
            # Left: play/pause
            self.vkplayer.broadcast('play_pause')

        elif button == 2:
            # Middle: random next
            self.vkplayer.broadcast('play_random')


class CurrentLayoutIcon(base._TextBox):
    """
    Display the name of the current layout of the current group of the screen,
    the bar containing the widget, is on.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    defaults = [
        ('scale', 1, 'Scale factor, defaults to 1'),
    ]

    def __init__(self, **config):
        base._TextBox.__init__(self, "", **config)
        self.add_defaults(CurrentLayoutIcon.defaults)
        self.scale = 1.0 / self.scale

        self.length_type = bar.STATIC
        self.length = 0

    def _configure(self, qtile, bar):
        base._TextBox._configure(self, qtile, bar)
        self.text = self.bar.screen.group.layouts[0].name
        self.icons = {
            'max': os.path.expanduser('~/.icons/layout_max.png'),
            'treetab': os.path.expanduser('~/.icons/layout_treetab.png'),
            'columns': os.path.expanduser('~/.icons/layout_columns.png'),
        }
        self.surfaces = {}
        self.setup_images()
        self.setup_hooks()

    def setup_hooks(self):
        def hook_response(layout, group):
            if group.screen is not None and group.screen == self.bar.screen:
                self.current_layout = layout.name
                # self.text = layout.name
                self.bar.draw()
        hook.subscribe.layout_change(hook_response)

    def button_press(self, x, y, button):
        if button == 1:
            self.qtile.cmd_next_layout()
        elif button == 2:
            self.qtile.cmd_prev_layout()

    def draw(self):
        self.drawer.clear(self.background or self.bar.background)
        self.drawer.ctx.set_source(self.surfaces[self.current_layout])
        self.drawer.ctx.paint()
        self.drawer.draw(offsetx=self.offset, width=self.length)

    def setup_images(self):
        for key, path in self.icons.items():
            img = cairocffi.ImageSurface.create_from_png(path)
            # try:
            #     path = os.path.join(self.theme_path, name)
            #     img = cairocffi.ImageSurface.create_from_png(path)
            # except cairocffi.Error:
            #     self.theme_path = None
            #     logger.warning('Battery Icon switching to text mode')
            #     return
            input_width = img.get_width()
            input_height = img.get_height()

            sp = float(input_height) / (self.bar.height - 1)

            logger.error('x ' + str(sp))

            logger.error('{} {}'.format(input_height, self.bar.height))

            width = float(input_width) / sp
            if width > self.length:
                self.length = int(width) + self.actual_padding * 2

            # print 'W', width
            # self.length = width
            # print 'W2', width
            # print 'L', self.length

            imgpat = cairocffi.SurfacePattern(img)

            scaler = cairocffi.Matrix()

            scaler.scale(sp, sp)
            scaler.scale(self.scale, self.scale)
            # diff = self.scale - 1
            factor = (1 - 1 / self.scale) / 2
            # if diff != 0:
            scaler.translate(-width * factor, -width * factor)
            scaler.translate(self.actual_padding * -1, 0)
            imgpat.set_matrix(scaler)

            imgpat.set_filter(cairocffi.FILTER_BEST)
            self.surfaces[key] = imgpat


class Volume2(Volume):
    def _update_drawer(self):
        if self.theme_path:
            self.drawer.clear(self.background or self.bar.background)
            if self.volume <= 0:
                img_name = 'audio-volume-muted'
            elif self.volume <= 30:
                img_name = 'audio-volume-low'
            elif self.volume < 80:
                img_name = 'audio-volume-medium'
            else:  # self.volume >= 80:
                img_name = 'audio-volume-high'

            self.drawer.ctx.set_source(self.surfaces[img_name])
            self.drawer.ctx.paint()
        elif self.emoji:
            if self.volume <= 0:
                self.text = u'\U0001f507'
            elif self.volume <= 30:
                self.text = u'\U0001f508'
            elif self.volume < 80:
                self.text = u'\U0001f509'
            elif self.volume >= 80:
                self.text = u'\U0001f50a'
        else:
            if self.volume == -1:
                self.text = u'\uf026    M '
            else:
                self.text = u'\uf028 %s%%' % self.volume


class ThermalSensor2(ThermalSensor):
    def poll(self):
        temp_values = self.get_temp_sensors()
        if temp_values is None:
            return False
        text = u"\uf069 "
        if self.show_tag and self.tag_sensor is not None:
            text = self.tag_sensor + u": "
        parts = temp_values.get(self.tag_sensor, ['N/A'])
        parts = [x.decode('utf-8') for x in parts]
        text += u"".join(parts)
        temp_value = float(temp_values.get(self.tag_sensor, [0])[0])
        if temp_value > self.threshold:
            self.layout.colour = self.foreground_alert
        else:
            self.layout.colour = self.foreground_normal
        return text


class Battery2(Battery):
    def update(self):
        ntext = u'\uf0e7 {}'.format(self._get_text())
        if ntext != self.text:
            self.text = ntext
            self.bar.draw()


class UnreadMail(base._TextBox):
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        self.unread_count = 0
        self.last_text = ''
        base._TextBox.__init__(self, **config)

    def timer_setup(self):
        self._update()

    def button_press(self, x, y, button):
        if button == 1:
            self.qtile.currentScreen.setGroup(self.qtile.groupMap['m'])

    def _update(self):
        profiles_file = open(os.path.expanduser('~/.thunderbird/profiles.ini'), 'r')
        for line in profiles_file.read().split('\n'):
            key, _, value = line.strip().partition('=')
            if key.lower() == 'path':
                profile = value.strip()
        profiles_file.close()

        self.unread_count = 0

        unread_file = open(os.path.expanduser('~/.thunderbird/{}/unread-counts'.format(profile)))
        for line in unread_file.read().split('\n'):
            count, _, box = line.strip().partition(':')
            try:
                self.unread_count += int(count)
            except ValueError:
                pass
        unread_file.close()

        self.timeout_add(0, self._ready)
        # self.ping = str(self.layout)
        # self._user_config['foreground'] = '#00FF00'

    def _ready(self):
        # \uf1eb
        self.text = u'\uf003  {}'.format(self.unread_count)
        self.foreground = '#FFFFFF' if self.unread_count == 0 else '#F05040'
        if len(self.text) != len(self.last_text):
            self.bar.draw()
        else:
            self.draw()
        self.last_text = self.text
        self.timeout_add(10, self._update)


class NextEvent(base._TextBox):
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        self.last_text = ''
        base._TextBox.__init__(self, **config)

    def timer_setup(self):
        self._update()

    def button_press(self, x, y, button):
        pass
        # if button == 1:
        #     self.qtile.currentScreen.setGroup(self.qtile.groupMap['m'])

    def _update(self):
        self.info = get_next_event()

        self.timeout_add(0, self._ready)
        # self.ping = str(self.layout)
        # self._user_config['foreground'] = '#00FF00'

    def _ready(self):
        # \uf1eb
        self.text = u'\uf073  {}'.format(self.info)
        self.foreground = '#00FFAA'
        if len(self.text) != len(self.last_text):
            self.bar.draw()
        else:
            self.draw()
        self.last_text = self.text
        self.timeout_add(60, self._update)
