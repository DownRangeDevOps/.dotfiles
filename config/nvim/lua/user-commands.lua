-- ----------------------------------------------
-- Plugins
-- Listed here as a reminder/easy access
-- ----------------------------------------------

-- ----------------------------------------------
-- Helpers
-- ----------------------------------------------
-- Toggle auto-save
vim.api.nvim_create_user_command(
    'AutoSaveToggle',
    function()
        vim.g.auto_save = not vim.g.auto_save

        local msg = vim.g.auto_save and 'enabled' or 'disabled'
        vim.cmd.echo('"AutoSave ' .. msg .. '"')
    end,
    { desc = 'Toggle AutoSave' }
)

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
vim.api.nvim_create_user_command('DR', 'ClearRegisters', { desc = 'Clear all registers'})
vim.api.nvim_create_user_command('CR', 'ClearRegisters', { desc = 'Clear all registers'})

-- Clear buffers
vim.api.nvim_create_user_command(
    'WipeAllBuffers',
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
    end,
    { desc = 'Close all hidden buffers' }
)
vim.api.nvim_create_user_command('Ca', 'WipeAllBuffers', { desc = 'Close all hidden buffers' })
vim.api.nvim_create_user_command('CloseAll', 'WipeAllBuffers', { desc = 'Close all hidden buffers' })

-- Typos
vim.api.nvim_create_user_command('W', function() vim.cmd.write() end, { desc = 'write'})
vim.api.nvim_create_user_command('Wa', function() vim.cmd.wall() end, { desc = 'wall'})
vim.api.nvim_create_user_command('Wqa', function() vim.cmd.wqall() end, { desc = 'wqall'})
vim.api.nvim_create_user_command('Qa', function() vim.cmd.wqall() end, { desc = 'qall'})
