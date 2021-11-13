vim.cmd([[
filetype on
filetype plugin on
filetype plugin indent on
syntax enable
]])

vim.cmd('colorscheme molokai')

-- Switch buffers (NeoVIM)
nnoremap('<S-PageUp>', '<cmd>bp<CR>')
nnoremap('<S-PageDown>', '<cmd>:bn<CR>')
inoremap('<S-PageUp>', '<cmd>bp<CR>')
inoremap('<S-PageDown>', '<cmd>:bn<CR>')

-- Save with C-s
nnoremap('<C-s>', '<cmd>w<CR>')
inoremap('<C-s>', '<cmd><C-o>w<CR>')
nnoremap('<M-s>', '<cmd>w<CR>')
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

-- Redo
nnoremap('<M-r>', '<C-r>')
nnoremap('r', '<C-r>')

-- Clear search
nnoremap('<M-c>', '<cmd>nohlsearch<CR>')
nnoremap('<esc>', '<cmd>nohlsearch<CR><esc>')

-- Smart home
function _G.smart_home()
    return vim.api.nvim_get_current_line():find('%S') == vim.api.nvim_win_get_cursor(0)[2] + 1 and t'0' or t'^'
end
nnoremap('<Home>', 'v:lua.smart_home()', true)
imap('<Home>', '<C-O><Home>')

-- Delete words with Alt-BackSpace
inoremap('<M-BS>', '<C-W>')

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

vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 10

vim.o.termguicolors = true

-- TODO: Any effect from these?
vim.g.molokai_original = 1
vim.g.rehash256 = 1
vim.g.sublimemonokai_term_italic = 1

-- Show cursor line, hide cursor column
vim.o.cursorline = true
vim.o.cursorcolumn = false

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
    trail = '·',
    extends = '»',
    precedes = '«',
    nbsp = '×',
}

-- Clipboard
vim.o.clipboard = 'unnamedplus'

-- Change line when cursor is moved beyond the line
vim.o.whichwrap = '<,>,h,l,[,]'

-- Force python path
vim.g.python_host_prog = '/usr/bin/python'

-- Scrolling
vim.o.scrolloff = 5

-- Window size
vim.cmd([[
aug EqualWindows
    au VimResized * :wincmd =
aug END
]])

-- Limit syntax highlight
vim.o.synmaxcol = 200

-- Text display tweaks
vim.opt.display = ''
vim.opt.display = vim.opt.display + 'lastline' + 'msgsep' + 'uhex'
vim.o.numberwidth = 5

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
vim.o.completeopt = 'menuone,longest,noinsert'

-- Blink yanked text
vim.cmd([[
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=100, on_visual=true}
]])

vim.cmd([[
hi Normal guibg=NONE ctermbg=NONE ctermfg=NONE
hi CursorLine guibg=#242424
hi CursorLineNr guibg=#242424
hi LineNr guibg=#202020
hi SignColumn guibg=#202020
hi ErrorMsg guibg=none
" TODO:
hi Conceal ctermfg=240 ctermbg=none
hi VertSplit ctermbg=none ctermfg=242

hi Pmenu ctermfg=81 ctermbg=16 guifg=#66D9EF guibg=#202020
hi! link PmenuSbar Pmenu
hi! PmenuThumb guibg=#66D9EF
hi PmenuSel guifg=#000000
]])

-- Remove trailing whitespaces
vim.cmd([[
fu CleanUp()
    exe '%s/\s\+$//e'
    " |norm!``
endf
aug CleanUp
    au BufWritePre * if !&bin | call CleanUp() | endi
aug END
]])

-- Folding
nnoremap('<space>', 'za')
vim.o.foldmethod = 'manual'
vim.o.foldnestmax = 2

-- Spell checking
vim.o.spelllang = 'uk,en'
vim.go.spell = false
function EnableSpellchecking()
    vim.bo.spell = true
end
vim.cmd([[
    au FileType markdown setlocal spell
]])
