-- ----------------------------------------------
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

        local _tterm_horizontal = Terminal:new({
            cmd = "${HOMEBREW_PREFIX}/bin/zsh --login; source ${HOME}/.bash_profile",
            direction = "horizontal",
            name="tterm",
            hidden = false,
        })

        local _tterm_vertical = Terminal:new({
            cmd = "${HOMEBREW_PREFIX}/bin/zsh --login; source ${HOME}/.bash_profile",
            direction = "vertical",
            name="tterm",
            hidden = false,
        })

        function horz_toggle()
            _tterm_horizontal:toggle(20)
        end

        function vert_toggle()
            _tterm_vertical:toggle(120)
        end

        keymap.map("n", "`", "<cmd>lua horz_toggle()<CR>", { group = "gen", desc = "bottom term" })
        keymap.map("n", "<leader>`", "<cmd>lua vert_toggle()<CR>", { group = "gen", desc = "vertical term" })
    end,
    opts = {
        -- size = function(term)
        --     if term.direction == "horizontal" then
        --         return 20
        --     elseif term.direction == "vertical" then
        --         return 120
        --     end
        -- end,
        hide_numbers = true,
        shade_terminals = false,
        start_in_insert = true,
        insert_mappings = false,
        terminal_mappings = false,
        presist_size = true,
        presist_mode = true,
        direction = "horizontal",
        shell = vim.o.shell,
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
