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
                {
                    "mfussenegger/nvim-lint",
                    lazy = false,
                    dependencies = {
                        {
                            -- Mason helper for nvim-lint integration
                            "rshkarin/mason-nvim-lint",
                            opts = {
                                ensure_installed = {
                                    "actionlint",
                                    "codespell",
                                    "djlint",
                                    "gitleaks",
                                    "jsonlint",
                                    "markdownlint-cli2",
                                    "mypy",
                                    "revive",
                                    "rubocop",
                                    "ruff",
                                    "shellcheck",
                                    "tfsec",
                                    "vint",
                                    "yamllint",
                                },
                                automatic_installation = false,
                            },
                        },
                    },
                    init = function()
                        -- Set paths to system bins
                        vim.g.mason_ruby_path = vim.fn.trim(vim.fn.system("rbenv which ruby"))
                        vim.g.mason_gem_path = vim.fn.trim(vim.fn.system("rbenv which gem"))


                        -- Initalize nvim-lint
                        local lint = require("lint")
                        local mypy = require("lint").linters.mypy

                        table.insert(mypy.args, "--python-executable $(which python)")


                        -- Linters that run on specific paths/all filetypes are controlled
                        -- with autocommands. See `user-autocommands.lua`.
                        --
                        local linter_to_ft = {
                            [ "ansible.yaml" ] = { "ansible-lint", },
                            go                 = { "revive", },
                            json               = { "jsonlint", },
                            python             = { "mypy", },
                            -- TODO: implement it, only markdownlint supported -- markdown           = { "markdownlint-cli2", },
                            sh                 = { "shellcheck", },
                            terraform          = { "tflint", "tfsec", },
                            vim                = { "vint", },
                            yaml               = { "yamllint", },
                            -- ◍ djlint: Django, Go, Nunjucks, Twig, Handlebars, Mustache, Angular, Jinja
                        }

                        local snyk = {
                            "docker",
                            "go",
                            "helm",
                            "javaScript",
                            "python",
                            "ruby",
                            "rust",
                            "terraform",
                            "typescript"
                        }

                        local trivy = {
                            "c",
                            "dart",
                            "docker",
                            "elixir",
                            "go",
                            "helm",
                            "java",
                            "javaScript",
                            "phP",
                            "python",
                            "ruby",
                            "rust",
                            "terraform",
                            "typescript",
                        }

                        for ft, _ in pairs(linter_to_ft) do
                            if snyk[ft] then
                                table.insert(linter_to_ft[ft], "snyk")
                            end

                            if trivy[ft] then
                                table.insert(linter_to_ft[ft], "trivy")
                            end
                        end

                        for ft, _ in pairs(snyk) do
                            if not linter_to_ft[ft] then
                                linter_to_ft[ft] = { "snyk" }
                            end
                        end

                        for ft, _ in pairs(trivy) do
                            if not linter_to_ft[ft] then
                                linter_to_ft[ft] = { "trivy" }
                            end
                        end

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
