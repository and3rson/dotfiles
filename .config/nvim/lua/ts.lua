require 'nvim-treesitter.configs'.setup {
    -- context_commentstring = {
    --   enable = false,
    --   enable_autocmd = true,
    -- },
    incremental_selection = {
        enable = false,
    },
    -- indent = {
    -- enable = false,
    -- disable = { "lua" }
    -- },
    highlight = {
        enable = true,
        custom_captures = {
            -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
            ["foo.bar"] = "Identifier",
        },
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
        -- additional_vim_regex_highlighting = { "gdresource" },
    },
    -- ensure_installed = 'maintained',
    ensure_installed = { 'c', 'python', 'cpp', 'css', 'go', 'html', 'lua', 'query', 'vim', 'zig', 'graphql', 'json', 'yaml', 'javascript', 'hcl' },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = 3000, -- Do not enable for files with more than n lines, int
        colors = {
            "#a89984",
            "#b16286",
            "#d79921",
            "#689d6a",
            "#d65d0e",
            "#458588",
            -- "#cc241d",
        }, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    }
}

-- require 'treesitter-context'.setup {
--     enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
--     throttle = true, -- Throttles plugin updates (may improve performance)
--     max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
--     patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
--         -- For all filetypes
--         -- Note that setting an entry here replaces all other patterns for this entry.
--         -- By setting the 'default' entry below, you can control which nodes you want to
--         -- appear in the context window.
--         default = {
--             'class',
--             'function',
--             'method',
--             -- 'for', -- These won't appear in the context
--             -- 'while',
--             -- 'if',
--             -- 'switch',
--             -- 'case',
--         },
--         -- Example for a specific filetype.
--         -- If a pattern is missing, *open a PR* so everyone can benefit.
--         --   rust = {
--         --       'impl_item',
--         --   },
--     },
--     exact_patterns = {
--         -- Example for a specific filetype with Lua patterns
--         -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
--         -- exactly match "impl_item" only)
--         -- rust = true,
--     }
-- }
