" vim:foldmethod=marker
" Preconfiguration {{{
scriptencoding utf-8

set t_Co=256

" set nocompatible

let g:python_highlight_all = 1
let python_highlight_all = 1
let g:python_highlight_indent_errors = 1
let g:python_space_error_highlight = 1

let g:python_self_cls_highlight = 1
let g:pymode_python = 'python3'

" Theme config
let g:molokai_original = 1
let g:rehash256 = 1

let g:sublimemonokai_term_italic = 1

filetype on
filetype plugin on
filetype plugin indent on
syntax enable

"let g:python_host_prog='/usr/bin/python'
" }}}

" Third-party plugins {{{

call plug#begin('~/.vim/plugged')
    " General
    " Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }
    " Plug 'tanvirtin/monokai.nvim'
    Plug 'tomasr/molokai'
    " Plug 'tamelion/neovim-molokai'
    " Plug 'scrooloose/nerdcommenter'

    " LSP
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/lsp-status.nvim'
    Plug 'JoosepAlviste/nvim-ts-context-commentstring'
    Plug 'tpope/vim-commentary'
    Plug 'jose-elias-alvarez/null-ls.nvim'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
    Plug 'nvim-treesitter/playground'

    " Indentation
    " Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'lua'}
    Plug 'Yggdroot/indentLine'

    " Code quality
    " Plug 'w0rp/ale'

    " Slow returns
    Plug 'Vimjas/vim-python-pep8-indent'
    Plug 'airblade/vim-gitgutter'
    " Plug 'tpope/vim-fugitive'
    Plug 'ervandew/supertab'

    "Plugin 'ap/vim-css-color'
    " Plug 'chrisbra/Colorizer'
    Plug 'osyo-manga/vim-over'

    " Telescope
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    " Startup
    Plug 'mhinz/vim-startify'

    " Tagbar
    Plug 'majutsushi/tagbar'

    " Syntax files
    " let g:polyglot_disabled = ['csv', 'go', 'html', 'python']
    " Plug 'sheerun/vim-polyglot'
    " Plug 'tmux-plugins/vim-tmux'
    " Plug 'pangloss/vim-javascript'
    " Plug 'mxw/vim-jsx'
    " Plug 'chemzqm/vim-jsx-improve'
    " Plug 'chr4/nginx.vim'
    " Plug 'martinda/Jenkinsfile-vim-syntax'
    " Plug 'calviken/vim-gdscript3'
    " Plug 'leafgarland/typescript-vim'
    " Plug 'cespare/vim-toml'
    Plug 'hashivim/vim-terraform'
    " Plug 'tikhomirov/vim-glsl'
    " Faster YAML syntax
    Plug 'stephpy/vim-yaml'
    Plug 'othree/html5.vim'

    " Hex mode
    Plug 'fidian/hexmode'

    " Local vim settings
    Plug 'embear/vim-localvimrc'

    " Status line
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'wfxr/minimap.vim'

    " Buffer tabline
    Plug 'ap/vim-buftabline'
    " Plug 'akinsho/bufferline.nvim'
    " Plug 'kdheepak/tabline.nvim'

    " Pretty stuff
    Plug 'luochen1990/rainbow'
    Plug 'mechatroner/rainbow_csv'

    " PlatformIO stuff
    " https://gist.github.com/neta540/9e65261be52d6cd4d6c17399b78d34bb
    " Plug 'neomake/neomake'

    " SQL completion
    Plug 'vim-scripts/dbext.vim'

    " Editorconfig
    Plug 'editorconfig/editorconfig-vim'

" }}}
" Local plugins {{{
    " Plug '~/.vim/plugins/prettyconceal'
    Plug '~/.vim/plugins/icons'
    " Plug '~/.vim/plugins/autocursor'
    Plug '~/.vim/plugins/hi_yaml'
    Plug '~/.vim/plugins/icons'
    Plug '~/.vim/plugins/signs'
    " Plug '~/.vim/plugins/statusline'
    " Plug '~/.vim/plugins/tabline'
    Plug '~/.vim/plugins/pds'
    Plug '~/.vim/plugins/hi_godot'
    Plug '~/.vim/plugins/zipe'
call plug#end()
" }}}

" Debug
set redrawtime=1000

" Internals (hotkeys, highlights, vim configs) {{{

" colorscheme spaceduck
" hi EndOfBuffer ctermbg=none
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

colorscheme molokai

set nowrap

