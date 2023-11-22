-- ----------------------------------------------
-- barbar (https://github.com/romgrk/barbar.nvim)
-- :help barbar.txt
-- ----------------------------------------------
return {
  'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
        animation = true, -- Enable/disable animations
        auto_hide = false, -- Automatically hide the tabline when there are this many buffers left.
        tabpages = true, -- Enable/disable current/total tabpages indicator (top right corner)
        clickable = true, -- Enables/disable clickable tabs, left-click: go to buffer, middle-click: delete buffer

        -- Excludes buffers from the tabline
        -- exclude_ft = {'javascript'},
        -- exclude_name = {'package.json'},

        -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
        -- Valid options are 'left' (the default), 'previous', and 'right'
        focus_on_close = 'left',

        hide = { extensions = false, inactive = true }, -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
        highlight_alternate = false, -- Disable highlighting alternate buffers
        highlight_inactive_file_icons = false, -- Disable highlighting file icons in inactive buffers

        highlight_visible = true, -- Enable highlighting visible buffers

        icons = {
            -- Configure the base icons on the bufferline.
            -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
            buffer_index = false,
            buffer_number = false,
            button = '',
            -- Enables / disables diagnostic symbols
            diagnostics = {
                [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
                [vim.diagnostic.severity.WARN] = { enabled = true },
                [vim.diagnostic.severity.INFO] = { enabled = true },
                [vim.diagnostic.severity.HINT] = { enabled = true },
            },
            gitsigns = {
                added = { enabled = true, icon = '+' },
                changed = { enabled = true, icon = '~' },
                deleted = { enabled = true, icon = '-' },
            },
            filetype = {
                -- Sets the icon's highlight group.
                -- If false, will use nvim-web-devicons colors
                custom_colors = false,
                enabled = true, -- Requires `nvim-web-devicons` if `true`
            },
            separator = {left = '▎', right = ''},
            -- separator = {left = '┆', right = ''},
            separator_at_end = true, -- If true, add an additional separator at the end of the buffer list

            -- Configure the icons on the bufferline when modified or pinned.
            -- Supports all the base icon options.
            modified = {button = '●'},
            pinned = {button = '', filename = true},

            preset = 'default', -- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'

            -- Configure the icons on the bufferline based on the visibility of a buffer.
            -- Supports all the base icon options, plus `modified` and `pinned`.
            alternate = { filetype = { enabled = false } },
            current = { buffer_index = true },
            inactive = { button = '×' },
            visible = { modified = {buffer_number = false} },
        },

        -- If true, new buffers will be inserted at the start/end of the list.
        -- Default is to insert after current buffer.
        insert_at_end = false,
        insert_at_start = false,

        maximum_padding = 1, -- Sets the maximum padding width with which to surround each tab
        minimum_padding = 1, -- Sets the minimum padding width with which to surround each tab
        maximum_length = 30, -- Sets the maximum buffer name length.
        minimum_length = 0, -- Sets the minimum buffer name length.

        -- If set, the letters for each buffer in buffer-pick mode will be
        -- assigned based on their name. Otherwise or in case all letters are
        -- already assigned, the behavior is to assign letters in order of
        -- usability (see order below)
        semantic_letters = true,

        -- Set the filetypes which barbar will offset itself for
        -- sidebar_filetypes = {
        --     -- Use the default values: {event = 'BufWinLeave', text = nil}
        --     NvimTree = true,
        --     -- Or, specify the text used for the offset:
        --     undotree = { text = 'undotree' },
        --     -- Or, specify the event which the sidebar executes when leaving:
        --     ['neo-tree'] = { event = 'BufWipeout' },
        --     -- Or, specify both
        --     Outline = { event = 'BufWinLeave', text = 'symbols-outline' },
        -- },

        -- New buffer letters are assigned in this order. This order is
        -- optimal for the qwerty keyboard layout but might need adjustment
        -- for other layouts.
        letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

        -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
        -- where X is the buffer number. But only a static string is accepted here.
        no_name_title = "[No Name]",
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  }
