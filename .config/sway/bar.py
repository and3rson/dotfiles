#!/usr/bin/env python3
import asyncio
from datetime import datetime
from threading import Thread
import psutil
import gi
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib

class Widget:
    def __init__(self, notifications):
        self.content = ''
        self.notifications = notifications
        self.loop = asyncio.get_event_loop()

    async def start(self):
        raise NotImplementedError()

    async def updated(self):
        await self.notifications.put([self, 'updated'])

class Player(Widget):
    async def start(self):
        self.manager = Playerctl.PlayerManager()
        for name in self.manager.props.player_names:
            self.manage_player(self.manager, name)
        self.manager.connect('name-appeared', self.manage_player)

        loop = GLib.MainLoop()
        await asyncio.get_event_loop().run_in_executor(None, loop.run)

    def manage_player(self, manager, name):
        print('manage', name)
        player = Playerctl.Player.new_from_name(name)
        player.connect('metadata', self.on_metadata)
        manager.manage_player(player)

    def on_metadata(self, player, data):
        components = []
        if 'xesam:artist' in data.keys():
            components.append(', '.join(data['xesam:artist']))
        if 'xesam:title' in data.keys():
            components.append(data['xesam:title'])
        if len(components) == 2:
            components = [' - '.join(components)]
        if 'mpris:length' in data.keys():
            length = int(data['mpris:length'] / 1000000)
            minutes, seconds = int(length / 60), length % 60
            components.append(f'({minutes:02d}:{seconds:02d})')
        self.content = ' '.join(components)
        print('c', self.content)
        asyncio.run_coroutine_threadsafe(self.updated(), self.loop)

class Time(Widget):
    async def start(self):
        while True:
            self.content = datetime.now().strftime('%H:%M:%S')
            await self.updated()
            await asyncio.sleep(1)

class CPU(Widget):
    async def start(self):
        while True:
            self.content = f'{int(psutil.cpu_percent(0)):2d}%'
            await self.updated()
            await asyncio.sleep(0.25)

async def main():
    config = [Player, CPU, Time]
    sep = ' | '

    notifications = asyncio.Queue()
    widgets = [widget(notifications) for widget in config]
    for widget in widgets:
        asyncio.create_task(widget.start())
    while True:
        try:
            notification = await asyncio.wait_for(notifications.get(), timeout=1)
        except asyncio.TimeoutError:
            pass
        else:
            first = True
            for widget in widgets:
                if not first:
                    print(sep, end='')
                print(widget.content, end='')
                first = False
            print('')

if __name__ == '__main__':
    asyncio.run(main())
