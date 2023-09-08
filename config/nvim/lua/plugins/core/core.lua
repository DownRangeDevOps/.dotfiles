-- ----------------------------------------------
-- Vim user sovereign rights
-- ----------------------------------------------
return {
    { "ThePrimeagen/harpoon",  name = "nvim-harpoon",   lazy = false }, -- Quick-switch files (https://github.com/ThePrimeagen/harpoon)
    { "mbbill/undotree",       name = "nvim-undotree",  lazy = false }, -- Browse undo-tree (https://github.com/mbbill/undotree.git)
    { "nathom/filetype.nvim",  name = "vim-filetype",   lazy = true },  -- Replacement for slow filetype.vim builtin (https://github.com/nathom/filetype.nvim)
    { "tpope/vim-abolish",     name = "vim-abolish",    lazy = true,    event = "InsertEnter,     CmdlineEnter" }, -- Fix typos and advanced case/conjugation sensitive replace (https://github.com/tpope/vim-abolish)
    { "tpope/vim-fugitive",    name = "vim-fugitive",   lazy = false},  -- Git manager (https://github.com/tpope/vim-fugitive)
    { "tpope/vim-obsession",   name = "vim-obsession",  lazy = false }, -- Session mgmt (https://github.com/tpope/vim-obsession)
    { "tpope/vim-repeat",      name = "vim-repeat",     lazy = false }, -- Repeat plugin maps (https://github.com/tpope/vim-repeat)
    { "tpope/vim-sleuth",      name = "vim-sleuth",     lazy = true,    event  = "InsertEnter" }, -- Detect tabstop and shiftwidth automatically (https://github.com/tpope/vim-sleuth)
    { "tpope/vim-surround",    name = "vim-surround",   lazy = false }, -- Surround text (https://github.com/tpope/vim-surround)
    { "tpope/vim-unimpaired",  name = "vim-unimpaired", lazy = false }, -- Navigation pairs like [q (https://github.com/tpope/vim-unimpaired)
    { "windwp/nvim-autopairs", name = "nvim-autopairs", lazy = true,    event  = "InsertEnter",   opts = {} },     -- auto-pairs (https://github.com/windwp/nvim-autopairs)
    { "zhimsel/vim-stay",      name = "vim-stay",       lazy = false }, --  Stay in your lane, vim! (https://github.com/zhimsel/vim-stay)
}
