-- ----------------------------------------------
-- GitHub CopilotChat (https://github.com/CopilotC-Nvim/CopilotChat.nvim)
-- :help CopilotChat.txt
-- ----------------------------------------------
return {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
        { "zbirenbaum/copilot.lua" },                   -- or github/copilot.vim
        { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log wrapper
        { "nvim-telescope/telescope-ui-select.nvim" },  -- for picker menus
    },
    build = "make tiktoken",

    -- Telescope picker integration for CopilotChat
    init = function()
        require("telescope").load_extension("ui-select")
    end,

    opts = function()
        local select = require("CopilotChat.select")

        return {
            auto_follow_cursor = false, -- Auto-follow cursor in chat (Default: true)
            highlight_selection = true, -- Highlight selection in the source buffer when in the chat window
            context = "buffer",         -- Context to use for the prompt. Can be "buffer", "line", "git:staged", or "git:unstaged"

            contexts = {
                line_diagnostics = {
                    resolve = function()
                        local bufnr = vim.api.nvim_get_current_buf()
                        local line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed
                        local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
                        if not diagnostics or #diagnostics == 0 then
                            return {
                                {
                                    content = "No diagnostics found on this line.",
                                    filename = vim.api.nvim_buf_get_name(bufnr),
                                    filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr }),
                                }
                            }
                        end
                        local messages = {}
                        for _, diag in ipairs(diagnostics) do
                            table.insert(messages, diag.message)
                        end
                        local content = "Diagnostics for line " .. (line + 1) .. ":\n" .. table.concat(messages, "\n\n")
                        return {
                            {
                                content = content,
                                filename = vim.api.nvim_buf_get_name(bufnr),
                                filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr }),
                            }
                        }
                    end,
                }
            },

            selection = function(source)
                return select.visual(source) or select.buffer(source)
            end,

            window = {
                layout = "horizontal", -- "vertical", "horizontal", "float", "replace"
                width = 1,             -- fractional width of parent, or absolute width in columns when > 1
                height = 0.33,         -- fractional height of parent, or absolute height in rows when > 1

                -- Options below only apply to floating windows
                -- relative = "editor",    -- "editor", "win", "cursor", "mouse"
                -- border = "single",      -- "none", single", "double", "rounded", "solid", "shadow"
                -- row = nil,              -- row position of the window, default is centered
                -- col = nil,              -- column position of the window, default is centered
                -- title = "Copilot Chat", -- title of chat window
                -- footer = nil,           -- footer of chat window
                -- zindex = 1,             -- determines if window is on top or below other floating windows
            },

            prompts = {
                FixDiagnostic = {
                    prompt = "Please fix the diagnostic at the current line. Here are the diagnostics:\n#line_diagnostics",
                    description = "Fixes code based on diagnostics at the current line",
                },
                Commit = {
                    prompt = [=[Write a commit message using the commitizen convention:
                        - Limit the title to 50 characters.
                        - Wrap all lines at 72 characters.
                        - Summarize changes as concise bullet points, each starting with `*`, in the imperative mood at a 12th grade reading level.
                        - If the branch name includes a ticket ID, add it as a Markdown reference link in brackets at the end of the title (e.g., `[[MLPLATFORM-643]]`), and include a reference link to the ticket in the footer (e.g., `[MLPLATFORM-643]: https://grainger.atlassian.net/browse/MLPLATFORM-643`).
                        - If no ticket ID is present, omit ticket references.
                        - Enclose the entire message in a code block with the `gitcommit` language.
                    ]=],
                    context = "git:staged",
                    description = "Writes a conventional commit with imparative bullet points summarizing the changes made."
                },
            },

            mappings = {
                complete = {
                    detail = "Use @<Tab> or /<Tab> for options.",
                    insert = "<Tab>",
                },
                close = {
                    normal = "q",
                    insert = "<C-c>"
                },
                reset = {
                    normal = false,
                    insert = false,
                },
                submit_prompt = {
                    normal = "<CR>",
                    insert = "<C-s>"
                },
                accept_diff = {
                    normal = "<C-y>",
                    insert = "<C-y>"
                },
                yank_diff = {
                    normal = "gy",
                },
                show_diff = {
                    normal = "gd"
                },
                show_info = {
                    normal = "gi"
                },
                show_context = {
                    normal = "gc"
                },
            },
        }
    end
}
