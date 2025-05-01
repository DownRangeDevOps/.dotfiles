-- ----------------------------------------------
-- nvim-lspconfig: user contributed configs for the LSP (https://github.com/neovim/nvim-lspconfig)
-- :help lspconfig.txt

-- NOTE: Ensure that plugins are installed in this order:
--  1. mason.nvim
--  2. mason-lspconfig.nvim
--  3. LSP Servers via `nvim-lspconfig`
-- ----------------------------------------------

-- Enable debugging, will dramatically decrease performance.
-- vim.lsp.set_log_level("debug")

return {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 3000,
    dependencies = {
        -- LazyDev: lua-ls configuration for nvim runtime and api (https://github.com/folke/lazydev.nvim)
        -- :help lazydev.nvim.txt
        {
            "folke/lazydev.nvim",
            ft = "lua",         -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            },
        },

        -- optional `vim.uv` typings
        { "Bilal2453/luvit-meta", lazy = true },

        -- optional completion source for require statements and module annotations
        {
            "hrsh7th/nvim-cmp",
            opts = function(_, opts)
                opts.sources = opts.sources or {}
                table.insert(opts.sources, {
                    name = "lazydev",
                    group_index = 0,         -- set group index to 0 to skip loading LuaLS completions
                })
            end,
        },

        -- Fidget: LSP status updates (https://github.com/j-hui/fidget.nvim)
        -- :help fidget.txt
        {
            "j-hui/fidget.nvim",
            tag = "legacy",
            lazy = true,
            config = true,
            event = "LspAttach"
        },
    },
}
