#!/usr/bin/env python3

import sys
from libqtile.command import Client
from PyQt4 import QtGui, QtCore
from daemonize import Daemonize


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
            QtCore.QSize(640, 480),
            QtGui.qApp.desktop().availableGeometry()
        ))

        self.setAttribute(QtCore.Qt.WA_TranslucentBackground)

        self.label = QtGui.QLabel(text='?')
        self.label.setAlignment(QtCore.Qt.AlignHCenter | QtCore.Qt.AlignTop)
        self.label.setStyleSheet('QLabel { color: #FFFFFF; font-family: Roboto Condensed; font-size: 480px; font-weight: 100; text-shadow: 1px 1px 1px #000; }')
        shadow = QtGui.QGraphicsDropShadowEffect()
        shadow.setBlurRadius(20)
        shadow.setColor(QtGui.QColor('#000000'))
        shadow.setOffset(0, 0)
        self.label.setGraphicsEffect(shadow)

        self.layout().addWidget(self.label)

        self.last_screen = -1
        self.hide_timer = None
        self.reset_hide_timer()

        self.timer = QtCore.QTimer()
        self.timer.timeout.connect(self.update)
        self.timer.start(50)

        self.hide()

    def update(self):
        screen = self.client.screen.info()['index']
        if screen == self.last_screen:
            return
        print('Screen changed')
        self.last_screen = screen
        # screen = QtGui.QApplication.desktop().screenNumber(QtGui.QApplication.desktop().cursor().pos())
        centerPoint = QtGui.QApplication.desktop().screenGeometry(screen).center()
        gm = self.frameGeometry()
        gm.moveCenter(centerPoint)
        self.move(gm.topLeft())
        self.show()

        self.label.setText(str(screen + 1))

        self.reset_hide_timer()

    def reset_hide_timer(self):
        if self.hide_timer is not None:
            self.hide_timer.stop()
            self.hide_timer.deleteLater()
        self.hide_timer = QtCore.QTimer()
        self.hide_timer.setSingleShot(True)
        self.hide_timer.timeout.connect(self.hide)
        self.hide_timer.start(191)

    def mousePressEvent(self, event):
        QtGui.qApp.quit()


def main():
    app = QtGui.QApplication(sys.argv)
    mywindow = MainWindow()
    app.exec_()


if __name__ == '__main__':
    daemon = Daemonize(app='qoverlay', pid='/tmp/qoverlay.pid', action=main)
    daemon.start()

