-- ------------------------˚----------------------
-- toggleterm (https://github.com/akinsho/toggleterm.nvim)
-- :help toggleterm
-- ----------------------------------------------
local keymap = require("user-keymap")
return {
    "akinsho/toggleterm.nvim",
    lazy = false,
    version = "*",
    init = function()
        local term = require("toggleterm.terminal").Terminal:new({
            cmd = "zsh",
            name = "main",
            hidden = false,
        })

        local function toggle(direction)
            if term:is_open() then
                term:close()
            else
                local one_third_height = vim.fn.floor(vim.o.lines / 3)
                local min_height = 12

                local one_third_width = vim.fn.floor(vim.o.columns / 3)
                local min_width = 100

                term.direction = direction
                if direction == "horizontal" then
                    term:toggle(math.max(one_third_height, min_height))
                else
                    term:toggle(math.max(one_third_width, min_width))
                end
            end
        end

        keymap.map("n", "`", function() toggle("horizontal") end, { group = "gen", desc = "bottom term" })
        keymap.map("n", "<leader>`", function() toggle("vertical") end, { group = "gen", desc = "vertical term" })
    end,
    opts = {
        hide_numbers = false,
        shade_terminals = false,
        start_in_insert = true,
        insert_mappings = false,
        terminal_mappings = false,
        presist_size = false,
        presist_mode = false,
        direction = "horizontal",
        shell = "zsh",
        auto_scroll = true,
        border = "curve",
        highlights = {
            Normal = {
                guibg = "#030303"
            },
            NormalFloat = {
                guibg = "#030303"
            },
            FloatBorder = {
                guibg = "#030303"
            },
        },
    },
}
