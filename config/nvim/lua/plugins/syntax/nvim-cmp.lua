-- ----------------------------------------------
-- nvim-cmp: completion manager (https://github.com/hrsh7th/nvim-cmp)
-- :help cmp
-- ----------------------------------------------
local keymap = require("user-keymap")

return {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = { "InsertEnter" ,"CmdlineEnter", },
    version = "2.*",
    -- build = "make install_jsregexp",
    dependencies = {
        --  LuaSnip: snippets manager (https://github.com/L3MON4D3/LuaSnip)
        -- :help luasnip.txt
        { "L3MON4D3/LuaSnip", lazy = true, event = "InsertEnter", config = function() require("luasnip.loaders.from_vscode").lazy_load() end },

        -- LuaSnip completion source (https://github.com/saadparwaiz1/cmp_luasnip)
        -- :help cmp_luasnip
        { "saadparwaiz1/cmp_luasnip", lazy = true, event = "InsertEnter" },

        -- Adds a number of user-friendly snippets
        { "rafamadriz/friendly-snippets", lazy = true, event = "InsertEnter" }, -- https://github.com/rafamadriz/friendly-snippets

        -- other recommended dependencies
        { "hrsh7th/cmp-nvim-lsp", lazy = false }, -- LSP completion capabilities (https://github.com/hrsh7th/cmp-nvim-lsp)
        { "hrsh7th/cmp-buffer", lazy = false }, -- Buffer words (https://github.com/hrsh7th/cmp-buffer)
        { "hrsh7th/cmp-path", lazy = false }, -- System paths (https://github.com/hrsh7th/cmp-path)
        { "hrsh7th/cmp-cmdline", lazy = false }, -- Search (/) and command (:) (https://github.com/hrsh7th/cmp-buffer)

        -- Auto complete rule: Sort underscores last (https://github.com/lukas-reineke/cmp-under-comparator)
        { "lukas-reineke/cmp-under-comparator", lazy = true, event = "InsertEnter" },
    },
    init = function()
        local cmp = require("cmp")
        local cmp_compare = require("cmp.config.compare")
        local luasnip = require("luasnip")

        luasnip.config.setup {}

        ---@diagnostic disable `lua_ls` isn't recognizing optional params
        keymap.cmp = cmp.setup {
            revision = 0,
            enabled = true,

            -- Customizations
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            comparators = {
                cmp_compare.offset,
                cmp_compare.exact,
                -- cmp_compare.scopes,
                cmp_compare.score,
                require("cmp-under-comparator").under,
                cmp_compare.recently_used,
                cmp_compare.locality,
                cmp_compare.kind,
                -- cmp_compare.sort_text,
                cmp_compare.length,
                cmp_compare.order,
            },

            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            },

            -- Key mappings
            mapping = cmp.mapping.preset.insert {
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-f>"] = cmp.mapping.scroll_docs(-4),
                ["<C-u>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete {},
                ["<CR>"] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                },

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },
        }

        -- `/` cmdline setup.
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" }
            }
        })

        -- `:` cmdline setup.
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" }
            },
            {
                {
                    name = "cmdline",
                    option = {
                        ignore_cmds = { "Man", "!" }
                    }
                }
            }
            )
        })
        ---@diagnostic enable
    end
}
