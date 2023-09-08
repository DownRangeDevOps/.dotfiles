-- ----------------------------------------------
-- markdown-preview (https://github.com/davidgranstrom/nvim-markdown-preview)
-- :help markdown-preview
-- ----------------------------------------------
return {
    "iamcco/markdown-preview.nvim",
    name = "markdown-preview",
    lazy = true,
    cmd = "MarkdownPreview",
    config = function() vim.fn["mkdp#util#install"]() end,
}
