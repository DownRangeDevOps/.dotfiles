-- ----------------------------------------------
-- Helpers
-- ----------------------------------------------
-- Open all project files in hidden buffers so that they are available to Copilot context
vim.api.nvim_create_user_command(
    "LoadProjectFiles",
    function()
        local res
        local files = {}
        local handle, err = io.popen("rg --files")
        local function is_regular_file(path)
            local stat = vim.loop.fs_stat(path)
            return stat and stat.type == "file"
        end

        if handle then
            vim.cmd("WipeAllBuffers")

            res = handle:read("*a")
            handle:close()


            for line in res:gmatch("[^\r\n]+") do
                table.insert(files, line)
            end

            for _, path in ipairs(files) do
                if path ~= "" and is_regular_file(path) then
                    vim.api.nvim_command("badd " .. path)
                end
            end

            vim.print("Project files loaded.")
        else
            vim.print(err)
        end
    end,
    { desc = "Open all project files" }
)

-- Clear registers
vim.api.nvim_create_user_command(
    "ClearRegisters",
    function()
        local registers = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"*+'
        for reg in registers:gmatch(".") do
            pcall(vim.fn.setreg, reg, {})
        end
    end,
    { desc = "Clear all registers" }
)
vim.api.nvim_create_user_command("DR", "ClearRegisters", { desc = "Clear all registers"})
vim.api.nvim_create_user_command("CR", "ClearRegisters", { desc = "Clear all registers"})

-- Clear buffers
vim.api.nvim_create_user_command(
    "WipeAllBuffers",
    function()
        --  get all visible buffers in all tabs
        local visible = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            visible[vim.api.nvim_win_get_buf(win)] = true
        end

        -- close all hidden buffers
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if not visible[buf] then
                if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
                    vim.cmd("bw! " .. buf)
                else
                    vim.cmd.bw(buf)
                end
            end
        end
    end,
    { desc = "Close all hidden buffers" }
)
vim.api.nvim_create_user_command("Ca", "WipeAllBuffers", { desc = "Close all hidden buffers" })
vim.api.nvim_create_user_command("CloseAll", "WipeAllBuffers", { desc = "Close all hidden buffers" })

vim.api.nvim_create_user_command(
    "ExtractTfVars",
    function()
        vim.cmd([[
            %s/\v\s*(default|variable)/ß\1/
            %s/\v\c^[^ß]*\n/
            %s/\v\c^ß//
            %s/\v\c^default[^\=]*\=\s*//
            %s/\v\cvariable[^"]*"([^"]*).*\n/\1 = /
        ]])
    end,
    { desc = "Extract vars from *.tf files"}
)

-- ----------------------------------------------
-- Formatters
-- ----------------------------------------------
vim.api.nvim_create_user_command("Tff", function()
    vim.cmd("silent! !terraform fmt %:p")
    vim.cmd.edit()
end, { desc = "Run Terraform formatter on current file"})

vim.api.nvim_create_user_command("Black", function()
    vim.cmd("silent! !black %:p")
    vim.cmd("silent! !docformatter --in-place --wrap-summaries 72 --wrap-descriptions 72 %:p")
    vim.cmd.edit()
end, { desc = "run Black and doc formatter on the current file"})

vim.api.nvim_create_user_command("Prettier", function()
    vim.cmd("silent! !prettier --write %:p")
    vim.cmd.edit()
end, { desc = "run Prettier formatter on the current file"})

vim.api.nvim_create_user_command("Tffr", function()
    vim.cmd("silent! !cd $(git rev-parse --show-toplevel 2>/dev/null) && terraform fmt -recursive && cd -")
    vim.cmd.edit()
end, { desc = "Run Terraform formatter recursively from the project root"})

vim.api.nvim_create_user_command("TfMovedFrom", function()
    vim.cmd("s/\\v\\c[^#]+# (.*)/moved {\r  from = \1\r}\r/")
end, { desc = "Create Terraform moved block with 'from' entry"})

vim.api.nvim_create_user_command("TfMovedTo", function()
    vim.cmd("s/\\v\\c[^#]+# (.*)/  to = \1")
end, { desc = "Create Terraform moved block 'to' entry"})

vim.api.nvim_create_user_command("TfMovedBlockSingle", function()
    local start_line = vim.fn.line("'<") - 1
    local end_line = vim.fn.line("'>")
    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

    if #lines == 2 then
        local from = lines[1]:match("#%s*(.*)")
        local to = lines[2]:match("#%s*(.*)")

        if from and to then
            vim.api.nvim_buf_set_lines(0, start_line, end_line, false, {
                "moved {",
                "  from = " .. from,
                "  to = " .. to,
                "}",
                " ",
            })
        end
    else
        vim.cmd("echoe 'More than two lines selected, please select exactly two lines to transform'")
    end
end, { range = true })

vim.api.nvim_create_user_command("TfMovedBlockMultiple", function()
  local start_line = vim.fn.line("'<") - 1
  local end_line = vim.fn.line("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

  local block1, block2, moved_blocks = {}, {}, {}
  local current_block = block1

  for _, line in ipairs(lines) do
    if line:match("^%s*#") then
      table.insert(current_block, line:match("#%s*(.*)"))
    elseif #current_block > 0 then
      current_block = block2
      table.insert(current_block, line:match("#%s*(.*)"))
    end
  end

  if #block1 ~= #block2 then
    print("Error: The selected blocks have a different number of lines.")
    return
  end

  for i = 1, #block1 do
    table.insert(moved_blocks, "moved {")
    table.insert(moved_blocks, "  from = " .. block1[i])
    table.insert(moved_blocks, "  to = " .. block2[i])
    table.insert(moved_blocks, "}")
    table.insert(moved_blocks, " ")
  end

  vim.api.nvim_buf_set_lines(0, start_line, end_line, false, moved_blocks)
end, { range = true })

-- ----------------------------------------------
-- Typos
-- ----------------------------------------------
vim.api.nvim_create_user_command("W", function() vim.cmd.write() end, { desc = "write"})
vim.api.nvim_create_user_command("Wa", function() vim.cmd.wall() end, { desc = "wall"})
vim.api.nvim_create_user_command("Wq", function() vim.cmd.wq() end, { desc = "wq"})
vim.api.nvim_create_user_command("Wqa", function() vim.cmd.wqall() end, { desc = "wqall"})
vim.api.nvim_create_user_command("Qa", function() vim.cmd.wqall() end, { desc = "qall"})

-- ----------------------------------------------
-- Info
-- ----------------------------------------------
vim.api.nvim_create_user_command(
    "SynGroup",
    function()
        local line = vim.fn.line('.')
        local col = vim.fn.col('.')
        -- local cur_synstack = vim.fn.synstack(cur_line, cur_col)
        local id = vim.fn.synID(line, col, 1)
        local name = vim.fn.synIDattr(id, "name")
        local link = vim.fn.synIDattr(vim.fn.synIDtrans(id), "name")

        if name == "" and link == "" then
            vim.cmd.echohl("WarningMsg")
            vim.cmd.echom("'No syntax groups found'")
            vim.cmd.echohl("None")
        else
            vim.cmd.echohl(name)
            vim.cmd.echon("'" .. name .. "'")
            vim.cmd.echohl("None")
            vim.cmd.echon("' -> '")
            vim.cmd.echohl(link)
            vim.cmd.echon("'" .. link .. "'")
            vim.cmd.echohl("None")
        end
    end,
    { desc = "Show syntax highlighting under cursor" }
)
