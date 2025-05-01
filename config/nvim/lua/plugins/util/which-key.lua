-- ----------------------------------------------
-- which-key (https://github.com/folke/which-key.nvim)
-- :help which-key.nvim.txt
-- ----------------------------------------------
-- Checking your config ~
-- - WARNING There are issues with your config:
--   - `opts.motions`: option is deprecated.
--   - `opts.hidden`: option is deprecated.
--   - `opts.popup_mappings`: option is deprecated. see `opts.keys`
--   - `opts.triggers_blacklist`: option is deprecated. see `opts.triggers`
--   - `opts.triggers_nowait`: option is deprecated. see `opts.delay`
--   - `opts.key_labels`: option is deprecated. see `opts.replace`
--   - `opts.operators`: option is deprecated. see `opts.defer`
--   - `opts.ignore_missing`: option is deprecated. see `opts.filter`
--   - `opts.triggers`: triggers must be a table
--   Please refer to the docs for more info.
-- - WARNING |mini.icons| is not installed

return {
    "folke/which-key.nvim",
    priority = 2000,
    lazy = false,
    config = true,
    init = function()
        vim.opt.timeout = true
        vim.opt.timeoutlen = 500
    end,
    -- opts = {
    --     plugins = {
    --         marks = true,
    --         registers = true,
    --         spelling = {
    --             enabled = true,
    --             suggestions = 20,
    --         },
    --         presets = {
    --             operators = true,
    --             motions = true,
    --             text_objects = true,
    --             windows = false,
    --             nav = false,
    --             z = true,
    --             g = true,
    --         },
    --     },
    --     -- add operators that will trigger motion and text object completion
    --     operators = {
    --         ys = "Surround",
    --         gc = "Comments",
    --     },
    --     key_labels = {
    --         -- override the label used to display some keys. It doesn't effect WK in any other way.
    --         -- ["<space>"] = "SPC",
    --     },
    --     motions = {
    --         count = true,
    --     },
    --     icons = {
    --         breadcrumb = "»",
    --         separator = "➜",
    --         group = "+", -- symbol prepended to a group
    --     },
    --     popup_mappings = {
    --         scroll_down = "<c-d>",
    --         scroll_up = "<c-u>",
    --     },
    --     win = {
    --         border = "none", -- none, single, double, shadow
    --         position = "bottom", -- bottom, top
    --         margin = { 1, 0.1, 1, 0.1 }, -- extra window margin [t,r,b,l]. 0-1 = %
    --         padding = { 1, 4, 1, 4 }, -- extra window padding [t,r,b,l]
    --         winblend = 25, -- value between 0-100 0 for fully opaque and 100 for fully transparent
    --         zindex = 1000,
    --     },
    --     layout = {
    --         height = { min = 4, max = 25 }, -- min and max height of the columns
    --         width = { min = 20, max = 50 }, -- min and max width of the columns
    --         spacing = 2, -- spacing between columns
    --         align = "left", -- align columns left, center or right
    --     },
    --     ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    --     hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- mapping boilerplate
    --     show_help = true,
    --     show_keys = true,
    --     triggers = "auto", -- automatically setup triggers
    --     triggers_nowait = {
    --         -- marks
    --         "`",
    --         "'",
    --         "g`",
    --         "g'",
    --
    --         -- registers
    --         "\"",
    --         "<c-r>",
    --
    --         -- spelling
    --         "z=",
    --     },
    --     triggers = {
    --         i = { "j", "k" },
    --         v = { "j", "k" },
    --     },
    --     disable = {
    --         buftypes = {},
    --         filetypes = {},
    --     },
    -- }
}
