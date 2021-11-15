-- vim:foldmethod=marker
-- Plugins {{{
require('packer').startup(function(use)
    -- General
    use 'wbthomason/packer.nvim'
    use 'tomasr/molokai'
    use 'mhinz/vim-startify'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/lsp-status.nvim'
    use 'tpope/vim-commentary'
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    -- use 'hrsh7th/cmp-vsnip'
    -- use 'hrsh7th/vim-vsnip'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    -- TS
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'nvim-treesitter/playground'
    use 'JoosepAlviste/nvim-ts-context-commentstring'

    -- Indentation
    use 'Yggdroot/indentLine'
    use 'Vimjas/vim-python-pep8-indent'
    use 'airblade/vim-gitgutter'
    use 'ervandew/supertab'
    use 'yuezk/vim-js'
    use 'MaxMEllon/vim-jsx-pretty'

    -- Cursor position
    use 'farmergreg/vim-lastplace'

    -- Telescope
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'

    -- Tagbar
    -- requires icons
    -- use 'majutsushi/tagbar'

    -- Syntax
    use 'hashivim/vim-terraform'
    use 'stephpy/vim-yaml'
    use 'othree/html5.vim'

    -- Status lines
    use 'nvim-lualine/lualine.nvim'
    use 'ap/vim-buftabline'

    -- SQL completion
    -- use 'vim-scripts/dbext.vim'

    -- Editorconfig
    -- use 'editorconfig/editorconfig-vim'
end)
-- }}}

-- Commentary {{{
nnoremap('<M-/>', '<cmd>Commentary<CR>')
vnoremap('<M-/>', ':Commentary<CR>')
-- inoremap <silent> <M-/> <C-o>:Commentary<CR><C-o><CR>
imap('<M-/>', '<cmd>Commentary<CR>')
-- }}}
-- indentLine {{{
vim.g.indent_guides_enable_on_vim_startup = 1
vim.g.indent_guides_guide_size=1

vim.g.indentLine_char = '▏'
vim.g.indentLine_first_char = '▏'
vim.g.indentLine_concealcursor = 0
vim.g.indentLine_conceallevel = 1
vim.g.indentLine_color_term = 236
vim.g.indentLine_showFirstIndentLevel = 0
vim.g.indentLine_fileTypeExclude = {'text', 'help', 'startify'}
vim.g.indentLine_faster = 1 -- TODO: Experimental
-- }}}
-- GitGutter {{{
vim.cmd([[
hi GitGutterAdd guifg=#50C650 guibg=#202020
hi GitGutterChange guifg=#C6C600 guibg=#202020
hi GitGutterDelete guifg=#C60050 guibg=#202020
]])
vim.g.gitgutter_realtime = 1
vim.g.gitgutter_eager = 0
vim.g.gitgutter_max_signs=1000
vim.cmd([[
aug GitGutter
    au BufWritePost,InsertLeave,TextChanged * :GitGutter
    au BufReadPre * if &bin | :GitGutterDisable
aug END
]])
-- }}}
-- Supertab {{{
-- vim.g.SuperTabDefaultCompletionType = 'context'
-- vim.g.SuperTabContextTextOmniPrecedence = {'&omnifunc', '&contextfunc'}
-- }}}
-- Status line {{{
local mode_map = {
    N= '',
    I= '',
    R= '',
    C= '',
    V= '',
    T= '',
    }

local function lspStatus()
    -- stats = require("lsp-status/diagnostics")(0)
    local stats = require("lsp-status").diagnostics()
    local parts = {}
    if stats.errors > 0 then
        table.insert(parts, '✖ ' .. stats.errors)
    end
    if stats.warnings > 0 then
        table.insert(parts, ' ' .. stats.warnings)
    end
    return table.concat(parts, ' ')
end

local ts_utils = require('nvim-treesitter.ts_utils');

local ts_node_icons = {
    class_definition = '',
    method_definition = '',
    function_definition = '',
}

local ts_node_highlights = {
    class_definition = 'TSType',
    method_definition = 'TSFunction',
    function_definition = 'TSFunction',
}

local function tsPath()
    local node = ts_utils.get_node_at_cursor()
    local parts = {}
    while node do
        if vim.tbl_contains({"class_definition", "method_definition", "function_definition"}, node:type()) then
            local name_node = node:named_child('name')
            local name = ts_utils.get_node_text(name_node)
            table.insert(parts, 1, '%#' .. ts_node_highlights[node:type()] .. '#' .. ts_node_icons[node:type()] .. ' ' .. table.concat(name, ''))
        end
        node = node:parent()
    end
    return table.concat(parts, ' -> ')
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
        lualine_b = {{'filename', fmt = function(str) local cur = vim.api.nvim_win_get_cursor(0); return str .. ':' .. cur[1] .. ':' .. cur[2] end}},
        -- lualine_c={'tsPath()'},
        lualine_x={'filetype', 'encoding'}, -- %04B
        lualine_y={'branch'},
        -- lualine_z={'lspStatus()'},
        lualine_z={
            {'diagnostics', color={bg='#202020'}}
        },
    }
}
-- }}}
-- Buffer line {{{
vim.cmd([[
hi TabLineFill ctermfg=0 guifg=#000000
hi TabLine ctermbg=0 ctermfg=245 guibg=#000000 guifg=#606060 cterm=none
hi TabLineSel ctermbg=150 ctermfg=0 guibg=#98C379 guifg=#000000 cterm=none gui=none
hi BufTabLineActive ctermbg=239 ctermfg=255 guibg=#404040 guifg=#FFFFFF
let g:buftabline_numbers = 2
let g:buftabline_indicators = 1
let g:buftabline_separators = 1
nmap <M-1> <Plug>BufTabLine.Go(1)
nmap <M-2> <Plug>BufTabLine.Go(2)
nmap <M-3> <Plug>BufTabLine.Go(3)
nmap <M-4> <Plug>BufTabLine.Go(4)
nmap <M-5> <Plug>BufTabLine.Go(5)
]])
-- }}}
-- Telescope {{{
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
vim.cmd([[
nnoremap <silent> <M-l> :Telescope live_grep<CR>
nnoremap <silent> <M-p> :Telescope find_files<CR>
]])
-- }}}
