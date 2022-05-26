_G.nnoremap = function(map, value, expr)
    vim.api.nvim_set_keymap('n', map, value, { noremap = true, silent = true, expr = expr })
end
_G.vnoremap = function(map, value, expr)
    vim.api.nvim_set_keymap('v', map, value, { noremap = true, silent = true, expr = expr })
end
_G.inoremap = function(map, value, expr)
    vim.api.nvim_set_keymap('i', map, value, { noremap = true, silent = true, expr = expr })
end
_G.imap = function(map, value, expr)
    vim.api.nvim_set_keymap('i', map, value, { noremap = false, silent = true, expr = expr })
end
_G.map = function(map, value, expr)
    vim.api.nvim_set_keymap('', map, value, { noremap = false, silent = true, expr = expr })
end

-- https://github.com/nanotee/nvim-lua-guide#vimapinvim_replace_termcodes
function _G.t(str)
    -- Adjust boolean arguments as needed
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
