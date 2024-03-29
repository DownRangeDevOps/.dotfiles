-- ----------------------------------------------
-- Telescope: Fuzzy Finder (https://github.com/nvim-telescope/telescope.nvim)
-- :help telescope.nvim
-- ----------------------------------------------
local function is_git_repo()
    if os.execute("git rev-parse") == 0 then
        return true
    else
        return false
    end
end

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
            mappings = {
                -- n = {
                    -- -- nvim
                    -- ["<leader>fb"] = require("telescope.builtin").buffers({ sort_lastused = true }),

                    -- -- files
                    -- ["<leader>?"] = require("telescope.builtin").oldfiles(),
                    -- ["<leader>fm"] = require("telescope.builtin").man_pages(),
                    -- ["<leader>ff"] = function()
                    --     local opts = {
                    --         cwd = require("mini.misc").find_root(0, { ".git", "Makefile" }),
                    --         hidden = true,
                    --         no_ignore = true
                    --     }
                    --
                    --     require("telescope.builtin").find_files(opts)
                    -- end,
                    -- ["<C-p>"] = function()
                    --     if is_git_repo() then
                    --         require("telescope.builtin").git_files({ show_untracked = true })
                    --     else
                    --         require("telescope.builtin").find_files()
                    --     end
                    -- end,
                    --
                    -- -- strings
                    -- ["<leader>fh"] = require("telescope.builtin").help_tags(),
                    -- ["<leader>rg"] = function()
                    --     local opts = {
                    --         cwd = require("mini.misc").find_root(0, { ".git", "Makefile" }),
                    --         grep_open_files = false,
                    --     }
                    --
                    --     require("telescope.builtin").live_grep(opts)
                    -- end,
                    -- ["<leader>fw"] = function()
                    --     local opts = {
                    --         cwd = require("mini.misc").find_root(0, { ".git", "Makefile" }),
                    --         hidden = true,
                    --         no_ignore = true
                    --     }
                    --
                    --     require("telescope.builtin").grep_string(opts)
                    -- end,
                    -- ["/"] = function()
                    --     require("telescope.builtin").current_buffer_fuzzy_find(
                    --         require("telescope.themes").get_ivy({ previewer = false, }))
                    -- end,
                    --
                    -- -- diagnostics
                    -- ["<leader>e"] = vim.diagnostic.open_float,
                    -- ["<leader>E"] = vim.diagnostic.setloclist,
                    -- ["[d"] = vim.diagnostic.goto_prev,
                    -- ["]d"] = vim.diagnostic.goto_next,
                -- },
                -- i = {
                --     ["<C-n>"] = require("telescope.actions").cycle_history_next(0),
                --     ["<C-p>"] = require("telescope.actions").cycle_history_prev(0),
                -- }
            },
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
