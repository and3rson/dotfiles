#!/usr/bin/env python2

"""Python 2.5 script. Creates a Notification pop-up bubble"""
import dbus
import os
from time import sleep, time
from subprocess import Popen, PIPE
import pyperclip

bus = dbus.SessionBus()

notif = bus.get_object(
    "org.freedesktop.Notifications",
    "/org/freedesktop/Notifications"
)
notify_interface = dbus.Interface(notif, "org.freedesktop.Notifications")


last_id = 0


sleep(0.25)


def notify(icon, title, message, progress=None, timeout=0):
    global last_id

    app_name = "SShot"
    id_num_to_replace = last_id
    # actions_list = dict(default='asd', Close='asdasd')
    actions_list = ''
    if progress:
        hint = dict(value=progress)
    else:
        hint = ''

    last_id = notify_interface.Notify(
        app_name, id_num_to_replace,
        icon, title, message,
        actions_list, hint, timeout
    )


def main():
    fname = '{}.jpg'.format(str(time()).replace('.', ''))
    fpath = '/tmp/{}'.format(fname)

    notify(
        'info',
        'Screenshot',
        'Select area to capture.',
        timeout=1500
    )

    scrot = Popen(['scrot', '-s', fpath], stdout=PIPE, stderr=PIPE)
    stdout, stderr = scrot.communicate()

    if scrot.returncode:
        notify(
            'error',
            'Error',
            'Failed to grab screenshot!\nError was: {}'.format(stderr),
            timeout=3000
        )
        os.exit(1)

    notify('image-loading', 'Please wait', 'Uploading image. Please wait...')

    # pyperclip.copy('http://public.dun.ai/public/screenshots/{}'.format(fname))
    # p = Popen(['xclip', '-i', '-selection', 'clipboard'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
    # p.stdin.write('http://public.dun.ai/public/screenshots/{}'.format(fname))
    # p.stdin.close()
    # out, err = p.communicate()
    # print out, err

    os.system('echo -n http://public.dun.ai/public/screenshots/{} | xclip -i -selection clipboard'.format(fname))

    scp = Popen(
        [
            'scp', fpath, 'dun.ai:/home/public/public/screenshots/'
        ],
        stdout=PIPE, stderr=PIPE
    )
    stdout, stderr = scp.communicate()

    if scp.returncode:
        notify(
            'error',
            'Error',
            'Failed to upload file!\nError was: {}'.format(stderr),
            timeout=3000
        )
        os.exit(1)
    else:
        notify('info', 'Finished', 'Image uploaded!', timeout=3000)


if __name__ == '__main__':
    main()
