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

-- Signature help config
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single",
    focusable = false,
}
)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { focusable = false }
)

-- Attach handler
---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-g>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<M-Enter>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<M-Enter>', '<cmd>Telescope lsp_code_actions<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<M-Enter>', '<cmd>CodeActionMenu<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<M-Enter>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<M-d>', '<cmd>Telescope diagnostics bufnr=0<CR>', opts)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', ';', '<cmd>lua vim.diagnostic.goto_prev{float=false}<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '\'', '<cmd>lua vim.diagnostic.goto_next{float=false}<CR>', opts)
    -- if vim.api.nvim_buf_get_option(bufnr, 'filetype') == 'python' then
    --     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<M-r>', '<cmd>%!autopep8 %<CR>', opts)
    -- else
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<M-r>', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
    -- end
    vim.cmd([[
        " autocmd CursorMoved * :lua require('ts_context_commentstring.internal').update_commentstring()
        " autocmd CursorHold * :lua vim.diagnostic.open_float({focusable=false})
        " autocmd CursorHoldI * :lua vim.lsp.buf.hover()
    ]])
    -- require'virtualtypes'.on_attach()

end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
        source = "always", -- Or "if_many"
    },
    underline = true,
    signs = {
        priority = 20,
    },
    -- update_in_insert = true
})

-- Completion via cmp
-- Add additional capabilities supported by nvim-cmp
-- local capabilities = vim.lsp.protocol.make_client_capabilities()

-- disable start
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0)) ---@diagnostic disable-line
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- null-ls
local null_ls = require("null-ls")
null_ls.setup({
    on_attach = on_attach,
    sources = {
        -- require("null-ls").builtins.formatting.stylua,
        -- require("null-ls").builtins.completion.spell,
    },
})
null_ls.register({
    method = null_ls.methods.FORMATTING,
    filetypes = { 'asm_ca65' },
    generator = null_ls.formatter({
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/HELPERS.md
        command = 'nice65',
        -- args = {'-', '-c'},
        args = {'-'},
        to_stdin = true,
        -- from_stderr = true,
        from_stdout = true,
        -- format = 'line',
        -- runtime_condition = function(x) return true end,
        -- check_exit_code = function(code)
        --     return code == 0
        -- end,
        -- on_output = require('null-ls.helpers').diagnostics.from_patterns({
        --     {
        --         pattern = [[(%d+):(.*)]],
        --         groups = { "row", "message" },
        --     },
        -- }),
    }),
})
-- null_ls.register({
--     method = null_ls.methods.FORMATTING,
--     filetypes = { 'asm' },
--     generator = null_ls.formatter({
--         command = 'asmfmt',
--         args = {},
--         to_stdin = true,
--         from_stdout = true,
--     }),
-- })
null_ls.register({
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = { 'gitcommit' },
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

local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require('lspkind')
lspkind.init({
    symbol_map = {
    }
})
vim.cmd([[
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
highlight! link CmpItemKindVariable Identifier
highlight! link CmpItemKindProperty Identifier
highlight! link CmpItemKindInterface Typedef
highlight! link CmpItemKindText Label
highlight! link CmpItemKindFunction Function
highlight! link CmpItemKindMethod Function
highlight! link CmpItemKindClass Keyword
highlight! link CmpItemKindStruct Keyword
highlight! link CmpItemKindConstant String
highlight! link CmpItemKindModule StorageClass
]])

require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup {
    snippet = {
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
        end,
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- ['<C-Space>'] = cmp.mapping.complete({reason = cmp.ContextReason.Manual}),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Esc>'] = cmp.mapping.close(),
        ['<C-Space>'] = function() cmp.complete() end,
        ['<Tab>'] = function(fallback)
            -- https://github.com/hrsh7th/nvim-cmp/issues/174#issuecomment-939262013
            if cmp.visible() then
                cmp.select_next_item()
                -- I don't like snippets...
                -- elseif luasnip.in_snippet() then
                --     -- elseif luasnip.expand_or_jumpable() then
                --     --     -- print('expand_or_jump')
                --     luasnip.expand_or_jump()
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
            else
                fallback()
            end
        end,
        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
        -- ['<C-p>'] = cmp.mapping(function()
        --     luasnip.jump(-1)
        -- end, { 'c', 'i', 'n', 's' }),
        -- ['<C-n>'] = cmp.mapping(function()
        --     luasnip.jump(1)
        -- end, { 'c', 'i', 'n', 's' }),
    },
    sources = cmp.config.sources({
        -- { name = 'luasnip' }, -- Not used to snippets yet...
        { name = 'nvim_lsp' },
        -- { name = 'snippy' },
        { name = 'path' },
    }, {
        { name = 'buffer' },
    }),
    completion = {
        autocomplete = false,
    },
    experimental = {
        ghost_text = true,
        -- native_menu = true,
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
        })
    },
}

