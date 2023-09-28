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
-- Plugins
-- ----------------------------------------------
-- setup nested comments on attach
vim.api.nvim_create_autocmd("BufEnter", {
    group = plugin,
    pattern = "*",
    callback = function()
        pcall(require('mini.misc').use_nested_comments)
    end,
})

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
vim.api.nvim_create_autocmd({ "BufEnter", "TermEnter", "WinEnter", "TabEnter", "WinScrolled", "VimResized" }, {
    group = ui,
    pattern = "*",
    callback = function()
        local cur_win_height = vim.fn.ceil(vim.api.nvim_win_get_height(0) * 0.66)
        if cur_win_height then vim.opt.scroll = cur_win_height end
    end
})

-- Set options for specific file and buffer types
vim.api.nvim_create_autocmd({ "BufWinEnter", "TermEnter", "BufEnter", "TabEnter", "WinEnter" }, {
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
            starter = true,
            Trouble = true,
        }

        local tab_filetypes = {
            gitconfig = true,
            terminfo = true,
        }

        local filetype = vim.bo.filetype
        local buftype = vim.bo.buftype

        filetype = filetype or "nofiletype"
        buftype = buftype or "nobuftype"

        -- keep other plugins from changing nvim-ufo fold settings
        vim.opt.foldcolumn = "1"
        vim.opt.foldlevel = 99
        vim.opt.foldlevelstart = 99
        vim.opt.foldenable = false

        -- disable ui elements in view-only type buffers
        if (clean_filetypes[filetype] or clean_buftypes[buftype]) then
            vim.wo.colorcolumn = false
            vim.wo.cursorline = false
            vim.wo.foldcolumn = "auto"
            vim.wo.list = false
            vim.wo.number = false
            vim.wo.relativenumber = false
            vim.wo.signcolumn = "auto"
            vim.wo.spell = false
            vim.wo.statuscolumn = ""
        end

        -- force neo-tree ui settings
        if vim.bo.filetype == "neo-tree" then
            -- vim.api.nvim_buf_set_option(0, "bufhidden", "delete")
            -- vim.api.nvim_buf_set_option(0, "buflisted", false)
            vim.wo.colorcolumn = false
            vim.wo.number = true
            vim.wo.relativenumber = true
        end

        -- use tabs in specific files
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
            and vim.api.nvim_buf_get_option(0, "modifiable")
            and vim.fn.expand("%") ~= "" then

            vim.cmd.write()
            pcall(vim.cmd.write)
            vim.defer_fn(function() vim.cmd.echon("''") end, 500)
        end
    end
})

-- Map/unmap shitty plugin auto bindings
vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave" }, {
    group = user,
    pattern = "*",
    callback = function()
        local bullets_mappings = {
            promote    = { mode = "i", lhs = "<C-d>",     rhs = function()
                vim.cmd("BulletPromote")
                vim.fn.feedkeys("<Esc>A")
            end,       opts = { group = "list", desc = "bullets promote" } },
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
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = user,
    pattern = "*",
    callback = function()
        local file_name = vim.fn.expand("%")
        local is_diffview = file_name:find("^diffview")

        if file_name ~= "" and vim.api.nvim_buf_get_option(0, "modifiable") and not is_diffview then
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
            keymap.snap(bufnr)
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
