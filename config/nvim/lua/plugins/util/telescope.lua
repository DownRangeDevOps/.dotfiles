-- ----------------------------------------------
-- Telescope: Fuzzy Finder (https://github.com/nvim-telescope/telescope.nvim)
-- :help telescope.nvim
-- ----------------------------------------------
return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    lazy = false,
    config = function(_, opts)
        require("telescope").setup(opts)
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("ui-select")
    end,
    -- TODO: How to use harpoon with telescope?
    -- init = function()
    --     local harpoon = require('harpoon')
    --     harpoon:setup({})
    --
    --     -- basic telescope configuration
    --     local conf = require("telescope.config").values
    --     local function toggle_telescope(harpoon_files)
    --         local file_paths = {}
    --         for _, item in ipairs(harpoon_files.items) do
    --             table.insert(file_paths, item.value)
    --         end
    --
    --         require("telescope.pickers").new({}, {
    --             prompt_title = "Harpoon",
    --             finder = require("telescope.finders").new_table({
    --                 results = file_paths,
    --             }),
    --             previewer = conf.file_previewer({}),
    --             sorter = conf.generic_sorter({}),
    --         }):find()
    --     end
    --
    --     vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    --     { desc = "Open harpoon window" })
    -- end,
    dependencies = {
        { "nvim-lua/plenary.nvim", branch = "master", lazy = false }, -- https://github.com/nvim-lua/plenary.nvim
        { "nvim-tree/nvim-web-devicons", lazy = false }, -- https://github.com/nvim-tree/nvim-web-devicons
        { "nvim-telescope/telescope-fzf-native.nvim", lazy = false, build = "make" }, -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
        { "nvim-telescope/telescope-ui-select.nvim", lazy = false }, -- https://github.com/nvim-telescope/telescope-ui-select.nvim#telescope-setup-and-configuration
    },
    opts = {
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
            ["ui-select"] = {
                require("telescope.themes").get_dropdown {
                    -- Custom configuration for Copilot-chat integration
                    width = 0.8,
                    previewer = false,
                    prompt_title = "Copilot",
                    results_title = false,
                    winblend = 10,
                    layout_config = {
                        width = 0.8,
                        height = 0.6,
                    },
                }
            },
        },
        defaults = {
            history = {},
            mappings = {},
            vimgrep_arguments = {
                vim.env.HOMEBREW_PREFIX .. "/bin/rg",
                -- required
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",

                -- optional
                -- "--no-ignore",
                -- "--hidden",
                "--no-config",
                "--glob=!.git/",
                "--glob=!**/.terraform/",
                "--glob=!**/moved.tf",
            }
        },
    },
}
