-- ----------------------------------------------
-- Indentation guides (https://github.com/lukas-reineke/indent-blankline.nvim)
-- :help indent_blankline.txt
-- ----------------------------------------------
return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    lazy = false,
    opts = {
        indent = {
            char = "┊",
            smart_indent_cap = true,
        },
        scope = {
            show_start = false,
            show_end = false,
        },

        -- context_char = "┊", -- `context_char` and `context_char_blankline` options are removed. Use `context_char` only.
        -- disable_with_nolist = true,
        -- indent_level = 6,
        -- show_current_context = true,
        -- show_current_context_start = false, -- `show_current_context_start_on_current_line` is removed in version 3.
        -- max_indent_increase = 1,
        -- enabled = true, -- This option might not be necessary if the plugin enables itself by default.
        -- -- `show_end_of_line`, `show_first_indent_level`, `show_trailing_blankline_indent`, `strict_tabs` options are removed or changed. Check if alternatives exist in version 3.
        -- space_char = " ", -- This option might have been removed or changed.
        -- -- `viewport_buffer` is removed. Consider alternatives for performance tuning if necessary.

        -- Exclusion settings remain largely the same but verify for any new additions or removals.
        exclude = {
            buftypes = {
                "nofile",
                "prompt",
                "quickfix",
                "terminal",
            },
            filetypes = {
                "",
                "TelescopePrompt",
                "TelescopeResults",
                "checkhealth",
                "gitcommit",
                "help",
                "lspinfo",
                "man",
                "neo-tree",
                "packer",
                "qf",
            }
        }
    }
}
