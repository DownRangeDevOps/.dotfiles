local colors = require('catppuccin.palettes.mocha')
-- ----------------------------------------------
-- Plugins
-- ----------------------------------------------
-- indentation guides (https://github.com/lukas-reineke/indent-blankline.nvim)
-- :help indent_blankline.txt
vim.cmd.highlight(
    "IndentBlanklineContextChar"
    .. " guifg=" .. colors.overlay0
    .. " gui=nocombine"
)
