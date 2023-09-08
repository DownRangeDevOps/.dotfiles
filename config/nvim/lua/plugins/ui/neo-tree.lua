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
            -- window = {
            --     mappings = {
            --         ["-"] = "navigate_up",
            --         ["<CR>"] = function(state)
            --             local node = state.tree:get_node()
            --             vim.cmd.keepalt(vim.cmd.edit(node))
            --         end
            --     },
            -- },
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
}
