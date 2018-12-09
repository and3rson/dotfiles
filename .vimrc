""""""""""""""""""""""""""""""""
" Vundle
""""""""""""""""""""""""""""""""
" ⍢⍩

set nocompatible
filetype off

set nowrap
syntax off

let g:python_highlight_all = 1
let python_highlight_all = 1
let g:python_highlight_indent_errors = 1
let g:python_space_error_highlight = 1

let g:python_self_cls_highlight = 1
let g:pymode_python = 'python3'

"let g:python_host_prog='/usr/bin/python'

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.vim/scripts
set rtp+=/usr/share/vim/vimfiles/plugin
set t_Co=256
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Yggdroot/indentLine'
"Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'w0rp/ale'

" Slow returns
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'ervandew/supertab'

"Plugin 'ap/vim-css-color'
Plugin 'chrisbra/Colorizer'
Plugin 'osyo-manga/vim-over'
"Plugin 'haya14busa/incsearch.vim'
"Plugin 'haya14busa/incsearch-fuzzy.vim'

Plugin 'tmux-plugins/vim-tmux'

Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

"Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

"Plugin 'joeytwiddle/sexy_scroller.vim'
Plugin 'mhinz/vim-startify'

"Plugin 'wkentaro/conque.vim'
"Plugin 'christoomey/vim-tmux-navigator'
"Plugin 'jpalardy/vim-slime'

Plugin 'majutsushi/tagbar'
"Plugin 'calebsmith/vim-lambdify'
"Plugin 'ehamberg/vim-cute-python'

" Syntax files
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'chr4/nginx.vim'
Plugin 'martinda/Jenkinsfile-vim-syntax'

" Faster YAML syntax
Plugin 'stephpy/vim-yaml'

"Plugin 'kien/rainbow_parentheses.vim'
Plugin 'luochen1990/rainbow'

" Godot GDScript
Plugin 'calviken/vim-gdscript3'

" Python better code folding
"Plugin 'tmhedberg/SimpylFold'

" TypeScript
Plugin 'leafgarland/typescript-vim'

" Hex mode
Plugin 'fidian/hexmode'
"Plugin 'mattn/vim-xxdcursor'

"Plugin 'chriskempson/base16-vim'

" Python
"Plugin 'python-mode/python-mode'
Plugin 'davidhalter/jedi-vim'
Plugin 'heavenshell/vim-pydocstring'

" Motion
Plugin 'easymotion/vim-easymotion'

call vundle#end()                    " required

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

nnoremap <End> $

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
nnoremap <silent> <M-x>      :bd<CR>
"nnoremap b  :buffers<CR>:b

" Close window
nnoremap <silent> <M-q> <C-w>q


" Redo with Alt
nnoremap <silent> <M-r> <C-r>
nnoremap <silent> r <C-r>

" Quick open .vimrc
nnoremap <silent> <M-c> :e ~/.vimrc<CR>
nnoremap <silent> <M-c> :nohlsearch<CR>


" Search symbols
"nnoremap <silent> <C-l> :CtrlPFunky<CR>
"inoremap <silent> <C-l> <ESC>:CtrlPFunky<CR>

