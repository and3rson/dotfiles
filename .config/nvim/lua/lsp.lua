vim.cmd([[
hi LspDiagnosticsDefaultError ctermfg=9 ctermbg=235
hi LspDiagnosticsDefaultWarning ctermfg=130 ctermbg=235
hi LspDiagnosticsDefaultInformation ctermfg=38 ctermbg=235
hi LspDiagnosticsDefaultHint ctermfg=156 ctermbg=235

hi DiagnosticSignError guifg=red guibg=#202020
hi DiagnosticSignWarn guifg=orange guibg=#202020
hi DiagnosticSignInfo guifg=lightblue guibg=#202020
hi DiagnosticSignHint guifg=lightgrey guibg=#202020
]])

local on_attach = function(client, bufnr)
    -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
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
local kind_icons = {
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
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
end

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = {
--         source = "always",    -- Or "if_many"
--     }
-- })
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(a, data, params, client_id, b, config)
    -- TODO: This is a hack
    if data ~= nil and data.diagnostics ~= nil and table.getn(data.diagnostics) > 0 then ---@diagnostic disable-line
        if data.diagnostics[1].source == 'Pyright' then
            return
            -- Ignore pyright
        end
    end

    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
            source = "always",    -- Or "if_many"
        }
    })(a, data, params, client_id, b, config)
    -- print(vim.inspect(params))
end

-- Completion via cmp
-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0)) ---@diagnostic disable-line
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require 'cmp'
local luasnip = require 'luasnip'
cmp.setup {
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
            end,
    },
    mapping = {
        -- ['<Up>'] = function(fallback)
        --     fallback()
        -- end,
        -- ['<Down>'] = function(fallback)
        --     fallback()
        -- end,
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = function(fallback)
            -- https://github.com/hrsh7th/nvim-cmp/issues/174#issuecomment-939262013
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
                -- cmp.complete()
				-- vim.fn.feedkeys(t("<Plug>(vsnip-expand-or-jump)"), "")
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
			elseif luasnip.jumpable(-1) == 1 then
                luasnip.jump(-1)
                -- cmp.complete()
				-- vim.fn.feedkeys(t("<Plug>(vsnip-jump-prev)"), "")
            else
                fallback()
            end
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' },
    }),
    completion = {
        autocomplete = false,
    },
}

-- Do not hijack arrow keys for completion popup

inoremap('<up>', "pumvisible() ? '<c-e><up>' : '<up>'", true)
inoremap('<down>', "pumvisible() ? '<c-e><down>' : '<down>'", true)

local lspconfig = require('lspconfig')
lspconfig.pylsp.setup{
    on_attach=on_attach,
    capabilities=capabilities,
    settings = {
        pylsp = {
            plugins = {
                jedi_completion = {
                    enabled = false, -- use pyright
                },
                rope_completion = {
                    enabled = false, -- use pyright
                },
                jedi_definition = {
                    enabled = false,
                },
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
lspconfig.pyright.setup{
    on_attach=on_attach,
    capabilities=capabilities,
    typeCheckingMode = 'off',
    settings = {
        typeCheckingMode = 'off',
        -- reportUnusedVariable = false,
        python = {
            analysis = {
                typeCheckingMode = 'off',
                -- reportUnusedVariable = false,
            },
        },
        pyright = {
            disableDiagnostics = true,
        }
    }
}
lspconfig.ccls.setup{
    on_attach=on_attach,
    capabilities=capabilities,
}
lspconfig.gopls.setup{
    on_attach=on_attach,
    capabilities=capabilities,
}
lspconfig.vimls.setup{
    on_attach=on_attach,
    capabilities=capabilities,
}
lspconfig.cssls.setup{
    on_attach=on_attach,
    capabilities=capabilities,
}
lspconfig.eslint.setup{
    on_attach=on_attach,
    capabilities=capabilities,
}
lspconfig.tsserver.setup{
    on_attach=on_attach,
    capabilities=capabilities,
}
lspconfig.html.setup{
    on_attach=on_attach,
    capabilities=capabilities,
}
lspconfig.jsonls.setup{
    on_attach=on_attach,
    capabilities=capabilities,
}
lspconfig.sumneko_lua.setup{
    -- https://github.com/sumneko/lua-language-server/wiki/Setting
    on_attach=on_attach,
    capabilities=capabilities,
    cmd={'lua-language-server'},
    settings={
        Lua={
            runtime={
                version='LuaJIT',
            },
            diagnostics={
                globals={"vim"},
            },
        },
    },
}
local null_ls = require("null-ls")
null_ls.config({
    sources = {
        -- require("null-ls").builtins.formatting.stylua,
        -- require("null-ls").builtins.completion.spell,
    },
})
null_ls.register({
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = {'gitcommit'},
    generator = null_ls.generator({
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/HELPERS.md
        command = '/home/anderson/src/gitlint/gitlint.py',
        args = {},
        to_stdin = true,
        from_stderr = true,
        -- from_stdout = true,
        format = 'line',
        -- runtime_condition = function(x) return true end,
        check_exit_code = function(code)
            return code == 0
        end,
        on_output = require('null-ls.helpers').diagnostics.from_patterns({
            {
                pattern = [[(%d+):(.*)]],
                groups = { "row", "message" },
            },
        }),
    }),
})
lspconfig['null-ls'].setup{
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
