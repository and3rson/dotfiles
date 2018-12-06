hi! StatusBarInsertInv ctermbg=233 ctermfg=197
" Visual
hi! StatusBarNormalInv ctermbg=233 ctermfg=81
"hi! StatusBarVisual ctermbg=32 ctermfg=0
"hi! StatusBarVisualInv ctermbg=234 ctermfg=32
" Normal
hi! StatusBarVisualInv ctermbg=233 ctermfg=118
" Replace
hi! StatusBarReplaceInv ctermbg=233 ctermfg=222
" Terminal
hi! StatusBarTerminalInv ctermbg=233 ctermfg=57
" Inactive
"hi! StatusBarInactive ctermfg=238 ctermbg=232
"hi! StatusBarInactiveInv ctermfg=248 ctermbg=232
" Text
"hi! StatusBarText ctermfg=33 ctermbg=234
hi! StatusBarText ctermfg=248 ctermbg=233
hi! StatusBarTextInv ctermfg=232 ctermbg=233
" Error parts
hi! StatusBarWarning ctermfg=3 ctermbg=233 cterm=bold
hi! StatusBarError ctermfg=1 ctermbg=233 cterm=bold

hi! StatusLine ctermfg=248 ctermbg=233 cterm=none
hi! StatusLineNC ctermfg=238 ctermbg=233 cterm=none

" PieCrumbs
hi! PieClass ctermfg=197 ctermbg=233 cterm=bold
hi! PieFunction ctermfg=154 ctermbg=233

