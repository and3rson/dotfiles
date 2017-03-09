# -*- coding: utf-8 -*-

from __future__ import division

from libqtile.widget import base, Volume, ThermalSensor, Battery, GroupBox, TaskList, Backlight
from libqtile.log_utils import logger
from libqtile import bar
import feedparser
# from urllib import urlencode
from six.moves.urllib.request import urlopen
from six.moves.urllib.parse import urlencode
# from six.moves import xrange
from six import unichr
# import urllib2
import json
from subprocess import Popen, PIPE
from re import findall, compile
# import dbus
import time
import iwlib
from weakref import proxy
from redobject import RedObject
from cal import get_next_event
from utils import NonBlockingSpawn, progress
import os
import cairocffi
from pulsectl import Pulse
from threading import Lock
import socket
from bs4 import BeautifulSoup as BS
import bt
from notify import notify


class RSS(base.ThreadedPollText):
    """
    Displays newest article from pravda.com.ua
    """
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        config['update_interval'] = 0.25
        config['font'] = 'DejaVu Sans Mono'
        self.last_entry = None
        self.pos = -1
        base.ThreadedPollText.__init__(self, **config)

    def button_press(self, x, y, button):
        if self.last_entry is not None:
            pass

    def _update(self):
        feed = feedparser.parse('http://www.pravda.com.ua/rss/view_mainnews/')
        entry = feed.entries[0]
        self.last_entry = entry

    def poll(self):
        if self.last_entry is None or self.pos >= len(self.last_entry.title) + 2:
            self._update()
            self.pos = -1
        self.pos += 1
        return (self.last_entry.title + ' | ' + self.last_entry.title)[self.pos:self.pos + 40]


class KBLayout(base.ThreadedPollText):
    """
    Shows current keyboard layout.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        config['update_interval'] = 1
        base.ThreadedPollText.__init__(self, **config)

    def button_press(self, x, y, button):
        pass

    def poll(self):
        # f0ac
        out, err = Popen(['xkblayout-state', 'print', '%s'], stdout=PIPE, stderr=PIPE).communicate()
        return u'\uf11c {}'.format(out.strip().upper())


class Ping(base._TextBox, NonBlockingSpawn):
    """
    Displays current Wi-Fi ESSID & ICMP latency.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        self.ping = '?'
        self.last_text = ''
        self.wlan_name = '-'
        base._TextBox.__init__(self, **config)

    def _configure(self, *args, **kwargs):
        base._TextBox._configure(self, *args, **kwargs)
        self.do_ping()

    def do_ping(self):
        self.spawn(self._do_ping, self.on_ping_result)

    def _do_ping_old(self):
        iwconfig = iwlib.get_iwconfig('wlp3s0')
        is_connected = iwconfig['Access Point'] != '00:00:00:00:00:00'
        if is_connected:
            wlan_name = iwconfig['ESSID']
        else:
            wlan_name = 'Offline'

        out, err = Popen(['ping', '-c', '1', '8.8.8.8'], stdout=PIPE, stderr=PIPE).communicate()
        try:
            ping = int(float(findall('icmp_seq=[\d]+ ttl=[\d]+ time=([\d\.]+)', out)[0]))
            if ping > 999:
                ping = 999
        except:
            ping = None

        return (wlan_name, ping)

    def _do_ping(self):
        out, err = Popen(['ping', '-c', '1', '8.8.8.8'], stdout=PIPE, stderr=PIPE).communicate()

        try:
            ping = int(float(findall(b'icmp_seq=[\d]+ ttl=[\d]+ time=([\d\.]+)', out)[0]))
            if ping > 999:
                ping = 999
        except:
            ping = None

        return ping

    def on_ping_result(self, result):
        # wlan_name, ping = result
        ping = result

        # self.update(wlan_name, ping)
        self.update(ping)

        self.timeout_add(2, self.do_ping)

    def button_press(self, x, y, button):
        pass

    def update(self, ping):
        # \uf1eb
        if ping is None:
            ping_str = '???'
            self.foreground = '#FF0000'
        else:
            if ping > 100:
                # self.foreground = '#FF0000'
                self.foreground = self.foreground_alert
            # elif ping < 50:
            #     # self.foreground = '#00FF00'
            #     self.foreground = self.foreground_normal
            # else:
            #     # factor = float(ping - 50) / 50
            #     # self.foreground = '#%02x%02x00' % (factor * 127 + 128, (1 - factor) * 127 + 128)
            #     self.foreground = self.foreground_normal
            else:
                self.foreground = self.foreground_normal

            ping_str = str(ping).rjust(3, '~')
            # ping_str = str(ping)
            # if len(ping_str) < 3:
            #     ping_str = u'\u00a0' * (3 - len(ping_str)) + ping_str

        # f072
        # \u2098\u209B
        self.text = u'\uf1eb {}'.format(ping_str)

        if len(self.text) != len(self.last_text):
            self.bar.draw()
        else:
            self.draw()
        self.last_text = self.text


