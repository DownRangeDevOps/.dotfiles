-- ----------------------------------------------
-- Markdown.nvim (https://github.com/tadmccorkle/markdown.nvim)
-- :help markdown.txt
-- ----------------------------------------------
return {
    "tadmccorkle/markdown.nvim",
    event = "VeryLazy",
    opts = {
        mappings = {
            inline_surround_toggle = false,      -- "gs",  -- (string|boolean) toggle inline style
            inline_surround_toggle_line = false, -- "gss", -- (string|boolean) line-wise toggle inline style
            inline_surround_delete = false,      -- "ds",  -- (string|boolean) delete emphasis surrounding cursor
            inline_surround_change = false,      -- "cs",  -- (string|boolean) change emphasis surrounding cursor
            link_add = false,                    -- "gl",  -- (string|boolean) add link
            link_follow = false,                 -- "gx",  -- (string|boolean) follow link
            go_curr_heading = false,             -- "]c",  -- (string|boolean) set cursor to current section heading
            go_parent_heading = false,           -- "]p",  -- (string|boolean) set cursor to parent section heading
            go_next_heading = false,             -- "]]",  -- (string|boolean) set cursor to next section heading
            go_prev_heading = false,             -- "[[",  -- (string|boolean) set cursor to previous section heading
        },
          toc = {
    -- comment text to flag headings/sections for omission in table of contents
    omit_heading = "toc omit heading",
    omit_section = "toc omit section",
    -- cycling list markers to use in table of contents
    -- use '.' and ')' for ordered lists
    markers = { "*" },
  },
    },
}
