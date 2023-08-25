local km = require('keymap')
local nvim = vim.api.nvim_create_augroup('NVIM', { clear = true })
local ui = vim.api.nvim_create_augroup('UI', { clear = true })
local user = vim.api.nvim_create_augroup('USER', { clear = true })

-- ----------------------------------------------
-- Neovim
-- ----------------------------------------------
-- vim.api.nvim_create_autocmd("VimEnter", {
--     group = nvim,
--     callback = function()
--         if vim.env.NVIM_SESSION_FILE_PATH then
--             vim.cmd.Obsession(vim.env.NVIM_SESSION_FILE_PATH)
--         end
--     end
-- })

-- ----------------------------------------------
-- UI
-- ----------------------------------------------
-- Set scroll to 80% of win_height & bind CTRL-U to CTRL-B
vim.api.nvim_create_autocmd({ 'WinScrolled', 'VimResized' }, {
    group = ui,
    callback = function()
        local cur_win_height = vim.fn.ceil(vim.api.nvim_win_get_height(0) * 0.8)
        if cur_win_height then vim.opt.scroll = cur_win_height end
    end
})

-- Plugins that fuck with options dynamically by default are satanic
vim.api.nvim_create_autocmd({ 'BufEnter', 'TabEnter', 'BufNew' }, {
    group = ui,
    callback = function()
        local ignore_filetypes = { 'lspinfo', 'packer', 'checkhealth', 'help', 'man', 'qf', '' }
        local ignore_buftypes = { 'help', 'quickfix', 'terminal', 'nofile', 'prompt' }

        if ignore_filetypes[vim.bo.filetype] or ignore_buftypes[vim.bo.buftype] then
            vim.b.minipairs_disable = true
            vim.opt.colorcolumn = false
            vim.opt.list = false
            vim.opt.number = false
            vim.opt.relativenumber = false
            vim.opt.spell = false
        else
            vim.opt.list = true
            vim.opt.number = true
            vim.opt.numberwidth = 5
            vim.opt.relativenumber = true
        end
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    group = user,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'Question',
            timeout = 150,
        })
    end,
})

-- ----------------------------------------------
-- User
-- ----------------------------------------------
-- Map/unmap shitty plugin auto bindings
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufLeave' }, {
    group = user,
    callback = function()
        local bullets_buftypes, err = pcall(function()
            vim.g.bullets_enabled_file_types()
        end)

        if not err then
            if bullets_buftypes[vim.opt:get('buftype')] then
                vim.keymap.set('i', '<CR>', '<Plug>bullets-newline', { desc = km.desc('txt', 'bullets newline') })
                vim.keymap.set('n', 'o', '<Plug>(bullets-newline)', { desc = km.desc('txt', 'bullets newline') })
                vim.keymap.set('v', 'gN', '<Plug>(bullets-renumber)', { desc = km.desc('txt', 'bullets renumber') })
                vim.keymap.set('n', '<leader>x', '<Plug>(bullets-toggle-checkbox)', { desc = km.desc('txt', 'bullets toggle checkbox') })
                vim.keymap.set('i', '<C-t>', '<Plug>(bullets-demote)', { desc = km.desc('txt', 'bullets demote') })
                vim.keymap.set('i', '<C-d>', '<Plug>(bullets-promote)', { desc = km.desc('txt', 'bullets promote') })
            else
                vim.keymap.set('i', '<CR>', '<CR>')
                vim.keymap.set('n', 'o', 'o')
                vim.keymap.del('v', 'gN')
                vim.keymap.del('n', '<leader>x')
                vim.keymap.del('i', '<C-t>')
                vim.keymap.del('i', '<C-d>')
            end
        end
    end,
})

-- Trim trailing white-space/lines
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = user,
    callback = function()
        MiniTrailspace.trim()
        MiniTrailspace.trim_last_lines()
    end
})

-- Overpower some buffers
vim.api.nvim_create_autocmd({ 'WinEnter' }, {
    group = user,
    callback = function()
        local bufnr = vim.fn.bufnr()

        if bufnr then
            km.snap(bufnr)
        end
    end
})
