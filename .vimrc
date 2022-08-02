" vim: set ft=vim
" Setup plugin manager
so $HOME/.dotfiles/.plugins
so $HOME/.dotfiles/assets/term_color.vim

" Use UTF8 encoding
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1
setglobal bomb
setglobal fileencoding=utf-8
scriptencoding utf-8

""" Prefrences ---------------------------------------------------------------
" Use space as leader key
let mapleader=' '
nnoremap <space> <leader>

" Config
filetype plugin indent on                " Enable file type detection and do language-dependent indenting.
set autochdir                            " Auto change working directory to that of the current file
set autoread                             " Automatically read files when they have changed
set autowrite                            " Automatically :write before running commands
set backspace=2                          " Backspace deletes like most programs in insert mode
set backspace=indent,eol,start           " Make backspace behave in a sane manner.
set colorcolumn=80                       " Make it obvious where 80 characters is
set complete+=kspell                     " Auto complete with dictionary words when spell check is on
set tags=tags                            " Enable ctags
set diffopt+=vertical                    " Always use vertical diffs
set directory=~/tmp                      " set where swapfile(s) are stored
set fillchars+=vert:\ |
set foldcolumn=0
set foldnestmax=2                        " methods of classes are folded, but not internal statements
set foldenable                           " Code folding config
set foldlevelstart=2
set foldmethod=indent
set formatoptions=croqnlj                " See :help fo-table
set history=50                           " store command history across sessions
set hlsearch                             " highlight search matches
set incsearch                            " do incremental searching
set lazyredraw                           " Disable redraw when executing macros
set list listchars=tab:»·,trail:·,nbsp:· " Display tabs, non-breaking spaces, and trailing whitespace
set mouse=a
set noshowmode                           " hide the mode status line
set spell spelllang=en_us                " Turn off spell checking by default
set noswapfile                           " disable swap file
set ruler                                " show the cursor position all the time
set scrolloff=2                          " Always show one line above/below the cursor
set secure                               " Prevent shell, write, :au unless file is owned by me
set sessionoptions+=tabpages,globals     " Allow Taboo to maintain tab names across sessions
set showbreak=↳\                         " Indicate wrapped lines
set linebreak
set showcmd                              " display incomplete commands
set splitbelow                           " Open new split panes to the right/bottom
set splitright
set termguicolors                        " Use true color
set timeoutlen=700                       " set a short leader timeout
set wildmode=list:longest,list:full      " Configure auto completion see :help wildmode
if &diff                                 " only for diff mode/vimdiff
set diffopt=filler,context:1000000     " filler is default and inserts empty lines for sync
endif

" Default tabbing preferences
set shiftround
set expandtab
set tabstop=4
set shiftwidth=4

" Relative line numbers
set number
set relativenumber
set numberwidth=5

" Change cursor shape in iTerm2 & tmux
if has('nvim')
    set guicursor=n-c-v-sm:block-Cursor/lCursor,
                \i-ci-ve:ver25-Cursor/lCursor,
                \r-cr-o:hor20-Cursor/lCursor,
                \a:blinkwait0-blinkoff500-blinkon500-Cursor/lCursor
    let g:python3_host_prog = '/Users/ryanfisher/.virtualenvs/nvim/bin/python3'
else
    let &t_SI = "\<ESC>]50;CursorShape=1\x7"
    let &t_SR = "\<ESC>]50;CursorShape=2\x7"
    let &t_EI = "\<ESC>]50;CursorShape=0\x7"
    let &t_SI = "\<ESC>Ptmux;\<ESC>\<ESC>]50;CursorShape=1\x7\<ESC>\\"
    let &t_SR = "\<ESC>Ptmux;\<ESC>\<ESC>]50;CursorShape=2\x7\<ESC>\\"
    let &t_EI = "\<ESC>Ptmux;\<ESC>\<ESC>]50;CursorShape=0\x7\<ESC>\\"
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has('gui_running')) && !exists('syntax_on')
    syntax on
    set synmaxcol=200
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let undo_dir = expand('$HOME/.vim/undo_dir')
    if !isdirectory(undo_dir)
        call mkdir(undo_dir, '', 0700)
    endif
    set undodir=$HOME/.vim/undo_dir
    set undofile
endif


inoremap <C-@> <C-Space>|                                   " Get to next editing point after autocomplete
inoremap jj <ESC>|                                          " Easy escape from insert/visual mode
inoremap jk <ESC>|                                          " Easy escape from insert/visual mode
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>|         " Replace selected text
nnoremap \ :ProjectRootCD<CR>:Ag -i<SPACE>|                 " bind \ (backward slash) to grep shortcut
nnoremap <silent> <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>:lclose\|cclose\|noh\<CR>" : ":noh\<CR>\<CR>"
nnoremap K                                                  " Keep searching for man entries by accident
nnoremap Q <Plug>window:quickfix:toggle

" Easy split navigation
nnoremap <silent><leader>\ :call <SID>OpenNewSplit('\')<CR>|        " Open vertical split
nnoremap <silent><leader>\| :call <SID>OpenNewSplit('\|')<CR>|      " Open horizontal split
noremap <C-h> <C-w>h                                       " Move left a window
let g:BASH_Ctrl_j = 'off'
noremap <C-j> <C-w>j                                       " Move down a window
noremap <C-k> <C-w>k                                       " Move up a window
noremap <C-l> <C-w>l                                       " Move right a window
nnoremap <c-w><c-w> <ESC><C-w>=                            " Set windows to equal size
if has('nvim')
    tnoremap <C-h> <C-\><C-n><C-w>h                        " Move left a window
    tnoremap <C-j> <C-\><C-n><C-w>j                        " Move down a window
    tnoremap <C-k> <C-\><C-n><C-w>k                        " Move up a window
    tnoremap <C-l> <C-\><C-n><C-w>l                        " Move right a window
    tnoremap <s-space> <space>
endif

" Easy tab navigation
nnoremap <silent><leader><S-w> :tabclose<CR>                " Move right a window
nnoremap <silent><leader><S-h> :tabprevious<CR>             " Move left a window
nnoremap <silent><leader><S-l> :tabnext<CR>                 " Move right a window

" Use magic in search/substitute
nnoremap / /\v\c
vnoremap / /\v\c
cnoremap %% %s/\v
cnoremap %%% s/\v
" cnoremap \>s/ \>smagic/
" nnoremap :g/ :g/\v
" nnoremap :g// :g//

" Utility
nnoremap ` za
nnoremap <leader>qa :call <SID>StripTrailingWhitespaces()<CR>:wa<CR>:qa<CR>|                " Close buffer(s)
nnoremap <silent><leader>q :call <SID>WipeBufOrQuit()<CR>
nnoremap <silent><leader>qq :q<CR>|
nnoremap <silent><leader>Q :q<CR>|
nnoremap <silent><leader>~ :sp<CR>:ProjectRootExe term<CR>:setl nospell<CR>:startinsert<CR>
nnoremap <silent><leader>` :vsp<CR>:ProjectRootExe term<CR>:setl nospell<CR>:startinsert<CR>
nnoremap <silent><leader>s :call ToggleSpell()<CR>
nnoremap <silent><leader>w :call <SID>StripTrailingWhitespaces()<CR>:w<CR>|                 " wtf workaround bc broken from autowrite or...???? Write buffer
nnoremap <silent><leader>1 :call <SID>NvimNerdTreeToggle()<CR>|                             " Open/close NERDTree
nnoremap <silent><leader>2 :ProjectRootExe NERDTreeFind<CR>|                                " Open NERDTree and hilight the current file
nnoremap <silent><leader>3 :TagbarOpenAutoClose<CR>:set relativenumber<CR>|                                                 " Open NERDTree and hilight the current file
nnoremap <leader>n :enew<CR>|                                                               " Open new buffer in current split
nnoremap <leader>/ :noh<CR>|                                                                " Clear search pattern matches with return
nnoremap <silent><leader>m :Neomake
nnoremap <silent><C-p> :ProjectRootExe Files<CR>|                                           " Open FZF
nnoremap <leader>ha <Plug>GitGutterStageHunk
nnoremap <leader>hr <Plug>GitGutter
nnoremap <silent><leader>l :let @+=<SID>GetPathToCurrentLine()<CR>|                         " Copy curgent line path/number
nnoremap Y y$                                                                               " Make Y act like C and D
nnoremap <leader>d :Dash<CR>

" Find/replace
nnoremap <leader>f :lvim /<C-R>=expand("<cword>")<CR>/ %<CR>:lopen<CR>
nnoremap <silent><leader>F :ProjectRootExe grep! "\b<C-R><C-W>\b"<CR>:bo copen 5<CR>|       " Bind K to grep word under cursor
nnoremap <leader>r :%s/\<<C-r><C-w>\>/

" Cut
nmap <leader>x <Plug>MoveMotionPlug
xmap <leader>x <Plug>MoveMotionXPlug
nmap <leader>xx <Plug>MoveMotionLinePlug
nmap <leader>X <Plug>MoveMotionEndOfLinePlug

" Copy/paste to/from system clipboard
vnoremap <leader>y  "+y
vnoremap <LeftRelease> "+y<LeftRelease>
nnoremap <leader>y  "+y
nnoremap <leader>Y  "+yg_
nnoremap <leader>yy  "+yy
nnoremap <leader>p "+p

" Gutentags configuration (https://github.com/ludovicchabant/vim-gutentags)
let g:gutentags_define_advanced_commands = 1
let g:gutentags_modules = ['ctags', 'gtags_cscope']
let s:python_lib_dirs = get(systemlist('pyenv prefix'), 0, '')
let g:gutentags_file_list_command = 'rg ' . projectroot#get() . ' ' . s:python_lib_dirs . ' --files'
" let g:gutentags_ctags_extra_args = ['--python-kinds=-i']
let g:gutentags_cache_dir = expand('~/.cache/tags')
let g:gutentags_plus_switch = 1

" NeoVim configuration
if has('nvim') && !exists('g:gui_oni')
    let $VISUAL = 'nvr -cc split --remote-wait'  " Prevent nested neovim instances when using :term
    nnoremap <leader>rc :so ~/.config/nvim/init.vim<CR>|
else
    nnoremap <leader>rc :so $MYVIMRC<CR>:echom $MYVIMRC " reloaded"<CR>|
endif

" Prevent nested neovim instances when using :term
if has('nvim')
  let $VISUAL = 'nvr -cc split --remote-wait'
endif

" Commands (aliases)
" command! Grc Gsdiff :1 | Gvdiff                 " Open vimdiff/fugitive in 4 splits with base shown
" command! -nargs=? Gd Gdiff <args>               " Alias for Gdiff
" command! Gs Gstatus                             " Alias for Gstatus
" command! Gc Gcommit                             " Alias for Gcommit
" command! -nargs=* -bar G !clear;git <args>      " Alias for Git
" command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor


""" Custom commands ------------------------------------------------------------
" Define a decrypt/encrypt command to decrypt the current file
command! -nargs=+ -bar DecryptThis silent! !ansible-vault decrypt --vault-password-file ~/.ansible/vault-passwords/<args> %
command! -nargs=+ -bar EncryptThis silent! !ansible-vault encrypt --vault-password-file ~/.ansible/vault-passwords/<args> %