set tabstop=4 softtabstop=4 expandtab shiftwidth=4 smarttab

" Let's try this.
noremap - :

" Gui
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

set guifont=DejaVu\ Sans\ Mono\ 9

" Italics
"let &t_ZH="^[[3m"
"let &t_ZR="^[[23m"
set t_ZH=[3m
set t_ZR=[23m

" One extra char at the end of the line
"set virtualedit=onemore

set splitbelow
set splitright

nnoremap <End> g$

" Move to next/prev non-whitespace line
nnoremap } /^\S<cr>:nohlsearch<cr>
nnoremap { ?^\S<cr>:nohlsearch<cr>

set number
"set relativenumber

set whichwrap+=<,>,h,l,[,]

" Timeouts
"set timeoutlen=0 ttimeoutlen=10
set timeoutlen=300 ttimeoutlen=10

" Switch buffers
"nnoremap <silent> <ESC>[5;2~ :bp<CR>
"nnoremap <silent> <ESC>[6;2~ :bn<CR>
"inoremap <silent> <ESC>[5;2~ <ESC>:bp<CR>
"inoremap <silent> <ESC>[6;2~ <ESC>:bn<CR>

" Switch buffers (NeoVIM)
nnoremap <silent> <S-PageUp> :bp<CR>
nnoremap <silent> <S-PageDown> :bn<CR>
inoremap <silent> <S-PageUp> <ESC>:bp<CR>
inoremap <silent> <S-PageDown> <ESC>:bn<CR>

" Jump words
"nnoremap <silent> <ESC>[1;5D b
"nnoremap <silent> <ESC>[1;5C w
"inoremap <silent> <ESC>[1;5D <C-o>b
"inoremap <silent> <ESC>[1;5C <C-o>w

" Move lines
nnoremap <silent> <C-Up> :call feedkeys(line('.') == 1 ? '' : '"mddk"mP')<CR>
nnoremap <silent> <C-Down> ddp
inoremap <C-Up> <C-o>:call feedkeys(line('.') == 1 ? '' : '<C-o>"mdd<C-o>k<C-o>"mP')<CR>
inoremap <C-Down> <C-o>:execute "normal! \"mdd\"mp"<CR>

" Save with C-s
nnoremap <C-s> :w<CR>
inoremap <C-s> <C-o>:w<CR>
nnoremap <M-s> :w<CR>
inoremap <M-s> <C-o>:w<CR>

" Unmap "s" anc "c"
"map s <Nop>
"map c <Nop>

" Delete buffer
" nnoremap <silent> <M-x>      :bd<CR>
" nnoremap <silent> <M-x>      :Bdelete<CR>
nnoremap <silent> <M-x>      :bdelete<CR>
"nnoremap b  :buffers<CR>:b

" Close window
nnoremap <silent> <M-q> <C-w>q

" Redo with Alt
nnoremap <silent> <M-r> <C-r>
nnoremap <silent> r <C-r>

" Quick open .vimrc
" nnoremap <silent> <M-c> :e ~/.vimrc<CR>
nnoremap <silent> <M-c> :nohlsearch<CR>
nnoremap <esc> :nohlsearch<CR><esc>

" Smart home
noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
imap <silent> <Home> <C-O><Home>
"nmap <silent> <Esc>OH <Home>
"nmap <silent> <Esc>OF <End>
"imap <silent> <Esc>OH <C-o><Home>
"imap <silent> <Esc>OF <C-o><End>

" Delete words
inoremap <C-h> <C-W>
inoremap <M-BS> <C-W>

" Unindent
"nnoremap <S-Tab> <<
"inoremap <S-Tab> <C-d>

" Switch between windows using Tab
nnoremap <Tab> <C-W>w

" Word jumps in normal mode
nnoremap <C-Left> b
nnoremap <C-Right> e

" Page scrolling
map <PageUp> <C-u>
map <PageDown> <C-d>


" Show cursor line, hide cursor column
set cursorline
set nocursorcolumn

" Fill chars
"set fillchars+=vert:\ ,stl:\ ,stlnc:\ ,fold:\ ,eob:\ "
set fillchars+=stl:\ ,stlnc:\ ,fold:\-,msgsep:+,eob:\ "
" Chars
set list listchars=tab:▏ ,trail:·,extends:»,precedes:«,nbsp:×
hi Whitespace ctermfg=236
" ,space:·
" 

" Clipboard fix
" set clipboard^=unnamed,unnamedplus
set clipboard=unnamedplus

" Sudo write
let $SUDO_ASKPASS=$HOME . '/.scripts/rofi-askpass.sh'
"command SudoW w !sudo -A tee %
"cmap w!! :SudoW<CR>
"
" Cursor blinking & look
set guicursor=n-v-c-sm:block-blinkwait100-blinkon100-blinkoff100,i-ci-ve:ver25-blinkwait100-blinkon100-blinkoff100,r-cr-o:hor20-blinkwait100-blinkon100-blinkoff100

" Detect hi groups
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Force python path
let g:python_host_prog='/usr/bin/python'

" Scrolling
"au BufRead * set scroll=20
set scrolloff=5

" Window size
aug EqualWindows
    au VimResized * :wincmd =
aug END

" Limit syntax highlight
set synmaxcol=200

" Text display tweaks
set display=lastline,msgsep,uhex
set numberwidth=5

" History length
set history=1000

" Disable netRW
let loaded_netrwPlugin = 1

" Shada config
set shada=!,'100,<50,s10,h,:500,@500,/500

" Color column
"set colorcolumn=80,100,120
set colorcolumn=120

" Command line horizontal completion instead of vertical
set nowildmenu
set wildoptions-=pum
set wildoptions-=tagfile
" No fancy list
set wildmode=list:longest

" Disable preview for completions
set completeopt-=preview
" set completeopt+=noinsert

" Blink yanked text
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=100, on_visual=true}

" Word jump config
"set iskeyword=@,48-57

" }}}

" Colors {{{
" Cursor

hi CursorLine ctermbg=234 " cterm=underline
" hi CursorColumn ctermbg=234
" hi CursorColumn ctermbg=94 ctermfg=255 " Used by Coc
"hi StatusLine ctermfg=233
"hi StatusLineNC ctermbg=None ctermfg=240 cterm=None

"hi MatchParen ctermfg=magenta ctermbg=none

"hi CursorLineNr ctermfg=119 ctermbg=235 cterm=bold
hi CursorLineNr ctermfg=81 ctermbg=234 cterm=bold
hi LineNr ctermbg=233 ctermfg=242
hi SignColumn ctermbg=233
"hi LineNr ctermbg=none ctermfg=239

" Molokai theme patches
hi Normal guibg=NONE ctermbg=NONE ctermfg=NONE
hi NonText ctermbg=NONE

hi Error ctermbg=197 ctermfg=255 cterm=bold,underline

"hi Repeat cterm=underline
"hi Function cterm=underline
hi Include cterm=bold ctermfg=154
"hi MatchParen ctermfg=197 ctermbg=NONE cterm=inverse,bold,underline
" hi MatchParen ctermfg=197 ctermbg=none cterm=bold,underline
hi MatchParen ctermfg=none ctermbg=240 cterm=none

hi Special cterm=italic

hi ColorColumn ctermbg=233

hi Conceal ctermfg=240 ctermbg=none

" Highlight selected word
"hi Selected ctermbg=94 ctermfg=none
"":autocmd CursorMoved * exe printf('match Selected /\V\<%s\>/', escape(expand('<cword>'), '/\'))
"" Better version: https://stackoverflow.com/a/36554391/3455614
"let g:no_highlight_group_for_current_word=["Statement", "Comment", "Type", "PreProc", "Include", "Conditional"]
"function s:HighlightWordUnderCursor()
"    let l:syntaxgroup = synIDattr(synIDtrans(synID(line("."), stridx(getline("."), expand('<cword>')) + 1, 1)), "name")

"    if (index(g:no_highlight_group_for_current_word, l:syntaxgroup) == -1)
"        exe printf('match Selected /\V\<%s\>/', escape(expand('<cword>'), '/\'))
"    else
"        exe 'match Selected /\V\<\>/'
"    endif
"endfunction
"autocmd CursorMoved * call s:HighlightWordUnderCursor()

" Split
"hi VertSplit ctermbg=none
" hi VertSplit ctermbg=233 ctermfg=242
hi VertSplit ctermbg=none ctermfg=242
" }}}

" Commentary {{{
"let g:NERDSpaceDelims = 1
"let g:NERDCompactSexyComs = 1
"let g:NERDDefaultAlign = 'left'
"let g:NERDCustomDelimiters = {'python': {'leftAlt': '"""', 'rightAlt': '"""', 'left': '#'}}
""let g:NERDCustomDelimiters = { 'c': { 'left': '//','right': '' } }
"let g:NERDAltDelims_c = 1
"let g:NERDAltDelims_cpp = 0
"let g:NERDTrimTrailingWhitespace = 1

"" nnoremap <silent> <M-/> :call NERDComment(0, "toggle")<CR><CR>
"""vnoremap <silent> <C-_> :call NERDComment(0, "alignleft")<CR><CR>
"""vnoremap <silent> <C-_> :call ToggleOrSexy()<CR>
"" vnoremap <silent> <M-/> :call NERDComment(0, "toggle")<CR><CR>
"" inoremap <silent> <M-/> <C-o>:call NERDComment(0, "toggle")<CR><C-o><CR>

"map <PageUp> <C-u>
"map <PageDown> <C-d>
""map <PageUp> 10<Up>
""map <PageDown> 10<Down>

"map <S-Up> <C-y>
"map <S-Down> <C-e>
""map <S-Up> {
""map <S-Down> }

nnoremap <silent> <M-/> :Commentary<CR>
vnoremap <silent> <M-/> :Commentary<CR>
inoremap <silent> <M-/> <C-o>:Commentary<CR><C-o><CR>

" }}}
" intentLine {{{
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1

let g:indentLine_char = '▏'
" let g:indentLine_char = ''
let g:indentLine_first_char = '▏'
"let g:indentLine_first_char = '>'
" let g:indentLine_first_char = 'x'
" let g:indentLine_char = 'x'
" let g:indentLine_leadingSpaceChar = '·'
" let g:indentLine_leadingSpaceEnabled = 1
" let g:indentLine_setColors = 0
let g:indentLine_concealcursor = 0
let g:indentLine_conceallevel = 1
" let g:indentLine_setConceal = 0
let g:indentLine_color_term = 236
" let g:indentLine_bgcolor_term = 202
let g:indentLine_showFirstIndentLevel = 0
let g:indentLine_fileTypeExclude = ['text', 'help', 'startify']
let g:indentLine_faster = 1 " TODO: Experimental
" }}}
" Conceal {{{

"syn keyword Operator lambda conceal cchar=λ

" }}}
" Backups {{{

" set backupdir=/tmp
" set directory=/tmp
set noswapfile
set nobackup

" }}}
" Edit/save hooks {{{

" Remove trailing whitespaces
fu CleanUp()
    exe '%s/\s\+$//e'
    " |norm!``
endf
aug CleanUp
    au BufWritePre * if !&bin | call CleanUp() | endi
aug END
":set noeol
":set nofixeol

" Allow switching to other buffer if current buffer has unsaved changes
set hidden

"let g:CursorColumnI = 0 "the cursor column position in INSERT

fu! InsertEnterHook()
    ":set norelativenumber
    "hi BufTabLineActive ctermbg=161 ctermfg=255 cterm=bold
    "hi BufTabLineCurrent ctermbg=161 ctermfg=255 cterm=bold
    hi CursorLineNr ctermfg=161
    "hi CursorLine ctermbg=238
    "let g:CursorColumnI = col('.')
endf

fu! InsertLeaveHook()
    ":set relativenumber
    "hi BufTabLineActive ctermbg=118 ctermfg=0 cterm=bold
    "hi BufTabLineCurrent ctermbg=118 ctermfg=0 cterm=bold
    "hi CursorLineNr ctermfg=118
    hi CursorLineNr ctermfg=81
    "hi CursorLine ctermbg=234
    " Back to true mode.
    "if col('.') != g:CursorColumnI | call cursor(0, col('.')+1) | endif
endf

aug CursorColor
    au InsertEnter * call InsertEnterHook()
    au InsertLeave * call InsertLeaveHook()
aug END
"au CursorMovedI * let CursorColumnI = col('.')

" }}}
" GitGutter {{{
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 0
let g:gitgutter_max_signs=1000
set signcolumn=yes
aug GitGutter
    au BufWritePost,InsertLeave,TextChanged * :GitGutter
    au BufReadPre * if &bin | :GitGutterDisable
aug END
"let g:gitgutter_sign_column_always = 1
" Disable for binary mode

" }}}
" Sexy replace {{{
:map <C-f> :OverCommandLine<CR>:
" }}}
" Folding {{{
" Disable folding
"set nofoldenable
"set foldlevelstart=99
" Nope, let's use it!
nnoremap <space> za
"vnoremap <space> zf
"nnoremap <M-space> zA
"set foldmethod=indent
set foldmethod=manual
set foldnestmax=2

fu! FoldText()
    "let l:indent = match(getline(v:foldstart), '\S')
    "let l:indent_str = repeat(' ', l:indent)
    "return l:indent_str . getline(v:foldstart)
    "return getline(v:foldstart) . '    (' . string(v:foldend - v:foldstart - 1) . ' more lines)'
    "let width = GetWindowWidth()
    let width = winwidth('%') - &numberwidth

    "let str = getline(v:foldstart) . '    ' . repeat('+', v:foldend - v:foldstart) . ' '
    ""let str = str . repeat('·', float2nr(ceil((width - len(str)) / 1.0)))
    "return str

    let code = getline(v:foldstart)
    let matches = matchlist(code, '^\("\|--\|#\) \(.*\) {' . '{{$')
    if len(matches)
        let code = matches[2]
        "let code = code[2:-5]
    endi
    "
    "let matches = matchlist(code, '{\(\S\+\)}')
    "if len(matches)
    "    let code = matches[1]
    "endi
    let lines = printf('%7d lines', v:foldend - v:foldstart)
    let pluses = repeat('+', min([v:foldend - v:foldstart, 32]))

    return printf('%-' . (width - len(lines) - 3 - len(pluses) - 1) . 's %s %s', code, pluses, lines)

    "return printf('%-'.(width - len(amount) - 3).'s%'.len(amount).'s', str, lines)
    "let amount = repeat('+', v:foldend - v:foldstart)
    "return printf('%-'.(width - len(amount) - 3).'s%'.len(amount).'s', str, amount)

    "let width = GetWindowWidth()
    "let line = getline(v:foldstart)
    "if len(line) > width - 16
    "    let line = strpart(line, 0, width - 16) . '~'
    "endif
    "return printf('%-' . (width - 15) . 's%15s', line, '+' . (v:foldend - v:foldstart) . ' ')
endf

set foldtext=FoldText()
hi FoldColumn ctermfg=245 ctermbg=233
"set foldcolumn=2
"hi Folded ctermfg=241 ctermbg=16
"hi Folded ctermfg=67 ctermbg=16
hi Folded ctermfg=67 ctermbg=none cterm=italic

aug CustomFolds
    "au FileType javascript setlocal foldmethod=marker foldmarker={,}
    "au FileType tmux setlocal foldmethod=marker
aug END

function! GoToOpenFold(direction)
  let start = line('.')
  if (a:direction ==? 'next')
    while (foldclosed(start) != -1)
      let start = start + 1
    endwhile
  else
    while (foldclosed(start) != -1)
      let start = start - 1
    endwhile
  endif
  call cursor(start, 0)
endfunction
nmap ]z :cal GoToOpenFold("next")
nmap [z :cal GoToOpenFold("prev")

" }}}
" NERDTree {{{
"au FileType nerdtree mapc <buffer>
aug NerdTreeCustom
    au FileType nerdtree map <buffer> <S-PageUp> <nop>
    au FileType nerdtree map <buffer> <S-PageDown> <nop>
    au FileType nerdtree map <buffer> <M-x> <nop>
    au BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
aug END
"au FileType nerdtree cnoreabbrev <buffer> bd <nop>
"au FileType nerdtree cnoreabbrev <buffer> bn <nop>
"au FileType nerdtree cnoreabbrev <buffer> bp <nop>
"au VimEnter *  NERDTree
"au VimEnter * wincmd p
" }}}
" Slime {{{
let g:slime_target = 'tmux'
" }}}
" Terminal tweaks {{{
"tnoremap <Esc> <C-\><C-n>
"nnoremap <M-d> :q!<CR>
" }}}
" Tagbar {{{
let g:tagbar_sort = 0
let g:tagbar_indent = 4
let g:tagbar_compact = 1
let g:tagbar_show_visibility = 1
"let g:tagbar_show_linenumbers = 0
let g:tagbar_silent = 1
let g:tagbar_show_linenumbers = 0
let g:tagbar_left = 1
let g:tagbar_autoshowtag = 1
"let g:tagbar_iconchars = ['-', '|']
"let g:tagbar_autopreview = 1
fu! TagbarStatusFn(current, sort, fname, flags, ...) abort
    let highlight_colour = a:current ? '%#StatusBarNormalInv#' : '%#StatusBarText#'
    let text_colour = a:current ? '%#StatusBarNormal#' : '%#StatusBarText#'
    let flagstr = join(a:flags, '')
    if flagstr !=# ''
        let flagstr = '[' . flagstr . '] '
    endif
    "echo a:current . '/' . colour
    return highlight_colour . ' ' . g:ic.code . ' ' . text_colour . ' Tag list'
    return highlight_colour . '[' . a:sort . '] ' . flagstr . a:fname
endfunction
"fu! Nope(...)
"    return ''
"endf
let g:tagbar_status_func = 'TagbarStatusFn'
"let g:tagbar_status_func = 'Nope'
"au VimEnter * nested :TagbarOpen
nnoremap <silent> <F2> :TagbarToggle<CR>
inoremap <silent> <F2> <C-o>:TagbarToggle<CR>
set updatetime=250

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }
" }}}
" JSX {{{
" let g:jsx_ext_required = 0
" aug JavascriptReactAuto
"     au BufNewFile,BufRead *.js set filetype=javascriptreact
" aug END
"
" }}}
" Virtualenv {{{
"python with virtualenv support
"py3 << EOF
"import os
"import sys
"if 'VIRTUAL_ENV' in os.environ:
"    project_base_dir = os.environ['VIRTUAL_ENV']
"    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"    exec(open(activate_this).read(), dict(__file__=activate_this))
"EOF
" }}}
" GraphViz {{{
aug GraphVizCustom
    au BufNewFile,BufRead *.gv set filetype=dot
aug END
" }}}
" Muttrc {{{
aug MuttRcCustom
    au BufNewFile,BufRead *.muttrc set filetype=muttrc
aug END
" }}}
" Jenkinsfile indentation {{{
aug JenkinsfileCustom
    au FileType Jenkinsfile setlocal ts=2 sts=2 sw=2 expandtab
aug END
" }}}
" Rainbow parentheses {{{
"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

let g:rbpt_colorpairs = reverse([
    \ ['red',         'firebrick3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['blue',        'SeaGreen3'],
    \ ['brown',       'RoyalBlue3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ])
" }}}
" Rainbow {{{
let g:rainbow_active = 1
let g:rainbow_conf = {
            \ 'ctermfgs': ['darkcyan', 'red', 'green', 'blue'],
            \ }
" }}}
" Colorizer {{{
" let g:colorizer_auto_filetype='css,html,lua'
" }}}
" Hex mode {{{
let g:hexmode_xxd_options = '-g 1'
" }}}
" Supertab {{{

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&contextfunc']

" }}}
" Go {{{
" aug GolangGoto
"     au FileType go nmap <silent> <C-g> :GoDef<CR>
" aug end
let g:go_fmt_fail_silently = 1  " Do not open loclist
let g:go_lint_fail_silently = 1  " Do not open loclist
let g:go_list_height = 0
let g:go_list_autoclose = 1
"let g:go_metalinter_autosave = 0
"au CursorMoved *.go :GoInfo
"au BufRead,BufWrite *.go :GoLint
" aug GolangInfo
"     au FileType go nnoremap <silent> w :GoInfo<CR>
" aug end
" }}}
" Startify {{{
let g:startify_files_number = 10
let g:startify_bookmarks = [{'c': '~/.vimrc'}]
let g:startify_padding_left = 4
let g:startify_fortune_use_unicode = 1
let g:startify_session_remove_lines = ['setlocal', 'winheight']
let g:startify_custom_indices =
            \ map(range(0, g:startify_files_number - 1), 'string(v:val)') +
            \ map(range(90, 99), 'string(v:val)')
let g:startify_change_to_dir = 0

let g:startify_lists = [
            \ { 'header': ['  MRU'], 'type': 'files' },
            \ { 'header': ['  Bookmarks'], 'type': 'bookmarks' },
            \ { 'header': ['  Sessions'], 'type': 'sessions' },
            \ ]
"            \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
"            \ { 'header': ['   Sessions'],       'type': 'sessions' },
"            \ { 'header': ['   Commits'],        'type': function('s:list_commits') },

" }}}
" Easy motion {{{
"nmap s <Plug>(easymotion-bd-w)
"nmap S <Plug>(easymotion-bd-jk)
"nmap c <Plug>(easymotion-s2)
nmap c <Plug>(easymotion-bd-w)

"nmap w <Plug>(easymotion-overwin-f)
"nmap w <Plug>(easymotion-overwin-f2)
"nmap w <Plug>(easymotion-overwin-line)
"nmap w <Plug>(easymotion-overwin-w)
nmap <Leader><Leader> <Plug>(easymotion-prefix)

hi EasyMotionTarget ctermfg=196 cterm=bold
hi EasyMotionTarget2First ctermfg=196 cterm=bold
hi EasyMotionTarget2FirstDefault ctermfg=green cterm=bold
hi EasyMotionTarget2Second ctermfg=11 cterm=bold
hi EasyMotionTarget2SecondDefault ctermfg=11 cterm=bold

"let g:EasyMotion_keys = 'bceimnopqrtuvwxyz0123456789lkjhgfdsa;'
let g:EasyMotion_keys = 'asdfghjkl;bceimnopqrtuvwxyz'
let g:EasyMotion_keys = 'ahsjdkflgbceimnopqrtuvwxyz'
let g:EasyMotion_keys = 'aishdpqnemw'
" '0123456789'
let g:EasyMotion_do_shade = 1
let g:EasyMotion_grouping = 2
let g:EasyMotion_use_upper = 1
"let g:EasyMotion_prompt = '{n}>>> '
let g:EasyMotion_prompt = '{n}> '
"let g:EasyMotion_add_search_history = 0
let g:EasyMotion_verbose = 0

" }}}
" Pydocstring {{{
let g:pydocstring_enable_mapping = 0
let g:pydocstring_templates_dir = $HOME . '/.vim/templates/pydocstring/'
" }}}
" PDS {{{
nnoremap <silent> <M-d> :call PDS()<CR>
" }}}
" Local VimRC {{{
"let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 1
" }}}
" Java {{{
aug JavaCustom
    au BufNewFile,BufRead *.jad set filetype=java
aug END
" }}}
" Templates {{{
fu! FormatTemplate()
    let l:user = getenv('USER')
    exe '%s/%USER%/' . $USER . '/eg'
    echo $USER
    let l:here = search('%HERE%')
    exe ':' . l:here
    if l:here != 0
        :d
    endi
endf
" aug PythonSkeleton
"     au BufNewFile *.py 0r ~/.vim/skeletons/skeleton.py | call FormatTemplate()
" aug end
" }}}
" Systemd {{{
aug SystemdAuto
    au BufNewFile,BufRead *.service set filetype=systemd
aug END
" }}}
" Terraform {{{
let g:terraform_fold_sections=0
" }}}
" Template files {{{
aug SystemdAuto
    au BufNewFile,BufRead *.tpl set filetype=bash
aug END
" }}}
" vim.zip {{{
let g:zip_nomax = 1
" let g:loaded_zipPlugin= 1
" let g:loaded_zip      = 1
" }}}
" OS X stuff {{{
au BufNewFile,BufRead *.plist set filetype=xml
" }}}
" LSP {{{
hi LspDiagnosticsDefaultError ctermfg=9 ctermbg=235
hi LspDiagnosticsDefaultWarning ctermfg=130 ctermbg=235
hi LspDiagnosticsDefaultInformation ctermfg=38 ctermbg=235
hi LspDiagnosticsDefaultHint ctermfg=156 ctermbg=235
" hi CocInfoSign ctermfg=11 ctermbg=235
" hi CocHintSign ctermfg=12 ctermbg=235

lua << EOF
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-g>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<M-Enter>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';', '<cmd>lua vim.lsp.diagnostic.goto_prev{float=false}<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '\'', '<cmd>lua vim.lsp.diagnostic.goto_next{float=false}<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<M-r>', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  -- autocmd CursorHold * :lua vim.lsp.buf.signature_help()
  vim.api.nvim_command("autocmd CursorMoved * :lua require('ts_context_commentstring.internal').update_commentstring()")
  -- vim.api.nvim_command("autocmd CursorHoldI * :lua vim.lsp.buf.signature_help()")
end
-- require'lspconfig'.pyright.setup{
--     on_attach=on_attach
-- }
kind_icons = {
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Enum = "了 ",
  EnumMember = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = " ",
  Interface = "ﰮ ",
  Keyword = " ",
  Method = "ƒ ",
  Module = " ",
  Property = " ",
  Snippet = "﬌ ",
  Struct = " ",
  Text = " ",
  Unit = " ",
  Value = " ",
  Variable = " ",
}

local kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(kinds) do
    if kind_icons[kind] then
        kinds[i] = kind_icons[kind] .. kind
    end
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = {
--         source = "always",    -- Or "if_many"
--     }
-- })

require'lspconfig'.pylsp.setup{
    on_attach=on_attach,
    settings = {
        pylsp = {
            plugins = {
                pylint = {
                    enabled = true,
                    args = {},
                    executable = 'pylint'
                    },
                flake8 = {
                    enabled = false
                    },
                pycodestyle = {
                    enabled = false
                    },
                pyflakes = {
                    enabled = false
                    },
                }
            }
        }
}
require'lspconfig'.ccls.setup{
    on_attach=on_attach
}
require'lspconfig'.gopls.setup{
    on_attach=on_attach
}
require'lspconfig'.vimls.setup{
    on_attach=on_attach
}
require'lspconfig'.cssls.setup{
    on_attach=on_attach
}
require'lspconfig'.eslint.setup{
    on_attach=on_attach
}
require'lspconfig'.html.setup{
    on_attach=on_attach
}
require'lspconfig'.jsonls.setup{
    on_attach=on_attach
}
require("null-ls").config({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.completion.spell,
    },
})
require('lspconfig')['null-ls'].setup{
    on_attach=on_attach
}
local lsp_status = require('lsp-status')
-- lsp_status.config({
--     indicator_errors = '✖',
--     indicator_warnings = '',
--     indicator_info = 'i',
--     indicator_hint = '',
--     indicator_ok = 'Ok',
-- })
lsp_status.register_progress()

--  lsp_status.config({
--    indicator_errors = 'E',
--    indicator_warnings = 'W',
--    indicator_info = 'i',
--    indicator_hint = '?',
--    indicator_ok = 'Ok',
--  })
EOF
" }}}
" TreeSitter {{{
lua << EOF
require'nvim-treesitter.configs'.setup {
  context_commentstring = {
    enable = true,
    enable_autocmd = true,
  },
  incremental_selection = {
    enable = false,
  },
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  ensure_installed = {'javascript', 'typescript'},
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
EOF
" }}}
" Status line {{{
lua << EOF
mode_map = {
    N= '',
    I= '',
    R= '',
    C= '',
    V= '',
    T= '',
    }

function lspStatus()
    -- stats = require("lsp-status/diagnostics")(0)
    stats = require("lsp-status").diagnostics()
    parts = {}
    if stats.errors > 0 then
        table.insert(parts, '✖ ' .. stats.errors)
    end
    if stats.warnings > 0 then
        table.insert(parts, ' ' .. stats.warnings)
    end
    return table.concat(parts, ' ')
end

require('lualine').setup{
options = {
    theme = 'onedark',
    section_separators = {
        left = '',
        right = ''
        },
    component_separators = {
        left = '|',
        right = '|'
        },
    },
sections = {
    lualine_a = {{'mode', fmt = function(str) return mode_map[str:sub(1, 1)] end}},
    lualine_c = {{'filename', fmt = function(str) cur = vim.api.nvim_win_get_cursor(0); return str .. ':' .. cur[1] .. ':' .. cur[2] end}},
    lualine_b={},
    lualine_x={'filetype', 'encoding', 'filetype'},
    lualine_y={'branch'},
    lualine_z={'lspStatus()'},
    }
}
EOF
" }}}
" Buffer line {{{
" lua << EOF
" require("tabline").setup{
" enable = true,
" options = {
"     }
" }
" EOF
" hi TabLine ctermbg=236 ctermfg=red
hi TabLineFill ctermfg=0
hi TabLine ctermbg=0 ctermfg=245 cterm=none
hi TabLineSel ctermbg=150 ctermfg=0 cterm=none
hi BufTabLineActive ctermbg=239 ctermfg=255
let g:buftabline_numbers = 2
let g:buftabline_indicators = 1
let g:buftabline_separators = 1
nmap <M-1> <Plug>BufTabLine.Go(1)
nmap <M-2> <Plug>BufTabLine.Go(2)
nmap <M-3> <Plug>BufTabLine.Go(3)
nmap <M-4> <Plug>BufTabLine.Go(4)
nmap <M-5> <Plug>BufTabLine.Go(5)

" }}}
" Telescope {{{
lua << EOF
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        -- ["<C-j>"]   = actions.move_selection_next,
        -- ["<C-k>"]   = actions.move_selection_previous,
        -- ["<C-q>"]   = actions.smart_send_to_qflist + actions.open_qflist,
        ["<ESC>"]   = actions.close,
      },
    },
  }
}
EOF
nnoremap <silent> <M-l> :Telescope live_grep<CR>
nnoremap <silent> <M-p> :Telescope find_files<CR>
" }}}
