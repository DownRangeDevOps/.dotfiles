-- ----------------------------------------------
-- neo-tree: tree/file browser (https://github.com/nvim-neo-tree/neo-tree.nvim)
-- :help neo-tree.txt
-- ----------------------------------------------
return {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = true,
    cmd = "Neotree",
    branch = "v3.x",
    dependencies = {
        { "nvim-lua/plenary.nvim", name = "nvim-plenary", lazy = false },
        { "nvim-tree/nvim-web-devicons", name = "nvim-devicons", lazy = false }, -- https://github.com/nvim-tree/nvim-web-devicons
        { "MunifTanjim/nui.nvim", name = "nvim-nui", lazy = false },
    },
    opts = {
        window = {
            position = "current",
            noremap = true,
            nowait = true,
        },
        filesystem = {
            window = {
                mappings = {
                    ["a"] = { "add", config = { show_path = "relative" } },
                    ["A"] = { "add_directory", config = { show_path = "relative" } },
                    ["c"] = { "add", config = { show_path = "relative" } },
                    ["m"] = { "add", config = { show_path = "relative" } },
                    ["-"] = "navigate_up",
                    ["<CR>"] =  function(state)
                        local origin_file = vim.fn.getreg("#")

                        state.commands["open"](state)
                        vim.fn.setreg("#", origin_file)
                    end,
                },
            },
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                    hijack_netrw_behavior = "open_current",
                    use_libuv_file_watcher = true,
                }
            },
        },
    },
}
