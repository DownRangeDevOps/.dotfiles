-- ----------------------------------------------
-- Treesitter Playground: View Treesitter information (https://github.com/nvim-treesitter/playground)
-- :help playground
-- ----------------------------------------------
local keymap = require("user-keymap")

return {
    "nvim-treesitter/playground",
    lazy = false,
    ---@diagnostic disable optional params not annotated correctly
    config = require("nvim-treesitter.configs").setup {
        playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = keymap.treesitter_playground_maps,
        },
    }
    ---@diagnostic enable
}
