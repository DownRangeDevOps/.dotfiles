-- ----------------------------------------------
-- Lazygit (https://github.com/kdheepak/lazygit.nvim)
-- :help lazygit.txt
-- ----------------------------------------------
return {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
        branch = "master",
    },
    config = function()
        require("telescope").load_extension("lazygit")
    end,
    init = function()
        vim.g.lazygit_floating_window_use_plenary = 1
        -- require("telescope").extensions.lazygit.lazygit()
    end,
}
