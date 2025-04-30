-- ----------------------------------------------
-- nvim-cmp: completion manager (https://github.com/hrsh7th/nvim-cmp)
-- :help cmp
-- ----------------------------------------------
-- Helpers
local keymap = require("user-keymap")

return {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = { "InsertEnter", "CmdlineEnter" },
    version = "2.*",
    dependencies = {
        --  LuaSnip: snippets manager (https://github.com/L3MON4D3/LuaSnip)
        -- :help luasnip.txt
        {
            "L3MON4D3/LuaSnip",
            lazy = true,
            event = "InsertEnter",
            version = "v2.*",
            build = "make install_jsregexp",
            config = function()
                -- Configure LuaSnip
                local ls = require("luasnip")

                -- Load friendly-snippets
                ls.loaders.from_vscode.lazy_load()

                -- DevOps-specific snippet extensions
                ls.filetype_extend("terraform", {"hcl"})
                ls.filetype_extend("yaml", {"kubernetes"})
                ls.filetype_extend("go", {"golang"})

                -- Load your custom snippets
                ls.loaders.from_vscode.lazy_load({
                    paths = {
                        vim.env.HOME .. ".dotfiles/config/nvim/snippets",
                    },
                })
            end,
        },

        -- LuaSnip completion source for snippet integration (https://github.com/saadparwaiz1/cmp_luasnip)
        { "saadparwaiz1/cmp_luasnip", lazy = true, event = "InsertEnter" },

        -- Adds a number of user-friendly snippets (https://github.com/rafamadriz/friendly-snippets)
        { "rafamadriz/friendly-snippets", lazy = true, event = "InsertEnter" },

        -- LSP and other base completion sources
        { "hrsh7th/cmp-nvim-lsp", lazy = false }, -- LSP source for completions (https://github.com/hrsh7th/cmp-nvim-lsp)
        { "hrsh7th/cmp-buffer", lazy = false }, -- Buffer words completion source (https://github.com/hrsh7th/cmp-buffer)
        { "hrsh7th/cmp-path", lazy = false }, -- Filesystem path completion source (https://github.com/hrsh7th/cmp-path)
        { "hrsh7th/cmp-cmdline", lazy = false }, -- Command-line completion source (https://github.com/hrsh7th/cmp-cmdline)
        { "petertriho/cmp-git", lazy = false }, -- Git commit/issue completion source (https://github.com/petertriho/cmp-git)
        { "hrsh7th/cmp-nvim-lsp-signature-help", lazy = false }, -- Function signature completion helper (https://github.com/hrsh7th/cmp-nvim-lsp-signature-help)

        -- Add Neovim Lua API completions (useful for modifying your config) (https://github.com/hrsh7th/cmp-nvim-lua)
        { "hrsh7th/cmp-nvim-lua", lazy = true, ft = "lua" },

        -- Add tmux completions (good for Go imports and shell commands) (https://github.com/andersevenrud/cmp-tmux)
        { "andersevenrud/cmp-tmux", lazy = true },

        -- Add calculator (useful for quick calculations) (https://github.com/hrsh7th/cmp-calc)
        { "hrsh7th/cmp-calc", lazy = true },

        -- Add crates.io completions for Cargo.toml (https://github.com/saecki/crates.nvim)
        {
            "saecki/crates.nvim",
            lazy = true,
            ft = {"rust", "toml"},
            config = function()
                require("crates").setup()
            end,
        },

        -- Auto complete rule: Sort underscores last (https://github.com/lukas-reineke/cmp-under-comparator)
        { "lukas-reineke/cmp-under-comparator", lazy = true, event = "InsertEnter" },

        -- Copilot integration for AI completions (https://github.com/zbirenbaum/copilot-cmp)
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

            -- Improved comparators with custom sorting function
            comparators = {
                cmp_compare.offset,
                cmp_compare.exact,
                require("copilot_cmp.comparators").priority,
                cmp_compare.scopes, -- Added for better variable context awareness
                cmp_compare.score,
                -- Custom comparator to prioritize variables/functions over text/keywords
                function(entry1, entry2)
                    local kind1 = entry1:get_kind()
                    local kind2 = entry2:get_kind()

                    -- Variables/functions (12) before text/keywords (1)
                    if kind1 == 12 and kind2 == 1 then return true end
                    if kind1 == 1 and kind2 == 12 then return false end

                    return nil -- Fall through to next comparator
                end,
                require("cmp-under-comparator").under,
                cmp_compare.recently_used,
                cmp_compare.locality,
                cmp_compare.kind,
                cmp_compare.length,
                cmp_compare.order,
            },

            -- Better organized sources with group indices
            sources = {
                { name = "nvim_lsp", group_index = 1 },
                { name = "copilot", group_index = 1 },
                { name = 'nvim_lsp_signature_help', group_index = 1 },
                { name = "nvim_lua", group_index = 1, ft = "lua" }, -- Neovim Lua API
                { name = 'luasnip', group_index = 2 },
                { name = "git", group_index = 2 },
                { name = "crates", group_index = 2 }, -- Rust crates
                { name = 'treesitter', group_index = 3 },
                { name = "buffer", keyword_length = 3, group_index = 3 }, -- Only suggest after 3 chars
                { name = "path", option = { trailing_slash = true }, group_index = 3 },
                { name = "tmux", option = { all_panes = true }, group_index = 3 }, -- Tmux panes
                { name = "calc", group_index = 3 }, -- Calculator
            },

            -- Performance optimizations
            performance = {
                debounce = 50, -- Reduce source debounce time (default: 150ms)
                throttle = 20, -- Source throttling (default: 30ms)
                fetching_timeout = 150, -- Timeout for fetching (default: 500ms)

                -- Configure buffer source to avoid lag with large buffers
                max_buffer_size = 1024 * 1024, -- Don't scan buffers larger than 1MB
            },

            -- Formatting and display improvements
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    -- Define icons for different completion types
                    local kind_icons = {
                        Text = "󰉿",
                        Method = "󰆧",
                        Function = "󰊕",
                        Constructor = "",
                        Field = "󰜢",
                        Variable = "󰀫",
                        Class = "󰠱",
                        Interface = "",
                        Module = "",
                        Property = "󰜢",
                        Unit = "󰑭",
                        Value = "󰎠",
                        Enum = "",
                        Keyword = "󰌋",
                        Snippet = "",
                        Color = "󰏘",
                        File = "󰈙",
                        Reference = "󰈇",
                        Folder = "󰉋",
                        EnumMember = "",
                        Constant = "󰏿",
                        Struct = "󰙅",
                        Event = "",
                        Operator = "󰆕",
                        TypeParameter = "",
                        Copilot = "󰚩",
                    }

                    -- Source-specific labels
                    local source_names = {
                        nvim_lsp = "[LSP]",
                        copilot = "[Copilot]",
                        luasnip = "[Snippet]",
                        buffer = "[Buffer]",
                        nvim_lua = "[Lua]",
                        treesitter = "[TS]",
                        path = "[Path]",
                        nvim_lsp_signature_help = "[Sig]",
                        crates = "[Crates]",
                        tmux = "[Tmux]",
                        calc = "[Calc]",
                        git = "[Git]",
                    }

                    -- Add icons and source information
                    vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)
                    vim_item.menu = source_names[entry.source.name] or "[" .. entry.source.name .. "]"

                    -- Indicate if item is from Copilot
                    if entry.source.name == "copilot" then
                        vim_item.kind = "󰚩 Copilot"
                        vim_item.kind_hl_group = "CmpItemKindCopilot"
                    end

                    return vim_item
                end,
            },

            -- Window styling
            window = {
                completion = {
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                    col_offset = -3,
                    side_padding = 0,
                },
                documentation = {
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                    max_width = 50,
                },
            },

            -- Experimental features
            experimental = {
                ghost_text = false, -- Disable ghost text for better performance
            },

            -- Key mappings (existing mapping with minor improvements)
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

        -- Git setup (keeping existing configuration)
        require("cmp_git").setup({
            -- defaults
            filetypes = { "gitcommit", "octo" },
            remotes = { "upstream", "origin" }, -- in order of most to least prioritized
            enableRemoteUrlRewrites = false, -- enable git url rewrites
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

        -- Git commit message setup
        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
                { name = 'git' },
            }, {
                    { name = 'buffer' },
                })
        })

        -- Terraform-specific setup
        cmp.setup.filetype('terraform', {
            sources = cmp.config.sources({
                { name = "nvim_lsp", group_index = 1 },
                { name = "copilot", group_index = 1 },
                { name = 'luasnip', group_index = 2 },
                { name = "buffer", keyword_length = 3, group_index = 3 },
                { name = "path", group_index = 3 },
            })
        })

        -- Kubernetes YAML setup
        cmp.setup.filetype('yaml', {
            sources = cmp.config.sources({
                { name = "nvim_lsp", group_index = 1 },
                { name = "copilot", group_index = 1 },
                { name = 'luasnip', group_index = 2 },
                { name = "buffer", keyword_length = 3, group_index = 3 },
                { name = "path", group_index = 3 },
            })
        })

        -- Go setup
        cmp.setup.filetype('go', {
            sources = cmp.config.sources({
                { name = "nvim_lsp", group_index = 1 },
                { name = "copilot", group_index = 1 },
                { name = 'luasnip', group_index = 2 },
                { name = "buffer", keyword_length = 3, group_index = 3 },
                { name = "path", group_index = 3 },
                { name = "tmux", group_index = 3 }, -- Help with imports
            })
        })

        -- `/`, `?` cmdline setup
        cmp.setup.cmdline({"/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" }
            }
        })

        -- `:` cmdline setup
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
