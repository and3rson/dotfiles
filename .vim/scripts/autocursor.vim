fu! ACInit()
    if ! exists('g:CURSORPOS')
        let g:CURSORPOS = {}
    endi
    let l:filename = expand('%:p')
    if ! has_key(g:CURSORPOS, l:filename)
        let g:CURSORPOS[l:filename] = {}
    else
        let [l:_, l:line, l:col, l:_] = g:CURSORPOS[l:filename]
        call cursor(l:line, l:col)
    endi
endf

fu! ACSavePos(pos)
    if ! exists('g:CURSORPOS')
        return
    endi
    let l:filename = expand('%:p')
    try
        let g:CURSORPOS[l:filename] = a:pos
    cat
    endt
endf

au BufReadPost * :call ACInit()
au CursorMoved,CursorMovedI * :call ACSavePos(getpos('.'))
