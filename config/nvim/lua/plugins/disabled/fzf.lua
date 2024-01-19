-- ----------------------------------------------
-- fzf-lua fzf integration (https://github.com/ibhagwan/fzf-lua)
-- :help fzf-lua.txt
-- Squirrel's
-- ----------------------------------------------
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({"telescope"})
  end
}
