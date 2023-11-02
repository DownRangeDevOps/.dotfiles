local keymap = require("user-keymap")

-- ----------------------------------------------
-- Install Lazy.nvim (https://github.com/folke/lazy.nvim)
-- :help lazy.nvim-lazy.nvim-installation
-- ----------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

-- Add Lazy.nvim to rtp
vim.opt.rtp:prepend(lazypath)

-- ----------------------------------------------
-- Lazy.nvim (https://github.com/folke/lazy.nvim)
-- :help lazy.nvim-lazy.nvim-plugin-spec
-- ----------------------------------------------
require("lazy").setup({
    { import = "plugins.util" },
    { import = "plugins.syntax" },
    { import = "plugins.ui" },
    { import = "plugins.core" },
    { import = "plugins.colorscheme" },
}, {
    install = {
        missing = true,
        colorscheme = { "habamax" }
    },
    diff = { cmd = "diffview.nvim" },
    change_detection = { -- reload ui on config file changes
        enabled = false,
        notify = false,
    },
    checker = {
        enabled = true,
        concurrency = nil,
        notify = false,
        frequency = 60 * 60 * 24,
    },
    performance = {
        cache = { enabled = true },
        reset_packpath = true,
        rtp = {
            reset = true,
            paths = {},
            disabled_plugins = {
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "rrhelper",
                "tar",
                "tarPlugin",
                "tohrml",
                "tutor",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            }
        }
    }
})

-- ----------------------------------------------
-- Set colorscheme after it's setup
-- ----------------------------------------------
vim.cmd.colorscheme("catppuccin")

-- ----------------------------------------------
-- Telescope: load extensions (https://github.com/nvim-telescope/telescope.nvim#extensions)
-- :help telescope.extensions()
-- ----------------------------------------------
require("telescope").load_extension("fzf")
require("telescope").load_extension("harpoon")

-- ----------------------------------------------
-- Treesitter (https://github.com/nvim-treesitter/nvim-treesitter#i-want-to-use-git-instead-of-curl-for-downloading-the-parsers)
-- :help nvim-treesitter
-- ----------------------------------------------
require("nvim-treesitter.install").prefer_git = true

-- ----------------------------------------------
-- nvim-cmp: broadcast capabilities to lsp (https://github.com/hrsh7th/nvim-cmp)
-- :help vim.lsp.protocol.make_client_capabilities()
-- ----------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- ----------------------------------------------
-- Mason: lsp configuration (https://github.com/williamboman/mason.nvim)
-- :help mason
-- ----------------------------------------------
local mason_lspconfig = require("mason-lspconfig")

-- Ensure these language servers are installed:
local mason_lsp_required_servers = {
    "ruby_ls",
    "lua_ls",
    "helm_ls",
    "ansiblels",
    "gopls",
    "pylsp",
    "cssls",
    "terraformls",
    "taplo",
    "neocmake",
    "marksman",
    "bashls",
    "vimls",
    "sqlls",
    "yamlls",
    "lemminx",
    "html",
    "tflint",
    "dockerls",
    "jqls",
    "pyre",
    "docker_compose_language_service",
    "rubocop",
    "jsonls",
}

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
}

mason_lspconfig.setup({ ensure_installed = mason_lsp_required_servers, })

mason_lspconfig.setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = keymap.lsp_maps,
            settings = mason_lsp_server_configs[server_name],
            filetypes = (mason_lsp_server_configs[server_name] or {}).filetypes,
        }
    end
}
