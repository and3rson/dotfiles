" vim:foldmethod=marker
" Preconfiguration {{{
scriptencoding utf-8

set t_Co=256

set nocompatible

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

"let g:python_host_prog='/usr/bin/python'
" }}}

" Plug {{{
call plug#begin('~/.vim/plugged')
    Plug 'tomasr/molokai'
    "Plug 'dikiaap/minimalist'
    "Plug 'ErichDonGubler/vim-sublime-monokai'
call plug#end()

colorscheme molokai
"colorscheme minimalist
"colorscheme sublimemonokai
filetype on
filetype plugin on
filetype plugin indent on
syntax enable

call plug#begin('~/.vim/plugged')
    "Plug 'dikiaap/minimalist'
    Plug 'VundleVim/Vundle.vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'Yggdroot/indentLine'
    "Plug 'nathanaelkane/vim-indent-guides'
    Plug 'w0rp/ale'

    " Slow returns
    Plug 'Vimjas/vim-python-pep8-indent'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'
    Plug 'ervandew/supertab'

    "Plugin 'ap/vim-css-color'
    Plug 'chrisbra/Colorizer'
    Plug 'osyo-manga/vim-over'
    "Plugin 'haya14busa/incsearch.vim'
    "Plugin 'haya14busa/incsearch-fuzzy.vim'

    Plug 'tmux-plugins/vim-tmux'

    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    " Ack (must be loaded AFTER fzf)
    "Plug 'mileszs/ack.vim'

    "Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    "Plugin 'joeytwiddle/sexy_scroller.vim'
    Plug 'mhinz/vim-startify'

    "Plugin 'wkentaro/conque.vim'
    "Plug 'christoomey/vim-tmux-navigator'
    "Plugin 'jpalardy/vim-slime'

    Plug 'majutsushi/tagbar'
    "Plugin 'calebsmith/vim-lambdify'
    "Plug 'ehamberg/vim-cute-python'

    " Syntax files
    Plug 'pangloss/vim-javascript'
    Plug 'mxw/vim-jsx'
    Plug 'chr4/nginx.vim'
    Plug 'martinda/Jenkinsfile-vim-syntax'

    " Faster YAML syntax
    Plug 'stephpy/vim-yaml'

    "Plugin 'kien/rainbow_parentheses.vim'
    Plug 'luochen1990/rainbow'

    " Godot GDScript
    Plug 'calviken/vim-gdscript3'

    " Python better code folding

    " TypeScript
    Plug 'leafgarland/typescript-vim'

    " Hex mode
    Plug 'fidian/hexmode'
    "Plugin 'mattn/vim-xxdcursor'

    "Plugin 'chriskempson/base16-vim'

    " Python
    "Plugin 'python-mode/python-mode'
    Plug 'davidhalter/jedi-vim'
    Plug 'heavenshell/vim-pydocstring'

    " Go
    Plug 'fatih/vim-go'

    " Motion
    Plug 'easymotion/vim-easymotion'

    " Local vim settings
    Plug 'embear/vim-localvimrc'

    " Custom plugins
    Plug '~/.vim/plugins/icons'
    Plug '~/.vim/plugins/utils'
    Plug '~/.vim/plugins/autocursor'
    Plug '~/.vim/plugins/hi_yaml'
    Plug '~/.vim/plugins/icons'
    Plug '~/.vim/plugins/signs'
    Plug '~/.vim/plugins/statusline'
    Plug '~/.vim/plugins/tabline'
    Plug '~/.vim/plugins/pds'
    "Plug '~/.vim/plugins/hi_godot'
    "Plug '~/.vim/plugins/pyxl'

call plug#end()                    " required
" }}}

" Internals (hotkeys, highlights, vim configs) {{{

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
nnoremap <silent> <M-x>      :bd<CR>
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

" Show cursor line, hide cursor column
set cursorline
set nocursorcolumn

" Fill chars
"set fillchars+=vert:\ ,stl:\ ,stlnc:\ ,fold:\ ,eob:\ "
set fillchars+=stl:\ ,stlnc:\ ,fold:\-,msgsep:+,eob:\ "
" Chars
set list listchars=tab:▏ ,trail:·,extends:»,precedes:«,nbsp:×
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
set colorcolumn=120,160

" Word jump config
"set iskeyword=@,48-57

" }}}

" Colors {{{
" Cursor

hi CursorLine ctermbg=234 " cterm=underline
hi CursorColumn ctermbg=234
"hi StatusLine ctermfg=233
"hi StatusLineNC ctermbg=None ctermfg=240 cterm=None

"hi MatchParen ctermfg=magenta ctermbg=none

"hi CursorLineNr ctermfg=119 ctermbg=235 cterm=bold
hi CursorLineNr ctermfg=81 ctermbg=234 cterm=bold
hi LineNr ctermbg=234 ctermfg=242
"hi LineNr ctermbg=none ctermfg=239

