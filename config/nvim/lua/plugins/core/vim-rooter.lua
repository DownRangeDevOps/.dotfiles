-- ----------------------------------------------
-- vim-rooter: cd to project root (https://github.com/airblade/vim-rooter)
-- :help vim-rooter
-- ----------------------------------------------
return {
    "airblade/vim-rooter",
    name = "vim-rooter",
    lazy = false,
    config = function()
        vim.g.rooter_buftypes = { "", "nofile" }
        vim.g.rooter_patterns = { ".git" }
        vim.g.rooter_change_directory_for_non_project_files = "home"
    end
}
