-- ----------------------------------------------
-- auto-save.nvim (https://github.com/Pocco81/auto-save.nvim)
-- :help auto-save.nvim
-- ----------------------------------------------
return {
    "pocco81/auto-save.nvim",
    dependencies = {"neovim/nvim-lspconfig"},
    opts = {
        enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
        execution_message = {
            message = function() -- message to print on save
                return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
            end,
            dim = 0.18, -- dim the color of `message`
            cleaning_interval = 750, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
        },
        trigger_events = {"InsertLeave", "TextChanged"}, -- vim events that trigger auto-save. See :h events
        -- function that determines whether to save the current buffer or not
        -- return true: if buffer is ok to be saved
        -- return false: if it's not ok to be saved
        -- condition = function(buf)
        --         return true -- met condition(s), can save
        --     end
        --     return false -- can't save
        -- end,
        write_all_buffers = false, -- write all buffers when the current one meets `condition`
        debounce_delay = 3000, -- saves the file at most every `debounce_delay` milliseconds
        callbacks = { -- functions to be executed at different intervals
            enabling = nil, -- ran when enabling auto-save
            disabling = nil, -- ran when disabling auto-save
            before_asserting_save = nil, -- ran before checking `condition`

            -- ran before doing the actual save
            before_saving = function()
                local mini_trailspace = require("mini.trailspace")

                mini_trailspace.trim()
                mini_trailspace.trim_last_lines()
            end,

            -- ran after doing the actual save
            after_saving = function()
                local lint = require("lint")

                vim.cmd("LspRestart")
                lint.try_lint()
            end
        }
    }
}
