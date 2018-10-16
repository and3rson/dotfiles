" Custom signs
"nnoremap <silent> mmm <Nop>
"unmap m
"hi link Mark LineNr
let ctermbg = matchstr(execute('hi LineNr'), 'ctermbg=\zs\S*')
exe 'hi Mark cterm=bold ctermfg=154 ctermbg=' . ctermbg
exe 'hi MarkLine ctermbg=236'
" . ctermbg

"hi Mark ctermbg=235 ctermfg=
let i = 0
while i < 10
    let c = nr2char(char2nr('a') + i)
    if c == 'm'
        continue
    endif
    exe 'sign define Sign_'.c.' text='.toupper(c).'> texthl=Mark linehl=MarkLine'
    exe 'nnoremap <silent> mm'.c.' :call SignPlace("'.c.'")<CR>'
    exe 'nnoremap <silent> m'.c.' :call SignJump("'.c.'")<CR>'
    let i = i + 1
endwhil

nnoremap <silent> mm<Space> :call ClearSigns()<CR>
nnoremap <silent> mh :call SignPrev()<CR>
nnoremap <silent> mn :call SignNext()<CR>

"sign define Sign_a text=a texthl=CursorLineNr
"nnoremap <silent> sa :call SignPlace('a')

fu! LoadSigns()
    if ! exists('g:SIGNS')
        let g:SIGNS = {}
    endi
    if buffer_number('%') == -1
        return
    endi
    let l:filename = expand('%:p')
    if ! has_key(g:SIGNS, l:filename)
        let g:SIGNS[l:filename] = {}
    endi
    "for l:filename in keys(g:SIGNS)
    let l:signs = g:SIGNS[l:filename]
    for l:sign in keys(l:signs)
        let l:line = l:signs[l:sign]
        "exe 'sign place ' . (char2nr(l:sign) + 4000000) . ' line=' . l:line . ' name=Sign_' . l:sign . ' file=' . l:filename
        exe 'sign place ' . (char2nr(l:sign) + 4000000) . ' line=' . l:line . ' name=Sign_' . l:sign . ' buffer=' . buffer_number('%')
    endfor
    "endfor
endf

fu! SaveSigns()
    if buffer_number('%') == -1
        return
    endi
    let g:SIGNS[expand('%:p')] = GetSigns()
endf

fu! GetSigns()
    if buffer_number('%') == -1
        return {}
    endi
    let l:result = {}
    "let l:filename = expand('%:p')
    let l:signs = execute('sign place buffer=' . buffer_number('%'))
    for l:line in split(l:signs, '\n')
        let l:match = matchlist(l:line, '=\(\d\+\).*=\(\d\+\).*=\(\S\+\)')
        if len(l:match) == 0
            continue
        endi
        let [l:_, l:line, l:id, l:name; l:_] = l:match
        if l:name =~ '^Sign_.\+'
            let l:sign = matchlist(l:name, '^Sign_\(.\+\)')[1]
            let l:result[l:sign] = str2nr(l:line)
        endi
    endfor
    return l:result
endf

fu! GetSignsAtLine(signs, line)
    let l:signs = []
    for l:sign in keys(a:signs)
        let l:line = a:signs[l:sign]
        if l:line ==# a:line
            call add(l:signs, l:sign)
        endif
    endfor
    return l:signs
endf

fu! SignPlace(sign)
    if buffer_number('%') == -1
        return
    endi
    let l:id = char2nr(a:sign) + 4000000
    let l:line = line('.')

    let l:signs = GetSigns()
    let l:signs_on_current_line = GetSignsAtLine(l:signs, l:line)
    let l:sign_already_here = (index(l:signs_on_current_line, a:sign) >= 0)
    let l:sign_somewhere_else = has_key(l:signs, a:sign)
    "if l:current_sign ==# a:sign
    "    let l:is_same_sign = 1
    "endif

    if l:sign_already_here
        exe 'sign unplace '.l:id.' buffer='.buffer_number('%')
    else
        if l:sign_somewhere_else
            exe 'sign unplace '.l:id.' buffer=' .buffer_number('%')
        endi
        exe 'sign place '.l:id.' line='.line('.').' name=Sign_'.a:sign.' buffer='buffer_number('%')
    endi

    "if has_key(l:signs, a:sign)
    "    echo 'sign unplace '.l:id.' buffer='.buffer_number('%')
    "    exe 'sign unplace '.l:id.' buffer='.buffer_number('%')
    "endi

    "if len(l:current_signs) > 0
    "    for l:sign in l:current_signs
    "        exe 'sign unplace '.l:id.' buffer=' .buffer_number('%')
    "    endfo
    "else
    "    exe 'sign place '.l:id.' line='.line('.').' name=Sign_'.a:sign.' buffer='buffer_number('%')
    "endi
    call SaveSigns()
endf

fu! SignJump(sign)
    let l:signs = GetSigns()
    if has_key(l:signs, a:sign)
        exe ':'.l:signs[a:sign]
    else
        echo 'Sign ' . a:sign . ' not found'
    endif
endf

fu! SignPrev()
    let l:current_line = line('.')
    let l:signs = GetSigns()
    let l:next_line = 0
    for l:line in values(l:signs)
        if l:line < l:current_line && (l:next_line == 0 || l:line > l:next_line)
            let l:next_line = l:line
        endi
    endfo
    if l:next_line == 0 && len(l:signs)
        let l:next_line = max(values(l:signs))
    endi
    if l:next_line > 0
        exe ':' . string(l:next_line)
    endi
endf

fu! SignNext()
    let l:current_line = line('.')
    let l:signs = GetSigns()
    let l:next_line = 0
    for l:line in values(l:signs)
        if l:line > l:current_line && (l:next_line == 0 || l:line < l:next_line)
            let l:next_line = l:line
        endi
    endfo
    if l:next_line == 0 && len(l:signs)
        let l:next_line = min(values(l:signs))
    endi
    if l:next_line > 0
        exe ':' . string(l:next_line)
    endi
endf

fu! ClearSigns()
    let l:signs = GetSigns()
    for l:sign in keys(l:signs)
        let l:id = char2nr(l:sign) + 4000000
        exe 'sign unplace '.l:id.' buffer=' .buffer_number('%')
    endfor
    call SaveSigns()
endf

aug SignsGroup
    au BufReadPost * :call LoadSigns()
    "au BufWritePost * :call SaveSigns()
aug END
