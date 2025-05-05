-- ----------------------------------------------
-- trouble: (https://github.com/folke/trouble.nvim)
-- :help trouble.nvim
-- ----------------------------------------------
return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    opts = {},
    -- Lualine opts.sections throws index nil error
    -- opts = function(_, opts)
    --     local trouble = require("trouble")
    --     local symbols = trouble.statusline({
    --         mode = "lsp_document_symbols",
    --         groups = {},
    --         title = false,
    --         filter = { range = true },
    --         format = "{kind_icon}{symbol.name:Normal}",
    --         -- The following line is needed to fix the background color
    --         -- Set it to the lualine section you want to use
    --         hl_group = "lualine_c_normal",
    --     })
    --
    --     -- Add Trouble to lualine
    --     table.insert(opts.sections.lualine_c, {
    --         symbols.get,
    --         cond = symbols.has,
    --     })
    -- end,
    keys = {
        {
            "<leader>t",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>tX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            "<leader>ts",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>tl",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
            "<leader>tL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<leader>tQ",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },
    },
}
