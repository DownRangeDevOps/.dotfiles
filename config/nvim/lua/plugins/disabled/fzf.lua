-- ----------------------------------------------
-- fzf-lua fzf integration (https://github.com/ibhagwan/fzf-lua)
-- :help fzf-lua.txt
-- ----------------------------------------------
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({})
  end
}
