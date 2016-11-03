class ToggleTerm(object):
    def __init__(self):
        self.prev = None

    def __call__(self, qtile):
        if self.prev is None:
            self.prev = qtile.currentGroup
            qtile.currentScreen.setGroup(qtile.groupMap['1 term'])
        else:
            qtile.currentScreen.setGroup(self.prev)
            self.prev = None
