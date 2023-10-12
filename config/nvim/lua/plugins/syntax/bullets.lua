-- ----------------------------------------------
-- bullets", lazy = true, event "InsertEnter" }, -- bullet formatting (https://github.io/dkarter/bullets.vim)
-- :help bullets.vim
-- ----------------------------------------------
return {
    "dkarter/bullets.vim",
    lazy = true,
    event = "InsertEnter",
    ft = "markdown",
    init = function()
        vim.g.bullets_set_mappings = 0
        vim.g.bullets_renumber_on_change = 1
        vim.g.bullets_outline_levels = { "num", "std*" }
        vim.g.bullets_checkbox_markers = " ⁃✔︎"
        vim.g.bullets_enabled_file_types = "markdown,text,gitcommit,scratch"
        vim.g.bullets_enabled_file_types_tbl = { markdown = true, text = true, gitcommit = true, scratch = true }
    end,
}
