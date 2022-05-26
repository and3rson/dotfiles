-- vim:foldmethod=marker
-- Plugins {{{
require('packer').startup(function(use)
    -- Themes
    use 'wbthomason/packer.nvim'
    use 'tomasr/molokai'
    use 'sainnhe/sonokai'
    -- use 'sainnhe/gruvbox-material'
    -- use 'navarasu/onedark.nvim'
    -- use 'tanvirtin/monokai.nvim'

    -- Startup & configs
    use 'mhinz/vim-startify'
    use 'embear/vim-localvimrc'
    use 'editorconfig/editorconfig-vim'
    use 'lambdalisue/vim-manpager'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/lsp-status.nvim'
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'onsails/lspkind-nvim'
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'
    -- use 'nyuszika7h/python-syntax' -- https://github.com/Vimjas/vim-python-pep8-indent/issues/140
    -- use 'hrsh7th/cmp-vsnip'
    -- use 'hrsh7th/vim-vsnip'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'rafamadriz/friendly-snippets'
    -- use 'dcampos/nvim-snippy'
    -- use 'dcampos/cmp-snippy'
    -- use 'ray-x/lsp_signature.nvim'
    -- use {'ms-jpq/coq_nvim', branch='coq'}
    -- use {'ms-jpq/coq.artifacts', branch='artifacts'}
    -- use 'kosayoda/nvim-lightbulb'
    -- use 'weilbith/nvim-code-action-menu' -- Does not work for golang's "fill struct"
    -- use 'jubnzv/virtual-types.nvim' -- OCaml only
    -- use 'liuchengxu/vista.vim'
    -- use 'simrat39/symbols-outline.nvim'

    -- UI
    use 'RishabhRD/popfix'
    -- use 'RishabhRD/nvim-lsputils'
    use 'hood/popui.nvim'
    use 'rcarriga/nvim-notify'
    use 'j-hui/fidget.nvim'
    use 'tpope/vim-fugitive'

    -- TS
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/playground'
    -- use 'JoosepAlviste/nvim-ts-context-commentstring'
    -- use 'lewis6991/nvim-treesitter-context'
    use 'p00f/nvim-ts-rainbow'

    -- Indentation and editing
    -- use 'Yggdroot/indentLine'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'Vimjas/vim-python-pep8-indent' -- TreeSitter is not enough
    use 'airblade/vim-gitgutter'
    -- use 'ervandew/supertab' -- nvim-cmp handles this
    use 'yuezk/vim-js'
    use 'MaxMEllon/vim-jsx-pretty'
    use 'farmergreg/vim-lastplace'
    -- use 'junegunn/vim-easy-align' -- VimScript
    use 'dhruvasagar/vim-table-mode' -- VimScript

    -- Comments
    use 'tpope/vim-commentary'
    -- use 'preservim/nerdcommenter' -- Does not handle dynamic commentstring

    -- Telescope
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'

    -- Tagbar
    -- requires icons
    -- use 'majutsushi/tagbar'

    -- Syntax
    -- use 'hashivim/vim-terraform'
    -- use 'stephpy/vim-yaml'
    -- use 'othree/html5.vim'
    -- use 'averms/black-nvim'

    -- Status lines
    use 'nvim-lualine/lualine.nvim'
    -- use 'ap/vim-buftabline'
    use 'kyazdani42/nvim-web-devicons'
    -- use 'akinsho/bufferline.nvim'
    use 'romgrk/barbar.nvim'

    -- use 'vimpostor/vim-tpipeline'

    -- SQL completion
    -- use 'vim-scripts/dbext.vim'
end)
-- }}}

