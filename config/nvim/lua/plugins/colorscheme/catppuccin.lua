-- ----------------------------------------------
-- Catppuccin colorscheme: setup (https://github.com/catppuccin/nvim/tree/main)
-- :help catppuccin.txt
-- ----------------------------------------------
return {
    "catppuccin/nvim",
    name = "catppuccin", -- required because of /nvim
    priority = 9999,
    lazy = false,
    opts = {
        transparent_background = false,
        dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.15,
        },
        highlight_overrides = {
            mocha = function(mocha)
                return {
                    -- https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/groups/editor.lua
                    --
                    -- mocha {
                    --     rosewater = "#f5e0dc",  text     = "#cdd6f4",
                    --     flamingo  = "#f2cdcd",  subtext1 = "#bac2de",
                    --     pink      = "#f5c2e7",  subtext0 = "#a6adc8",
                    --     mauve     = "#cba6f7",  overlay2 = "#9399b2",
                    --     red       = "#f38ba8",  overlay1 = "#7f849c",
                    --     maroon    = "#eba0ac",  overlay0 = "#6c7086",
                    --     peach     = "#fab387",  surface2 = "#585b70",
                    --     yellow    = "#f9e2af",  surface1 = "#45475a",
                    --     green     = "#a6e3a1",  surface0 = "#313244",
                    --     teal      = "#94e2d5",  base     = "#1e1e2e",
                    --     sky       = "#89dceb",  mantle   = "#181825",
                    --     sapphire  = "#74c7ec",  crust    = "#11111b",
                    --     blue      = "#89b4fa", lavender = "#b4befe",
                    -- }

                    CmpBorder = { fg = "#3e4145" },
                    ColorColumn = { bg = mocha.base },
                    CurSearch = { fg = mocha.crust, bg = mocha.green },
                    Cursor = { fg = mocha.crust, bg = mocha.sapphire },
                    lCursor = { fg = mocha.crust, bg = mocha.sapphire },
                    CursorLineNr = { fg = mocha.sapphire },
                    LineNr = { fg = mocha.surface1 },
                    MsgArea = { bg = mocha.crust },
                    Normal = { bg = mocha.mantle },
                    Search = { fg = mocha.crust, bg = mocha.overlay2 },

                    -- :help listcars
                    NonText = { fg = mocha.surface1 },
                    Whitespace = { fg = mocha.surface1 },

                    -- :help indent-blankline-highlights
                    IblIndent = { fg = mocha.surface0 },
                    IblScope = { fg = mocha.surface2 },

                    -- Folds
                    -- :help nvim-ufo
                    Folded = {fg = mocha.text, bg = mocha.base },
                    UfoFoldedBg = { bg = mocha.base },
                    UfoFoldedEllipsis = { fg = mocha.blue, bg = mocha.base },

                    -- Diagnostics
                    DiagnosticUnderlineError = { style = { "undercurl" } },
                    DiagnosticUnderlineHint = { style = { "undercurl" } },
                    DiagnosticUnderlineInfo = { style = { "undercurl" } },
                    DiagnosticUnderlineWarn = { style = { "undercurl" } },

                    -- Neotree
                    NeoTreeSymbolicLinkTarget = { fg = mocha.teal },
                }
            end,
        },
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
            lsp_trouble = true,
            which_key = true,
            indent_blankline = { enabled = true, colored_indent_levels = false },
            native_lsp = {
                enabled = true,
                inlay_hints = { background = true },
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
            },
        }
    }
}
