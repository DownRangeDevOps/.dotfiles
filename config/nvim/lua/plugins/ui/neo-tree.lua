-- ----------------------------------------------
-- neo-tree: tree/file browser (https://github.com/nvim-neo-tree/neo-tree.nvim)
-- :help neo-tree.txt
-- ----------------------------------------------
return {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = true,
    cmd = "Neotree",
    dependencies = {
        { "nvim-lua/plenary.nvim", branch = "master", lazy = false },
        { "nvim-tree/nvim-web-devicons", lazy = false }, -- https://github.com/nvim-tree/nvim-web-devicons
        { "MunifTanjim/nui.nvim",        lazy = false },
    },
    opts = {
        popup_border_style = "rounded",
        use_popups_for_input = false, -- use vim input since I can't change width
        event_handlers = {
            {
                event = "neo_tree_buffer_enter",
                handler = function()
                    vim.wo.number = true
                    vim.wo.relativenumber = true
                end
            },
            {
                event = "neo_tree_popup_input_ready",
                handler = function()
                    vim.cmd("stopinsert") -- enter input popup with normal mode by default.
                end,
            },
        },
        window = {
            position = "current",
            noremap = true,
            nowait = true,
            -- configure popup windows
            popup = {
                size = {
                    height = "10",
                    width = "90%",
                },
                position = {
                    row = "50%",
                    col = "1"
                }
            },
            floating = {
                size = {
                    height = "10",
                    width = "90%",
                },
                position = {
                    row = "50%",
                    col = "1"
                }
            }
        },
        filesystem = {
            last_modified = {
                enabled        = true,
                format         = "relitive",
                width          = 20,
                required_width = 88,
            },
            commands = {
                expand_node = function(state)
                    local origin_file = vim.fn.getreg("#")

                    state.commands["open"](state)

                    if origin_file ~= "" then
                        vim.fn.setreg("#", origin_file)
                    end
                end,
            },
            window = {
                mappings = {
                    ["A"] = { "add_directory", config = { show_path = "relative" } },
                    ["a"] = { "add", config = { show_path = "relative" } },
                    ["c"] = { "copy", config = { show_path = "relative" } },
                    ["m"] = { "move", config = { show_path = "relative" } },
                    ["-"] = "navigate_up",
                    ["<CR>"] = "expand_node",
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
