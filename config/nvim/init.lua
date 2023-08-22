-- Set first to ensure the correct leader key is used
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('plugins')
require('autocommands')
require('keymap')
require('config')
