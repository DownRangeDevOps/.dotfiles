-- ----------------------------------------------
-- mini-starter: (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-starter)
-- :help mini-starter
-- ----------------------------------------------
return {
    "echasnovski/mini.starter",
    lazy = false,
    version = "*",
    config = true,
    opts = {
        autoopen = true,
        evaluate_single = false,

        -- Items to be displayed. Should be an array with the following elements:
        --     Item: table with <action>, <name>, and <section> keys.
        --     Function: should return one of these three categories.
        --     Array: elements of these three types (i.e. item, array, function).
        -- If `nil` (default), default items will be used (see |mini.starter|).
        items = nil,
        header = ""
        .. "\"If you look for truth, you may find comfort in the end; if you look for\n"
        .. "comfort you will not get either comfort or truth only soft soap and wishful\n"
        .. "thinking to begin, and in the end, despair.\"\n"
        .. "                                         – C. S. Lewis\n"
        .. "\n"
        .. "\"Everybody has a plan until they get punched in the mouth.\"\n"
        .. "                                         – Mike Tyson\n"
        .. "\n",

        -- Footer to be displayed after items. Converted to single string via
        -- `tostring` (use `\n` to display several lines). If function, it is
        -- evaluated first. If `nil` (default), default usage help will be shown.
        footer = nil,

        -- Array  of functions to be applied consecutively to initial content.
        -- Each function should take and return content for "Starter" buffer (see
        -- |mini.starter| and |MiniStarter.content| for more details).
        content_hooks = nil,

        -- Characters to update query. Each character will have special buffer
        -- mapping overriding your global ones. Be careful to not add `:` as it
        -- allows you to go into command mode.
        query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_-.",

        -- Whether to disable showing non-error feedback
        silent = false,
    },
}
