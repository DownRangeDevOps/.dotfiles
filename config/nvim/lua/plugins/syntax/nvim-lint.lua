-- ----------------------------------------------
-- nvim-lint
--
-- NOTE: Ensure that plugins are installed in this order:
--  1. mason.nvim
--  2. mason-lspconfig.nvim
--  3. LSP Servers via `nvim-lspconfig`
-- ----------------------------------------------

return {
    -- An asynchronous linter plugin for Neovim (https://github.com/mfussenegger/nvim-lint)
    -- :help lint
    "mfussenegger/nvim-lint",
    lazy = false,
    dependencies = {
        {
            -- Mason helper for nvim-lint integration
            "rshkarin/mason-nvim-lint",
            opts = {
                automatic_installation = false,
            },
        },
    },
    init = function()
        -- Initalize nvim-lint
        local linters_by_ft = require("lint").linters_by_ft
        local mypy = require("lint").linters.mypy

        table.insert(mypy.args, "--python-executable ${HOME}/.asdf/shims/python")

        -- Linters that run on specific paths/all filetypes are controlled
        -- with autocommands. See `user-autocommands.lua`.
        local linter_to_ft = {
            ["ansible.yaml"] = { "ansible-lint" },
            dockerfile       = { "hadolint" },
            gitcommmit       = { "gitlint" },
            go               = { "revive", "djlint" },
            javascript       = { "eslint_d" },
            jinja            = { "djlint" },
            json             = { "jsonlint" },
            markdown         = {
                {
                    cmd = "markdownlint-cli2",
                    args = { "--config", vim.fn.expand("~/.dotfiles/config/.markdownlint.yaml") },
                },
                "vale"
            },
            python           = { "ruff", "mypy" },
            rst              = { "vale" },
            ruby             = { "rubocop" },
            sh               = { "shellcheck" },
            terraform        = { "tflint" },
            tex              = { "vale" },
            text             = { "vale" },
            typescript       = { "eslint_d" },
            vim              = { "vint" },
            yaml             = { "yamllint" },
            zsh              = { "shellcheck" },
        }

        -- linters for all filetypes
        for ft, _ in pairs(linters_by_ft) do
            table.insert(linters_by_ft[ft], "editorconfig-checker")
            table.insert(linters_by_ft[ft], "codespell")
        end

        local lint = require("lint")

        for ft, linters in pairs(linter_to_ft) do
            lint.linters_by_ft[ft] = linters
        end
    end,
}