class OpenWeatherMap(base._TextBox, NonBlockingSpawn):
    """
    Displays weather from openweathermap.org
    """
    orientations = base.ORIENTATION_HORIZONTAL

    ABS_ZERO = 273.15
    URL = 'http://api.openweathermap.org/data/2.5/weather'

    def __init__(self, **config):
        f = open(os.path.expanduser('~/.config/qtile/weather_i18n.ini'), 'r')
        # self.i18n = {k: v.decode('utf-8') for k, v in [[p.strip() for p in line.split('=')] for line in filter(None, f.read().split('\n'))]}
        self.i18n = {k: v for k, v in [[p.strip() for p in line.split('=')] for line in filter(None, f.read().split('\n'))]}
        f.close()

        self.url = None
        for key in ('appid', 'location'):
            if key not in config:
                logger.error('Missing "{}" config parameter!'.format(key))
                return
        # config['update_interval'] = 60
        self.url = OpenWeatherMap.URL + '?' + urlencode(dict(
            q=config.pop('location'),
            appid=config.pop('appid')
        ))
        self.last_text = ''
        base._TextBox.__init__(self, **config)

    def _configure(self, *args, **kwargs):
        base._TextBox._configure(self, *args, **kwargs)
        self.do_fetch()

    def do_fetch(self):
        self.spawn(self._do_fetch, self.on_fetch_result)

    def _do_fetch(self):
        # logger.error('Fetch')
        if self.url is None:
            return 'N/A'
        try:
            response = json.loads(urlopen(self.url).read())
            # F0C2
            return u'\uF0E9  {name} {temp}\u00B0C'.format(
                city=response['name'],
                temp=int(response['main']['temp'] - OpenWeatherMap.ABS_ZERO),
                # name=response['weather'][0]['main']
                name=self.i18n.get(str(response['weather'][0]['id']), response['weather'][0]['main'])
            )
        except Exception as e:
            logger.exception(e.message)
            return 'ERROR'

    def on_fetch_result(self, result):
        if result == 'ERROR':
            self.timeout_add(10, self.do_fetch)
        else:
            self.timeout_add(300, self.do_fetch)

        self.text = result
        if len(self.last_text) != len(self.text):
            self.bar.draw()
        else:
            self.draw()


