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
    -- use 'lambdalisue/vim-manpager'
    use 'lewis6991/impatient.nvim'

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
    use { 'j-hui/fidget.nvim', tag = 'legacy' }
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
    -- use 'tpope/vim-commentary'
    use 'numToStr/Comment.nvim'
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
    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-tree/nvim-tree.lua'
    -- use 'akinsho/bufferline.nvim'
    use 'romgrk/barbar.nvim'

    -- use 'vimpostor/vim-tpipeline'

    -- SQL completion
    -- use 'vim-scripts/dbext.vim'

    -- 6502 assembly
    use 'maxbane/vim-asm_ca65'

    -- Z80 assembly
    use 'samsaga2/vim-z80'
    -- Copilot
    use 'github/copilot.vim'
end)
-- }}}

-- Local RC {{{
vim.g.localvimrc_persistent = 2
-- }}}
-- Commentary {{{
-- -- nnoremap('<M-/>', '<cmd>Commentary<CR>j')
-- nnoremap('<M-/>', '<cmd>Commentary<CR>')
-- -- vnoremap('<M-/>', 'm`:Commentary<CR>``')
-- vnoremap('<M-/>', ':Commentary<CR>')
-- -- inoremap <silent> <M-/> <C-o>:Commentary<CR><C-o><CR>
-- -- imap('<M-/>', '<cmd>Commentary<CR><C-o>j')
-- imap('<M-/>', '<cmd>Commentary<CR>')
-- require('Comment').setup({mappings=false})
require('Comment').setup({
    toggler = {
        line = '<M-/>',
    },
    opleader = {
        line = '<M-/>'
    },
})
-- api = require('Comment.api')
-- vim.keymap.set('n', '<M-/>', api.toggle.linewise.current)
-- vim.keymap.set('v', '<M-/>', api.toggle.linewise.current)
-- vim.keymap.set('v', '<M-/>', function() api.toggle.linewise(vim.fn.visualmode()) end)
-- vim.api.nvim_set_keymap('n', '<M-/>', '<Plug>(comment_toggle_linewise)<CR>', {silent=true, noremap=false})
-- vim.api.nvim_set_keymap('v', '<M-/>', '<Plug>(comment_toggle_blockwise)<CR>', {silent=true, noremap=false})
-- vim.api.nvim_set_keymap('i', '<M-/>', '<C-o><Plug>(comment_toggle_linewise)<CR>', {silent=true, noremap=false})
local ft = require('Comment.ft')
ft.set('z80', '; %s')
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

-- local custom_onedark = require 'lualine.themes.onedark'
-- custom_onedark.inactive.a.bg = '#222222'
-- custom_onedark.inactive.b.bg = '#222222'
-- custom_onedark.inactive.c.bg = '#222222'
local custom_sonokai = require 'lualine.themes.sonokai'


local lualine_sections = {
    lualine_a = { { 'mode', fmt = function(str) return mode_map[str:sub(1, 1)] end } },
    lualine_b = { { 'filename', fmt = function(str) local cur = vim.api.nvim_win_get_cursor(0); return str .. ':' .. cur[1] .. ':' .. cur[2] end } },
    lualine_c = {},
    -- lualine_c={'tsPath()'},
    lualine_x = { { 'filetype', colored = true }, 'encoding' }, -- %04B
    lualine_y = { 'branch' },
    -- lualine_z={'lspStatus()'},
    lualine_z = {
        { 'diagnostics', color = { bg = '#404040' }, diagnostics_color = {
            -- Same values as the general color option can be used here.
            error = 'ErrorFloat', -- Changes diagnostics' error color.
            warn  = 'WarningFloat', -- Changes diagnostics' warn color.
            info  = 'InfoFloat', -- Changes diagnostics' info color.
            hint  = 'HintFloat', -- Changes diagnostics' hint color.
        },
        }
        -- { 'diagnostics' }
    },
}

require('lualine').setup {
    options = {
        theme = custom_sonokai,
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
-- require('bufferline').setup{
--     animation = false,
--     -- closable = false,
--     -- icons = {
--     --     inactive = {
--     --         separator = ' '
--     --     },
--     --     separator = {
--     --         left = ' '
--     --     },
--     -- },
--     -- icon_separator_active = ' ',
--     -- icon_separator_inactive = ' ',
--     icon_custom_colors = false,
--     -- icon_close_tab = '',
--     maximum_padding = 0,
--     add_in_buffer_number_order = true,
--     -- icons = 'both',
--     -- insert_at_end = true,
--     -- icon_close_tab_modified = 'X',
-- }
require('barbar').setup({
    icons = {
        button = false,
    }
})
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
" nnoremap <silent> <M-p> :Telescope find_files<CR>
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

-- vim.notify = require('notify')
-- vim.notify.setup({
--     -- stages = 'static',
--     stages = 'slide',
--     timeout = 3000,
--     -- render = 'minimal',
--     on_open = function(win)
--         vim.api.nvim_win_set_config(win, { focusable = false })
--     end,
--     render = function(buf, notification, highlights)
--         -- highlights.title
--         -- highlights.icon
--         -- highlights.border
--         -- highlights.body
--         -- local left_icon = notif.icon .. " "
--         local namespace = base.namespace()
--         notification.message[1] = ' ' .. notification.icon .. ' ' .. notification.message[1]
--         -- table.insert(notification.message, 0, notification.icon)
--         -- print(notification.icon)
--         vim.api.nvim_buf_set_lines(buf, 0, -1, false, notification.message)
--         vim.api.nvim_buf_set_extmark(buf, namespace, 0, 0, {
--             hl_group = highlights.icon,
--             end_line = #notification.message - 1,
--             end_col = #notification.message[#notification.message],
--             priority = 50,
--         })
--         return notification
--     end
-- })
-- }}}
-- {{{ nvim-tree
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
    remove_keymaps = { '<Tab>', '-', 'f' },
    update_focused_file = {
        enable = true,
        -- update_root = true,
    },
    renderer = {
        -- highlight_opened_files = 'all',
        icons = {
            git_placement = 'signcolumn',
            show = {
                folder = false,
            },
        },
        indent_width = 2,
        indent_markers = {
            enable = true,
            icons = {
                item = '├',
            },
        },
    },
    hijack_cursor = true,
    on_attach = function()
      local api = require('nvim-tree.api')

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end


      -- Default mappings. Feel free to modify or remove as you wish.
      --
      -- BEGIN_DEFAULT_ON_ATTACH
      vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
      vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
      vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
      vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
      vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
      vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
      vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
      vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
      vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
      vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
      vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
      vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
      vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
      vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
      vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
      vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
      vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
      vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
      vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
      vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
      vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
      vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
      vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
      vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
      vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
      vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
      vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
      vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
      vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
      vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
      vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
      vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
      vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
      vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
      vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
      vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
      vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
      vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
      vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
      vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
      vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
      vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
      vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
      vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
      vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
      vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
      vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
      vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
      vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
      vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
      vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
      vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
      -- END_DEFAULT_ON_ATTACH


      -- Mappings removed via:
      --   remove_keymaps
      --   OR
      --   view.mappings.list..action = ""
      --
      -- The dummy set before del is done for safety, in case a default mapping does not exist.
      --
      -- You might tidy things by removing these along with their default mapping.
      vim.keymap.set('n', '<Tab>', '', { buffer = bufnr })
      vim.keymap.del('n', '<Tab>', { buffer = bufnr })
      vim.keymap.set('n', '-', '', { buffer = bufnr })
      vim.keymap.del('n', '-', { buffer = bufnr })
      vim.keymap.set('n', 'f', '', { buffer = bufnr })
      vim.keymap.del('n', 'f', { buffer = bufnr })


      -- Mappings migrated from view.mappings.list
      --
      -- You will need to insert "your code goes here" for any mappings with a custom action_cb
      vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))


    end
})

nnoremap('<F2>', '<cmd>NvimTreeToggle<CR>')
nnoremap('f', '<cmd>NvimTreeToggle<CR>')

-- vim.cmd('autocmd BufEnter * hi! link NvimTreeFolderIcon Blue')
-- vim.cmd('autocmd BufEnter * hi! NvimTreeFolderName guifg=' .. vim.fn.synIDattr(vim.fn.hlID('Blue'), 'fg') .. ' gui=bold')
vim.cmd('autocmd BufEnter * hi! NvimTreeFolderIcon guifg=#87AFFF')
vim.cmd('autocmd BufEnter * hi! NvimTreeFolderName guifg=#87AFFF gui=bold')

vim.cmd('autocmd BufEnter * hi! link NvimTreeOpenedFolderName NvimTreeFolderName')
vim.cmd('autocmd BufEnter * hi! link NvimTreeEmptyFolderName NvimTreeFolderName')
-- vim.cmd('autocmd VimEnter * asd')
-- vim.cmd('hi! NvimTreeFolderIcon guifg=#FF0000')
-- }}}
-- Copilot {{{
vim.cmd([[
imap <silent><script><expr> <C-c> copilot#Accept("\<CR>")
imap <silent><script><expr> <C-n> copilot#Next()
let g:copilot_no_tab_map = v:true
]])
-- }}}
