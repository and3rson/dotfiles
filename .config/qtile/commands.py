from libqtile import hook
from libqtile.log_utils import logger


class ToggleTerm(object):
    def __init__(self):
        self.prev = None
        self.do_not_clean = False
        hook.subscribe.setgroup(self.reset_prev)

    def __call__(self, qtile):
        if self.prev is None:
            self.prev = qtile.currentGroup
            self.do_not_clean = True
            qtile.currentScreen.setGroup(qtile.groupMap['t'])
        else:
            qtile.currentScreen.setGroup(self.prev)
            self.prev = None

    def reset_prev(self, *args):
        if self.do_not_clean:
            self.do_not_clean = False
            return
        self.prev = None
#        logger.error('clean')


#@hook.subscribe.setgroup
#def foo(*args):
#    logger.error(str(args))

class FixGroups(object):
    def __init__(self):
        pass

    def __call__(self, qtile):
        for client in qtile.windowMap.values():
            logger.error('CLIENT {}'.format(client))
            for rule in qtile.dgroups.rules:
                logger.error('    RULE {}'.format(rule))
                if rule.matches(client):
                    logger.error('        MATCHED!')
                    if rule.group and hasattr(client, 'togroup'):
                        logger.error('                MOVE {} to {}'.format(client, rule.group))
                        client.togroup(rule.group)
                    else:
                        logger.error('                WTF WITH {}'.format(str(client)))