-- Local RC {{{
vim.g.localvimrc_persistent = 2
-- }}}
-- Commentary {{{
-- nnoremap('<M-/>', '<cmd>Commentary<CR>j')
nnoremap('<M-/>', '<cmd>Commentary<CR>')
-- vnoremap('<M-/>', 'm`:Commentary<CR>``')
vnoremap('<M-/>', ':Commentary<CR>')
-- inoremap <silent> <M-/> <C-o>:Commentary<CR><C-o><CR>
-- imap('<M-/>', '<cmd>Commentary<CR><C-o>j')
imap('<M-/>', '<cmd>Commentary<CR>')
-- }}}
-- indentLine & blankline {{{
-- vim.g.indent_guides_enable_on_vim_startup = 1
-- vim.g.indent_guides_guide_size = 1

-- vim.g.indentLine_char = '▏'
-- -- vim.g.indentLine_char = ''
-- vim.g.indentLine_first_char = '▏'
-- vim.g.indentLine_concealcursor = 0
-- vim.g.indentLine_conceallevel = 1
-- vim.g.indentLine_color_term = 236
-- vim.g.indentLine_showFirstIndentLevel = 0
-- vim.g.indentLine_fileTypeExclude = { 'text', 'help', 'startify' }
-- vim.g.indentLine_faster = 1 -- TODO: Experimental

-- Blankline
require('indent_blankline').setup {
    char = '▏',
    -- char_list = {'|', '¦', '┆', '┊'},
    -- show_first_indent_level = false,
    show_current_context = true,
    -- show_current_context_start = true,
    filetype_exclude = { 'text', 'help', 'startify' },
}
vim.cmd('au CursorMovedI * IndentBlanklineRefresh')

-- }}}
-- GitGutter {{{
vim.cmd([[
hi GitGutterAdd guifg=#50C650 guibg=#202020
hi GitGutterChange guifg=#C6C600 guibg=#202020
hi GitGutterDelete guifg=#C60050 guibg=#202020
]])
vim.g.gitgutter_realtime = 1
vim.g.gitgutter_eager = 0
vim.g.gitgutter_max_signs = 1000
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
    N = 'N',
    I = 'I',
    R = 'R',
    C = 'C',
    V = 'V',
    T = 'T',
    S = 'S',
    -- N= '',
    -- I= '',
    -- R= '',
    -- C= '',
    -- V= '',
    -- T= '',
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
        if vim.tbl_contains({ "class_definition", "method_definition", "function_definition" }, node:type()) then
            local name_node = node:named_child('name')
            local name = ts_utils.get_node_text(name_node)
            table.insert(parts, 1, '%#' .. ts_node_highlights[node:type()] .. '#' .. ts_node_icons[node:type()] .. ' ' .. table.concat(name, ''))
        end
        node = node:parent()
    end
    return table.concat(parts, ' -> ')
end

local custom_onedark = require 'lualine.themes.onedark'
custom_onedark.inactive.a.bg = '#222222'
custom_onedark.inactive.b.bg = '#222222'
custom_onedark.inactive.c.bg = '#222222'

local lualine_sections = {
    lualine_a = { { 'mode', fmt = function(str) return mode_map[str:sub(1, 1)] end } },
    lualine_b = { { 'filename', fmt = function(str) local cur = vim.api.nvim_win_get_cursor(0); return str .. ':' .. cur[1] .. ':' .. cur[2] end } },
    lualine_c = {},
    -- lualine_c={'tsPath()'},
    lualine_x = { { 'filetype', colored = true }, 'encoding' }, -- %04B
    lualine_y = { 'branch' },
    -- lualine_z={'lspStatus()'},
    lualine_z = {
        { 'diagnostics', color = { bg = '#202020' } }
    },
}

require('lualine').setup {
    options = {
        theme = custom_onedark,
        section_separators = {
            left = '',
            right = ''
        },
        component_separators = {
            left = '|',
            right = '|'
        },
    },
    sections = lualine_sections,
    inactive_sections = lualine_sections,
}
vim.cmd([[
" What? Why did I add this?
" hi lualine_a_inactive guibg=#FF0000
]])
-- }}}
-- Buffer line {{{
-- old
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
-- new
-- require("bufferline").setup{
--     options = {
--         -- numbers = function(x) return x.ordinal end,
--         indicator_icon = ' ',
--         -- left_trunc_marker = '',
--         -- right_trunc_marker = '',
--         separator_style = {'', ''},
--         show_buffer_close_icons = false,
--         tab_size = 1,
--         -- max_name_length = 10,
--         enforce_regular_tabs = false,
--     },
-- }
-- barbar
vim.g.bufferline = {
    animation = false,
    -- closable = false,
    icon_separator_active = ' ',
    icon_separator_inactive = ' ',
    icon_custom_colors = false,
    icon_close_tab = '',
    maximum_padding = 0,
    add_in_buffer_number_order = true,
    -- icons = 'both',
    -- insert_at_end = true,
    -- icon_close_tab_modified = 'X',
}
vim.cmd([[
" hi BufferInactive guifg=#999999 guibg=#202020
" hi link BufferInactiveSign BufferInactive
" hi BufferCurrent guibg=#98C379 guifg=#000000
" hi link BufferCurrentSign BufferCurrent
" hi link BufferCurrentMod BufferCurrent
]])
nnoremap('<S-PageUp>', '<cmd>BufferPrevious<CR>')
nnoremap('<S-PageDown>', '<cmd>:BufferNext<CR>')
inoremap('<S-PageUp>', '<cmd>BufferPrevious<CR>')
inoremap('<S-PageDown>', '<cmd>BufferNext<CR>')
-- }}}
-- Telescope {{{
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
function fzf_multi_select(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = table.getn(picker:get_multi_selection())

    if num_selections > 1 then
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selections = picker:get_multi_selection()
        vim.cmd('bw!')
        for _, entry in ipairs(selections) do
            vim.cmd(string.format("%s %s", ":e!", entry.path))
        end
        vim.cmd('stopinsert')
    else
        actions.file_edit(prompt_bufnr)
    end
end

require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                -- ["<C-j>"]   = actions.move_selection_next,
                -- ["<C-k>"]   = actions.move_selection_previous,
                -- ["<C-q>"]   = actions.smart_send_to_qflist + actions.open_qflist,
                -- ["<ESC>"]   = actions.close,
                ['<ESC>'] = actions.close,
                -- ['<CR>'] = fzf_multi_select, -- disabled because it breaks code actions
            },
        },
    }
}
_G.project_files = function()
    local opts = {} -- define here if you want to define something
    local ok = pcall(require 'telescope.builtin'.git_files, opts)
    if not ok then require 'telescope.builtin'.find_files(opts) end
