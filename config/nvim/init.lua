-- Set first to ensure the correct leader key is used
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('commands')
require('plugins')
require('highlights')
require('keymap')
require('autocommands')
require('config')
