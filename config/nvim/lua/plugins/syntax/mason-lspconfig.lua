-- ----------------------------------------------
-- mason-lspconfig
--
-- NOTE: Ensure that plugins are installed in this order:
--  1. mason.nvim
--  2. mason-lspconfig.nvim
--  3. LSP Servers via `nvim-lspconfig`
-- ----------------------------------------------

-- Enable debugging, will dramatically decrease performance.
-- vim.lsp.set_log_level("debug")

local capabilities = vim.lsp.protocol.make_client_capabilities()
local keymap = require("user-keymap")
local misc = require("mini.misc")

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
    -- Mason helper for LSP configs/plugins (https://github.com/williamboman/mason-lspconfig.nvim)
    -- :help mason-lspconfig.nvim
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    priority = 2000,
    config = function()
        -- Ensure Mason is set up before attempting to configure LSPs
        require("mason").setup()

        -- Configure mason-lspconfig handlers
        require("mason-lspconfig").setup({
            automatic_installation = true,
            ensure_installed = {},
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
}
