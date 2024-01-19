local M = {}

-- ----------------------------------------------
-- Core
-- ----------------------------------------------
-- vim.env.PATH = vim.env.PATH .. vim.env.HOME .. "/.local/share/nvim/mason/bin/"
vim.env.EDITOR="nvr -cc split" -- prevent nested nvim instances
vim.g.auto_save = true -- used by auto-save autocmd
vim.g.netrw_altfile = 1

vim.o.lazyredraw = true
vim.o.mouse = "a"
vim.o.secure = true
vim.o.swapfile = false
vim.o.timeoutlen = 500
vim.o.undodir = os.getenv("HOME") .. "/.nvim/undo/"
vim.o.undofile = true
vim.o.updatetime = 250

vim.o.grepprg = table.concat({
    "${HOMEBREW_PREFIX}/bin/rg",
    " --follow",
    " --hidden",
    " --no-config",
    " --smart-case",
    " --colors 'match:style:bold'",
    " --colors 'match:fg:205,214,244'",
    " --colors 'match:bg:62,87,103'",
    " --glob '!.git'",
    " $@",
}, ",")

vim.o.diffopt = table.concat({
    "filler",
    "context:100",
    "iwhiteall",
    "horizontal",
    "linematch:60",
    "algorithm:histogram",
}, ",")

vim.o.viewoptions = table.concat({
    "cursor",
    "folds",
    "slash",
    "unix",
}, ",")

-- Providers
vim.g.node_host_prog = vim.env.HOMEBREW_PREFIX .. "/bin/neovim-node-host"
vim.g.perl_host_prog = vim.env.HOMEBREW_PREFIX .. "/bin/perl"
vim.g.python3_host_prog = "/Users/xjxf277/.pyenv/versions/3.11.5/bin/python"

-- Use rbenv bins
vim.env.GEM_HOME = vim.fn.trim(vim.fn.system("rbenv which gem"))
vim.env.GEM_PATH = vim.env.GEM_HOME
vim.env.PATH = vim.fn.trim(vim.fn.system("rbenv which ruby")):gsub("/ruby$", "") .. ":" .. vim.env.PATH
vim.g.ruby_host_prog = vim.fn.system("rbenv which neovim-ruby-host")

-- Files
vim.g.fileencoding = "ucs-bom,utf-8,latin1"
vim.o.bomb = false
vim.o.autochdir = false
vim.o.browsedir = "current"
vim.o.autoread = true
vim.o.autowriteall = false
vim.o.autowrite = false
vim.o.backup = false
vim.o.encoding = "utf-8"
vim.o.fixendofline = true

-- Vim command line completion
vim.o.completeopt = "menu,menuone,noinsert,noselect"
vim.o.fileignorecase = true
vim.g.wildmenu = true
vim.g.wildigorecase = false
vim.o.wildmode = "longest,full"
vim.opt.wildoptions:append("fuzzy,tagfile")
vim.o.wildignore = table.concat({
    "*/node_modules/*",
    "_site",
    "*.pyc",
    "*/__pycache__/",
    "*/venv/*",
    "*/target/*",
    "*/.vim$",
    "\\~$",
    "*/.log",
    "*/.aux",
    "*/.cls",
    "*/.aux",
    "*/.bbl",
    "*/.blg",
    "*/.fls",
    "*/.fdb*/",
    "*/.toc",
    "*/.out",
    "*/.glo",
    "*/.log",
    "*/.ist",
    "*/.fdb_latexmk",
}, ",")

-- ----------------------------------------------
-- UI
-- ----------------------------------------------
vim.o.autoindent = true
vim.o.backspace = "indent,eol,start" -- Make backspace behave in a sane manner.
vim.o.colorcolumn = "80"
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.hidden = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.number = true
vim.o.numberwidth = 5
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.list = true
vim.o.listchars = table.concat({
    "tab:⇢•",
    "precedes:«",
    "extends:»",
    "trail:•",
    "nbsp:•",
}, ",")

-- Line wrapping
vim.o.showbreak = "↳ " -- show wrapped lines
vim.o.wrap = false
vim.o.linebreak = true

-- Folding (nvim-ufo)
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = false

-- Terminal
-- :help guicursor
vim.o.shell = table.concat({
    vim.env.HOMEBREW_PREFIX .. "/bin/zsh",
    "--login",
}, " ")
vim.o.termguicolors = true
vim.o.guicursor = table.concat({
    "n-c-v-sm:block",
    "i-ci-ve:ver25",
    "r-cr-o:hor20",
    "a:blinkwait0-blinkoff500-blinkon500-Cursor/lCursor",
}, ",")

-- ----------------------------------------------
-- Editing
-- ----------------------------------------------
-- Editorconfig
vim.g.EditorConfig_exclude_patterns = { "fugitive://.\\*", "scp://.\\*" }

-- Insert
vim.o.shiftround = true
vim.o.expandtab = true
vim.o.shiftwidth = 4

-- Spelling
vim.o.spell = true
vim.o.spelllang = "en_us"

-- ----------------------------------------------
-- Plugins
-- ----------------------------------------------
vim.lsp.set_log_level("off")

local script_path = function()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
M.script_path = script_path()

return M
