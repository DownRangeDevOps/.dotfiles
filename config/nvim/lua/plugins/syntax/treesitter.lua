-- ----------------------------------------------
-- Treesitter: Syntax and code navigation (https://github.com/nvim-treesitter/nvim-treesitter)
-- :help treesitter.txtt i
-- ----------------------------------------------
local keymap = require("user-keymap")

return {
    "nvim-treesitter/nvim-treesitter",
    name = "nvim-treesitter",
    lazy = false,
    opts = {
        sync_install = false,
        ignore_install = { "cpp" },
        modules = {},
        auto_install = true, -- Autoinstall languages that are not installed
        ensure_installed = { -- Add languages to be installed here that you want installed for treesitter
            "awk",
            "bash",
            "c",
            "cmake",
            "comment",
            "cpp",
            "css",
            "csv",
            "diff",
            "dockerfile",
            "git_config",
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "go",
            "gpg",
            "groovy",
            "hcl",
            "html",
            "ini",
            "javascript",
            "jq",
            "json",
            "llvm",
            "lua",
            "luadoc",
            "luapatterns",
            "make",
            "markdown",
            "markdown_inline",
            "ninja",
            "ocamel",
            "ocamel_interface",
            "ocamllex",
            "passwd",
            "pip requirements",
            "python",
            "query",
            "regex",
            "ruby",
            "rust",
            "scss",
            "sql",
            "terraform",
            "toml",
            "tsv",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
            "zig",
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
    },
}
