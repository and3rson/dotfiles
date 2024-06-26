require 'functions'

vim.cmd([[
" filetype on
" filetype plugin on
" filetype plugin indent on
" syntax enable
]])

vim.o.fileencodings = 'ucs-bom,utf-8,default,cp1251,latin1'

vim.o.termguicolors = true

-- TODO: Any effect from these?
vim.g.sonokai_better_performance = 1
vim.g.molokai_original = 1
vim.g.rehash256 = 1
vim.g.sublimemonokai_term_italic = 1

vim.g.sonokai_transparent_background = 1
vim.g.sonokai_show_eob = 0
vim.g.sonokai_enable_italic = 1
vim.g.sonokai_diagnostic_text_highlight = 1
-- vim.g.sonokai_diagnostic_line_highlight = 1
vim.g.sonokai_diagnostic_virtual_text = 'colored'
vim.g.sonokai_style = 'andromeda'
vim.g.sonokai_menu_selection_background = 'green'

vim.cmd([[
    fu! s:sonokai_custom() abort
        hi CursorLine guibg=#242424
        hi CursorLineNr guibg=#242424
        hi LineNr guibg=#202020
        hi SignColumn guibg=#202020
        hi ColorColumn guibg=#111111

        hi Pmenu ctermfg=81 ctermbg=16 guifg=#66D9EF guibg=#202020
        hi! link PmenuSbar Pmenu
        hi! PmenuThumb guibg=#66D9EF
        hi PmenuSel guifg=#000000

        hi MatchParen guifg=red guibg=none gui=underline,bold
        " hi Whitespace guifg=red " gui=underline
        hi IndentBlanklineChar guifg=#444444


        hi! link TSInclude Green
        " exec 'hi! TSInclude gui=bold guifg=' .. synIDattr(hlID('Green'), 'fg')
        hi! link TSConstant Purple
        " exec 'hi! TSConstant gui=bold guifg=' .. synIDattr(hlID('Purple'), 'fg')
        exec 'hi! TSVariableBuiltin gui=bold guifg=' .. synIDattr(hlID('Purple'), 'fg')
        " hi! link TSVariableBuiltin Red
        " hi! TSVariableBuiltin gui=bold
        " hi! link TSParameter Orange
        hi! link TSTag Blue
        " hi! link TSType Red
    endf
    augroup SonokaiCustom
        autocmd!
        autocmd ColorScheme sonokai call s:sonokai_custom()
    augroup END
]])

-- vim.cmd('colorscheme molokai')
-- vim.cmd('hi Normal guibg=none')
vim.cmd('colorscheme sonokai')
-- vim.cmd('colorscheme gruvbox-material')
-- vim.cmd('colorscheme monokai')

-- Switch buffers (NeoVIM)
nnoremap('<S-PageUp>', '<cmd>bp<CR>')
nnoremap('<S-PageDown>', '<cmd>:bn<CR>')
inoremap('<S-PageUp>', '<cmd>bp<CR>')
inoremap('<S-PageDown>', '<cmd>:bn<CR>')

-- Save with C-s
nnoremap('<C-s>', '<cmd>w<CR>')
inoremap('<C-s>', '<cmd><C-o>w<CR>')
nnoremap('<M-s>', '<cmd>w<CR><cmd>nohlsearch<CR>')
inoremap('<M-s>', '<cmd>w<CR>')

-- Delete buffer
nnoremap('<M-x>', '<cmd>bdelete<CR>')

-- Close window
nnoremap('<M-q>', '<C-w>q<CR>')

-- Switch windows with Tab
nnoremap('<Tab>', '<C-W>w')

-- Page scrolling
map('<PageUp>', '<C-u>')
map('<PageDown>', '<C-d>')

-- Moving around
nnoremap('<C-Left>', 'b')
nnoremap('<C-Right>', 'e')

-- Redo
nnoremap('<M-r>', '<C-r>')
nnoremap('r', '<C-r>')

-- Clear search
-- nnoremap('<M-c>', '<cmd>nohlsearch<CR>')
nnoremap('<esc>', '<cmd>nohlsearch<CR>')

-- Smart home
function _G.smart_home()
    return vim.api.nvim_get_current_line():find('%S') == vim.api.nvim_win_get_cursor(0)[2] + 1 and t '0' or t '^'
end

nnoremap('<Home>', 'v:lua.smart_home()', true)
imap('<Home>', '<C-O><Home>')

-- Delete words with Alt-BackSpace
inoremap('<M-BS>', '<C-W>')

-- Align columns
vnoremap('c', ':%!column -t<CR>')

-- General configs
vim.o.redrawtime = 1000

vim.wo.wrap = false

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.smarttab = true

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.number = true

vim.o.timeoutlen = 100
vim.o.ttimeoutlen = 10

-- Show cursor line, hide cursor column
vim.o.cursorline = true
vim.o.cursorcolumn = false

-- CursorHold
vim.o.updatetime = 500

