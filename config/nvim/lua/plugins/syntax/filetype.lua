-- ----------------------------------------------
-- filetype.nvim Replacement for slow filetype.vim builtin (https://github.com/nathom/filetype.nvim)
-- :help filetype.nvim
-- ----------------------------------------------
return {
    "nathom/filetype.nvim",
    name = "filetype",
    lazy = true,
    opts = {
        overrides = {
            extensions = {
                tf = "terraform",
                tfvars = "terraform",
                tfstate = "json",
            }
        },
    },
}
