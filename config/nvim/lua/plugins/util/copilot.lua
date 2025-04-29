-- ----------------------------------------------
-- GitHub Copilot (https://github.com/github/copilot.vim)
-- :help copilot.vim
-- ----------------------------------------------
return {
  "zbirenbaum/copilot.lua",
  cond = function()
    local handle = io.popen("whoami")
    local username = ""

    if handle then
      username = handle:read("*a"):gsub("%s+", "")  -- Remove whitespace/newlines
      handle:close()
    end

    -- Check if env var matches username
    local env_value = os.getenv("PERSONAL_LAPTOP_USER") or ""
    return (env_value == username)
  end,
  cmd = "Copilot",
  lazy = false,
  -- event = { "InsertEnter", "LspAttach" },
  opts = {
    fix_pairs = true,
  },
  config = function()
    require('copilot').setup({
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>"
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        debounce = 75,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = 'node', -- Node.js version must be > 18.x
      server_opts_overrides = {},
    })
  end,
}
