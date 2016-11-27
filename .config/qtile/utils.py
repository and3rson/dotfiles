from libqtile.log_utils import logger
from subprocess import Popen, PIPE


def nonblocking(on_result):
    # Not sure if this is actually called anywhere.
    def callable_fn(fn):
        def wrapper(self, *args, **kwargs):
            def on_done(future):
                try:
                    result = future.result()
                except Exception:
                    logger.exception('Polling raised exception')
                    result = None
                on_result(self, result)

            future = self.qtile.run_in_executor(fn)
            future.add_done_callback(on_done)
        return wrapper
    return callable_fn


class NonBlockingSpawn(object):
    """
    This mixin provides a `spawn` method that performs
    long-running operations within magic Qtile task executor.
    Very handy for use in custom widgets to avoid blocking main loop.
    """
    def spawn(self, fn, result_cb):
        def on_done(future):
            try:
                result = future.result()
            except Exception:
                logger.exception('Polling raised exception')
                result = None
            result_cb(result)

        future = self.qtile.run_in_executor(fn)
        future.add_done_callback(on_done)


class DMenu(NonBlockingSpawn, object):
    def __init__(self, run=False, **kwargs):
        self.kwargs = kwargs
        self.app = 'dmenu_run' if run else 'dmenu'

    def run(self, items, callback):
        self.spawn(lambda: self._run(items), callback)

    def _run(self, items):
        args = [self.app] + map(str, sum(map(list, self.kwargs.items()), []))
        return Popen(args, stdout=PIPE, stderr=PIPE).communicate('\n'.join(items))[0]
