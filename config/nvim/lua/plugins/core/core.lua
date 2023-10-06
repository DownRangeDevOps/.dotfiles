-- ----------------------------------------------
-- Vim user sovereign rights
-- ----------------------------------------------
return {
    { "ThePrimeagen/harpoon",  lazy = false },    -- Quick-switch files (https://github.com/ThePrimeagen/harpoon)
    { "mbbill/undotree",       lazy = false },    -- Browse undo-tree (https://github.com/mbbill/undotree.git)
    { "tpope/vim-fugitive",    lazy = false},     -- Git manager (https://github.com/tpope/vim-fugitive)
    { "tpope/vim-obsession",   lazy = false },    -- Session mgmt (https://github.com/tpope/vim-obsession)
    { "tpope/vim-repeat",      lazy = false },    -- Repeat plugin maps (https://github.com/tpope/vim-repeat)
    { "tpope/vim-surround",    lazy = false },    -- Surround text (https://github.com/tpope/vim-surround)
    { "tpope/vim-unimpaired",  lazy = false },    -- Navigation pairs like [q (https://github.com/tpope/vim-unimpaired)

    -- Fix typos and advanced case/conjugation sensitive replace (https://github.com/tpope/vim-abolish)
    {
        "tpope/vim-abolish",
        lazy = true,
        event = "InsertEnter, CmdlineEnter",
    },

    -- Detect tabstop and shiftwidth automatically (https://github.com/tpope/vim-sleuth)
    {
        "tpope/vim-sleuth",
        lazy = true,
        event  = "InsertEnter",
    },

    -- auto-pairs (https://github.com/windwp/nvim-autopairs)
    {
        "windwp/nvim-autopairs",
        lazy = true,
        event  = "InsertEnter",
        opts = {},
    },
}
