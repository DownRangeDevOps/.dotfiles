-- Set first to ensure the correct leader key is used
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ----------------------------------------------
-- Plugins
-- ----------------------------------------------
-- blankline indent
local blankline_indet_session_opts = { "tabpages", "globals" }
for _, i in ipairs(blankline_indet_session_opts) do
    if not vim.opt.sessionoptions[i] then
        table.insert(vim.opt.sessionoptions, i)
    end
end

-- Configure dkarter/bullets.vim (https://github.com/dkarter/bullets.vim)
vim.g.bullets_set_mappings = 0
vim.g.bullets_renumber_on_change = 1
vim.g.bullets_outline_levels = { "num", "std*" }
vim.g.bullets_checkbox_markers = " ⁃✔︎"
vim.g.bullets_enabled_file_types = "markdown,text,gitcommit,scratch"
vim.g.bullets_enabled_file_types_tbl = { markdown = true, text = true, gitcommit = true, scratch = true }

require("user-commands")
require("user-plugins")
require("user-highlights")
require("user-autocommands")
require("user-keymap")
require("user-config")