class NowPlayingWidget(base._TextBox, NonBlockingSpawn):
    """
    Displays current song from VKPlayer.
    https://github.com/and3rson/vkplayer

    Also uses my own IPC implementation.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    class VKPlayer(RedObject):
        def __init__(self, widget):
            logger.error('VKPlayer.__init__()')
            self.widget = proxy(widget)
            super(NowPlayingWidget.VKPlayer, self).__init__('org.dunai.vkplayer', logger)

        def on_connected_handler(self):
            logger.error('VKPlayer.on_connected_handler()')
            self.broadcast('request_state')

    def __init__(self, **config):
        self.is_downloading = False
        self.is_playing = False
        self.current_icon = '?'
        self.current_song = 'Empty'
        self.last_scroll = 0
        try:
            self.max_len = 1000
            self.prev_len = 0
            self.shifted = 0
            # self.sep = u'  \uf105\uf105\uf105   '
            self.sep = u'  \uf069    '
            # self.length = bar.STRETCH
            base._TextBox.__init__(self, width=bar.STRETCH, **config)

            self.vkplayer = NowPlayingWidget.VKPlayer(self)
        except Exception as e:
            logger.exception(e.message)

    def _configure(self, *args):
        super(NowPlayingWidget, self)._configure(*args)
        self.timeout_add(0.2, self._shift)
        self.poll()

    def poll(self):
        self.spawn(self.vkplayer.next_event, self.on_new_event)

    def on_new_event(self, event):
        if event is not None:
            if event.name == 'state_changed':
                self._update_state(*event.data)
            else:
                logger.error('Unknown event received: {}'.format(event.name))
        self.poll()

    # def timer_setup(self):
    #     def on_done(future):
    #         try:
    #             event = future.result()
    #         except Exception:
    #             self._update_state(False, False, 'Player is offline')
    #             logger.exception('next_event() raised exceptions')
    #         else:
    #             if event is not None:
    #                 if event.name == 'state_changed':
    #                     self._update_state(*event.data)
    #                 else:
    #                     logger.error('Unknown event received: {}'.format(event))
    #         self.timer_setup()

    #     future = self.qtile.run_in_executor(self.vkplayer.next_event)
    #     future.add_done_callback(on_done)

    def _shift(self, *args):
        self.timeout_add(0.2, self._shift)
        self._draw()
        self.shifted += 1
        if (self.shifted >= len(self.current_song) + len(self.sep)) or (len(self.current_song) != self.prev_len):
            self.shifted = 0
        self.prev_len = len(self.current_song)

    def _update_state(self, is_downloading, is_playing, current_song):
        try:
            self.is_downloading = is_downloading
            self.is_playing = is_playing

            # self.current_icon = u'\uF019' if is_downloading else u'\uF04B' if is_playing else u'\uF04C'
            self.current_icon = u'\uF04B' if is_playing else u'\uF04C'
            # self.current_icon = u'v' if is_downloading else u'>' if is_playing else u'x'

            # current_song = current_song
            self.current_song = current_song

            self._draw()
        except Exception as e:
            logger.exception(e.message)

    def _draw(self, redraw=False):
        # if len(self.current_song) > self.max_len:
        #     shifted_title = self.sep.join([self.current_song] * 10)[self.shifted:self.shifted + self.max_len + 3]
        # else:
        #     shifted_title = self.current_song.ljust(self.max_len + 3)
        shifted_title = self.sep.join([self.current_song] * 10)[self.shifted:128]
        self.text = u'{}  {}'.format(self.current_icon, shifted_title)
        if self.is_downloading:
            self.foreground = '#9999EE'
        elif self.is_playing:
            self.foreground = '#99EE99'
        else:
            self.foreground = '#EEEE99'

        self.draw()

    def _debounce(self):
        last_scroll = self.last_scroll
        self.last_scroll = time.time()

        if time.time() - last_scroll > 0.35:
            return True
        else:
            return False

    def button_press(self, x, y, button):
        if button == 1:
            # Left: play/pause
            self.vkplayer.broadcast('play_pause')

        elif button == 2:
            # Middle: random next
            self.vkplayer.broadcast('play_random')

        elif button == 4:
            # Scroll up
            if self._debounce():
                self.vkplayer.broadcast('play_prev')

        elif button == 5:
            # Scroll down
            if self._debounce():
                self.vkplayer.broadcast('play_next')


class NowPlayingWidget2(base._TextBox, NonBlockingSpawn):
    """
    Displays current song from VKPlayer.
    https://github.com/and3rson/vkplayer

    Also uses my own IPC implementation.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    class VKPlayer(RedObject):
        def __init__(self, widget):
            logger.error('VKPlayer.__init__()')
            self.widget = proxy(widget)
            super(NowPlayingWidget2.VKPlayer, self).__init__('org.dunai.vkplayer', logger)

        def on_connected_handler(self):
            logger.error('VKPlayer.on_connected_handler()')
            self.broadcast('request_state')

    def __init__(self, **config):
        self.is_downloading = False
        self.is_playing = False
        self.current_icon = '?'
        self.current_song = 'Empty'

        self.last_scroll = 0

        self.sep = ' ::: '
        self.max_len = 12
        self.shift = 0
        self.do_scroll = True
        self.last_song = None

        # base._TextBox.__init__(self, width=bar.STRETCH, **config)
        base._TextBox.__init__(self, **config)

        self.vkplayer = NowPlayingWidget2.VKPlayer(self)

    def _configure(self, *args):
        super(NowPlayingWidget2, self)._configure(*args)
        self.timeout_add(0.15, self._shift)
        self.poll()

    def poll(self):
        self.spawn(self.vkplayer.next_event, self.on_new_event)

    def on_new_event(self, event):
        if event is not None:
            if event.name == 'state_changed':
                self._update_state(*event.data)
            else:
                logger.error('Unknown event received: {}'.format(event))
        self.poll()

    def _update_state(self, is_downloading, is_playing, current_song):
        try:
            self.is_downloading = is_downloading
            self.is_playing = is_playing

            # self.current_icon = u'\uF019' if is_downloading else u'\uF04B' if is_playing else u'\uF04C'
            self.current_icon = u'\uF04B' if is_playing else u'\uF04C'
            self.current_icon = u'\u25b6' if is_playing else u'\u25a0'
            # self.current_icon = u'v' if is_downloading else u'>' if is_playing else u'x'

            # current_song = current_song
            self.current_song = current_song

            self._draw()
        except Exception as e:
            logger.exception(e.message)

    def _shift(self):
        self.shift += 1
        if self.last_song != self.current_song:
            self.shift = 0
            self.last_song = self.current_song
            self._draw(True)
        elif self.shift > len(self.current_song) + len(self.sep):
            self.shift = 0
            self._draw(True)
        else:
            self._draw()
        self.timeout_add(0.15, self._shift)

    def _draw(self, redraw=False):
        # shifted_song = (self.current_song + self.sep) * 5

        if len(self.current_song) < self.max_len:
            shifted_song = self.current_song
        else:
            filled_song = (self.current_song + self.sep) * 5
            shifted_song = filled_song[self.shift:self.shift + self.max_len]

        self.text = u'{} {}'.format(self.current_icon, shifted_song.ljust(self.max_len))

        if self.is_downloading:
            self.foreground = '#9999EE'
        elif self.is_playing:
            self.foreground = '#99EE99'
        else:
            self.foreground = '#EEEE99'

        if redraw:
            self.bar.draw()
        else:
            self.draw()

    def _debounce(self):
        last_scroll = self.last_scroll
        self.last_scroll = time.time()

        if time.time() - last_scroll > 0.35:
            return True
        else:
            return False

    def button_press(self, x, y, button):
        if button == 1:
            # Left: play/pause
            self.vkplayer.broadcast('play_pause')

        elif button == 2:
            # Middle: random next
            self.vkplayer.broadcast('play_random')

        elif button == 4:
            # Scroll up
            if self._debounce():
                self.vkplayer.broadcast('play_prev')

        elif button == 5:
            # Scroll down
            if self._debounce():
                self.vkplayer.broadcast('play_next')


