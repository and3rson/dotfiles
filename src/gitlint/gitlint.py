#!/usr/bin/python3

import sys
from collections import namedtuple

from lark import Lark

l = Lark(
    r'''
    start: line+
    line: (sentence | message)? "\n"
    sentence: /.+/
    message: scope+ /.+/?
    scope.2: /[a-z]+/ ": "
    ''',
    propagate_positions=True
)

Warn = namedtuple('Warn', 'lineno message')

def check(tree):
    for lineno, line in enumerate(tree.children, start=1):
        if lineno == 1:
            if not line.children:
                yield Warn(lineno, 'Header cannot be empty')
            elif line.children[0].data == 'message':
                yield Warn(lineno, 'Missing header')
            elif line.children[0].data == 'sentence' and not line.children[0].children[0][0].isupper():
                yield Warn(lineno, 'Header should start with a capital letter')
        if lineno == 2:
            if line.children:
                yield Warn(lineno, 'Expected 1 empty line')
        if lineno > 2:
            if not line.children:
                yield Warn(lineno, 'Unexpected empty line')
            elif line.children[0].data != 'message':
                yield Warn(lineno, 'Line should be in form "scope1: ...: scopeN: message"')
            else:
                *scopes, message = line.children[0].children
                verb = message.partition(' ')[0]
                if verb.endswith('ed'):
                    yield Warn(lineno, 'Avoid past tense')

if __name__ == '__main__':
    lines = [line for line in sys.stdin.read().strip().split('\n') if not line.startswith('#')]
    lines = '\n'.join(lines) + "\n"
    tree = l.parse(lines)
    # print(tree.pretty(' ' * 4))
    good = True
    for warning in check(tree):
        print(f'{warning.lineno}:{warning.message}', file=sys.stderr)
        good = False
    sys.exit(int(not good))