" Terraform
command! -nargs=0 -bar Tff silent! !terraform fmt %:p

" Git aliases
command! -nargs=0 Grbm silent! Git rebase -i origin/master

" Use The Silver Searcher if it is installed
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|:bo copen 10|redraw!

if executable('rg')
  " Use ag over grep
  set grepprg="rg --vimgrep --smart-case --hidden --follow"
endif

""" Plugin configuration ------------------------------------------------------------
" Configure fzf (https://github.com/junegunn/fzf and https://github.com/junegunn/fzf.vim)
let g:fzf_commits_log_options = "git log --branches --remotes --graph --color --decorate=short --format=format:'%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(white)%s%C(reset) %C(black)[%an]%C(reset) %C(bold green)(%ar)%C(reset)"

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'String'],
  \ 'fg+':     ['fg', 'Statement', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'String'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Type'],
  \ 'pointer': ['fg', 'Constant'],
  \ 'marker':  ['fg', 'Type'],
  \ 'spinner': ['fg', 'Comment'],
  \ 'header':  ['fg', 'Comment'] }

" Customize fzf window
let g:fzf_layout = {'down': '30%'}
let g:fzf_preview_window = ['right:50%']
let g:rg_derive_root='true'

" Configure dash.vim (https://github.com/rizzatti/dash.vim)
let g:dash_activate=0

" Configure vim-markdown (https://github.com/plasticboy/vim-markdown)
" let g:vim_markdown_folding_disabled = 1
" let g:vim_markdown_conceal = 0
let g:tex_conceal = ''
let g:vim_markdown_math = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_fenced_languages = [
    \ 'viml=vim',
    \ 'bash=bash',
    \ 'java=java',
    \ 'ini=dosini',
    \ 'ansible=ansible',
    \ 'yaml=yaml',
    \ 'md=markdown'
    \ ]

" Configure vim-markdown-toc (https://github.com/mzlogin/vim-markdown-toc)
let g:vmt_dont_insert_fence = 1

" Configure vim-pydocstring (https://github.com/heavenshell/vim-pydocstring)
let g:pydocstring_formatter = 'google'
let g:pydocstring_doq_path = '/Users/ryanfisher/.local/bin/doq'
nmap <silent> <C-_> <Plug>(pydocstring)

" Configure vim-table-mode (https://github.com/dhruvasagar/vim-table-mode)

" Configure nerdtree-git-plugin (https://github.com/Xuyuanp/nerdtree-git-plugin)
let NERDTreeHijackNetrw=1                       " Open in current split with netrw
let NERDTreeShowHidden=1                        " Show NERDTree
let NERDTreeQuitOnOpen=1                        " Close NERDTree after file is opened
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ 'Modified'  : '•',
    \ 'Staged'    : '+',
    \ 'Untracked' : '*',
    \ 'Renamed'   : '⇢',
    \ 'Unmerged'  : '═',
    \ 'Deleted'   : 'x',
    \ 'Dirty'     : '✗',
    \ 'Clean'     : '✓',
    \ 'Ignored'   : '⌀',
    \ 'Unknown'   : '?'
    \ }

" Configure machakann/vim-sandwich
runtime macros/sandwich/keymap/surround.vim     " Enable vim-surround keymappings

" Configure (https://github.com/junegunn/vim-easy-align)
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:easy_align_delimiters = {
    \ '#': {
        \ 'pattern': '#\+',
        \ 'ignore_groups': ['String'],
        \ 'delimiter_align': 'l'
    \}
\ }

" Configure NERDCommenter scrooloose/nerdcommenter
let g:NERDSpaceDelims = 1                                             " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1                                         " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'                                       " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1                                          " Set a language to use its alternate delimiters by default
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } } " Add your own custom formats or override the defaults
let g:NERDCommentEmptyLines = 1                                       " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1                                  " Enable trimming of trailing whitespace when uncommenting

" Configure vim-easyclip (https://github.com/svermeulen/vim-easyclip)
let g:EasyClipUseCutDefaults = 0
let g:EasyClipUseSubstituteDefaults = 1

" Configure editorconfig-vim (https://github.com/editorconfig/editorconfig-vim)
let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']

" Configure neomake (https://github.com/neomake/neomake)
call neomake#configure#automake('nwr', 1000)
" call neomake#configure#automake('w')  " use when on battery
let g:neomake_ansible_enabled_makers = ['ansiblelint', 'yamllint']
let g:neomake_go_enabled_makers = ['go vet']
let g:neomake_java_enabled_makers = ['mvn']
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_markdown_enabled_makers = ['markdownlint']
let g:neomake_python_enabled_makers = ['flake8', 'python']
let g:neomake_ruby_enabled_makers = ['rubocop', 'rubylint']
let g:neomake_shell_enabled_makers = ['shellcheck']
let g:neomake_text_enabled_makers = ['writegood']
let g:neomake_vim_enabled_makers = ['vint']
let g:neomake_yaml_enabled_makers = ['yamllint']

" Seems to not be working...
" https://github.com/jhinch/nginx-linter
" let g:neomake_nginx_maker = {
"     \ 'exe': 'nginx-linter',
"     \ 'args': ['--include'],
"     \ 'errorformat': '%f:%l:%c: %m',
"     \ }

" Configure auto-pairs (https://github.com/jiangmiao/auto-pairs)
let g:AutoPairsMapCR=0

" Configure FastFold (https://github.com/Konfekt/FastFold)
let g:fastfold_savehook = 0

" Note colors are in the section after the color scheme is loaded
let g:neomake_error_sign = {'text': 'x', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '!', 'texthl': 'NeomakeWarningSign'}

" Configure vim-auto-save plugin (https://github.com/vim-scripts/vim-auto-save)
let g:auto_save = 1
let g:auto_save_silent = 1        " Do not display the auto-save notification
let g:auto_save_no_updatetime = 1 " do not change the 'updatetime' option

" Configure vim-tmux-navigator (https://github.com/christoomey/vim-tmux-navigator)
let g:tmux_navigator_save_on_switch = 2

" Configure ansible-vim (https://github.com/pearofducks/ansible-vim)
let g:ansible_template_syntaxes = {
        \ '*.python.j2': 'python',
        \ '*.cfg.j2': 'cfg',
        \ '*.php.j2': 'php',
        \ '*.sh.j2': 'sh',
        \ '*.groovy.j2': 'groovy',
        \ '*.conf.j2': 'nginx',
        \ '*.route.j2': 'nginx',
        \ '*.upstream.j2': 'nginx'
    \}
let g:ansible_attribute_highlight = 'ad'
let g:ansible_name_highlight = 'd'
let g:ansible_extra_keywords_highlight = 1
let g:ansible_with_keywords_highlight = 'PreProc'
let g:ansible_normal_keywords_highlight = 'Type'
let g:ansible_yamlKeyName = 'yamlKey'

" Configure vim-stay (https://github.com/zhimsel/vim-stay)
set viewoptions=cursor,folds,slash,unix

" Configure vim-lastplace (https://github.com/farmergreg/vim-lastplace)
" let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"     " Always put cursor at top when opening these files
" let g:lastplace_ignore_buftype = "terminal,quickfix,nofile,help"

" Configure Neovim Completion Manager (https://github.com/ncm2/ncm2)
" See ncm2 setup for details
set completeopt=noinsert,menuone,noselect
set shortmess+=c
inoremap <c-c> <ESC>
inoremap <expr> <CR> (pumvisible() ? "\<c-y>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Configure ncm2-utilisnips (https://github.com/ncm2/ncm2-ultisnips)
let g:UltiSnipsJumpForwardTrigger   = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger  = '<c-k>'
let g:UltiSnipsRemoveSelectModeMappings = 0

" Enable chriskempson/vim-tomorrow-theme
colorscheme Tomorrow-Night-Eighties

hi Cursor ctermbg=6 guibg=#76d4d6
hi NeomakeErrorSign ctermfg=196 guifg=#d70000
hi NeomakeWarningSign ctermfg=226 guifg=#ffff00
hi FoldColumn guifg=#313131 ctermfg=235

" Custom colors that override any theme loaded to this point
hi Search ctermfg=2 ctermbg=29 guifg=#a8d4a9 guibg=#134f2f
" hi Cursor ctermbg=6 guibg=#2aa198
" hi ColorColumn ctermbg=8 guibg=#003741
" hi Normal ctermbg=NONE guibg=NONE
" hi Comment cterm=italic gui=italic
" hi MatchParen ctermbg=NONE guibg=NONE
" hi GitGutterAdd ctermbg=8 guibg=#003741
" hi GitGutterChange ctermbg=8 guibg=#003741
" hi GitGutterDelete ctermbg=8 guibg=#003741
" hi GitGutterChangeDelete ctermbg=8 guibg=#003741
hi DiffDelete ctermfg=8 ctermbg=0 gui=bold guifg=#2d2d2d guibg=#484A4A
hi DiffAdd ctermbg=108  guibg=#366344
hi DiffChange ctermbg=31 guibg=#385570
hi DiffText ctermbg=208 guibg=#6E3935

" Configure nathanaelkane/vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  guibg=#313131   ctermbg=235
hi IndentGuidesEven guibg=#2d2d2d   ctermbg=237
" hi IndentGuidesOdd  guibg=#2d2d2d   ctermbg=232
" hi IndentGuidesEven guibg=#313131   ctermbg=237

" Configure lightline status bar
set laststatus=2
set noshowmode

if exists('g:gui_oni')
    set laststatus=0 noshowmode
endif

let g:lightline = {
    \ 'colorscheme': 'Tomorrow_Night_Eighties',
    \ 'active': {
    \   'left': [['mode', 'paste'],
    \            ['readonly', 'modified', 'filename']]
    \ },
    \ 'component_function': {
    \   'filename': 'LightLineFilename',
    \ },
    \ 'component': {
    \   'readonly': '%{&readonly?"⭤":""}',
    \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
    \ },
    \ 'component_visible_condition': {
    \   'readonly': '(&filetype!="help"&& &readonly)',
    \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
    \ },
    \ 'separator': { 'left': '⮀', 'right': '|' },
    \ 'subseparator': { 'left': '⮁', 'right': '|' }
\ }
    " \   'fugitive': '(&filetype!="help"&&exists("*fugitive#head") && ""!=fugitive#head())'
    " \   'fugitive': '%{&filetype=="help"?"":exists("*fugitive#head")?fugitive#head():"⭠"}'

" Lightline functions
function! LightLineFilename()
    if &buftype !=? 'terminal'
        let limit = 3
        let project_root = projectroot#guess()
        let path = substitute(expand('%:p'), project_root . '/', '', '')
        let trunc_path = path
        let path_len = len(path)
        let max_width = winwidth(0) - 65

        if path_len > max_width
            let max_width += 3
            let trunc_path = '...' . strpart(path, path_len - max_width)
        else
            let trunc_path = path
        endif

        return trunc_path
    endif
endfunction

function! SynStack()
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

""" Custom functions -----------------------------------------------------------
" Remove trailing whitespace and return cursor to starting position
function! s:StripTrailingWhitespaces()
    if &readonly == 0
            \&& &buftype ==? ''
            \&& &diff == 0
        let l:cur_pos = winsaveview()
        %s/\s\+$//e
        call winrestview(l:cur_pos)
        retab
   endif