" Molokai theme patches
hi Normal guibg=NONE ctermbg=NONE ctermfg=NONE
hi NonText ctermbg=NONE

hi Error ctermbg=197 ctermfg=255 cterm=bold,underline

"hi Repeat cterm=underline
"hi Function cterm=underline
hi Include cterm=bold ctermfg=154
"hi MatchParen ctermfg=197 ctermbg=NONE cterm=inverse,bold,underline
hi MatchParen ctermfg=197 ctermbg=none cterm=bold,underline

hi Special cterm=italic

hi ColorColumn ctermbg=235

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
hi VertSplit ctermbg=234 ctermfg=242
" }}}

" NERD Commenter {{{
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCustomDelimiters = {'python': {'leftAlt': '"""', 'rightAlt': '"""', 'left': '#'}}
"let g:NERDCustomDelimiters = { 'c': { 'left': '//','right': '' } }
let g:NERDAltDelims_c = 1
let g:NERDAltDelims_cpp = 0
let g:NERDTrimTrailingWhitespace = 1

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

" }}}
" Ctrl-P {{{
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

"nnoremap <silent> <C-p>      :CtrlP<CR>
"nnoremap <silent> <M-p>      :CtrlP<CR>

" Completion mode
"set wildmode=longest,list,full
set wildmode=longest,list
set wildmenu

" }}}
" intentLine {{{
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
    %s/\s\+$//e
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
" PieCrumbs {{{
let g:piecrumbs_glue = '  '
" }}}
" ALE {{{
" TODO: Do not rewrite existing linters config?
"let g:ale_linters.javascript = ['eslint']
"let g:ale_linters.python = ['pylint']
let g:ale_linters = {
            \'javascript': ['eslint'],
            \'python': ['pylint'],
            \'go': ['gofmt', 'golint', 'go vet']
            \}
"\'python': ['flake8', 'pylint']
"\'python': ['flake8']

nnoremap <silent> ; :lprev<CR>
nnoremap <silent> ' :lnext<CR>

let g:ale_open_list = 0
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
"let g:ale_sign_error = 'EE'
"let g:ale_sign_warning = 'EE'
let g:ale_lint_delay = 500
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_save = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_cursor_detail = 0
let g:ale_writegood_use_global = 1
let g:ale_echo_cursor = 1

"let g:ale_virtualtext_cursor = 1
"let g:ale_virtualtext_prefix = ' *** '
"let g:ale_cursor_detail = 1

"let g:ale_python_pylint_options = '-j2 --load-plugins pylint_django'
let g:ale_python_pylint_options = '-j2'
"let g:ale_python_pylint_options = "-j2 --init-hook='import sys; sys.path.append(\".\")'"
let g:ale_python_pylint_change_directory = 1

" TODO: ?
let g:ale_python_flake8_executable = $VIRTUAL_ENV . '/bin/flake8'

nmap <silent> <F5> :ALELint<CR>

"au BufNewFile,BufRead * ALELint
"let g:ale_sign_column_always = 1

noremap <silent> <A-e> :lopen<CR>

"hi ALEWarning ctermbg=190 ctermfg=233 cterm=bold
"hi ALEWarning cterm=underline
hi ALEWarning cterm=reverse ctermfg=yellow
hi ALEWarningSign ctermbg=234 ctermfg=190
"hi ALEError ctermbg=197 ctermfg=255
"hi ALEError ctermbg=197 ctermfg=255 cterm=bold,underline
"hi ALEError cterm=underline
hi ALEError cterm=reverse ctermfg=red
hi ALEErrorSign ctermbg=234 ctermfg=197 cterm=bold

hi ALEVirtualTextError ctermfg=197 cterm=bold
hi ALEVirtualTextWarning ctermfg=yellow cterm=bold
"hi ALEVirtualTextWarning ctermfg=190 cterm=bold,underline

let g:ale_annotations_ns_id = nvim_create_namespace('ALEAnnotations')

hi VirtualError ctermfg=244 cterm=underline

fu! ClearALEAnnotations()
    call nvim_buf_clear_highlight(bufnr('%'), g:ale_annotations_ns_id, 0, -1)
endf

