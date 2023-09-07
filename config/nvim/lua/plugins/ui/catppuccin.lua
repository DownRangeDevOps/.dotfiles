-- ----------------------------------------------
-- Catppuccin colorscheme: setup (https://github.com/catppuccin/nvim/tree/main)
-- :help catppuccin.txt
-- ----------------------------------------------
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    dim_inactive = { enabled = false },
    highlight_overrides = {
        mocha = function(mocha)
            return {
                -- https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/groups/editor.lua
                CmpBorder = { fg = "#3e4145" },
                ColorColumn = { bg = mocha.base },
                CurSearch = { fg = mocha.base, bg = mocha.green },
                Cursor = { fg = mocha.crust },
                CursorLineNr = { fg = mocha.sapphire },
                Folded = { bg = mocha.surface0 },
                LineNr = { fg = mocha.surface1 },
                MsgArea = { bg = mocha.crust },
                Normal = { bg = mocha.mantle },
                Search = { fg = mocha.base, bg = mocha.sky },
                IndentBlanklineContextChar = { fg = mocha.surface1 },
            }
        end,
    },
    transparent_background = false,
    integrations = {
        cmp = true,
        fidget = true,
        gitsigns = true,
        harpoon = true,
        markdown = true,
        mason = true,
        mini = true,
        neotree = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
        indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
        },
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
            inlay_hints = {
                background = true,
            },
        },
    }
}
