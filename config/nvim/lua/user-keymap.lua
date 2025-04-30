local M = {}

-- ----------------------------------------------
-- Helpers
-- ----------------------------------------------
local bin = {
    bash = vim.env.HOMEBREW_PREFIX .. "/bin/bash --login"
}
M.bin = bin

local fk = {
    escape = "<Esc>",
    enter = "<CR>",
    space = "<Space>",
}
M.fk = fk

local function switch_toggle_state(id)
    local toggle_states

    if vim.g.toggle_states then
        toggle_states = vim.g.toggle_states
    else
        toggle_states = {}
    end

    if toggle_states[id] then
        toggle_states[id] = not toggle_states[id]
    else
        toggle_states[id] = true
    end

    vim.g.toggle_states = toggle_states

    return toggle_states[id]
end

local function git_master_or_main()
    local handle = io.popen("__git_master_or_main")
    local result = "main"

    if handle ~= nil then
        result = handle:read("*a")
        handle:close()
    end

    return result
end

local function is_git_repo()
    if os.execute("git rev-parse") == 0 then
        return true
    else
        return false
    end
end
M.is_git_repo = is_git_repo

-- Custom vim.keymap.set supporting "group"
-- This was intended to be used by WhichKey, I don't know if I'll ever go back to it.
--
---@param mode string|table ("n"|"i"|"v"|"c"|"t")
---@param lhs string
---@param rhs string|function
---@param opts table|nil
local function map(mode, lhs, rhs, opts)
    -- TODO: remove when I figure out how to fix which-key import
    assert(tostring(mode), "invalid argument: mode :string required")
    assert(tostring(lhs), "invalid argument: lhs :string required")
    assert(tostring(rhs), "invalid argument: rhs :string required")

    if opts then
        if opts.group then opts.group = nil end
        vim.keymap.set(mode, lhs, rhs, opts)
    else
        vim.keymap.set(mode, lhs, rhs)
    end
end
M.map = map

-- ----------------------------------------------
-- Keymaps
-- ----------------------------------------------
-- Clear search highlight
vim.on_key(
    function(char)
        if vim.fn.mode() == "n" then
            -- ignore these literal keys
            local new_hlsearch = vim.tbl_contains({
                "", "", "", "",
                "H", "L",
                "z", "v", "t", "m", "b",
                "n", "N",
                "*", "?", "/",
                "<ScrollWheelUp>", "<ScrollWheelDown>",
            }, vim.fn.keytrans(char))

            if vim.api.nvim_get_option_value("hlsearch", { scope = "global" }) ~= new_hlsearch then
                vim.opt.hlsearch = new_hlsearch
            end
        end
    end,
    vim.api.nvim_create_namespace "auto_hlsearch"
)
map("n", "<Leader>cs", function() vim.fn.setreg("/", "") end, { group = "gen", desc = "clear search" })

-- TKL keyboard
-- map("n", "<S-Esc>", "~", { group = "gen", desc = "tilde" })
-- map({ "i", "c" },"<C-[>", "<Esc>", { group = "gen", desc = "tilde" })
-- map({ "i", "c" },"<Esc>", "`", { group = "gen", desc = "tilde" })
-- map({ "i", "c" },"<S-Esc>", "~", { group = "gen", desc = "tilde" })

-- QOL
map("n", "<Enter>", function()
    local keypress = vim.api.nvim_replace_termcodes("<Enter>", true, false, true)

    vim.fn.setreg("/", "åß∂ƒ")

    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "terminal" then
        vim.cmd.startinsert()
        vim.api.nvim_feedkeys(keypress, "m", false)
    else
        vim.api.nvim_feedkeys(keypress, "n", false)
    end
end, { group = "gen", desc = "Enter"})
map("n", "<C-C>", function()
    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "terminal" then
        vim.cmd.startinsert()
        vim.api.nvim_feedkeys("", "n", false)
    else
        vim.api.nvim_feedkeys("", "n", false)
    end
end, { group = "gen", desc = "Enter"})
map("n", "<leader>rc", function()
    for name,_ in pairs(package.loaded) do
        if name:match("^user-") and not name:match("^user-plugins") then
            package.loaded[name] = nil
        end
    end

    dofile(vim.env.MYVIMRC)

    vim.cmd.nohlsearch()
    vim.notify("Config reloaded.")
end, { group = "gen", desc = "Reload Neovim configuration files" })
map("n", "gl", "gu")    -- "go lower" sure makes sense to me...
map("n", "gL", "gu")
map("n", "gQ", "<nop>") -- reeeeeee (use :Ex-mode if you really need it, which will be never)
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "<leader>nu", function()
    local bufnr = vim.api.nvim_win_get_buf(0)

    if vim.wo.number and vim.wo.relativenumber then
        vim.b[bufnr].num_toggle_state = true
    else
        vim.b[bufnr].num_toggle_state = false
    end

    if vim.b[bufnr].num_toggle_state then
        vim.wo.number = false
        vim.wo.relativenumber = false
    else
        vim.wo.number = true
        vim.wo.relativenumber = true
    end

    vim.b[bufnr].num_toggle_state = not vim.b[bufnr].num_toggle_state
