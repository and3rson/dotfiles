import neovim


@neovim.plugin()
class ComplPlugin(object):
    def __init__(self, vim):
        self.vim = vim

    @neovim.function('Fn')
    def fn(self, a, b):
        return a + b

