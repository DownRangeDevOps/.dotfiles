-- ----------------------------------------------
-- Helpers
-- ----------------------------------------------

-- Clear registers
vim.api.nvim_create_user_command(
    'ClearRegisters',
    function()
        local registers = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"*+'
        for reg in registers:gmatch(".") do
            pcall(vim.fn.setreg, reg, {})
        end
    end,
    { desc = 'Clear all registers' }
)