-- Do not hijack arrow keys for completion popup
-- inoremap('<up>', "pumvisible() ? '<c-e><up>' : '<up>'", true)
-- inoremap('<down>', "pumvisible() ? '<c-e><down>' : '<down>'", true)

local lspconfig = require('lspconfig')
lspconfig.pylsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
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
                    -- enabled = true,
                    enabled = false,
                    args = { '/usr/bin/pylint' },
                    executable = 'python'
                },
                flake8 = {
                    enabled = false,
                    executable = 'flake8'
                },
                pycodestyle = {
                    enabled = true,
                },
                pydocstyle = {
                    enabled = false,
                },
                pyflakes = {
                    enabled = false
                },
                black = {
                    enabled = true
                },
                autopep8 = {
                    enabled = false
                },
            }
        }
    }
}
lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    typeCheckingMode = 'off',
    handlers = {
        ['textDocument/publishDiagnostics'] = function() end,
    },
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
-- lspconfig.clangd.setup{
--     on_attach=on_attach,
--     capabilities=capabilities,
-- }
-- lspconfig.ccls.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
-- }
lspconfig.clangd.setup {
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.cmd([[
            " au BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()
            " Map F4 to :ClangdSwitchSourceHeader
            nnoremap <buffer> <F4> :ClangdSwitchSourceHeader<CR>
        ]])
    end,
    capabilities = capabilities,
    -- cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    -- init_options = {
    --     clangdFileStatus = true,
    --     usePlaceholders = true,
    --     completeUnimported = true,
    --     semanticHighlighting = true,
    -- },
    -- handlers = {
    --     ['textDocument/publishDiagnostics'] = function() end,
    -- },
    cmd = { 'clangd', '--offset-encoding=utf-16', '--log=verbose' },
}
lspconfig.gopls.setup {
    cmd = { 'gopls', '-vv' },
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.cmd([[
            " au BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()
            au BufWritePre <buffer> :lua vim.lsp.buf.format()
        ]])
    end,
    capabilities = capabilities,
}
lspconfig.golangci_lint_ls.setup {
    init_options = {
        -- gofumpt? (preset: format, autofix is true)
        command = { "golangci-lint", "run", "-E", "wsl,wrapcheck,nlreturn,revive,noctx,gocritic,errorlint,forcetypeassert", "-p", "bugs", "-D", "gosec,errchkjson", "--out-format", "json" }
        -- command = { "golangci-lint", "run", "--enable-all", "--out-format", "json" }
    }
}
lspconfig.vimls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
lspconfig.cssls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
lspconfig.eslint.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    -- settings = {
    --     format = {
    --         enable = false,
    --     },
    -- workingDirectories = { {
    --     mode = "auto"
    -- } }
    -- },
    -- editor={defaultFormatter='adbaeumer.avscode-eslint'}
}
lspconfig.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
lspconfig.html.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
lspconfig.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
-- TODO: Replace with lua_ls
-- lspconfig.sumneko_lua.setup {
--     -- https://github.com/sumneko/lua-language-server/wiki/Setting
--     on_attach = on_attach,
--     capabilities = capabilities,
--     cmd = { '/home/anderson/src/lua-language-server/bin/lua-language-server', '--preview', '--logpath', '/tmp/lua-language-server/' },
--     settings = {
--         Lua = {
--             runtime = {
--                 version = 'LuaJIT',
--             },
--             diagnostics = {
--                 globals = { "vim" },
--             },
--         },
--     },
-- }
lspconfig.terraformls.setup { on_attach = on_attach }
-- lspconfig.terraform_lsp.setup { on_attach = on_attach }
-- lspconfig['null-ls'].setup{
--     on_attach=on_attach
-- }
lspconfig.graphql.setup { on_attach = on_attach }
lspconfig.yamlls.setup { on_attach = on_attach }
-- local lsp_status = require('lsp-status')
-- lsp_status.register_progress()
lspconfig.zls.setup {}
lspconfig.gdscript.setup {}
lspconfig.lemminx.setup {
    on_attach = on_attach
}
lspconfig.rust_analyzer.setup{
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = true;
      }
    }
  }
}
lspconfig.asm_lsp.setup{}
lspconfig.pkgbuild_language_server.setup{}

require 'fidget'.setup()
