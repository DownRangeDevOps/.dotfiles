-- ----------------------------------------------
-- Diffview (https://github.com/sindrets/diffview.nvim#usage)
-- :help diffview.nvim
-- ----------------------------------------------
return {
    "sindrets/diffview.nvim",
    name = "diffview",
    lazy = true,
    cmd = {
        "DiffviewOpen",
        "DiffviewTogglefiles",
        "DiffviewFileHistory"
    }
}
