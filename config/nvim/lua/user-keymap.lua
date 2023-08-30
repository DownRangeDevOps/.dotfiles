local M = {}
-- ----------------------------------------------
-- Helpers
-- ----------------------------------------------

M.bin = {
    bash = vim.env.BREW_PREFIX .. '/bin/bash --login'
}
local bin = M.bin

M.fk = {
    escape = '<Esc>',
    enter = '<CR>',
    space = '<Space>',
}
local fk = M.fk

M.is_git_repo = function()
    if os.execute('git rev-parse') == 0 then
        return true
    else
        return false
    end
end
local is_git_repo = M.is_git_repo

-- Mapping
-- TODO: Use to auto add which-key documentation
M.map = function(mode, lhs, rhs, opts)
    --- Shortcut for vim.keymap.set
    --
    -- @param mode :string|table ('n'|'i'|'v'|'c'|'t')
    -- @param keys :string
    -- @param func :string|func
    -- @param opts :table|nil
    assert(tostring(mode), 'invalid argument: mode :string required')
    assert(tostring(lhs), 'invalid argument: lhs :string required')
    assert(tostring(rhs), 'invalid argument: rhs :string required')

    if opts then
        vim.keymap.set(mode, lhs, rhs, opts)
    else
        vim.keymap.set(mode, lhs, rhs)
    end
end
local map = M.map

M.desc = function(group, desc)
    --- Prefix descriptions with a group
    --
    -- @param group :string Group prefix (cond|diag|file|gen|lsp|nav|tog|ts)
    -- @param desc :string Description
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
local desc = M.desc

-- You should have gone for the head...
M.thanos_snap = function(bufnr)
    local modifiable = vim.api.nvim_buf_get_option(bufnr, 'modifiable')
    local readonly = vim.api.nvim_buf_get_option(bufnr, 'readonly')
    local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    local the_unfortunate = { 'help', 'qf', 'man', 'checkhouth', 'lspinfo', 'checkhealth' } -- file types
    local the_disgraced = { 'quickfix', 'prompt', 'nofile' } -- buf types

    local snap_while_wearing_a_gauntlet = function ()
        map('n', 'q', ':quit', { buffer = bufnr, desc = desc('gui', "don't @ me") })
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
map('i', 'jj', fk.escape, { desc = desc('gen', 'Escape') })
map('n', 'gl', 'gu') -- err 'go lower' sure makes sense to me...
map('n', 'gL', 'gu') -- err 'go lower' sure makes sense to me...
map('n', 'gQ', '<nop>') -- reeeeeee (use :Ex-mode if you really need it, which will be never)

-- fuuuuuuu (disable command-line mode, use <C-F>, see :h c_CTRL-F)
map('c', 'q:', ':')
map('c', 'q/', '/')
map('c', 'q/', '?')

