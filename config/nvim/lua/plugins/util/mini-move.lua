-- ----------------------------------------------
-- mini-move: (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-move)
-- :help mini-move
-- ----------------------------------------------
return {
    "echasnovski/mini.move",
    lazy = false,
    version = "*",
    config = true,
    opts = {
        mappings = {
            -- Move visual selection
            left = "<S-h>",
            right = "<S-l>",
            down = "<S-j>",
            up = "<S-k>",

                -- Move current line in normal mode
                line_left = "",
                line_right = "",
                line_down = "",
                line_up = "",
            },
            options = {
                reindent_linewise = true, -- re-indent selection during vertical move
            },
        }
}
