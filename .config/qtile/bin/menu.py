#!/usr/bin/env python2

import os
from collections import namedtuple
from subprocess import Popen, PIPE, call

DMENU = [
    'dmenu',
    '-i', '-nb', '#000', '-nf', '#fff', '-sb', '#F05040', '-sf', '#000',
    '-l', '30', '-fn', 'DejaVu Sans Mono-10', '-dim', '0.5', '-p', 'cmd?'
]


MenuItemType = namedtuple('MenuItemType', ('id', 'title', 'cmd'))


def get_menu():
    f = open(os.path.expanduser('~/.config/qtile/menu.conf'), 'r')
    data = f.read()
    f.close()
    items = [map(lambda x: x.strip(), line.split(':')) for line in filter(None, data.split('\n'))]
    return [MenuItemType(id, title, cmd) for (id, (title, cmd)) in enumerate(items)]


if __name__ == '__main__':
    menu = get_menu()
    p = Popen(DMENU, stdin=PIPE, stdout=PIPE)
    out = p.communicate(u'\n'.join([u'{}: {}'.format(item.id, item.title) for item in menu]).encode('utf-8'))[0]
    id = out.strip().split(':')[0]
    if id:
        id = int(id)
        selected_item = [item for item in menu if item.id == id][0]
        os.system(selected_item.cmd)