class GPMDP(base._TextBox, NonBlockingSpawn):
    """
    Displays current song from VKPlayer.
    https://github.com/and3rson/vkplayer

    Also uses my own IPC implementation.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        self.is_downloading = False
        self.is_playing = False
        self.current_icon = '?'
        self.current_song = 'Empty'

        self.last_scroll = 0

        self.sep = ' ::: '
        self.max_len = 12
        self.shift = 0
        self.do_scroll = True
        self.last_song = None

        self.last_data = None

        self.file = os.path.expanduser('~/.config/Google Play Music Desktop Player/json_store/playback.json')

        # base._TextBox.__init__(self, width=bar.STRETCH, **config)
        base._TextBox.__init__(self, **config)

        # self.vkplayer = NowPlayingWidget2.VKPlayer(self)

    def _configure(self, *args):
        super(GPMDP, self)._configure(*args)
        self.timeout_add(0.15, self._shift)
        self.timeout_add(0.25, self.poll)
        self.poll()

    def poll(self):
        # self.spawn(self.vkplayer.next_event, self.on_new_event)
        try:
            if os.path.exists(self.file):
                f = open(self.file, 'r')
                data = json.loads(f.read())
                self._update_state(False, data['playing'], u' - '.join([data['song']['artist'], data['song']['title']]), data['song'])
                f.close()
            else:
                self._update_state(False, False, 'Not playing', None)

            self.timeout_add(0.25, self.poll)
        except Exception as e:
            logger.exception(str(e))
            self._update_state(False, False, 'Error', None)
            self.timeout_add(5, self.poll)

    def _update_state(self, is_downloading, is_playing, current_song, song):
        try:
            self.is_downloading = is_downloading
            self.is_playing = is_playing

            # self.current_icon = u'\uF019' if is_downloading else u'\uF04B' if is_playing else u'\uF04C'
            self.current_icon = u'\uF04B' if is_playing else u'\uF04C'
            self.current_icon = u'\u25b6' if is_playing else u'\u25a0'
            # self.current_icon = u'v' if is_downloading else u'>' if is_playing else u'x'

            # current_song = current_song
            if self.current_song != current_song and song:
                self._on_song_changed(song)
                self.current_song = current_song
            self._draw()
        except Exception as e:
            logger.exception(e.message)

    def _on_song_changed(self, song):
        def download():
            if 'albumArt' not in song:
                return None
            url = song['albumArt']
            out, err = Popen([os.path.expanduser('~/.config/qtile/bin/aart.sh'), url], stdout=PIPE, stderr=PIPE).communicate()
            fname = out.strip()
            notify('GPMDP', fname or 'multimedia-audio-player', u'{}'.format(song['title']), u'by {}'.format(song['artist']))
            return fname

        def on_complete(fname):
            pass

        self.spawn(download, on_complete)

    def _shift(self):
        self.shift += 1
        if self.last_song != self.current_song:
            self.shift = 0
            self.last_song = self.current_song
            self._draw(True)
        elif self.shift > len(self.current_song) + len(self.sep):
            self.shift = 0
            self._draw(True)
        else:
            self._draw()
        self.timeout_add(0.15, self._shift)

    def _draw(self, redraw=False):
        # shifted_song = (self.current_song + self.sep) * 5

        if len(self.current_song) < self.max_len:
            shifted_song = self.current_song
        else:
            filled_song = (self.current_song + self.sep) * 5
            shifted_song = filled_song[self.shift:self.shift + self.max_len]

        self.text = u'{} {}'.format(self.current_icon, shifted_song.ljust(self.max_len))

        if self.is_downloading:
            self.foreground = '#9999EE'
        elif self.is_playing:
            self.foreground = '#99EE99'
        else:
            self.foreground = '#EEEE99'

        if redraw:
            self.bar.draw()
        else:
            self.draw()

    def _debounce(self):
        last_scroll = self.last_scroll
        self.last_scroll = time.time()

        if time.time() - last_scroll > 0.35:
            return True
        else:
            return False

    def button_press(self, x, y, button):
        pass
        # if button == 1:
        #     # Left: play/pause
        #     self.vkplayer.broadcast('play_pause')

        # elif button == 2:
        #     # Middle: random next
        #     self.vkplayer.broadcast('play_random')

        # elif button == 4:
        #     # Scroll up
        #     if self._debounce():
        #         self.vkplayer.broadcast('play_prev')

        # elif button == 5:
        #     # Scroll down
        #     if self._debounce():
        #         self.vkplayer.broadcast('play_next')


class Volume2(Volume):
    """
    Patched version of Volume widget that shows icon font chars.
    Psst: I use nerd-fonts package for this.
    """
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

    def button_press(self, x, y, button):
        if button == 3:
            os.system('pavucontrol &')
        else:
            super(Volume2, self).button_press(x, y, button)


class ThermalSensor2(ThermalSensor):
    """
    Patched version of ThermalSensor widget that shows icon font chars.
    Psst: I use nerd-fonts package for this.
    """
    def poll(self):
        # logger.error('{} {}'.format(self.foreground_normal, self.foreground_alert))
        temp_values = self.get_temp_sensors()
        if temp_values is None:
            return False
        # F069
        # F135
        # text = u"\uF0E4 "
        text = ''
        if self.show_tag and self.tag_sensor is not None:
            text = self.tag_sensor + u": "
        parts = temp_values.get(self.tag_sensor, ['N/A'])
        # parts = [x.decode('utf-8') for x in parts]
        parts = [x for x in parts]
        parts[0] = str(int(float(parts[0])))
        text += u"".join(parts)
        temp_value = float(temp_values.get(self.tag_sensor, [0])[0])
        if temp_value > self.threshold:
            self.layout.colour = self.foreground_alert
        else:
            self.layout.colour = self.foreground_normal
        text += self.get_nvidia_temp()
        return text

    def get_nvidia_temp(self):
        try:
            ps = Popen(['nvidia-smi', '-q', '-d', 'temperature'], stdout=PIPE, stderr=PIPE)
        except:
            return u''
        out, err = ps.communicate()
        if ps.returncode == 0:
            try:
                temp = int(findall('GPU Current Temp\s*:\s*([\d]+)\s*C', out)[0])
                if temp > self.threshold:
                    self.layout.colour = self.foreground_alert
            except IndexError:
                return u''
            return u' / {}\u00B0C'.format(temp)
        else:
            return u''


class FanControl(base._TextBox, NonBlockingSpawn):
    """
    Displays time to next event in Google Calendar.
    Psst: I use nerd-fonts package for this.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        self.last_text = ''
        base._TextBox.__init__(self, **config)

    def _configure(self, qtile, bar):
        base._TextBox._configure(self, qtile, bar)
        self.do_update()

    def button_press(self, x, y, button):
        pass
        # if button == 1:
        #     self.qtile.currentScreen.setGroup(self.qtile.groupMap['m'])

    def do_update(self):
        self.spawn(self.get_speed, self.on_update_result)

    def get_speed(self):
        if socket.gethostname() == 'spawn':
            out, err = Popen(['nvidia-settings', '-q', 'GPUCurrentFanSpeedRPM'], stdout=PIPE, stderr=PIPE).communicate()
            value = int(findall(r'Attribute .*: ([\d]+)\.', out)[0])
        else:
            f = open(self.fan_input, 'r')
            value = int(f.read().strip())
            f.close()

        if value > 1000:
            self.foreground = self.foreground_alert
        else:
            self.foreground = self.foreground_normal

        return value

    def on_update_result(self, result):
        # \uf1eb
        # F0E4
        # self.text = u'\uF135  {} RPM'.format(result)
        self.text = u'{} RPM'.format(result)
        if len(self.text) != len(self.last_text):
            self.bar.draw()
        else:
            self.draw()
        self.last_text = self.text
        self.timeout_add(0.5, self.do_update)


