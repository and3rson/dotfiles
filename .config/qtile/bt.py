from __future__ import print_function
from blueman import bluez


def get_adapter():
    manager = bluez.Manager()
    adapter = manager.get_adapter()
    return adapter


def get_connected_devices(adapter):
    props_array = [device.get_properties() for device in adapter.list_devices()]
    return [props['Name'] for props in props_array if props['Connected']]


if __name__ == '__main__':
    print(get_connected_devices(get_adapter()))
