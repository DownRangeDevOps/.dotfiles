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
end, { desc = "terraform fmt"})

vim.api.nvim_create_user_command("Tffr", function()
    vim.cmd("silent! !cd $(git rev-parse --show-toplevel 2>/dev/null) && terraform fmt -recursive && cd -")
    vim.cmd.edit()
end, { desc = "terraform recursive fmt"})

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
