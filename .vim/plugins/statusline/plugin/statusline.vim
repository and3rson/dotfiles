" vim:foldmethod=marker
scriptencoding utf-8
" Highlights {{{
hi! StatusBarInsert ctermbg=233 ctermfg=197
hi! StatusBarNormal ctermbg=233 ctermfg=81
hi! StatusBarCommand ctermbg=233 ctermfg=32
hi! StatusBarVisual ctermbg=233 ctermfg=118
hi! StatusBarReplace ctermbg=233 ctermfg=222
hi! StatusBarTerminal ctermbg=233 ctermfg=57
hi! StatusBarText ctermbg=233 ctermfg=248
" Error parts
hi! StatusBarWarning ctermfg=3 ctermbg=233 cterm=bold
hi! StatusBarError ctermfg=1 ctermbg=233 cterm=bold

hi! StatusLine ctermfg=248 ctermbg=233 cterm=none
hi! StatusLineNC ctermfg=238 ctermbg=233 cterm=none

" PieCrumbs
hi! PieClass ctermfg=197 ctermbg=233 cterm=bold
hi! PieFunction ctermfg=154 ctermbg=233
" }}}

" Mode icons {{{
let g:mode_map = {
    \ '__': '',
    \ 'n': g:ic.vim,
    \ 'i': g:ic.insert,
    \ 'R': g:ic.replace,
    \ 'c': g:ic.code,
    \ 'v': '',
    \ 'V': '',
    \ nr2char(22): '',
    \ 's': '',
    \ 'S': '',
    \ '^S': '',
    \ 't': ''
    \ }
"let g:sep = ' ⎪ '
let g:sep = '  '
" }}}

" Char code {{{
fu! CharCode(bufnr, mode, is_active_window)
    return g:sep . '0x%02B'
    "echo getbufline(a:bufnr, '.')
    "let char = matchstr(getbufline(a:bufnr, '.'), '\%' . col('.') . 'c.')
    "let code = char2nr(char)

    "if code == 0
    "    let char = ''
    "elseif code == 32
    "    let char = '␣'
    "    "let char = '…' " ''
    "elseif code == 9
    "    let char = ''
    "endif


    "return printf("%s (0x%04x)", char, code)
endf
" }}}
" Scroll progress {{{
fu! ScrollProgress(bufnr, mode, is_active_window)
    let base = 0x2581
    let base = 0x2588
    let size = 8
    let chars = '▁▂▃▄▅▆▇█'
    let current = line('.')
    let total = line('$')
    let v = float2nr(ceil(Clamp(0, total, 0, size, current)))
    let s = '⎹'
    let s = ''
    let s .= nr2char(base + (8 - v))
    let s .= '⎸'
    return s
endf
" }}}
" ALE status {{{
fu! AleStatus(bufnr, mode, is_active_window) abort
    let l:is_checking = ale#engine#IsCheckingBuffer(bufnr(''))

    return l:is_checking == 0 ? '' : (g:sep . '...')
endf
" }}}
" ALE warnings {{{
fu! AleWarnings(bufnr, mode, is_active_window) abort
    let l:is_checking = ale#engine#IsCheckingBuffer(bufnr(''))
    let l:counts = ale#statusline#Count(a:bufnr)
    let l:errors = l:counts.error + l:counts.style_error
    let l:warnings = l:counts.total - l:errors
    let l:msg = ''
    if l:is_checking
        let l:msg = '%#StatusBarText# ' . ' …'
    else
        if l:warnings
            let l:msg = '%#StatusBarWarning# ' . printf('%2d', l:warnings)
        else
            let l:msg = '%#StatusBarText# ' . ' 0'  " ' —'
        endi
    endi
    return g:sep . l:msg . '%#StatusBarText#'
endf
" }}}
" ALE errors {{{
fu! AleErrors(bufnr, mode, is_active_window) abort
    let l:is_checking = ale#engine#IsCheckingBuffer(bufnr(''))
    let l:counts = ale#statusline#Count(a:bufnr)
    let l:errors = l:counts.error + l:counts.style_error
    let l:msg = ''
    if l:is_checking
        let l:msg = '%#StatusBarText# ' . ' …'
    else
        if l:errors
            let l:msg = '%#StatusBarError# ' . printf('%2d', l:errors)
        else
            let l:msg = '%#StatusBarText# ' . ' 0'  " ' —'
        endi
    endi
    return g:sep . l:msg . '%#StatusBarText#'
