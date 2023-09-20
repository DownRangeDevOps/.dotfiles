-- ----------------------------------------------
-- LuaLine (https://github.com/nvim-lualine/lualine.nvim)
-- :help lualine.txt
-- ----------------------------------------------
return {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    config = true,
    opts = {
        options = {
            icons_enabled = false,
            theme = "catppuccin",
            component_separators = "┆",
            section_separators = { left = "", right = ""},
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
        },
    },
}
-- local theme = require("catppuccin.palettes").mocha
-- local conditions = {
--     buffer_not_empty = function()
--         return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
--     end,
--     hide_in_width = function()
--         return vim.fn.winwidth(0) > 80
--     end,
--     check_git_workspace = function()
--         local filepath = vim.fn.expand("%:p:h")
--         local gitdir = vim.fn.finddir(".git", filepath .. ";")
--         return gitdir and #gitdir > 0 and #gitdir < #filepath
--     end,
-- }
--
-- return {
--     "nvim-lualine/lualine.nvim",
--     lazy = false,
--     config = true,
--     options = {
--         icons_enabled = true,
--         theme = "catppuccin",
--         component_separators = { left = "⁞", right = "⁞"},
--         section_separators = { left = "", right = ""},
--         disabled_filetypes = {
--             statusline = {},
--             winbar = {},
--         },
--         ignore_focus = {},
--         always_divide_middle = true,
--         globalstatus = false,
--         refresh = {
--             statusline = 1000,
--             tabline = 1000,
--             winbar = 1000,
--         }
--     },
--     sections = {
--         lualine_a = {
--             -- mode component
--             function()
--                 return ""
--             end,
--             color = function()
--                 -- set mode colors
--                 local mode_color = {
--                 n = theme.blue,
--                 i = theme.green,
--                 v = theme.mauve,
--                 [""] = theme.text,
--                 V = theme.mauve,
--                 c = theme.peach,
--                 no = theme.blue,
--                 s = theme.mauve,
--                 S = theme.mauve,
--                 [""] = theme.text,
--                 ic = theme.green,
--                 R = theme.mauve,
--                 Rv = theme.mauve,
--                 cv = theme.mauve,
--                 ce = theme.mauve,
--                 r = theme.mauve,
--                 rm = theme.mauve,
--                 ["r?"] = theme.mauve,
--                 ["!"] = theme.mauve,
--                 t = theme.blue,
--                 }
--                 return { fg = mode_color[vim.fn.mode()] }
--             end,
--             padding = { right = 1 },
--   },
--         lualine_b = { " branch" end, "diff", "diagnostics" },
--         lualine_c = { "filename", cond = conditions.buffer_not_empty },
--         lualine_x = {"encoding", "fileformat", "filetype"},
--         lualine_y = {"progress"},
--         lualine_z = {"location"}
--     },
--     inactive_sections = {
--         lualine_a = {},
--         lualine_b = {},
--         lualine_c = {"filename"},
--         lualine_x = {"location"},
--         lualine_y = {},
--         lualine_z = {}
--     },
--     tabline = {},
--     winbar = {},
--     inactive_winbar = {},
--     extensions = {}
-- }
