-- ----------------------------------------------
-- nvim-ufo folds (https://github.com/kevinhwang91/nvim-ufo)
-- :help nvim-ufo
-- ----------------------------------------------
return {
    "kevinhwang91/nvim-ufo",
    name = "nvim-ufo",
    lazy = false,
    enabled = false, -- until I figure out why folds keep auto-closing
    config = true,
    opts = {
        provider_selector = function() return { "treesitter", "indent" } end,
        close_fold_kinds = {}
    },
    dependencies = {
        { "kevinhwang91/promise-async", name = "nvim-promise-async", lazy = true }
    }
}
