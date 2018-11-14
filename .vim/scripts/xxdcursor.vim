let g:xxd_segments = [
            \ [0, 8],
            \ [11, 57],
            \ [60, 75]
            \ ]

function! s:highlight()
    if exists('s:match') && s:match != -1
        call matchdelete(s:match)
        unlet s:match
    endif
    let l:col = col('.')
    let l:segment = -1
    let l:i = 0
    for [c_start, c_end] in g:xxd_segments
        if l:col >= c_start && l:col <= c_end
            let l:segment = l:i
        endi
        let l:i = l:i + 1
    endfo
    echo l:segment
    if l:segment == 0
        let seg1 = [line('.'), g:xxd_segments[1][0], g:xxd_segments[1][1] - g:xxd_segments[1][0] + 1]
        let s:match = matchaddpos('XXDHighlight', [seg1])
    elseif l:segment == 1
        let l:char = matchstr(getline('.'), '\%' . col('.') . 'c.')
        if l:char == ' '
            return
        endi
        let l:hl = (l:col - g:xxd_segments[1][0]) / 3 + g:xxd_segments[2][0]
        let s:match = matchaddpos('XXDHighlight', [[line('.'), l:hl, 1]])
    elseif l:segment == 2
        let l:hl = (l:col - g:xxd_segments[2][0]) * 3 + g:xxd_segments[1][0]
        let s:match = matchaddpos('XXDHighlight', [[line('.'), l:hl, 2]])
    endi
endfunction

if &bin
    augroup XXD
        au!
        autocmd CursorMoved,CursorMovedI <buffer> call s:highlight()
    augroup END
endi
hi XXDHighlight cterm=bold,underline ctermfg=255
"highlight link MyGroup WildMenu
