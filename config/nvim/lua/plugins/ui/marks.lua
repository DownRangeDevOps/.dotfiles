-- ----------------------------------------------
-- marks (https://github.com/chentoast/marks.nvim)
-- :help marks-nvim.txt
-- ----------------------------------------------
return {
    "chentoast/marks.nvim",
    lazy = false,
    config = true,
    opts = {
        default_mappings = true, -- whether to map keybinds or not. default = true
        builtin_marks = { ".", "<", ">", "^" }, -- which builtin marks to show. default = {}
        cyclic = true, -- whether movements cycle back to the beginning/end of buffer. default = true
        force_write_shada = false, -- whether the shada file is updated after modifying uppercase marks. default = false
        excluded_filetypes = {}, -- disables mark tracking for specific filetypes. default = {}


        -- How often (in ms) to redraw signs/recompute mark positions.
        -- Higher values will have better performance but may cause visual lag,
        -- while lower values may cause performance penalties.
        -- default = 150
        refresh_interval = 250,

        -- Sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
        -- marks, and bookmarks. Can be either a table with all/none of the keys, or a single number, in which case
        -- the priority applies to all marks.
        -- default = 10
        sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },

        -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
        -- sign/virtual text. Bookmarks can be used to group together positions and quickly move
        -- across multiple buffers. Default sign is '!@#$%^&*()' (from 0 to 9), and
        -- default = ""
        bookmark_0 = {
            sign = "⚑",
            virt_text = "",
            -- Explicitly prompt for a virtual line annotation when setting a bookmark from this group.
            -- defaults = false.
            annotate = false,
        },
        mappings = {}
    },
}
