-- ----------------------------------------------
-- Treesitter: Syntax and code navigation (https://github.com/nvim-treesitter/nvim-treesitter)
-- :help treesitter.txt
-- ----------------------------------------------
local keymap = require("user-keymap")

-- Prepend the Treesitter plugin dir so that parsers it manages are loaded first
vim.opt.runtimepath:prepend(vim.env.HOME .. "/.local/share/nvim/lazy/nvim-treesitter")

return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = require("nvim-treesitter.configs").setup({
        sync_install = false,
        ignore_install = {},
        modules = {},
        auto_install = true,
        ensure_installed = {
            "bash",
            "bash",
            "c",
            "comment",
            "csv",
            "diff",
            "dockerfile",
            "git_config",
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "go",
            "gomod",
            "gosum",
            "gowork",
            "hcl",
            "html",
            "ini",
            "javascript",
            "jq",
            "json",
            "lua",
            "luadoc",
            "luap",
            "make",
            "markdown",
            "markdown_inline",
            "python",
            "regex",
            "requirements",
            "ruby",
            "rust",
            "sql",
            "terraform",
            "toml",
            "typescript",
            "vim",
            "vimdoc",
            "xml",
            "yaml",

            -- "astro",
            -- "awk",
            -- "cmake",
            -- "css",
            -- "gpg",
            -- "groovy",
            -- "llvm",
            -- "ninja",
            -- "ocaml",
            -- "ocaml_interface",
            -- "ocamllex",
            -- "passwd",
            -- "query",
            -- "regex",
            -- "requirements",
            -- "scss",
            -- "toml",
            -- "tsv",
            -- "xml",
            -- "zig",
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            disable = { "c" },
            keymaps = keymap.treesitter_maps.incremental_selection
        },
        textobjects = {
            select = {
                keymaps = keymap.treesitter_maps.textobjects
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = keymap.treesitter_maps.move.goto_next_start,
                goto_next_end = keymap.treesitter_maps.move.goto_next_end,
                goto_previous_start = keymap.treesitter_maps.move.goto_previous_start,
                goto_previous_end = keymap.treesitter_maps.move.goto_previous_end,
            },
            swap = {
                enable = true,
                swap_next = keymap.swap_next,
                swap_previous = keymap.swap_previous,
            },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects", -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        },
        build = ":TSUpdate",
    }),
}
