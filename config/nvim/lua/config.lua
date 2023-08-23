-- File encodings
vim.go.fileencodings = 'ucs-bom,utf-8,latin1'
vim.go.bomb = false
vim.go.fileencoding = 'utf-8'
vim.go.encoding = 'utf-8'

-- Core
vim.env.VISUAL = 'nvr -cc split --remote-wait' -- Prevent nested nvim instances
vim.o.autochdir = true -- cd .
vim.o.autoread = true -- read changed files
vim.o.autowrite = true -- write before running command
vim.o.backup = false
vim.o.diffopt = vim.o.diffopt .. ',vertical'
vim.o.lazyredraw = true
vim.o.secure = true
vim.o.swapfile = false
vim.o.undofile = true -- save undo history
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undo/"

-- Global vars
vim.g.python3_host_prog = os.execute('pyenv which python')
vim.g.is_bash = 1
vim.g.html_indent_tags = 'li\\|p'

-- Enable mouse mode
vim.o.mouse = 'a'

-- Decrease update time
vim.o.timeoutlen = 300
vim.o.updatetime = 250

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Open new splits to the right/bottom
vim.o.splitbelow = true
vim.o.splitright = true

-- Insert
vim.o.shiftround = true
vim.o.expandtab = true

-- UI
vim.o.scrolloff = 8
vim.o.backspace = 'indent,eol,start' -- Make backspace behave in a sane manner.
vim.o.colorcolumn = 80 -- Make it obvious where 80 characters is
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.listchars = 'tab:»·,trail:·,nbsp:·' -- Show whitespace
vim.o.number = true
vim.o.numberwidth = 5
vim.o.relativenumber = true
vim.o.showbreak = '↳ ' -- Wrapped line
-- vim.o.t_SI = "\\<ESC>]50;CursorShape=1\\x7"
-- vim.o.t_SR = "\\<ESC>]50;CursorShape=2\\x7"
-- vim.o.t_EI = "\\<ESC>]50;CursorShape=0\\x7"
-- vim.o.t_SI = "\\<ESC>Ptmux;\\<ESC>\\<ESC>]50;CursorShape=1\\x7\\<ESC>\\\\"
-- vim.o.t_SR = "\\<ESC>Ptmux;\\<ESC>\\<ESC>]50;CursorShape=2\\x7\\<ESC>\\\\"
-- vim.o.t_EI = "\\<ESC>Ptmux;\\<ESC>\\<ESC>]50;CursorShape=0\\x7\\<ESC>\\\\"

-- Customize highlights
vim.o.colorcolumn = 80
vim.api.nvim_set_hl(0, 'ColorColumn', { ctermbg=202031 })

-- Syntax and spelling
vim.o.spell = true
vim.o.spelllang = 'en_us'

-- Terminal
vim.o.termguicolors = true -- Use 24-bit colors
vim.o.guicursor = ''
  .. 'n-c-v-sm:block-Cursor/lCursor,'
  .. 'i-ci-ve:ver25-Cursor/lCursor,'
  .. 'r-cr-o:hor20-Cursor/lCursor,'
  .. 'a:blinkwait0-blinkoff500-blinkon500-Cursor/lCursor'
