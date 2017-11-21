#!/usr/bin/env python3
from urllib.request import urlopen
import pyinotify
import json
import os
import subprocess
import hashlib


PATH = '~/.config/Google Play Music Desktop Player/json_store/playback.json'
AART_DIR = '~/.cache/aart'


class App(pyinotify.ProcessEvent):
    def __init__(self, path, aart_dir):
        super().__init__()

        path = os.path.expanduser(path)
        self.path = path

        aart_dir = os.path.expanduser(aart_dir)
        self.aart_dir = aart_dir

        self.wm = pyinotify.WatchManager()
        self.notifier = pyinotify.Notifier(self.wm, self)
        self.wm.add_watch(path, pyinotify.IN_CLOSE_WRITE)

        self.last_song_hash = None
        self.last_notification_id = '0'

    def run(self):
        self.notifier.loop()

    def process_IN_CLOSE(self, event):
        self.update()

    def update(self):
        with open(self.path, 'r') as f:
            try:
                data = json.loads(f.read())
            except:
                return
            song, time = data['song'], data['time']
            song_hash = hash(song['artist'] + song['title'])
            if song_hash != self.last_song_hash:
                self.last_song_hash = song_hash
                self.song_changed(song, time)

    def song_changed(self, song, time):
        """
            + '\n(%02d:%02d)' % (
                time['total'] // 60000,
                (time['total'] // 1000) % 60
            ),
        """
        icon = self.get_album_art_icon(song['albumArt'])
        ps = subprocess.Popen(map(lambda x: x.encode('utf-8'), [
            os.path.expanduser('~/.config/qtile/notify_dbus.py'),
            'GPMDP',
            icon,
            song['title'],
            'by ' + song['artist'] + '\n@ ' + song['album'],
            self.last_notification_id
        ]), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = ps.communicate()
        self.last_notification_id = out.strip().decode('utf-8')

    def get_album_art_icon(self, url):
        md5 = hashlib.md5()
        md5.update(url.encode('utf-8'))
        md5 = md5.hexdigest()

        fname = os.path.join(self.aart_dir, md5 + '.png')

        if not os.path.exists(fname):
            response = urlopen(url)
            with open(fname, 'wb') as f:
                f.write(response.read())

        return fname


app = App(PATH, AART_DIR)
app.run()