end, { group = "gen", desc = "toggle relativenumber" })

-- fuuuuuuu (disable command-line mode, use <C-F>, see :h c_CTRL-F)
map("c", "q:", ":")
map("c", "q/", "/")
map("c", "q/", "?")

-- Yanky
map({"n", "x"}, "p", "<Plug>(YankyPutAfter)", { group = "gen", desc = "paste" })
map({"n", "x"}, "P", "<Plug>(YankyPutBefore)", { group = "gen", desc = "paste before" })
map({"n", "x"}, "<c-m>", "<Plug>(YankyPreviousEntry)", { group = "gen", desc = "yanky prev" })
map({"n", "x"}, "<c-n>", "<Plug>(YankyNextEntry)", { group = "gen", desc = "yanky next" })

-- Karen without Karenness
-- Copy/paste to/from system clipboard
map("v", "<LeftRelease>", '"+y<LeftRelease>', { group = "gen", desc = "copy on mouse select" })
map({ "n", "v" }, "<leader>y", '"+y', { group = "gen", desc = "copy to system clipboard" })
map("n", "<leader>Y", '"+y$', { group = "gen", desc = "copy -> eol to system clipboard" })
map("n", "<leader>yy", '"+yy', { group = "gen", desc = "copy line to system clipboard" })
map("n", "<leader>p", '"+p', { group = "gen", desc = "paste system clipboard" })
map("n", "<leader>P", '"+P', { group = "gen", desc = "paste system clipboard" })

-- paste (p/P)
-- map("v", "p", '"_dgvp', { group = "txt", desc = "paste" })
-- map("v", "P", '"_dgvP', { group = "txt", desc = "paste before" })
map("v", "<leader>p", "ygvp", { group = "txt", desc = "yank-paste after" })
map("v", "<leader>P", "ygvP", { group = "txt", desc = "yank-paste before" })

-- delete (d/D)
map({ "n", "v" }, "d", '"_d', { group = "txt", desc = "delete" })
map("n", "D", '"_D', { group = "txt", desc = "delete -> eol" })
map({ "n", "v" }, "<leader>d", "d", { group = "txt", desc = "yank-delete" })
map("n", "<leader>D", "D", { group = "txt", desc = "yank-delete -> eol" })

-- change (c/D)
map("", "c", '"_c', { group = "txt", desc = "change" })
map("", "C", '"_c$', { group = "txt", desc = "change -> eol" })
map("", "<leader>c", "c", { group = "txt", desc = "yank-change" })
map("", "<leader>C", "C", { group = "txt", desc = "yank-change -> eol" })

-- delete (x/X)
map("", "x", '"_x', { group = "txt", desc = "delete" })
map("", "X", '"_X', { group = "txt", desc = "delete back" })
map("", "<leader>x", "x", { group = "txt", desc = "delete cut" })
map("", "<leader>X", "X", { group = "txt", desc = "delete back & cut" })

-- maintain cursor pos
map("n", "J", "mzJ`z", { group = "txt", desc = "join w/o hop" })
map("n", "<C-u>", "<C-u>zz", { group = "gen", desc = "half-pgup" })
map("n", "<C-d>", "<C-d>zz", { group = "gen", desc = "half-pgdn" })
map("n", "<C-f>", "<C-f>zz", { group = "gen", desc = "pgup" })
map("n", "<C-b>", "<C-b>zz", { group = "gen", desc = "pgdn" })
map("n", "n", "nzzzv", { desc = "next search" })
map("n", "N", "Nzzzv", { desc = "prev search" })