-- Karen without Karenness
-- NOTE: test for a while then add response:
-- (https://stackoverflow.com/questions/11993851/how-to-delete-not-cut-in-vim)
-- Copy/paste to/from system clipboard
map({ 'n', 'v' }, '<leader>y', '"+y', { desc = desc('gen', 'copy to system clipboard') })
map('n', '<leader>Y', '"+Y', { desc = desc('gen', 'copy -> eol to system clipboard') })
map('v', '<LeftRelease>', '"+y<LeftRelease>', { desc = desc('gen', 'copy on mouse select') })
map('n', '<leader>yy', '"+yy', { desc = desc('gen', 'copy line to system clipboard') })
map('n', '<leader>p', '"+p', { desc = desc('gen', 'paste system clipboard') })
map('n', '<leader>P', '"+P', { desc = desc('gen', 'paste system clipboard') })

-- delete
map({ 'n', 'v' }, "d", '"_d', { desc = desc('txt', 'delete') })
map('n', "D", '"_D', { desc = desc('txt', 'delete -> eol') })
map({ 'n', 'v' }, "<leader>d", "d", { desc = desc('txt', 'yank-delete') })
map('n', "<leader>D", "D", { desc = desc('txt', 'yank-delete -> eol') })

-- cut
map("", "c", '"_c', { desc = desc('txt', 'change') })
map("", "C", '"_C', { desc = desc('txt', 'change -> eol') })
map("", "<leader>c", "c", { desc = desc('txt', 'yank-change')})
map("", "<leader>C", "C", { desc = desc('txt', 'yank-change -> eol')})

-- paste
map('v', "p", '"_dgvp', { desc = desc('txt', 'paste') })
map('v', "P", '"_dgvP', { desc = desc('txt', 'paste after') })
map('v', "<leader>p", "ygvp", { desc = desc('txt', 'yank-paste after') })
map('v', "<leader>P", "ygvP", { desc = desc('txt', 'yank-paste after') })

-- Manipulate lines, maintain cursor pos
map('v', 'J', ':m \'>+1' ..fk.enter .. 'gv=gv', { desc = desc('txt', 'move lines up') })
map('v', 'K', ':m \'<-2' ..fk.enter .. 'gv=gv', { desc = desc('txt', 'move lines down')} )
map('n', 'J', 'mzJ`z', { desc = desc('txt', 'join w/o hop') })
map('n', '<C-u>', '<C-u>zz', { desc = desc('gen', 'pgup') })
map('n', '<C-d>', '<C-d>zz', { desc = desc('gen', 'pgdn') })
map('n', 'n', 'nzzzv', { desc = desc('next search') })
map('n', 'N', 'Nzzzv', { desc = desc('prev search') })

-- File management (auto-save, browser)
map('n', '<leader>w', vim.cmd.write, { silent = true, desc = desc('file', 'write to file') })
map('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = desc('file', 'open undo-tree' ) })
map('n', '<leader>1', function() vim.cmd(
    'Neotree action=focus source=filesystem position=current toggle reveal') end,
    { silent = true, desc = desc('file', 'open browser') })
map('n', '<leader>2', function() vim.cmd(
    'Neotree action=show source=filesystem position=left toggle reveal') end,
    { silent = true, desc = desc('file', 'open sidebar browser') })

M.neo_tree = {
    window = {
        mappings = {
            ['-'] = 'navigate_up',
            ['<C-r>'] = 'Neotree refresh',
        }
    }
}

-- map('n', '<leader>x', function() vim.cmd([[chmod +x %]]) end, { desc = desc('file', 'make file +x') })

-- Harpoon (https://github.com/ThePrimeagen/harpoon)
-- :help harpoon
map('n', '<leader>hf', function() require("harpoon.mark").toggle_file() end, { desc = desc('file', 'harpoon/release') })
map('n', '<leader>j', function() require("harpoon.ui").nav_file(1) end, { desc = desc('file', 'first harpoon') })
map('n', '<leader>k', function() require("harpoon.ui").nav_file(2) end, { desc = desc('file', 'second harpoon') })
map('n', '<leader>l', function() require("harpoon.ui").nav_file(3) end, { desc = desc('file', 'third harpoon') })
map('n', '<leader>;', function() require("harpoon.ui").nav_file(4) end, { desc = desc('file', 'fourth harpoon') })
map('n', '<leader>ho', function() require("harpoon.ui").toggle_quick_menu() end, { desc = desc('file', 'view live well') })
map('n', '<C-j>', function() require("harpoon.ui").nav_prev() end, { desc = desc('file', '<< harpoon') })
map('n', '<C-k>', function() require("harpoon.ui").nav_next() end, { desc = desc('file', 'harpoon >>') })
map('n', '<leader>hc', function() require("harpoon.mark").clear_all() end, { desc = desc('file', 'release all harpoons') })

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
    vim.cmd('GitDiff')
end, { desc = desc('git', 'git diff')})

map('n', '<leader>gl', function()
    vim.cmd('botright Git log' .. git_log_branch)
end, { desc = desc('git', 'git log')})

-- Use magic when searching
local use_magic = function(key, prefix)
    local pos = vim.fn.getcmdpos()

    if pos == 1 or pos == 6 then
        vim.fn.setcmdline(vim.fn.getcmdline() .. prefix)
    else
        vim.fn.setcmdline(vim.fn.getcmdline() .. key)
    end
end

map('n', '*', '*N', { desc = desc('gen', 'find word at cur')})
map('n', '/', '/\\v\\c', { desc = desc('gen', 'regex search') })
map('c', '%', function() use_magic('%', '%s/\\v\\c') end, { desc = desc('gen', 'regex replace') })
map('c', '%%', function() use_magic('%%', 's/\\v\\c') end, { desc = desc('gen', 'regex replace visual') })
map('n', '<leader>rw', ':%smagic/\\<<C-r><C-w>\\>//gI<left><left><left>', { desc = desc('txt', 'replace current word')})

-- Split management
map('n', '<leader>\\', function() vim.cmd('vsplit') end, { silent = true, desc = desc('gen', 'vsplit') })
map('n', '<leader>-', function() vim.cmd('split') end, { silent = true, desc = desc('gen', 'split') })
map('n', '<leader>q', ':w' .. fk.enter .. '<C-^>:bd#' .. fk.enter .. 'i' .. fk.enter, { silent = true, desc = desc('gen', 'close') }) -- TODO: fix if no prev buffer or last buf is terminal
map('n', '<leader>Q', function() vim.cmd('quit!') end, { silent = true, desc = desc('gen', 'quit') })

-- Terminal split management
map('n', '`', ':ToggleTerm size=15 direction=horizontal' .. fk.enter, { desc = desc('gen', 'open floating terminal')})
map('n', '<leader>`', function()
    vim.cmd.vsplit('term://' .. bin.bash)
    vim.cmd.startinsert()
end, { silent = true, desc = desc('gen', ':vsplit term') })

map('n', '<leader>~', function()
    vim.cmd.split('term://' .. bin.bash)
    vim.cmd.startinser()
end, { silent = true, desc = desc('gen', ':split term') })

-- Split navigation
map({ 'i', 'v', 'n' }, '<C-h>', '<C-w>h', { desc = desc('nav', 'left window') })
map({ 'i', 'v', 'n' }, '<C-j>', '<C-w>j', { desc = desc('nav', 'down window') })
map({ 'i', 'v', 'n' }, '<C-k>', '<C-w>k', { desc = desc('nav', 'up window') })
map({ 'i', 'v', 'n' }, '<C-l>', '<C-w>l', { desc = desc('nav', 'right window') })

map('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = desc('nav', 'left window') })
map('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = desc('nav', 'down window') })
map('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = desc('nav', 'up window') })
map('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = desc('nav', 'right window') })

-- Tab navigation
map('i', '˙',fk.escape .. ':tabprevious' .. fk.enter .. ':echo ""' .. fk.enter, { desc = desc('nav', 'prev tab') })
map('i', '¬',fk.escape .. ':tabnext' .. fk.enter .. ':echo ""' .. fk.enter, { desc = desc('nav', 'next tab') })

map('v', '˙',fk.escape .. ':tabprevious' .. fk.enter .. ':echo ""' .. fk.enter, { desc = desc('nav', 'prev window') })
map('v', '¬',fk.escape .. ':tabnext' .. fk.enter .. ':echo ""' .. fk.enter, { desc = desc('nav', 'next window') })

map('n', '˙', ':tabprevious' .. fk.enter .. ':echo ""' .. fk.enter, { desc = desc('nav', 'prev window') })
map('n', '¬', ':tabnext' .. fk.enter .. ':echo ""' .. fk.enter, { desc = desc('nav', 'next window') })

map('t', '˙', '<C-\\><C-n>:tabprevious' .. fk.enter .. ':echo ""' .. fk.enter, { desc = desc('nav', 'prev window') })
map('t', '¬', '<C-\\><C-n>:tabnext' .. fk.enter .. ':echo ""' .. fk.enter, { desc = desc('nav', 'next window') })

-- ----------------------------------------------
-- Plugin Keymaps
-- ----------------------------------------------
-- nvim-ufo (https://github.com/kevinhwang91/nvim-ufo)
-- :help nvim-ufl
-- map('n', 'zR', require('ufo').openAllFolds, { desc = desc('ui', 'open all folds') })
-- map('n', 'zM', require('ufo').closeAllFolds, { desc = desc('ui', 'close all folds') })

-- -- Telescope
-- -- :help telescope.builtin
map('n', '<C-p>', function()
    if is_git_repo() then
        vim.print("Running Telescope git_files in " .. vim.cmd.pwd())
        require('telescope.builtin').git_files({show_untracked = true})
    else
        vim.print("Running Telescope find_files in " .. vim.cmd.pwd())
        require('telescope.builtin').find_files()
    end
end, { desc = desc('ts', 'find git files') })
map('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = desc('ts', 'find files') })
map('n', '<leader>fw', function() require('telescope.builtin').grep_string() end, { desc = desc('ts', 'find word') })

map('n', '<leader><space>', function() require('telescope.builtin').buffers() end, { desc = desc('ts', 'find buffers') })
map('n', '<leader>?', function() require('telescope.builtin').oldfiles() end, { desc = desc('ts', 'find recent files') })
map('n', '<leader>f\'', function() require('telescope.builtin').marks() end, { desc = desc('ts', 'find marks') })
map('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = desc('ts', 'find help') })
map('n', '<leader>fk', function() require('telescope.builtin').keymaps() end, { desc = desc('ts', 'find keymaps') })
map('n', '<leader>fm', function() require('telescope.builtin').man_pages() end, { desc = desc('ts', 'find manpage') })
map('n', '<leader>gd', function() require('telescope.builtin').lsp_definitions() end, { desc = desc('ts', 'goto deffinition') })
map('n', '<leader>gi', function() require('telescope.builtin').lsp_implementations() end, { desc = desc('ts', 'goto implementation') })
map('n', '<leader>qf', function() require('telescope.builtin').quickfix() end, { desc = desc('ts', 'find quickfix') })
map('n', '<leader>rg', function() require('telescope.builtin').live_grep() end, { desc = desc('ts', 'rg current dir') })
map('n', '<leader>/', function()
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = desc('ts', 'find in current buffer') })

map('n', '<leader>fe', function() require('telescope.builtin').diagnostics() end, { desc = desc('ts', 'find errors') })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = desc('diag', 'show errors') })
map('n', '<leader>E', vim.diagnostic.setloclist, { desc = desc('diag', 'open error list') })
map('n', '[d', vim.diagnostic.goto_prev, { desc = desc('diag', 'previous message') })
map('n', ']d', vim.diagnostic.goto_next, { desc = desc('diag', 'next message') })

-- LSP key maps
M.lsp_on_attach = function(_, bufnr)
    -- refactor
    map('n', '<leader>rn', vim.lsp.buf.rename, { desc = desc('lsp', 'rename') })
    map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = desc('lsp', 'code action') })

    -- goto
    map('n', 'gd', vim.lsp.buf.definition, { desc = desc('lsp', 'goto definition') })
    map('n', 'gr', function() require('telescope.builtin').lsp_references() end, { desc = desc('lsp', 'goto references') })
    map('n', 'gI', vim.lsp.buf.implementation, { desc = desc('lsp', 'goto implementation') })

    -- Open manpages/help
    map('n', 'K', vim.lsp.buf.hover, { desc = desc('lsp', 'show symbol info') })
    map('n', '<C-n>', vim.lsp.buf.signature_help, { desc = desc('lsp', 'show signature info') })


    map('n', '<leader>D', vim.lsp.buf.type_definition, { desc = desc('lsp', 'type definition') })
    map('n', '<leader>ds', function() require('telescope.builtin').lsp_document_symbols() end, { desc = desc('lsp', 'document symbols') })
    map('n', '<leader>ws', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, { desc = desc('lsp', 'workspace symbols') })

    -- Lesser used LSP functionality
    map('n', 'gD', vim.lsp.buf.declaration, { desc = desc('lsp', 'goto declaration') })
    map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = desc('lsp', 'workspace add folder') })
    map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = desc('lsp', 'workspace remove folder') })
    map('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { desc = desc('lsp', 'Workspace list folders') })

    -- Create a command `:Format` local to the LSP buffer and map it
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = desc('lsp', 'format current buffer') })
    map('n', '<leader>=', ':Format' .. fk.enter, { desc = desc('lsp', 'format current buffer') })
end

M.treesitter_km = {
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

M.cmp_keys = {
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
