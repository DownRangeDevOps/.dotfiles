-- ----------------------------------------------
-- Install Lazy.nvim (https://github.com/folke/lazy.nvim)
-- :help lazy.nvim-lazy.nvim-installation
-- ----------------------------------------------
-- Globals file markers for `mini.misc` project root helpers
MISC_PROJECT_MARKERS = {
    ".git", -- Handles both repositories and worktrees

    -- DevOps tools I commonly use
    ".pre-commit-config.yaml",
    ".tool-versions", -- asdf version manager

    -- CI/CD
    ".github/workflows",
    ".gitlab-ci.yml",

    -- Python projects
    "pyproject.toml",
    "poetry.lock",

    -- Golang projects
    "go.mod",
}

-- Global fallback function for `mini.misc` project root helpers
function MISC_FALLBACK()
  local bufnr = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(bufnr)

  -- If current buffer has no name, use current working directory
  if current_file == "" then
    return vim.fn.getcwd()
  end

  -- Otherwise return the directory of the current file
  return vim.fn.fnamemodify(current_file, ":h")
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
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
    { import = "plugins.ui" },
    { import = "plugins.syntax" },
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
-- Treesitter (https://github.com/nvim-treesitter/nvim-treesitter#i-want-to-use-git-instead-of-curl-for-downloading-the-parsers)
-- :help nvim-treesitter
-- ----------------------------------------------
require("nvim-treesitter.install").prefer_git = true

-- ----------------------------------------------
-- Plugin config
-- ----------------------------------------------

-- Editorconfig
vim.g.EditorConfig_exclude_patterns = { "fugitive://.\\*", "scp://.\\*" }

vim.lsp.set_log_level("off")
