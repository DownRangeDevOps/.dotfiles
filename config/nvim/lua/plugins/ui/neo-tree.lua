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
        event_handlers = {
            {
                event = "neo_tree_buffer_enter",
                handler = function(arg)
                    vim.wo.colorcolumn = false
                    vim.wo.number = true
                    vim.wo.relativenumber = true
                end,
            }
        },
        window = {
            position = "current",
            noremap = true,
            nowait = true,
        },
        filesystem = {
            window = {
                mappings = {
                    ["A"] = { "add_directory", config = { show_path = "relative" } },
                    ["a"] = { "add", config = { show_path = "relative" } },
                    ["c"] = { "copy", config = { show_path = "relative" } },
                    ["m"] = { "move", config = { show_path = "relative" } },
                    ["-"] = "navigate_up",
                    ["<CR>"] =  function(state)
                        local origin_file = vim.fn.getreg("#")

                        state.commands["open"](state)

                        if origin_file ~= "" then
                            vim.fn.setreg("#", origin_file)
                        end
                    end,
                },
            },
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = true,
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