-- Copy line info
map("n", "<leader>L", function()
    local current_line = vim.fn.line(".")
    local path = vim.fn.expand("%:p")
    local git_root = vim.fn.systemlist("basename \"$(git rev-parse --show-toplevel)\"")[1]
    local git_repo = vim.fn.systemlist("git remote -v | awk '{print $2}' | sed 's|.*/||'")[1]

    if git_root ~= "" then
        local intra_repo_path = string.gsub(path, ".*" .. git_root .. "/", "")
        path = git_repo .. "/" .. intra_repo_path
    end

    local path_with_line_num = string.format("%s:%d", path, current_line)

    vim.fn.setreg('"', path_with_line_num)
    vim.fn.setreg('*', path_with_line_num)
    vim.fn.setreg('+', path_with_line_num)
end, { group = "txt", desc = "path to cur line from git root"})

-- file/buffer management (auto-save, browser)
local save_if_modifiable = function()
    local modifiable = vim.bo.modifiable
    local mini_trailspace = require("mini.trailspace")
    local notify = require("notify")

    if modifiable then
        mini_trailspace.trim()
        mini_trailspace.trim_last_lines()

        local status, err = pcall(function() vim.cmd.write() end)

        if not status then
            if err and err:match("No file name") then
                vim.defer_fn(function() notify("No file name", "WARN") end, 250)
            end
        else
            vim.cmd("LspRestart")
            vim.defer_fn(function() vim.cmd.echon("''") end, 750)
        end
    end
end
map("n", "<leader>w", function() save_if_modifiable() end, { silent = true, group = "file", desc = "write/save" })
map("n", "<leader>W", function() save_if_modifiable() vim.cmd.quit() end, { silent = true, group = "file", desc = "write/save, quit" })
map("n", "<leader>rf", function()
    vim.cmd("e")
    vim.print(vim.fn.expand("%:t") .. " reloaded...")
    vim.defer_fn(function() vim.cmd.echon("''") end, 750)
end, { silent = true, group = "file", desc = "reload file" })
map("n", "<leader>u", vim.cmd.UndotreeToggle, { group = "file", desc = "open undo-tree" })
map("n", "<leader>1", function()
    vim.cmd("Neotree action=focus source=filesystem position=current toggle reveal")
end, { silent = true, group = "file", desc = "open file browser" })
map("n", "<leader>2", function()
    vim.cmd("Neotree action=show source=buffers position=current toggle reveal")
end, { silent = true, group = "file", desc = "open buffer browser" })
map({ "n", "v" }, "-", function()
    if vim.api.nvim_get_option_value("filetype", {scope = "local", buf = 0}) == "neo-tree" then
        vim.fn.feedkeys("<BS>")
    else
        vim.fn.feedkeys("-")
    end
end, { group = "file", desc = "navigate up a dir" })
map("n", "<leader>mx", function()
    local file = vim.fn.shellescape(vim.fn.expand("%"))

    if os.execute("[[ -f " .. file .. " ]]") == 0 then
        os.execute("chmod +x " .. file)
        vim.cmd.echomsg('"' .. vim.fn.expand("%") .. ' +x"')
    else
        vim.cmd.echoerr('"' .. vim.fn.expand("%") .. ' is not a file"')
    end
end, { group = "file", desc = "make file +x" })
map("n", "<leader>fr", function() MiniMisc.find_root(0, MISC_PROJECT_MARKERS) end, { group = "file", desc = "find project root"})

