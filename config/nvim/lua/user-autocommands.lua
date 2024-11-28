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
vim.api.nvim_create_autocmd({"CursorHold", "FocusGained"}, {
    group = nvim,
    pattern = "*",
    callback = function()
        if vim.fn.mode ~= "c" then
            vim.cmd.checktime() -- auto-reload from disk
        end
    end
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = nvim,
    pattern = "*",
    callback = function()
        vim.cmd.echohl("WarningMsg File changed on disk. Buffer reloaded.")
        vim.defer_fn(function() vim.cmd.echohl("None") end, 750)
    end
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = nvim,
    pattern = "*",
    callback = function()
        -- maximize window height on start... Probably a toggle term issue
        vim.cmd.wincmd("_")

        -- set by .envrc
        local session_file_path = vim.env.NVIM_SESSION_FILE_PATH

        if session_file_path then
            local session_dir = session_file_path:match("(.*/)")

            if session_dir and vim.fn.isdirectory(session_dir) == 0 then
                os.execute("mkdir --parents " .. session_dir)

                if vim.fn.filereadable(session_file_path) == 0 then
                    os.execute("rm -rf" .. session_file_path)
                    os.execute("touch " .. session_file_path)
                end
            end

            vim.cmd("silent Obsession " .. session_file_path)
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

-- ----------------------------------------------
-- Filetype
-- ----------------------------------------------
-- bash files with no extension
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = ui,
    pattern = {
        ".envrc",
        ".bashrc",
    },
    callback = function()
        vim.cmd.set("ft=sh")
    end
})

-- git commit message
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = ui,
    pattern = {"COMMIT_EDITMSG", "gitcommit"},
    callback = function()
        vim.wo.colorcolumn = "72"
        vim.wo.list = true
        vim.wo.number = true
        vim.wo.relativenumber = true
        vim.wo.spell = true
    end
})

-- markdown comments
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = ui,
    pattern = "markdown",
    callback = function()
        vim.bo.commentstring = "[//]: # (%s)"
    end
})

-- helm
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = ui,
    pattern = {
        "*/templates/*.yaml",
        "*/templates/*.tpl",
        "*.gotmpl",
        "helmfile*.yaml",
        "*.helm.yaml",
    },
    callback = function()
        vim.cmd.set("ft=helm")
        vim.cmd.setlocal([[commentstring={{/*\ %s\ */}}]])
    end,
})


-- terraform
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = ui,
    pattern = "terraform",
    callback = function()
        vim.bo.commentstring = "# %s"
    end,
})

-- terraform vars
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = ui,
    pattern = "terraform-vars",
    callback = function()
        vim.treesitter.start(0, "hcl")
    end,
})

-- files that use tab indentation
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = ui,
    pattern = { "gitconfig", "terminfo" },
    callback = function()
        vim.bo.expandtab = false
        vim.wo.listchars = table.concat({
            "tab:⇢•",
            "precedes:«",
            "extends:»",
            "trail:•",
            "nbsp:•",
        }, ",")
    end
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = ui,
    pattern = "term",
    callback = function()
        vim.cmd.startinsert()
    end,
})

-- ----------------------------------------------
-- User
-- ----------------------------------------------
-- Fix shitty bullets plugin bindings, only one that does markdown bullets correctly
vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave" }, {
    group = user,
    pattern = "*",
    callback = function()
        local bullets_mappings = {
            promote = { mode = "i", lhs = "<C-d>", rhs = function()
                vim.cmd("BulletPromote")
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>$", true, false, true), "n", false)
                vim.api.nvim_feedkeys(" ", "i", true)
            end, opts = { group = "list", desc = "bullets promote" } },
            demote = { mode = "i", lhs = "<C-t>", rhs = function()
                vim.cmd("BulletDemote")
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>$", true, false, true), "n", false)
                vim.api.nvim_feedkeys(" ", "i", true)
            end, opts = { group = "list", desc = "bullets demote" } },

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
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = plugin,
    pattern = ".github/*/*", -- only run on YAML files in the `.github` dir
    callback = function()
        local modifiable = vim.api.nvim_buf_get_option(0, "modifiable")
        local filename = vim.api.nvim_buf_get_name(0)

        if modifiable and #filename > 0 then
            local lint = require("lint")

            lint.linters.actionlint.args = { "-config-file", ".github/actionlint.yml" }
            lint.try_lint("actionlint")
        end
    end
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = plugin,
    pattern = "*",
    callback = function()
        local modifiable = vim.api.nvim_buf_get_option(0, "modifiable")
        local filename = vim.api.nvim_buf_get_name(0)

        if modifiable and #filename > 0 then
            require("lint").try_lint()
        end
    end
})

-- ----------------------------------------------
-- Last
-- ----------------------------------------------
-- clean ui filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = ui,
    pattern = {
        "Trouble",
        "checkhealth",
        "git",
        "help",
        "lspinfo",
        "man",
        "packer",
        "qf",
        "term",
        "toggleterm",
    },
    callback = function()
        vim.wo.colorcolumn = ""
        vim.wo.cursorline = false
        vim.wo.foldcolumn = "auto"
        vim.wo.list = false
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = "auto"
        vim.wo.spell = false
        vim.wo.statuscolumn = ""

        local numbers_exception_ft = {
            help = true,
        }

        if numbers_exception_ft[vim.bo.filetype] then
            vim.wo.number = true
            vim.wo.relativenumber = true
        end
    end
})

-- Git commit messages
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = ui,
    pattern = { "gitcommit" },
    callback = function()
        vim.wo.colorcolumn = ""
        vim.wo.list = true
        vim.wo.number = true
        vim.wo.relativenumber = true
        vim.wo.spell = true
    end
})

-- Terminals
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
    group = ui,
    pattern = "*",
    callback = function()
        vim.wo.spell = false
        vim.wo.number = false
        vim.wo.relativenumber = false
    end,
})

-- maximize window height on start... Probably a toggle term issue
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = ui,
    pattern = "*",
    callback = function()
        vim.cmd.wincmd("_")
    end
})