class Battery2(Battery):
    """
    Patched version of Battery widget that shows icon font chars.
    Psst: I use nerd-fonts package for this.
    """
    def update(self):
        # f037
        # f011
        # self.update_delay = 1
        info = self._get_info()

        # if info:
        #     value = int(info['now'] / info['full'] * 100)

        #     if value > 100:
        #         value = 100
        #     if value < 0:
        #         value = 0

        #     if info['stat'] in ('Charging', 'Full'):
        #         self.foreground = self.foreground_charging
        #         style = 8
        #         if info['stat'] == 'Charging':
        #             char = '+'
        #         else:
        #             char = '='
        #     else:
        #         if value < 10:
        #             self.foreground = self.foreground_low
        #         else:
        #             self.foreground = self.foreground_normal
        #         style = 8
        #         char = '-'

        #     progress_bar = progress(0, 100, value, 5, style=style)
        #     ntext = u'{}{}{}%'.format(progress_bar, char, value)
        # else:
        #     self.foreground = self.foreground_normal
        #     ntext = u'\uF1E6'

        start = 0xF244
        info = self._get_info()

        if info:
            value = int(info['now'] / info['full'] * 100)

            if info['stat'] in ('Charging', 'Full'):
                icon_id = 0xF1E6

                self.foreground = self.foreground_charging
            else:
                if value > 100:
                    value = 100
                if value < 0:
                    value = 0

                if value == 100:  # full
                    icon_id = start - 4
                else:
                    icon_id = start - int(value / 20)

                if value < 10:
                    self.foreground = self.foreground_low
                else:
                    self.foreground = self.foreground_normal

            icon = unichr(icon_id)

            # icon = progress(0, 100, value, 5, style=16)
            # text = self._get_text()

            text = '{}%'.format(str(value))
        else:
            icon = unichr(0xF1E6)
            # text = 'No battery'
            text = ''

        # icon = unichr(icon_id)  # I could comment that out,
        # but then the linter gets mad.

        if text:
            ntext = u'{} {}'.format(icon, text)
        else:
            ntext = u'{}'.format(icon)
        if ntext != self.text:
            self.text = ntext
            self.bar.draw()


class UnreadMail(base._TextBox):
    """
    Displays count of unread messages in ThunderBird.
    Requires "Unread Count" plugin.

    https://addons.mozilla.org/en-US/thunderbird/addon/unread-count/?src=api

    Psst: I use nerd-fonts package for this.
    """
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

    def _ready(self):
        # \uf1eb
        self.text = u'\uf003  {}'.format(self.unread_count)
        self.foreground = '#AAAAAA' if self.unread_count == 0 else '#F05040'
        if len(self.text) != len(self.last_text):
            self.bar.draw()
        else:
            self.draw()
        self.last_text = self.text
        self.timeout_add(15, self._update)


