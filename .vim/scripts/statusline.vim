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

"\ 'n': '',
let g:mode_map = {
    \ '__': '',
    \ 'n': '',
    \ 'i': '',
    \ 'R': '',
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
        let char = ' '
    endif

    return printf("%3d 0x%04x (%s)", code, code, char)
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
    return l:warnings == 0 ? '' : (' ' . l:warnings . 'W ')
endfunction

function! AleErrors() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:errors = l:counts.error + l:counts.style_error
    return l:errors == 0 ? '' : (' ' . l:errors . 'E ')
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? '' : printf(
    \   ' %dW %dE ',
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

hi StatusLine ctermfg=255 cterm=None gui=None ctermbg=None

" !!!
set lazyredraw

let g:active_winnr = winnr()

function! StatusBar(winid)
    let s = ''
    let end = '%*'
    let m = mode()
    let tn = 'Text'
    if win_getid() == a:winid
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
        let mn = 'Inactive'
        let tn = 'Inactive'
    endif
    let c1 = printf('%%#StatusBar%s#', mn)
    let c2 = printf('%%#StatusBar%sInv#', mn)
    let ct = printf('%%#StatusBar%s#', tn)
    let s .= c1 . ' ' . ((m == 'n') ? FileIcon() : g:mode_map[m]) . ' ' . end
    let s .= c2 . ' %<%F '
    let s .= ' %='
    "let s .= 'A=' . win_getid() . ' C=' . a:winid
    let s .= ct
    "let s .= ' ' . FileIcon() . '  ' . FileType() . ' '
    "let s .= ' ' . ScrollProgress() . ' '
    let s .= ' :%04l.%02c/%L '
    let s .= ' ' . CharCode() . ' '
    let s .= '%#StatusBarWarning#' . AleWarnings()
    let s .= '%#StatusBarError#' . AleErrors()
    let s .= end
    return s
endfunction

set laststatus=2
function InitStatusBar()
    let &l:statusline='%!StatusBar('.win_getid().')'
endfunction
au VimEnter,WinNew * call InitStatusBar()
"au VimEnter,WinNew * setlocal statusline=%!StatusBar(win_getid())
"set statusline=%!StatusBar()

