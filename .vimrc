""""""""""""""""""""""""""""""""

" Vundle
""""""""""""""""""""""""""""""""

set nocompatible
filetype off

set nowrap

set rtp+=/home/anderson/.vim/bundle/Vundle.vim
call vundle#begin()


Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree' 	    	" Project and file navigation
" Plugin 'majutsushi/tagbar'          	" Class/module browser
Plugin 'scrooloose/nerdcommenter'

" Plugin 'mitsuhiko/vim-python-combined'  " Combined Python 2/3 for Vim
" Plugin 'davidhalter/jedi-vim'
Plugin 'tpope/vim-fugitive'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'wincent/command-t'
Plugin 'ryanoasis/vim-devicons'
Plugin 'ctrlpvim/ctrlp.vim'

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
":set relativenumber

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
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'
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
" inoremap <silent> <ESC>[5;2~ <ESC>:bp<CR>i
" inoremap <silent> <ESC>[6;2~ <ESC>:bn<CR>i
inoremap <silent> <ESC>[5;2~ <ESC>:bp<CR>
inoremap <silent> <ESC>[6;2~ <ESC>:bn<CR>

" nnoremap <silent> <C-n>      :tabnew<CR>
" nnoremap <silent> <C-o>      :CtrlPMixed<CR>
nnoremap <silent> <C-p>      :CtrlPMixed<CR>
nnoremap <silent> <C-x>      :bd<CR>
nnoremap b  :buffers<CR>:b

nnoremap <silent> <C-_> :call NERDComment(0, "toggle")<CR><CR>
vnoremap <silent> <C-_> :call NERDComment(0, "toggle")<CR><CR>
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

let g:airline_powerline_fonts = 1

let g:airline_theme='kalisi'
" let g:airline_theme='term'
" let g:airline_theme='molokai'
" let g:airline_solarized_bg='dark'

let g:airline_enable_branch=1
"let g:airline_mode_map = {
"    \ '__': '-',
"    \ 'n': 'N',
"    \ 'i': 'I',
"    \ 'R': 'R',
"    \ 'c': 'C',
"    \ 'v': 'V',
"    \ 'V': 'V',
"    \ '^V': 'V',
"    \ 's': 'S',
"    \ 'S': 'S',
"    \ '^S': 'S',
"    \ }

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#buffer_min_count = 1
let g:airline#extensions#tabline#combined = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline_skip_empty_sections = 1

":AirlineTheme badwolf
":AirlineTheme dark
":AirlineTheme deus

"set laststatus=0

set timeoutlen=1000 ttimeoutlen=0

"let g:jedi#completions_command = "<C-Space>"
let g:jedi#completions_command = "<Tab>"
let g:jedi#popup_on_dot = 0
"let g:jedi#auto_initialization = 0
let g:jedi#use_tabs_not_buffers = 1

"set wildmode=longest,list,full
set wildmode=longest,list
set wildmenu

" Smart home
noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
imap <silent> <Home> <C-O><Home>
"imap <silent> <Home> <Esc><Home>i

:set cursorline
:set cursorcolumn

:set fillchars+=vert:│

" CommandT
:let g:CommandTFileScanner = 'git'

" CtrlP
let g:webdevicons_enable_ctrlp = 1
" let g:ctrlp_max_height = 20
let g:ctrlp_match_window = 'bottom,order:ttb,min:16,max:16,results:16'
let g:ctrlp_match_window_reversed = 0

"let g:ctrlp_prompt_mappings = {
"    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
"    \ 'AcceptSelection("t")': ['<cr>'],
"    \ }

" adding to vim-airline's tabline
let g:webdevicons_enable_airline_tabline = 1
" adding to vim-airline's statusline 
let g:webdevicons_enable_airline_statusline = 1

" Cursor

:hi CursorLine ctermbg=235
:hi CursorColumn ctermbg=235

" Molokai theme patches

hi Normal guibg=NONE ctermbg=NONE

filetype plugin on

