from libqtile import hook
from libqtile.log_utils import logger
from collections import namedtuple
import os
import subprocess
import re
from glob import glob
from utils import NonBlockingSpawn, DMenu


class ToggleTerm(object):
    """
    Allows to quickly toggle to first pane and back (Guake-style.)
    """
    def __init__(self):
        self.prev = None
        self.do_not_clean = False
        hook.subscribe.setgroup(self.reset_prev)

    def __call__(self, qtile):
        if self.prev is None:
            self.prev = qtile.currentGroup
            self.do_not_clean = True
            qtile.currentScreen.setGroup(qtile.groupMap['t'])
        else:
            qtile.currentScreen.setGroup(self.prev)
            self.prev = None

    def reset_prev(self, *args):
        if self.do_not_clean:
            self.do_not_clean = False
            return
        self.prev = None


class FixGroups(object):
    """
    Reassigns windows to their matching groups.
    Useful once some damn window gets into a wrong group.
    """
    def __init__(self):
        pass

    def __call__(self, qtile):
        for client in qtile.windowMap.values():
            for rule in qtile.dgroups.rules:
                if rule.matches(client):
                    if rule.group and hasattr(client, 'togroup'):
                        client.togroup(rule.group)


class SwitchScreen(object):
    """
    Switches to a group on the next monitor.
    """

    def __call__(self, qtile):
        screens = qtile.cmd_screens()
        index = qtile.currentScreen.cmd_info()['index']
        if len(screens) - index > 1:
            next_index = index + 1
        else:
            next_index = 0
        qtile.cmd_to_screen(next_index)


class DMenuWindowSelector(NonBlockingSpawn, DMenu, object):
    """
    Starts dmenu with a list of windows.

    Kind credits to zordsdavini
    https://github.com/qtile/qtile-examples/tree/master/zordsdavini/bin
    """
    def __init__(self, **style):
        super(DMenuWindowSelector, self).__init__(p='window?', **style)

    def __call__(self, qtile):
        self.qtile = qtile

        # get info of windows
        self.wins = []
        self.id_map = {}
        id = 0
        for win in qtile.cmd_windows():
            if win["group"]:
                self.wins.append(u"%i: %s (%s)" % (id, win["name"], win["group"]))
                self.id_map[id] = {
                    'id': win['id'],
                    'group': win['group']
                }
                id = id + 1

        self.qtile = qtile
        screen = qtile.currentScreen.cmd_info()
        self.spawn(lambda: self.execute(screen), self.on_execute_result)

    def execute(self, screen):
        # try:
        #     # call dmenu
        #     DMENU = [
        #         'dmenu',
        #         '-i', '-nb', '#000', '-nf', '#fff', '-sb', '#F05040', '-sf', '#000',
        #         '-l', '30', '-fn', 'DejaVu Sans Mono-10', '-dim', '0.5', '-p', 'window?',
        #         '-x', str(screen['width'] / 2 - 200), '-y', str(screen['height'] / 2 - 120), '-w', '400', '-h', '22'
        #     ]
        #     p = subprocess.Popen(DMENU, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        #     out = p.communicate(u"\n".join(self.wins).encode('utf-8'))[0]
        #     return out
        # except Exception as e:
        #     logger.exception(e.message)
        return self.run_menu(self.wins)

    def on_execute_result(self, out):
        # get selected window info
        match = re.match(b"^\d+", out)
        if match:
            id = int(match.group())
            win = self.id_map[id]

            # focusing selected window
            for window in self.qtile.cmd_windows():
                if window['id'] == win['id']:
                    self.qtile.groupMap[window['group']].cmd_toscreen()

                    g = [group for group in self.qtile.groups if group.name == window['group']][0]
                    w = [x for x in g.windows if x.window.wid == window['id']][0]

                    for i in range(len(g.info()['windows'])):
                        g.layout.cmd_next()
                        if w.cmd_inspect()['attributes']['map_state']:
                            break


class DMenuAppLauncher(NonBlockingSpawn, DMenu, object):
    def __init__(self, **style):
        super(DMenuAppLauncher, self).__init__(run=True, p='app?', **style)

    def __call__(self, qtile):
        self.qtile = qtile
        self.spawn(self.run_menu, lambda *args: None)


class DMenuCustomMenu(NonBlockingSpawn, DMenu, object):
    MenuItemType = namedtuple('MenuItemType', ('id', 'title', 'cmd'))

    def __init__(self, **style):
        super(DMenuCustomMenu, self).__init__(run=False, p='app?', **style)

    def get_menu(self):
        f = open(os.path.expanduser('~/.config/qtile/menu.conf'), 'r')
        data = f.read()
        f.close()
        items = [map(lambda x: x.strip(), (line.partition(':')[0], line.partition(':')[2])) for line in filter(None, data.split('\n'))]
        return [DMenuCustomMenu.MenuItemType(id, title, cmd) for (id, (title, cmd)) in enumerate(items)]

    def __call__(self, qtile):
        self.menu = self.get_menu()
        self.qtile = qtile
        self.spawn(lambda: self.run_menu([u'{}: {}'.format(item.id, item.title) for item in self.menu]), self.on_result)

    def on_result(self, result):
        id = result.strip().partition(':')[0]
        if id:
            id = int(id)
            selected_item = [item for item in self.menu if item.id == id][0]
            self.spawn(lambda: os.system(selected_item.cmd), lambda *args: None)


class DMenuAppsCollectorMenu(NonBlockingSpawn, DMenu, object):
    PATHS = [
        '/usr/share/applications/*.desktop',
        os.path.expanduser('~/.local/share/applications/*.desktop')
    ]

    def __init__(self, **style):
        super(DMenuAppsCollectorMenu, self).__init__(run=False, p='desktop?', **style)

    def __call__(self, qtile):
        self.qtile = qtile
        self.spawn(self.collect_apps, self.on_result)

    def collect_apps(self):
        apps = list(self._build_menu_items())

        # for app in apps:
        return apps, self.run_menu(['{}: {}'.format(i, name) for (i, (name, cmd)) in enumerate(apps)])

    def on_result(self, result):
        apps, output = result
        id = output.strip().partition(':')[0]
        if id:
            id = int(id)
            self.qtile.cmd_spawn(apps[id][1])

    def _get_desktop_files(self):
        for path in DMenuAppsCollectorMenu.PATHS:
            for file in glob(path):
                yield file

    def _read_desktop_file(self, file):
        f = open(file, 'r')
        content = f.read()
        f.close()
        name = None
        cmd = None
        for line in filter(None, content.split('\n')):
            key, _, value = line.partition('=')
            if key.lower() == 'name':
                name = value.strip()
            elif key.lower() == 'exec':
                cmd = value.strip()

        return name, cmd

    def _build_menu_items(self):
        for path in self._get_desktop_files():
            name, cmd = self._read_desktop_file(path)
            if name and cmd:
                yield name, cmd


class ToWindow(object):
    def __init__(self, id):
        self.id = id

    def __call__(self, qtile):
        # print self.id
        try:
            logger.error(list(qtile.currentGroup.windows))
            window = list(qtile.currentGroup.windows)[self.id - 1]
            window.group.focus(window, False)
        except IndexError:
            logger.error('dafuq')
            pass
        # for w in qtile.cmd_windows():
        #     if w['group'] == qtile.currentGroup.name:
        #         logger.error(str(w))
        #     # logger.error(u'w: {}'.format(str(w)))
        #     # logger.error(str(w['group']))
        #     # if w['group'] == qtile.currentGroup.name:
        #     #     logger.error(u'w: {}'.format(str(w)))
