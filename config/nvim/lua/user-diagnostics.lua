-- ----------------------------------------------
-- Neovim diagnostics configuration
-- :help diagnostics.txt
-- ----------------------------------------------

-- Custom diagnostic signs with their icons
local signs = {
    [vim.diagnostic.severity.ERROR] = "",
    [vim.diagnostic.severity.HINT] = "",
    [vim.diagnostic.severity.INFO] = "",
    [vim.diagnostic.severity.WARN] = "",
}

-- Map severity levels to highlight groups
local severity_to_hl = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
    [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
}

-- Configure the diagnostic system
vim.diagnostic.config({
    underline = false,
    virtual_text = {
        source = true,
        spacing = 2,
        prefix = function(diagnostic)
            -- Use the icon directly based on severity
            return signs[diagnostic.severity] or "●"
        end,
    },
    severity_sort = true,
    signs = {
        text = signs,
        texthl = severity_to_hl,
        numhl = severity_to_hl
    },
    float = {
        source = true,
        severity_sort = true,
        scope = "line",
        header = nil,
        border = "rounded",
        focusable = false,
    },
})
