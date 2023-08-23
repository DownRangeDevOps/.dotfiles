-- ----------------------------------------------
-- Install package manager (https://github.com/folke/lazy.nvim)
-- :help lazy.nvim-lazy.nvim-installation
-- ----------------------------------------------
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

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
  -- Git managers
  'tpope/vim-fugitive', -- (git) https://github.com/tpope/vim-fugitive
  'tpope/vim-rhubarb', -- (hub) https://github.com/tpope/vim-rhubarb
  'tpope/fugitive-gitlab.vim', -- (gitlab) https://github.com/tpope/fugitive-gitlab.vim

  -- Vim user sovereign rights
  'tpope/vim-obsession', -- Session mgmt (https://github.com/tpope/vim-obsession)
  'tpope/vim-repeat', -- Repeat plugin maps (https://github.com/tpope/vim-repeat)
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically (https://github.com/tpope/vim-sleuth)
  'tpope/vim-surround', -- Surround text (https://github.com/tpope/vim-surround)
  { "tenxsoydev/karen-yank.nvim", config = true }, -- Make delete/change behave (https://github.com/tenxsoydev/karen-yank.nvim)
  { 'echasnovski/mini.nvim', version = '*' }, -- mini-align (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md)
  { 'numToStr/Comment.nvim', opts = {} }, -- Comment/un-comment with vim motions (https://github.com/numToStr/Comment.nvim)
  { 'windwp/nvim-autopairs', event = "InsertEnter", opts = {} }, -- auto-pairs (https://github.com/windwp/nvim-autopairs)
  'mbbill/undotree', -- Browse undo-tree (https://github.com/mbbill/undotree.git)
  'ThePrimeagen/harpoon', -- Quick-switch files (https://github.com/ThePrimeagen/harpoon)

  -- Auto complete rule: Underscores last (/) and command (:) (https://github.com/lukas-reineke/cmp-under-comparator)
  -- 'lukas-reineke/cmp-under-comparator',

  -- ----------------------------------------------
  -- UI
  -- ----------------------------------------------

  -- neo-tree: tree/file browser (https://github.com/nvim-neo-tree/neo-tree.nvim)
  -- :help neo-tree.txt
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  },

  -- Treesitter: Syntax and code navigation (https://github.com/nvim-treesitter/nvim-treesitter)
  -- :help treesitter.txt
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
      integrations = {
        gitsignts = true,
        harpoon = true,
        markdown = true,
        cmp = true,
        which_key = true,
        mason = true,
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
        component_separators = '|',
        section_separators = '',
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
      char = '┊',
      show_trailing_blankline_indent = false,
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
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {
      operators = {
        ys = 'Surround',
        gc = 'Comment',
      },
    },
  },

  -- git gutter signs and utils for managing changes (https://github.com/lewis6991/gitsigns.nvim)
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
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
        vim.keymap.set('n', '<leader>rh', require('gitsigns').reset_hunk, { buffer = bufnr, desc = '[R]eset [H]unk' })
        vim.keymap.set('n', '<leader>rh', require('gitsigns').stage_hunk, { buffer = bufnr, desc = '[S]tage [H]unk' })
      end,
    },
  },

  -- Trim whitespace and trailing empty lines (https://github.com/mcauley-penney/tidy.nvim)
  -- :help tidy.nvim.txt
  {
    'mcauley-penney/tidy.nvim',
    config = true,
    opts = {
      filetype_exclude = { 'diff' }
    }
  },

  -- Auto-save (https://github.com/pocco81/auto-save.nvim)
  {
    'okuuva/auto-save.nvim',
    cmd = 'ASToggle',
    event = { 'InsertLeave', 'TextChanged' },
    opts = {
      enabled = true,
      execution_message = {
        enabled = true,
        message = function()
          return ('auto-save ' .. vim.fn.strftime('(%H:%M:%S)'))
        end,
        dim = 0.80,
        cleaning_interval = 500, -- (milliseconds) to wait before clearing MsgArea
      },
      trigger_events = { -- See :h events
        immediate_save = { 'BufLeave', 'FocusLost' }, -- events that trigger immediate save
        defer_save = { 'InsertLeave', 'TextChanged' }, -- events that trigger deferred save
        cancel_defered_save = { 'InsertEnter' }, -- events that cancel a pending deferred save
      },
      condition = nil, -- callback to validate buffer save (return true|false, nil = disabled)
      write_all_buffers = false, -- write all buffers `condition` is met
      noautocmd = false, -- do not execute autocmds when saving
      debounce_delay = 1000, -- delay before executing pending save
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
    },
  },

  -- Fuzzy Finder
  {
    'nvim-telescope/telescope.nvim', -- https://github.com/nvim-telescope/telescope.nvim
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim', -- https://github.com/nvim-lua/plenary.nvim

      -- Dependencies that require `make`
      {
        'nvim-telescope/telescope-fzf-native.nvim', -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
        build = 'make', -- Trouble installing? https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation
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
local on_attach = function(_, bufnr) --  Runs when an LSP connects to a particular buffer
  local keymap = require('keymap')
  local nmap = keymap.nmap()
  local desc = keymap.desc()
  local fk = keymap.fk

  -- refactor
  nmap('<leader>rn', vim.lsp.buf.rename, desc('lsp', 'rename'))
  nmap('<leader>ca', vim.lsp.buf.code_action, desc('lsp', 'code action'))

  -- goto
  nmap('gd', vim.lsp.buf.definition, desc('lsp', 'goto definition'))
  nmap('gr', require('telescope.builtin').lsp_references, desc('lsp', 'goto references'))
  nmap('gI', vim.lsp.buf.implementation, desc('lsp', 'goto implementation'))

  -- Open manpages/help
  nmap('K', vim.lsp.buf.hover, desc('lsp', 'open documentation')) -- :help K
  nmap('<C-k>', vim.lsp.buf.signature_help, desc('lsp', 'open signature documentation'))

  nmap('<leader>D', vim.lsp.buf.type_definition, desc('lsp', 'type definition'))
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, desc('lsp', 'document symbols'))
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, desc('lsp', 'workspace symbols'))

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, desc('lsp', 'goto declaration'))
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, desc('lsp', 'workspace add folder'))
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, desc('lsp', 'workspace remove folder'))
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, desc('lsp', 'Workspace list folders'))

  -- Create a command `:Format` local to the LSP buffer and map it
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = desc('lsp', 'format current buffer') })
  nmap('<leader>=', ':Format' .. fk.enter, { desc = desc('lsp', 'format current buffer') })
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
    -- cmp_under_comparatar.under,
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