endf
" }}}
" Linter status {{{
fu! LinterStatus(bufnr, mode, is_active_window) abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? '' : printf(
    \   '  %d  %d',
    \   all_non_errors,
    \   all_errors
    \)
endf
" }}}
" File icon {{{
fu! FileIcon(filetype)
    return has_key(g:ic, a:filetype) ? g:ic[a:filetype] : g:ic.default
endf
" }}}
" File type {{{
fu! FileType(bufnr, mode, is_active_window)
    return getbufvar(a:bufnr, '&filetype')
    "let ft = &filetype
    "return has_key(g:abbr, ft) ? g:abbr[ft] : ft
endf
" }}}
" PieCrumbs {{{
fu! PieCrumbs(bufnr, mode, is_active_window)
    if getbufvar(a:bufnr, '&filetype') != 'python'
        return ''
    endi
    let result = ''
    let l:show_signatures = 0
    if l:show_signatures
        let regexp = '\(def\|class\) \([a-zA-Z_]*\)\(\(:\|([^:]*)\):\)'
    else
        let regexp = '\(def\|class\) \([a-zA-Z_]*\)[(:]'
    endif
    let line_count = line('$')
    let lineno = getpos('.')[1]
    let lineno_initial = lineno
    let min_indent = -1
    let remaining = winwidth(0)
    while lineno <= line_count
        let min_indent = match(getline(lineno), '\S')
        if min_indent != -1
            break
        endif
        let lineno += 1
    endwhile
    let s = ''
    let path = []
    while lineno > 0
        let line = getline(lineno)
        let indent = match(line, '\S')
        if (indent < min_indent || lineno == lineno_initial) && indent != -1
            let min_indent = indent
            let match = matchlist(line, regexp)
            if len(match) != 0
                call add(path, [match[1], match[2], match[4]])
            endif
        endif
        let lineno = lineno - 1
    endwhile
    if len(path) == 0
        return ''
    endif
    call reverse(path)
    let result .= '%#StatusBarText# '
    let is_first = 1
    for part in path
        if is_first == 1
            let is_first = 0
        else
            "echohl Number
            "let remaining = PieCrumbsPrintTrimmed(remaining, g:piecrumbs_glue)
            let result .= '%#StatusBarText#  '
        endif
        if part[0] ==  'def'
            "echohl Function
            let result .= '%#PieFunction#'
        elseif part[0] == 'class'
            "echohl Keyword
            let result .= '%#PieClass#'
        endif
        let result .= part[1]
        "let remaining = PieCrumbsPrintTrimmed(remaining, part[1])
        let result .= l:show_signatures ? part[2] : '()'
        "echohl Normal
        "let remaining = PieCrumbsPrintTrimmed(remaining, part[2])
    endfor
    return result
endf
" }}}
" TagBarLoc {{{
fu! TagBarLoc(bufnr, mode, is_active_window)
    let tag = tagbar#currenttag('%s', '', 'f')
    if strlen(tag) == 0
        return ''
    endif
    return ' > ' . tag
endf
" }}}
" Current branch {{{
fu! Branch(bufnr, mode, is_active_window)
    " expand('%:p:h')
    " let head = system('git -C ' . shellescape(a:file) . ' rev-parse --symbolic-full-name --abbrev-ref HEAD')
    " let head = substitute(head, '\n\+$', '', '')
    " if v:shell_error != 0
    "     let head = ''
    " endif
    let head = fugitive#Head(8, getbufvar(a:bufnr, 'git_dir'))
    if strlen(head)
        if strlen(head) > 16
            let head = head[:15] . '>'
        endif
        let br = g:sep . ' ' . head
        return br
    endif
    return ''
endf
" }}}
" File position {{{
fu! FilePos(bufnr, mode, is_active_window)
    "return g:sep . '%03l:%03c / %03L'
    return g:sep . '%03l/%03L'
