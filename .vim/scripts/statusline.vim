hi! StatusBarInsert ctermbg=197 ctermfg=0
hi! StatusBarInsertInv ctermbg=234 ctermfg=197
" Visual
hi! StatusBarVisual ctermbg=81 ctermfg=0
hi! StatusBarVisualInv ctermbg=234 ctermfg=81
" Normal
hi! StatusBarNormal ctermbg=118 ctermfg=0
hi! StatusBarNormalInv ctermbg=234 ctermfg=118
" Replace
hi! StatusBarReplace ctermbg=222 ctermfg=0
hi! StatusBarReplaceInv ctermbg=234 ctermfg=222
" Terminal
hi! StatusBarTerminal ctermbg=57 ctermfg=0
hi! StatusBarTerminalInv ctermbg=234 ctermfg=57
" Inactive
hi! StatusBarInactive ctermfg=238 ctermbg=232
hi! StatusBarInactiveInv ctermfg=238 ctermbg=232
" Text
hi! StatusBarText ctermfg=248 ctermbg=234
" Error parts
hi! StatusBarWarning ctermfg=3 ctermbg=234 cterm=bold
hi! StatusBarError ctermfg=1 ctermbg=234 cterm=bold

" PieCrumbs
hi! PieClass ctermfg=197 ctermbg=234 cterm=bold
hi! PieFunction ctermfg=154 ctermbg=234

"\ 'n': '',
"\ 'i': '',
"\ 'R': '',
let g:mode_map = {
    \ '__': '',
    \ 'n': '',
    \ 'i': g:ic.insert,
    \ 'R': g:ic.replace,
    \ 'c': '',
    \ 'v': '',
    \ 'V': '',
    \ nr2char(22): '',
    \ 's': '',
    \ 'S': '',
    \ '^S': '',
    \ 't': ''
    \ }
let g:sep = ' ⎪ '

set noshowmode

" Char code
fu! CharCode(bufnr)
    "echo getbufline(a:bufnr, '.')
    let char = matchstr(getbufline(a:bufnr, '.'), '\%' . col('.') . 'c.')
    let code = char2nr(char)

    if code == 0
        let char = ''
    elseif code == 32
        let char = ''
    elseif code == 9
        let char = ''
    endif


    return printf("%s (0x%04x)", char, code)
endf

fu! Clamp(smin, smax, dmin, dmax, value)
    let smin = a:smin * 1.0
    let smax = a:smax * 1.0
    let k = (a:value - smin) / (smax - smin)
    return a:dmin + (a:dmax - a:dmin) * k
endf

fu! ScrollProgress()
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

fu! AleWarnings(bufnr, reset_style) abort
    let l:counts = ale#statusline#Count(a:bufnr)
    let l:errors = l:counts.error + l:counts.style_error
    let l:warnings = l:counts.total - l:errors
    "return l:warnings == 0 ? '' : ('  ' . l:warnings . ' ')
    return l:warnings == 0 ? '' : ('%#StatusBarWarning# ' . l:warnings . a:reset_style . g:sep)
endf

fu! AleErrors(bufnr, reset_style) abort
    let l:counts = ale#statusline#Count(a:bufnr)
    let l:errors = l:counts.error + l:counts.style_error
    return l:errors == 0 ? '' : ('%#StatusBarError# ' . l:errors . a:reset_style . g:sep)
endf

fu! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? '' : printf(
    \   '  %d  %d' . g:sep,
    \   all_non_errors,
    \   all_errors
    \)
endf

fu! FileIcon()
    let ft = &filetype
    return has_key(g:ic, ft) ? g:ic[ft] : g:ic.default
endf

fu! FileType()
    let ft = &filetype
    return has_key(g:abbr, ft) ? g:abbr[ft] : ft
endf

"call SetStatusLineColor('n')

let g:winid = win_getid()
fu! SLEnter()
    let g:winid = win_getid()
endf

hi StatusLine ctermfg=255 cterm=None gui=None ctermbg=None

" !!!
set lazyredraw

let g:active_winnr = winnr()

fu! PieCrumbs(show_signatures)
    let result = ''
    if a:show_signatures
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
    let result .= '%#StatusBarText#  '
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
        let result .= a:show_signatures ? part[2] : '()'
        "echohl Normal
        "let remaining = PieCrumbsPrintTrimmed(remaining, part[2])
    endfor
    return result
endf

fu! Branch()
    let head = fugitive#head()
    if strlen(head)
        if strlen(head) > 16
            let head = head[:15] . '>'
        endif
        let br = ' ' . head . g:sep
        return br
    endif
    return ''
endf

fu! StatusBar(winid, file_type, file_icon)
    let s = ''
    let end = '%*'
    let tn = 'Text'
    let bufnr = -1
    for bufinfo in getbufinfo()
        if index(bufinfo.windows, str2nr(a:winid)) != -1
            let bufnr = bufinfo.bufnr
        endif
    endfor
    if g:winid == a:winid
        if a:file_type == 'qf'
            let m ='t'
            let mn = 'Insert'
            let tn = 'Text'
        else
            let m = mode()
            if (m ==# 'i')
                let mn = 'Insert'
            elseif (m ==# 'R')
                let mn = 'Replace'
            elseif (m ==# 'v' || m ==# 'V' || m ==# nr2char(22))
                let mn = 'Visual'
            elseif (m ==# 't')
                let mn = 'Terminal'
            else
                let mn = 'Normal'
            endif
        endif
    else
        let m = 'n'
        let mn = 'Inactive'
        let tn = 'Inactive'
    endif
    let c1 = printf('%%#StatusBar%s#', mn)
    let c2 = printf('%%#StatusBar%sInv#', mn)
    let ct = printf('%%#StatusBar%s#', tn)
    let s .= c1 . ' ' . ((m == 'n') ? a:file_icon : g:mode_map[m]) . ' ' . end
    let s .= c2 . ' %<%F'
    if a:file_type ==# 'python'
        "let s .= ' ' . ASTLoc()
        let s .= PieCrumbs(1) . ' %#StatusBarText#'
    endif
    let s .= '%='
    "let s .= 'A=' . win_getid() . ' C=' . a:winid
    let s .= ct
    "let s .= ' ' . FileIcon() . '  ' . FileType() . ' '
    "let s .= ' ' . ScrollProgress() . ' '
    let s .= '' . bufnr . g:sep
    let s .= Branch()
    let s .= '%04l.%02c/%L' . g:sep
    "let s .= CharCode(bufnr) . g:sep
    let s .= '%#StatusBarWarning#' . AleWarnings(bufnr, ct)
    let s .= '%#StatusBarError#' . AleErrors(bufnr, ct)
    let s .= ct . g:rotate_icons[g:rotate_state % 4] . ' '
    let s .= end
    return s
endf

let g:rotate_state = 0
let g:rotate_icons = ['—', '\', '|', '/']
fu Rotate(timer)
    let g:rotate_state = g:rotate_state + 1
endf

call timer_start(100, 'Rotate', {'repeat': -1})

set laststatus=2
fu InitStatusBar()
    let &l:statusline='%!StatusBar('.win_getid().', "' . &filetype . '", "' . FileIcon() . '")'
endf
au VimEnter,WinNew,BufEnter * call InitStatusBar()
au VimEnter,WinEnter,BufEnter * call SLEnter()
au FileType qf call InitStatusBar()
"au VimEnter,WinNew * setlocal statusline=%!StatusBar(win_getid())
"set statusline=%!StatusBar()

