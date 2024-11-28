-- ----------------------------------------------
-- marks (https://github.com/chentoast/marks.nvim)
-- :help marks-nvim.txt
-- ----------------------------------------------
return {
    "yorickpeterse/nvim-window",
    keys = {
        {
            "<leader>,",
            "<cmd>lua require('nvim-window').pick()<cr>",
            desc = "nvim-window: Jump to window"
        },
    },
    opts = {
        chars = {
            "a",
            "s",
            "d",
            "f",
            "h",
            "j",
            "k",
            "l",
            "q",
            "w",
            "e",
            "r",
            "u",
            "i",
            "o",
            "p",
        },
        border = "rounded"
    },
    config = true,
}