class NextEvent(base._TextBox, NonBlockingSpawn):
    """
    Displays time to next event in Google Calendar.
    Psst: I use nerd-fonts package for this.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        self.last_text = ''
        base._TextBox.__init__(self, **config)

    def _configure(self, qtile, bar):
        base._TextBox._configure(self, qtile, bar)
        self.do_update()

    def button_press(self, x, y, button):
        pass
        # if button == 1:
        #     self.qtile.currentScreen.setGroup(self.qtile.groupMap['m'])

    def do_update(self):
        self.spawn(get_next_event, self.on_update_result)
        self.timeout_add(60, self.do_update)

    def on_update_result(self, result):
        # \uf1eb
        self.text = u'\uf073  {}'.format(result)
        self.foreground = '#00FFDD'
        if len(self.text) != len(self.last_text):
            self.bar.draw()
        else:
            self.draw()
        self.last_text = self.text


class GroupBox2(GroupBox):
    """
    A patched version of GroupBox that shows info
    # about active groups of each monitor.
    """
    defaults = GroupBox.defaults + [
        (
            "other_current_screen_border",
            "215578",
            "Border or line colour for current group on other screen."
        ),
    ]

    NUMBERS = {
        1: u'\u0323',
        2: u'\u0324',
        # 1: u'\u0329',
        # 2: u'\u0348',
        # 1: u'\u2071',
        # 2: u'\u00B2',
        3: u'\u00B3',
        4: u'\u2074',
        5: u'\u2075',
        6: u'\u2076',
        7: u'\u2077',
        8: u'\u2078',
        9: u'\u2079',
    }

    CHARS = {
        # 1: u'\u0307',
        # 2: u'\u0308',
        # 3: u'\u20DB',
        # 'DEFAULT': u'\u0303'
        1: u'\u0323',
        2: u'\u0324',
        'DEFAULT': u'\u0331'
    }

    def get_group_text(self, group):
        window_count = len(group.windows)

        # group_name = group.name.upper()
        group_name = group.name

        if window_count:
            return u'{}{}'.format(
                group_name,
                # u'\u2071' * window_count
                GroupBox2.CHARS.get(window_count, GroupBox2.CHARS.get('DEFAULT'))
                # GroupBox2.NUMBERS.get(window_count)
                # '+' * window_count
                # self.NUMBERS.get(window_count, self.NUMBERS.get(9) + '+')
            )
        else:
            return group_name

    def box_width(self, groups):
        width, height = self.drawer.max_layout_size(
            [self.get_group_text(i) for i in groups],
            self.font,
            self.fontsize
        )
        width += 6
        return width + self.padding_x * 2 + self.margin_x * 2 + \
            self.borderwidth * 2

    def draw(self):
        self.drawer.clear(self.background or self.bar.background)

        offset = 0
        for i, g in enumerate(self.groups):
            to_highlight = False

            is_block = False
            is_line = False

            bw = self.box_width([g])

            if self.group_has_urgent(g) and self.urgent_alert_method == "text":
                text_color = self.urgent_text
            elif g.windows:
                text_color = self.active
            else:
                text_color = self.inactive

            if g.screen:
                if self.highlight_method == 'text':
                    border = self.bar.background
                    text_color = self.this_current_screen_border
                else:
                    if self.bar.screen.group.name == g.name:
                        # This is active group
                        if self.qtile.currentScreen == self.bar.screen:
                            # Current screen
                            border = self.this_screen_border
                            to_highlight = True
                            is_block = True
                        else:
                            # Other screen
                            border = self.other_current_screen_border
                            is_line = False
                    else:
                        # This is inactive group
                        if self.qtile.currentScreen != self.bar.screen:
                            # Other screen
                            border = self.other_screen_border
                            is_line = False
                        else:
                            # Current screen
                            border = self.this_current_screen_border
                            to_highlight = True
                            is_block = True
            elif self.group_has_urgent(g) and \
                    self.urgent_alert_method in ('border', 'block', 'line'):
                border = self.urgent_border
                if self.urgent_alert_method == 'block':
                    is_block = True
                elif self.urgent_alert_method == 'line':
                    is_line = True
            else:
                border = self.background or self.bar.background

            self.drawbox(
                self.margin_x + offset,
                self.get_group_text(g),
                border,
                text_color,
                highlight_color=self.highlight_color,
                width=bw - self.margin_x * 2 - self.padding_x * 2,
                rounded=self.rounded,
                block=is_block,
                line=is_line,
                highlighted=to_highlight
            )
            offset += bw
        self.drawer.draw(offsetx=self.offset, width=self.width)


class TaskList2(TaskList):
    """
    A patch version of TaskList widget that fixes icon positions.
    """
    def draw_icon(self, surface, offset):
        if not surface:
            return

        x = offset + self.padding_x + self.borderwidth + 2 + self.margin_x + self.padding_x_extra
        y = self.padding_y + self.borderwidth + self.padding_y_extra

        self.drawer.ctx.save()
        self.drawer.ctx.translate(x, y)
        self.drawer.ctx.scale(0.95, 0.95)
        self.drawer.ctx.set_source(surface)
        self.drawer.ctx.paint()
        self.drawer.ctx.restore()

    def draw(self):
        self.drawer.clear(self.background or self.bar.background)
        offset = 0

        # logger.error('C: {}'.format(self.qtile.currentLayout.clients))

        for i, w in enumerate(self.bar.screen.group.windows):
        # for i, w in enumerate(self.qtile.currentLayout.clients):
            state = ''
            if w is None:
                pass
            elif w.maximized:
                state = '[X]'
            elif w.minimized:
                state = '[_]'
            elif w.floating:
                state = '[F]'
            else:
                state = '[%d]' % (i + 1)
                # state = ''

            # if w:
            #     # name = w.name
            #     try:
            #         name = w.cmd_inspect()['wm_class'][1][:8]
            #     except Exception:
            #         name = w.name
            # else:
            #     name = '?'

            # task = "%d %s%s" % (i + 1, state, name)

            # task = "%d%s" % (i + 1, state)

            task = state

            if w.urgent:
                border = self.urgent_border
                text_color = border
            elif w is w.group.currentWindow:
                border = self.border
                text_color = border
            else:
                border = self.background or self.bar.background
                text_color = self.foreground

            if self.highlight_method == 'text':
                border = self.bar.background
            else:
                text_color = self.foreground

            # logger.error(u'WIN: {}, {}, {}'.format(w.name, len(w.icons), self.get_window_icon(w)))

            bw = self.box_width(task)
            self.drawbox(
                self.margin_x + offset,
                task,
                border,
                text_color,
                rounded=self.rounded,
                block=(self.highlight_method == 'block'),
                width=(bw - self.margin_x * 2 - self.padding_x * 2),
                icon=self.get_window_icon(w),
            )

            offset += bw + self.icon_size
        self.drawer.draw(offsetx=self.offset, width=self.width)

    def get_clicked(self, x, y):
        window = None
        new_width = width = 0
        for w in self.bar.screen.group.windows:
            if w:
                # name = w.name
                name = w.cmd_inspect()['wm_class'][1]
            else:
                name = '?'
            # new_width += self.icon_size + self.box_width("[%d] %s%s" % (0, '?', name))
            new_width += self.icon_size + self.box_width('[W]')
            if width <= x <= new_width:
                window = w
                break
            width = new_width
        return window


class ArchLogo(base._TextBox):
    """
    Displays a cute Arch Linux icon.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    defaults = [
        ('scale', 1, 'Scale factor, defaults to 1'),
    ]

    def __init__(self, **config):
        base._TextBox.__init__(self, "", **config)
        self.add_defaults(ArchLogo.defaults)
        self.scale = 1.0 / self.scale

        self.length_type = bar.STATIC
        self.length = 0

    def _configure(self, qtile, bar):
        base._TextBox._configure(self, qtile, bar)
        self.text = ''
        self.surface = None
        self.setup_images()

    def draw(self):
        self.drawer.clear(self.background or self.bar.background)
        self.drawer.ctx.set_source(self.surface)
        self.drawer.ctx.paint()
        self.drawer.draw(offsetx=self.offset, width=self.length)

    def setup_images(self):
        img = cairocffi.ImageSurface.create_from_png(os.path.expanduser('~/.icons/arch-white.png'))

        input_width = img.get_width()
        input_height = img.get_height()

        sp = float(input_height) / (self.bar.height - 1)

        width = float(input_width) / sp
        if width > self.length:
            self.length = int(width) + self.actual_padding * 2

        imgpat = cairocffi.SurfacePattern(img)

        scaler = cairocffi.Matrix()

        scaler.scale(sp, sp)
        scaler.scale(self.scale, self.scale)
        factor = (1 - 1 / self.scale) / 2
        scaler.translate(-width * factor, -width * factor)
        scaler.translate(self.actual_padding * -1, 0)
        imgpat.set_matrix(scaler)

        imgpat.set_filter(cairocffi.FILTER_BEST)
        self.surface = imgpat