endfunction

function! s:WriteIfModifiable()
    if buffer_name('%') !=? ''
                \&& &readonly == 0
                \&& &buftype !=? 'nofile'
                \&& &buftype !=? 'terminal'
                \&& &buftype !=? 'nowrite'
                \&& &diff == 0
                \&& buffer_name('%') !~? 'quickfix-'
        silent w
    endif
endfunction

" Open previous buffer, wipe current, quit if only one buffer
function! s:WipeBufOrQuit()
    let num_bufs = len(getbufinfo({'buflisted':1}))
    let prev_buf = bufnr('#')
    if num_bufs <= 1
        silent execute 'qall'
    elseif prev_buf == -1 || &buftype !=? ''
        silent execute 'quit'
        if &buftype ==? 'terminal'
            silent execute 'startinsert'
        endif
    else
        silent execute 'buf #'
        if bufnr('#') != -1
            silent execute 'bwipeout! #'
        endif
        if &buftype ==? 'terminal'
            silent execute 'startinsert'
        endif
    endif
endfunction

" Open NERDTree using ProjectRootExe if buffer isn't a terminal
function! s:NvimNerdTreeToggle()
    if &buftype ==? 'terminal'
        silent execute 'NERDTreeToggle'
    else
        silent execute 'ProjectRootExe NERDTreeToggle'
    endif
