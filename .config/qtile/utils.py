from libqtile.log_utils import logger


def nonblocking(on_result):
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
