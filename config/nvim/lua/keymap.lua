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

-- Mapping
local map = function(mode, keys, func, opts)
  --- Shortcut for vim.keymap.set
  --
  -- @param mode:string|table ('n'|'i'|'v'|'c'|'t')
  -- @param keys:string
  -- @param func:string|func
  -- @param opts:table|nil

  opts = opts or nil

  vim.keymap.set(mode, keys, func)
end

local cmap = function(keys, func, opts)
  --- Shortcut for vim.keymap.set('c', ...)
  --
  -- @param keys:string
  -- @param func:string|func
  -- @param opts:table|nil

  opts = opts or nil
  map('c', keys, func, opts)
end

local imap = function(keys, func, opts)
  --- Shortcut for vim.keymap.set('i', ...)
  --
  -- @param keys:string
  -- @param func:string|func
  -- @param opts:table|nil

  opts = opts or nil
  map('i', keys, func, opts)
end

local nmap = function(keys, func, opts)
  --- Shortcut for vim.keymap.set('n', ...)
  --
  -- @param keys:string
  -- @param func:string|func
  -- @param opts:table|nil

  opts = opts or nil
  map('n', keys, func, opts)
end

local tmap = function(keys, func, opts)
  --- Shortcut for vim.keymap.set('t', ...)
  --
  -- @param keys:string
  -- @param func:string|func
  -- @param opts:table|nil

  opts = opts or nil
  map('t', keys, func, opts)
end

local vmap = function(keys, func, opts)
  --- Shortcut for vim.keymap.set('v', ...)
  --
  -- @param keys:string
  -- @param func:string|func
  -- @param opts:table|nil

  opts = opts or nil
  map('v', keys, func, opts)
end

local desc = function(group, desc)
  --- Prefix descriptions with a group
  --
  -- @param group:string Group prefix (cond|diag|file|gen|lsp|nav|tog|ts)
  -- @param desc:string Description
  local groups = {
    cond = 'Conditional: ',
    diag = 'Diagnostic: ',
    file = 'File: ',
    gen = 'General: ',
    lsp = 'LSP: ',
    nav = 'Nav: ',
    tog = 'Toggle: ',
    ts = 'TS: ',
  }

  if groups[group] then
    desc = groups[group] .. desc
  end

  return desc
end

local helpers = {
  fk = fk,
  desc = desc,
  imap = nmap,
  nmap = nmap,
  tmap = nmap,
  vmap = nmap,
}

local should_overload_q = function()
  local cur_buffer = vim.api.nvim_get_current_buf()

  local is_readonly =  vim.api.nvim_buf_get_option(cur_buffer, 'readonly')
  local is_not_modifiable = not vim.api.nvim_buf_get_option(cur_buffer, 'modifiable')
  local is_overload_type = (function()
    local buf_types = { 'quickfix', 'help' }
    local buf_type = vim.api.nvim_buf_get_option(cur_buffer, 'buftype')

    return buf_types[buf_type]
  end)

  print(is_readonly and "true" or "readonly: false")
  print(is_not_modifiable and "true" or "is not modifiable: false")
  print(is_overload_type() and "true" or "is overload type: false")

  return is_readonly or is_not_modifiable or is_overload_type or nil
end

-- ----------------------------------------------
-- Keymaps
-- ----------------------------------------------

