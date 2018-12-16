fu! ACInit()
    if ! exists('g:CURSORPOS')
        let g:CURSORPOS = {}
    endi
    let l:filename = expand('%:p')
    if ! has_key(g:CURSORPOS, l:filename)
        let g:CURSORPOS[l:filename] = [0, 0, 0, 0]
        "let g:CURSORPOS[l:filename] = 0
    else
        let [l:_, l:line, l:col, l:_] = g:CURSORPOS[l:filename]
        "let l:line = g:CURSORPOS[l:filename]
        call cursor(l:line, l:col)
        "call cursor(l:line, 0)
    endi
endf

fu! ACSavePos(pos)
    if ! exists('g:CURSORPOS')
        return
    endi
    let l:filename = expand('%:p')
    if l:filename == ''
        return
    endi
    try
        let g:CURSORPOS[l:filename] = a:pos
    cat
    endt
endf

aug AutoCursor
    au BufReadPost * :call ACInit()
    au CursorMoved,CursorMovedI * :call ACSavePos(getpos('.'))
aug END
