-- ----------------------------------------------
-- Helpers
-- ----------------------------------------------
--
-- trying to figure out metatables
-- local function require_arg(arg)
--   assert(arg ~= nil, arg .. ' argument required')
--   return arg
-- end
--
-- local mt_require_arg = {
--   __call = function(fn, ...)
--     local args = {...}
--
--     for i, arg in ipairs(args) do
--       args[i] = require_arg(arg)
--     end
--
--   return fn(unpack(args))
--   end
-- }

local bin = {
    bash = '$(brew --prefix)/bin/bash --login'
}

local fk = {
    escape = '<Esc>',
    enter = '<CR>',
    space = '<Space>',
}

local function get_project_root()
    local dir = '.'

    if os.execute('git rev-parse') then
        local stdout, err = io.popen("git rev-parse --show-toplevel")

        if stdout then
            dir = stdout:read("*a")
            stdout:close()
        else
            error("Failed: " .. err, vim.log.levels.DEBUG)
        end
    end

    return dir
end

local project_root = get_project_root()

-- Mapping
local map = function(mode, lhs, rhs, opts)
    --- Shortcut for vim.keymap.set
    --
    -- @param mode:string|table ('n'|'i'|'v'|'c'|'t')
    -- @param keys:string
    -- @param func:string|func
    -- @param opts:table|nil
    assert(tostring(mode), 'invalid argument: mode string required')
    assert(tostring(lhs), 'invalid argument: lhs string required')
    assert(tostring(rhs), 'invalid argument: rhs string required')

    if opts then
        vim.keymap.set(mode, lhs, rhs, opts)
    else
        vim.keymap.set(mode, lhs, rhs)
    end
end

local desc = function(group, desc)
    --- Prefix descriptions with a group
    --
    -- @param group:string Group prefix (cond|diag|file|gen|lsp|nav|tog|ts)
    -- @param desc:string Description
    local groups = {
        cond = 'Cond: ',
        diag = 'Diag: ',
        file = 'File: ',
        gen = 'Gen: ',
        git = 'Git: ',
        lsp = 'LSP: ',
        nav = 'Nav: ',
        tog = 'Togg: ',
        ts = 'TS: ',
        txt = 'TXT: ',
        ui = 'UI: ',
    }

    if groups[group] then
        desc = groups[group] .. desc
    end

    return desc
end

-- You should have gone for the head...
local thanos_snap = function(bufnr)
    local modifiable = vim.api.nvim_buf_get_option(bufnr, 'modifiable')
    local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    local the_unfortunate = { 'help', 'qf', 'man', 'checkhouth', 'lspinfo', 'checkhealth' }
    local the_disgraced = { 'quickfix', 'prompt', 'nofile' }

    if not modifiable then
        if bufnr and (the_unfortunate[filetype] or the_disgraced[buftype]) then
            map('n', 'q', ':quit', { buffer = bufnr, desc = desc('gui', "don't @ me") })
        end
    end
end

local helpers = {
    fk = fk,
    desc = desc,
    snap = thanos_snap,
}

-- ----------------------------------------------
-- Keymaps
-- ----------------------------------------------
-- Clear search highlight
vim.on_key(
    function(char)
        if vim.fn.mode() == "n" then
            local new_hlsearch = vim.tbl_contains(
                { "n", "N", "*", "?", "/", "v" },
                vim.fn.keytrans(char)
            )

            if vim.opt.hlsearch:get() ~= new_hlsearch then
                vim.opt.hlsearch = new_hlsearch
            end
        end
    end,
    vim.api.nvim_create_namespace "auto_hlsearch"
)

-- QOL
map('i', 'jj', fk.escape, { desc = desc('gen', 'Escape') })
map('i', '<C-c', fk.escape) -- fml
map('n', 'gl', 'gu') -- err 'go lower' sure makes sense to me...
map('n', 'gL', 'gu') -- err 'go lower' sure makes sense to me...
map('n', 'Q', '<nop>') -- rreeeeeeeeeeeee
map('n', 'gQ', '<nop>') -- get off my lawn
map('n', '<C-u>', '<C-b') -- can't be bothered to switch to the proper keys...
map('c', '<C-f>', '<nop>') -- up arrow works fuuuuuuu

