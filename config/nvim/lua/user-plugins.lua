local keymap = require("user-keymap")

-- ----------------------------------------------
-- Install Lazy.nvim (https://github.com/folke/lazy.nvim)
-- :help lazy.nvim-lazy.nvim-installation
-- ----------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end

-- Add Lazy.nvim to rtp
vim.opt.rtp:prepend(lazypath)

-- ----------------------------------------------
-- Load plugins (https://github.com/folke/lazy.nvim)
-- :help lazy.nvim-lazy.nvim-plugin-spec
-- ----------------------------------------------
require("lazy").setup({
    -- ----------------------------------------------
    -- Vim user sovereign rights
    -- ----------------------------------------------
    { "ThePrimeagen/harpoon",  name = "nvim-harpoon",   lazy = false }, -- Quick-switch files (https://github.com/ThePrimeagen/harpoon)
    { "mbbill/undotree",       name = "nvim-undotree",  lazy = false }, -- Browse undo-tree (https://github.com/mbbill/undotree.git)
    { "nathom/filetype.nvim",  name = "vim-filetype",   lazy = true },  -- Replacement for slow filetype.vim builtin (https://github.com/nathom/filetype.nvim)
    { "tpope/vim-abolish",     name = "vim-abolish",    lazy = true,    event = "InsertEnter,     CmdlineEnter" }, -- Fix typos and advanced case/conjugation sensitive replace (https://github.com/tpope/vim-abolish)
    { "tpope/vim-fugitive",    name = "vim-fugitive",   lazy = false},  -- Git manager (https://github.com/tpope/vim-fugitive)
    { "tpope/vim-obsession",   name = "vim-obsession",  lazy = false }, -- Session mgmt (https://github.com/tpope/vim-obsession)
    { "tpope/vim-repeat",      name = "vim-repeat",     lazy = false }, -- Repeat plugin maps (https://github.com/tpope/vim-repeat)
    { "tpope/vim-sleuth",      name = "vim-sleuth",     lazy = true,    event  = "InsertEnter" }, -- Detect tabstop and shiftwidth automatically (https://github.com/tpope/vim-sleuth)
    { "tpope/vim-surround",    name = "vim-surround",   lazy = false }, -- Surround text (https://github.com/tpope/vim-surround)
    { "tpope/vim-unimpaired",  name = "vim-unimpaired", lazy = false }, -- Navigation pairs like [q (https://github.com/tpope/vim-unimpaired)
    { "windwp/nvim-autopairs", name = "nvim-autopairs", lazy = true,    event  = "InsertEnter",   opts = {} },     -- auto-pairs (https://github.com/windwp/nvim-autopairs)
    { "zhimsel/vim-stay",      name = "vim-stay",       lazy = false }, --  Stay in your lane,    vim! (https://github.com/zhimsel/vim-stay)

    -- vim-rooter: cd to project root (https://github.com/airblade/vim-rooter)
    -- :help vim-rooter
    {
        "airblade/vim-rooter",
        name = "vim-rooter",
        lazy = false,
        config = function()
            vim.g.rooter_buftypes = { "", "nofile" }
            vim.g.rooter_patterns = { ".git" }
            vim.g.rooter_change_directory_for_non_project_files = "home"
        end
    },

    -- ----------------------------------------------
    -- UI
    -- ----------------------------------------------
    -- colorscheme/theme (https://github.com/catppuccin/nvim/tree/main)
    -- :help catppuccin.txt
    { "catppuccin/nvim", name = "nvim-catppuccin", priority = 1000, lazy = false }, -- setup called later in file

    -- show syntax at cursor (https://github.com/vim-scripts/SyntaxAttr.vim)
    -- :help syntaxattr
    { "vim-scripts/SyntaxAttr.vim", name = "vim-syntaxattr", lazy = false },

    -- nvim-ufo folds (https://github.com/kevinhwang91/nvim-ufo)
    -- :help nvim-ufo
    {
        "kevinhwang91/nvim-ufo",
        name = "nvim-ufo",
        lazy = false,
        enabled = false, -- until I figure out why folds keep auto-closing
        config = true,
        opts = {
            provider_selector = function() return { "treesitter", "indent" } end,
            close_fold_kinds = {}
        },
        dependencies = {
            { "kevinhwang91/promise-async", name = "nvim-promise-async", lazy = true }
        }
    },

    -- LuaLine
    -- :help lualine.txt
    {
        "nvim-lualine/lualine.nvim", -- https://github.com/nvim-lualine/lualine.nvim
        name = "nvim-lualine",
        lazy = false,
        config = true,
        opts = {
            options = {
                icons_enabled = false,
                theme = "catppuccin",
                component_separators = "⁞",
                section_separators = { left = "", right = ""},
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
            },
        },
    },

    -- Indentation guides (https://github.com/lukas-reineke/indent-blankline.nvim)
    -- :help indent_blankline.txt
    {
        "lukas-reineke/indent-blankline.nvim",
        name = "nvim-blankline",
        lazy = false,
        opts = {
            char = "┊",
            context_char = "┊",
            context_char_blankline = "┊",
            show_current_context = true,
            show_current_context_start = false,
            show_current_context_start_on_current_line = false,
            show_end_of_line = false,
            show_first_indent_level = true,
            show_trailing_blankline_indent = true,
            disable_with_nolist = true,
            space_char = " ",
            strict_tabs = true,
            space_char_blankline = " ",
            use_treesitter = true,
            use_treesitter_scope = true,
            viewport_buffer = 50,
            buftype_exclude = {
                "terminal",
                "nofile",
                "quickfix",
                "prompt",
            },
            filetype_exclude = {
                "",
                "checkhealth",
                "help",
                "lspinfo",
                "man",
                "neo-tree",
                "packer",
                "qf",
            },
            context_patterns = {
                "class",
                "^func",
                "method",
                "^if",
                "while",
                "for",
                "with",
                "try",
                "except",
                "match",
                "arguments",
                "argument_list",
                "object",
                "dictionary",
                "element",
                "table",
                "tuple",
                "do_block",
                "Block",
                "InitList",
                "FnCallArguments",
                "IfStatement",
                "ContainerDecl",
                "SwitchExpr",
                "IfExpr",
                "ParamDeclList",
                "unless",
            }
        },
    },

    -- nvim-colorizer: (https://github.com/NvChad/nvim-colorizer.lua)
    -- :help nvim-colorizer
    --
    -- Attach to buffer
    -- require("colorizer").attach_to_buffer(0, { mode = "background", css = true})
    --
    -- Detach from buffer
    -- require("colorizer").detach_from_buffer(0, { mode = "virtualtext", css = true})
    {
        "NvChad/nvim-colorizer.lua",
        name = "nvim-colorizer",
        lazy = true,
        opts = {
            filetypes = { "*" },
            user_default_options = {
                RGB = true, -- #RGB
                RRGGBB = true, -- #RRGGBB
                names = true, -- Blue or blue
                RRGGBBAA = true, -- #RRGGBBAA
                AARRGGBB = true, -- 0xAARRGGBB
                rgb_fn = true, -- CSS rgb() and rgba()
                hsl_fn = true, -- CSS hsl() and hsla()
                css = true, -- rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- rgb_fn, hsl_fn
                mode = "virtualtext", -- foreground, background,  virtualtext
                tailwind = false, -- false, true/normal, lsp, both
                -- parsers can contain values used in |user_default_options|
                sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
                virtualtext = "●",
                -- update color values even if buffer is not focused
                -- example use: cmp_menu, cmp_docs
                always_update = false
            },
            -- all the sub-options of filetypes apply to buftypes
            buftypes = {},
        }
    },

    -- neo-tree: tree/file browser (https://github.com/nvim-neo-tree/neo-tree.nvim)
    -- :help neo-tree.txt
    {
        "nvim-neo-tree/neo-tree.nvim",
        name = "nvim-neotree",
        lazy = true,
        cmd = "Neotree",
        branch = "v3.x",
        dependencies = {
            { "nvim-lua/plenary.nvim", name = "nvim-plenary", lazy = false },
            { "nvim-tree/nvim-web-devicons", name = "nvim-devicons", lazy = false }, -- https://github.com/nvim-tree/nvim-web-devicons
            { "MunifTanjim/nui.nvim", name = "nvim-nui", lazy = false },
        },
        opts = {
            window = {
                position = "current",
                noremap = true,
                nowait = true,
            },
            filesystem = {
                -- window = {
                --     mappings = {
                --         ["-"] = "navigate_up",
                --         ["<CR>"] = function(state)
                --             local node = state.tree:get_node()
                --             vim.cmd.keepalt(vim.cmd.edit(node))
                --         end
                --     },
                -- },
            },
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                    hijack_netrw_behavior = "open_current",
                    use_libuv_file_watcher = true,
                }
            },
        },
    },

    -- refactoring.vim: Refactoring library (https://github.com/ThePrimeagen/refactoring.nvim)
    -- :help refactoring.nvim
    {
        "ThePrimeagen/refactoring.nvim",
        name = "nvim-refactoring",
        lazy = true,
        event = "InsertEnter",
        dependencies = {
            { "nvim-lua/plenary.nvim", name = "nvim-plenary", lazy = false },
            { "nvim-treesitter/nvim-treesitter", name = "nvim-treesitter", lazy = false },
        },
        config = true,
        opts = {
            prompt_func_return_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            prompt_func_param_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            printf_statements = {},
            print_var_statements = {},
        },
    },

    -- gitsigns (https://github.com/lewis6991/gitsigns.nvim)
    -- :help gitsigns.txt
    {
        "lewis6991/gitsigns.nvim",
        name = "nvim-gitsigns",
        lazy = false,
        config = true,
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                changedelete = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                untracked    = { text = "┆" },
            },
            on_attach = function(bufnr)
                vim.keymap.set("n", "<leader>p", require("gitsigns").prev_hunk, { buffer = bufnr, desc = "go prev hunk" })
                vim.keymap.set("n", "<leader>nh", require("gitsigns").next_hunk, { buffer = bufnr, desc = "go next hunk" })
                vim.keymap.set("n", "<leader>hp", require("gitsigns").preview_hunk, { buffer = bufnr, desc = "preview hunk" })
                vim.keymap.set("n", "<leader>hu", require("gitsigns").reset_hunk, { buffer = bufnr, desc = "reset hunk" })
                vim.keymap.set("n", "<leader>ha", require("gitsigns").stage_hunk, { buffer = bufnr, desc = "stage hunk" })
            end,
        },
    },

    -- ----------------------------------------------
    -- Utils
    -- ----------------------------------------------
    { "echasnovski/mini.align", lazy = true, event = "InsertEnter", version = "*", config = true, }, -- align/columns (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md)
    { "echasnovski/mini.comment", lazy = false, version = "*", config = true }, -- mini-comment: (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-comment)
    { "echasnovski/mini.trailspace", lazy = false, version = "*", config = true }, -- mini-trailspace: delete trailing whitespace (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-trailspace.md)
    { "sindrets/diffview.nvim", lazy = true, cmd = { "DiffviewOpen", "DiffviewTogglefiles", "DiffviewFileHistory" } }, -- Diffview (https://github.com/sindrets/diffview.nvim#usage)
    { "dkarter/bullets.vim", name = "vim-bullets", lazy = true, event = "InsertEnter" }, -- bullet formatting (https://github.io/dkarter/bullets.vim)
    { "gcmt/taboo.vim", name = "vim-taboo", lazy = true, event = "CmdlineEnter", }, -- taboo.vim: tab management (https://github.com/gcmt/taboo.vim)

    -- nvim-lint (https://github.com/mfussenegger/nvim-lint)
    -- :help nvim-lint
    { "mfussenegger/nvim-lint", lazy = true, event = "BufWritePost" },

    -- mini-move: (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-move)
    -- :help mini-move
    {
        "echasnovski/mini.move",
        lazy = false,
        version = "*",
        config = true,
        opts = {
            mappings = {
                -- Move visual selection
                left = "<S-h>",
                right = "<S-l>",
                down = "<S-j>",
                up = "<S-k>",

                -- Move current line in normal mode
                line_left = "",
                line_right = "",
                line_down = "",
                line_up = "",
            },
            options = {
                reindent_linewise = true, -- re-indent selection during vertical move
            },
        }
    },

    -- mini-starter: (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-starter)
    -- :help mini-starter
    {
        "echasnovski/mini.starter",
        lazy = false,
        version = "*",
        config = true,
        opts = {
            autoopen = true,
            evaluate_single = false,

            -- Items to be displayed. Should be an array with the following elements:
            --     Item: table with <action>, <name>, and <section> keys.
            --     Function: should return one of these three categories.
            --     Array: elements of these three types (i.e. item, array, function).
            -- If `nil` (default), default items will be used (see |mini.starter|).
            items = nil,
            header = ""
            .. "\"If you look for truth, you may find comfort in the end; if you look for\n"
            .. "comfort you will not get either comfort or truth only soft soap and wishful\n"
            .. "thinking to begin, and in the end, despair.\"\n"
            .. "                                         – C. S. Lewis\n"
            .. "\n"
            .. "\"Everybody has a plan until they get punched in the mouth.\"\n"
            .. "                                         – Mike Tyson\n"
            .. "\n",

            -- Footer to be displayed after items. Converted to single string via
            -- `tostring` (use `\n` to display several lines). If function, it is
            -- evaluated first. If `nil` (default), default usage help will be shown.
            footer = nil,

            -- Array  of functions to be applied consecutively to initial content.
            -- Each function should take and return content for "Starter" buffer (see
            -- |mini.starter| and |MiniStarter.content| for more details).
            content_hooks = nil,

            -- Characters to update query. Each character will have special buffer
            -- mapping overriding your global ones. Be careful to not add `:` as it
            -- allows you to go into command mode.
            query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_-.",

            -- Whether to disable showing non-error feedback
            silent = false,
        },
    },

    -- which-key (https://github.com/folke/which-key.nvim)
    -- :help which-key.nvim.txt
    {
        "folke/which-key.nvim",
        name = "nvim-which-key",
        lazy = false,
        config = true,
        init = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 500
        end,
        opts = {
            plugins = {
                marks = true,
                registers = true,
                spelling = {
                    enabled = true,
                    suggestions = 20,
                },
                presets = {
                    operators = true,
                    motions = true,
                    text_objects = true,
                    windows = false,
                    nav = false,
                    z = true,
                    g = true,
                },
            },
            -- add operators that will trigger motion and text object completion
            operators = {
                ys = "Surround",
                gc = "Comments",
            },
            key_labels = {
                -- override the label used to display some keys. It doesn't effect WK in any other way.
                -- ["<space>"] = "SPC",
            },
            motions = {
                count = true,
            },
            icons = {
                breadcrumb = "»",
                separator = "➜",
                group = "+", -- symbol prepended to a group
            },
            popup_mappings = {
                scroll_down = "<c-d>",
                scroll_up = "<c-u>",
            },
            window = {
                border = "none", -- none, single, double, shadow
                position = "bottom", -- bottom, top
                margin = { 1, 0.1, 1, 0.1 }, -- extra window margin [t,r,b,l]. 0-1 = %
                padding = { 1, 4, 1, 4 }, -- extra window padding [t,r,b,l]
                winblend = 25, -- value between 0-100 0 for fully opaque and 100 for fully transparent
                zindex = 1000,
            },
            layout = {
                height = { min = 4, max = 25 }, -- min and max height of the columns
                width = { min = 20, max = 50 }, -- min and max width of the columns
                spacing = 2, -- spacing between columns
                align = "left", -- align columns left, center or right
            },
            ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
            hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- mapping boilerplate
            show_help = true,
            show_keys = true,
            triggers = "auto", -- automatically setup triggers
            triggers_nowait = {
                -- marks
                "`",
                "'",
                "g`",
                "g'",

                -- registers
                "\"",
                "<c-r>",

                -- spelling
                "z=",
            },
            triggers_blacklist = {
                i = { "j", "k" },
                v = { "j", "k" },
            },
            disable = {
                buftypes = {},
                filetypes = {},
            },
        }
    },

    -- Telescope: Fuzzy Finder (https://github.com/nvim-telescope/telescope.nvim)
    -- :help telescope.nvim
    {
        "nvim-telescope/telescope.nvim",
        name = "nvim-telescope",
        branch = "0.1.x",
        lazy = false,
        dependencies = {
            { "nvim-lua/plenary.nvim", name = "nvim-plenary", lazy = false }, -- https://github.com/nvim-lua/plenary.nvim
            { "nvim-tree/nvim-web-devicons", name = "nvim-devicons", lazy = false }, -- https://github.com/nvim-tree/nvim-web-devicons
            { "nvim-telescope/telescope-fzf-native.nvim", name = "nvim-telescope-fzf-native", lazy = false, build = "make", } -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
        },
        config = true,
        opts = {
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                harpoon = {},
            },
            defaults = {
                mappings = {
                    i = {
                        ["<C-u>"] = false,
                        ["<C-d>"] = false,
                    },
                },
            },
        },
    },

    -- toggleterm (https://github.com/akinsho/toggleterm.nvim)
    -- :help toggleterm
    {
        "akinsho/toggleterm.nvim",
        name = "vim-toggleterm",
        lazy = true,
        cmd = "ToggleTerm",
        version = "*",
        opts = {
            hide_numbers = true,
            shade_terminals = false,
            start_in_insert = true,
            insert_mappings = false,
            terminal_mappings = false,
            presist_size = true,
            presist_mode = true,
            direction = "horizontal",
            shell = vim.env.BREW_PREFIX .. "/bin/bash --login",
            auto_scroll = true,
            border = "curve",
            highlights = {
                Normal = {
                    guibg = "#11111b"
                },
                NormalFloat = {
                    guibg = "#11111b"
                },
                FloatBorder = {
                    guibg = "#11111b"
                },
            },
        },
    },

    -- ----------------------------------------------
    -- Syntax/LSP
    -- ----------------------------------------------
    -- Treesitter: Syntax and code navigation (https://github.com/nvim-treesitter/nvim-treesitter)
    -- :help treesitter.txtt i
    {
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
            keymaps = keymap.treesitter_keymap.incremental_selection
        },
        textobjects = {
            select = {
                keymaps = keymap.treesitter_keymap.textobjects
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = keymap.treesitter_keymap.move.goto_next_start,
                goto_next_end = keymap.treesitter_keymap.move.goto_next_end,
                goto_previous_start = keymap.treesitter_keymap.move.goto_previous_start,
                goto_previous_end = keymap.treesitter_keymap.move.goto_previous_end,
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
},

-- nvim-lspconfig: user contributed configs for the LSP (https://github.com/neovim/nvim-lspconfig)
-- :help lspconfig.txt
{
    "neovim/nvim-lspconfig",
        name = "nvim-lspconfig",
    lazy = false,
    dependencies = {
        -- Mason: LSP and related plugin manager (https://github.com/williamboman/mason.nvim)
        -- :help mason.nvim
            { "williamboman/mason.nvim", name = "nvim-mason", lazy = false, config = true },

        -- Mason helper for LSP configs/plugins (https://github.com/williamboman/mason-lspconfig.nvim)
        -- :help mason-lspconfig.nvim
            { "williamboman/mason-lspconfig.nvim", name = "nvim-mason-lspconfig", lazy = false, config = true },

        -- NeoDev: lua-ls configuration for nvim runtime and api (https://github.com/folke/neodev.nvim)
        -- :help neodev.nvim.txt
            { "folke/neodev.nvim", name = "nvim-neodev", lazy = true, ft = "lua", config = true },

        -- Fidget: LSP status updates (https://github.com/j-hui/fidget.nvim)
        -- :help fidget.txt
            { "j-hui/fidget.nvim", name = "nvim-fidget", tag = "legacy", lazy = true, event = "LspAttach" },
    },
},

-- nvim-cmp: completion manager (https://github.com/hrsh7th/nvim-cmp)
-- :help cmp
{
    "hrsh7th/nvim-cmp",
        name = "nvim-cmp",
    lazy = true,
    event = "InsertEnter,CmdlineEnter",
    version = "2.*",
    build = "make install_jsregexp",
    dependencies = {
        --  LuaSnip: snippets manager (https://github.com/L3MON4D3/LuaSnip)
        -- :help luasnip.txt
            { "L3MON4D3/LuaSnip", name = "nvim-luasnip", lazy = true, event = "InsertEnter", config = function() require("luasnip.loaders.from_vscode").lazy_load() end }, -- https://github.com/L3MON4D3/LuaSnip

        -- LuaSnip completion source (https://github.com/saadparwaiz1/cmp_luasnip)
        -- :help cmp_luasnip
            { "saadparwaiz1/cmp_luasnip", name = "nvim-cmp-luasnip", lazy = true, event = "InsertEnter", },

        -- Adds a number of user-friendly snippets
            { "rafamadriz/friendly-snippets", name = "nvim-friendly-snippets", lazy = true, event = "InsertEnter",}, -- https://github.com/rafamadriz/friendly-snippets

        -- other recommended dependencies
            { "hrsh7th/cmp-nvim-lsp", name = "nvim-cmp-nvim-lsp", lazy = false }, -- LSP completion capabilities (https://github.com/hrsh7th/cmp-nvim-lsp)
            { "hrsh7th/cmp-buffer", name = "nvim-cmp-buffer", lazy = false }, -- Buffer words (https://github.com/hrsh7th/cmp-buffer)
            { "hrsh7th/cmp-path", name = "nvim-cmp-path", lazy = false }, -- System paths (https://github.com/hrsh7th/cmp-path)
            { "hrsh7th/cmp-cmdline", name = "nvim-cmp-cmdline", lazy = false }, -- Search (/) and command (:) (https://github.com/hrsh7th/cmp-buffer)

        -- Auto complete rule: Sort underscores last (https://github.com/lukas-reineke/cmp-under-comparator)
            { "lukas-reineke/cmp-under-comparator", name = "nvim-cmp-under-comparator", lazy = true, event = "InsertEnter" },
    },
},
}, {
    install = {
        missing = true,
        colorscheme = { "catppuccin" }
    },
    diff = { cmd = "diffview.nvim" },
    checker = {
        enabled = true,
        concurrency = nil,
        notify = true,
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
                "matchparen",
                "tar",
                "tarPlugin",
                "rrhelper",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            }
        }
    }
})
-- ----------------------------------------------
-- End of Lazy loading
-- ----------------------------------------------

-- load extensions
require("telescope").load_extension("fzf")
require("telescope").load_extension("harpoon")

-- ----------------------------------------------
-- Treesitter
-- :help nvim-treesitter
-- ----------------------------------------------
require("nvim-treesitter.install").prefer_git = true

-- ----------------------------------------------
-- nvim-cmp: broadcast additional completion capabilities to lsp
-- ----------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- ----------------------------------------------
-- Mason: lsp configuration
-- :help mason
-- ----------------------------------------------
local mason_lspconfig = require("mason-lspconfig")
-- Enable the following language servers:
--   `filetypes` = default filetypes the language server will attach to
local mason_lsp_servers = {
    lua_ls = {
        Lua = {
            filetypes = "lua",
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
                globals = { "vim", }
            },
        },
    },
    pyre = { filetypes = "python" }, -- https://github.com/facebook/pyre-check
    bashls = { filetypes = "sh" },
    -- docker_compose_language_server = {},
    -- -- https://github.com/microsoft/vscode-json-languageservice
    -- jsonls = {},
    -- dockerls = {},
    -- nginx_language_server = { -- https://github.com/pappasam/nginx-language-server
    --     languageserver = {
    --         nginx_language_server = {
    --             command = "nginx-language-server",
    --             filetypes = { "nginx" },
    --             rootPatterns = { "nginx.conf", ".git" }
    --         }
    --     }
    -- },
    -- terraformls = {}, -- https://github.com/hashicorp/terraform-lsp
    -- -- https://github.com/terraform-linters/tflint
    -- -- plugin "terraform" {
    -- --    enabled = true
    -- --    preset  = "recommended"
    -- -- }
    -- tflint = {},
    -- yaml_language_server = {}, -- https://github.com/redhat-developer/yaml-language-server
}

mason_lspconfig.setup({ ensure_installed = mason_lsp_servers, })

mason_lspconfig.setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = keymap.lsp_on_attach,
            settings = mason_lsp_servers[server_name],
            filetypes = (mason_lsp_servers[server_name] or {}).filetypes,
        }
    end
}

-- ----------------------------------------------
-- nvim-cmp: setup (https://github.com/hrsh7th/nvim-cmp)
-- :help cmp
-- ----------------------------------------------
local cmp = require("cmp")
local cmp_compare = require("cmp.config.compare")
local luasnip = require("luasnip")

luasnip.config.setup {}

---@diagnostic disable either lua_ls isn"t recognizing optional params, or they"re not annotated correctly
keymap.cmp = cmp.setup {
    revision = 0,
    enabled = true,

    -- Customizations
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    comparators = {
        cmp_compare.offset,
        cmp_compare.exact,
        -- cmp_compare.scopes,
        cmp_compare.score,
        require("cmp-under-comparator").under,
        cmp_compare.recently_used,
        cmp_compare.locality,
        cmp_compare.kind,
        -- cmp_compare.sort_text,
        cmp_compare.length,
        cmp_compare.order,
    },

    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },

    -- Key mappings
    mapping = cmp.mapping.preset.insert {
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-f>"] = cmp.mapping.scroll_docs(-4),
        ["<C-u>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete {},
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
}

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" }
    }
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" }
    },
    {
        {
            name = "cmdline",
            option = {
                ignore_cmds = { "Man", "!" }
            }
        }
    }
    )
})
---@diagnostic enable

-- ----------------------------------------------
-- Catppuccin colorscheme: setup (https://github.com/catppuccin/nvim/tree/main)
-- :help catppuccin.txt
-- ----------------------------------------------
require("catppuccin").setup({
    dim_inactive = { enabled = false },
    highlight_overrides = {
        mocha = function(mocha)
            return {
                -- https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/groups/editor.lua
                CmpBorder = { fg = "#3e4145" },
                ColorColumn = { bg = mocha.base },
                CurSearch = { fg = mocha.base, bg = mocha.green },
                Cursor = { fg = mocha.crust },
                CursorLineNr = { fg = mocha.sapphire },
                Folded = { bg = mocha.surface0 },
                LineNr = { fg = mocha.surface1 },
                MsgArea = { bg = mocha.crust },
                Normal = { bg = mocha.mantle },
                Search = { fg = mocha.base, bg = mocha.sky },
                IndentBlanklineContextChar = { fg = mocha.surface1 },
            }
        end,
    },
    transparent_background = false,
    integrations = {
        cmp = true,
        fidget = true,
        gitsigns = true,
        harpoon = true,
        markdown = true,
        mason = true,
        mini = true,
        neotree = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
        indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
        },
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
            inlay_hints = {
                background = true,
            },
        },
    }
})