-- Fill chars
-- vim.opt.fillchars = vim.opt.fillchars + 'stl: ' + 'stlnc: ' + 'fold:-' + 'msgsep:+' + 'eob: '
vim.opt.fillchars = {
    stl = ' ',
    stlnc = ' ',
    fold = '-',
    msgsep = '+',
    eob = ' ',
}

-- Chars
-- TODO: Not working
vim.o.list = true
vim.go.list = true
vim.wo.list = true
vim.api.nvim_set_option('list', true)
vim.api.nvim_win_set_option(0, 'list', true)
-- vim.opt.listchars = vim.opt.listchars + 'tab:▏ ' + 'trail:·' + 'extends:»' + 'precedes:«' + 'nbsp:×'
vim.opt.listchars = {
    tab = '▏ ',
    -- tab = '  ',
    trail = '·',
    -- trail = '×',
    -- trail = '-',
    extends = '»',
    precedes = '«',
    nbsp = '×',
}

-- Clipboard
vim.o.clipboard = 'unnamedplus'

-- Disable mouse
vim.o.mouse = false

-- Change line when cursor is moved beyond the line
vim.o.whichwrap = '<,>,h,l,[,]'

-- Force python path
vim.g.python_host_prog = '/usr/bin/python'
vim.g.python3_host_prog = '/usr/bin/python'

-- Scrolling
vim.o.scrolloff = 5

-- Window size
vim.cmd([[
aug EqualWindows
    au VimResized * :wincmd =
aug END
]])

-- Limit syntax highlight
vim.o.synmaxcol = 300

-- Text display tweaks
vim.opt.display = ''
vim.opt.display = vim.opt.display + 'lastline' + 'msgsep' + 'uhex'
vim.o.numberwidth = 2

-- History length
vim.o.history = 1000

-- Disable netRW
vim.g.loaded_netrwPlugin = 1

-- Shada config
vim.opt.shada = "!,'100,<50,s10,h,:500,@500,/500"

-- No backups
vim.o.swapfile = false
vim.o.backup = false

-- Allow switching to other buffer if current buffer has unsaved changes
vim.o.hidden = true

-- Color column
vim.o.colorcolumn = '120'

-- Sign column
vim.o.signcolumn = 'yes'

-- Command line horizontal completion instead of vertical
vim.o.wildmenu = false
vim.opt.wildoptions = vim.opt.wildoptions - 'pum'
vim.opt.wildoptions = vim.opt.wildoptions - 'tagfile'
vim.o.wildmode = 'list:longest'

-- Disable preview for completions
-- vim.opt.completeopt = vim.opt.completeopt - 'preview'
-- vim.opt.completeopt = vim.opt.completeopt + 'noinsert'
vim.o.completeopt = 'menu,noselect'

-- Cmdline height
-- vim.o.cmdheight = 0
-- vim.cmd([[
--     au CmdlineEnter * set cmdheight=1
--     au CmdlineLeave * set cmdheight=0
-- ]])

-- Blink yanked text
vim.cmd([[
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=100, on_visual=true}
]])

-- Remove trailing whitespaces
-- vim.cmd([[
-- fu CleanUp()
--     exe '%s/\s\+$//e'
--     " |norm!``
-- endf
-- aug CleanUp
--     au BufWritePre * if !&bin | call CleanUp() | endi
-- aug END
-- ]])

-- Folding
nnoremap('<space>', 'za')
-- vim.o.foldmethod = 'syntax'
vim.o.foldnestmax = 10

-- Spell checking
vim.o.spelllang = 'uk,en'
vim.go.spell = false
function EnableSpellchecking()
    vim.bo.spell = true
end

vim.cmd([[
    au FileType markdown setlocal spell
    au FileType go set noet
]])

-- Filetype-specific
vim.cmd([[
    au FileType gitcommit setlocal nofen
    au FileType javascript setlocal nofen
    au FileType conf setlocal fdm=marker
    au FileType markdown setlocal sw=2
    au BufRead *.tscn,*.tres,*.import set ft=dosini
    au BufRead *.tfvars set ft=terraform
    au BufNewFile,BufRead *.s set ft=asm_ca65
    " au FileType asm lua vim.opt.listchars:append({trail = ' '})
    au BufNewFile,BufRead *.inc set ft=asm
    au BufNewFile,BufRead *.vec set ft=vec
    au BufNewFile,BufRead *.ASM set ft=asm
    au BufNewFile,BufRead *.asm set ft=nasm
    au FileType cupl set commentstring=/*%s*/
    au FileType nasm set commentstring=;%s
    let g:asm_ca65_wdc = 1
    let g:asm_ca65_rockwell = 1

    " for hex editing
    augroup Binary
      au!
      au BufReadPre  *.bin let &bin=1
      au BufReadPost *.bin if &bin | %!xxd -g1
      au BufReadPost *.bin set ft=xxd | endif
      au BufWritePre *.bin if &bin | %!xxd -r -g1
      au BufWritePre *.bin endif
      au BufWritePost *.bin if &bin | %!xxd -g1
      au BufWritePost *.bin set nomod | endif
    augroup END
]])
vim.cmd('let g:vim_json_conceal = 0')
vim.g.vim_json_conceal = 0

