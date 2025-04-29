-- ----------------------------------------------
-- gitsigns (https://github.com/lewis6991/gitsigns.nvim)
-- :help gitsigns.txt
-- ----------------------------------------------
return {
    "lewis6991/gitsigns.nvim",
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
        on_attach = function(bufnr)
            local gs = require("gitsigns")

            vim.keymap.set("n", "<leader>p", function() gs.nav_hunk("last", { preview = true, target = "all"}) end, { buffer = bufnr, desc = "go prev hunk" })
            vim.keymap.set("n", "<leader>n", function() gs.nav_hunk("next", { preview = true, target = "all"}) end, { buffer = bufnr, desc = "go next hunk" })
            vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "preview hunk" })
            vim.keymap.set("n", "<leader>hu", gs.reset_hunk, { buffer = bufnr, desc = "reset hunk" })
            vim.keymap.set("n", "<leader>sh", gs.stage_hunk, { buffer = bufnr, desc = "stage hunk" })
            vim.keymap.set("n", "<leader>sb", gs.stage_buffer, { buffer = bufnr, desc = "stage hunk" })
            vim.keymap.set("n", "<leader>rh", gs.reset_hunk, { buffer = bufnr, desc = "reset hunk" })
            vim.keymap.set("n", "<leader>rb", gs.reset_buffer, { buffer = bufnr, desc = "reset hunk" })
        end
    },
}
