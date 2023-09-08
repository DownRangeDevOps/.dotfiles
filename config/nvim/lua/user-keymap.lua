local M = {}

-- ----------------------------------------------
-- Helpers
-- ----------------------------------------------
local bin = {
    bash = vim.env.BREW_PREFIX .. "/bin/bash --login"
}
M.bin = bin

local fk = {
    escape = "<Esc>",
    enter = "<CR>",
    space = "<Space>",
}
M.fk = fk

local function is_git_repo()
    if os.execute("git rev-parse") == 0 then
        return true
    else
        return false
    end
end
M.is_git_repo = is_git_repo

local function extend_tbl(tbl, keys, value)
  local last_key = keys[#keys]

  for i = 1, #keys - 1 do
    local key = keys[i]

    if not tbl[key] then
      tbl[key] = {}
    end

    tbl = tbl[key]
  end

  if not tbl[last_key] then
    tbl[last_key] = {}
  end

  tbl[last_key] = value
end

local function parse_lhs(lhs)
    local head
    local tail = nil
    local prefix = nil

    if string.len(lhs) > 1 then
        if string.find(lhs, "^<") then
            prefix = string.lower(string.match(lhs, "^(.->)"))
            head = string.match(lhs, "^.->(.)")
            tail = string.match(lhs, "^.->.(.*)")
        else
            head = string.sub(lhs, 1, 1)
            tail = string.sub(lhs, 2)
        end

        if head == "" or head == nil then head = prefix end
        if tail == "" or tail == nil then tail = head end
    else
        head = lhs
        tail = head
    end


    return { head = head, tail = tail, prefix = prefix }
end

-- populate with info needed to register keys with `which-key`
local which_key_register_keys = {}

--- map generates a table used to register keys with `which-key`
--
--- @param modes string|table ("n": normal|"i": insert|"v": visual|"c": command|"t": terminal)
--- @param lhs string
--- @param rhs string|function
--- @param opts table|nil
local function map(modes, lhs, rhs, opts)

    assert(tostring(modes), "argument(s) missing: mode :string|table required")
    assert(tostring(lhs), "argument(s) missing: lhs :string required")
    assert(tostring(rhs), "argument(s) missing: rhs :string required")

    local desc = nil
    local group = "none"
    local which_key_opts = {}
    local lhs_pieces = parse_lhs(lhs)

    if opts then
        if opts.desc then desc = opts.desc end
        if opts.group then group = opts.group end

        which_key_opts = {
            buffer = opts.buffer or nil,
            silent = opts.silent or true,
            noremap = opts.noremap or true,
            nowait = opts.nowait or false,
            expr = opts.expr or false,
        }
    end

    if lhs_pieces.prefix then which_key_opts["prefix"] = lhs_pieces.prefix end

    if type(modes) == "string" then modes = { modes } end

    for _, mode in ipairs(modes) do
        extend_tbl(which_key_register_keys, { group, mode, lhs_pieces.head }, {
            lhs = lhs_pieces.tail,
            rhs = rhs,
            desc = desc,
            opts = which_key_opts
        })
    end
end
-- M.map = map

-- Shortcut for vim.keymap.set
--
---@param mode string|table ("n"|"i"|"v"|"c"|"t")
---@param lhs string
---@param rhs string|function
---@param opts table|nil
local map = function(mode, lhs, rhs, opts)
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

-- You should have gone for the head...
local function thanos_snap(bufnr)
    local modifiable = vim.api.nvim_buf_get_option(bufnr, "modifiable")
    local readonly = vim.api.nvim_buf_get_option(bufnr, "readonly")
    local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    local the_unfortunate = { "help", "qf", "man", "checkhouth", "lspinfo", "checkhealth" } -- file types
    local the_disgraced = { "quickfix", "prompt", "nofile" } -- buf types

    local snap_while_wearing_a_gauntlet = function ()
        map("n", "q", ":quit", { buffer = bufnr, group = "gui", desc = "don't @ me" })
    end

    if bufnr then
        if buftype == "prompt" then
            snap_while_wearing_a_gauntlet()
        else
            if not modifiable and readonly and (the_unfortunate[filetype] or the_disgraced[buftype]) then
                snap_while_wearing_a_gauntlet()
            end
        end
    end
end

M.snap = thanos_snap

-- ----------------------------------------------
-- Keymaps
-- ----------------------------------------------
-- Clear search highlight
vim.on_key(
    function(char)
        if vim.fn.mode() == "n" then
            local new_hlsearch = vim.tbl_contains(
            {"v", "n", "N", "*", "?", "/" },
                vim.fn.keytrans(char)
            )

            if vim.opt.hlsearch:get() ~= new_hlsearch then
                vim.opt.hlsearch = new_hlsearch
            end
        end
    end,
    vim.api.nvim_create_namespace "auto_hlsearch"
)

-- QOL
map("i", "jj", fk.escape, { group = "gen", desc = "Escape" })
map("n", "gl", "gu") -- err "go lower" sure makes sense to me...
map("n", "gL", "gu") -- err "go lower" sure makes sense to me...
map("n", "gQ", "<nop>") -- reeeeeee (use :Ex-mode if you really need it, which will be never)
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- fuuuuuuu (disable command-line mode, use <C-F>, see :h c_CTRL-F)
map("c", "q:", ":")
map("c", "q/", "/")
map("c", "q/", "?")

-- Karen without Karenness
-- Copy/paste to/from system clipboard
map("v", "<LeftRelease>", '"+y<LeftRelease>', { group = "gen", desc = "copy on mouse select" })
map({ "n", "v" }, "<leader>y", '"+y', { group = "gen", desc = "copy to system clipboard" })
map("n", "<leader>Y", '"+Y', { group = "gen", desc = "copy -> eol to system clipboard" })
map("n", "<leader>yy", '"+yy', { group = "gen", desc = "copy line to system clipboard" })
map("n", "<leader>p", '"+p', { group = "gen", desc = "paste system clipboard" })
map("n", "<leader>P", '"+P', { group = "gen", desc = "paste system clipboard" })

-- paste (p/P)
map("v", "p", '"_dgvp', { group = "txt", desc = "paste" })
map("v", "P", '"_dgvP', { group = "txt", desc = "paste after" })
map("v", "<leader>p", "ygvp", { group = "txt", desc = "yank-paste after" })
map("v", "<leader>P", "ygvP", { group = "txt", desc = "yank-paste after" })

-- delete (d/D)
map({ "n", "v" }, "d", '"_d', { group = "txt", desc = "delete" })
map("n", "D", '"_D', { group = "txt", desc = "delete -> eol" })
map({ "n", "v" }, "<leader>d", "d", { group = "txt", desc = "yank-delete" })
map("n", "<leader>D", "D", { group = "txt", desc = "yank-delete -> eol" })

-- change (c/D)
map("", "c", '"_c', { group = "txt", desc = "change" })
map("", "C", '"_C', { group = "txt", desc = "change -> eol" })
map("", "<leader>c", "c", { group = "txt", desc = "yank-change"})
map("", "<leader>C", "C", { group = "txt", desc = "yank-change -> eol"})

-- cut (x/X)
map("", "x", '"_x', { group = "txt", desc = "delete" })
map("", "X", '"_X', { group = "txt", desc = "delete -> eol" })
map("", "<leader>x", "d", { group = "txt", desc = "yank-cut"})
map("", "<leader>X", "D", { group = "txt", desc = "yank-cut -> eol"})

-- maintain cursor pos
map("n", "J", "mzJ`z", { group = "txt", desc = "join w/o hop" })
map("n", "<C-u>", "<C-u>zz", { group = "gen", desc = "pgup" })
map("n", "<C-d>", "<C-d>zz", { group = "gen", desc = "pgdn" })
map("n", "n", "nzzzv", { desc = "next search" })
map("n", "N", "Nzzzv", { desc = "prev search" })

-- file/buffer management (auto-save, browser)
map("n", "<leader>w", function()
    local modifiable  = vim.api.nvim_buf_get_option(0, "modifiable")
    if modifiable then vim.cmd.write() end
end, { silent = true, group = "file", desc = "write to file" })
map("n", "<leader>u", vim.cmd.UndotreeToggle, { group = "file", desc = "open undo-tree"  })
map("n", "<leader>1", function() vim.cmd(
    "Neotree action=focus source=filesystem position=current toggle reveal") end,
    { silent = true, group = "file", desc = "open browser" })
map("n", "<leader>2", function() vim.cmd(
    "Neotree action=show source=filesystem position=left toggle reveal") end,
    { silent = true, group = "file", desc = "open sidebar browser" })
map({ "n", "v" }, "-", function()
    if vim.api.nvim_buf_get_option(0, "filetype") == "neo-tree" then
        vim.fn.feedkeys("<BS>") else vim.fn.feedkeys("-") end
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

-- git (fugitive, gitsigns, diffview)
-- :help Git
map("n", "<leader>gl", function()
    vim.cmd.TermExec("size=15 direction=horizontal cmd=gl")
end, { group = "git", desc = "git log this branch"})
--
map("n", "<leader>gl-", function()
    vim.cmd.TermExec("size=15 direction=horizontal cmd=gl-")
end, { group = "git", desc = "git log this branch, full msg"})
--
map("n", "<leader>gL", function()
    vim.cmd.TermExec("size=15 direction=horizontal cmd=gL-")
end, { group = "git", desc = "git log all branches"})
--
map("n", "<leader>gL-", function()
    vim.cmd.TermExec("size=15 direction=horizontal cmd=gL-")
end, { group = "git", desc = "git log all branches, full msg"})

-- git status/blame
map("n", "<leader>gs", function() vim.cmd("Git") end, { group = "git", desc = "git status"})
map("n", "<leader>gb", function() vim.cmd("Git_blame") end, { group = "git", desc = "git blame"})

-- git diff
-- :help diffview
map("n", "<leader>do", function() vim.cmd("DiffviewOpen") end, { group = "git", desc = "diffview open"})
map("n", "<leader>df", function() vim.cmd("DiffviewFileHistory") end, { group = "git", desc = "diffview log"})
map("n", "<leader>dtf", function() vim.cmd("DiffviewToggleFiles") end, { group = "git", desc = "diffview file browser"})
map("n", "<leader>dr", function() vim.cmd("DiffviewRefresh") end, { group = "git", desc = "diffview refresh"})

-- gitsigns
-- :help gitsigns.txt
local gitsigns_maps = function(bufnr)
    vim.keymap.set("n", "<leader>p", require("gitsigns").prev_hunk, { buffer = bufnr, desc = "go prev hunk" })
    vim.keymap.set("n", "<leader>nh", require("gitsigns").next_hunk, { buffer = bufnr, desc = "go next hunk" })
    vim.keymap.set("n", "<leader>hp", require("gitsigns").preview_hunk, { buffer = bufnr, desc = "preview hunk" })
    vim.keymap.set("n", "<leader>hu", require("gitsigns").reset_hunk, { buffer = bufnr, desc = "reset hunk" })
    vim.keymap.set("n", "<leader>ha", require("gitsigns").stage_hunk, { buffer = bufnr, desc = "stage hunk" })
end
M.gitsigns_maps = gitsigns_maps

-- use magic when searching
-- :help magic
local use_magic = function(key, prefix)
    local pos = vim.fn.getcmdpos()

    if pos == 1 or pos == 6 then
        vim.fn.setcmdline(vim.fn.getcmdline() .. prefix)
    else
        vim.fn.setcmdline(vim.fn.getcmdline() .. key)
    end
end

map("n", "*", "*N", { group = "gen", desc = "find word at cur"})
map("n", "/", "/\\v\\c", { group = "gen", desc = "regex search" })
map("c", "%", function() use_magic("%", "%s/\\v\\c") end, { group = "gen", desc = "regex replace" })
map("c", "%%", function() use_magic("%%", "s/\\v\\c") end, { group = "gen", desc = "regex replace visual" })
map("n", "<leader>rw", ":%smagic/\\<<C-r><C-w>\\>//gI<left><left><left>", { group = "txt", desc = "replace current word"})

-- Split management
map("n", "<leader>z", function() require("mini.misc").zoom() end, { silent = true, group = "gen", desc = "toggle zoom" })
map("n", "<leader>\\", function() vim.cmd("vsplit") end, { silent = true, group = "gen", desc = "vsplit" })
map("n", "<leader>-", function() vim.cmd("split") end, { silent = true, group = "gen", desc = "split" })
map("n", "<leader>q", function()
    vim.cmd.write()
    vim.cmd.buffer("#")
    vim.cmd.bwipeout("#")

    if vim.api.nvim_buf_get_option(0, "buftype") == "terminal" then
        vim.cmd.startinsert()
    end
end, { silent = true, group = "gen", desc = "close" })
map("n", "<leader>Q", function() vim.cmd("quit!") end, { silent = true, group = "gen", desc = "quit" })
map("n", "<leader>tc", function() vim.cmd.tabclose() end, { group = "gen", desc = "close tab"})

-- Terminal split management
map("n", "`", function()
    vim.cmd("ToggleTerm size=15 direction=horizontal")

    if vim.api.nvim_buf_get_option(0, "buftype") == "terminal" then
        vim.cmd.startinsert()
    end
end, { group = "gen", desc = "bottom terminal"})
map("n", "<leader>`", function()
    vim.cmd.vsplit("term://" .. bin.bash)
    vim.cmd.startinsert()
end, { silent = true, group = "gen", desc = ":vsplit term" })

map("n", "<leader>~", function()
    vim.cmd.split("term://" .. bin.bash)
    vim.cmd.startinser()
end, { silent = true, group = "gen", desc = ":split term" })

-- Split navigation and sizing
map({ "n" }, "<C-h>", "<C-w>h", { group = "nav", desc = "left window" })
map({ "n" }, "<C-j>", "<C-w>j", { group = "nav", desc = "down window" })
map({ "n" }, "<C-k>", "<C-w>k", { group = "nav", desc = "up window" })
map({ "n" }, "<C-l>", "<C-w>l", { group = "nav", desc = "right window" })

map("t", "<C-h>", "<C-\\><C-n><C-w>h", { group = "nav", desc = "left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { group = "nav", desc = "down window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { group = "nav", desc = "up window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { group = "nav", desc = "right window" })

-- my iTerm is setup to send mac ⌥ (option) key instead of meta, which will look like gibberish to most
map("n", "˚", function() vim.cmd.resize("+2") end, { group = "nav", desc = "increase win height" })
map("n", "∆", function() vim.cmd.resize("-2") end, { group = "nav", desc = "decrease win height" })
map("n", "˙", function() vim.cmd("vertical resize +2") end, { group = "nav", desc = "increase win width" })
map("n", "¬", function() vim.cmd("vertical resize -2") end, { group = "nav", desc = "decrease win width" })

-- Tab navigation
map("", "<leader>˙", function() vim.cmd.tabprevious() end, { group = "nav", desc = "prev window" })
map("", "<leader>¬", function() vim.cmd.tabnext() end, { group = "nav", desc = "next window" })

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
    if is_git_repo() then
        vim.print("Running Telescope git_files in " .. vim.cmd.pwd())
        require("telescope.builtin").git_files({show_untracked = true})
    else
        vim.print("Running Telescope find_files in " .. vim.cmd.pwd())
        require("telescope.builtin").find_files()
    end
end, { group = "ts", desc = "fuzzy git files" })
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { group = "ts", desc = "fuzzy files" })
map("n", "<leader>?", function() require("telescope.builtin").oldfiles() end, { group = "ts", desc = "fuzzy recent files" })
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { group = "ts", desc = "fuzzy help" })
map("n", "<leader>fm", function() require("telescope.builtin").man_pages() end, { group = "ts", desc = "fuzzy manpage" })
map("n", "<leader>rg", function() require("telescope.builtin").live_grep() end, { group = "ts", desc = "ripgrep" })

-- strings
map("n", "<leader>fw", function() require("telescope.builtin").grep_string() end, { group = "ts", desc = "fuzzy word" })

-- diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { group = "diag", desc = "show errors" })
map("n", "<leader>E", vim.diagnostic.setloclist, { group = "diag", desc = "open error list" })
map("n", "[d", vim.diagnostic.goto_prev, { group = "diag", desc = "previous message" })
map("n", "]d", vim.diagnostic.goto_next, { group = "diag", desc = "next message" })

-- trouble
-- :help trouble.nvim.txt
map("n", "<leader>tt", function() vim.cmd.TroubleToggle() end, { group = "lsp", desc = "toggle trouble" })

-- others
map("n", "<leader><space>", function() require("telescope.builtin").buffers() end, { group = "ts", desc = "fuzzy buffers" })
map("n", '<leader>f"', function() require("telescope.builtin").marks() end, { group = "ts", desc = "fuzzy marks" })
map("n", "<leader>gh", function() vim.print("not implemented") end, { group = "ts", desc = "fuzzy help" })
map("n", "<leader>fk", function() require("telescope.builtin").keymaps() end, { group = "ts", desc = "fuzzy keymaps" })
map("n", "<leader>gd", function() require("telescope.builtin").lsp_definitions() end, { group = "ts", desc = "goto definition" })
map("n", "<leader>gi", function() require("telescope.builtin").lsp_implementations() end, { group = "ts", desc = "goto implementation" })
map("n", "<leader>qf", function() require("telescope.builtin").quickfix() end, { group = "ts", desc = "fuzzy quickfix" })
map("n", "<leader>/", function() require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown { winblend = 10, previewer = false, }) end, { group = "ts", desc = "fuzzy in current buffer" })
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
    map("n", "<leader>S", function() require("telescope.builtin").lsp_document_symbols() end, { group = "lsp", desc = "document symbols" })
    map("n", "<leader>ws", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, { group = "lsp", desc = "workspace symbols" })

    -- workspace
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { group = "lsp", desc = "workspace add folder" })
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { group = "lsp", desc = "workspace remove folder" })
    map("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { group = "lsp", desc = "workspace list folders" })
end
M.lsp_maps = lsp_maps

-- Treesitter keymaps
local treesitter_maps = {
    incremental_selection = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = "<c-s>",
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

-- nvim-cmp keymaps
local cmp_maps = {
    select_next_item = "<C-j>",
    select_prev_item = "<C-k>",
    scroll_docs_up = "<C-u>",
    scroll_docs_down = "<C-f>",
    complete = "<C-Space>",
    confirm = "<CR>",
    tab = "<Tab>",
    shift_tab = "<S-Tab>",
}
M.cmp_maps = cmp_maps

-- trouble.nvim keymaps
local trouble_maps = { -- key mappings for actions in the trouble list
    -- map to {} to remove a mapping, for example:
    -- close = {},
    close = "q", -- close the list
    cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
    refresh = "r", -- manually refresh
    jump = { "<cr>", "<tab>", "<2-leftmouse>" }, -- jump to the diagnostic or open / close folds
    open_split = { "<c-x>" }, -- open buffer in new split
    open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
    open_tab = { "<c-t>" }, -- open buffer in new tab
    jump_close = {"o"}, -- jump to the diagnostic and close the list
    toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
    switch_severity = "s", -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
    toggle_preview = "P", -- toggle auto_preview
    hover = "K", -- opens a small popup with the full multiline message
    preview = "p", -- preview the diagnostic location
    open_code_href = "c", -- if present, open a URI with more information about the diagnostic error
    close_folds = {"zM", "zm"}, -- close all folds
    open_folds = {"zR", "zr"}, -- open all folds
    toggle_fold = {"zA", "za"}, -- toggle fold of current file
    previous = "k", -- previous item
    next = "j", -- next item
    help = "?", -- help menu
}
M.trouble_maps = trouble_maps

-- Unmap annoying maps forced by plugin authors
local unimpaired = { "<s", ">s", "=s", "<p", ">p", "<P", ">P" }
local bullets = { "<<", "<", ">", ">>"}

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

-- Register keys and documentation with which-key
-- local function which_key_register(groups)
--     local wk = require("which-key")
--
--     for group, modes in pairs(groups) do
--         for mode, mappings in pairs(modes) do
--             for key, cfg in pairs(mappings) do
--                 cfg.opts.mode = mode
--
--                 if key == cfg.lhs then
--                     if cfg.opts["prefix"] then
--                         wk.register({
--                             [cfg.opts.prefix] = {
--                                 name = group,
--                                 [cfg.lhs] = { cfg.rhs, cfg.desc },
--                             },
--                             cfg.opts
--                         })
--                     else
--                         vim.keymap.set(mode, cfg.lhs, cfg.rhs, { desc = cfg.desc })
--                     end
--                 else
--                     wk.register({
--                         [key] = {
--                             name = group,
--                             [cfg.lhs] = { cfg.rhs, cfg.desc },
--                         },
--                         cfg.opts
--                     })
--                 end
--             end
--         end
--     end
-- end
--
-- which_key_register(which_key_register_keys)

return M