end
vim.cmd([[
nnoremap <silent> <M-l> :Telescope live_grep<CR>
nnoremap <silent> <M-p> :lua project_files()<CR>
nnoremap <silent> <M-o> :Telescope file_browser<CR>
]])
-- }}}
-- Custom file types {{{
vim.cmd([[
au BufRead level.dat* :set ft=nbted
au FileType nbted :set noet
au BufRead *.jad :set ft=java
]])
-- }}}
-- Lightbulb {{{
_G.lightbulb_config = {
    sign = {
        enabled = false,
    },
    virtual_text = {
        enabled = true,
        text = "  ",
    },
}
vim.cmd([[
" autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb(lightbulb_config)
" hi LightBulbVirtualText guibg=#D7D787 guifg=#222222
]])
-- }}}
-- NERDCommenter {{{
-- vim.cmd([[
-- fu ReinitNERDCommenter()
--     echo 'reinit ' .. v:option_new
-- endf
-- " au OptionSet commentstring :call ReinitNERDCommenter()
-- au OptionSet commentstring :echo 42
-- ]])
-- }}}
-- PopUI {{{
-- Popui (code actions)
vim.ui.select = require "popui.ui-overrider"
-- }}}
-- vim-notify {{{

vim.cmd([[
function! MsgFunc(method, kind, chunks, overwrite) abort
    " echomsg a:method
    let l:parts = []
    let l:title = a:method
    let l:class = 'info'
    if a:kind !=# ''
        let l:title .= ': ' .. a:kind
        if a:kind == 'emsg' || a:kind == 'echoerr' || a:kind == 'lua_error' || a:kind == 'rpc_error'
            let l:class = 'error'
        elseif a:kind == 'search' || a:kind == 'search_count'
            return
        endif
        " echomsg "[AA]" a:kind
    endif
    if !empty(a:chunks)
        for l:pair in a:chunks
            call add(l:parts, l:pair[1])
        endfor
        " echomsg "[BB]" a:chunks
    else
        return
    endif
    " echomsg l:parts
    call luaeval('vim.notify(_A[1], _A[2], {title=_A[3]})', [join(l:parts, " "), l:class, l:title])
endfunction

" set msgfunc=MsgFunc
]])

function MsgFunc(method, kind, chunks, overwrite)
end

local base = require("notify.render.base")

vim.notify = require('notify')
vim.notify.setup({
    -- stages = 'static',
    stages = 'slide',
    timeout = 3000,
    -- render = 'minimal',
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = false })
    end,
    render = function(buf, notification, highlights)
        -- highlights.title
        -- highlights.icon
        -- highlights.border
        -- highlights.body
          -- local left_icon = notif.icon .. " "
        local namespace = base.namespace()
        notification.message[1] = ' ' .. notification.icon .. ' ' .. notification.message[1]
        -- table.insert(notification.message, 0, notification.icon)
        -- print(notification.icon)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, notification.message)
        vim.api.nvim_buf_set_extmark(buf, namespace, 0, 0, {
            hl_group = highlights.icon,
            end_line = #notification.message - 1,
            end_col = #notification.message[#notification.message],
            priority = 50,
        })
        return notification
    end
})
-- }}}
