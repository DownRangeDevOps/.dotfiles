-- ----------------------------------------------
-- Telescope: Fuzzy Finder (https://github.com/nvim-telescope/telescope.nvim)
-- :help telescope.nvim
-- ----------------------------------------------
return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    lazy = false,
    config = true,
    dependencies = {
        { "nvim-lua/plenary.nvim", lazy = false }, -- https://github.com/nvim-lua/plenary.nvim
        { "nvim-tree/nvim-web-devicons", lazy = false }, -- https://github.com/nvim-tree/nvim-web-devicons
        { "nvim-telescope/telescope-fzf-native.nvim", lazy = false, build = "make", } -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
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
            history = {},
            mappings = {},
            vimgrep_arguments = {
                vim.env.HOMEBREW_PREFIX .. "/bin/rg",
                -- required
                "--color=never",
                "--no-heading",
                "--no-ignore",
                "--line-number",
                "--column",
                "--with-filename",
                -- optional
                "--smart-case",
                "--hidden",
                "--no-config",
                "--glob=!.git/",
                "--glob=!**/.terraform/",
            }
        },
    },
}
