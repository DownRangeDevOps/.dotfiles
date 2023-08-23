-- ----------------------------------------------
-- Core
-- ----------------------------------------------
vim.env.VISUAL = 'nvr -cc split --remote-wait' -- Prevent nested nvim instances
vim.opt.autochdir = true -- cd .
vim.opt.autoread = true -- read changed files
vim.opt.autowrite = true -- write before running command
vim.opt.backup = false
vim.opt.diffopt = table.concat({
  'filler',
  'context:100',
  'iwhiteall',
  'horizontal',
  'linematch:60',
  'algorithm:histogram',
}, ',')
vim.opt.lazyredraw = true
vim.opt.mouse = 'a'
vim.opt.secure = true
vim.opt.swapfile = false
vim.opt.timeoutlen = 750
vim.opt.undodir = os.getenv('HOME') .. '/.nvim/undo/'
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.viewoptions = table.concat({
  'cursor',
  'folds',
  'slash',
  'unix',
}, ',')

-- Files
vim.g.fileencoding = 'ucs-bom,utf-8,latin1'
vim.opt_global.bomb = false
vim.opt_global.encoding = 'utf-8'
vim.opt.fixendofline = true

-- Global vars
-- vim.opt_global.python3_host_prog = os.execute('pyenv which python')

-- Vim command line completion
vim.opt.completeopt = 'menuone,noselect'
vim.opt.wildignore = '*.o,*.a,__pycache__'
vim.opt.wildmode = 'list:lastused,list:full'

-- ----------------------------------------------
-- UI
-- ----------------------------------------------
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#202031' })
vim.opt.backspace = 'indent,eol,start' -- Make backspace behave in a sane manner.
vim.opt.colorcolumn = '80'
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.relativenumber = true
vim.opt.scrolloff = 8 -- never stray too far...
vim.opt.showbreak = '↳ ' -- Wrapped line
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.listchars = table.concat({
  'tab:»·',
  'trail:·',
  'nbsp:·',
}, ',')
vim.opt.list = true

-- Folding (nvim-ufo)
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Terminal
vim.opt.termguicolors = true -- Use 24-bit colors
vim.opt.guicursor = table.concat({
  'n-c-v-sm:block-Cursor/lCursor',
  'i-ci-ve:ver25-Cursor/lCursor',
  'r-cr-o:hor20-Cursor/lCursor',
  'a:blinkwait0-blinkoff500-blinkon500-Cursor/lCursor',
}, ',')

-- ----------------------------------------------
-- Editing
-- ----------------------------------------------
-- Insert
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Spelling
vim.opt.spell = true
vim.opt.spelllang = 'en_us'

-- ----------------------------------------------
-- Plugins
-- ----------------------------------------------
-- blankline indent
local blankline_indet_session_opts = { 'tabpages', 'globals' }
for _, i in ipairs(blankline_indet_session_opts) do
    if not vim.opt.sessionoptions[i] then
        table.insert(vim.opt.sessionoptions, i)
    end
end

-- Configure dkarter/bullets.vim (https://github.com/dkarter/bullets.vim)
vim.g.bullets_set_mappings = 0
vim.g.bullets_renumber_on_change = 1
vim.g.bullets_outline_levels = { 'num', 'std*' }
vim.g.bullets_checkbox_markers = ' ⁃✔︎'
vim.g.bullets_enabled_file_types = { 'markdown', 'text', 'gitcommit', 'scratch' }

-- Obsession
