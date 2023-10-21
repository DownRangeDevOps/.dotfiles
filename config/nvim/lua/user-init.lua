-- Settings and dependencies for everything loaded after this
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load user settings
require("user-config")
require("user-keymap")
require("user-plugins")
require("user-commands")
require("user-diagnostics")
require("user-autocommands")
