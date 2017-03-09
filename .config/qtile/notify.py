#!/usr/bin/env python2

import os
import sys
from subprocess import Popen, PIPE


def notify(app_name, icon, title, message):
    args = [
        os.path.expanduser('~/.config/qtile/notify_dbus.py'),
        app_name,
        icon,
        title,
        message
    ]
    ps = Popen(args, stdout=PIPE, stderr=PIPE)
    out, err = ps.communicate()
    sys.stdout.write(out)
    sys.stderr.write(err)
    sys.exit(ps.returncode)
