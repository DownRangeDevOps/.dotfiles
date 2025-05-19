-- ----------------------------------------------
-- mason
--
-- NOTE: Ensure that plugins are installed in this order:
--  1. mason.nvim
--  2. mason-lspconfig.nvim
--  3. LSP Servers via `nvim-lspconfig`
-- ----------------------------------------------

local mason_ensure_installed = {
  "actionlint",
  "ansible-lint",
  "ansible-language-server",
  "bash-language-server",
  "codespell",
  "css-lsp",
  "djlint",
  "docker-compose-language-service",
  "dockerfile-language-server",
  "dotenv-linter",
  "eslint_d",
  "gitlint",
  "gopls",
  "hadolint",
  "helm-ls",
  "html-lsp",
  "jq-lsp",
  "jsonlint",
  "json-lsp",
  "lemminx",
  "ltex-ls-plus",
  "lua-language-server",
  "markdownlint-cli2",
  "marksman",
  "mypy",
  "neocmakelsp",
  "nginx-language-server",
  "powershell-editor-services",
  "python-lsp-server",
  "revive",
  "rubocop",
  "ruby-lsp",
  "ruff",
  "shellcheck",
  "sqlls",
  "taplo",
  "terraform-ls",
  "tflint",
  "typescript-language-server",
  "vale",
  "vale-ls",
  "vim-language-server",
  "vint",
  "yamllint",
  "yaml-language-server",
}

return {
    -- Mason: LSP and related plugin manager (https://github.com/williamboman/mason.nvim)
    -- :help mason.nvim
    "williamboman/mason.nvim",
    lazy = false,
    priority = 3000,
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    },
    init = function()
        local registry = require("mason-registry")
        local installed_packages = registry.get_all_packages()

        -- Extract just the names from installed packages
        local installed_names = {}
        for _, pkg in ipairs(installed_packages) do
            table.insert(installed_names, pkg.name)
        end

        -- Find packages that need to be installed
        local packages_to_install = {}
        for _, required_pkg in ipairs(mason_ensure_installed) do
            local is_installed = false
            for _, installed_pkg in ipairs(installed_names) do
                if installed_pkg == required_pkg then
                    is_installed = true
                    break
                end
            end

            if not is_installed then
                table.insert(packages_to_install, required_pkg)
            end
        end

        -- Create command string for MasonInstall
        if #packages_to_install > 0 then
            local install_cmd = "MasonInstall " .. table.concat(packages_to_install, " ")

            vim.cmd(install_cmd)
        end
    end,
}
