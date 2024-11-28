-- ----------------------------------------------
-- Vimspector: (https://github.com/puremourning/vimspector)
-- :help vimspector
-- ----------------------------------------------
return {
    "puremourning/vimspector",
    -- cmd = { "VimspectorInstall", "VimspectorUpdate", "VimspectorReset" },
    -- ft = "python",
    -- build = "./install_gadget.py --enable-python --force-enable-python",
    lazy = false,
    config = function()
        vim.cmd([[
            nmap <Leader>db <cmd>call vimspector#Launch()<CR>
            nmap <Leader>s <cmd>call vimspector#Stop()<CR>
            nmap <leader>r <cmd>call vimspector#Restart()<CR>
            nmap <leader>p <cmd>call vimspector#Pause()<CR>
            nmap <leader>i <cmd>call vimspector#StepInto()<CR>
            nmap <leader>o <cmd>call vimspector#StepOver()<CR>
            nmap <leader>O <cmd>call vimspector#StepOut()<CR>
            nmap <Leader>b <cmd>call vimspector#ToggleBreakpoint()<CR>
            nmap <Leader>B <cmd>call vimspector#ToggleConditionalBreakpoint()<CR>
            nmap <Leader>c <cmd>call vimspector#Continue()<CR>
        ]])

        vim.fn.sign_define('vimspectorBP', {
            text = '●',
            texthl = 'WarningMsg',
        })

        vim.fn.sign_define('vimspectorBPCond', {
            text = '◆',
            texthl = 'WarningMsg',
        })

        vim.fn.sign_define('vimspectorCurrentLine', {
            text = '▶',
            texthl = 'MatchParen',
        })
    end,
}
