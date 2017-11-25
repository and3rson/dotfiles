function! ASTLocInit()
let g:ast_loc_initialized = 1
py3 << EOF
from ast import parse, ClassDef, FunctionDef, If, Return, Assign
import sys
import vim


def astloc_find_node(root, line):
    path = []
    while True:
        leading = [node for node in root.body if node.lineno <= line]
        # print([node.lineno for node in leading])
        if not len(leading):
            return path
        closest = leading[-1]
        path.append(closest)
        # print('Closest so far:', closest, 'at', closest.lineno)
        if hasattr(closest, 'body'):
            root = closest
        else:
            return path


def astloc_represent_node(node, show_signatures=False):
    if show_signatures:
        template = '{name}({args})'
    else:
        template = '{name}'
    if isinstance(node, ClassDef):
        bases = [base for base in node.bases if hasattr(base, 'id')]
        return '%#Keyword#' + template.format(
            name=node.name,
            args=', '.join([base.id for base in bases])
        )
    elif isinstance(node, FunctionDef):
        return '%#Function#' + template.format(
            name=node.name,
            args=', '.join([arg.arg for arg in node.args.args])
        )
    elif isinstance(node, If):
        return '%#Keyword#if'
    elif isinstance(node, Return):
        return '%#Keyword#return'
    elif isinstance(node, Assign):
        return ', '.join([node.id for node in node.targets])
    return '?'


def astloc_run():
    pos = vim.eval('getpos(\'.\')')
    line = int(pos[1])
    # print(repr(pos))
    src = '\n'.join(vim.current.buffer[:-1])
    root = parse(src)
    path = astloc_find_node(root, line)
    nodes = [astloc_represent_node(node) for node in path]
    # vim.command('let b:astloc_result = ' + str(list(nodes)))
    result = '.'.join(nodes)
    vim.command('let b:astloc_result = ' + repr(result))
EOF
endfunction

function ASTLoc()
    if ! exists('g:ast_loc_initialized')
        call ASTLocInit()
    endif
    py3 astloc_run()
    return b:astloc_result
endfunction

