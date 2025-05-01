-- ----------------------------------------------
-- Vim user sovereign rights
-- ----------------------------------------------
return {
    { "mbbill/undotree",       lazy = false }, -- Browse undo-tree (https://github.com/mbbill/undotree.git)
    { "tpope/vim-abolish",     lazy = false }, -- Fix typos and advanced case/conjugation sensitive replace (https://github.com/tpope/vim-abolish)
    { "tpope/vim-fugitive",    lazy = false }, -- Git manager (https://github.com/tpope/vim-fugitive)
    { "tpope/vim-obsession",   lazy = false }, -- Session mgmt (https://github.com/tpope/vim-obsession)
    { "tpope/vim-repeat",      lazy = false }, -- Repeat plugin maps (https://github.com/tpope/vim-repeat)
    { "tpope/vim-sleuth",      lazy = false }, -- Detect tabstop and shiftwidth automatically (https://github.com/tpope/vim-sleuth)
    { "tpope/vim-unimpaired",  lazy = false }, -- Navigation pairs like [q (https://github.com/tpope/vim-unimpaired)
    { "windwp/nvim-autopairs", lazy = true, event = "InsertEnter", opts = {} }, -- auto-pairs (https://github.com/windwp/nvim-autopairs)

    -- TODO: How to fix recursive dependency on user-keymap
    -- Quick-switch files (https://github.com/ThePrimeagen/harpoon)
    -- {
    --     "ThePrimeagen/harpoon",
    --     branch = "harpoon2",
    --     lazy = false,
    --     dependencies = { "nvim-lua/plenary.nvim", branch = "master" },
    --     conf = function()
    --         -- Harpoon (https://github.com/ThePrimeagen/harpoon)
    --         -- :help harpoon
    --         local harpoon = require("harpoon")
    --         harpoon:setup()
    --
    --         local harpoon_extensions = require("harpoon.extensions")
    --         harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
    --
    --         local map = vim.keymap.set
    --
    --         map("n", "<leader>hh", function() harpoon:ui:toggle_quick_menu(harpoon:list()) end, { group = "file", desc = "view live well" })
    --         map("n", "<leader>a", function() harpoon:list():add() end, { group = "file", desc = "harpoon this file" })
    --         map("n", "<leader>j", function() harpoon:list():select(1) end, { group = "file", desc = "first harpoon" })
    --         map("n", "<leader>k", function() harpoon:list():select(2) end, { group = "file", desc = "second harpoon" })
    --         map("n", "<leader>l", function() harpoon:list():select(3) end, { group = "file", desc = "third harpoon" })
    --         map("n", "<leader>;", function() harpoon:list():select(4) end, { group = "file", desc = "fourth harpoon" })
    --         map("n", "<C-j>", function() harpoon:list():prev() end, { group = "file", desc = "<< harpoon" })
    --         map("n", "<C-k>", function() harpoon:list():next() end, { group = "file", desc = "harpoon >>" })
    --         map("n", "<leader>hc", function() harpoon:list().clear() end, { group = "file", desc = "release all harpoons" })
    --     end,
    -- },

    -- No-delay multi-key escape (https://github.com/max397574/better-escape.nvim)
    {
        "max397574/better-escape.nvim",
        lazy = true,
        event = "InsertEnter",
        config = function()
            require("better_escape").setup({
                mapping = { "jj" },
                timeout = vim.o.timeoutlen,
                clear_empty_lines = false,
                keys = function()
                    return vim.api.nvim_win_get_cursor(0)[2] > 1 and "<esc>l" or "<esc>"
                end,
            })
            -- require("better_escape").setup({
            --     mapping = { "jk" },
            --     timeout = vim.o.timeoutlen,
            --     clear_empty_lines = false,
            --     keys = function()
            --        return vim.cmd("ToggleTerm")
            --     end,
            -- })
        end
    },

    -- vim-surround, but better (https://github.com/kylechui/nvim-surround)
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = true,
    },
}
