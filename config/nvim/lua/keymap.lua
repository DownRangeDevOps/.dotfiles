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

local M = {}

local bin = {
    bash = '$(brew --prefix)/bin/bash --login'
}

M.fk = {
    escape = '<Esc>',
    enter = '<CR>',
    space = '<Space>',
}

M.get_project_root = function()
    local dir = '${HOME}'
    local is_git_repo = os.execute('git rev-parse')

    if is_git_repo == 0 then
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

local project_root = M.get_project_root()

-- Mapping
M.map = function(mode, lhs, rhs, opts)
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

M.desc = function(group, desc)
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
M.thanos_snap = function(bufnr)
    local modifiable = vim.api.nvim_buf_get_option(bufnr, 'modifiable')
    local readonly = vim.api.nvim_buf_get_option(bufnr, 'readonly')
    local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    local the_unfortunate = { 'help', 'qf', 'man', 'checkhouth', 'lspinfo', 'checkhealth' } -- file types
    local the_disgraced = { 'quickfix', 'prompt', 'nofile' } -- buf types

    local snap_while_wearing_a_gauntlet = function ()
        M.map('n', 'q', ':quit', { buffer = bufnr, desc = M.desc('gui', "don't @ me") })
    end

    if bufnr then
        if buftype == 'prompt' then
            snap_while_wearing_a_gauntlet()
        else
            if not modifiable and readonly and (the_unfortunate[filetype] or the_disgraced[buftype]) then
                snap_while_wearing_a_gauntlet()
            end
        end
    end
end

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
M.map('i', 'jj', M.fk.escape, { desc = M.desc('gen', 'Escape') })
M.map('n', 'gl', 'gu') -- err 'go lower' sure makes sense to me...
M.map('n', 'gL', 'gu') -- err 'go lower' sure makes sense to me...
M.map('n', 'Q', '<nop>') -- rreeeeeeeeeeeee
M.map('n', 'gQ', '<nop>') -- get off my lawn
M.map('n', '<C-u>', '<C-b') -- can't be bothered to switch to the proper keys...
M.map('c', '<C-f>', '<nop>') -- up arrow works fuuuuuuu