endf
" }}}
" Buffer number {{{
fu! BufNr(bufnr, mode, is_active_window)
    "return g:sep . ' ' . a:bufnr . ':' . a:mode . ' '
    return g:sep . '#' . a:bufnr . g:sep . a:mode
endf
" }}}
" File and mode {{{
let g:statusbar_highlights = {
            \ 'n': 'StatusBarNormal',
            \ 'c': 'StatusBarCommand',
            \ 'i': 'StatusBarInsert',
            \ 'R': 'StatusBarReplace',
            \ 'v': 'StatusBarVisual',
            \ 'V': 'StatusBarVisual',
            \ nr2char(22): 'StatusBarVisual',
            \ 't': 'StatusBarTerminal'
            \ }

fu! FileAndMode(bufnr, m, is_active_window)
    let s = ''
    if a:is_active_window
        let title_hi = '%#' . g:statusbar_highlights[a:m] . '#'
    else
        let title_hi = '%#StatusBarInactive#'
    endif
    let l:filetype = getbufvar(a:bufnr, '&filetype')
    let l:file_icon = FileIcon(l:filetype)

    let l:flags = ''
    if getbufvar(a:bufnr, '&modified')
        let l:flags .= '[M]'
    endi
    if getbufvar(a:bufnr, '&readonly')
        let l:flags .= '[RO]'
    endi
    if ! getbufvar(a:bufnr, '&modifiable')
        let l:flags .= '[-M]'
    endi

    let s .= title_hi . ' ' . ((a:m == 'n' || a:m == 'c') ? l:file_icon : g:mode_map[a:m]) . ' '
    let s .= title_hi . '%<%f:%l:%c' . l:flags . ' '
    return s
endf
" }}}
" Spacer {{{
fu! Spacer(bufnr, m, is_active_window)
    return '%*%='
endf
" }}}
" Locinfo {{{
"au BufRead,BufWrite *.go :GoLint
"fu! FileAndMode(bufnr, m, is_active_window)
"    if getbufvar(a:bufnr, '&filetype') == 'go'

"    endi
"    return ''
"endf
" }}}

            "\ 'PieCrumbs',
            "
            "\ 'Branch',
            "\ 'BufNr',
            "
            "\ 'CharCode',
            "\ 'LocInfo',
let g:status_bar = [
            \ 'FileAndMode',
            \ 'Spacer',
            \ 'FileType',
            \
            \ 'FilePos',
            \
            \ 'AleErrors',
            \ 'AleWarnings',
            \ ]

fu! StatusBar(winid)
    let l:s = ''
    "let end = ' %*'
    let l:bufnr = -1
    let l:title_hi = '*'
    let l:is_active_window = g:winid == a:winid
    for l:bufinfo in getbufinfo()
        if index(l:bufinfo.windows, str2nr(a:winid)) != -1
            let l:bufnr = l:bufinfo.bufnr
            break
        endif
    endfor
    if l:is_active_window
        let l:m = mode()
    else
        let l:m = 'n'
    endi
    for l:fn in g:status_bar
        let s .= call(l:fn, [l:bufnr, l:m, l:is_active_window])
    endfo
    let s .= ' '
    return l:s
endf

fu! Clamp(smin, smax, dmin, dmax, value)
    let smin = a:smin * 1.0
    let smax = a:smax * 1.0
    let k = (a:value - smin) / (smax - smin)
    return a:dmin + (a:dmax - a:dmin) * k
endf

let g:winid = win_getid()
fu! SLEnter()
    let g:winid = win_getid()
endf

let g:active_winnr = winnr()

set lazyredraw
set noshowmode
set laststatus=2

fu InitStatusBar()
    if &filetype ==? 'tagbar'
        return
    endif
    let &l:statusline='%!StatusBar('.win_getid().')'
endf
aug StatusLine
    au VimEnter,WinNew,BufEnter * call InitStatusBar()
    au VimEnter,WinEnter,BufEnter * call SLEnter()
    au FileType qf call InitStatusBar()
    au FileType tagbar call InitStatusBar()
aug END
