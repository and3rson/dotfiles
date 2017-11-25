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
hi! StatusBarInactive ctermfg=245 ctermbg=236
hi! StatusBarInactiveInv ctermfg=245 ctermbg=234
" Text
hi! StatusBarText ctermfg=245 ctermbg=234
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

set noshowmode

" Char code
function! CharCode()
    let char = matchstr(getline('.'), '\%' . col('.') . 'c.')
    let code = char2nr(char)

    if code == 0
        let char = ''
    elseif code == 32
        let char = ''
    elseif code == 9
        let char = ''
    endif


    return printf("%s (0x%04x)", char, code)
endfunction

function! Clamp(smin, smax, dmin, dmax, value)
    let smin = a:smin * 1.0
    let smax = a:smax * 1.0
    let k = (a:value - smin) / (smax - smin)
    return a:dmin + (a:dmax - a:dmin) * k
endfunction

function! ScrollProgress()
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
endfunction

function! AleWarnings() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:errors = l:counts.error + l:counts.style_error
    let l:warnings = l:counts.total - l:errors
    "return l:warnings == 0 ? '' : ('  ' . l:warnings . ' ')
    return l:warnings == 0 ? '' : ('  ' . l:warnings . ' ')
endfunction

function! AleErrors() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:errors = l:counts.error + l:counts.style_error
    return l:errors == 0 ? '' : ('  ' . l:errors . ' ')
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? '' : printf(
    \   '  %d  %d ',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

function! FileIcon()
    let ft = &filetype
    return has_key(g:ic, ft) ? g:ic[ft] : g:ic.default
endfunction

function! FileType()
    let ft = &filetype
    return has_key(g:abbr, ft) ? g:abbr[ft] : ft
endfunction

"call SetStatusLineColor('n')

let g:winid = win_getid()
function! SLEnter()
    let g:winid = win_getid()
endfunction

hi StatusLine ctermfg=255 cterm=None gui=None ctermbg=None

" !!!
set lazyredraw

let g:active_winnr = winnr()

function! PieCrumbs(show_signatures)
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
    "echo ''
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
endfunction

function! StatusBar(winid, file_type, file_icon)
    let s = ''
    let end = '%*'
    let tn = 'Text'
    if g:winid == a:winid
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
    let head = fugitive#head()
    if strlen(head)
        let s .= '  ' . head . ' '
    endif
    let s .= ' :%04l.%02c/%L '
    let s .= ' ' . CharCode() . ' '
    let s .= '%#StatusBarWarning#' . AleWarnings()
    let s .= '%#StatusBarError#' . AleErrors()
    let s .= end
    return s
endfunction

set laststatus=2
function InitStatusBar()
    let &l:statusline='%!StatusBar('.win_getid().', "' . &filetype . '", "' . FileIcon() . '")'
endfunction
au VimEnter,WinNew,BufEnter * call InitStatusBar()
au VimEnter,WinEnter,BufEnter * call SLEnter()
"au VimEnter,WinNew * setlocal statusline=%!StatusBar(win_getid())
"set statusline=%!StatusBar()

