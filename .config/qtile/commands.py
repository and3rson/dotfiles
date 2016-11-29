from libqtile import hook
from libqtile.log_utils import logger
from collections import namedtuple
import os
import subprocess
import re
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
