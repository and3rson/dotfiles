#!/usr/bin/env python3

import os
import sys
import argh
import signal
import logging
import socket
from select import select
from threading import Thread
from PyQt4 import QtGui, QtCore
from daemonize import Daemonize
from libqtile.command import Client


PIDFILE = '/tmp/qnoti.pid'
SOCKFILE = '/tmp/qnoti.sock'


class BorderEffect(QtGui.QGraphicsEffect):
    def draw(self, painter):
        print(painter)
        pixmap, point = self.sourcePixmap()
        image = QtGui.QImage(pixmap)
        for y in range(0, image.height()):
            for x in range(0, image.width()):
                c = image.pixel(x, y)
                if c & 0xFF > 128:
                    image.setPixel(x, y, 0xFFFF0000)
                # print(c & 0xFF, (c >> 8) & 0xFF, (c >> 16) & 0xFF)
        # pixmap.save('/tmp/1.png', 'PNG')
        # painter.drawLine(0, 0, 100, 100)
        painter.drawImage(QtCore.QPoint(0, 0), image)
        print(self.source)


class MainWindow(QtGui.QMainWindow):
    def __init__(self):
        self.client = Client()

        QtGui.QMainWindow.__init__(self)
        self.setWindowFlags(
            QtCore.Qt.WindowStaysOnTopHint |
            QtCore.Qt.FramelessWindowHint |
            QtCore.Qt.X11BypassWindowManagerHint |
            QtCore.Qt.WindowStaysOnTopHint
        )
        self.setGeometry(QtGui.QStyle.alignedRect(
            QtCore.Qt.LeftToRight, QtCore.Qt.AlignCenter,
            QtCore.QSize(640, 240),
            QtGui.qApp.desktop().availableGeometry()
        ))

        self.setAttribute(QtCore.Qt.WA_TranslucentBackground)

        self.label = QtGui.QLabel(text='?')
        self.label.setAlignment(QtCore.Qt.AlignHCenter | QtCore.Qt.AlignTop)
        self.label.setStyleSheet('QLabel { color: #FFFFFF; font-family: Roboto Condensed; font-size: 120px; font-weight: 100; text-shadow: 1px 1px 1px #000; background-color: rgba(0, 0, 0, 0%); }')
        shadow = QtGui.QGraphicsDropShadowEffect()
        shadow.setBlurRadius(20)
        shadow.setColor(QtGui.QColor('#000000'))
        shadow.setOffset(0, 0)
        self.label.setGraphicsEffect(shadow)
        # self.label.setGraphicsEffect(BorderEffect())

        self.layout().addWidget(self.label)

        # self.last_screen = -1
        self.hide_timer = None
        # self.reset_hide_timer()

        # self.timer = QtCore.QTimer()
        # self.timer.timeout.connect(self.update)
        # self.timer.start(50)

        self.hide()

        self.listener = Listener(self)
        self.listener.start()

    # def update(self):
    #     try:
    #         screen = self.client.screen.info()['index']
    #     except:
    #         return
    #     if screen == self.last_screen:
    #         return
    #     print('Screen changed')
    #     group = next(iter([key.upper() for key, group in self.client.groups().items() if group['screen'] == screen]), str(screen + 1))
    #     self.label.setText(group)
    #     self.last_screen = screen
    #     # screen = QtGui.QApplication.desktop().screenNumber(QtGui.QApplication.desktop().cursor().pos())
    #     centerPoint = QtGui.QApplication.desktop().screenGeometry(screen).center()
    #     gm = self.frameGeometry()
    #     gm.moveCenter(centerPoint)
    #     self.move(gm.topLeft())
    #     self.show()

    #     self.reset_hide_timer()

    #     self.raise_()

        self.connect(self.listener, self.listener.signal, self.show_note)

    def start_hide_timer(self):
        if self.hide_timer is not None:
            self.hide_timer.stop()
            self.hide_timer.deleteLater()
        self.hide_timer = QtCore.QTimer()
        self.hide_timer.setSingleShot(True)
        self.hide_timer.timeout.connect(self.hide)
        self.hide_timer.start(320)

    def mousePressEvent(self, event):
        QtGui.qApp.quit()

    def show_note(self, note):
        screen = QtGui.QApplication.desktop().screenNumber(QtGui.QApplication.desktop().cursor().pos())
        centerPoint = QtGui.QApplication.desktop().screenGeometry(screen).center()
        gm = self.frameGeometry()
        gm.moveCenter(centerPoint)

        self.move(gm.topLeft())
        self.label.setText(note)
        self.show()
        self.start_hide_timer()


class Listener(QtCore.QThread):
    def __init__(self, mw):
        self.signal = QtCore.SIGNAL('note')
        self.mw = mw
        self.socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        if os.path.exists(SOCKFILE):
            os.unlink(SOCKFILE)
        self.socket.bind(SOCKFILE)
        self.socket.listen(10)
        super().__init__()

    def run(self):
        while True:
            conn, info = self.socket.accept()
            # i, o, e = select([conn], [], [], 1)
            # if conn in i:
            data = conn.recv(1024)
            print('Got data:', data)
            conn.close()
            self.emit(self.signal, data.decode('utf-8'))


def app():
    app = QtGui.QApplication(sys.argv)
    mywindow = MainWindow()
    signal.signal(signal.SIGINT, lambda *args: QtGui.qApp.quit())
    app.exec_()


def main(daemonize=False, kill=False):
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.ERROR)
    logger.propagate = False
    fh = logging.FileHandler('/tmp/qoverlay.log', 'w')
    fh.setLevel(logging.ERROR)
    logger.addHandler(fh)

    if daemonize:
        daemon = Daemonize(app='qoverlay', pid=PIDFILE, action=app, keep_fds=[fh.stream.fileno()], logger=logger)
        if kill:
            if os.path.exists(PIDFILE):
                with open(PIDFILE, 'r') as f:
                    pid = int(f.read().strip())
                    os.kill(pid, signal.SIGINT)
                daemon.exit()
            else:
                sys.stderr.write('PID file not found.\n')
        else:
            daemon.start()
    else:
        app()


if __name__ == '__main__':
    argh.dispatch_command(main)

