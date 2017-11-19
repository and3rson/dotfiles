" Insert
hi StatusBarInsert ctermbg=197 ctermfg=0
hi StatusBarInsertInv ctermbg=none ctermfg=197
" Visual
hi StatusBarVisual ctermbg=81 ctermfg=0
hi StatusBarVisualInv ctermbg=none ctermfg=81
" Normal
hi StatusBarNormal ctermbg=118 ctermfg=0
hi StatusBarNormalInv ctermbg=none ctermfg=118
" Normal
hi StatusBarReplace ctermbg=222 ctermfg=0
hi StatusBarReplaceInv ctermbg=none ctermfg=222
" Text
hi StatusBarText ctermfg=245
" Error parts
hi StatusBarWarning ctermfg=3 ctermbg=none cterm=bold
hi StatusBarError ctermfg=1 ctermbg=none cterm=bold

let g:mode_map = {
    \ '__': '',
    \ 'n': '',
    \ 'i': '',
    \ 'R': '',
    \ 'c': '',
    \ 'v': '',
    \ 'V': '',
    \ '^V': '',
    \ 's': '',
    \ 'S': '',
    \ '^S': '',
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

"call SetStatusLineColor('n')

hi StatusLine ctermfg=255 cterm=None gui=None ctermbg=None

" !!!
set lazyredraw

function! StatusBar()
    let s = ''
    let end = '%*'
    let m = mode()
    if (m ==# 'i')
        let mn = 'Insert'
    elseif (m ==# 'R')
        let mn = 'Replace'
    elseif (m ==# 'v' || m ==# 'V')
        let mn = 'Visual'
    else
        let mn = 'Normal'
    endif
    let c1 = printf('%%#StatusBar%s#', mn)
    let c2 = printf('%%#StatusBar%sInv#', mn)
    let s .= c1 . ' ' . g:mode_map[m] . ' ' . end
    let s .= c2 . ' %<%F '
    let s .= ' %='
    let s .= '%#StatusBarText# :%l.%c/%L '
    let s .= ' ' . CharCode() . ' '
    let s .= '%#StatusBarWarning#' . AleWarnings()
    let s .= '%#StatusBarError#' . AleErrors()
    let s .= end
    return s
endfunction

set laststatus=2
set statusline=%!StatusBar()