class DiskUsage(base._TextBox, NonBlockingSpawn):
    """
    Displays dist usage info.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        base._TextBox.__init__(self, **config)

    def _configure(self, *args, **kwargs):
        base._TextBox._configure(self, *args, **kwargs)
        self.do_process()

    def do_process(self):
        self.spawn(self._do_process, self.on_process_result)

    def _do_process(self):
        statvfs = os.statvfs(self.root)

        return (
            statvfs.f_frsize * statvfs.f_blocks,  # Size of filesystem in bytes
            statvfs.f_frsize * statvfs.f_bfree,  # Actual number of free bytes
            statvfs.f_frsize * statvfs.f_bavail  # Number of free bytes that ordinary users
        )

    def on_process_result(self, result):
        size, _, free = result
        self.update(size, free)

        self.timeout_add(5, self.do_process)

    def button_press(self, x, y, button):
        pass

    def sizeof_fmt(self, num, suffix='B'):
        for unit in ['', 'Ki', 'Mi', 'Gi', 'Ti', 'Pi', 'Ei', 'Zi']:
            if abs(num) < 1024.0:
                # return "%3.1f%s%s" % (num, unit, suffix)
                return "%3d %s%s" % (num, unit, suffix)
            num /= 1024.0
        return "%.1f%s%s" % (num, 'Yi', suffix)

    def update(self, size, free):
        # \uf1eb
        # free_factor = 1 - free / size
        # self.foreground = '#%02x%02x00' % (free_factor * 127 + 128, (1 - free_factor) * 127 + 128)
        if 1 - free / size < 0.1:
            self.foreground = self.foreground_alert
        else:
            self.foreground = self.foreground_normal
        self.text = u'{} {}'.format(progress(0, size, size - free, 5, style=8, before='', after=''), self.sizeof_fmt(free))
        self.bar.draw()


class PAControl(base._TextBox, NonBlockingSpawn):
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        self.order = [
            (compile(r'^bluez(.*)'), u'\uf025'),
            (compile(r'(.*)analog-stereo$'), u'\uf028')
        ]
        self.sink = None
        self.busy = Lock()
        self.p = Pulse()
        base._TextBox.__init__(self, **config)

    def _configure(self, *args, **kwargs):
        base._TextBox._configure(self, *args, **kwargs)
        self.do_process()

    def do_process(self):
        self.spawn(self._do_process, lambda result: (self.timeout_add(1, self.do_process), self.on_process_result(result)))

    def _do_process(self):
        if self.busy.locked():
            return
        self.busy.acquire()
        try:
            sinks = self.p.sink_list()
            for pattern, name in self.order:
                for sink in sinks:
                    if pattern.match(sink.name):
                        return sink, name
        except Exception as e:
            self.busy.release()
            logger.exception(e.message)
            return None
        return sinks[0], 'Default'

    def on_process_result(self, result):
        if not result:
            return
        sink, name = result
        self.text = u'{} {}%'.format(
            name,
            int(round(sink.volume.value_flat * 100)) if not sink.mute else 'M'
        )
        self.sink = sink
        self.draw()
        self.busy.release()

    def button_press(self, x, y, button):
        if button in (1, 2):
            self.toggle_mute()
            self.spawn(self._do_process, self.on_process_result)
        elif button == 3:
            os.system('pavucontrol &')
        elif button == 4:
            self.modify_volume(0.04)
        elif button == 5:
            self.modify_volume(-0.04)

    def modify_volume(self, change):
        if not self.sink:
            return
        if self.busy.locked():
            return
        self.busy.acquire()
        self.p.volume_change_all_chans(self.sink, change)
        self.busy.release()
        self.spawn(self._do_process, self.on_process_result)

    def toggle_mute(self):
        if not self.sink:
            return
        if self.busy.locked():
            return
        self.busy.acquire()
        self.p.mute(self.sink, not self.sink.mute)
        self.busy.release()
        self.spawn(self._do_process, self.on_process_result)

    def cmd_increase_volume(self):
        self.modify_volume(0.04)

    def cmd_decrease_volume(self):
        self.modify_volume(-0.04)

    def cmd_toggle_mute(self):
        self.toggle_mute()


class Backlight2(Backlight):
    def poll(self):
        return u'\uf0eb {}'.format(super(Backlight2, self).poll().strip())


class Hostname(base.ThreadedPollText):
    """
    Shows current keyboard layout.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        config['update_interval'] = 60
        base.ThreadedPollText.__init__(self, **config)

    def button_press(self, x, y, button):
        pass

    def poll(self):
        # f0ac
        return socket.gethostname().upper()


