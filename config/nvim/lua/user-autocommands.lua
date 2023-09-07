-- local conf = require("config")
local keymap = require("user-keymap")

-- ----------------------------------------------
-- Auto-command Groups
-- ----------------------------------------------
local nvim = vim.api.nvim_create_augroup("NVIM", { clear = true })
local ui = vim.api.nvim_create_augroup("UI", { clear = true })
local user = vim.api.nvim_create_augroup("USER", { clear = true })
local plugin = vim.api.nvim_create_augroup("PLUGIN", { clear = true })

-- ----------------------------------------------
-- Neovim
-- ----------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
    group = nvim,
    pattern = "*",
    callback = function()
        if vim.env.NVIM_SESSION_FILE_PATH then
            vim.cmd.Obsession(vim.env.NVIM_SESSION_FILE_PATH) -- set by .envrc
        end
    end
})

-- ----------------------------------------------
-- UI
-- ----------------------------------------------
-- Enable relative line numbers in neo-tree and exclude from file/jump list
vim.api.nvim_create_autocmd( { "BufWinEnter" }, { group = ui,
    pattern = "*",
    callback = function()
        if vim.api.nvim_buf_get_option(0, "filetype") == "neo-tree" then
            local bufnr = vim.api.nvim_get_current_buf()

            vim.opt.relativenumber = true
            vim.api.nvim_buf_set_option(bufnr, "buflisted", false)
            vim.api.nvim_buf_set_option(bufnr, "bufhidden", "delete")
            vim.wo.list = false
            vim.opt.colorcolumn = ""
        end
    end
})

-- Set cursorline when search highlight is active
vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    group = ui,
    pattern = "*",
    callback = function()
        if vim.opt.hlsearch:get() then
            vim.opt.cursorlineopt = "both"
        else
            vim.opt.cursorlineopt = "number"
        end
    end
})

-- Set scroll distance for <C-u> and <C-d>
vim.api.nvim_create_autocmd({ "BufEnter", "WinScrolled", "VimResized" }, {
    group = ui,
    pattern = "*",
    callback = function()
        local cur_win_height = vim.fn.ceil(vim.api.nvim_win_get_height(0) * 0.66)
        if cur_win_height then vim.opt.scroll = cur_win_height end
    end
})

-- Set options for specific file and buffer types
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "TabEnter", "BufNew" }, {
    group = ui,
    pattern = "*",
    callback = function()
        local clean_filetypes = {
            lspinfo = true,
            packer = true,
            checkhealth = true,
            help = true,
            man = true,
            qf = true,
            git = true,
        }

        local clean_buftypes = {
            help = true,
            quickfix = true,
            terminal = true,
            prompt = true,
        }

        local tab_filetypes = { gitconfig = true }

        local filetype = vim.bo.filetype
        local buftype = vim.bo.buftype

        filetype = filetype or "nofiletype"
        buftype = buftype or "nobuftype"

        -- set overall ui
        if (clean_filetypes[filetype] or clean_buftypes[buftype]) then
            vim.wo.colorcolumn = false
            vim.wo.list = false
            vim.wo.number = false
            vim.wo.relativenumber = false
            vim.wo.spell = false
        else
            vim.wo.colorcolumn = "80"
            vim.wo.list = true
            vim.wo.number = true
            vim.wo.numberwidth = 5
            vim.wo.relativenumber = true
            vim.wo.spell = true
            vim.wo.listchars = table.concat({
                "tab:⇢•",
                "precedes:«",
                "extends:»",
                "trail:•",
                "nbsp:•",
            }, ",")
        end

        -- set file specific ui
        if tab_filetypes[filetype] then
            vim.bo.expandtab = false
            vim.wo.listchars = table.concat({
                "tab:⇢•",
                "precedes:«",
                "extends:»",
                "trail:•",
                "nbsp:•",
            }, ",")
        end
    end
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = user,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "Question",
            timeout = 250,
        })
    end,
})

-- ----------------------------------------------
-- User
-- ----------------------------------------------
-- Auto-Save
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    group = user,
    pattern = "*",
    callback = function()
        if vim.g.auto_save
            and vim.api.nvim_buf_get_option(0, "buftype") == ""
            and vim.api.nvim_buf_get_option(0, "modifiable") then

            vim.cmd.write()
            vim.fn.timer_start(1000, function() vim.cmd.echon("''") end)
        end
    end
})

-- Map/unmap shitty plugin auto bindings
vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave" }, {
    group = user,
    pattern = "*",
    callback = function()
        local bullets_mappings = {
            promote    = { mode = "i", lhs = "<C-d>",     rhs = function() vim.cmd("BulletPromote") end,       opts = { group = "list", desc = "bullets promote" } },
            demote     = { mode = "i", lhs = "<C-t>",     rhs = function() vim.cmd("BulletDemote") end,        opts = { group = "list", desc = "bullets demote" } },
            vpromote   = { mode = "v", lhs  = "<C-d>",    rhs = function() vim.cmd("BulletPromoteVisual") end, opts = { group = "list", desc = "bullets promote" } },
            vdemote    = { mode = "v", lhs  = "<C-t>",    rhs = function() vim.cmd("BulletDemoteVisual") end,  opts = { group = "list", desc = "bullets demote" } },
            enter      = { mode = "i", lhs = "<CR>",      rhs = function() vim.cmd("InsertNewBullet") end,     opts = { group = "list", desc = "bullets newline" } },
            checkbliox = { mode = "n", lhs = "<leader>x", rhs = function() vim.cmd("ToggleCheckbox") end,      opts = { group = "list", desc = "bullets toggle checkbox" } },
            openline   = { mode = "n", lhs = "o",         rhs = function() vim.cmd("InsertNewBullet") end,     opts = { group = "list", desc = "bullets newline" } },
            renumber   = { mode = "n", lhs = "gN",        rhs = function() vim.cmd("RenumberList") end,        opts = { group = "list", desc = "bullets renumber" } },
            vrenumber  = { mode = "v", lhs  = "gN",       rhs = function() vim.cmd("RenumberSelection") end,   opts = { group = "list", desc = "bullets renumber" } },
        }

        if vim.g.bullets_enabled_file_types_tbl[vim.api.nvim_buf_get_option(0, "filetype")] then
            for _, value in pairs(bullets_mappings) do
                vim.keymap.set(value["mode"], value["lhs"], value["rhs"], value["opts.desc"])
            end
        else
            for _, value in pairs(bullets_mappings) do
                pcall(vim.keymap.del, value["mode"], value["lhs"])
            end
        end
    end
})

-- Trim trailing white-space/lines
vim.api.nvim_create_autocmd({ "BufWritePre", "InsertLeave" }, {
    group = user,
    pattern = "*",
    callback = function()
        local is_diffview = vim.fn.expand("%"):find("^diffview")

        if vim.api.nvim_buf_get_option(0, "modifiable") and not is_diffview then
            MiniTrailspace.trim()
            MiniTrailspace.trim_last_lines()
        end
    end
})

-- Overpower some buffers
vim.api.nvim_create_autocmd({ "WinEnter" }, {
    group = user,
    pattern = "*",
    callback = function()
        local bufnr = vim.fn.bufnr()

        if bufnr then
            keymap.thanos_snap(bufnr)
        end
    end
})

-- ----------------------------------------------
-- Plugins
-- ----------------------------------------------
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "TextChanged" }, {
    group = plugin,
    pattern = { "*.lua", "*.sh", "*.py" },
    callback = function()
        require('lint').try_lint()
    end
})