" NERD Commenter
let g:NERDCompactSexyComs = 0
let g:NERDDefaultAlign = 'left'
"let g:NERDCustomDelimiters = {'python': {'leftAlt': '"""', 'rightAlt': '"""', 'left': '# '}}

nnoremap <silent> <M-/> :call NERDComment(0, "toggle")<CR><CR>
"vnoremap <silent> <C-_> :call NERDComment(0, "alignleft")<CR><CR>
"vnoremap <silent> <C-_> :call ToggleOrSexy()<CR>
vnoremap <silent> <M-/> :call NERDComment(0, "toggle")<CR><CR>
inoremap <silent> <M-/> <C-o>:call NERDComment(0, "toggle")<CR><C-o><CR>

map <PageUp> <C-u>
map <PageDown> <C-d>
"map <PageUp> 10<Up>
"map <PageDown> 10<Down>

map <S-Up> <C-y>
map <S-Down> <C-e>
"map <S-Up> {
"map <S-Down> }

" Ctrl-P
let g:ctrlp_funky_syntax_highlight = 1
let g:ctrlp_funky_matchtype = 'path'

let g:webdevicons_enable = 1
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

" CtrlP
"nnoremap <silent> <C-p>      :CtrlP<CR>
"nnoremap <silent> <M-p>      :CtrlP<CR>

" Completion mode
"set wildmode=longest,list,full
set wildmode=longest,list
set wildmenu

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

nnoremap <S-Tab> <<
inoremap <S-Tab> <C-d>

" Show cursor line, hide cursor column
set cursorline
set nocursorcolumn

" Making active window more obvious
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END

" Vertical sep
"set fillchars+=vert:\ " Stuff
"set fillchars+=vert:\│,stl:\ ,stlnc:\ ,fold:\―"
"set fillchars+=vert:\ ,stl:\ ,stlnc:\ ,fold:\ ,eob:\ "
set fillchars+=vert:\ ,stl:\ ,stlnc:\ ,fold:\ ,eob:~
"set fillchars+=vert:\|

" │

" Cursor

hi CursorLine ctermbg=234 " cterm=underline
hi CursorColumn ctermbg=234
"hi StatusLine ctermfg=233
"hi StatusLineNC ctermbg=None ctermfg=240 cterm=None

"hi MatchParen ctermfg=magenta ctermbg=none

"hi CursorLineNr ctermfg=119 ctermbg=235 cterm=bold
hi CursorLineNr ctermfg=81 ctermbg=234 cterm=bold
hi LineNr ctermbg=234 ctermfg=239
"hi LineNr ctermbg=none ctermfg=239

" https://stackoverflow.com/a/19594724/3455614
" Dim inactive windows using 'colorcolumn' setting
" This tends to slow down redrawing, but is very useful.
" Based on https://groups.google.com/d/msg/vim_use/IJU-Vk-QLJE/xz4hjPjCRBUJ
" XXX: this will only work with lines containing text (i.e. not '~')
" from
"if exists('+colorcolumn')
"  function! s:DimInactiveWindows()
"    for i in range(1, tabpagewinnr(tabpagenr(), '$'))
"      let l:range = ""
"      if i != winnr()
"        if &wrap
"         " HACK: when wrapping lines is enabled, we use the maximum number
"         " of columns getting highlighted. This might get calculated by
"         " looking for the longest visible line and using a multiple of
"         " winwidth().
"         let l:width=256 " max
"        else
"         let l:width=winwidth(i)
"        endif
"        let l:range = join(range(1, l:width), ',')
"      endif
"      call setwinvar(i, '&colorcolumn', l:range)
"    endfor
"  endfunction
"  augroup DimInactiveWindows
"    au!
"    au WinEnter * call s:DimInactiveWindows()
"    au WinEnter * set cursorline
"    au WinLeave * set nocursorline
"  augroup END
"endif

" Molokai theme patches
hi Normal guibg=NONE ctermbg=NONE ctermfg=NONE
hi NonText ctermbg=NONE

hi Error ctermbg=197 ctermfg=255 cterm=bold,underline

"hi Repeat cterm=underline
"hi Function cterm=underline
hi Include cterm=bold ctermfg=154
"hi MatchParen ctermfg=197 ctermbg=NONE cterm=inverse,bold,underline
hi MatchParen ctermbg=197 cterm=bold,underline

hi Special cterm=italic

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
hi VertSplit ctermbg=none
"hi VertSplit ctermbg=none

" Chars
set list listchars=tab:▏ ,trail:·,extends:»,precedes:«,nbsp:×
" 

let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1

let g:indentLine_char = '▏'
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
let g:indentLine_color_term = 239
" let g:indentLine_bgcolor_term = 202
let g:indentLine_showFirstIndentLevel = 0
let g:indentLine_fileTypeExclude = ['text', 'json', 'help', 'startify']
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
let $SUDO_ASKPASS=$HOME . '/.scripts/rofi-askpass.sh'
"command SudoW w !sudo -A tee %
"cmap w!! :SudoW<CR>

" Clipboard fix
set clipboard^=unnamed,unnamedplus

" Remove trailing whitespaces
fu CleanUp()
    %s/\s\+$//e
    " |norm!``
endf
au BufWritePre * if !&bin | call CleanUp() | endi

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
    "let g:CursorColumnI = col('.')
endf

fu! InsertLeaveHook()
    ":set relativenumber
    "hi BufTabLineActive ctermbg=118 ctermfg=0 cterm=bold
    "hi BufTabLineCurrent ctermbg=118 ctermfg=0 cterm=bold
    "hi CursorLineNr ctermfg=118
    hi CursorLineNr ctermfg=81
    " Back to true mode.
    "if col('.') != g:CursorColumnI | call cursor(0, col('.')+1) | endif
endf

au InsertEnter * call InsertEnterHook()
au InsertLeave * call InsertLeaveHook()
"au CursorMovedI * let CursorColumnI = col('.')

"let &t_EI .= "\<Esc>[2 q\<Esc>]12;green\x7"
"let &t_SI .= "\<Esc>[2 q\<Esc>]12;red\x7"
"let &t_EI .= "\<Esc>[6 q"
"let &t_SI .= "\<Esc>[2 q"

"au VimLeave * silent !echo -ne "\033]112\007"

" piecrumbs
let g:piecrumbs_glue = '  '

" Switch between windows using Tab
nnoremap <Tab> <C-W>w

"set omnifunc=syntaxcomplete#Complete

" BufTabLine

let g:buftabline_show = 2
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1
let g:buftabline_separators = 0
hi BufTabLineFill ctermbg=235
hi BufTabLineCurrent ctermbg=33 ctermfg=255 cterm=bold
"hi BufTabLineActive ctermbg=118 ctermfg=0 cterm=bold
hi BufTabLineHidden ctermbg=235

" ALE
let g:ale_linters = {
            \'javascript': ['eslint'],
            \'python': ['pylint']
            \}
"\'python': ['flake8', 'pylint']
"\'python': ['flake8']

nnoremap <silent> ; :lprev<CR>
nnoremap <silent> ' :lnext<CR>

"let g:ale_sign_error = ' '
"let g:ale_sign_warning = ' '
let g:ale_sign_error = 'E>'
let g:ale_sign_warning = 'E>'
let g:ale_lint_delay = 500
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_save = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_cursor_detail = 0
let g:ale_writegood_use_global = 1

let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix = ' # '

"let g:ale_python_pylint_options = '-j2 --load-plugins pylint_django'
let g:ale_python_pylint_options = "-j2"
"let g:ale_python_pylint_options = "-j2 --init-hook='import sys; sys.path.append(\".\")'"
let g:ale_python_pylint_change_directory = 0

nmap <silent> <F5> :ALELint<CR>

"au BufNewFile,BufRead * ALELint
"let g:ale_sign_column_always = 1

noremap <silent> <A-e> :lopen<CR>

hi ALEWarning ctermbg=190 ctermfg=233 cterm=bold
"hi ALEWarning cterm=reverse
hi ALEWarningSign ctermbg=234 ctermfg=190
"hi ALEError ctermbg=197 ctermfg=255
hi ALEError ctermbg=197 ctermfg=255 cterm=bold,underline
"hi ALEError cterm=reverse
hi ALEErrorSign ctermbg=234 ctermfg=197 cterm=bold

hi ALEVirtualTextError ctermfg=197
hi ALEVirtualTextWarning ctermfg=190

" GitGutter
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 0
let g:gitgutter_max_signs=1000
set signcolumn=yes
au BufWritePost,InsertLeave,TextChanged * :GitGutter
"let g:gitgutter_sign_column_always = 1
" Disable for binary mode
au BufReadPre * if &bin | :GitGutterDisable

" Sexy replace
:map <C-f> :OverCommandLine<CR>:

source $HOME/.vim/scripts/icons.vim
source $HOME/.vim/scripts/signs.vim
"source $HOME/.vim/scripts/fastescape.vim
source $HOME/.vim/scripts/astloc.vim
source $HOME/.vim/scripts/statusline.vim
source $HOME/.vim/scripts/tabline.vim
"source $HOME/.vim/scripts/compl.vim
source $HOME/.vim/scripts/hi_yaml.vim
source $HOME/.vim/scripts/utils.vim
source $HOME/.vim/scripts/autocursor.vim
source $HOME/.vim/scripts/xxdcursor.vim
"source $HOME/.vim/scripts/cute.vim
"source $HOME/.vim/scripts/termrun.vim
"pyfile $HOME/.vim/scripts/compl.py

"fu! PyCompl(findstart, base)
    "return ['a', 'b']
    "result = exe 'py compl('.a:findstart.', "'.a:base.'")'
    "return result
"endf
"set completefunc=PyCompl

" Disable folding
"set nofoldenable
"set foldlevelstart=99
" Nope, let's use it!
"nnoremap <space> za
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
    let width = GetWindowWidth()

    "let str = getline(v:foldstart) . '    ' . repeat('+', v:foldend - v:foldstart) . ' '
    ""let str = str . repeat('·', float2nr(ceil((width - len(str)) / 1.0)))
    "return str

    let str = getline(v:foldstart)
    let amount = repeat('+', v:foldend - v:foldstart)

    return printf('%-'.(width - len(amount) - 3).'s%'.len(amount).'s', str, amount)

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
hi Folded ctermfg=67 ctermbg=16

au FileType javascript setlocal foldmethod=marker foldmarker={,}

function! GoToOpenFold(direction)
  let start = line('.')
  if (a:direction == "next")
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

" Deoplete
"let g:deoplete#enable_at_startup = 1
"let g:deoplete#auto_complete_start_length = 0

"inoremap <expr> <Esc>      pumvisible() ? "\<C-o>\<Esc>" : "\<Esc>"
"inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"

" python3 plugins
"call remote#host#RegisterPlugin(
            "\ 'python3', '/home/anderson/.vim/config/compl2.py', [
            "\ {'sync': v:false, 'name': 'BufWritePost', 'type': 'au', 'opts': {'pattern': '*', 'eval': 'expand("<afile>:p")'}},
            "\ ]
            "\ )

" FZF
function! FindGitRoot()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

nnoremap <silent> <C-p>      :execute 'Files' FindGitRoot()<CR>
nnoremap <silent> <M-p>      :execute 'Files' FindGitRoot()<CR>
nnoremap <silent> <C-l>      :Lines<CR>
nnoremap <silent> <M-l>      :Lines<CR>

"let g:fzf_prefer_tmux = 1

fu! s:fzf_statusline()
  " Override statusline as you like
  "highlight fzf1 ctermfg=161 ctermbg=251
  hi link fzf1 StatusBarVisualInv
  "highlight fzf2 ctermfg=23 ctermbg=251
  hi link fzf2 StatusBarVisualInv
  "highlight fzf3 ctermfg=237 ctermbg=251
  hi link fzf3 StatusBarVisualInv
  setlocal statusline=%#fzf1#\ \ %*\ %#fzf2#fzf%#fzf3#
endf

au! User FzfStatusLine call <SID>fzf_statusline()

au! FileType fzf
au FileType fzf set conceallevel=0
  \| au BufLeave <buffer> set conceallevel=2

"com! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
com! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {'options': ['--reverse', '--preview', 'highlight -O xterm256 --style molokai --force -n {}']}, <bang>0)

"let g:fzf_files_options = '--prefiew "cat {}"'

" NERDTree
"au FileType nerdtree mapc <buffer>
au FileType nerdtree map <buffer> <S-PageUp> <nop>
au FileType nerdtree map <buffer> <S-PageDown> <nop>
au FileType nerdtree map <buffer> <M-x> <nop>
au BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"au FileType nerdtree cnoreabbrev <buffer> bd <nop>
"au FileType nerdtree cnoreabbrev <buffer> bn <nop>
"au FileType nerdtree cnoreabbrev <buffer> bp <nop>
"au VimEnter *  NERDTree
"au VimEnter * wincmd p

" Cursor blinking & look
set guicursor=n-v-c-sm:block-blinkon100,i-ci-ve:ver25-blinkon100,r-cr-o:hor20-blinkon100

" Slime
let g:slime_target = 'tmux'

" Terminal tweaks
"tnoremap <Esc> <C-\><C-n>
"nnoremap <M-d> :q!<CR>

" Detect hi groups
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Tagbar
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
    let highlight_colour = a:current ? '%#StatusBarNormal#' : '%#StatusBarText#'
    let text_colour = a:current ? '%#StatusBarText#' : '%#StatusBarText#'
    let flagstr = join(a:flags, '')
    if flagstr != ''
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
set updatetime=200

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

" JSX
let g:jsx_ext_required = 0

" .xinitrc
"au! BufRead,BufNewFile *.xinitrc set filetype=sh

" Force python path
let g:python_host_prog='/usr/bin/python'

" Virtualenv
"python with virtualenv support
"py3 << EOF
"import os
"import sys
"if 'VIRTUAL_ENV' in os.environ:
"    project_base_dir = os.environ['VIRTUAL_ENV']
"    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"    exec(open(activate_this).read(), dict(__file__=activate_this))
"EOF
let g:ale_python_flake8_executable = $VIRTUAL_ENV . '/bin/flake8'

" GraphViz
au BufNewFile,BufRead *.gv set filetype=dot

" Muttrc
au BufNewFile,BufRead *.muttrc set filetype=muttrc

" Scrolling
"au BufRead * set scroll=20
set scrolloff=5

" UntiSnips
"let g:UltiSnipsExpandTrigger="<C-i>"

" Jenkinsfile indentation
au FileType Jenkinsfile setlocal ts=2 sts=2 sw=2 expandtab

" Limit syntax highlight
set synmaxcol=250

" Rainbow parentheses
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

" Rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
            \ 'ctermfgs': ['darkcyan', 'red', 'darkblue', 'blue'],
            \ }
" SimpylFold
let g:SimpylFold_docstring_preview = 0
let g:SimpylFold_fold_docstring = 0
let g:SimpylFold_fold_import = 0

" Text display tweaks
set display=lastline,msgsep,uhex
set numberwidth=5

" History length
set history=1000

" Disable netRW
let loaded_netrwPlugin = 1

" Shada config
set shada=!,'100,<50,s10,h,:500,@500,/500

" Colorizer
let g:colorizer_auto_filetype='css,html,lua'

" Hex mode
let g:hexmode_xxd_options = '-g 1'

" Python
" Python-mode
let g:pymode_rope = 1
let g:pymode_doc = 1
let g:pymode_doc_bind = '<C-k>'
let g:pymode_rope_completion = 1
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion_bind = '<C-Space>'
let g:pymode_rope_lookup_project = 1
let g:pymode_rope_goto_definition_bind = '<Return>'
let g:pymode_quickfix_minheight = 6
let g:pymode_quickfix_maxheight = 8
let g:pymode_options_max_line_length = 120
let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}
let g:pymode_lint_options_pylint = {'max-line-length': g:pymode_options_max_line_length}
let g:pymode_syntax_all = 1
let g:pymode_rope_goto_definition_cmd = 'vnew'
let g:pymode_options_colorcolumn = 0

" https://github.com/python-mode/python-mode/issues/384#issuecomment-38399715
set completeopt=menu

" Jedi
let g:jedi#show_call_signatures = 2
let g:jedi#show_call_signatures_delay = 500
let g:jedi#popup_select_first = 0
let g:jedi#max_doc_height = 15
let g:jedi#rename_command = '<C-r>'
let g:jedi#usages_command = '<C-n>'
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#use_splits_not_buffers = 'bottom'
let g:jedi#smart_auto_mappings = 0
let g:jedi#fuzzy_completion = 1
au FileType python :py3 from jedi import settings; settings.fuzzy_completion = 1
"let g:jedi#godo_command = '<C-g>'
nmap <silent> <C-g> :call jedi#goto()<CR>
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&contextfunc']

au TextChangedI,CursorMovedI * :call jedi#show_call_signatures()

hi TabLine ctermbg=236 ctermfg=red

" More obvious active windows. Neovim rocks!
hi! NormalNC ctermfg=240 ctermbg=none cterm=none
augroup BgHighlight
    autocmd!
    "autocmd WinEnter * set nu
    "autocmd WinLeave * set nonu
    autocmd WinEnter * set winhl=
    autocmd WinLeave * set winhl=Normal:NormalNC
augroup END

" Conceal tweaks for jedi signature display
hi jediFat ctermfg=203 ctermbg=234 cterm=bold,underline
"hi jediFatSymbol ctermfg=234 ctermbg=234
"au BufRead *.py :syn match jediFatSymbol "\*_\*" contained  " conceal

" Startify
let g:startify_files_number = 10
let g:startify_bookmarks = [{'c': '~/.vimrc'}]
let g:startify_padding_left = 4
let g:startify_fortune_use_unicode = 1
let g:startify_session_remove_lines = ['setlocal', 'winheight']
let g:startify_custom_indices =
            \ map(range(0, g:startify_files_number - 1), 'string(v:val)') +
            \ map(range(90, 99), 'string(v:val)')

let g:startify_lists = [
            \ { 'header': ['  MRU'], 'type': 'files' },
            \ { 'header': ['  Bookmarks'], 'type': 'bookmarks' },
            \ { 'header': ['  Sessions'], 'type': 'sessions' },
            \ ]
"            \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
"            \ { 'header': ['   Sessions'],       'type': 'sessions' },
"            \ { 'header': ['   Commits'],        'type': function('s:list_commits') },

" Easy motion
nmap s <Plug>(easymotion-bd-w)
nmap S <Plug>(easymotion-bd-jk)
nmap c <Plug>(easymotion-s2)
nmap <Leader><Leader> <Plug>(easymotion-prefix)

" Incsearch
"call incsearch#call(incsearch#config#fuzzy#make())
"map z/  <Plug>(incsearch-fuzzy)
"map z?  <Plug>(incsearch-fuzzy?)
"map zg/ <Plug>(incsearch-fuzzy-stay)

" Pydocstring
let g:pydocstring_enable_mapping = 0
let g:pydocstring_templates_dir = $HOME . '/.vim/templates/pydocstring/'

