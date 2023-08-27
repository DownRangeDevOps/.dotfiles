-- local conf = require('config')
local keymap = require('keymap')

-- ----------------------------------------------
-- Auto-command Groups
-- ----------------------------------------------
local nvim = vim.api.nvim_create_augroup('NVIM', { clear = true })
local ui = vim.api.nvim_create_augroup('UI', { clear = true })
local user = vim.api.nvim_create_augroup('USER', { clear = true })

-- ----------------------------------------------
-- Neovim
-- ----------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
    group = nvim,
    callback = function()
        if vim.env.NVIM_SESSION_FILE_PATH then
            vim.cmd.Obsession(vim.env.NVIM_SESSION_FILE_PATH) -- set by .envrc
        end
    end
})

-- ----------------------------------------------
-- UI
-- ----------------------------------------------
-- Set cursorline when search highlight is active
vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
    group = ui,
    callback = function()
        if vim.opt.hlsearch:get() then
            vim.opt.cursorline = true
        else
            vim.opt.cursorline = false
        end
    end
})

-- Set scroll distance for <C-u> and <C-d>
vim.api.nvim_create_autocmd({ 'BufEnter', 'WinScrolled', 'VimResized' }, {
    group = ui,
    callback = function()
        local cur_win_height = vim.fn.ceil(vim.api.nvim_win_get_height(0) * 0.66)
        if cur_win_height then vim.opt.scroll = cur_win_height end
    end
})

-- Set options for specific file and buffer types
vim.api.nvim_create_autocmd({ 'BufEnter', 'TabEnter', 'BufNew' }, {
    group = ui,
    callback = function()
        local clean_filetypes = {
            lspinfo = true,
            packer = true,
            checkhealth = true,
            help = true,
            man = true,
            qf = true,
        }
        local clean_buftypes = {
            help = true,
            quickfix = true,
            terminal = true,
            nofile = true,
            prompt = true,
        }
        local filetype = vim.bo.filetype
        local buftype = vim.bo.buftype

        filetype = filetype or "nofiletype"
        buftype = buftype or "nobuftype"

        if clean_filetypes[filetype] or clean_buftypes[buftype] then
            vim.wo.colorcolumn = false
            vim.wo.list = false
            vim.wo.number = false
            vim.wo.relativenumber = false
            vim.wo.spell = false
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
                vim.keymap.set('i', '<CR>', '<Plug>bullets-newline', { desc = keymap.desc('txt', 'bullets newline') })
                vim.keymap.set('n', 'o', '<Plug>(bullets-newline)', { desc = keymap.desc('txt', 'bullets newline') })
                vim.keymap.set('v', 'gN', '<Plug>(bullets-renumber)', { desc = keymap.desc('txt', 'bullets renumber') })
                vim.keymap.set('n', '<leader>x', '<Plug>(bullets-toggle-checkbox)', { desc = keymap.desc('txt', 'bullets toggle checkbox') })
                vim.keymap.set('i', '<C-t>', '<Plug>(bullets-demote)', { desc = keymap.desc('txt', 'bullets demote') })
                vim.keymap.set('i', '<C-d>', '<Plug>(bullets-promote)', { desc = keymap.desc('txt', 'bullets promote') })
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
vim.api.nvim_create_autocmd({ 'BufWritePre', 'InsertLeave' }, {
    group = user,
    callback = function()
        if vim.api.nvim_buf_get_option(0, 'modifiable') then
            MiniTrailspace.trim()
            MiniTrailspace.trim_last_lines()
        end
    end
})

-- Overpower some buffers
vim.api.nvim_create_autocmd({ 'WinEnter' }, {
    group = user,
    callback = function()
        local bufnr = vim.fn.bufnr()

        if bufnr then
            keymap.thanos_snap(bufnr)
        end
    end
})
