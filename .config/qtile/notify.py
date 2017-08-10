#!/usr/bin/env python2

import os
# import sys
from subprocess import Popen, PIPE


IDS = {}


def notify(app_name, icon, title, message):
    if app_name in IDS:
        id = str(IDS[app_name])
    else:
        id = ''
    args = [
        os.path.expanduser('~/.config/qtile/notify_dbus.py'),
        app_name,
        icon,
        title,
        message,
        id
    ]
    ps = Popen(args, stdout=PIPE, stderr=PIPE)
    out, err = ps.communicate()
    print('Notification ID:', out.strip())
    IDS[app_name] = int(out.strip())
    # sys.stdout.write(out)
    # sys.stderr.write(err)
    # sys.exit(ps.returncode)
