-- ----------------------------------------------
-- nvim-cmp: completion manager (https://github.com/hrsh7th/nvim-cmp)
-- :help cmp
-- ----------------------------------------------
-- Helpers
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
        {
            "L3MON4D3/LuaSnip",
            lazy = true,
            event = "InsertEnter",
            config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
            build = "make install_jsregexp",
        },

        -- LuaSnip completion source (https://github.com/saadparwaiz1/cmp_luasnip)
        -- :help cmp_luasnip
        { "saadparwaiz1/cmp_luasnip", lazy = true, event = "InsertEnter" },


        -- { "SirVer/ultisnips" }, -- Utilisnip (https://github.com/SirVer/ultisnips)
        -- { "quangnguyen30192/cmp-nvim-ultisnips" }, -- Utilisnips integration (https://github.com/quangnguyen30192/cmp-nvim-ultisnips)

        -- Adds a number of user-friendly snippets
        { "rafamadriz/friendly-snippets", lazy = true, event = "InsertEnter" }, -- https://github.com/rafamadriz/friendly-snippets

        -- other recommended dependencies
        { "hrsh7th/cmp-nvim-lsp", lazy = false }, -- LSP completion capabilities (https://github.com/hrsh7th/cmp-nvim-lsp)
        { "hrsh7th/cmp-buffer", lazy = false }, -- Buffer words (https://github.com/hrsh7th/cmp-buffer)
        { "hrsh7th/cmp-path", lazy = false }, -- System paths (https://github.com/hrsh7th/cmp-path)
        { "hrsh7th/cmp-cmdline", lazy = false }, -- Search (/) and command (:) (https://github.com/hrsh7th/cmp-buffer)
        { "petertriho/cmp-git", lazy = false }, -- Git (https://github.com/petertriho/cmp-git)

        -- Auto complete rule: Sort underscores last (https://github.com/lukas-reineke/cmp-under-comparator)
        { "lukas-reineke/cmp-under-comparator", lazy = true, event = "InsertEnter" },

        {
            "zbirenbaum/copilot-cmp",
            config = function ()
                local conf = {
                    suggestion = { enabled = false },
                    panel = { enabled = false },
                }

                require("copilot_cmp").setup(conf)
            end
        },
    },

    init = function()
        local cmp = require("cmp")
        local cmp_compare = require("cmp.config.compare")
        local luasnip = require("luasnip")
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local format = require("cmp_git.format")
        local sort = require("cmp_git.sort")
        local has_words_before = function()
            if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end

            local line, col = unpack(vim.api.nvim_win_get_cursor(0))

            return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
        end

        luasnip.config.setup {}

        ---@diagnostic disable `lua_ls` isn't recognizing optional params
        keymap.cmp = cmp.setup({
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
                require("copilot_cmp.comparators").priority,
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
                { name = 'nvim_lsp_signature_help' },
                { name = 'treesitter' },
                { name = "buffer" },
                { name = "copilot", group_index = 2 },
                { name = "luasnip" },
                -- { name = "ultisnips" },
                { name = "path", option = { trailing_slash = true, } },
                { name = "git" },
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
                    if cmp.visible() and has_words_before() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
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
        })

        -- Git setup.
        require("cmp_git").setup({
            -- defaults
            filetypes = { "gitcommit", "octo" },
            remotes = { "upstream", "origin" }, -- in order of most to least prioritized
            enableRemoteUrlRewrites = false, -- enable git url rewrites, see https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtinsteadOf
            git = {
                commits = {
                    limit = 100,
                    sort_by = sort.git.commits,
                    format = format.git.commits,
                },
            },
            github = {
                hosts = {},  -- list of private instances of github
                issues = {
                    fields = { "title", "number", "body", "updatedAt", "state" },
                    filter = "all", -- assigned, created, mentioned, subscribed, all, repos
                    limit = 100,
                    state = "open", -- open, closed, all
                    sort_by = sort.github.issues,
                    format = format.github.issues,
                },
                mentions = {
                    limit = 100,
                    sort_by = sort.github.mentions,
                    format = format.github.mentions,
                },
                pull_requests = {
                    fields = { "title", "number", "body", "updatedAt", "state" },
                    limit = 100,
                    state = "open", -- open, closed, merged, all
                    sort_by = sort.github.pull_requests,
                    format = format.github.pull_requests,
                },
            },
            gitlab = {
                hosts = {},  -- list of private instances of gitlab
                issues = {
                    limit = 100,
                    state = "opened", -- opened, closed, all
                    sort_by = sort.gitlab.issues,
                    format = format.gitlab.issues,
                },
                mentions = {
                    limit = 100,
                    sort_by = sort.gitlab.mentions,
                    format = format.gitlab.mentions,
                },
                merge_requests = {
                    limit = 100,
                    state = "opened", -- opened, closed, locked, merged
                    sort_by = sort.gitlab.merge_requests,
                    format = format.gitlab.merge_requests,
                },
            },
            trigger_actions = {
                {
                    debug_name = "git_commits",
                    trigger_character = ":",
                    action = function(sources, trigger_char, callback, params, git_info)
                        return sources.git:get_commits(callback, params, trigger_char)
                    end,
                },
                {
                    debug_name = "gitlab_issues",
                    trigger_character = "#",
                    action = function(sources, trigger_char, callback, params, git_info)
                        return sources.gitlab:get_issues(callback, git_info, trigger_char)
                    end,
                },
                {
                    debug_name = "gitlab_mentions",
                    trigger_character = "@",
                    action = function(sources, trigger_char, callback, params, git_info)
                        return sources.gitlab:get_mentions(callback, git_info, trigger_char)
                    end,
                },
                {
                    debug_name = "gitlab_mrs",
                    trigger_character = "!",
                    action = function(sources, trigger_char, callback, params, git_info)
                        return sources.gitlab:get_merge_requests(callback, git_info, trigger_char)
                    end,
                },
                {
                    debug_name = "github_issues_and_pr",
                    trigger_character = "#",
                    action = function(sources, trigger_char, callback, params, git_info)
                        return sources.github:get_issues_and_prs(callback, git_info, trigger_char)
                    end,
                },
                {
                    debug_name = "github_mentions",
                    trigger_character = "@",
                    action = function(sources, trigger_char, callback, params, git_info)
                        return sources.github:get_mentions(callback, git_info, trigger_char)
                    end,
                },
            },
        })

        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
                { name = 'git' },
            }, {
                    { name = 'buffer' },
                })
        })

        -- `/`, `?` cmdline setup.
        cmp.setup.cmdline({"/", "?" }, {
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
