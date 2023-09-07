-- ----------------------------------------------
-- nvim-lspconfig: user contributed configs for the LSP (https://github.com/neovim/nvim-lspconfig)
-- :help lspconfig.txt
-- ----------------------------------------------
return {
    "neovim/nvim-lspconfig",
    name = "nvim-lspconfig",
    lazy = false,
    dependencies = {
        -- Mason: LSP and related plugin manager (https://github.com/williamboman/mason.nvim)
        -- :help mason.nvim
        { "williamboman/mason.nvim", name = "nvim-mason", lazy = false, config = true },

        -- Mason helper for LSP configs/plugins (https://github.com/williamboman/mason-lspconfig.nvim)
        -- :help mason-lspconfig.nvim
        { "williamboman/mason-lspconfig.nvim", name = "nvim-mason-lspconfig", lazy = false, config = true },

        -- NeoDev: lua-ls configuration for nvim runtime and api (https://github.com/folke/neodev.nvim)
        -- :help neodev.nvim.txt
        { "folke/neodev.nvim", name = "nvim-neodev", lazy = true, ft = "lua", config = true },

        -- Fidget: LSP status updates (https://github.com/j-hui/fidget.nvim)
        -- :help fidget.txt
        { "j-hui/fidget.nvim", name = "nvim-fidget", tag = "legacy", lazy = true, event = "LspAttach" },
    },
}