endfunction

" Make the enter key go into insert mode if on a terminal window
function! s:EnterInsertModeInTerminal()
    echo 'ran'
    if &buftype ==? 'terminal'
        if mode() ==? 'n'
            call startinsert()
        endif
    else
        silent execute 'nohlsearch'
        return '\<CR>'
    endif
endfunction

" Get the path to the current line from the project root
function! s:GetPathToCurrentLine()
    let root = ProjectRootGet()
    let full_path = expand('%:p') . ':' . line('.')
    let basename = split(root, '/')
    let basename = basename[-1]
    let path_from_root = join([basename, substitute(full_path, root, '', '')], '')

    return path_from_root
endfunction

" When opening a new split, create a new term if needed
function! s:OpenNewSplit(splitType)
    if a:splitType ==? '\'
        silent execute 'vsp'
    else
        silent execute 'sp'
    endif

    if &buftype ==? 'terminal'
        silent execute 'term'
    endif
endfunction

" Convert mac or dos line endings to unix
function! s:ConvertLineEndingsToUnix()
    :update
    :edit ++fileformat=dos
    :edit ++fileformat=mac
    :setlocal fileformat=unix
    :write
endfunction

" Toggle spell check
hi clear SpellCap
hi clear SpellRare
hi clear SpellLocal
function! ToggleSpell()
  if !exists('g:showingSpell')
    let g:showingSpell=1
    execute 'hi SpellBad cterm=underline gui=underline'
  endif

  if g:showingSpell==0
    execute 'hi SpellBad cterm=underline gui=underline'
    let g:showingSpell=1
    echom 'Spellcheck enabled'
  else
    execute 'hi clear SpellBad'
    let g:showingSpell=0
    echom 'Spellcheck disabled'
  endif
