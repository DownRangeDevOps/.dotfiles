-- ----------------------------------------------
-- Neogit (https://github.com/NeogitOrg/neogit)
-- :help neogit.txt
-- ----------------------------------------------
return {
    "NeogitOrg/neogit",
    dependencies = {
        { "nvim-lua/plenary.nvim", branch = "master" }, -- required
        { "nvim-telescope/telescope.nvim", },           -- optional
        { "sindrets/diffview.nvim", },                  -- optional
        -- { "ibhagwan/fzf-lua", },                     -- optional
    },
    config = true
}
