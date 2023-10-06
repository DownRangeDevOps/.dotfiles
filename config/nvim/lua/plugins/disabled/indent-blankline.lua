-- ----------------------------------------------
-- Indentation guides (https://github.com/lukas-reineke/indent-blankline.nvim)
-- :help indent_blankline.txt
-- ----------------------------------------------
return {
    "lukas-reineke/indent-blankline.nvim",
    version = "2.20.8",
    lazy = false,
    init = function()
        local indet_blankline_session_opts = { "tabpages", "globals" }

        for _, i in ipairs(indet_blankline_session_opts) do
            if not vim.opt.sessionoptions[i] then
                table.insert(vim.opt.sessionoptions, i)
            end
        end
    end,
    opts = {
        char = "┊",
        char_blankline = "┊",
        context_char = "┊",
        context_char_blankline = "┊",
        disable_with_nolist = true,
        indent_level = 6,
        show_current_context = true,
        show_current_context_start = false,
        show_current_context_start_on_current_line = true,
        max_indent_increase = 1,
        enabled = true,
        show_end_of_line = false,
        show_first_indent_level = false,
        show_trailing_blankline_indent = true,
        space_char = " ",
        space_char_blankline = " ",
        strict_tabs = true,
        use_treesitter = true,
        use_treesitter_scope = true,
        viewport_buffer = 50,

        buftype_exclude = {
            "terminal",
            "nofile",
            "quickfix",
            "prompt",
        },
        filetype_exclude = {
            "",
            "checkhealth",
            "help",
            "lspinfo",
            "man",
            "neo-tree",
            "packer",
            "qf",
        },

        context_patterns = {
            "class",
            "^func",
            "method",
            "^if",
            "while",
            "for",
            "with",
            "try",
            "except",
            "match",
            "arguments",
            "argument_list",
            "object",
            "dictionary",
            "element",
            "table",
            "tuple",
            "do_block",
            "Block",
            "InitList",
            "FnCallArguments",
            "IfStatement",
            "ContainerDecl",
            "SwitchExpr",
            "IfExpr",
            "ParamDeclList",
            "unless",
        },
    },
}