-- Clear search highlight
vim.on_key(
  function(char)
  if vim.fn.mode() == "n" then
    local new_hlsearch = vim.tbl_contains(
      { "<CR>", "n", "N", "*", "#", "?", "/" },
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
imap('jj', fk.escape, { desc = desc('gen', 'Escape') })
nmap('<leader>s', ':call ToggleSpell()' .. fk.enter, { silent = true, desc = desc('tog', 'toggle spellcheck') })
-- nmap('q', function() return should_overload_q() and ':echom "QUIT"' .. fk.enter or ':echom "Q"' .. fk.enter end, { expr = true, silent = true, desc = desc('cond', 'close readonly buffer') })

-- File management
nmap('<leader>w', ':write' .. fk.enter, { silent = true, desc = desc('file', 'write to file') })
nmap('<leader>1', '::Neotree source=filesystem reveal=true position=current' .. fk.enter, { silent = true, desc = desc('file', 'open browser') })
nmap('<leader>2', '::Neotree source=filesystem reveal=true position=left' .. fk.enter, { silent = true, desc = desc('file', 'open browser') })
nmap('<leader>u', vim.cmd.UndotreeToggle, { desc = desc('file', 'open undo-tree' ) })

local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")

nmap('<leader>ha', harpoon_mark.add_file, { desc = desc('file', 'harpoon current file')})
nmap('<leader>ho', harpoon_ui.toggle_quick_menu, { desc = desc('file', 'open harpoon')})
nmap('<leader>j', function() harpoon_ui.nav_file(1) end, { desc = desc('file', 'harpoon first')})
nmap('<leader>k', function() harpoon_ui.nav_file(2) end, { desc = desc('file', 'harpoon second')})
nmap('<leader>l', function() harpoon_ui.nav_file(3) end, { desc = desc('file', 'harpoon third')})
nmap('<leader>;', function() harpoon_ui.nav_file(4) end, { desc = desc('file', 'harpoon fourth')})
nmap('<C-d>', function() harpoon_ui.nav_prev() end, { desc = desc('file', 'harpoon next')})
nmap('<C-j>', function() harpoon_ui.nav_next() end, { desc = desc('file', 'harpoon prev')})

-- Copy/paste
vmap('<leader>y', '"+y', { desc = desc('gen', 'copy to system clipboard') })
nmap('<leader>Y', '"+yg_', { desc = desc('gen', 'EOL copy to system clipboard') })
vmap('<LeftRelease>', '"+y<LeftRelease>', { desc = desc('gen', 'copy on mouse select') })
nmap('<leader>yy', '"+yy', { desc = desc('gen', 'copy line to system clipboard') })
nmap('<leader>p', '"+p', { desc = desc('gen', 'paste system clipboard') })

-- Use magic when searching
nmap('/', '/\\v\\c', { desc = desc('gen', 'Case insensitive regex search') })
vmap('/', '/\\v\\c', { desc = desc('gen', 'Case insensitive regex search') })
cmap('%', '%s/\\v', { desc = desc('gen', 'regex search buffer') })
cmap('%%', 's/\\v', { desc = desc('gen', 'regex search selection') })

-- Split management
nmap('<leader>\\', ':vsplit' .. fk.enter, { silent = true, desc = desc('gen', 'vsplit') })
nmap('<leader>-', ':split' .. fk.enter, { silent = true, desc = desc('gen', 'split') })
nmap('<leader>q', '<C-^>:bd#' .. fk.enter, { silent = true, desc = desc('gen', 'close') })
nmap('<leader>Q', ':q' .. fk.enter, { silent = true, desc = desc('gen', 'quit') })

-- Terminal split management
local insert_mode = bin.bash .. fk.enter .. ':startinsert' .. fk.enter
nmap('<leader>`', ':vsplit term://' .. insert_mode, { silent = true, desc = desc('gen', ':vsplit term') })
nmap('<leader>~', ':split term://' .. insert_mode, { silent = true, desc = desc('gen', ':split term') })

-- Split navigation
imap('<C-h>', fk.escape .. '<C-w>h', { desc = desc('nav', 'left window') })
imap('<C-j>', fk.escape .. '<C-w>j', { desc = desc('nav', 'down window') })
imap('<C-k>', fk.escape .. '<C-w>k', { desc = desc('nav', 'up window') })
imap('<C-l>', fk.escape .. '<C-w>l', { desc = desc('nav', 'right window') })

vmap('<C-h>', fk.escape .. '<C-w>h', { desc = desc('nav', 'left window') })
vmap('<C-j>', fk.escape .. '<C-w>j', { desc = desc('nav', 'down window') })
vmap('<C-k>', fk.escape .. '<C-w>k', { desc = desc('nav', 'up window') })
vmap('<C-l>', fk.escape .. '<C-w>l', { desc = desc('nav', 'right window') })

nmap('<C-h>', '<C-w>h', { desc = desc('nav', 'left window') })
nmap('<C-j>', '<C-w>j', { desc = desc('nav', 'down window') })
nmap('<C-k>', '<C-w>k', { desc = desc('nav', 'up window') })
nmap('<C-l>', '<C-w>l', { desc = desc('nav', 'right window') })

tmap('<C-h>', '<C-\\><C-n><C-w>h', { desc = desc('nav', 'left window') })
tmap('<C-j>', '<C-\\><C-n><C-w>j', { desc = desc('nav', 'down window') })
tmap('<C-k>', '<C-\\><C-n><C-w>k', { desc = desc('nav', 'up window') })
tmap('<C-l>', '<C-\\><C-n><C-w>l', { desc = desc('nav', 'right window') })

-- ----------------------------------------------
-- Plugin Keymaps
-- ----------------------------------------------

-- Telescope
-- :help telescope.builtin
nmap('<C-p>', require('telescope.builtin').find_files, { desc = desc('ts', 'find files') })
nmap('<leader>fg', require('telescope.builtin').git_files, { desc = desc('ts', 'find git files') })
nmap('<leader>rg', require('telescope.builtin').live_grep, { desc = desc('ts', 'rg current dir') })
nmap('<leader>?', require('telescope.builtin').oldfiles, { desc = desc('ts', 'find recent files') })
nmap('<leader><space>', require('telescope.builtin').buffers, { desc = desc('ts', 'find buffers') })
nmap('<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = desc('ts', 'find in current buffer') })

nmap('<leader>fh', require('telescope.builtin').help_tags, { desc = desc('ts', 'find help') })
nmap('<leader>fw', require('telescope.builtin').grep_string, { desc = desc('ts', 'find word') })

nmap('<leader>fe', require('telescope.builtin').diagnostics, { desc = desc('ts', 'find errors') })
nmap('<leader>e', vim.diagnostic.open_float, { desc = desc('diag', 'show errors') })
nmap('<leader>E', vim.diagnostic.setloclist, { desc = desc('diag', 'open error list') })
nmap('[d', vim.diagnostic.goto_prev, { desc = desc('diag', 'previous message') })
nmap(']d', vim.diagnostic.goto_next, { desc = desc('diag', 'next message') })

return helpers