fu! ShowALEAnnotations()
    for l:info in g:ale_buffer_info[bufnr('%')].loclist
        let l:class = 'ALEVirtualTextError'
        let l:prefix = 'EE'
        if l:info.type ==# 'W'
            let l:class = 'ALEVirtualTextWarning'
            let l:prefix = 'WW'
        endi
        let l:meta = ''
        if has_key(l:info, 'linter_name')
            let l:meta = l:info.linter_name
        end
        if has_key(l:info, 'code')
            if len(l:meta)
                let l:meta .= '/'
            end
            let l:meta .= l:info.code
        end
        if len(l:meta)
            let l:meta .= ': '
        end
        "\ [[' ', 'Normal'], ['[' . l:prefix . '] ' . l:meta . l:info.text, l:class]],
        call nvim_buf_set_virtual_text(
                    \ bufnr('%'),
                    \ g:ale_annotations_ns_id,
                    \ l:info.lnum - 1,
                    \ [
                    \   [' ' . b:NERDCommenterDelims.left, 'Comment'],
                    \   ['[' . l:prefix . '] ', l:class],
                    \   [l:meta . l:info.text, 'VirtualError']
                    \ ],
                    \ {}
                    \ )
    endfo
endf

aug ALEAutoLint
    au! BufRead,BufWrite * :ALELint
    "au! BufRead,BufWrite,TextChanged,InsertLeave * :ALELint
    " au! User ALELintPre :call ClearALEAnnotations()
    " au! User ALELintPost :call ShowALEAnnotations()
aug END

"let g:ale_go_golint_executable = '...'

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
hi Folded ctermfg=67 ctermbg=0 cterm=italic

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
" Deoplete {{{
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
" }}}
" FZF {{{
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

aug FZFCustomStatusLine
    au! User FzfStatusLine call <SID>fzf_statusline()

    au! FileType fzf
    au FileType fzf set conceallevel=0
      \| au BufLeave <buffer> set conceallevel=2
aug END

"com! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
com! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {'options': ['--reverse', '--preview', 'highlight -O xterm256 --style molokai --force -n {}']}, <bang>0)

nnoremap <silent> <M-f> :Rg<CR>

"let g:fzf_files_options = '--prefiew "cat {}"'

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
    let highlight_colour = a:current ? '%#StatusBarNormal#' : '%#StatusBarText#'
    let text_colour = a:current ? '%#StatusBarText#' : '%#StatusBarText#'
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
" }}}
" JSX {{{
let g:jsx_ext_required = 0
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
let g:colorizer_auto_filetype='css,html,lua'
" }}}
" Hex mode {{{
let g:hexmode_xxd_options = '-g 1'
" }}}
" Python {{{
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
"let g:jedi#auto_initialization = 0
let g:jedi#show_call_signatures = 2
let g:jedi#show_call_signatures_delay = 500
let g:jedi#popup_select_first = 0
let g:jedi#max_doc_height = 15
let g:jedi#rename_command = '<C-r>'
let g:jedi#usages_command = '<C-n>'
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
" let g:jedi#use_splits_not_buffers = 'right'
let g:jedi#smart_auto_mappings = 0
let g:jedi#fuzzy_completion = 1
aug PythonJediConfig
    au FileType python :py3 from jedi import settings; settings.fuzzy_completion = 1
    "au TextChangedI,CursorMovedI * :call jedi#show_call_signatures()
aug end
"let g:jedi#godo_command = '<C-g>'
au FileType python nmap <silent> <C-g> :call jedi#goto()<CR>
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&contextfunc']

hi TabLine ctermbg=236 ctermfg=red

" More obvious active windows. Neovim rocks!
"hi! NormalNC ctermfg=240 ctermbg=none cterm=none
"hi! LineNrNC ctermbg=none
"hi! SignColumnNC ctermbg=none
"hi! IdentifierNC ctermfg=100
"hi! StatementNC ctermfg=89
"hi! SpecialNC ctermfg=25
"hi! PreProcNC ctermfg=65

aug BgHighlight
    au!
    "autocmd WinEnter * set nu
    "autocmd WinLeave * set nonu

    " Tired of this
    "au WinEnter * setlocal winhl=
    "au WinLeave * setlocal winhl=Normal:NormalNC

    " ,LineNr:LineNrNC,SignColumn:SignColumnNC
    " ,Identifier:IdentifierNC
    " ,Statement:StatementNC,Special:SpecialNC,PreProc:PreProcNC
aug END

" Conceal tweaks for jedi signature display
hi jediFat ctermfg=197 ctermbg=234 cterm=bold,underline
"hi jediFatSymbol ctermfg=234 ctermbg=234
"au BufRead *.py :syn match jediFatSymbol "\*_\*" contained  " conceal

" }}}
" Go {{{
au FileType go nmap <silent> <C-g> :GoDef<CR>
let g:go_fmt_fail_silently = 1  " Do not open loclist
let g:go_lint_fail_silently = 1  " Do not open loclist
let g:go_list_height = 0
let g:go_list_autoclose = 1
"let g:go_metalinter_autosave = 0
"au CursorMoved *.go :GoInfo
"au BufRead,BufWrite *.go :GoLint
au FileType go nnoremap <silent> w :GoInfo<CR>
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
let g:localvimrc_ask = 0
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
au BufNewFile *.py 0r ~/.vim/skeletons/skeleton.py | call FormatTemplate()
" }}}
