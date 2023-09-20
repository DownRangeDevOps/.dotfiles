-- ----------------------------------------------
-- nvim-colorizer: (https://github.com/NvChad/nvim-colorizer.lua)
-- :help nvim-colorizer
-- ----------------------------------------------
return {
    "NvChad/nvim-colorizer.lua",
    lazy = true,
    cmd = "ColorizerToggle",
    config = true,
    opts = {
        filetypes = { "*" },
        user_default_options = {
            RGB = true, -- #RGB
            RRGGBB = true, -- #RRGGBB
            names = false, -- Blue or blue
            RRGGBBAA = true, -- #RRGGBBAA
            AARRGGBB = true, -- 0xAARRGGBB
            rgb_fn = true, -- CSS rgb() and rgba()
            hsl_fn = true, -- CSS hsl() and hsla()
            css = true, -- rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = true, -- rgb_fn, hsl_fn
            mode = "virtualtext", -- foreground, background,  virtualtext
            tailwind = false, -- false, true/normal, lsp, both

            -- parsers can contain values used in |user_default_options|
            sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
            virtualtext = "●",

            -- update color values even if buffer is not focused
            -- example use: cmp_menu, cmp_docs
            always_update = false
        },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = {},
    }
}
