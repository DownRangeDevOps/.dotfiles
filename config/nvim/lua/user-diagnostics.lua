-- ----------------------------------------------
-- Neovim diagnostics configuration
-- :help diagnostics.txt
-- ----------------------------------------------

-- Custom diagnostic signs
local signs = {
    Error = "",
    Hint = "",
    Info = "",
    Warn = "",
}

for level, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. level
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    underline = true,
    severity_sort = true,
    signs = true,
    virtual_text = {
        source = false, -- bool, "always", "if_many"
        spacing = 2,
        prefix = "",
        format = function(diagnostic)
            local icon = "●"
            if diagnostic.severity == vim.diagnostic.severity.ERROR then icon = signs.Error end
            if diagnostic.severity == vim.diagnostic.severity.HINT then icon = signs.Hint end
            if diagnostic.severity == vim.diagnostic.severity.INFO then icon = signs.Info end
            if diagnostic.severity == vim.diagnostic.severity.WARN then icon = signs.Warn end

            return icon .. " " .. diagnostic.message
        end,
    },
    float = {
        source = "always",  -- bool, "always", "if_many"
        show_header = true,
        border = "rounded",
        focusable = false,
    },
})
