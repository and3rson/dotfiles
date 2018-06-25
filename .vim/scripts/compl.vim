" VIM Fuzzy Completion
"
" Written by Andrew Dunai <a@dun.ai>
"
" Uses regular expressions & levenshtein algorithm
" to find & sort canditate matches.
"
" TODO: better matching (e. g. only lower-case letters between upper-case
" letters

function! ComplInit()
let g:compl_initialized = 1
py3 << EOF
import vim
import re
from time import sleep

SEP = r'[a-zA-Z0-9_]*'


# Calculates the levenshtein distance and the edits between two strings
def levenshtein(s1, s2, key=hash):
    rows = costmatrix(s1, s2, key)
    edits = backtrace(s1, s2, rows, key)

    return len(edits)  # rows[-1][-1], edits


# Generate the cost matrix for the two strings
# Based on http://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#Python
def costmatrix(s1, s2, key=hash):
    rows = []

    previous_row = range(len(s2) + 1)
    rows.append(list(previous_row))

    for i, c1 in enumerate(s1):
        current_row = [i + 1]
        for j, c2 in enumerate(s2):
            insertions = previous_row[j + 1] + 1
            deletions = current_row[j] + 1
            substitutions = previous_row[j] + (key(c1) != key(c2))
            current_row.append(min(insertions, deletions, substitutions))
        previous_row = current_row

        rows.append(previous_row)

    return rows


# Trace back through the cost matrix to generate the list of edits
def backtrace(s1, s2, rows, key=hash):
    i, j = len(s1), len(s2)

    edits = []

    while(not (i == 0 and j == 0)):
        prev_cost = rows[i][j]

        neighbors = []

        if(i != 0 and j != 0):
            neighbors.append(rows[i - 1][j - 1])
        if(i != 0):
            neighbors.append(rows[i - 1][j])
        if(j != 0):
            neighbors.append(rows[i][j - 1])

        min_cost = min(neighbors)

        if(min_cost == prev_cost):
            i, j = i - 1, j - 1
            edits.append({'type': 'match', 'i': i, 'j': j})
        elif(i != 0 and j != 0 and min_cost == rows[i - 1][j - 1]):
            i, j = i - 1, j - 1
            edits.append({'type': 'substitution', 'i': i, 'j': j})
        elif(i != 0 and min_cost == rows[i - 1][j]):
            i, j = i - 1, j
            edits.append({'type': 'deletion', 'i': i, 'j': j})
        elif(j != 0 and min_cost == rows[i][j - 1]):
            i, j = i, j - 1
            edits.append({'type': 'insertion', 'i': i, 'j': j})

    edits.reverse()

    return edits


def compl_run():
    base = vim.eval('a:base')
    base = base.replace('.', '')
    src = ' '.join(vim.current.buffer[:-1])
    matches = list(re.findall('(?:^|\n|[^a-zA-Z0-9_])(' + SEP.join(base) + SEP + ')', src))
    matches = set(matches)
    result = []
    for m in matches:
        if len(m) < 3:
            continue
        fn_args = re.findall('def ' + m + '\([^)]*\)', src)
        if fn_args:
            result.append(dict(word=m, menu=fn_args[0].strip().strip(':'), kind='f'))
            continue
        class_args = re.findall('class[\s]*' + m + '[\s]*\([^)]*\)', src)
        if class_args:
            result.append(dict(word=m, menu=class_args[0].strip().strip(':'), kind='t'))
            continue
        import_args = re.findall('import ' + m, src)
        if import_args:
            result.append(dict(word=m, menu=import_args[0].strip().strip(':'), kind='d'))
            continue
        result.append(dict(word=m, kind='v'))
    result = sorted(result, key=lambda x: levenshtein(base, x if isinstance(x, str) else x['word']))
    vim.command('let b:compl_result = ' + str(list(result)))
EOF
endfunction

function! Compl(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && (len(matchstr(line[start - 1], '[a-zA-Z0-9_]')) != 0)
            let start -= 1
        endwhile
        return start
    else
        if ! exists('g:compl_initialized')
            call ComplInit()
        endif
        py3 compl_run()
        return b:compl_result
        "let expr = ''
        "for c in split(a:base, '\zs')
            "if len(expr) == 0
                "let expr .= c
            "else
                "let expr .= '[a-zA-Z0-9_]*' . c
            "endif
        "endfor
        "let current_line = 0
        "let line_count = line('$')
        "echo current_line
        "echo line_count
        "let matches = []
        "while current_line < line_count
            "call substitute(getline(current_line), '[a-zA-Z_][a-zA-Z0-9_]*', '\=add(matches, submatch(0))', 'g')
            ""let m = matchstr(getline(current_line), '[a-zA-Z_][0-9]\*')
            ""echo matches
            "let current_line += 1
        "endwhile
        "let results = []
        "for m in matches
            ""echo m
            ""echo expr
            ""echo x
            "if len(matchstr(m, expr))
                ""echo 'MATCHED ' . m
                ""echo x
                "call add(results, m)
            "endif
        "endfor
        "return [a:base . 'a', a:base . 'b', a:base . 'c']
        "return results
    endif
endfunction

" SuperTab
let g:SuperTabDefaultCompletionType = "<C-X><C-U>"
inoremap <C-p> <C-X><C-U>
set completefunc=Compl

" Completion tweaks
inoremap <expr> <Esc>      pumvisible() ? "\<C-o>\<Esc>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
"inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
"inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
"inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

