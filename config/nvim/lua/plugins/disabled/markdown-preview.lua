-- ----------------------------------------------
-- markdown-preview (https://github.com/iamcco/markdown-preview.nvim)
-- :help markdown-preview
-- ----------------------------------------------
local mkdp_theme = "dark"

return {
    "iamcco/markdown-preview.nvim",
    lazy = false,
    cmd = {
        "MarkdownPreview",
        "MarkdownPreviewStop",
        "MarkdownPreviewToggle",
    },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    config = function()
        vim.g.mkdp_auto_close = 1 -- Close preview window when associated buffer is closed
        vim.g.mkdp_echo_preview_url = 1
        vim.g.mkdp_markdown_css = vim.env.HOME .. "/.dotfiles/external/github-markdown-css/github-markdown-" .. mkdp_theme .. ".css"
        vim.g.mkdp_filetypes = { "markdown" } -- Attach MKDP commands to these filetypes
        vim.g.mkdp_page_title = vim.fn.expand("%:.")
        vim.g.mkdp_refresh_slow = 1
        vim.g.mkdp_theme = mkdp_theme
        -- vim.g.mkdp_browserfunc = function(url) os.execute("open '" .. url .. "'") end
        vim.g.mkdp_preview_options = {
            mkit = {},                     -- markdown-it options for render
            katex = {},                    -- katex options for math
            uml = {},                      -- markdown-it      -plantuml options
            maid = {},                     -- mermaid options
            disable_sync_scroll = 0,       -- disable sync scroll
            sync_scroll_type = "relative", -- 'middle', 'top' or 'relative'
            hide_yaml_meta = 1,            -- hide yaml metadata
            sequence_diagrams = {},        -- js-sequence-diagrams options
            flowchart_diagrams = {},
            content_editable = false,      -- content editable for preview page
            disable_filename = 1,          -- disable filename header for preview page
            toc = {}
        }
    end,
}
