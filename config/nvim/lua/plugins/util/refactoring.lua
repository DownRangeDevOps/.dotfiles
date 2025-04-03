-- ----------------------------------------------
-- refactoring.vim: Refactoring library (https://github.com/ThePrimeagen/refactoring.nvim)
-- :help refactoring.nvim
-- ----------------------------------------------
return {
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    event = "InsertEnter",
    dependencies = {
        { "nvim-lua/plenary.nvim", branch = "master", name = "nvim-plenary", lazy = false },
        { "nvim-treesitter/nvim-treesitter", name = "nvim-treesitter", lazy = false },
    },
    config = true,
    opts = {
        prompt_func_return_type = {
            go = false,
            java = false,
            cpp = false,
            c = false,
            h = false,
            hpp = false,
            cxx = false,
        },
        prompt_func_param_type = {
            go = false,
            java = false,
            cpp = false,
            c = false,
            h = false,
            hpp = false,
            cxx = false,
        },
        printf_statements = {},
        print_var_statements = {},
    },
}
