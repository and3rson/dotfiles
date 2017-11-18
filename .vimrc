""""""""""""""""""""""""""""""""
" Vundle
""""""""""""""""""""""""""""""""

set nocompatible
filetype off

set nowrap

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.vim/scripts
set t_Co=256
call vundle#begin()

let g:python_highlight_all = 1
let g:python_highlight_indent_errors = 1
let g:python_space_error_highlight = 1

Plugin 'VundleVim/Vundle.vim'

"Plugin 'scrooloose/nerdtree' 	    	" Project and file navigation
"Plugin 'majutsushi/tagbar'          	" Class/module browser
Plugin 'scrooloose/nerdcommenter'

" Plugin 'mitsuhiko/vim-python-combined'  " Combined Python 2/3 for Vim
"Plugin 'davidhalter/jedi-vim'
Plugin 'tpope/vim-fugitive'

"Plugin 'vim-airline/vim-airline'
"Plugin 'vim-airline/vim-airline-themes'

Plugin 'ap/vim-buftabline'

"Plugin 'wincent/command-t'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tacahiroy/ctrlp-funky'

" Plugin 'michaeljsmith/vim-indent-object'
" Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Yggdroot/indentLine'
"Plugin 'hdima/python-syntax'

"Plugin 'terryma/vim-expand-region'

"Plugin 'python-mode/python-mode'

" Plugin 'kevinw/pyflakes-vim'

"Plugin 'vim-syntastic/syntastic'
Plugin 'w0rp/ale'

Plugin 'Vimjas/vim-python-pep8-indent'

"Plugin 'ryanoasis/vim-devicons'

"Plugin 'and3rson/piecrumbs'
"Plugin 'tomtom/tcomment_vim'

Plugin 'airblade/vim-gitgutter'
"Plugin 'kshenoy/vim-signature'

Plugin 'ervandew/supertab'

"Plugin 'Valloric/YouCompleteMe'

" Plugin 'nvie/vim-flake8'

"Bundle 'jistr/vim-nerdtree-tabs'
" Plugin 'jistr/vim-nerdtree-tabs'

Plugin 'ap/vim-css-color'
Plugin 'osyo-manga/vim-over'

call vundle#end()            		" required

filetype on
filetype plugin on
filetype plugin indent on


""""""""""""""""""""""""""""""""
" Configs
""""""""""""""""""""""""""""""""


syntax enable

" Theme
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai

set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

" Gui
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

set guifont=DejaVu\ Sans\ Mono\ 9

" One extra char at the end of the line
set virtualedit=onemore

set splitbelow
set splitright

nnoremap <End> g$

set number
set relativenumber

set whichwrap+=<,>,h,l,[,]

" Timeouts
set timeoutlen=500 ttimeoutlen=250


