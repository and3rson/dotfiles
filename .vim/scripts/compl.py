#!/usr/bin/env python3

import sys
import re
import vim
import string

# print(vim.
# print(sys.argv)
# sys.exit(0)

SEP = r'[a-zA-Z0-9_]*'


# print(vim.current.range)


def compl(findstart, base):
    if findstart:
        col = int(vim.eval('col(\'.\')')) - 2
        line = vim.current.line
        while col > 0 and line[col] in string.digits + string.ascii_letters:
            col -= 1
        col += 1
        return col
    else:
        src = vim.current.buffer[:-1]
        matches = list(re.findall(SEP + SEP.join(base) + SEP, src))
        for match in matches:
            print(match)

