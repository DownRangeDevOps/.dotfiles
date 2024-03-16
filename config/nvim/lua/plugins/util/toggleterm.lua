-- ------------------------˚----------------------
-- toggleterm (https://github.com/akinsho/toggleterm.nvim)
-- :help toggleterm
-- ----------------------------------------------
local keymap = require("user-keymap")
return {
    "akinsho/toggleterm.nvim",
    lazy = false,
    -- cmd = "ToggleTerm",
    version = "*",
    init = function()
        local Terminal = require("toggleterm.terminal").Terminal

        local horizontal = Terminal:new({
            cmd = "zsh --login",
            direction = "horizontal",
            name="tterm",
            hidden = false,
        })

        local vertical = Terminal:new({
            cmd = "zsh --login",
            direction = "vertical",
            name="tterm",
            hidden = false,
        })

        local function horz_toggle()
            if vertical:is_open() then
                vertical:close()
            else
                horizontal:toggle(20)
            end
        end

        local function vert_toggle()
            if horizontal:is_open() then
                horizontal:close()
            else
                vertical:toggle(120)
            end
        end

        keymap.map("n", "`", function() horz_toggle() end, { group = "gen", desc = "bottom term" })
        keymap.map("n", "<leader>`", function() vert_toggle() end, { group = "gen", desc = "vertical term" })
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
        shell = "zsh --login",
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
