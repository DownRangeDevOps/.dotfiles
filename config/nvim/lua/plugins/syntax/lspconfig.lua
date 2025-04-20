-- ----------------------------------------------
-- nvim-lspconfig: user contributed configs for the LSP (https://github.com/neovim/nvim-lspconfig)
-- :help lspconfig.txt
-- ----------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
local keymap = require("user-keymap")
-- vim.lsp.set_log_level("debug")

-- Language server customizations
-- help: mason-lspconfig-automatic-server-setup
-- help: mason-lspconfig.setup_handlers()
local mason_lsp_server_configs = {
    lua_ls = { -- https://github.com/LuaLS/lua-language-server/wiki/Diagnostics
        Lua = {
            filetypes = "lua", -- filetypes the language server will attach to
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
                globals = { "vim", }
            },
        },
    },
    ltex = {
        ltex = {
            root_dir = "~/.local/share/nvim/mason/packages/ltex-ls",
            language = "en-US",
        },
    },
    pylsp = {
        pylsp = {
            plugins = {
                -- formatters
                autopep8 = { enabled = false },
                black = { enabled = true },
                pyls_isort = { enabled = true },
                yapf = { enabled = false },

                -- linters
                flake8 = { enabled = false },
                mccabe = { enabled = true },
                pycodestyle = { enabled = false },
                pydocstyle = { enabled = false },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
                python_lsp_ruff = { enabled = true },

                -- type checkers
                pylsp_mypy = { enabled = true },

                -- auto-completion
                jedi_completion = {
                    enabled = true,
                    fuzzy = true,
                    include_params = true,
                    include_class_objects = true,
                    include_function_objects = true,
                },
                jedi_definition = {
                    enabled = true,
                    follow_imports = true,
                    follow_builtin_imports = true,
                    follow_builtin_deffinitions = true,
                },
                rope_autoimport = {
                    enabled = true,
                    completions = { enabled = true },
                    code_actions = { enabled = true },
                },
                rope_completion = { enabled = true },
            },
        },
    },
}

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
                -- Mason helper for LSP configs/plugins (https://github.com/williamboman/mason-lspconfig.nvim)
                -- :help mason-lspconfig.nvim
                {
                    "williamboman/mason-lspconfig.nvim",
                    lazy = false,
                    config = function()
                        -- Ensure Mason is set up before attempting to configure LSPs
                        require("mason").setup()

                        -- Configure mason-lspconfig handlers
                        require("mason-lspconfig").setup({
                            automatic_installation = false,
                            ensure_installed = {
                                "ansiblels",
                                "bashls",
                                "cssls",
                                "docker_compose_language_service",
                                "dockerls",
                                "eslint",
                                "gopls",
                                "helm_ls",
                                "html",
                                "jqls",
                                "jsonls",
                                "lemminx",
                                "ltex",
                                "lua_ls",
                                "marksman",
                                "neocmake",
                                "nginx_language_server",
                                "pylsp",
                                "rubocop",
                                "ruby_lsp",
                                "ruff",
                                "sqlls",
                                "taplo",
                                "terraformls",
                                "tflint",
                                "ts_ls",
                                "vale_ls",
                                "vimls",
                                "yamlls",
                            },
                            handlers = {
                                -- Default handler for all servers
                                function(server_name)
                                    require("lspconfig")[server_name].setup {
                                        capabilities = capabilities,
                                        on_attach = keymap.lsp_maps,
                                        settings = mason_lsp_server_configs[server_name],
                                        filetypes = (mason_lsp_server_configs[server_name] or {}).filetypes,
                                    }
                                end,

                                -- Custom handler for vale_ls
                                ["vale_ls"] = function()
                                    require("lspconfig").vale_ls.setup {
                                        settings = {
                                            vale_ls = {
                                                cmd = { "vale-ls" },
                                                filetypes = { 'markdown', 'text', 'tex', 'rst' },
                                                root_dir = vim.fn.getcwd(),
                                                single_file_support = true,
                                                valeCLI = {
                                                    installVale = true,
                                                    syncOnStartup = true,
                                                    configPath = vim.fn.expand("~/.dotfiles/config/vale/.vale.ini"),
                                                },
                                            }
                                        },
                                    }
                                end,
                            }
                        })
                    end,
                },
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
                        local linters_by_ft = require("lint").linters_by_ft
                        local mypy = require("lint").linters.mypy

                        table.insert(mypy.args, "--python-executable ${HOME}/.asdf/shims/python")

                        -- Linters that run on specific paths/all filetypes are controlled
                        -- with autocommands. See `user-autocommands.lua`.
                        --
                        local linter_to_ft = {
                            -- [ "ansible.yaml" ] = { "ansible-lint" },
                            go        = { "revive" },
                            json      = { "jsonlint" },
                            python    = { "mypy" },
                            -- TODO: implement it, only markdownlint supported -- markdown           = { "markdownlint-cli2", },
                            sh        = { "shellcheck" },
                            terraform = { "tflint" },
                            vim       = { "vint" },
                            yaml      = { "yamllint" },
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

                        -- for ft, _ in pairs(linter_to_ft) do
                        --     if snyk[ft] then
                        --         table.insert(linter_to_ft[ft], "snyk")
                        --     end
                        --
                        --     if trivy[ft] then
                        --         table.insert(linter_to_ft[ft], "trivy")
                        --     end
                        -- end

                        -- merge with default config
                        for type, linters in pairs(linter_to_ft) do
                            linters_by_ft[type] = linters
                        end

                        -- linters for all filetypes
                        for ft, _ in pairs(linters_by_ft) do
                            table.insert(linters_by_ft[ft], "editorconfig-checker")
                            table.insert(linters_by_ft[ft], "codespell")
                        end

                        linters_by_ft = linter_to_ft
                    end,
                },
            },
        },

        -- LazyDev: lua-ls configuration for nvim runtime and api (https://github.com/folke/lazydev.nvim)
        -- :help lazydev.nvim.txt
        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            },
        },
        { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
        {                                        -- optional completion source for require statements and module annotations
            "hrsh7th/nvim-cmp",
            opts = function(_, opts)
                opts.sources = opts.sources or {}
                table.insert(opts.sources, {
                    name = "lazydev",
                    group_index = 0, -- set group index to 0 to skip loading LuaLS completions
                })
            end,
        },

        -- Fidget: LSP status updates (https://github.com/j-hui/fidget.nvim)
        -- :help fidget.txt
        { "j-hui/fidget.nvim",    tag = "legacy", lazy = true, config = true, event = "LspAttach" },
    },
}
