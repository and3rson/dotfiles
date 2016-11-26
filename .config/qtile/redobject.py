from threading import Thread
import redis
from json import loads, dumps
import logging
from time import sleep


# This is my own IPC implementation that I use because DBus does some
# real weird shit within Qtile. "So I've decided to make my own." - Me.


class RedEvent(object):
    def __init__(self, name, data):
        self.name = name
        self.data = data


class RedObject(Thread):
    def __init__(self, channel, logger=None):
        Thread.__init__(self)
        self.channel = channel
        self.running = True
        self.redis = redis.Redis()
        self.pubsub = None
        self.connected = False
        if logger:
            self.logger = logger
        else:
            logging.basicConfig()
            self.logger = logging.getLogger('redtruck')

    def connect(self):
        if self.connected:
            return
        self.pubsub = None
        try:
            self.pubsub = self.redis.pubsub()
            self.pubsub.subscribe([self.channel])
        except:
            self.logger.exception('Failed to reconnect! Waiting 1s before proceeding.')
            sleep(1)
            self.connected = False
            return False
        else:
            self.connected = True
            self.call_handler('connected')
            return True

    def run(self, timeout=1):
        while self.running:
            event = self.next_event(timeout)
            if event:
                self.dispatch_event(event)

    def next_event(self, timeout=1):
        self.connect()
        try:
            item = self.pubsub.get_message(timeout=timeout)

            if not item:
                return
            if item['type'] == 'message':
                event_name, event_data = loads(item['data'])
                return RedEvent(event_name, event_data)
            return
        except Exception as e:
            self.logger.exception('Error! Will reconnect: {}'.format(e.message))
            self.disconnect()
            sleep(1)
            self.connect()

    def dispatch_event(self, event):
        self.call_handler(event.name, event.data)

    def call_handler(self, name, *args, **kwargs):
        handler = getattr(self, 'on_{}_handler'.format(name), None)
        if handler is not None:
            try:
                handler(*args, **kwargs)
            except Exception as e:
                self.logger.exception(e.message)

    def broadcast(self, event, data=None):
        try:
            self.redis.publish(self.channel, dumps([event, data]))
        except Exception as e:
            self.logger.exception(e.message)
            self.disconnect()
            self.connect()

    def disconnect(self):
        self.connected = False
        self.call_handler('disconnected')

    def stop(self):
        self.running = False