" Switch buffers
nnoremap <silent> <ESC>[5;2~ :bp<CR>
nnoremap <silent> <ESC>[6;2~ :bn<CR>
inoremap <silent> <ESC>[5;2~ <ESC>:bp<CR>
inoremap <silent> <ESC>[6;2~ <ESC>:bn<CR>

" Switch buffers (NeoVIM)
nnoremap <silent> <S-PageUp> :bp<CR>
nnoremap <silent> <S-PageDown> :bn<CR>
inoremap <silent> <S-PageUp> <ESC>:bp<CR>
inoremap <silent> <S-PageDown> <ESC>:bn<CR>

" Jump words
nnoremap <silent> <ESC>[1;5D b
nnoremap <silent> <ESC>[1;5C w
inoremap <silent> <ESC>[1;5D <C-o>b
inoremap <silent> <ESC>[1;5C <C-o>w

" Move lines
nnoremap <silent> <C-Up> :call feedkeys(line('.') == 1 ? '' : '"mddk"mP')<CR>
nnoremap <silent> <C-Down> ddp
inoremap <C-Up> <C-o>:call feedkeys(line('.') == 1 ? '' : '<C-o>"mdd<C-o>k<C-o>"mP')<CR>
inoremap <C-Down> <C-o>:execute "normal! \"mdd\"mp"<CR>

" Save with C-s
nnoremap <C-s> :w<CR>
inoremap <C-s> <C-o>:w<CR>

" Delete buffer
nnoremap <silent> <C-x>      :bd<CR>
"nnoremap b  :buffers<CR>:b

" Search symbols
nnoremap <silent> <C-l> :CtrlPFunky<CR>
inoremap <silent> <C-l> <ESC>:CtrlPFunky<CR>

nnoremap <silent> <C-_> :call NERDComment(0, "toggle")<CR><CR>
"vnoremap <silent> <C-_> :call NERDComment(0, "alignleft")<CR><CR>
"vnoremap <silent> <C-_> :call ToggleOrSexy()<CR>
vnoremap <silent> <C-_> :call NERDComment(0, "toggle")<CR><CR>
inoremap <silent> <C-_> <C-o>:call NERDComment(0, "toggle")<CR><C-o><CR>

map <PageUp> <C-u>
map <PageDown> <C-d>

" Ctrl-P
let g:ctrlp_funky_syntax_highlight = 1
let g:ctrlp_funky_matchtype = 'path'

let g:webdevicons_enable_ctrlp = 1
" let g:ctrlp_max_height = 20
let g:ctrlp_match_window = 'bottom,order:ttb,min:16,max:16,results:16'
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_map = '<c-k>'
let g:ctrlp_custom_ignore = '\v[\/](\.git|node_modules|\.env[236]*|\.cache|\.exe|\.so|\.pyc|\.pyo|__pycache__|build)'

let g:ctrlp_user_command = {
            \   'types': {
            \       1: ['.git', 'cd %s && git ls-files -co --exclude-standard'],
            \   },
\}
let g:ctrlp_match_current_file = 0
let g:ctrlp_types = ['fil']

let g:ctrlp_cmd = 'CtrlPMRUFiles' " Does not work

nnoremap <silent> <C-p>      :CtrlP<CR>

" Completion mode
"set wildmode=longest,list,full
set wildmode=longest,list
set wildmenu

" Smart home
noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
imap <silent> <Home> <C-O><Home>
nmap <silent> <Esc>OH <Home>
nmap <silent> <Esc>OF <End>
imap <silent> <Esc>OH <C-o><Home>
imap <silent> <Esc>OF <C-o><End>

" Delete words
inoremap <C-h> <C-W>

" Unindent

nnoremap <S-Tab> <<
inoremap <S-Tab> <C-d>

" Show cursor line, hide cursor column
set cursorline
set nocursorcolumn

" Vertical sep
set fillchars+=vert:│

" Cursor

hi CursorLine ctermbg=235 " cterm=underline
hi CursorColumn ctermbg=235
hi StatusLine ctermfg=233
hi StatusLineNC ctermbg=None ctermfg=240 cterm=None
" ctermbg=7
hi MatchParen ctermfg=magenta ctermbg=none
hi CursorLineNr ctermfg=119 cterm=bold
" 161
" Molokai theme patches

hi Normal guibg=NONE ctermbg=NONE
hi NonText ctermbg=NONE
"hi EndOfBuffer ctermfg=118

" Indentation
set tabstop=4 softtabstop=4 shiftwidth=4

" Chars
set list listchars=tab: ,trail:·,extends:»,precedes:«,nbsp:×
" 

" let g:indent_guides_enable_on_vim_startup=1
let g:indentLine_char = '▏'
let g:indentLine_first_char = '▏'
"let g:indentLine_first_char = '>'
" let g:indentLine_first_char = 'x'
" let g:indentLine_char = 'x'
" let g:indentLine_leadingSpaceChar = '·'
" let g:indentLine_leadingSpaceEnabled = 1
" let g:indentLine_setColors = 0
let g:indentLine_concealcursor = ''
" let g:indentLine_conceallevel = 1
" let g:indentLine_setConceal = 0
let g:indentLine_color_term = 239
" let g:indentLine_bgcolor_term = 202
let g:indentLine_showFirstIndentLevel = 0
let g:indentLine_fileTypeExclude = ['text', 'json', 'help']
let g:indentLine_faster = 1 " TODO: Experimental

" Fix cursor positioning on I->N mode switch
" au InsertLeave * call cursor([getpos('.')[1], getpos('.')[2]+1])

" Conceal

syn keyword Operator lambda conceal cchar=λ

" Backups

" set backupdir=/tmp
" set directory=/tmp
set noswapfile
set nobackup

" Sudo write
:command SudoW w !sudo tee %

" Clipboard fix
set clipboard=unnamedplus

" Remove trailing whitespaces
function CleanUp()
    %s/\s\+$//e
    " |norm!``
endfunction
autocmd BufWritePre * call CleanUp()

":set noeol
":set nofixeol

" Allow switching to other buffer if current buffer has unsaved changes
set hidden

let g:CursorColumnI = 0 "the cursor column position in INSERT

function! InsertEnterHook()
    ":set norelativenumber
    hi BufTabLineActive ctermbg=161 ctermfg=255 cterm=bold
    hi BufTabLineCurrent ctermbg=161 ctermfg=255 cterm=bold
    hi CursorLineNr ctermfg=161
    let g:CursorColumnI = col('.')
endfunction

function! InsertLeaveHook()
    ":set relativenumber
    hi BufTabLineActive ctermbg=118 ctermfg=0 cterm=bold
    hi BufTabLineCurrent ctermbg=118 ctermfg=0 cterm=bold
    hi CursorLineNr ctermfg=118
    if col('.') != g:CursorColumnI | call cursor(0, col('.')+1) | endif
endfunction

autocmd InsertEnter * call InsertEnterHook()
autocmd InsertLeave * call InsertLeaveHook()
autocmd CursorMovedI * let CursorColumnI = col('.')

"let &t_EI .= "\<Esc>[2 q\<Esc>]12;green\x7"
"let &t_SI .= "\<Esc>[2 q\<Esc>]12;red\x7"
"let &t_EI .= "\<Esc>[6 q"
"let &t_SI .= "\<Esc>[2 q"

"autocmd VimLeave * silent !echo -ne "\033]112\007"

" NERDTress File highlighting
"function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
"exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
"exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
"endfunction

" piecrumbs

let g:piecrumbs_glue = '  '

" Switch between windows using Tab
nnoremap <Tab> <C-W>w

"set omnifunc=syntaxcomplete#Complete

function! Compl(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && (len(matchstr(line[start - 1], '[a-zA-Z_]')) != 0)
            let start -= 1
        endwhile
        return start
    else
        let expr = ''
        for c in split(a:base, '\zs')
            if len(expr) == 0
                let expr .= c
            else
                let expr .= '[a-zA-Z0-9_]*' . c
            endif
        endfor
        let current_line = 0
        let line_count = line('$')
        echo current_line
        echo line_count
        let matches = []
        while current_line < line_count
            call substitute(getline(current_line), '[a-zA-Z_][a-zA-Z0-9_]*', '\=add(matches, submatch(0))', 'g')
            "let m = matchstr(getline(current_line), '[a-zA-Z_][0-9]\*')
            "echo matches
            let current_line += 1
        endwhile
        let results = []
        for m in matches
            "echo m
            "echo expr
            "echo x
            if len(matchstr(m, expr))
                "echo 'MATCHED ' . m
                "echo x
                call add(results, m)
            endif
        endfor
        return results
        "return [a:base . 'aa', a:base . 'ab', a:base . 'ac']
    endif
endfunction

" SuperTab
let g:SuperTabDefaultCompletionType = "<C-X><C-U>"
inoremap <C-p> <C-X><C-U>
set completefunc=Compl

" Completion tweaks
inoremap <expr> <Esc>      pumvisible() ? "\<C-o>\<Esc>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
"inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
"inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
"inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

" BufTabLine

let g:buftabline_indicators = 1
let g:buftabline_seperators = 1
hi BufTabLineFill ctermbg=233
hi BufTabLineCurrent ctermbg=118 ctermfg=0 cterm=bold
hi BufTabLineActive ctermbg=118 ctermfg=0 cterm=bold
hi BufTabLineHidden ctermbg=238

" Custom status

hi User1 ctermfg=245
hi User2 ctermfg=197
"hi User1 ctermfg=250
"hi User1 ctermbg=208 " Orange

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

" Status line color for different modes
let g:last_mode = ''
function SetStatusLineColor()
    let m = mode()
    if m ==# g:last_mode
        return ''
    endif
    let g:last_mode = m
    if (m ==# 'i')
        exe 'hi! StatusLine ctermfg=197'
    elseif (m ==# 'v' || mode() ==# 'V')
        exe 'hi! StatusLine ctermfg=81'
    else
        exe 'hi! StatusLine ctermfg=118'
    endif
    return ''
endfunction

" Char code
function! CharCode()
    let char = matchstr(getline('.'), '\%' . col('.') . 'c.')
    let code = char2nr(char)

    if code == 0
        let char = ' '
    endif

    return printf("%3d 0x%04x (%s)", code, code, char)
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

hi StatusLine cterm=None cterm=None gui=None ctermbg=None

" !!!
set lazyredraw

set laststatus=2
set statusline=
set statusline +=%{SetStatusLineColor()}
set statusline +=\ %{mode_map[mode()]}\ %*
set statusline +=\ %<%F%*
set statusline +=%=
set statusline +=%1*:%l.%c/%L\ %*
set statusline +=%1*\ %{CharCode()}\ %*
"set statusline +=%1*%3b\ 0x%04B
set statusline +=%2*%{LinterStatus()}%*
"set statusline +=%{strftime('%c')}
"set statusline +=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
"set statusline +=%=a
"set statusline +=%{SetStatusLineColor()}

" ALE
let g:ale_linters = {
            \'javascript': ['eslint'],
            \'python': ['flake8']
            \}

nnoremap <silent> ; :ALEPrevious<CR>
nnoremap <silent> ' :ALENext<CR>

hi Error ctermfg=235 ctermbg=161

let g:ale_sign_error = '->'
let g:ale_sign_warning = '-]'
"let g:ale_sign_column_always = 1

" GitGutter
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
set signcolumn=yes
"let g:gitgutter_sign_column_always = 1

" VimSignature
let g:SignatureMap = {
    \ 'Leader'             :  "m",
    \ 'PlaceNextMark'      :  "m,",
    \ 'ToggleMarkAtLine'   :  "m.",
    \ 'PurgeMarksAtLine'   :  "m-",
    \ 'DeleteMark'         :  "dm",
    \ 'PurgeMarks'         :  "m!",
    \ 'PurgeMarkers'       :  "m<BS>",
    \ 'GotoNextLineAlpha'  :  "']",
    \ 'GotoPrevLineAlpha'  :  "'[",
    \ 'GotoNextSpotAlpha'  :  "`]",
    \ 'GotoPrevSpotAlpha'  :  "`[",
    \ 'GotoNextLineByPos'  :  "]'",
    \ 'GotoPrevLineByPos'  :  "['",
    \ 'GotoNextSpotByPos'  :  "]`",
    \ 'GotoPrevSpotByPos'  :  "[`",
    \ 'GotoNextMarker'     :  "]-",
    \ 'GotoPrevMarker'     :  "[-",
    \ 'GotoNextMarkerAny'  :  "]=",
    \ 'GotoPrevMarkerAny'  :  "[=",
    \ 'ListBufferMarks'    :  "m/",
    \ 'ListBufferMarkers'  :  "m?"
    \ }

" Fast Escape
" https://www.reddit.com/r/vim/comments/2391u5/delay_while_using_esc_to_exit_insert_mode/cgw9xrh/

augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=500
augroup END

inoremap <C-c> <Esc>

" Custom signs
let i = 0
while i < 10
    exe 'sign define Sign_'.i.' text='.i.' texthl=Function'
    exe 'nnoremap <silent> mm'.i.' :call SignPlace('.i.')<CR>'
    exe 'nnoremap <silent> m'.i.' :call SignJump('.i.')<CR>'
    let i = i + 1
endwhile

function! EnsureSigns()
    if ! exists('b:signs')
        let b:signs = 1
        let b:sign_line_to_id = {}
        let b:sign_id_to_line = {}
    endif
endfunction

function! SignPlace(id)
    call EnsureSigns()

    let exists = has_key(b:sign_line_to_id, line('.'))
    let is_same = 0
    if exists && (b:sign_line_to_id[line('.')] ==# a:id)
        let is_same = 1
    endif

    if exists
        exe 'sign unplace '.(line('.')+4000000).' buffer='.buffer_number('.')
        let old_id= b:sign_line_to_id[line('.')]
        unlet b:sign_line_to_id[line('.')]
        unlet b:sign_id_to_line[old_id]
    endif
    if ! is_same
        if has_key(b:sign_id_to_line, a:id)
            echo 'EXISTS'
            exe 'sign unplace '.(b:sign_id_to_line[a:id]+4000000).' buffer='.buffer_number('.')
        endif
        exe 'sign place '.(line('.')+4000000).' line='.line('.').' name=Sign_'.a:id.' buffer='.buffer_number('.')
        let b:sign_line_to_id[line('.')] = a:id
        let b:sign_id_to_line[a:id] = line('.')
    endif
endfunction

function! SignJump(id)
    call EnsureSigns()

    if has_key(b:sign_id_to_line, a:id)
        exe ':'.b:sign_id_to_line[a:id]
    else
        echo 'Sign ' . a:id . ' not found'
    endif
endfunction

" Sexy replace
:map <C-f> :OverCommandLine<CR>:%

