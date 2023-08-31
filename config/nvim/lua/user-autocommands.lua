-- local conf = require('config')
local keymap = require('user-keymap')

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
    pattern = '*',
    callback = function()
        if vim.env.NVIM_SESSION_FILE_PATH then
            vim.cmd.Obsession(vim.env.NVIM_SESSION_FILE_PATH) -- set by .envrc
        end
    end
})

-- ----------------------------------------------
-- UI
-- ----------------------------------------------
-- Enable relative line numbers in neo-tree
vim.api.nvim_create_autocmd( { 'BufWinEnter' }, {
    group = ui,
    pattern = 'neo-tree',
    command = 'setlocal relativenumber',
})

-- Set cursorline when search highlight is active
vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
    group = ui,
    pattern = '*',
    callback = function()
        if vim.opt.hlsearch:get() then
            vim.opt.cursorlineopt = 'both'
        else
            vim.opt.cursorlineopt = 'number'
        end
    end
})

-- Set scroll distance for <C-u> and <C-d>
vim.api.nvim_create_autocmd({ 'BufEnter', 'WinScrolled', 'VimResized' }, {
    group = ui,
    pattern = '*',
    callback = function()
        local cur_win_height = vim.fn.ceil(vim.api.nvim_win_get_height(0) * 0.66)
        if cur_win_height then vim.opt.scroll = cur_win_height end
    end
})

-- Set options for specific file and buffer types
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter', 'TabEnter', 'BufNew' }, {
    group = ui,
    pattern = '*',
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
            -- nofile = true,
            prompt = true,
        }

        local filetype = vim.bo.filetype
        local buftype = vim.bo.buftype

        filetype = filetype or "nofiletype"
        buftype = buftype or "nobuftype"

        if (clean_filetypes[filetype] or clean_buftypes[buftype]) then
            vim.wo.colorcolumn = false
            vim.wo.list = false
            vim.wo.number = false
            vim.wo.relativenumber = false
            vim.wo.spell = false
        else
            vim.opt.colorcolumn = '80'
            vim.opt.list = true
            vim.opt.number = true
            vim.opt.numberwidth = 5
            vim.opt.relativenumber = true
            vim.opt.listchars = table.concat({
                'tab:»·',
                'trail:·',
                'nbsp:·',
            }, ',')
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
            timeout = 250,
        })
    end,
})

-- ----------------------------------------------
-- User
-- ----------------------------------------------
-- Auto-Save
vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
    group = user,
    pattern = '*',
    callback = function()
        if vim.g.auto_save
            and vim.api.nvim_buf_get_option(0, 'buftype') == ''
            and vim.api.nvim_buf_get_option(0, 'modifiable') then

            vim.cmd.write()
            vim.fn.timer_start(1000, function() vim.cmd.echon('""') end)
        end
    end
})

-- Map/unmap shitty plugin auto bindings
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufLeave' }, {
    group = user,
    pattern = '*',
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
    pattern = '*',
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
    pattern = '*',
    callback = function()
        local bufnr = vim.fn.bufnr()

        if bufnr then
            keymap.thanos_snap(bufnr)
        end
    end
})

-- Protect large files from sourcing and other overhead
-- Files become read only
-- vim.api.nvim_create_autocmd({ 'BufReadPre' }, {
--     group = user,
--     pattern = '*',
--     callback = function()
--         local large_file = 1024 * 1024 * 10
--         local file = vim.fn.expand("<afile>")
--         local file_type = vim.fn.getftype(file)
--
--         if vim.fn.getfsize(file) > large_file then
--             vim.opt.eventignore:append(file_type)
--             vim.bo.noswapfile  = true
--             vim.bo.bufhidden = 'unload'
--             vim.bo.buftype = 'nowrite'
--             vim.opt.undolevels:remove(1)
--         else
--             vim.opt.eventignore:remove(file_type)
--         end
-- end, })