-- Harpoon (https://github.com/ThePrimeagen/harpoon)
-- :help harpoon
map("n", "<leader>hh", function() require("harpoon.ui").toggle_quick_menu() end, { group = "file", desc = "view live well" })
map("n", "<leader>hf", function() require("harpoon.mark").toggle_file() end, { group = "file", desc = "harpoon/release" })
map("n", "<leader>j", function() require("harpoon.ui").nav_file(1) end, { group = "file", desc = "first harpoon" })
map("n", "<leader>k", function() require("harpoon.ui").nav_file(2) end, { group = "file", desc = "second harpoon" })
map("n", "<leader>l", function() require("harpoon.ui").nav_file(3) end, { group = "file", desc = "third harpoon" })
map("n", "<leader>;", function() require("harpoon.ui").nav_file(4) end, { group = "file", desc = "fourth harpoon" })
map("n", "<C-j>", function() require("harpoon.ui").nav_prev() end, { group = "file", desc = "<< harpoon" })
map("n", "<C-k>", function() require("harpoon.ui").nav_next() end, { group = "file", desc = "harpoon >>" })
map("n", "<leader>hc", function() require("harpoon.mark").clear_all() end, { group = "file", desc = "release all harpoons" })

-- git (fugitive, gitsigns, DiffView, LazyGit)
-- :help Git
map("n", "<leader>gl", function() vim.cmd.TermExec("size=15 direction=horizontal cmd=gl") end, { group = "git", desc = "git log this branch" })
map("n", "<leader>gl-", function() vim.cmd.TermExec("size=15 direction=horizontal cmd=gl-") end, { group = "git", desc = "git log this branch, full msg" })
map("n", "<leader>gL", function() vim.cmd.TermExec("size=15 direction=horizontal cmd=gL-") end, { group = "git", desc = "git log all branches" })
map("n", "<leader>gL-", function() vim.cmd.TermExec("size=15 direction=horizontal cmd=gL-") end, { group = "git", desc = "git log all branches, full msg" })

-- git status/blame
map("n", "<leader>gs", function() vim.cmd("Git") end, { group = "git", desc = "git status" })
map("n", "<leader>gb", function() vim.cmd("Git_blame") end, { group = "git", desc = "git blame" })

-- git d, DiffView
-- :help diffview
map("n", "<leader>do", function() vim.cmd("DiffviewOpen") end, { group = "git", desc = "DiffView open" })
map("n", "<leader>dom", function() vim.cmd("DiffviewOpen origin/" .. git_master_or_main() .. "...") end, { group = "git", desc = "DiffView open" })
map("n", "<leader>df", function() vim.cmd("DiffviewFileHistory") end, { group = "git", desc = "DiffView log" })
map("n", "<leader>dtf", function() vim.cmd("DiffviewToggleFiles") end, { group = "git", desc = "DiffView file browser" })
map("n", "<leader>dr", function() vim.cmd("DiffviewRefresh") end, { group = "git", desc = "DiffView refresh" })

-- LazyGit
-- :help lazygit.nvim
map("n", "<leader>lg", function() vim.cmd("LazyGit") end, { group = "git", desc = "LazyGit" })
map("n", "<leader>lgt", function() vim.cmd("LazyGitCurrentFile") end, { group = "git", desc = "LazyGitCurrentFile" })
map("n", "<leader>lgf", function() vim.cmd("LazyGitFilter") end, { group = "git", desc = "LazyGitFilter" })
map("n", "<leader>lgff", function() vim.cmd("LazyGitFilterCurrentFile") end, { group = "git", desc = "LazyGitFilterCurrentFile" })

-- use magic when searching
-- :help magic
local set_magic_prefix = function(keymap, search_prefix)
    local pos = vim.fn.getcmdpos()

    if pos == 1 or pos == 6 then
        vim.fn.setcmdline(vim.fn.getcmdline() .. search_prefix)
    else
        vim.fn.setcmdline(vim.fn.getcmdline() .. keymap)
    end
end

map("n", "*", "*N", { group = "gen", desc = "find word at cur" })
map("n", "<leader>/", "/\\v\\c", { group = "gen", desc = "regex search" })
map("c", "%", function() set_magic_prefix("%", "%s/\\v\\c") end, { group = "gen", desc = "regex replace" })
map("c", "%%", function() set_magic_prefix("%%", "s/\\v\\c") end, { group = "gen", desc = "regex replace visual" })
map("n", "<leader>rw", ":%smagic/\\<<C-r><C-w>\\>//gI<left><left><left>", { group = "txt", desc = "replace current word" })

-- Split management
map("n", "<leader>z", function()
    local toggle_state = switch_toggle_state("zoom_bufnr_" .. vim.fn.bufnr(0))

    require("mini.misc").zoom()

    if toggle_state then
        vim.api.nvim_win_set_config(0, { height = vim.fn.winheight(0) - 2 })
    end
end, { silent = true, group = "gen", desc = "toggle zoom" })
map("n", "<leader>\\", function() vim.cmd("vsplit") end, { silent = true, group = "gen", desc = "vsplit" })
map("n", "<leader>-", function() vim.cmd("split") end, { silent = true, group = "gen", desc = "split" })
map("n", "<leader>Q", function()
    -- local modifiable = vim.api.nvim_buf_get_option(0, "modifiable")
    -- local filename = vim.api.nvim_buf_get_name(0)
    --
    -- if modifiable and #filename > 0 then
    --     vim.cmd.write()
    -- end

    vim.cmd.bp()

    if vim.api.nvim_get_option_value("buftype", {scope = "local", buf = 0}) == "terminal" then
        vim.cmd.startinsert()
    end
end, { silent = true, group = "gen", desc = "save, open alt buf" })
map("n", "<leader>q", function()
    -- local modifiable = vim.api.nvim_buf_get_option(0, "modifiable")
    -- local filename = vim.api.nvim_buf_get_name(0)
    --
    -- if modifiable and #filename > 0 then
    --     vim.cmd.write()
    -- end
    --
    vim.cmd.quit()
end, { silent = true, group = "gen", desc = "write quit" })

-- Tab management (barbar.nvim)
map("n", "<leader>tc", function() vim.cmd.tabclose() end, { group = "tab", desc = "close tab" })
map("n", "<leader>tp", function() vim.cmd("tabprevious") end, { group = "tab", desc = "prev tab" })
map("n", "<leader>tn", function() vim.cmd("tabnext") end, { group = "tab", desc = "next tab" })
map("n", "<leader>nt", function() vim.cmd("tabnew") end, { group = "tab", desc = "new tab" })
map("n", "gt", function() vim.cmd("BufferPick") end, { group = "tab", desc = "pick tab" })

-- Terminal split management
-- see toggleterm.lua plugin config

-- Split navigation and sizing
map({ "n", "i" }, "<C-h>", "<Esc><C-w>h", { group = "nav", desc = "left window" })
map({ "n", "i" }, "<C-j>", "<Esc><C-w>j", { group = "nav", desc = "down window" })
map({ "n", "i" }, "<C-k>", "<Esc><C-w>k", { group = "nav", desc = "up window" })
map({ "n", "i" }, "<C-l>", "<Esc><C-w>l", { group = "nav", desc = "right window" })

map("t", "<C-h>", "<C-\\><C-n><C-w>h", { group = "nav", desc = "left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { group = "nav", desc = "down window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { group = "nav", desc = "up window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { group = "nav", desc = "right window" })

-- my iTerm is setup to send mac ⌥ (option) key instead of meta, which will look like gibberish to most
map("n", "˚", function() vim.cmd.resize("+4") end, { group = "nav", desc = "increase win height" })
map("n", "∆", function() vim.cmd.resize("-4") end, { group = "nav", desc = "decrease win height" })
map("n", "˙", function() vim.cmd("vertical resize +8") end, { group = "nav", desc = "increase win width" })
map("n", "¬", function() vim.cmd("vertical resize -8") end, { group = "nav", desc = "decrease win width" })
map("n", "–", function() vim.cmd.wincmd("_") end, { group = "nav", desc = "maximize window height" })


-- Tab navigation
map("", "<leader>˙", function() vim.cmd.tabprevious() end, { group = "nav", desc = "prev window" })
map("", "<leader>¬", function() vim.cmd.tabnext() end, { group = "nav", desc = "next window" })

-- Window scrolling
map("n", "<C-y>", "4<C-y>", { group = "nav", desc = "scroll up 4 lines" })
map("n", "<C-e>", "4<C-e>", { group = "nav", desc = "scroll down 4 lines" })

-- ----------------------------------------------
-- Plugin Keymaps
-- ----------------------------------------------
-- nvim-ufo (https://github.com/kevinhwang91/nvim-ufo)
-- :help nvim-ufl
map("n", "zR", function() require("ufo").openAllFolds() end, { group = "ui", desc = "open all folds" })
map("n", "zM", function() require("ufo").closeAllFolds() end, { group = "ui", desc = "close all folds" })
map("n", "zr", function() require("ufo").openFoldsExceptKinds() end, { group = "ui", desc = "open folds" })
map("n", "zm", function() require("ufo").closeFoldsWith() end, { group = "ui", desc = "close folds" })

-- Telescope
-- :help telescope.builtin
-- files
map("n", "<C-p>", function()
    if vim.bo.filetype == "TelescopePrompt" then
        require("telescope.builtin").resume()
    elseif is_git_repo() then
        require("telescope.builtin").git_files({ show_untracked = true })
    else
        require("telescope.builtin").find_files()
    end
end, { group = "ts", desc = "fuzzy git files" })
map("i", "<C-p>", function()
    if vim.bo.filetype == "TelescopePrompt" then
        require("telescope.builtin").resume()
    end
end, { group = "ts", desc = "telescope resume if open" })
map("n", "<leader>?", function() require("telescope.builtin").oldfiles() end, { group = "ts", desc = "fuzzy recent files" })
map("n", "<leader>fm", function() require("telescope.builtin").man_pages() end, { group = "ts", desc = "fuzzy manpage" })
map("n", "<leader>ff", function()
    local opts = {
        cwd = require("mini.misc").find_root(0, MISC_PROJECT_MARKERS),
        hidden = true,
        no_ignore = true
    }

    require("telescope.builtin").find_files(opts)
end, { group = "ts", desc = "fuzzy files" })

-- strings
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { group = "ts", desc = "fuzzy help" })
map("n", "<leader>rg", function()
    local opts = {
        cwd = require("mini.misc").find_root(0, MISC_PROJECT_MARKERS),
        grep_open_files = false,
    }

    require("telescope.builtin").live_grep(opts)
end, { group = "ts", desc = "ripgrep" })
map("n", "<leader>fw", function()
    local opts = {
        cwd = require("mini.misc").find_root(0, MISC_PROJECT_MARKERS),
        hidden = true,
        no_ignore = true,
    }

    require("telescope.builtin").grep_string(opts)
end, { group = "ts", desc = "fuzzy word" })
map("n", "/", function()
    require("telescope.builtin").current_buffer_fuzzy_find(
        require("telescope.themes").get_ivy({ previewer = false, }))
end, { group = "ts", desc = "fuzzy in current buffer" })

-- diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { group = "diag", desc = "show errors" })
map("n", "<leader>E", vim.diagnostic.setloclist, { group = "diag", desc = "open error list" })
map("n", "[d", function() vim.diagnostic.get_pref() end, { group = "diag", desc = "previous message" })
map("n", "]d", function() vim.diagnostic.get_next() end, { group = "diag", desc = "next message" })

-- trouble
-- :help trouble.nvim.txt
map("n", "<leader>t", function() vim.cmd.TroubleToggle() end, { group = "lsp", desc = "toggle trouble" })

-- others
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { group = "ts", desc = "fuzzy buffers" })
map("n", '<leader>f"', function() require("telescope.builtin").marks() end, { group = "ts", desc = "fuzzy marks" })
map("n", "<leader>gh", function() vim.print("not implemented") end, { group = "ts", desc = "fuzzy help" })
map("n", "<leader>fk", function() require("telescope.builtin").keymaps() end, { group = "ts", desc = "fuzzy keymaps" })
map("n", "<leader>gd", function() require("telescope.builtin").lsp_definitions() end, { group = "ts", desc = "goto definition" })
map("n", "<leader>gi", function() require("telescope.builtin").lsp_implementations() end, { group = "ts", desc = "goto implementation" })
map("n", "<leader>fr", function() require("telescope.builtin").lsp_references() end, { group = "ts", desc = "find references" })
map("n", "<leader>qf", function() require("telescope.builtin").quickfix() end, { group = "ts", desc = "fuzzy quickfix" })
map("n", "<leader>fe", function() require("telescope.builtin").diagnostics() end, { group = "ts", desc = "fuzzy errors" })

-- LSP keymaps
local lsp_maps = function(_, bufnr)
    -- Format buffer with LSP
    vim.api.nvim_buf_create_user_command(
        bufnr,
        "Format",
        function(_) vim.lsp.buf.format() end,
        { desc = "format current buffer" }
    )
    map("n", "<leader>=", function() vim.cmd.Format() end, { group = "lsp", desc = "format current buffer" })

    -- refactor
    map("n", "<leader>rn", vim.lsp.buf.rename, { group = "lsp", desc = "rename" })
    map("n", "<leader>ca", vim.lsp.buf.code_action, { group = "lsp", desc = "code action" })

    -- goto
    map("n", "gd", vim.lsp.buf.definition, { group = "lsp", desc = "goto definition" })
    map("n", "gD", vim.lsp.buf.declaration, { group = "lsp", desc = "goto declaration" })
    map("n", "gr", function() require("telescope.builtin").lsp_references() end, { group = "lsp", desc = "goto references" })
    map("n", "gi", vim.lsp.buf.implementation, { group = "lsp", desc = "goto implementation" })

    -- symbols
    map("n", "K", vim.lsp.buf.hover, { group = "lsp", desc = "show symbol info" })
    map("n", "<C-s>", vim.lsp.buf.signature_help, { group = "lsp", desc = "show signature info" })
    map("n", "<leader>td", vim.lsp.buf.type_definition, { group = "lsp", desc = "type definition" })
    map("n", "<leader>S", function()
        require("telescope.builtin").lsp_document_symbols()
    end, { group = "lsp", desc = "document symbols" })
    map("n", "<leader>ws", function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
    end, { group = "lsp", desc = "workspace symbols" })

    -- workspace
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { group = "lsp", desc = "workspace add folder" })
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { group = "lsp", desc = "workspace remove folder" })
    map("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { group = "lsp", desc = "workspace list folders" })
end
M.lsp_maps = lsp_maps

-- Treesitter keymaps
local treesitter_maps = {
    incremental_selection = {
        init_selection = "<C-Space>",
        node_incremental = "<C-Space>",
        scope_incremental = "<C-s>",
        node_decremental = "<M-space>",
    },
    textobjects = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
    },
    move = {
        goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
        },
        goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
        },
        goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
        },
        goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
        },
    },
    swap = {
        swap_next = {
            ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
            ["<leader>A"] = "@parameter.inner",
        },
    }
}
M.treesitter_maps = treesitter_maps

