-- ----------------------------------------------
-- toggleterm (https://github.com/akinsho/toggleterm.nvim)
-- :help toggleterm
-- ----------------------------------------------
return {
    "akinsho/toggleterm.nvim",
    lazy = true,
    cmd = "ToggleTerm",
    version = "*",
    opts = {
        hide_numbers = true,
        shade_terminals = false,
        start_in_insert = true,
        insert_mappings = false,
        terminal_mappings = false,
        presist_size = true,
        presist_mode = true,
        direction = "horizontal",
        shell = vim.env.BREW_PREFIX .. "/bin/bash --login",
        auto_scroll = true,
        border = "curve",
        highlights = {
            Normal = {
                guibg = "#11111b"
            },
            NormalFloat = {
                guibg = "#11111b"
            },
            FloatBorder = {
                guibg = "#11111b"
            },
        },
    },
}