endfunction

command! ConvertEndings silent! call <SID>ConvertLineEndingsToUnix()

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" vim: set ft=vim
""" Startup autocommands -------------------------------------------------------
augroup vimrcEx
    au!

    " Don't change terminal size unless it is redrawn
    "au TermOpen * au <buffer> BufEnter,WinEnter redraw!

    " enable ncm2 for all buffers
    au BufEnter * call ncm2#enable_for_buffer()
    au TextChangedI * call ncm2#auto_trigger()
    au User Ncm2Plugin call ncm2#register_source({
        \ 'on_complete': ['ncm2#on_complete#delay',
        \                  300,
        \                 'ncm2#on_complete#omni',
        \                 'csscomplete#CompleteCSS'],
        \ })

    " Configure vim-javacomplete2 (https://github.com/artur-shaik/vim-javacomplete2)
    " autocmd FileType java,groovy setlocal omnifunc=javacomplete#Complete

    " Set syntax highlighting for specific file types
    au BufRead,BufNewFile Appraisals setl ft=ruby
    au BufRead,BufNewFile *.md setl ft=markdown nofoldenable
    au BufRead,BufNewFile *sudoers-* setl ft=sudoers
    au BufRead,BufNewFile .vimrc setl ft=vim
    au BufRead,BufNewFile */orchestration/*.yml setl ft=yaml.ansible
    au BufRead,BufNewFile Jenkinsfile setl ft=groovy
    au BufRead,BufNewFile .envrc setl ft=sh
    au BufRead,BufNewFile dockerfile.* setl ft=Dockerfile
    au BufRead,BufNewFile */gcloud_vars/.* set ft=sh

    " Enable spellchecking and textwrap for Markdown
    au FileType markdown setl spell
        \ formatoptions+=t
    au BufRead,BufNewFile *.md setl textwidth=80

    " Wrap at 72 characters and spell check git commit messages
    au FileType gitcommit setl filetype=markdown
        \ textwidth=72
        \ colorcolumn=50,72
        \ spell
        \ commentstring=#%s
        \ formatoptions+=t

    " Set Makefile filetype and don't expand tabs
    au BufRead,BufNewfile Makefile* setl ft=make noexpandtab tabstop=4
    au FileType make setl noexpandtab tabstop=4

    " Auto set nowrap on some files
    au BufRead */environments/000_cross_env_users.yml setl nowrap

    " :set nowrap for some files
    au BufRead, BufNewFile user_list.yml setl nowrap

    " Allow style sheets to auto-complete hyphenated words
    au FileType css,scss,sass setl iskeyword+=-

    " Remove tabs and trailing whitespace on open and insert
    au BufRead,BufLeave,TextChanged *
        \call <SID>StripTrailingWhitespaces()

    " Autosave
    au TextChanged * call <SID>WriteIfModifiable()

    " Autoread
    au CursorHold,CursorHoldI,FocusGained,BufEnter * checktime

    " Auto lint on write or change
    au BufWritePost,TextChanged * Neomake

    " Configure terminal settings
    au TermOpen * setl nospell
        \ nonumber
        \ norelativenumber

    " Force spell/nospell
    au FileType terraform setl spell
    au FileType ansible setl nospell
    au FileType yaml setl nospell
    au FileType Dockerfile setl nospell

    " Bind q to close quickfix
    au FileType quickfix nnoremap q :cclose

    " Hide the status line for FZF buffer
    au! FileType fzf
        au  FileType fzf setl laststatus=0 noshowmode noruler
        \| au BufLeave <buffer> setl laststatus=2 showmode ruler

" augroup END
