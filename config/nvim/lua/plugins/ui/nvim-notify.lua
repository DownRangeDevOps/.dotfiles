-- ----------------------------------------------
-- nvim-notify (https://github.com/rcarriga/nvim-notify)
-- :help Notify
-- ----------------------------------------------
-- Abstract the configuration as it's used twice
local options = {
    render = "compact",
    stages = "fade_in_slide_out",
    timeout = "3000", -- 3 seconds
    top_down = false,
}

return {
    "rcarriga/nvim-notify",
    lazy = false,
    opt = options,
    init = function()
        local notify = require("notify")

        notify.setup(options)

        -- Override the default Vim notification with nvim-notify
        vim.notify = notify

        -- Override vim.print to use nvim-notify
        print = function(...)
            local print_safe_args = {}
            local _ = { ... }

            for i = 1, #_ do
                table.insert(print_safe_args, tostring(_[i]))
            end

            notify(table.concat(print_safe_args, ' '), "info")
        end
    end
}