-- Treesitter keymaps
local treesitter_playground_maps = {
    toggle_query_editor = 'o',
    toggle_hl_groups = 'i',
    toggle_injected_languages = 't',
    toggle_anonymous_nodes = 'a',
    toggle_language_display = 'I',
    focus_language = 'f',
    unfocus_language = 'F',
    update = 'R',
    goto_node = '<cr>',
    show_help = '?',
}
M.treesitter_playground_maps = treesitter_playground_maps

-- trouble.nvim keymaps
local trouble_maps = { -- key mappings for actions in the trouble list
    -- map to {} to remove a mapping, for example:
    -- close = {},
    close = "q",                                 -- close the list
    cancel = "<esc>",                            -- cancel the preview and get back to your last window / buffer / cursor
    refresh = "r",                               -- manually refresh
    jump = { "<cr>", "<tab>", "<2-leftmouse>" }, -- jump to the diagnostic or open / close folds
    open_split = { "<c-x>" },                    -- open buffer in new split
    open_vsplit = { "<c-v>" },                   -- open buffer in new vsplit
    open_tab = { "<c-t>" },                      -- open buffer in new tab
    jump_close = { "o" },                        -- jump to the diagnostic and close the list
    toggle_mode = "m",                           -- toggle between "workspace" and "document" diagnostics mode
    switch_severity = "s",                       -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
    toggle_preview = "P",                        -- toggle auto_preview
    hover = "K",                                 -- opens a small popup with the full multiline message
    preview = "p",                               -- preview the diagnostic location
    open_code_href = "c",                        -- if present, open a URI with more information about the diagnostic error
    close_folds = { "zM", "zm" },                -- close all folds
    open_folds = { "zR", "zr" },                 -- open all folds
    toggle_fold = { "zA", "za" },                -- toggle fold of current file
    previous = "k",                              -- previous item
    next = "j",                                  -- next item
    help = "?",                                  -- help menu
}
M.trouble_maps = trouble_maps

-- Unmap annoying maps forced by plugin authors
local unimpaired = { "<s", ">s", "=s", "<p", ">p", "<P", ">P" }
local bullets = { "<<", "<", ">", ">>" }

--- get_off_my_lawn delete keymaps
--
--- @param args table[list(string), ...]
local function get_off_my_lawn(args)
    for _, tbl in ipairs(args) do
        for _, v in ipairs(tbl) do
            vim.keymap.del("", v)
        end
    end
end

pcall(get_off_my_lawn, { unimpaired, bullets })

return M
