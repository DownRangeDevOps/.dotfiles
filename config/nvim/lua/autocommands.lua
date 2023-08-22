-- mapping helpers
local nmap = require('keymap').nmap
local desc = require('keymap').desc

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({
      higroup = 'Question',
      timeout = 150,
    })
  end,
  group = highlight_group,
  pattern = '*',
})

-- Configure terminal
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = { '*' },
  command = 'set nonumber norelativenumber nospell ft=term',
})

-- Set relitive line numbers
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local nonum_buffs = { 'help', 'quickfix', 'terminal' }

    if vim.bo.buftype == '' then
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.numberwidth = 5
      vim.o.colorcolumn = 80
      vim.api.nvim_set_hl(0, 'ColorColumn', { ctermbg=202031 })
      vim.b.minipairs_disable = true
    end

    if nonum_buffs[vim.bo.buftype] then
      vim.o.number = false
      vim.o.relativenumber = false
    end

  end
})
