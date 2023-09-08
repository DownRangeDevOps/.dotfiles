-- ----------------------------------------------
-- Telescope: Fuzzy Finder (https://github.com/nvim-telescope/telescope.nvim)
-- :help telescope.nvim
-- ----------------------------------------------
return {
    "nvim-telescope/telescope.nvim",
    name = "nvim-telescope",
    branch = "0.1.x",
    lazy = false,
    config = true,
    dependencies = {
        { "nvim-lua/plenary.nvim", name = "nvim-plenary", lazy = false }, -- https://github.com/nvim-lua/plenary.nvim
        { "nvim-tree/nvim-web-devicons", name = "nvim-devicons", lazy = false }, -- https://github.com/nvim-tree/nvim-web-devicons
        { "nvim-telescope/telescope-fzf-native.nvim", name = "nvim-telescope-fzf-native", lazy = false, build = "make", } -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
    },
    opts = {
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
            harpoon = {},
        },
        defaults = {
            mappings = {
                i = {
                    ["<C-u>"] = false,
                    ["<C-d>"] = false,
                },
            },
        },
    },
}
