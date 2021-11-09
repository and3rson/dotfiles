vim.cmd([[
hi LspDiagnosticsDefaultError ctermfg=9 ctermbg=235
hi LspDiagnosticsDefaultWarning ctermfg=130 ctermbg=235
hi LspDiagnosticsDefaultInformation ctermfg=38 ctermbg=235
hi LspDiagnosticsDefaultHint ctermfg=156 ctermbg=235
]])

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
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
-- require'lspconfig'.pyright.setup{
--     on_attach=on_attach
-- }
kind_icons = {
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
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = {
--         source = "always",    -- Or "if_many"
--     }
-- })

require'lspconfig'.pylsp.setup{
    on_attach=on_attach,
    settings = {
        pylsp = {
            plugins = {
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
require'lspconfig'.ccls.setup{
    on_attach=on_attach
}
require'lspconfig'.gopls.setup{
    on_attach=on_attach
}
require'lspconfig'.vimls.setup{
    on_attach=on_attach
}
require'lspconfig'.cssls.setup{
    on_attach=on_attach
}
require'lspconfig'.eslint.setup{
    on_attach=on_attach
}
require'lspconfig'.html.setup{
    on_attach=on_attach
}
require'lspconfig'.jsonls.setup{
    on_attach=on_attach
}
require("null-ls").config({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.completion.spell,
    },
})
require('lspconfig')['null-ls'].setup{
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
