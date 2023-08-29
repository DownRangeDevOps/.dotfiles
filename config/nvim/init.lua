-- Set first to ensure the correct leader key is used
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('user-commands')
require('user-plugins')
require('user-highlights')
require('user-keymap')
require('user-autocommands')
require('user-config')
