-- ----------------------------------------------
-- Auto-command Groups
-- ----------------------------------------------
local nvim = vim.api.nvim_create_augroup("NVIM", { clear = true })
local ui = vim.api.nvim_create_augroup("UI", { clear = true })
local user = vim.api.nvim_create_augroup("USER", { clear = true })
local plugin = vim.api.nvim_create_augroup("PLUGIN", { clear = true })
local easy_quit_group = vim.api.nvim_create_augroup("EasyQuit", { clear = true })


-- ----------------------------------------------
-- Neovim
-- ----------------------------------------------
-- Always create and use a session file in the local directory
vim.api.nvim_create_autocmd("VimEnter", {
    group = nvim,
    pattern = "*",
    callback = function()
        -- Maximize window height on start (happens, probably a toggle term issue)
        vim.cmd.wincmd("_")

        -- Helper to get the project root
        local function get_git_or_cwd()
            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
            if git_root and git_root ~= "" then
                return git_root
            else
                return vim.fn.getcwd()
            end
        end

        local session_file_name = vim.env.VIM_SESSION_FILE or ".session.vim"
        local project_root = get_git_or_cwd()

        -- Helper to create session file
        local function ensure_session_file_exists()
            local full_session_path = project_root .. "/" .. session_file_name

            if vim.fn.filereadable(full_session_path) == 0 then
                vim.fn.writefile({}, full_session_path)
            end

            return full_session_path
        end

        local session_path = ensure_session_file_exists()

        -- Use or create session with Obsession
        vim.cmd("silent Obsession " .. session_path)
    end
})

-- auto-reload from disk
vim.api.nvim_create_autocmd({ "CursorHold", "FocusGained" }, {
    group = nvim,
    pattern = "*",
    callback = function()
        if vim.fn.mode ~= "c" then
            vim.cmd.checktime()
        end
    end
})

-- Warn when a file was changed outside of nvim
local notify = require("notify")
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = nvim,
    pattern = "*",
    callback = function()
        notify("WarningMsg File changed on disk. Buffer reloaded.", "warn")
    end
})

-- ----------------------------------------------
-- Plugins
-- ----------------------------------------------
-- setup nested comments on attach
vim.api.nvim_create_autocmd('BufEnter', { callback = function() require("mini.misc").use_nested_comments() end })

-- ----------------------------------------------
-- UI
-- ----------------------------------------------
-- Show cursorline when search highlight is active
vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    group = ui,
    pattern = "*",
    callback = function()
        if vim.v.hlsearch == 1 then
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
        vim.opt.filetype = "sh"
    end
})

-- git commit message
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = ui,
    pattern = { "COMMIT_EDITMSG", "gitcommit" },
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

-- terraform
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = ui,
    pattern = "terraform",
    callback = function()
        vim.bo.commentstring = "# %s"
    end,
})

-- files that use tab indentation
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = ui,
    pattern = { "gitconfig", "terminfo", "make", "cmake" },
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

-- Start in insert mode when opening a terminal (:term)
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
            promote    = {
                mode = "i",
                lhs = "<C-d>",
                rhs = function()
                    vim.cmd("BulletPromote")
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>$", true, false, true), "n", false)
                    vim.api.nvim_feedkeys(" ", "i", true)
                end,
                opts = { group = "list", desc = "bullets promote" }
            },
            demote     = {
                mode = "i",
                lhs = "<C-t>",
                rhs = function()
                    vim.cmd("BulletDemote")
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>$", true, false, true), "n", false)
                    vim.api.nvim_feedkeys(" ", "i", true)
                end,
                opts = { group = "list", desc = "bullets demote" }
            },

            vpromote   = { mode = "v", lhs = "<C-d>", rhs = function() vim.cmd("BulletPromoteVisual") end, opts = { group = "list", desc = "bullets promote" } },
            vdemote    = { mode = "v", lhs = "<C-t>", rhs = function() vim.cmd("BulletDemoteVisual") end, opts = { group = "list", desc = "bullets demote" } },
            enter      = { mode = "i", lhs = "<CR>", rhs = function() vim.cmd("InsertNewBullet") end, opts = { group = "list", desc = "bullets newline" } },
            checkbliox = { mode = "n", lhs = "<leader>x", rhs = function() vim.cmd("ToggleCheckbox") end, opts = { group = "list", desc = "bullets toggle checkbox" } },
            openline   = { mode = "n", lhs = "o", rhs = function() vim.cmd("InsertNewBullet") end, opts = { group = "list", desc = "bullets newline" } },
            renumber   = { mode = "n", lhs = "gN", rhs = function() vim.cmd("RenumberList") end, opts = { group = "list", desc = "bullets renumber" } },
            vrenumber  = { mode = "v", lhs = "gN", rhs = function() vim.cmd("RenumberSelection") end, opts = { group = "list", desc = "bullets renumber" } },
        }

        if vim.g.bullets_enabled_file_types_tbl[vim.api.nvim_get_option_value("filetype", { buf = 0 })] then
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

