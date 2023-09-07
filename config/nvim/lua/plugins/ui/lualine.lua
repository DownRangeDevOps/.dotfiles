-- ----------------------------------------------
-- LuaLine (https://github.com/nvim-lualine/lualine.nvim)
-- :help lualine.txt
-- ----------------------------------------------
return {
    "nvim-lualine/lualine.nvim",
    name = "lualine",
    lazy = false,
    config = true,
    opts = {
        options = {
            icons_enabled = false,
            theme = "catppuccin",
            component_separators = "⁞",
            section_separators = { left = "", right = ""},
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
        },
    },
}
