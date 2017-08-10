#!/usr/bin/env python2

import sys
import dbus

bus = dbus.SessionBus()

notif = bus.get_object(
    "org.freedesktop.Notifications",
    "/org/freedesktop/Notifications"
)
notify_interface = dbus.Interface(notif, "org.freedesktop.Notifications")


last_id = 0


def notify(app_name, icon, title, message, id):
    global last_id

    if not id.isdigit():
        id_num_to_replace = last_id
    else:
        id_num_to_replace = id
    # actions_list = dict(default='asd', Close='asdasd')
    actions_list = ''
    # if progress:
    #     hint = dict(value=progress)
    # else:
    #     hint = ''
    hint = dict()

    last_id = notify_interface.Notify(
        app_name, id_num_to_replace,
        icon, title, message,
        actions_list, hint, 7000
    )

    return last_id


if __name__ == '__main__':
    if len(sys.argv) < 5:
        sys.stderr.write('Usage: ./notify.py {app_name} {icon} {title} {message}\n')
        sys.exit(1)
    else:
        print(notify(*sys.argv[1:]))

