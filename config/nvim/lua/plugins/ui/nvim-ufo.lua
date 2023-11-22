-- ----------------------------------------------
-- nvim-ufo folds (https://github.com/kevinhwang91/nvim-ufo)
-- :help nvim-ufo
-- ----------------------------------------------
return {
    "kevinhwang91/nvim-ufo",
    lazy = false,
    enabled = true,
    config = true,
    -- init = vim.cmd("UfoEnable"),
    opts = {
        provider_selector = function() return { "treesitter", "indent" } end,
        close_fold_kinds = { "imports", "comments" },
    },
    dependencies = {
        { "kevinhwang91/promise-async", name = "nvim-promise-async", lazy = true }
    }
}
