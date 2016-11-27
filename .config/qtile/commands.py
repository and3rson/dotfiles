from libqtile import hook
from libqtile.log_utils import logger
import os
import subprocess
import re
from utils import NonBlockingSpawn


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


class WindowSelector(NonBlockingSpawn):
    """
    Starts dmenu with a list of windows.

    Kind credits to zordsdavini
    https://github.com/qtile/qtile-examples/tree/master/zordsdavini/bin
    """
    def __init__(self):
        pass

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
        try:
            # call dmenu
            DMENU = [
                'dmenu',
                '-i', '-nb', '#000', '-nf', '#fff', '-sb', '#F05040', '-sf', '#000',
                '-l', '30', '-fn', 'DejaVu Sans Mono-10', '-dim', '0.5', '-p', 'window?',
                '-x', str(screen['width'] / 2 - 200), '-y', str(screen['height'] / 2 - 120), '-w', '400', '-h', '22'
            ]
            p = subprocess.Popen(DMENU, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
            out = p.communicate(u"\n".join(self.wins).encode('utf-8'))[0]
            return out
        except Exception as e:
            logger.exception(e.message)

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


class DMenu(object):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def __call__(self, qtile):
        screen = qtile.currentScreen.cmd_info()
        os.system('''dmenu_run -fn 'DejaVu Sans Mono-10' -sb '#F05040' -sf '#000' -nb black -dim 0.5 -p '>' -l 10 -x {x} -y {y} -w {w} -h 22'''.format(
            x=(screen['width'] - self.width) / 2,
            y=(screen['height'] - self.height) / 2,
            w=self.width
        ))
