-- ----------------------------------------------
-- edit-markdown-table.nvim: Edit and format markdown tables (https://github.com/kiran94/edit-markdown-table.nvim)
--
-- ----------------------------------------------
return {
    'kiran94/edit-markdown-table.nvim',
    lazy         = true,
    cmd          = "EditMarkdownTable",
    config       = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
}
