local M = {}
local keymap = require('user-keymap')

-- ----------------------------------------------
-- Install Lazy.nvim (https://github.com/folke/lazy.nvim)
-- :help lazy.nvim-lazy.nvim-installation
-- ----------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- ----------------------------------------------
-- Load plugins (https://github.com/folke/lazy.nvim)
-- :help lazy.nvim-lazy.nvim-plugin-spec
-- ----------------------------------------------
require('lazy').setup({
    -- Vim user sovereign rights
    { 'ThePrimeagen/harpoon', lazy = false }, -- Quick-switch files (https://github.com/ThePrimeagen/harpoon)
    { 'mbbill/undotree', lazy = false }, -- Browse undo-tree (https://github.com/mbbill/undotree.git)
    { 'tpope/vim-obsession', lazy = false }, -- Session mgmt (https://github.com/tpope/vim-obsession)
    { 'tpope/vim-repeat', lazy = false }, -- Repeat plugin maps (https://github.com/tpope/vim-repeat)
    { 'tpope/vim-sleuth', lazy = true, event = "InsertEnter" }, -- Detect tabstop and shiftwidth automatically (https://github.com/tpope/vim-sleuth)
    { 'tpope/vim-surround', lazy = false, event = "InsertEnter" }, -- Surround text (https://github.com/tpope/vim-surround)
    { 'tpope/vim-unimpaired', lazy = false }, -- Navigation pairs like [q (https://github.com/tpope/vim-unimpaired)
    { 'zhimsel/vim-stay', lazy = false }, --  Stay in your lane, vim! (https://github.com/zhimsel/vim-stay)
    { 'windwp/nvim-autopairs', lazy = true, event = "InsertEnter", opts = {} }, -- auto-pairs (https://github.com/windwp/nvim-autopairs)

    { "nathom/filetype.nvim", lazy = true }, -- Replacement for slow filetype.vim builtin (https://github.com/nathom/filetype.nvim)

    -- Git manager: vim-fugitive clone (https://github.com/dinhhuy258/git.nvim)
    { 'dinhhuy258/git.nvim', lazy = true, event = 'CmdlineEnter', config = true,
        opts = { default_mappings = false, target_branch = 'main', },
    },

    -- ----------------------------------------------
    -- vim-rooter: cd to project root (https://github.com/airblade/vim-rooter)
    -- :help vim-rooter
    -- ----------------------------------------------
    {
        'airblade/vim-rooter',
        lazy = false,
        config = function()
            vim.g.rooter_buftypes = { '', 'nofile' }
            vim.g.rooter_patterns = { '.git' }
            vim.g.rooter_change_directory_for_non_project_files = 'home'
        end
    },

    -- ----------------------------------------------
    -- mini.nvim plugins (https://github.com/echasnovski/mini.nvim)
    -- ----------------------------------------------
    -- align/columns (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md)
    -- :help mini-align
    { 'echasnovski/mini.align', lazy = true, event = 'InsertEnter', version = '*', config = true, },

    -- comment/un-comment (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini.comment)
    -- :help mini.comment
    { 'echasnovski/mini.comment', lazy = false, version = '*', config = true, },

    -- mini-starter: (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini.starter)
    -- :help mini-starter
    {
        'echasnovski/mini.starter',
        lazy = false,
        version = '*',
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
            .. 'If you look for truth, you may find comfort in the end; if you look for\n'
            .. 'comfort you will not get either comfort or truth only soft soap and wishful\n'
            .. 'thinking to begin, and in the end, despair.\n'
            .. '                                         – C. S. Lewis\n'
            .. '\n'
            .. '"Everybody has a plan until they get punched in the mouth."\n'
            .. '                                         – Mike Tyson\n'
            .. '\n',

            -- Footer to be displayed after items. Converted to single string via
            -- `tostring` (use `\n` to display several lines). If function, it is
            -- evaluated first. If `nil` (default), default usage help will be shown.
            footer = nil,

            -- Array  of functions to be applied consecutively to initial content.
            -- Each function should take and return content for 'Starter' buffer (see
            -- |mini.starter| and |MiniStarter.content| for more details).
            content_hooks = nil,

            -- Characters to update query. Each character will have special buffer
            -- mapping overriding your global ones. Be careful to not add `:` as it
            -- allows you to go into command mode.
            query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',

            -- Whether to disable showing non-error feedback
            silent = false,
        },
        config = true,
    },

    -- mini-trailspace: delete trailing whitespace (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-trailspace.md)
    -- :help mini-trailspace
    { 'echasnovski/mini.trailspace', lazy = false, config = true, },

    -- bullet formatting (https://github.io/dkarter/bullets.vim)
    -- :help bullets
    { 'dkarter/bullets.vim', lazy = true, event = 'FileType ' .. table.concat(vim.g.bullets_enabled_file_types, ',') },

    -- colorscheme/theme (https://github.com/catppuccin/nvim/tree/main)
    -- :help catppuccin.txt
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        opts = {
            transparent_background = true,
            highlight_overrides = {
                theme = function(theme)
                    return {
                        CmpBorder = { fg = "#3e4145" },
                        CurSearch = { fg = theme.base, bg = theme.green },
                        Cursor = { fg = theme.none, bg = theme.saphire },
                        MsgArea = { bg = theme.crust },
                        Normal = { bg = theme.mantle },
                        Search = { fg = theme.base, bg = theme.sky },
                    }
                end,
            },
            integrations = {
                cmp = true,
                fidget = true,
                gitsignts = true,
                -- harpoon = true,
                markdown = true,
                mason = true,
                mini = true,
                neotree = true,
                telescope = true,
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
            },
            dim_inactive = {
                enabled = false,
                shade = 'base',
                percentage = 0.15,
            }
        },
        config = function()
            vim.cmd.colorscheme 'catppuccin-mocha'
        end,
    },

    -- taboo.vim: tab management (https://github.com/gcmt/taboo.vim)
    -- :help taboo
    { 'gcmt/taboo.vim', lazy = true, event = 'CmdlineEnter' },

    -- nvim-ufo folds (https://github.com/kevinhwang91/nvim-ufo)
    -- :help nvim-ufo
    -- { 'kevinhwang91/nvim-ufo', lazy = false, config = true, dependencies = 'kevinhwang91/promise-async' },

    -- nvim-colorizer: (https://github.com/NvChad/nvim-colorizer.lua)
    -- :help nvim-colorizer
    --
    -- Attach to buffer
    -- require("colorizer").attach_to_buffer(0, { mode = "background", css = true})
    --
    -- Detach from buffer
    -- require("colorizer").detach_from_buffer(0, { mode = "virtualtext", css = true})
    {
        'NvChad/nvim-colorizer.lua',
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
        lazy = false,
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        opts = {
            window = {
                position = "current",
                noremap = true,
                nowait = true,
                window = {
                    mappings = keymap.neo_tree
                },
            },
            filesystem = {
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
    },

    -- Treesitter: Syntax and code navigation (https://github.com/nvim-treesitter/nvim-treesitter)
    -- :help treesitter.txtt i
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects', -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        },
        build = ':TSUpdate',
    },

    -- LuaLine
    -- :help lualine.txt
    {
        'nvim-lualine/lualine.nvim', -- https://github.com/nvim-lualine/lualine.nvim
        lazy = false,
        opts = {
            options = {
                icons_enabled = false,
                theme = 'catppuccin',
                component_separators = '⁞',
                section_separators = { left = '', right = ''},
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
        'lukas-reineke/indent-blankline.nvim',
        lazy = false,
        opts = {
            char = '┊',
            context_char = '┊',
            context_char_blankline = '┊',
            show_current_context = true,
            show_current_context_start = false,
            show_current_context_start_on_current_line = false,
            show_end_of_line = false,
            show_first_indent_level = false,
            show_trailing_blankline_indent = true,
            space_char = '•',
            space_char_blankline = ' ',
            use_treesitter = true,
            use_treesitter_scope = true,
            viewport_buffer = 80,
            buftype_exclude = {
                "terminal",
                "nofile",
                "quickfix",
                "prompt",
            },
            filetype_exclude = {
                "lspinfo",
                "packer",
                "checkhealth",
                "help",
                "man",
                "qf",
                "",
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

    -- ----------------------------------------------
    --  Utils
    -- ----------------------------------------------
    -- Which-Key (https://github.com/folke/which-key.nvim)
    -- :help which-key.nvim.txt
    {
        'folke/which-key.nvim',
        lazy = false,
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
                '"',
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

    -- gitsigns (https://github.com/lewis6991/gitsigns.nvim)
    -- :help gitsigns.txt
    {
        'lewis6991/gitsigns.nvim',
        lazy = false,
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                changedelete = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                untracked    = { text = '┆' },
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>p', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'go prev hunk' })
                vim.keymap.set('n', '<leader>nh', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'go next hunk' })
                vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'preview hunk' })
                vim.keymap.set('n', '<leader>hu', require('gitsigns').reset_hunk, { buffer = bufnr, desc = 'reset hunk' })
                vim.keymap.set('n', '<leader>ha', require('gitsigns').stage_hunk, { buffer = bufnr, desc = 'stage hunk' })
            end,
        },
    },

    -- ----------------------------------------------
    -- LSP Configuration & Plugins
    -- ----------------------------------------------
    {
        'neovim/nvim-lspconfig', -- https://github.com/neovim/nvim-lspconfig
        lazy = false,
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },  -- https://github.com/williamboman/mason.nvim
            'williamboman/mason-lspconfig.nvim', -- https://github.com/williamboman/mason-lspconfig.nvim

            -- Useful status updates for LSP
            { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} }, -- https://github.com/j-hui/fidget.nvim

            -- Additional lua configuration, makes nvim stuff amazing!
            { 'folke/neodev.nvim', lazy = true } -- https://github.com/folke/neodev.nvim
        },
    },

    -- ----------------------------------------------
    -- CMP (https://github.com/hrsh7th/nvim-cmp)
    -- ----------------------------------------------
    {
        'hrsh7th/nvim-cmp',
        lazy = false,
        version = '2.*',
        build = 'make install_jsregexp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip', -- https://github.com/L3MON4D3/LuaSnip
            'saadparwaiz1/cmp_luasnip', -- https://github.com/saadparwaiz1/cmp_luasnip

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets', -- https://github.com/rafamadriz/friendly-snippets

            -- other recomended dependencies
            'hrsh7th/cmp-nvim-lsp', -- LSP completion capabilities (https://github.com/hrsh7th/cmp-nvim-lsp)
            'hrsh7th/cmp-buffer', -- Buffer words (https://github.com/hrsh7th/cmp-buffer)
            'hrsh7th/cmp-path', -- System paths (https://github.com/hrsh7th/cmp-buffer)
            'hrsh7th/cmp-cmdline', -- Search (/) and command (:) (https://github.com/hrsh7th/cmp-buffer)

            -- Auto complete rule: Underscores last (/) and command (:) (https://github.com/lukas-reineke/cmp-under-comparator)
            'lukas-reineke/cmp-under-comparator',
        },
    },

    -- Fuzzy Finder
    -- https://github.com/nvim-telescope/telescope.nvim
    -- :help telescope
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim', -- https://github.com/nvim-lua/plenary.nvim
            {
                -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
    },

    -- toggleterm (https://github.com/akinsho/toggleterm.nvim)
    -- :help toggleterm
    {
        "akinsho/toggleterm.nvim",
        lazy = false,
        version = "*",
        opts = {
            hide_numbers = true,
            shade_terminals = false,
            start_in_insert = true,
            insert_mappings = false,
            terminal_mappings = false,
            presist_size = true,
            presist_mode = true,
            direction = 'horizontal',
            shell = vim.env.BREW_PREFIX .. '/bin/bash --login',
            auto_scroll = true,
            border = 'curved',
            highlights = {
                Normal = {
                    guibg = '#11111b'
                },
                NormalFloat = {
                    guibg = '#11111b'
                },
                FloatBorder = {
                    guibg = '#11111b'
                },
            },
        },
    },
})
-- ----------------------------------------------
-- End of Lazy loading
-- ----------------------------------------------

-- ----------------------------------------------
--  LuaSnip
-- ----------------------------------------------
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

-- ----------------------------------------------
--  Neodev  (neovim lua help and completion)
-- ----------------------------------------------
require('neodev').setup()

-- ----------------------------------------------
--  Telescope
-- :help telescope
-- :help telescope.setup()
-- ----------------------------------------------
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
    },
}

-- extensions
pcall(require('telescope').load_extension, 'fzf') -- Enable telescope fzf native, if installed
-- require('telescope').load_extension('harpoon')

-- ----------------------------------------------
--  Treesitter
-- :help nvim-treesitter
-- ----------------------------------------------
require('nvim-treesitter.install').prefer_git = true
require('nvim-treesitter.configs').setup {
    sync_install = false,
    ignore_install = { 'cpp' },
    modules = {},
    auto_install = true, -- Autoinstall languages that are not installed
    ensure_installed = { -- Add languages to be installed here that you want installed for treesitter
        'bash',
        'c',
        'cmake',
        'css',
        'diff',
        'dockerfile',
        'git_config',
        'git_rebase',
        'gitcommit',
        'gitignore',
        'go',
        'hcl',
        'html',
        'ini',
        'javascript',
        'jq',
        'json',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'passwd',
        'python',
        'query',
        'regex',
        'ruby',
        'rust',
        'scss',
        'sql',
        'terraform',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        disable = { 'c' },
        keymaps = keymap.treesitter_km.incremental_selection
    },
    textobjects = {
        select = {
            keymaps = keymap.treesitter_km.textobjects
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = keymap.treesitter_km.move.goto_next_start,
            goto_next_end = keymap.treesitter_km.move.goto_next_end,
            goto_previous_start = keymap.treesitter_km.move.goto_previous_start,
            goto_previous_end = keymap.treesitter_km.move.goto_previous_end,
        },
        swap = {
            enable = true,
            swap_next = keymap.swap_next,
            swap_previous = keymap.swap_previous,
        },
    },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- ----------------------------------------------
--  Mason
-- :help mason
-- ----------------------------------------------
local mason_lspconfig = require 'mason-lspconfig'

-- Enable the following language servers
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
    -- bashls = {},
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
    -- pyre = {}, -- https://github.com/facebook/pyre-check
    -- terraformls = {}, -- https://github.com/hashicorp/terraform-lsp
    -- -- https://github.com/terraform-linters/tflint
    -- -- plugin "terraform" {
    -- --    enabled = true
    -- --    preset  = "recommended"
    -- -- }
    -- tflint = {},
    -- yaml_language_server = {}, -- https://github.com/redhat-developer/yaml-language-server
}

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers), -- Ensure the servers above are installed
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = keymap.lsp_on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
        }
    end
}

-- ----------------------------------------------
-- [[ nvim-cmp ]]
-- :help cmp
-- ----------------------------------------------
local cmp = require('cmp')
local cmp_default = require('cmp.config.default')
local cmp_compare = require('cmp.config.compare')


keymap.cmp = cmp.setup {
    revision = 0,
    enabled = true,

    -- Import defaults to appease LSP
    completion = cmp_default().completion,
    confirmation = cmp_default().confirmation,
    experimental = cmp_default().experimental,
    formatting = cmp_default().formatting,
    matching = cmp_default().matching,
    performance = cmp_default().performance,
    preselect = cmp_default().preselect,
    sorting = cmp_default().sorting,
    view = cmp_default().view,

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
        require('cmp-under-comparator').under,
        cmp_compare.recently_used,
        cmp_compare.locality,
        cmp_compare.kind,
        -- cmp_compare.sort_text,
        cmp_compare.length,
        cmp_compare.order,
    },

    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },

    -- Key mappings
    mapping = cmp.mapping.preset.insert {
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-f>'] = cmp.mapping.scroll_docs(-4),
        ['<C-u>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },

        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },

    -- Key mappings
    -- mapping = cmp.mapping.preset.insert {
    --     [ keymap.cmp_keys.select_next_item ] = cmp.mapping.select_next_item(),
    --     [ keymap.cmp_keys.select_prev_item ] = cmp.mapping.select_prev_item(),
    --     [ keymap.cmp_keys.scroll_docs_up ] = cmp.mapping.scroll_docs(4),
    --     [ keymap.cmp_keys.scroll_docs_down ] = cmp.mapping.scroll_docs(-4),
    --     [ keymap.cmp_keys.complete ] = cmp.mapping.complete {},
    --     [ keymap.cmp_keys.confirm ] = cmp.mapping.confirm {
    --         behavior = cmp.ConfirmBehavior.Replace,
    --         select = false,
    --     },
    --     [ keymap.cmp_keys.tab] = cmp.mapping(function(fallback)
    --         if cmp.visible() then
    --             cmp.select_next_item()
    --         elseif luasnip.expand_or_locally_jumpable() then
    --             luasnip.expand_or_jump()
    --         else
    --             fallback()
    --         end
    --     end, { 'i', 's' }),
    --     [ keymap.cmp_keys.shift_tab ] = cmp.mapping(function(fallback)
    --         if cmp.visible() then
    --             cmp.select_prev_item()
    --         elseif luasnip.locally_jumpable(-1) then
    --             luasnip.jump(-1)
    --         else
    --             fallback()
    --         end
    --     end, { 'i', 's' }),
    -- },
}

return M
