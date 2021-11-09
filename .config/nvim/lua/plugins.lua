-- vim:foldmethod=marker
require('packer').startup(function()
    -- General
    use 'wbthomason/packer.nvim'
    use 'tomasr/molokai'
    use 'mhinz/vim-startify'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/lsp-status.nvim'
    use 'tpope/vim-commentary'
    use 'jose-elias-alvarez/null-ls.nvim'

    -- TS
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'nvim-treesitter/playground'
    use 'JoosepAlviste/nvim-ts-context-commentstring'

    -- Indentation
    use 'Yggdroot/indentLine'
    use 'Vimjas/vim-python-pep8-indent'
    use 'airblade/vim-gitgutter'
    use 'ervandew/supertab'

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
vim.g.SuperTabDefaultCompletionType = 'context'
vim.g.SuperTabContextTextOmniPrecedence = {'&omnifunc', '&contextfunc'}
-- }}}
-- Status line {{{
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
