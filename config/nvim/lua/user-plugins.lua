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
    -- "ansible-language-server",
    -- "bash-language-server",
    -- "css-lsp",
    -- "docker-compose-language-service",
    -- "dockerfile-language-server",
    -- "eslint-lsp",
    -- "gopls",
    -- "helm-ls",
    -- "html-lsp",
    -- "jq-lsp",
    -- "json-lsp",
    -- "lemminx",
    -- "ltex-ls",
    -- "lua-language-server",
    -- "marksman",
    -- "neocmakelsp",
    -- "nginx-language-server",
    -- "python-lsp-server",
    -- "rubocop",
    -- "ruby-lsp",
    -- "ruff",
    -- "sqlls",
    -- "taplo",
    -- "terraform-ls",
    -- "tflint",
    -- "typescript-language-server",
    -- "vale-ls",
    -- "vim-language-server",
    -- "yaml-language-server",
}
