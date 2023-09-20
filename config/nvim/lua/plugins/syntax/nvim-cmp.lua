-- ----------------------------------------------
-- nvim-cmp: completion manager (https://github.com/hrsh7th/nvim-cmp)
-- :help cmp
-- ----------------------------------------------
return {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = "InsertEnter,CmdlineEnter",
    version = "2.*",
    build = "make install_jsregexp",
    dependencies = {
        --  LuaSnip: snippets manager (https://github.com/L3MON4D3/LuaSnip)
        -- :help luasnip.txt
        { "L3MON4D3/LuaSnip", lazy = true, event = "InsertEnter", config = function() require("luasnip.loaders.from_vscode").lazy_load() end }, -- https://github.com/L3MON4D3/LuaSnip

        -- LuaSnip completion source (https://github.com/saadparwaiz1/cmp_luasnip)
        -- :help cmp_luasnip
        { "saadparwaiz1/cmp_luasnip", lazy = true, event = "InsertEnter", },

        -- Adds a number of user-friendly snippets
        { "rafamadriz/friendly-snippets", lazy = true, event = "InsertEnter",}, -- https://github.com/rafamadriz/friendly-snippets

        -- other recommended dependencies
        { "hrsh7th/cmp-nvim-lsp", lazy = false }, -- LSP completion capabilities (https://github.com/hrsh7th/cmp-nvim-lsp)
        { "hrsh7th/cmp-buffer", lazy = false }, -- Buffer words (https://github.com/hrsh7th/cmp-buffer)
        { "hrsh7th/cmp-path", lazy = false }, -- System paths (https://github.com/hrsh7th/cmp-path)
        { "hrsh7th/cmp-cmdline", lazy = false }, -- Search (/) and command (:) (https://github.com/hrsh7th/cmp-buffer)

        -- Auto complete rule: Sort underscores last (https://github.com/lukas-reineke/cmp-under-comparator)
        { "lukas-reineke/cmp-under-comparator", lazy = true, event = "InsertEnter" },
    },
}
