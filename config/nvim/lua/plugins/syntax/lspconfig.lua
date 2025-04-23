-- ----------------------------------------------
-- nvim-lspconfig: user contributed configs for the LSP (https://github.com/neovim/nvim-lspconfig)
-- :help lspconfig.txt
--
-- NOTE: Dependencies are set to ensure that plugins are installed in this order:
--         1. mason.nvim
--         2. mason-lspconfig.nvim
--         3. LSP Servers via `nvim-lspconfig`
-- ----------------------------------------------

-- Enable debugging, will dramatically decrease performance.
-- vim.lsp.set_log_level("debug")

local capabilities = vim.lsp.protocol.make_client_capabilities()
local keymap = require("user-keymap")
local misc = require("mini.misc")
local lsp_ensure_installed = {
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
}

-- Language server customizations
-- help: mason-lspconfig-automatic-server-setup
-- help: mason-lspconfig.setup_handlers()
local mason_lsp_server_configs = {
    yamlls = {
        filetypes = { "yaml" }, -- don't run on helm filetypes
    },
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
    vale_ls = {
        vale_ls = {
            cmd = { "vale-ls" },
            filetypes = { "markdown", "text", "tex", "rst" },
            root_dir = misc.find_root(0, MISC_PROJECT_MARKERS, function() MISC_FALLBACK() end),
            single_file_support = true,
            valeCLI = {
                installVale = true,
                syncOnStartup = true,
                configPath = vim.env.HOME .. "/.dotfiles/config/vale/.vale.ini",
            },
        },
    },
    ltex = {
        ltex = {
            root_dir = vim.env.HOME .. "/.local/share/nvim/mason/packages/ltex-ls",
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
                    ensure_installed = lsp_ensure_installed,
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
                    }
                })
            end,
            dependencies = {
                -- Mason: LSP and related plugin manager (https://github.com/williamboman/mason.nvim)
                -- :help mason.nvim
                {
                    "williamboman/mason.nvim",
                    lazy = false,
                    config = true,
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
                -- Initalize nvim-lint
                local linters_by_ft = require("lint").linters_by_ft
                local mypy = require("lint").linters.mypy

                table.insert(mypy.args, "--python-executable ${HOME}/.asdf/shims/python")

                -- Linters that run on specific paths/all filetypes are controlled
                -- with autocommands. See `user-autocommands.lua`.
                local linter_to_ft = {
                    ["ansible.yaml"] = { "ansible-lint" },
                    dockerfile       = { "synk", "trivy", "hadolint" },
                    go               = { "revive", "djlint", "synk", "trivy" },
                    helm             = { "kube-linter", "snyk", "trivy" },
                    jinja            = { "djlint" },
                    json             = { "jsonlint" },
                    markdown         = { "markdownlint-cli2", "vale" },
                    python           = { "ruff", "mypy", "snyk", "trivy" },
                    rst              = { "vale" },
                    rust             = { "snyk", "trivy" },
                    ruby             = { "rubocop", "snyk" },
                    sh               = { "shellcheck" },
                    terraform        = { "tflint", "snyk", "trivy" },
                    tex              = { "vale" },
                    text             = { "vale" },
                    vim              = { "vint" },
                    yaml             = { "yamllint" },
                    typescript       = { "eslint_d", "snyk", "trivy" },
                    javascript       = { "eslint_d", "snyk", "trivy" },
                    zsh              = { "shellcheck" },
                }

                -- linters for all filetypes
                for ft, _ in pairs(linters_by_ft) do
                    table.insert(linters_by_ft[ft], "editorconfig-checker")
                    table.insert(linters_by_ft[ft], "codespell")
                    table.insert(linters_by_ft[ft], "gitleaks")
                end

                linters_by_ft = linter_to_ft
            end,
        },
    },
}
