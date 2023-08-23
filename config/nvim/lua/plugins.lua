-- ----------------------------------------------
-- Install package manager (https://github.com/folke/lazy.nvim)
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
-- Install and configure plugins (https://github.com/folke/lazy.nvim)
-- :help lazy.nvim-lazy.nvim-plugin-spec
-- ----------------------------------------------
-- require('plugins')
require('lazy').setup({

    -- Git manager: vim-fugitive clone (https://github.com/dinhhuy258/git.nvim)
    {
        'dinhhuy258/git.nvim',
        config = true,
        opts = {
            default_mappings = false,
            target_branch = 'main',
        },
    },

    -- Vim user sovereign rights
    'ThePrimeagen/harpoon', -- Quick-switch files (https://github.com/ThePrimeagen/harpoon)
    'mbbill/undotree', -- Browse undo-tree (https://github.com/mbbill/undotree.git)
    'tpope/vim-obsession', -- Session mgmt (https://github.com/tpope/vim-obsession)
    'tpope/vim-repeat', -- Repeat plugin maps (https://github.com/tpope/vim-repeat)
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically (https://github.com/tpope/vim-sleuth)
    'tpope/vim-surround', -- Surround text (https://github.com/tpope/vim-surround)
    'tpope/vim-unimpaired', -- Navigation pairs like [q (https://github.com/tpope/vim-unimpaired)
    'zhimsel/vim-stay', --  Stay in your lane, vim! (https://github.com/zhimsel/vim-stay)
    { 'windwp/nvim-autopairs', event = "InsertEnter", opts = {} }, -- auto-pairs (https://github.com/windwp/nvim-autopairs)

    -- ----------------------------------------------
    -- mini.nvim
    -- ----------------------------------------------

    -- mini-align (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md)
    -- :help mini-align
    { 'echasnovski/mini.align', version = '*', config = true, },

    -- Comment/un-comment with vim motions (https://github.com/echasnovski/mini.comment)
    -- :help mini.comment
    { 'echasnovski/mini.comment', version = '*', config = true, },

    -- mini-jump, f/t over eol (https://github.io/echasnovski/mini.jump)
    -- :help mini.jump'
    { 'echasnovski/mini.jump', version = '*', config = true, },

    -- mini-starter: (https://github.io/echasnovski/mini.starter)
    -- :help mini-starter
    { 'echasnovski/mini.starter',
        version = '*',
        -- opts = {},
        config = true, },

    -- :help mini-trailspace
    -- mini-trailspace (https://github.com/cappyzawa/trim.nvim)
    { 'echasnovski/mini.trailspace', verion = '*', config = true, },

    -- Bullets (https://github.io/dkarter/bullets.vim)
    -- :help bullets
    'dkarter/bullets.vim',

    -- ----------------------------------------------
    -- UI
    -- ----------------------------------------------
    -- taboo.vim (https://github.com/gcmt/taboo.vim)
    -- :help taboo
    { 'gcmt/taboo.vim' },

    -- toggleterm.nvim (https://github.com/akinsho/toggleterm.nvim)
    -- :help toggleterm.nvim
    { 'akinsho/toggleterm.nvim', version = "*", config = true },

    -- nvim-ufo folds (https://github.com/kevinhwang91/nvim-ufo)
    -- :help nvim-ufo
    { 'kevinhwang91/nvim-ufo', config = true, dependencies = 'kevinhwang91/promise-async' },

    -- nvim-colorizer: (https://github.com/NvChad/nvim-colorizer.lua)
    -- :help nvim-colorizer
    { 'NvChad/nvim-colorizer.lua' },

    -- neo-tree: tree/file browser (https://github.com/nvim-neo-tree/neo-tree.nvim)
    -- :help neo-tree.txt
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        opts = {
            filesystem = {
                window = {
                    mappings = {
                        ["-"] = "navigate_up",
                        ["<C-r"] = "refresh",
                    }
                }
            }
        },
    },

    -- Treesitter: Syntax and code navigation (https://github.com/nvim-treesitter/nvim-treesitter)
    -- :help treesitter.txtt i
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects', -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        },
        build = ':TSUpdate',
    },

    -- Colorscheme/Theme
    -- :help catppuccin.txt
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        opts = {
            transparent_background = true,
            highlight_overrides = {
                mocha = function(latte)
                    return {
                        Cursor = { fg = latte.none },
                        CmpBorder = { fg = "#3e4145" },
                    }
                end,
            },
            integrations = {
                cmp = true,
                fidget = true,
                gitsignts = true,
                harpoon = true,
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
                -- shade = 'dark',
                -- percentage = 0.15
            }
        },
        config = function()
            vim.cmd.colorscheme 'catppuccin-mocha'
        end,
    },

    -- LuaLine
    -- :help lualine.txt
    {
        'nvim-lualine/lualine.nvim', -- https://github.com/nvim-lualine/lualine.nvim
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
        opts = {
            -- disable_with_nolist
            -- show_foldtext
            char = '┊',
            context_char = '┊',
            context_char_blankline = "",
            show_current_context = true,
            show_current_context_start = false,
            show_current_context_start_on_current_line = false,
            show_end_of_line = false,
            show_first_indent_level = false,
            show_trailing_blankline_indent = false,
            space_char = '·',
            space_char_blankline = '',
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
    -- [[ Utils ]]
    -- ----------------------------------------------
    -- Which-Key (https://github.com/folke/which-key.nvim)
    -- :help which-key.nvim.txt
    {
        'folke/which-key.nvim',
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

    -- Auto-save (https://github.com/pocco81/auto-save.nvim)
    {
        'okuuva/auto-save.nvim',
        cmd = 'ASToggle',
        event = { 'InsertLeave', 'TextChanged' },
        opts = {
            enabled = true,
            execution_message = { enabled = false },
            trigger_events = { -- See :h events
                immediate_save = { 'BufLeave', 'FocusLost' }, -- events that trigger immediate save
                defer_save = { 'InsertLeave', 'TextChanged' }, -- events that trigger deferred save
                cancel_defered_save = { 'InsertEnter' }, -- events that cancel a pending deferred save
            },
            condition = nil, -- callback to validate buffer save (return true|false, nil = disabled)
            write_all_buffers = false, -- write all buffers `condition` is met
            noautocmd = false, -- do not execute autocmds when saving
            debounce_delay = 5000, -- delay before executing pending save
            debug = false, -- log for debug messages (saved in neovim cache directory)
        },
    },

    -- ----------------------------------------------
    -- LSP Configuration & Plugins
    -- ----------------------------------------------
    {
        'neovim/nvim-lspconfig', -- https://github.com/neovim/nvim-lspconfig
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },  -- https://github.com/williamboman/mason.nvim
            'williamboman/mason-lspconfig.nvim', -- https://github.com/williamboman/mason-lspconfig.nvim

            -- Useful status updates for LSP
            { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} }, -- https://github.com/j-hui/fidget.nvim

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim', -- https://github.com/folke/neodev.nvim
        },
    },

    -- ----------------------------------------------
    -- Auto-completion
    -- ----------------------------------------------
    {
        'hrsh7th/nvim-cmp', -- https://github.com/hrsh7th/nvim-cmp
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
})

-- ----------------------------------------------
-- [[ LuaSnip ]]
-- ----------------------------------------------
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

-- ----------------------------------------------
-- [[ Neodev ]] (neovim lua help and completion)
-- ----------------------------------------------
require('neodev').setup()

-- ----------------------------------------------
-- [[ Telescope ]]
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
require('telescope').load_extension('harpoon')

-- ----------------------------------------------
-- [[ Treesitter ]]
-- :help nvim-treesitter
-- ----------------------------------------------
require('nvim-treesitter.install').prefer_git = true
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
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

    sync_install = false,
    ignore_install = { 'cpp' },
    modules = {}, -- make LSP happy

    auto_install = true, -- Autoinstall languages that are not installed

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        disable = { 'c' },
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
        },
    },

    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- LSP key maps
local on_attach = function(_, bufnr)
    local km = require('keymap')

    -- refactor
    km.map('n', '<leader>rn', vim.lsp.buf.rename, km.desc('lsp', 'rename'))
    km.map('n', '<leader>ca', vim.lsp.buf.code_action, km.desc('lsp', 'code action'))

    -- goto
    km.map('n', 'gd', vim.lsp.buf.definition, km.desc('lsp', 'goto definition'))
    km.map('n', 'gr', require('telescope.builtin').lsp_references, km.desc('lsp', 'goto references'))
    km.map('n', 'gI', vim.lsp.buf.implementation, km.desc('lsp', 'goto implementation'))

    -- Open manpages/help
    km.map('n', 'K', vim.lsp.buf.hover, km.desc('lsp', 'open documentation')) -- :help K
    km.map('n', '<C-k>', vim.lsp.buf.signature_help, km.desc('lsp', 'open signature documentation'))

    km.map('n', '<leader>D', vim.lsp.buf.type_definition, km.desc('lsp', 'type definition'))
    km.map('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, km.desc('lsp', 'document symbols'))
    km.map('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, km.desc('lsp', 'workspace symbols'))

    -- Lesser used LSP functionality
    km.map('n', 'gD', vim.lsp.buf.declaration, km.desc('lsp', 'goto declaration'))
    km.map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, km.desc('lsp', 'workspace add folder'))
    km.map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, km.desc('lsp', 'workspace remove folder'))
    km.map('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, km.desc('lsp', 'Workspace list folders'))

    -- Create a command `:Format` local to the LSP buffer and map it
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = km.desc('lsp', 'format current buffer') })
    km.map('n', '<leader>=', ':Format' .. km.enter, { desc = km.desc('lsp', 'format current buffer') })
end

-- ----------------------------------------------
-- [[ Mason ]]
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
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers), -- Ensure the servers above are installed
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
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
-- local cmp_under_comparatar = require('cmp-under-comparatar')


cmp.setup {
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
            select = true,
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
}
