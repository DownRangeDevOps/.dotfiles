-- ----------------------------------------------
-- vim-helm, helmfile syntax (https://github.com/towolf/vim-helm)
-- :help syntax
-- ----------------------------------------------
return {
    "towolf/vim-helm",
    lazy = false,
    priority = 1000, -- make sure to load this first so yamlls doesn't run on helm files
}
