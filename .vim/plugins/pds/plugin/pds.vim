fu! PDS()
    if getbufvar(bufnr('%'), '&filetype') != 'python'
        return
    endi
    let regexp = '\(def\|class\) \([a-zA-Z_]*\)\(\(:\|([^)]*)\):\)'
    "let l:regexp = '\(def\|class\) \([a-zA-Z_]*\)[(:]'
    let l:lineno = getpos('.')[1]
    let l:fn = ''
    let l:args = []
    while l:lineno >= 0
        let l:line = getline(l:lineno)
        let l:matches = matchlist(l:line, l:regexp)
        if len(l:matches)
            let l:fn = l:matches[2]
            if l:matches[1] == 'def'
                let l:args = map(split(trim(l:matches[4], '()'), ','), {k, v -> trim(split(v, ':')[0])})
            endi
            break
        endi
        let l:lineno = l:lineno - 1
    endw
    if l:fn != ''
        let l:initial_lineno = l:lineno
        let l:indent = match(getline(l:lineno), '\S')
        let l:docstring = []
        call add(l:docstring, '"""')
        call add(l:docstring, '')
        call add(l:docstring, '')
        for l:arg in l:args
            if l:arg != 'self'
                call add(l:docstring, ':param ' . l:arg . ':')
            endi
        endfo
        if l:matches[1] == 'def'
            call add(l:docstring, ':return: None')
        endi
        call add(l:docstring, '"""')
        for l:line in l:docstring
            if len(l:line) > 0
                call append(l:lineno, repeat(' ', l:indent + 4) . l:line)
            else
                call append(l:lineno, '')
            endi
            let l:lineno = l:lineno + 1
        endfo
        call cursor(l:initial_lineno + 2, 1)
        call feedkeys('i    ')
    endi
endf