-- Karen without Karenness
-- NOTE: test for a while then add response:
-- (https://stackoverflow.com/questions/11993851/how-to-delete-not-cut-in-vim)
--
-- Copy/paste to/from system clipboard
-- M.map('', '<leader>y', '"+y', { desc = M.desc('gen', 'copy to system clipboard') })
-- M.map('n', '<leader>Y', '"+y$', { desc = M.desc('gen', 'copy -> eol to system clipboard') })
-- M.map('v', '<LeftRelease>', '"+y<LeftRelease>', { desc = M.desc('gen', 'copy on mouse select') })
-- M.map('n', '<leader>yy', '"+yy', { desc = M.desc('gen', 'copy line to system clipboard') })
-- M.map('n', '<leader>p', '"+p', { desc = M.desc('gen', 'paste system clipboard') })
--
-- delete
-- M.map('n', "d", '"_d', { expr = true, desc = M.desc('txt', 'delete') })
-- M.map('n', "D", '"_D', { expr = true, desc = M.desc('txt', 'delete -> eol') })
-- map('n', "<leader>d", "d", { expr = true, desc = M.desc('txt', 'yank-delete') })
-- M.map('n', "<leader>D", "D", { expr = true, desc = M.desc('txt', 'yank-delete -> eol') })
--
-- cut
-- M.map("", "c", '"_c', { expr = true, desc = M.desc('txt', 'change') })
-- M.map("", "C", '"_C', { expr = true, desc = M.desc('txt', 'change -> eol') })
-- M.map("", "<leader>c", "c", { expr = true , desc = M.desc('txt', 'yank-change')})
-- M.map("", "<leader>C", "C", { expr = true , desc = M.desc('txt', 'yank-change -> eol')})
--
-- paste
-- M.map('n', "p", '"_dp', { expr = true, desc = M.desc('txt', 'paste') })
-- M.map('n', "P", '"_dP', { expr = true, desc = M.desc('txt', 'paste after') })
-- M.map('v', "p", '"_dgvp', { expr = true, desc = M.desc('txt', 'paste') })
-- M.map('v', "P", '"_dgvP', { expr = true, desc = M.desc('txt', 'paste after') })
-- M.map('v', "<leader>p", "ygvp", { expr = true, desc = M.desc('txt', 'yank-paste after') })
-- M.map('v', "<leader>P", "ygvP", { expr = true, desc = M.desc('txt', 'yank-paste after') })
--
-- Manipulate lines, maintain cursor pos
M.map('v', 'J', ':m \'>+1' ..M.fk.enter .. 'gv=gv', { desc = M.desc('txt', 'move lines up') })
M.map('v', 'K', ':m \'<-2' ..M.fk.enter .. 'gv=gv', { desc = M.desc('txt', 'move lines down')} )
M.map('n', 'J', 'mzJ`z', { desc = M.desc('txt', 'join w/o hop') })
M.map('n', '<C-u>', '<C-u>zz', { desc = M.desc('gen', 'pgup') })
M.map('n', '<C-d>', '<C-d>zz', { desc = M.desc('gen', 'pgdn') })
M.map('n', 'n', 'nzzzv', { desc = M.desc('next search') })
M.map('n', 'N', 'Nzzzv', { desc = M.desc('prev search') })

-- File management
M.map('n', '<leader>1', function() vim.cmd(
    'Neotree action=focus source=filesystem position=current toggle reveal') end,
    { silent = true, desc = M.desc('file', 'open browser') })
M.map('n', '<leader>2', function() vim.cmd(
    'Neotree action=show source=filesystem position=left toggle reveal') end,
    { silent = true, desc = M.desc('file', 'open sidebar browser') })
M.map('n', '<leader>w', vim.cmd.write, { silent = true, desc = M.desc('file', 'write to file') })
M.map('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = M.desc('file', 'open undo-tree' ) })
M.map('n', '<leader>x', function() vim.cmd([[chmod +x %]]) end, { desc = M.desc('file', 'make file +x') })

-- Harpoon (https://github.com/ThePrimeagen/harpoon)
-- :help harpoon
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")
M.map('n', '<leader>hf', harpoon_mark.toggle_file, { desc = M.desc('file', 'harpoon/release') })
M.map('n', '<leader>j', function() harpoon_ui.nav_file(1) end, { desc = M.desc('file', 'first harpoon') })
M.map('n', '<leader>k', function() harpoon_ui.nav_file(2) end, { desc = M.desc('file', 'second harpoon') })
M.map('n', '<leader>l', function() harpoon_ui.nav_file(3) end, { desc = M.desc('file', 'third harpoon') })
M.map('n', '<leader>;', function() harpoon_ui.nav_file(4) end, { desc = M.desc('file', 'fourth harpoon') })
M.map('n', '<leader>ho', harpoon_ui.toggle_quick_menu, { desc = M.desc('file', 'view live well') })
M.map('n', '<C-j>', function() harpoon_ui.nav_prev() end, { desc = M.desc('file', '<< harpoon') })
M.map('n', '<C-k>', function() harpoon_ui.nav_next() end, { desc = M.desc('file', 'harpoon >>') })
M.map('n', '<leader>hc', harpoon_mark.clear_all, { desc = M.desc('file', 'release all harpoons') })

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

M.map('n', '<leader>gs', function() vim.cmd('Git status') end, { desc = M.desc('git', 'git status')})
M.map('n', '<leader>gb', function() vim.cmd('GitBlame') end, { desc = M.desc('git', 'git blame')})

M.map('n', '<leader>gD', function()
    vim.cmd('tabnew' .. vim.fn.expand('%:p'))
    vim.cmd('Gdiff')
end, { desc = M.desc('git', 'git diff')})

M.map('n', '<leader>gl', function()
    vim.cmd('botright Git log' .. git_log_branch)
end, { desc = M.desc('git', 'git log')})

-- Use magic when searching
M.map('n', '/', '/\\v\\c', { desc = M.desc('gen', 'regex search') })
M.map('c', '%', '%smagic/\\c', { desc = M.desc('gen', 'regex replace') })
M.map('c', '%%', 'smagic/\\c', { desc = M.desc('gen', 'regex replace selection') })
M.map('n', '<leader>rw', ':%smagic/\\<<C-r><C-w>\\>//gI<left><left><left>', { desc = M.desc('txt', 'replace current word')})

-- Split management
M.map('n', '<leader>\\', function() vim.cmd('vsplit') end, { silent = true, desc = M.desc('gen', 'vsplit') })
M.map('n', '<leader>-', function() vim.cmd('split') end, { silent = true, desc = M.desc('gen', 'split') })
M.map('n', '<leader>q', '<C-^>:bd#' ..M.fk.enter, { silent = true, desc = M.desc('gen', 'close') })
M.map('n', '<leader>Q', function() vim.cmd('q') end, { silent = true, desc = M.desc('gen', 'quit') })

-- Terminal split management
M.map('n', '<leader>`', function()
    vim.cmd('vsplit term://' .. bin.bash)
    vim.cmd('startinser')
end, { silent = true, desc = M.desc('gen', ':vsplit term') })
M.map('n', '<leader>~', function()
    vim.cmd('split term://' .. bin.bash)
    vim.cmd('startinser')
end, { silent = true, desc = M.desc('gen', ':split term') })

-- Split navigation
M.map('i', '<C-h>',M.fk.escape .. '<C-w>h', { desc = M.desc('nav', 'left window') })
M.map('i', '<C-j>',M.fk.escape .. '<C-w>j', { desc = M.desc('nav', 'down window') })
M.map('i', '<C-k>',M.fk.escape .. '<C-w>k', { desc = M.desc('nav', 'up window') })
M.map('i', '<C-l>',M.fk.escape .. '<C-w>l', { desc = M.desc('nav', 'right window') })

M.map('v', '<C-h>',M.fk.escape .. '<C-w>h', { desc = M.desc('nav', 'left window') })
M.map('v', '<C-j>',M.fk.escape .. '<C-w>j', { desc = M.desc('nav', 'down window') })
M.map('v', '<C-k>',M.fk.escape .. '<C-w>k', { desc = M.desc('nav', 'up window') })
M.map('v', '<C-l>',M.fk.escape .. '<C-w>l', { desc = M.desc('nav', 'right window') })

M.map('n', '<C-h>', '<C-w>h', { desc = M.desc('nav', 'left window') })
M.map('n', '<C-j>', '<C-w>j', { desc = M.desc('nav', 'down window') })
M.map('n', '<C-k>', '<C-w>k', { desc = M.desc('nav', 'up window') })
M.map('n', '<C-l>', '<C-w>l', { desc = M.desc('nav', 'right window') })

M.map('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = M.desc('nav', 'left window') })
M.map('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = M.desc('nav', 'down window') })
M.map('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = M.desc('nav', 'up window') })
M.map('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = M.desc('nav', 'right window') })

-- Tab navigation
M.map('i', '<M-h>',M.fk.escape .. ':tabprevious' ..M.fk.enter, { desc = M.desc('nav', 'prev tab') })
M.map('i', '<M-l>',M.fk.escape .. ':tabnext' ..M.fk.enter, { desc = M.desc('nav', 'next tab') })

M.map('v', '<M-h>',M.fk.escape .. ':tabprevious' ..M.fk.enter, { desc = M.desc('nav', 'prev window') })
M.map('v', '<M-l>',M.fk.escape .. ':tabnext' ..M.fk.enter, { desc = M.desc('nav', 'next window') })

M.map('n', '<M-h>', ':tabprevious' ..M.fk.enter, { desc = M.desc('nav', 'prev window') })
M.map('n', '<M-l>', ':tabnext' ..M.fk.enter, { desc = M.desc('nav', 'next window') })

M.map('t', '<M-h>', '<C-\\><C-n>:tabprevious' ..M.fk.enter, { desc = M.desc('nav', 'prev window') })
M.map('t', '<M-l>', '<C-\\><C-n>:tabnext' ..M.fk.enter, { desc = M.desc('nav', 'next window') })

-- ----------------------------------------------
-- Plugin Keymaps
-- ----------------------------------------------
-- nvim-ufo (https://github.com/kevinhwang91/nvim-ufo)
-- :help nvim-ufl
M.map('n', 'zR', require('ufo').openAllFolds, { desc = M.desc('ui', 'open all folds') })
M.map('n', 'zM', require('ufo').closeAllFolds, { desc = M.desc('ui', 'close all folds') })

-- Telescope
-- :help telescope.builtin
local tsb = require('telescope.builtin')

M.map('n', '<C-p>', function()
    vim.cmd('cd ' .. project_root)
    tsb.git_files({show_untracked = true})
end, { desc = M.desc('ts', 'find git files') })

M.map('n', '<leader>ff', function()
    vim.cmd('cd ' .. project_root)
    tsb.find_files()
end, { desc = M.desc('ts', 'find files') })

M.map('n', '<leader>fw', function()
    vim.cmd('cd ' .. project_root)
    tsb.grep_string()
end, { desc = M.desc('ts', 'find word') })

M.map('n', '<leader><space>', tsb.buffers, { desc = M.desc('ts', 'find buffers') })
M.map('n', '<leader>?', tsb.oldfiles, { desc = M.desc('ts', 'find recent files') })
M.map('n', '<leader>f\'', tsb.marks, { desc = M.desc('ts', 'find marks') })
M.map('n', '<leader>fh', tsb.help_tags, { desc = M.desc('ts', 'find help') })
M.map('n', '<leader>fk', tsb.keymaps, { desc = M.desc('ts', 'find keymaps') })
M.map('n', '<leader>fm', tsb.man_pages, { desc = M.desc('ts', 'find manpage') })
M.map('n', '<leader>gd', tsb.lsp_definitions, { desc = M.desc('ts', 'goto deffinition') })
M.map('n', '<leader>gi', tsb.lsp_implementations, { desc = M.desc('ts', 'goto implementation') })
M.map('n', '<leader>qf', tsb.quickfix, { desc = M.desc('ts', 'find quickfix') })
M.map('n', '<leader>rg', tsb.live_grep, { desc = M.desc('ts', 'rg current dir') })
M.map('n', '/', function()
    tsb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = M.desc('ts', 'find in current buffer') })
M.map('n', '<leader>/', '/')

M.map('n', '<leader>fe', tsb.diagnostics, { desc = M.desc('ts', 'find errors') })
M.map('n', '<leader>e', vim.diagnostic.open_float, { desc = M.desc('diag', 'show errors') })
M.map('n', '<leader>E', vim.diagnostic.setloclist, { desc = M.desc('diag', 'open error list') })
M.map('n', '[d', vim.diagnostic.goto_prev, { desc = M.desc('diag', 'previous message') })
M.map('n', ']d', vim.diagnostic.goto_next, { desc = M.desc('diag', 'next message') })

-- LSP key maps
M.lsp_on_attach = function(_, bufnr)
    -- refactor
    M.map('n', '<leader>rn', vim.lsp.buf.rename, M.desc('lsp', 'rename'))
    M.map('n', '<leader>ca', vim.lsp.buf.code_action, M.desc('lsp', 'code action'))

    -- goto
    M.map('n', 'gd', vim.lsp.buf.definition, M.desc('lsp', 'goto definition'))
    M.map('n', 'gr', require('telescope.builtin').lsp_references, M.desc('lsp', 'goto references'))
    M.map('n', 'gI', vim.lsp.buf.implementation, M.desc('lsp', 'goto implementation'))

    -- Open manpages/help
    M.map('n', 'K', vim.lsp.buf.hover, M.desc('lsp', 'open documentation')) -- :help K
    M.map('n', '<C-k>', vim.lsp.buf.signature_help, M.desc('lsp', 'open signature documentation'))

    M.map('n', '<leader>D', vim.lsp.buf.type_definition, M.desc('lsp', 'type definition'))
    M.map('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, M.desc('lsp', 'document symbols'))
    M.map('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, M.desc('lsp', 'workspace symbols'))

    -- Lesser used LSP functionality
    M.map('n', 'gD', vim.lsp.buf.declaration, M.desc('lsp', 'goto declaration'))
    M.map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, M.desc('lsp', 'workspace add folder'))
    M.map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, M.desc('lsp', 'workspace remove folder'))
    M.map('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, M.desc('lsp', 'Workspace list folders'))

    -- Create a command `:Format` local to the LSP buffer and map it
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = M.desc('lsp', 'format current buffer') })
    M.map('n', '<leader>=', ':Format' .. M.fk.enter, { desc = M.desc('lsp', 'format current buffer') })
end

M.treesitter = {
    incremental_selection = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
    },
    textobjects = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
    },
    move = {
        goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
        },
        goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
        },
        goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
        },
        goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
        },
    },
    swap = {
        swap_next = {
            ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
            ['<leader>A'] = '@parameter.inner',
        },
    }
}

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

M.cmp = {
    select_next_item = '<C-j>',
    select_prev_item = '<C-k>',
    scroll_docs_up = '<C-u>',
    scroll_docs_down = '<C-f>',
    complete = '<C-Space>',
    confirm = '<CR>',
    tab = '<Tab>',
    shift_tab = '<S-Tab>',
}

pcall(get_off_my_lawn, { unimpaired, bullets })

return M
