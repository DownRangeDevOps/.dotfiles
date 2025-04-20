-- ----------------------------------------------
-- nvim-notify (https://github.com/rcarriga/nvim-notify)
-- :help Notify
-- ----------------------------------------------
return {
    "rcarriga/nvim-notify",
    lazy = false,
    init = function()
        local notify = require("notify")
        vim.notify = notify

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
