local keymap = require("user-keymap")

-- ----------------------------------------------
-- Install Lazy.nvim (https://github.com/folke/lazy.nvim)
-- :help lazy.nvim-lazy.nvim-installation
-- ----------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

-- Add Lazy.nvim to rtp
vim.opt.rtp:prepend(lazypath)

-- ----------------------------------------------
-- Lazy.nvim (https://github.com/folke/lazy.nvim)
-- :help lazy.nvim-lazy.nvim-plugin-spec
-- ----------------------------------------------
require("lazy").setup({
    { import = "plugins.core" },
    { import = "plugins.util" },
    { import = "plugins.syntax" },
    { import = "plugins.ui" },
    { import = "plugins.colorscheme" },
}, {
    install = {
        missing = true,
        colorscheme = { "habamax" }
    },
    diff = { cmd = "diffview.nvim" },
    change_detection = { -- reload ui on config file changes
        enabled = false,
        notify = false,
    },
    checker = {
        enabled = true,
        concurrency = nil,
        notify = false,
        frequency = 60 * 60 * 24,
    },
    performance = {
        cache = { enabled = true },
        reset_packpath = true,
        rtp = {
            reset = true,
            paths = {},
            disabled_plugins = {
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "matchparen",
                "tar",
                "tarPlugin",
                "rrhelper",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            }
        }
    }
})

-- ----------------------------------------------
-- Set colorscheme after it's setup
-- ----------------------------------------------
vim.cmd.colorscheme("catppuccin")

-- ----------------------------------------------
-- Telescope: load extensions (https://github.com/nvim-telescope/telescope.nvim#extensions)
-- :help telescope.extensions()
-- ----------------------------------------------
require("telescope").load_extension("fzf")
require("telescope").load_extension("harpoon")

-- ----------------------------------------------
-- Treesitter (https://github.com/nvim-treesitter/nvim-treesitter#i-want-to-use-git-instead-of-curl-for-downloading-the-parsers)
-- :help nvim-treesitter
-- ----------------------------------------------
require("nvim-treesitter.install").prefer_git = true

-- ----------------------------------------------
-- nvim-cmp: setup (https://github.com/hrsh7th/nvim-cmp)
-- :help cmp
-- ----------------------------------------------
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

-- ----------------------------------------------
-- nvim-cmp: broadcast capabilities to lsp (https://github.com/hrsh7th/nvim-cmp)
-- :help vim.lsp.protocol.make_client_capabilities()
-- ----------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- ----------------------------------------------
-- Mason: lsp configuration (https://github.com/williamboman/mason.nvim)
-- :help mason
-- ----------------------------------------------
local mason_lspconfig = require("mason-lspconfig")
local mason_lsp_servers = {
    -- Ensure these language servers are installed:
    lua_ls = { -- https://github.com/LuaLS/lua-language-server/wiki/Diagnostics
        Lua = {
            filetypes = "lua", -- filetypes the language server will attach to
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
                globals = { "vim", }
            },
        },
    },
}

mason_lspconfig.setup({ ensure_installed = mason_lsp_servers, })

mason_lspconfig.setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = keymap.lsp_maps,
            settings = mason_lsp_servers[server_name],
            filetypes = (mason_lsp_servers[server_name] or {}).filetypes,
        }
    end
}
