#!/usr/bin/env python2

import os
import sys
import socket
import subprocess
# from colors import color


ARROW = u'\uE0B0'
SLASH = u'\uE0BC'


class Styled(object):
    def __init__(self, text, fg=None, bg=None, style='', left=' ', right=' '):
        self.text = left + text + right
        self.fg = fg
        self.bg = bg
        self.style = style

    def render(self):
        # return '\\[' + color(self.text, fg=self.fg, bg=self.bg) + '\\]'
        # return color(self.text, fg=self.fg, bg=self.bg)
        s = ''
        if self.fg:
            s += '\033[' + ('1;' if 'bold' in self.style else '') + '38;5;' + str(self.fg) + 'm'
        if self.bg:
            s += '\033[48;5;' + str(self.bg) + 'm'
        s += self.text
        s += '\033[0m'
        return s


class Part(object):
    def call(self, *args):
        proc = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = proc.communicate()
        return proc.returncode, out.strip(), err.strip()


class VirtualEnv(Part):
    def render(self):
        venv = os.environ.get('VIRTUAL_ENV')
        is_active = bool(venv)

        if not venv and os.path.exists(os.path.join(os.environ['PWD'], '.env')):
            venv = os.path.join(os.environ['PWD'], '.env')
            is_active = False

        if venv:
            venv = os.path.join(os.path.basename(os.path.dirname(venv)), os.path.basename(venv))
            return Styled(venv, fg=255, bg=22 if is_active else 160)
        return None



class HostnamePart(Part):
    def render(self):
        return Styled(socket.gethostname(), fg=255, bg=125)  # 27)  # 26


class GitBranchPart(Part):
    def render(self):
        code, branches, _ = self.call('git', 'branch')
        if not code:
            branch = [branch[2:] for branch in branches.split('\n') if branch.startswith('* ')][0]
            code, _, _ = self.call('git', 'diff', '--quiet')
            if not code:
                return Styled(branch, fg=255, bg=70)
            return Styled(u'\u00B1 ' + branch, fg=255, bg=130)  # 125)
        else:
            return None


class CurrentDir(Part):
    def render(self):
        return Styled(os.environ['PWD'].replace(os.environ['HOME'], '~'), fg=255, bg=27, style='bold')


class ReturnCode(Part):
    def render(self):
        if os.environ['ret'] == '0':
            return None
        return Styled(os.environ['ret'], fg=255, bg=160, style='bold')


def draw(parts, lf=False):
    styled_list = filter(None, [part.render() for part in parts])

    for styled, next_styled in zip(styled_list, styled_list[1:] + [None]):

        sys.stdout.write(styled.render())

        if next_styled is not None:
            pass
            sys.stdout.write(Styled(SLASH, fg=styled.bg, bg=next_styled.bg, left='', right='').render())
        else:
            # sys.stdout.write(color('>', fg=styled.bg, bg=None))
            sys.stdout.write(Styled(SLASH, fg=styled.bg, left='', right='').render())
            sys.stdout.write(' ')
            # sys.stdout.write(' \033[10D')

    if lf:
        sys.stdout.write('\n')


def main():
    parts = [
        VirtualEnv(),
        HostnamePart(),
        GitBranchPart(),
        ReturnCode(),
        CurrentDir()
    ]
    parts2 = [
        CurrentDir(),
    ]
    draw(parts, lf=True)
    # draw(parts2)


if __name__ == '__main__':
    main()
