-- ----------------------------------------------
-- Plugins
-- Listed here as a reminder/easy access
-- ----------------------------------------------

-- ----------------------------------------------
-- Helpers
-- ----------------------------------------------
-- Clear registers
vim.api.nvim_create_user_command(
    'CR',
    function()
        local registers = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"*+'
        for reg in registers:gmatch(".") do
            pcall(vim.fn.setreg, reg, {})
        end
    end,
    { desc = 'Clear all registers' }
)

-- Clear registers
--   command! -nargs=* Only call CloseHiddenBuffers()
vim.api.nvim_create_user_command(
    'CB',
    function()
        --  get all visible buffers in all tabs
        local visible = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            visible[vim.api.nvim_win_get_buf(win)] = true
        end

        -- close all hidden buffers
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if not visible[buf] then
                if vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
                    vim.cmd('bw! ' .. buf)
                else
                    vim.cmd.bw(buf)
                end
            end
        end
    end, { desc = 'Close all hidden buffers' }
)