-- Karen without Karenness
-- NOTE: test for a while then add response:
-- (https://stackoverflow.com/questions/11993851/how-to-delete-not-cut-in-vim)
--
-- Copy/paste to/from system clipboard
-- map('', '<leader>y', '"+y', { desc = desc('gen', 'copy to system clipboard') })
-- map('n', '<leader>Y', '"+y$', { desc = desc('gen', 'copy -> eol to system clipboard') })
-- map('v', '<LeftRelease>', '"+y<LeftRelease>', { desc = desc('gen', 'copy on mouse select') })
-- map('n', '<leader>yy', '"+yy', { desc = desc('gen', 'copy line to system clipboard') })
-- map('n', '<leader>p', '"+p', { desc = desc('gen', 'paste system clipboard') })
--
-- delete
-- map('n', "d", '"_d', { expr = true, desc = desc('txt', 'delete') })
-- map('n', "D", '"_D', { expr = true, desc = desc('txt', 'delete -> eol') })
map('n', "<leader>d", "d", { expr = true, desc = desc('txt', 'yank-delete') })
-- map('n', "<leader>D", "D", { expr = true, desc = desc('txt', 'yank-delete -> eol') })
--
-- cut
-- map("", "c", '"_c', { expr = true, desc = desc('txt', 'change') })
-- map("", "C", '"_C', { expr = true, desc = desc('txt', 'change -> eol') })
-- map("", "<leader>c", "c", { expr = true , desc = desc('txt', 'yank-change')})
-- map("", "<leader>C", "C", { expr = true , desc = desc('txt', 'yank-change -> eol')})
--
-- paste
-- map('n', "p", '"_dp', { expr = true, desc = desc('txt', 'paste') })
-- map('n', "P", '"_dP', { expr = true, desc = desc('txt', 'paste after') })
-- map('v', "p", '"_dgvp', { expr = true, desc = desc('txt', 'paste') })
-- map('v', "P", '"_dgvP', { expr = true, desc = desc('txt', 'paste after') })
-- map('v', "<leader>p", "ygvp", { expr = true, desc = desc('txt', 'yank-paste after') })
-- map('v', "<leader>P", "ygvP", { expr = true, desc = desc('txt', 'yank-paste after') })
--
-- Manipulate lines, maintain cursor pos
map('v', 'J', ':m \'>+1' .. fk.enter .. 'gv=gv', { desc = desc('txt', 'move lines up') })
map('v', 'K', ':m \'<-2' .. fk.enter .. 'gv=gv', { desc = desc('txt', 'move lines down')} )
map('n', 'J', 'mzJ`z', { desc = desc('txt', 'join w/o hop') })
map('n', '<C-u>', '<C-u>zz', { desc = desc('gen', 'pgup') })
map('n', '<C-d>', '<C-d>zz', { desc = desc('gen', 'pgdn') })
map('n', 'n', 'nzzzv', { desc = desc('next search') })
map('n', 'N', 'Nzzzv', { desc = desc('prev search') })

-- File management
map('n', '<leader>1', function() vim.cmd(
    'Neotree action=focus source=filesystem position=current toggle reveal') end,
    { silent = true, desc = desc('file', 'open browser') })
map('n', '<leader>2', function() vim.cmd(
    'Neotree action=show source=filesystem position=left toggle reveal') end,
    { silent = true, desc = desc('file', 'open sidebar browser') })
map('n', '<leader>w', vim.cmd.write, { silent = true, desc = desc('file', 'write to file') })
map('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = desc('file', 'open undo-tree' ) })
map('n', '<leader>x', function() vim.cmd([[chmod +x %]]) end, { desc = desc('file', 'make file +x') })

-- Harpoon (https://github.com/ThePrimeagen/harpoon)
-- :help harpoon
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")
map('n', '<leader>hf', harpoon_mark.toggle_file, { desc = desc('file', 'harpoon/release') })
map('n', '<leader>j', function() harpoon_ui.nav_file(1) end, { desc = desc('file', 'first harpoon') })
map('n', '<leader>k', function() harpoon_ui.nav_file(2) end, { desc = desc('file', 'second harpoon') })
map('n', '<leader>l', function() harpoon_ui.nav_file(3) end, { desc = desc('file', 'third harpoon') })
map('n', '<leader>;', function() harpoon_ui.nav_file(4) end, { desc = desc('file', 'fourth harpoon') })
map('n', '<leader>ho', harpoon_ui.toggle_quick_menu, { desc = desc('file', 'view live well') })
map('n', '<C-j>', function() harpoon_ui.nav_prev() end, { desc = desc('file', '<< harpoon') })
map('n', '<C-k>', function() harpoon_ui.nav_next() end, { desc = desc('file', 'harpoon >>') })
map('n', '<leader>hc', harpoon_mark.clear_all, { desc = desc('file', 'release all harpoons') })

-- Git
-- :help Git
local git_log_branch = ''
    .. '--branches --remotes --graph --color --decorate=short --format=format:'
    .. '"'
    .. '%x09%C(bold blue)%h%C(reset)' -- short hash
    .. '-%C(auto)%d%C(reset)' -- ref name
    .. '%C(yellow)%<(40,trunc)%s%C(reset)' -- comment
    .. '%C(normal)[%cn]%C(reset)' -- committer
    .. '%C(bold green)(%ar)%C(reset)' -- time elapsed
    .. '"'

map('n', '<leader>gs', function() vim.cmd('Git status') end, { desc = desc('git', 'git status')})
map('n', '<leader>gb', function() vim.cmd('GitBlame') end, { desc = desc('git', 'git blame')})

map('n', '<leader>gD', function()
    vim.cmd('tabnew' .. vim.fn.expand('%:p'))
    vim.cmd('Gdiff')
end, { desc = desc('git', 'git diff')})

map('n', '<leader>gl', function()
    vim.cmd('botright Git log' .. git_log_branch)
end, { desc = desc('git', 'git log')})

-- Use magic when searching
map('n', '/', '/\\v\\c', { desc = desc('gen', 'regex search') })
map('c', '%', '%smagic/\\c', { desc = desc('gen', 'regex replace') })
map('c', '%%', 'smagic/\\c', { desc = desc('gen', 'regex replace selection') })
map('n', '<leader>rw', ':%smagic/\\<<C-r><C-w>\\>//gI<left><left><left>', { desc = desc('txt', 'replace current word')})

-- Split management
map('n', '<leader>\\', function() vim.cmd('vsplit') end, { silent = true, desc = desc('gen', 'vsplit') })
map('n', '<leader>-', function() vim.cmd('split') end, { silent = true, desc = desc('gen', 'split') })
map('n', '<leader>q', '<C-^>:bd#' .. fk.enter, { silent = true, desc = desc('gen', 'close') })
map('n', '<leader>Q', function() vim.cmd('q') end, { silent = true, desc = desc('gen', 'quit') })

-- Terminal split management
map('n', '<leader>`', function()
    vim.cmd('vsplit term://' .. bin.bash)
    vim.cmd('startinser')
end, { silent = true, desc = desc('gen', ':vsplit term') })
map('n', '<leader>~', function()
    vim.cmd('split term://' .. bin.bash)
    vim.cmd('startinser')
end, { silent = true, desc = desc('gen', ':split term') })

-- Split navigation
map('i', '<C-h>', fk.escape .. '<C-w>h', { desc = desc('nav', 'left window') })
map('i', '<C-j>', fk.escape .. '<C-w>j', { desc = desc('nav', 'down window') })
map('i', '<C-k>', fk.escape .. '<C-w>k', { desc = desc('nav', 'up window') })
map('i', '<C-l>', fk.escape .. '<C-w>l', { desc = desc('nav', 'right window') })

map('v', '<C-h>', fk.escape .. '<C-w>h', { desc = desc('nav', 'left window') })
map('v', '<C-j>', fk.escape .. '<C-w>j', { desc = desc('nav', 'down window') })
map('v', '<C-k>', fk.escape .. '<C-w>k', { desc = desc('nav', 'up window') })
map('v', '<C-l>', fk.escape .. '<C-w>l', { desc = desc('nav', 'right window') })

map('n', '<C-h>', '<C-w>h', { desc = desc('nav', 'left window') })
map('n', '<C-j>', '<C-w>j', { desc = desc('nav', 'down window') })
map('n', '<C-k>', '<C-w>k', { desc = desc('nav', 'up window') })
map('n', '<C-l>', '<C-w>l', { desc = desc('nav', 'right window') })

map('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = desc('nav', 'left window') })
map('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = desc('nav', 'down window') })
map('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = desc('nav', 'up window') })
map('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = desc('nav', 'right window') })

-- Tab navigation
map('i', '<M-h>', fk.escape .. ':tabprevious' .. fk.enter, { desc = desc('nav', 'prev tab') })
map('i', '<M-l>', fk.escape .. ':tabnext' .. fk.enter, { desc = desc('nav', 'next tab') })

map('v', '<M-h>', fk.escape .. ':tabprevious' .. fk.enter, { desc = desc('nav', 'prev window') })
map('v', '<M-l>', fk.escape .. ':tabnext' .. fk.enter, { desc = desc('nav', 'next window') })

map('n', '<M-h>', ':tabprevious' .. fk.enter, { desc = desc('nav', 'prev window') })
map('n', '<M-l>', ':tabnext' .. fk.enter, { desc = desc('nav', 'next window') })

map('t', '<M-h>', '<C-\\><C-n>:tabprevious' .. fk.enter, { desc = desc('nav', 'prev window') })
map('t', '<M-l>', '<C-\\><C-n>:tabnext' .. fk.enter, { desc = desc('nav', 'next window') })

-- ----------------------------------------------
-- Plugin Keymaps
-- ----------------------------------------------
-- nvim-ufo (https://github.com/kevinhwang91/nvim-ufo)
-- :help nvim-ufl
-- map('n', 'zR', require('ufo').openAllFolds, { desc = desc('ui', 'open all folds') })
-- map('n', 'zM', require('ufo').closeAllFolds, { desc = desc('ui', 'close all folds') })

-- Telescope
-- :help telescope.builtin
local tsb = require('telescope.builtin')

map('n', '<C-p>', function()
    vim.cmd('cd ' .. project_root)
    tsb.git_files({show_untracked = true})
end, { desc = desc('ts', 'find git files') })

map('n', '<leader>ff', function()
    vim.cmd('cd ' .. project_root)
    tsb.find_files()
end, { desc = desc('ts', 'find files') })

map('n', '<leader>fw', function()
    vim.cmd('cd ' .. project_root)
    tsb.grep_string()
end, { desc = desc('ts', 'find word') })

map('n', '<leader><space>', tsb.buffers, { desc = desc('ts', 'find buffers') })
map('n', '<leader>?', tsb.oldfiles, { desc = desc('ts', 'find recent files') })
map('n', '<leader>f\'', tsb.marks, { desc = desc('ts', 'find marks') })
map('n', '<leader>fh', tsb.help_tags, { desc = desc('ts', 'find help') })
map('n', '<leader>fk', tsb.keymaps, { desc = desc('ts', 'find keymaps') })
map('n', '<leader>fm', tsb.man_pages, { desc = desc('ts', 'find manpage') })
map('n', '<leader>gd', tsb.lsp_definitions, { desc = desc('ts', 'goto deffinition') })
map('n', '<leader>gi', tsb.lsp_implementations, { desc = desc('ts', 'goto implementation') })
map('n', '<leader>qf', tsb.quickfix, { desc = desc('ts', 'find quickfix') })
map('n', '<leader>rg', tsb.live_grep, { desc = desc('ts', 'rg current dir') })
map('n', '/', function()
    tsb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = desc('ts', 'find in current buffer') })
map('n', '<leader>/', '/')

map('n', '<leader>fe', tsb.diagnostics, { desc = desc('ts', 'find errors') })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = desc('diag', 'show errors') })
map('n', '<leader>E', vim.diagnostic.setloclist, { desc = desc('diag', 'open error list') })
map('n', '[d', vim.diagnostic.goto_prev, { desc = desc('diag', 'previous message') })
map('n', ']d', vim.diagnostic.goto_next, { desc = desc('diag', 'next message') })

-- Unmap annoying maps forced by plugin authors
local unimpaired = { '<s', '>s', '=s', '<p', '>p', '<P', '>P' }
local bullets = { '<<', '<', '>', '>>'}

local get_off_my_lawn = function(args)
    for _, tbl in ipairs(args) do
        for _, v in ipairs(tbl) do
            vim.keymap.del('', v)
        end
    end
end

pcall(get_off_my_lawn, { unimpaired, bullets })

return helpers
