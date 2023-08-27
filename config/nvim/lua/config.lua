-- ----------------------------------------------
-- Core
-- ----------------------------------------------
vim.env.VISUAL = 'nvr -cc split --remote-wait' -- Prevent nested nvim instances
vim.opt.diffopt = table.concat({
  'filler',
  'context:100',
  'iwhiteall',
  'horizontal',
  'linematch:60',
  'algorithm:histogram',
}, ',')

-- vim.opt.isfname:append("{,}") -- expand variables before gf, gF
vim.opt.lazyredraw = true
vim.opt.mouse = 'a'
vim.opt.secure = true
vim.opt.swapfile = false
vim.opt.timeoutlen = 750
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undo/'
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
vim.opt.bomb = false
vim.opt.autochdir = true
vim.opt.browsedir = "current"
vim.opt.autoread = true
vim.opt.autowriteall = true
vim.opt.autowrite = true
vim.opt.backup = false
vim.opt.encoding = 'utf-8'
vim.opt.fixendofline = true

-- Global vars
-- vim.opt.python3_host_prog = os.execute('pyenv which python')

-- Vim command line completion
vim.opt.completeopt = 'menu,menuone,noinsert,noselect'
vim.opt.fileignorecase = true
vim.g.wildmenu = true
vim.g.wildigorecase = true
vim.opt.wildmode = 'list,full'
vim.opt.wildoptions = "fuzzy,tagfile"
vim.opt.wildignore = table.concat({
    '*/node_modules/*',
    '_site',
    '*.pyc',
    '*/__pycache__/',
    '*/venv/*',
    '*/target/*',
    '*/.vim$',
    '\\~$',
    '*/.log',
    '*/.aux',
    '*/.cls',
    '*/.aux',
    '*/.bbl',
    '*/.blg',
    '*/.fls',
    '*/.fdb*/',
    '*/.toc',
    '*/.out',
    '*/.glo',
    '*/.log',
    '*/.ist',
    '*/.fdb_latexmk',
})

-- ----------------------------------------------
-- UI
-- ----------------------------------------------
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#202031' })
vim.opt.autoindent = true
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
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

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

-- Catppuchin
