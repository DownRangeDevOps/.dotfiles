-- ----------------------------------------------
-- gitsigns (https://github.com/lewis6991/gitsigns.nvim)
-- :help gitsigns.txt
-- ----------------------------------------------
local keymap = require("user-keymap")

return {
    "lewis6991/gitsigns.nvim",
    name = "gitsigns",
    lazy = false,
    config = true,
    opts = {
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            changedelete = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            untracked    = { text = "┆" },
        },
        on_attach = keymap.gitsigns_maps
    },
}
