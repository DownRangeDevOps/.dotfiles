-- ----------------------------------------------
-- nvim-lspconfig: user contributed configs for the LSP (https://github.com/neovim/nvim-lspconfig)
-- :help lspconfig.txt
-- ----------------------------------------------
return {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
        -- Mason: LSP and related plugin manager (https://github.com/williamboman/mason.nvim)
        -- :help mason.nvim
        {
            "williamboman/mason.nvim",
            lazy = false,
            config = true,
            dependencies = {
                -- Mason helper for nvim-lint integration
                {
                    "mfussenegger/nvim-lint",
                    lazy = false,
                    init = function()
                        local lint = require('lint')

                        -- Linters that run on specific paths/all filetypes are controlled
                        -- with autocommands. See `user-autocommands.lua`.
                        --
                        local linter_to_ft = {
                            [ "ansible.yaml" ] = { "ansible-lint", },
                            go                 = { "revive", },
                            json               = { "jsonlint", },
                            -- TODO: implement it, only markdownlint supported -- markdown           = { "markdownlint-cli2", },
                            sh                 = { "shellcheck", },
                            terraform          = { "tflint", "tfsec", },
                            vim                = { "vint", },
                            yaml               = { "yamllint", },
                            -- ◍ djlint: Django, Go, Nunjucks, Twig, Handlebars, Mustache, Angular, Jinja
                        }

                        -- linters for all filetypes
                        for ft, _ in pairs(linter_to_ft) do
                            table.insert(linter_to_ft[ft], "editorconfig-checker")
                            table.insert(linter_to_ft[ft], "codespell")
                        end

                        lint.linters_by_ft = linter_to_ft
                    end,
                },
            },
        },

        -- Mason helper for LSP configs/plugins (https://github.com/williamboman/mason-lspconfig.nvim)
        -- :help mason-lspconfig.nvim
        { "williamboman/mason-lspconfig.nvim", lazy = false, config = true },

        -- NeoDev: lua-ls configuration for nvim runtime and api (https://github.com/folke/neodev.nvim)
        -- :help neodev.nvim.txt
        { "folke/neodev.nvim", lazy = true, ft = "lua", config = true },

        -- Fidget: LSP status updates (https://github.com/j-hui/fidget.nvim)
        -- :help fidget.txt
        { "j-hui/fidget.nvim", tag = "legacy", lazy = true, config = true, event = "LspAttach" },
    },
}