-- ----------------------------------------------
-- Easy Quit with q
-- ----------------------------------------------
-- Easy quit filetypes
local quit_filetypes = {
    "help",
    "qf",
    "man",
    "checkhealth",
    "lspinfo"
}

-- Easy quit buffer types
local quit_buftypes = {
    "prompt",
    "quickfix",
    "nofile"
}

-- Filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = easy_quit_group,
    pattern = quit_filetypes,
    callback = function(args)
        local bufnr = args.buf

        -- For prompt buffers, always enable the q mapping
        if vim.bo[bufnr].buftype == "prompt" then
            vim.keymap.set("n", "q", vim.cmd.quit, {
                buffer = bufnr,
                noremap = true,
                silent = true,
                desc = "Close buffer with q"
            })
            return
        end

        -- For other buffer types, only set the mapping if buffer is not modifiable and readonly
        if not vim.bo[bufnr].modifiable and vim.bo[bufnr].readonly then
            vim.keymap.set("n", "q", vim.cmd.quit, {
                buffer = bufnr,
                noremap = true,
                silent = true,
                desc = "Close buffer with q"
            })
        end
    end
})

-- Buffer types
vim.api.nvim_create_autocmd("BufEnter", {
    group = easy_quit_group,
    callback = function(args)
        local bufnr = args.buf
        local buftype = vim.bo[bufnr].buftype

        if not vim.tbl_contains(quit_buftypes, buftype) then
            return
        end

        -- For prompt buffers, always enable the q mapping
        if buftype == "prompt" then
            vim.keymap.set("n", "q", vim.cmd.quit, {
                buffer = bufnr,
                noremap = true,
                silent = true,
                desc = "Close buffer with q"
            })
            return
        end

        -- For other buffer types, only set the mapping if buffer is not modifiable and readonly
        if not vim.bo[bufnr].modifiable and vim.bo[bufnr].readonly then
            vim.keymap.set("n", "q", vim.cmd.quit, {
                buffer = bufnr,
                noremap = true,
                silent = true,
                desc = "Close buffer with q"
            })
        end
    end
})

-- ----------------------------------------------
-- Linting
-- ----------------------------------------------
-- Action lint, only run on yaml files under the `.github/` directory
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = plugin,
    pattern = { "*.yaml", "*.yml" },
    callback = function()
        local modifiable = vim.api.nvim_get_option_value("modifiable", { buf = 0 })
        local filename = vim.api.nvim_buf_get_name(0)
        local filepath = vim.fn.expand("%:p")

        if modifiable and #filename > 0 and string.match(filepath, "%.github/") then
            local lint = require("lint")

            lint.linters.actionlint.args = { "-config-file", ".github/actionlint.yml" }
            vim.diagnostic.reset()
            lint.try_lint("actionlint")
        end
    end
})

-- .env, .envrc
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = plugin,
    pattern = { "*.env", "*.envrc" },
    callback = function()
        local modifiable = vim.api.nvim_get_option_value("modifiable", { buf = 0 })
        local filename = vim.api.nvim_buf_get_name(0)

        if modifiable and #filename > 0 then
            local lint = require("lint")

            lint.try_lint("dotenv-linter")
        end
    end
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = plugin,
    pattern = "*",
    callback = function()
        local modifiable = vim.api.nvim_get_option_value("modifiable", { buf = 0 })
        local filename = vim.api.nvim_buf_get_name(0)

        if modifiable and #filename > 0 then
            local lint = require("lint")

            lint.try_lint()
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
