-- ----------------------------------------------
-- Core
-- ----------------------------------------------
vim.env.TERM = "iterm2"
vim.env.EDITOR="nvr -cc split" -- prevent nested nvim instances
vim.g.auto_save = true -- used by auto-save autocmd
vim.g.netrw_altfile = 1

vim.o.lazyredraw = true
vim.o.mouse = "a"
vim.o.secure = true
vim.o.swapfile = false
vim.o.timeoutlen = 500
vim.o.undofile = true
vim.o.updatetime = 250

vim.o.grepprg = "${HOMEBREW_PREFIX}/bin/rg $@"

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

-- Files
vim.g.fileencoding = "ucs-bom,utf-8,latin1"
vim.o.bomb = false
vim.o.autochdir = false
-- vim.o.browsedir = "current"
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
vim.o.list = true
vim.o.number = true
vim.o.numberwidth = 5
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.scrollback = 100000
vim.o.showtabline = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.opt.sessionoptions:append("tabpages","globals")

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
vim.o.breakindent = true

-- Formatting
vim.o.formatoptions = vim.o.formatoptions .. "n" -- Recognize numbered lists
vim.o.formatlistpat = [[^\\s*\\d\\+[\\]:.)}\\t ]\\s*\\\|^\\s*[-*+]\\s\\+]]

-- Folding (nvim-ufo)
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = false

-- Terminal
-- :help guicursor
-- vim.o.shell = vim.env.HOMEBREW_PREFIX .. "/bin/zsh"
vim.g.shell = "zsh --login"
vim.o.termguicolors = true

-- Configure custom cursor styling for different modes in NeoVim.
-- This setting defines how the cursor appears in various modes:
--
-- * "n-c-v-sm:block": Normal, Command-line, Visual, and Select modes use a block cursor.
-- * "i-ci-ve:ver25": Insert, Command-line Insert, and Visual Exclusive modes use a vertical bar cursor (25% width).
-- * "r-cr-o:hor20": Replace, Command-line Replace, and Operator-pending modes use a horizontal bar cursor (20% height).
-- * "a:blinkwait0-blinkoff500-blinkon500-Cursor/lCursor": All modes use a blinking cursor with:
--     * No initial delay (blinkwait0)
--     * 500ms off time (blinkoff500)
--     * 500ms on time (blinkon500)
--     * Custom cursor shapes defined by "Cursor" and "lCursor" highlight groups.

vim.o.guicursor = table.concat({
    "n-c-v-sm:block", -- Block cursor for Normal, Command-line, Visual, and Select modes
    "i-ci-ve:ver25",  -- Vertical bar cursor (25% width) for Insert, Command-line Insert, and Visual Exclusive modes
    "r-cr-o:hor20",   -- Horizontal bar cursor (20% height) for Replace, Command-line Replace, and Operator-pending modes
    "a:blinkwait0-blinkoff500-blinkon500-Cursor/lCursor", -- Blinking cursor with custom timing and highlight groups
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
-- Settings and dependencies for everything loaded after this
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.undodir = os.getenv("HOME") .. "/.nvim/undo/"

-- Ensure ASDF shims are in the path
vim.env.PATH = os.getenv("HOME") .. "/.asdf/shims:" .. vim.env.PATH

-- Add the asdf-installed luarocks path to package.path and package.cpath
local home = os.getenv("HOME")
local asdf_luarocks_path = home .. "/.asdf/installs/lua/5.1/luarocks"
package.path = asdf_luarocks_path .. "/share/lua/5.1/?.lua;" ..
               asdf_luarocks_path .. "/share/lua/5.1/?/init.lua;" ..
               package.path
package.cpath = asdf_luarocks_path .. "/lib/lua/5.1/?.so;" .. package.cpath

-- Externally installed providers
vim.g.loaded_perl_provider = vim.env.HOMEBREW_PREFIX .. "/bin/perl"
vim.g.python3_host_prog = vim.env.HOME .. "/.asdf/shims/python"
vim.g.loaded_node_provider =

-- Load user settings
require("user-keymap")
require("user-plugins")
require("user-commands")
require("user-diagnostics")
require("user-autocommands")
