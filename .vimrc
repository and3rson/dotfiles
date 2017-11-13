""""""""""""""""""""""""""""""""
" Vundle
""""""""""""""""""""""""""""""""

set nocompatible
filetype off

set nowrap

set rtp+=~/.vim/bundle/Vundle.vim
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
"Plugin 'tpope/vim-fugitive'

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

"Plugin 'airblade/vim-gitgutter'

Plugin 'ervandew/supertab'

"Plugin 'Valloric/YouCompleteMe'

" Plugin 'nvie/vim-flake8'

"Bundle 'jistr/vim-nerdtree-tabs'
" Plugin 'jistr/vim-nerdtree-tabs'


call vundle#end()            		" required

filetype on
filetype plugin on
filetype plugin indent on


""""""""""""""""""""""""""""""""
" Configs
""""""""""""""""""""""""""""""""


syntax enable
colorscheme molokai
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
" Plugin 'sickill/vim-monokai'

:set guioptions-=m  "remove menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar

set guifont=DejaVu\ Sans\ Mono\ 9

:set virtualedit=onemore

set splitbelow
set splitright
" g$:set ve= ve=all<CR>
nnoremap <End> g$
set number
set relativenumber

set whichwrap+=<,>,h,l,[,]


"turn off status line
"set laststatus=0
set ls=0
set showtabline=1
"set tabline="what status line equals, or equaled or whatever"
"set or change the color of the tabline
" hi tablinefill cterm=none ctermbg=blue ctermfg=white gui=none guibg=blue guifg=white

"Plugin 'vim-airline/vim-airline'
"Plugin 'vim-airline/vim-airline-themes'

"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '│'
let g:airline#extensions#tabline#left_alt_sep = '⎸'
"let g:airline#extensions#tabline#left_alt_sep = ''
"map <F2> :!ls<CR>:e

":verbose nnoremap <C-[> :tabprevious<CR>
":verbose nnoremap <C-]> :tabnext<CR>
"inoremap <C-[> <Esc>:tabprevious<CR>icd ~/
"inoremap <C-]> <Esc>:tabnext<CR>i

"nnoremap <C-;> :tabprevious<CR>
"nnoremap <C-'>   :tabnext<CR>
"nnoremap <C-n>     :tabnew<CR>
"inoremap <C-S-tab> <Esc>:tabprevious<CR>i
"inoremap <C-tab>   <Esc>:tabnext<CR>i
"inoremap <C-t>     <Esc>:tabnew<CR>