"\ 'n': '',
"\ 'i': '',
"\ 'R': '',
let g:mode_map = {
    \ '__': '',
    \ 'n': '',
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

set noshowmode

" Char code
fu! CharCode(bufnr, mode, is_active_window)
    return g:sep . '%02B'
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

fu! Clamp(smin, smax, dmin, dmax, value)
    let smin = a:smin * 1.0
    let smax = a:smax * 1.0
    let k = (a:value - smin) / (smax - smin)
    return a:dmin + (a:dmax - a:dmin) * k
endf

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

fu! AleStatus(bufnr, mode, is_active_window) abort
    let l:is_checking = ale#engine#IsCheckingBuffer(bufnr(''))

    return l:is_checking == 0 ? '' : (g:sep . '...')
endf

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
            let l:msg = '%#StatusBarText# ' . ' —'
        endi
    endi
    return g:sep . l:msg . '%#StatusBarText#'
endf

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
            let l:msg = '%#StatusBarText# ' . ' —'
        endi
    endi
    return g:sep . l:msg . '%#StatusBarText#'
endf

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

fu! FileIcon(filetype)
    return has_key(g:ic, a:filetype) ? g:ic[a:filetype] : g:ic.default
endf

fu! FileType(bufnr, mode, is_active_window)
    return getbufvar(a:bufnr, '&filetype')
    "let ft = &filetype
    "return has_key(g:abbr, ft) ? g:abbr[ft] : ft
endf

"call SetStatusLineColor('n')

let g:winid = win_getid()
fu! SLEnter()
    let g:winid = win_getid()
endf

"hi StatusLine ctermfg=255 cterm=None gui=None ctermbg=None

" !!!
set lazyredraw

let g:active_winnr = winnr()

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

fu! TagBarLoc(bufnr, mode, is_active_window)
    let tag = tagbar#currenttag('%s', '', 'f')
    if strlen(tag) == 0
        return ''
    endif
    return ' > ' . tag
endf

fu! Branch(bufnr, mode, is_active_window)
    " expand('%:p:h')
    " let head = system('git -C ' . shellescape(a:file) . ' rev-parse --symbolic-full-name --abbrev-ref HEAD')
    " let head = substitute(head, '\n\+$', '', '')
    " if v:shell_error != 0
    "     let head = ''
    " endif
    let head = fugitive#head(8)
    if strlen(head)
        if strlen(head) > 16
            let head = head[:15] . '>'
        endif
        let br = g:sep . ' ' . head
        return br
    endif
    return ''
endf

fu! FilePos(bufnr, mode, is_active_window)
    return g:sep . '%03l:%03c / %03L'
endf

fu! BufNr(bufnr, mode, is_active_window)
    "return g:sep . ' ' . a:bufnr . ':' . a:mode . ' '
    return g:sep . '' . a:bufnr . '/' . a:mode
endf

fu! FileAndMode(bufnr, m, is_active_window)
    let s = ''
    let title_hi = '#StatusBarNormalInv#'
    if a:is_active_window
        if (a:m ==# 'i')
            let title_hi = '#StatusBarInsertInv#'
        elseif (a:m ==# 'R')
            let title_hi = '#StatusBarReplaceInv#'
        elseif (a:m ==# 'v' || a:m ==# 'V' || a:m ==# nr2char(22))
            let title_hi = '#StatusBarVisualInv#'
        elseif (a:m ==# 't')
            let title_hi = '#StatusBarTerminalInv#'
        endif
    else
        let title_hi = '#StatusBarInactiveInv#'
    endif
    let l:filetype = getbufvar(a:bufnr, '&filetype')
    let l:file_icon = FileIcon(l:filetype)
    let s .= '%' . title_hi . ' ' . ((a:m == 'n') ? l:file_icon : g:mode_map[a:m]) . ' '
    let s .= '%' . title_hi . '%<%f%m '
    return s
endf

fu! Spacer(bufnr, m, is_active_window)
    return '%*%='
endf

let g:status_bar = [
            \ 'FileAndMode',
            \ 'PieCrumbs',
            \ 'Spacer',
            \ 'FileType',
            \ 'BufNr',
            \ 'FilePos',
            \ 'CharCode',
            \ 'AleWarnings',
            \ 'AleErrors'
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
    "let s .= '%*%<%f'
    "let s .= '%*'

    "let s .= TagBarLoc()
    "if a:file_type ==# 'python'
    "    "let s .= ' ' . ASTLoc()
    "    let s .= PieCrumbs(1) . ' %#StatusBarText#'
    "endif
    "let s .= '%='
    "let s .= 'A=' . win_getid() . ' C=' . a:winid
    "" let s .= '%#StatusBarText#'
    "let s .= ' ' . FileIcon() . '  ' . FileType() . ' '
    "let s .= ' ' . ScrollProgress() . ' '
    "let s .= FileType()
    "let s .= BufNr(bufnr, m)
    ""let s .= g:sep . ' ' . a:file_type . ' '
    ""let s .= Branch()
    "let s .= FilePos()
    "let s .= CharCode(bufnr)
    ""let s .= AleStatus(bufnr)
    "let s .= AleWarnings(bufnr)
    "let s .= AleErrors(bufnr)
    ""let s .= color . g:rotate_icons[g:rotate_state % 4] . ' '
    "let s .= end
    for l:fn in g:status_bar
        let s .= call(l:fn, [l:bufnr, l:m, l:is_active_window])
    endfo
    let s .= ' '
    return l:s
endf

"let g:rotate_state = 0
" let g:rotate_icons = ['—', '\', '|', '/']
""let g:rotate_icons = ['◜', '◝', '◞', '◟']
"fu Rotate(timer)
"    let g:rotate_state = g:rotate_state + 1
"endf
"fu RotateIcon()
"    return g:rotate_icons[g:rotate_state % 4]
"endf

"call timer_start(100, 'Rotate', {'repeat': -1})

set laststatus=2
fu InitStatusBar()
    if &filetype == 'tagbar'
        return
    endif
    let &l:statusline='%!StatusBar('.win_getid().')'
endf
au VimEnter,WinNew,BufEnter * call InitStatusBar()
au VimEnter,WinEnter,BufEnter * call SLEnter()
au FileType qf call InitStatusBar()
au FileType tagbar call InitStatusBar()
"au VimEnter,WinNew * setlocal statusline=%!StatusBar(win_getid())
"set statusline=%!StatusBar()