class DoomsdayClock(base._TextBox, NonBlockingSpawn):
    """
    Shows current keyboard layout.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        base._TextBox.__init__(self, **config)

    def _configure(self, *args, **kwargs):
        base._TextBox._configure(self, *args, **kwargs)
        self.do_fetch()

    def do_fetch(self):
        self.spawn(self._fetch, self._on_fetch)

    def _fetch(self):
        opener = urllib2.build_opener()
        opener.addheaders = [('User-Agent', 'Mozilla/5.0')]
        try:
            response = opener.open('http://thebulletin.org/timeline')
            doc = BS(response.read())
            match = findall('it is( still)? ([\w\s]+) minutes', doc.select_one('.view-doomsday-clock .views-row-first .node-title').text.lower())
            # logger.error('M: %s', str(match))
            msg = match[0][1]

            replaces = {
                'one': '1',
                'two': '2',
                'three': '3',
                'four': '4',
                'five': '5',
                'six': '6',
                'seven': '7',
                'eight': '8',
                'nine': '9',
                'ten': '10',
                'eleven': '11',
                'twelve': '12',
                ' and a half': ',5'
            }

            for k, v in replaces.items():
                msg = msg.replace(k, v)

            return msg
        except Exception as e:
            logger.exception(e.message)
            return None

    def _on_fetch(self, result):
        if result:
            # logger.error('Fetched: %s', result)
            self.text = u'\u2622 {} m.t.m.'.format(result)
            self.timeout_add(300, self.do_fetch)
        else:
            self.text = u'...'.format(result)
            self.timeout_add(5, self.do_fetch)
        self.bar.draw()

    def button_press(self, x, y, button):
        pass


class BluetoothInfo(base._TextBox, NonBlockingSpawn):
    """
    Shows current keyboard layout.
    """
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        base._TextBox.__init__(self, **config)

    def _configure(self, *args, **kwargs):
        base._TextBox._configure(self, *args, **kwargs)
        self.adapter = bt.get_adapter()
        self.do_fetch()

    def do_fetch(self):
        self.spawn(self._fetch, self._on_fetch)

    def _fetch(self):
        try:
            return ', '.join(bt.get_connected_devices(self.adapter))
        except Exception as e:
            logger.exception(e.message)
            return None

    def _on_fetch(self, result):
        if result:
            # logger.error('Fetched: %s', result)
            ntext = u'\uf294  {}'.format(result)
            self.timeout_add(5, self.do_fetch)
        else:
            ntext = u'\uf294  No devices'.format(result)
            self.timeout_add(2, self.do_fetch)

        if self.text != ntext:
            self.text = ntext
            self.bar.draw()
        self.text = ntext

    def button_press(self, x, y, button):
        if button == 3:
            os.system('blueman-manager &')