nnoremap <silent> <ESC>[5;2~ :bp<CR>
nnoremap <silent> <ESC>[6;2~ :bn<CR>
nnoremap <silent> <ESC>[1;3D <C-w>h
nnoremap <silent> <ESC>[1;3C <C-w>l
nnoremap <silent> o <C-w>w


" inoremap <silent> <ESC>[5;2~ <ESC>:bp<CR>i
" inoremap <silent> <ESC>[6;2~ <ESC>:bn<CR>i
inoremap <silent> <ESC>[5;2~ <ESC>:bp<CR>
inoremap <silent> <ESC>[6;2~ <ESC>:bn<CR>

nnoremap <silent> <ESC>[1;5D b
nnoremap <silent> <ESC>[1;5C w
inoremap <silent> <ESC>[1;5D <C-o>b
inoremap <silent> <ESC>[1;5C <C-o>w

"nnoremap <C-[> :call feedkeys( line('.')==1 ? '' : 'ddkP' )<CR>
"nnoremap <C-]> ddp

nnoremap <C-s> :w<CR>
inoremap <C-s> <C-o>:w<CR>

" nnoremap <silent> <C-n>      :tabnew<CR>
" nnoremap <silent> <C-o>      :CtrlPMixed<CR>
nnoremap <silent> <C-p>      :CtrlPMixed<CR>
nnoremap <silent> <C-x>      :bd<CR>
nnoremap <silent> <C-q>      :q<CR>
"nnoremap b  :buffers<CR>:b

nnoremap <silent> <C-l> :CtrlPFunky<CR>
inoremap <silent> <C-l> <ESC>:CtrlPFunky<CR>

let g:ctrlp_funky_syntax_highlight = 1
let g:ctrlp_funky_matchtype = 'path'

function ToggleOrSexy() range
    echo matchstr(getline(a:firstline), '^[ ]*#')
    if len(matchstr(getline(a:firstline), '^[ ]*#'))
        "echo 'toggle'
        ":call NERDComment(a:firstline, a:lastline)
        exe a:firstline . ',' . a:lastline . 'call NERDComment(0, "toggle")'
    else
        "echo 'sexy'
        exe a:firstline . ',' . a:lastline . 'call NERDComment(0, "alignleft")'
    endif
endfunction

nnoremap <silent> <C-_> :call NERDComment(0, "toggle")<CR><CR>
"vnoremap <silent> <C-_> :call NERDComment(0, "alignleft")<CR><CR>
vnoremap <silent> <C-_> :call ToggleOrSexy()<CR>
inoremap <silent> <C-_> <C-o>:call NERDComment(0, "toggle")<CR><C-o><CR>

" Go to previous split
" nnoremap <ESC>[1;2D <C-W><C-H>

"map <C-o> <plug>NERDTreeTabsToggle<CR>
"map <Leader>n <plug>NERDTreeTabsToggle<CR>
"map <C-o> :q!<CR>

map <PageUp> <C-u>
map <PageDown> <C-d>

"let g:nerdtree_tabs_open_on_console_startup=1

""""""""""""""""""""""""""""""""
" Airline
""""""""""""""""""""""""""""""""

"let g:airline_powerline_fonts = 1
let g:airline_powerline_fonts = 0

let g:airline_theme='kalisi'
"let g:airline_theme='term'
"let g:airline_theme='molokai'
"let g:airline_solarized_bg='dark'

let g:airline_enable_branch=0
"let g:airline_mode_map = {
    "\ '__': '-',
    "\ 'n': 'N',
    "\ 'i': 'I',
    "\ 'R': 'R',
    "\ 'c': 'C',
    "\ 'v': 'V',
    "\ 'V': 'V',
    "\ '^V': 'V',
    "\ 's': 'S',
    "\ 'S': 'S',
    "\ '^S': 'S',
    "\ }
    "\ 'i': '',
let g:airline_mode_map = {
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

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#buffer_min_count = 1
let g:airline#extensions#tabline#combined = 1
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline_skip_empty_sections = 1

"let g:airline_left_sep = ''
"let g:airline_right_sep = ''
let g:airline_left_sep = ''
"let g:airline_left_sep = ''
let g:airline_right_sep = ''

let g:airline_left_sep = ''
let g:airline_right_sep = ''

":AirlineTheme badwolf
":AirlineTheme dark
":AirlineTheme deus

"set laststatus=0

set timeoutlen=0 ttimeoutlen=0

"let g:jedi#completions_command = "<C-Space>"
let g:jedi#completions_command = "<C-p>"
let g:jedi#popup_on_dot = 0
"let g:jedi#auto_initialization = 0
"let g:jedi#use_tabs_not_buffers = 1
let g:jedi#smart_auto_mappings = 0

let g:jedi#goto_command = "<C-M>"

let g:jedi#completions_enabled = 1

set noshowmode
let g:jedi#show_call_signatures = 0  " 2
let g:jedi#show_call_signatures_delay = 0
"call jedi#configure_call_signatures()

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

"imap <silent> <Home> <Esc><Home>i

:set cursorline
:set nocursorcolumn

:set fillchars+=vert:│

" CommandT
:let g:CommandTFileScanner = 'git'

" CtrlP
let g:webdevicons_enable_ctrlp = 1
" let g:ctrlp_max_height = 20
let g:ctrlp_match_window = 'bottom,order:ttb,min:16,max:16,results:16'
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_map = '<c-k>'
"let g:ctrlp_custom_ignore = {
            "\ 'dir': '\.git$|node_modules$|\.env$',
            "\ 'file': '\.exe$|\.so$|\.pyc$|\.pyo$|__pycache__$'
            "\ }
let g:ctrlp_custom_ignore = '\v[\/](\.git|node_modules|\.env[236]*|\.cache|\.exe|\.so|\.pyc|\.pyo|__pycache__)'

"let g:ctrlp_buffer_func = { 'enter': 'BrightHighlightOn', 'exit':  'BrightHighlightOff', }

"function BrightHighlightOn()
  "hi CursorLine ctermbg=darkred
"endfunction

"function BrightHighlightOff()
  "hi CursorLine ctermbg=235
"endfunction

"let g:ctrlp_prompt_mappings = {
"    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
"    \ 'AcceptSelection("t")': ['<cr>'],
"    \ }

" adding to vim-airline's tabline
let g:webdevicons_enable_airline_tabline = 1
" adding to vim-airline's statusline
let g:webdevicons_enable_airline_statusline = 1

" Cursor

hi CursorLine ctermbg=235 " cterm=underline
hi CursorColumn ctermbg=235
hi StatusLine ctermfg=233
hi StatusLineNC ctermfg=233 ctermbg=7
hi MatchParen ctermfg=magenta ctermbg=none
hi CursorLineNr ctermfg=255 cterm=bold
" 161
" Molokai theme patches

hi Normal guibg=NONE ctermbg=NONE
hi NonText ctermbg=NONE
hi EndOfBuffer ctermfg=118

filetype plugin on

" Indentation
set tabstop=4 softtabstop=4 shiftwidth=4
"set list listchars=tab:❘-,trail:·,extends:»,precedes:«,nbsp:×
set list listchars=tab: ,trail:·,extends:»,precedes:«,nbsp:×
" 

" let g:indent_guides_enable_on_vim_startup=1
"let g:indentLine_char = '▏'
let g:indentLine_char = '⎣'
"let g:indentLine_char = '⎨'
"let g:indentLine_char = '⎬'
"let g:indentLine_char = '├'
"let g:indentLine_char = '┊'
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
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_fileTypeExclude = ['text']
let g:indentLine_faster = 1 " TODO: Experimental

" PyMode
"
"let g:pymode_folding = 0
"let g:pymode_lint = 1
"let g:pymode_python = 'python'

"nnoremap <silent> <F5> :PymodeLint<CR>
"inoremap <silent> <F5> <C-o>:PymodeLint<CR>

"let g:pymode_python = 'python3'
"let g:pymode_rope = 0

" PyFlakes

let g:pyflakes_use_quickfix = 0

" Syntastic

" let g:syntastic_check_on_open = 1
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_error_symbol = '✖︎'
let g:syntastic_style_error_symbol = '✖︎'
let g:syntastic_warning_symbol = '∙∙'
let g:syntastic_style_warning_symbol = '∙∙'
let g:syntastic_always_populate_loc_list = 1

"nnoremap <silent> <F5> :w<CR>:SyntasticCheck<CR>
"inoremap <silent> <F5> <C-o>:w<CR><C-o>:SyntasticCheck<CR>
"nnoremap <silent> <F6> :Errors<CR>
"inoremap <silent> <F6> <C-o>:Errors<CR>

"nnoremap <silent> ; :lprev<CR>
"inoremap <silent> ; <C-o>:lprev<CR>i
"nnoremap <silent> ' :lnext<CR>
"inoremap <silent> <ESC>[] <C-o>:lnext<CR>i

" Fix cursor positioning on I->N mode switch
" au InsertLeave * call cursor([getpos('.')[1], getpos('.')[2]+1])

" Conceal

" syn keyword Operator lambda conceal cchar=λ

" Backups

" set backupdir=/tmp
" set directory=/tmp
set noswapfile
set nobackup

" Sudo write
:command SudoW w !sudo tee %

" Clipboard fix
set clipboard=unnamedplus

" Char code

function! CharSegment()
    let char = matchstr(getline('.'), '\%' . col('.') . 'c.')
    let code = char2nr(char)

    if code == 0
        let char = ' '
    endif

    "let g:airline_section_z .= ' ' . code
    return printf("0x%04x (%s)", code, char)
endfunction

function! SectionsInit()
  "call airline#parts#define_function('cwd', 'getcwd')
  "call airline#parts#define_minwidth('cwd', 80) "adjust as necessary, it'll check against windwidth()
  "let g:airline_section_b = airline#section#create(['Buf #[%n] ', 'cwd'])
  "let g:airline_section_z .= '  %{CharSegment()}'
  "let g:airline_section_a = 'A'
  "let g:airline_section_b = 'B'
  "let g:airline_section_c = 'C'
  "let g:airline_section_x = 'X'
  "let g:airline_section_y = 'Y'
  "let g:airline_section_z = 'Z'
  "let g:airline_section_b = g:airline_section_c
  "let g:airline_section_c = ' '
  let g:airline_section_b = ''
  "let g:airline_section_x = '%{Breadcrumbs()}'
  let g:airline_section_x = ''
  let g:airline_section_y = '%#__accent_bold#%4l%#__restore__#%#__accent_bold#/%L%#__restore__#:%-4c %{CharSegment()}'
  let g:airline_section_z = ''
endfunction

"autocmd VimEnter * call SectionsInit()
"augroup airline_init
    "autocmd!
    autocmd User AirlineAfterInit call SectionsInit()
"augroup END

" Make section Y customizable again!
let g:webdevicons_enable_airline_statusline_fileformat_symbols = 0

" Error/warning highlights

"hi SpellBad ctermbg=9
"hi SpellCap ctermbg=11

" Interactive bash (with .bashrc)
":set shellcmdflag=-ic

let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod =  ':t'

" Prevent cursor from jumping left when leaving insert mode
"inoremap <silent> <Esc> <C-O>:stopinsert<CR>

" Remove trailing whitespaces
autocmd BufWritePre * %s/\s\+$//e

":set noeol
":set nofixeol

"set tabstop=4
"set softtabstop=4
"set shiftwidth=2

" Disable jedi docstring popup
"autocmd FileType python setlocal completeopt-=preview

" Allow switching to other buffer if current buffer has unsaved changes
set hidden

function! InsertEnterHook()
    ":set norelativenumber
    hi BufTabLineActive ctermbg=161 ctermfg=255 cterm=bold
    hi BufTabLineCurrent ctermbg=161 ctermfg=255 cterm=bold
    ":hi LineNr ctermfg=161
    ":hi LineNr ctermbg=52
    ":hi CursorColumn ctermbg=52
    ":hi CursorLine ctermbg=52
    ":hi CursorColumn ctermbg=52
endfunction

function! InsertLeaveHook()
    ":set relativenumber
    hi BufTabLineActive ctermbg=118 ctermfg=0 cterm=bold
    hi BufTabLineCurrent ctermbg=118 ctermfg=0 cterm=bold
    ":hi LineNr ctermfg=250
    ":hi LineNr ctermbg=236
    ":hi CursorColumn ctermbg=235
    ":hi CursorLine ctermbg=235
    ":hi CursorColumn ctermbg=235
endfunction

autocmd InsertEnter * call InsertEnterHook()
autocmd InsertLeave * call InsertLeaveHook()

"let &t_EI .= "\<Esc>[2 q\<Esc>]12;green\x7"
"let &t_SI .= "\<Esc>[2 q\<Esc>]12;red\x7"
"let &t_EI .= "\<Esc>[6 q"
"let &t_SI .= "\<Esc>[2 q"

let CursorColumnI = 0 "the cursor column position in INSERT
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

autocmd VimLeave * silent !echo -ne "\033]112\007"

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

au VimEnter * call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
au VimEnter * call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
au VimEnter * call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
au VimEnter * call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
au VimEnter * call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
au VimEnter * call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
au VimEnter * call NERDTreeHighlightFile('rb', 'Red', 'none', '#ffa500', '#151515')
au VimEnter * call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

" piecrumbs

let g:piecrumbs_glue = '  '

" Tagbar

"nnoremap <F8> :TagbarToggle<CR>
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

" YouCompleteMe

let g:ycm_auto_trigger = 0
let g:ycm_key_invoke_completion = '<C-p>'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_key_list_stop_completion = ['<CR>']

" BufTabLine

let g:buftabline_indicators = 1
let g:buftabline_seperators = 1
hi BufTabLineFill ctermbg=233
hi BufTabLineCurrent ctermbg=118 ctermfg=0 cterm=bold
hi BufTabLineActive ctermbg=118 ctermfg=0 cterm=bold
hi BufTabLineHidden ctermbg=238

" Custom status

hi User1 ctermfg=245
hi User2 ctermfg=161
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

function SetStatusLineColor()
    let m = mode()
    "echo m
    if (m ==# 'i')
        "echo 'INSERT'
        exe 'hi! StatusLine ctermfg=161'
    elseif (m ==# 'v' || mode() ==# 'V')
        "echo 'VISUAL'
        exe 'hi! StatusLine ctermfg=81'
    else
        "echo 'OTHER'
        exe 'hi! StatusLine ctermfg=118'
    endif
    return ''
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

hi StatusLine cterm=None cterm=None gui=None ctermbg=233

" !!!
set lazyredraw

set laststatus=2
set statusline=
set statusline +=%{SetStatusLineColor()}
set statusline +=\ %{mode_map[mode()]}\ %*
set statusline +=\ %<%F%*
set statusline +=%=
set statusline +=%1*:%l.%c/%L\ %*
set statusline +=%1*\ %{CharSegment()}\ %*
set statusline +=%2*%{LinterStatus()}%*
"set statusline +=%=a
"set statusline +=%{SetStatusLineColor()}

" ALE
let g:ale_linters = {
            \'javascript': ['eslint'],
            \'python': ['flake8']
            \}

nnoremap <silent> <F5> :w<CR>:SyntasticCheck<CR>
inoremap <silent> <F5> <C-o>:w<CR><C-o>:SyntasticCheck<CR>

nnoremap <silent> ; :ALEPrevious<CR>
nnoremap <silent> ' :ALENext<CR>

hi Error ctermfg=235 ctermbg=161

