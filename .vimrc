" vim: set ft=vim:
" Setup plugin manager
so ~/.dotfiles/.plugins
so ~/.dotfiles/.vim-jenkins
so ~/.dotfiles/assets/term_color.vim

""" Prefrences ---------------------------------------------------------------
filetype plugin indent on           " Enable file type detection and do language-dependent indenting.
set autochdir                       " Auto change working directory to that of the current file
set autowrite                       " Automatically :write before running commands
set autoread                        " Automatically read files when they have changed
set backspace=2                     " Backspace deletes like most programs in insert mode
set backspace=indent,eol,start      " Make backspace behave in a sane manner.
set colorcolumn=80                  " Make it obvious where 80 characters is
set complete+=kspell                " Autocomplete with dictionary words when spell check is on
set diffopt+=vertical               " Always use vertical diffs
set formatoptions=croqnlj           " See :help fo-table
set foldenable                      " Code folding config
" set foldmethod=syntax
set foldlevelstart=99
set foldcolumn=0
set history=50                      " store command history across sessions
set hlsearch                        " hilight search matches
set incsearch                       " do incremental searching
set list listchars=tab:»·,trail:·,nbsp:·  " Dispay tabs, non-breaking spaces, and trailing whitespace
set mouse=a
set noshowmode                      " hide the mode status line
set ruler                           " show the cursor position all the time
set showbreak=↳\ \ \>               " Indicate wraped lines
set fillchars+=vert:\ |
set showcmd                         " display incomplete commands
set nospell spelllang=en_us         " Turn off spellchecking by default
set splitbelow                      " Open new split panes to the right/bottom
set splitright
set noswapfile                      " disable swap file
set timeoutlen=700                  " set a short leader timeout
set dir=~/tmp                       " set where swapfile(s) are stored
set wildmode=list:longest,list:full       " Configure autocompletion see :help wildmode
set secure                          " Prevent shell, write, :au unless file is owned by me
set scrolloff=2                     " Always show one line above/below the cursor
set termguicolors                   " Use truecolor
if &diff                            " only for diff mode/vimdiff
  set diffopt=filler,context:1000000      " filler is default and inserts empty lines for sync
endif

" Default tabbing prefrences
set tabstop=4
set shiftwidth=4
set softtabstop=4
set shiftround
set expandtab

" Relitive line numbers
set number
set relativenumber
set numberwidth=5

" Change cursor shape in iTerm2 & tmux in iTerm
if has('nvim')
    set guicursor=n-c-v-sm:block-Cursor/lCursor,
                \i-ci-ve:ver25-Cursor/lCursor,
                \r-cr-o:hor20-Cursor/lCursor,
                \a:blinkwait0-blinkoff500-blinkon500-Cursor/lCursor
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
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  set synmaxcol=200
endif


""" Key mappings ---------------------------------------------------------------
map <SPACE> <leader>
let mapleader = ' '
inoremap <C-@> <C-Space>|                                   " Get to next editing point after autocomplete
inoremap jj <ESC>|                                          " Easy escape from insert/visual mode
inoremap jk <ESC>|                                          " Easy escape from insert/visual mode
" nnoremap <CR> :call <SID>EnterInsertModeInTerminal()<CR>|
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>|         " Replace selected text
nnoremap \ :ProjectRootCD<CR>:Ag -iQ<SPACE>|                 " bind \ (backward slash) to grep shortcut
nnoremap <silent> <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>:lclose\|cclose\|noh\<CR>" : ":noh\<CR>\<CR>"
nnoremap K                                                  " Keep searching for man entries by accident
nnoremap Q <Plug>window:quickfix:toggle

" Easy split navigation
nnoremap <C-h> <C-w>h                           " Move left a window
nnoremap <C-j> <C-w>j                           " Move down a window
nnoremap <C-k> <C-w>k                           " Move up a window
nnoremap <C-l> <C-w>l                           " Move right a window
nnoremap <c-w><c-w> <C-w>=                      " Set windows to equal size
inoremap <C-h> <ESC><C-w>h                      " Move left a window
inoremap <C-j> <ESC><C-w>j                      " Move down a window
inoremap <C-k> <ESC><C-w>k                      " Move up a window
inoremap <C-l> <ESC><C-w>l                      " Move right a window
inoremap <c-w><c-w> <C-w>=                      " Set windows to equal size
if has('nvim')
    tnoremap <C-h> <C-\><C-n><C-w>h             " Move left a window
    tnoremap <C-j> <C-\><C-n><C-w>j             " Move down a window
    tnoremap <C-k> <C-\><C-n><C-w>k             " Move up a window
    tnoremap <C-l> <C-\><C-n><C-w>l             " Move right a window
    " breaks terminal ctrl+w for deleting tnoremap <c-w><c-w> <C-\><C-n><C-w>=        " Set windows to equal size
endif


" Use magic in search/substitue
nnoremap / /\v\c
vnoremap / /\v\c
cnoremap %% %s/\v
" cnoremap \>s/ \>smagic/
" nnoremap :g/ :g/\v
" nnoremap :g// :g//

" Leader key remappings
nnoremap <leader>\ :call <SID>OpenNewSplit('\')<CR>|                                                                " Open vertical split
nnoremap <leader>\| :call <SID>OpenNewSplit('\|')<CR>|                                                                 " Open horizontal split
nnoremap <leader>qa :call <SID>StripTrailingWhitespaces()<CR>:wa<CR>:qa<CR>|                " Close buffer(s)
nnoremap <silent><leader>q :call <SID>WipeBufOrQuit()<CR>
nnoremap <silent><leader>qq :q<CR>|
nnoremap <silent><leader>Q :q<CR>|
nnoremap <silent><leader>~ :sp<CR>:ProjectRootExe term<CR>:setl nospell<CR>:startinsert<CR>
nnoremap <silent><leader>` :vsp<CR>:ProjectRootExe term<CR>:setl nospell<CR>:startinsert<CR>
nnoremap <silent><leader>w :call <SID>StripTrailingWhitespaces()<CR>:w<CR>|                 " wtf workaround bc broken from autowrite or...???? Write buffer
nnoremap <silent><leader>1 :call <SID>NvimNerdTreeToggle()<CR>|                             " Open/close NERDTree
nnoremap <silent><leader>2 :ProjectRootExe NERDTreeFind<CR>|                                " Open NERDTree and hilight the current file
nnoremap <silent><leader>3 :ProjectRootExe e .<CR>|
nnoremap <leader>n :enew<CR>|                                                               " Open new buffer in current split
nnoremap <leader>L :SyntasticToggleMode<CR>|                                                " Togle syntastic mode
nnoremap <leader>l :SyntasticCheck<CR>|                                                     " Trigger syntastic check
nnoremap <leader>/ :noh<CR>|                                                                " Clear search pattern matches with return
" nnoremap <leader>m :!clear;ansible-lint %<CR>|                                              " Run ansible-lint on the current file
nnoremap <silent><leader>m :Neomake
nnoremap <silent><C-p> :ProjectRootExe Files<CR>|                                           " Open FZF
nnoremap <silent><C-p> :ProjectRootExe Files<CR>|                                           " Open FZF
nnoremap <leader>ha <Plug>GitGutterStageHunk
nnoremap <leader>hr <Plug>GitGutter
nnoremap <silent><leader>l :let @+=<SID>GetPathToCurrentLine()<CR>|  " Copy curgent line path/number
nnoremap Y y$  " Make Y act like C and D
nnoremap <leader>d :Dash<CR>

" Find/replace
nnoremap <leader>f :lvim /<C-R>=expand("<cword>")<CR>/ %<CR>:lopen<CR>
nnoremap <silent><leader>F :ProjectRootExe grep! "\b<C-R><C-W>\b"<CR>:bo copen 5<CR>|         " Bind K to grep word under cursor
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


" NeoVim configuration
if has('nvim')
    let $VISUAL = 'nvr -cc split --remote-wait'  " Prevent nested neovim instances when using :term
    nnoremap <leader>rc :so ~/.config/nvim/init.vim<CR>|
else
    nnoremap <leader>rc :so $MYVIMRC<CR>:echom $MYVIMRC " reloaded"<CR>|
endif

" Commands (aliases)
" command! Grc Gsdiff :1 | Gvdiff                 " Open vimdiff/fugitive in 4 splits with base shown
" command! -nargs=? Gd Gdiff <args>               " Alias for Gdiff
" command! Gs Gstatus                             " Alias for Gstatus
" command! Gc Gcommit                             " Alias for Gcommit
" command! -nargs=* -bar G !clear;git <args>      " Alias for Git
" command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor


""" Custom commands ------------------------------------------------------------
" Define an Ag command to search for the provided text and open results in quickfix
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|:bo copen 10|redraw!

" Define a decrypt/encrypt command to decrypt the current file
command! -nargs=+ -bar DecryptThis silent! !ansible-vault decrypt --vault-password-file ~/.ansible/vault-passwords/<args> %
command! -nargs=+ -bar EncryptThis silent! !ansible-vault encrypt --vault-password-file ~/.ansible/vault-passwords/<args> %

" Git aliases
command! -nargs=0 Grbm silent! Git rebase -i origin/master


""" Plugin config --------------------------------------------------------------
" Configure neovim (https://github.com/neovim/neovim/wiki)
let g:python_host_prog  = '/Users/ryanfisher/.pyenv/shims/python2'      " Enable python2 support
let g:python3_host_prog = '/Users/ryanfisher/.pyenv/shims/python3'      " Enable python3 support

" Configure deoplete.nvim (https://github.com/Shougo/deoplete.nvim)
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 100
let g:deoplete#sources#jedi#python_path = '/usr/local/bin/python3'
call deoplete#custom#source('_', 'matchers', ['matcher_head'])
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

if has('nvim')                                              " Prevent nested neovim instances when using :term
  let $VISUAL = 'nvr -cc split --remote-wait'
endif

" Use The Silver Searcher if it is installed
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden --skip-vcs-ignores -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

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

" Configure dash.vim (https://github.com/rizzatti/dash.vim)
let g:dash_activate=0

" Configure vim-markdown (https://github.com/plasticboy/vim-markdown)
" let g:vim_markdown_folding_disabled = 1
" let g:vim_markdown_conceal = 0
let g:tex_conceal = ""
let g:vim_markdown_math = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_fenced_languages = [
    \ 'viml=vim',
    \ 'bash=sh',
    \ 'java=java',
    \ 'ini=dosini',
    \ 'ansible=ansible',
    \ 'yaml=yaml',
    \ 'md=markdown'
    \ ]

" Configure vim-markdown-toc (https://github.com/mzlogin/vim-markdown-toc)
let g:vmt_dont_insert_fence = 1

" Configure vim-table-mode (https://github.com/dhruvasagar/vim-table-mode)

" Configure nerdtree-git-plugin (https://github.com/Xuyuanp/nerdtree-git-plugin)
let NERDTreeHijackNetrw=1                       " Open in current split with netrw
let NERDTreeShowHidden=1                        " Show NERDTree
let NERDTreeQuitOnOpen=1                        " Close NERDTree after file is opened
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "•",
    \ "Staged"    : "+",
    \ "Untracked" : "*",
    \ "Renamed"   : "⇢",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "x",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✓",
    \ 'Ignored'   : "⌀",
    \ "Unknown"   : "?"
    \ }

" Configure machakann/vim-sandwich
runtime macros/sandwich/keymap/surround.vim     " Enable vim-surround keymappings

" Configure (https://github.com/junegunn/vim-easy-align)
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Configure NERDCommenter scrooloose/nerdcommenter
let g:NERDSpaceDelims = 1                                               " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1                                           " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'                                         " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1                                            " Set a language to use its alternate delimiters by default
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }   " Add your own custom formats or override the defaults
let g:NERDCommentEmptyLines = 1                                         " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1                                    " Enable trimming of trailing whitespace when uncommenting

" Configure vim-easyclip (https://github.com/svermeulen/vim-easyclip)
let g:EasyClipUseCutDefaults = 0
let g:EasyClipUseSubstituteDefaults = 1

" Configure neomake (https://github.com/neomake/neomake)
call neomake#configure#automake('nwr', 1000)
let g:neomake_ansible_enabled_makers = ['ansiblelint', 'yamllint']
let g:neomake_python_enabled_makers = ['pep8', 'flake8', 'python']

" Note colors are in the section after the color scheme is loaded
let g:neomake_error_sign = {'text': 'x', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '!', 'texthl': 'NeomakeWarningSign'}

" Configure vim-auto-save plugin (https://github.com/vim-scripts/vim-auto-save)
let g:auto_save = 1
let g:auto_save_silent = 1              " Do not display the auto-save notification
let g:auto_save_no_updatetime = 1       " do not change the 'updatetime' option

" Configure vim-tmux-navigator (https://github.com/christoomey/vim-tmux-navigator)
let g:tmux_navigator_save_on_switch = 2

" Configure ansible-vim (https://github.com/pearofducks/ansible-vim)
let g:ansible_template_syntaxes = {
            \'*.python.j2': 'python',
            \'*.cfg.j2': 'cfg',
            \'*.php.j2': 'php',
            \'*.sh.j2': 'sh',
            \'*.groovy.j2': 'groovy'
            \}
let g:ansible_attribute_highlight = "ad"
let g:ansible_name_highlight = "d"
let g:ansible_extra_keywords_highlight = 1
let g:ansible_with_keywords_highlight = 'PreProc'
let g:ansible_normal_keywords_highlight = 'Type'
let g:ansible_yamlKeyName = 'yamlKey'

" Configure vim-lastplace (https://github.com/farmergreg/vim-lastplace)
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"     " Always put cursor at top when opening these files
let g:lastplace_ignore_buftype = "quickfix,nofile,help"

" Configure vim-diminactive (https://github.com/blueyed/vim-diminactive)
let g:diminactive_use_syntax = 1
let g:diminactive_use_colorcolumn = 0
let g:diminactive_enable_focus = 1

" Enable jnurmine/Zenburn color scheme
" colorscheme Zenburn

" Enable chriskempson/vim-tomorrow-theme
colorscheme Tomorrow-Night-Eighties

hi Cursor ctermbg=6 guibg=#76d4d6
hi NeomakeErrorSign ctermfg=196 guifg=#d70000
hi NeomakeWarningSign ctermfg=226 guifg=#ffff00
" Enable icymind/NeoSolarized color scheme
" NOTE: highlight customizations must be after this
" colorscheme NeoSolarized
" set background=dark
" let g:neosolarized_contrast = "high"
" let g:neosolarized_visibility = "low"
" let g:neosolarized_vertSplitBgTrans = 1
" let g:neosolarized_bold = 1
" let g:neosolarized_underline = 1
" let g:neosolarized_italic = 1

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
let g:lightline = {
  \ 'component_function': {
    \  'filename': 'LightLineFilename'
  \ },
  \ 'colorscheme': 'Tomorrow_Night_Eighties',
  \ 'component': {
  \   'readonly': '%{&readonly?"⭤":""}',
  \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
  \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():"⭠"}'
  \ },
  \ 'component_visible_condition': {
  \   'readonly': '(&filetype!="help"&& &readonly)',
  \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
  \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
  \ },
  \ 'separator': { 'left': '⮀', 'right': '⮂' },
  \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
\ }

" Lightline functions
function! LightLineFilename()
    let limit = 3
    let project_root = projectroot#guess()
    let path = substitute(expand('%:p'), project_root . '/', '', '')
    let path_len = len(path)
    let max_width = winwidth(0) - 65

    if path_len > max_width
        let max_width += 3
        return '...' . strpart(path, path_len - max_width)
    else
        return path
    endif
endfunction

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

""" Startup autocommands -------------------------------------------------------
augroup vimrcEx
  au!

  " Configure vim-javacomplete2 (https://github.com/artur-shaik/vim-javacomplete2)
  autocmd FileType java,groovy setlocal omnifunc=javacomplete#Complete

  " Set syntax highlighting for specific file types
  au BufRead,BufNewFile Appraisals set ft=ruby
  au BufRead,BufNewFile *.md set ft=markdown | set nofoldenable
  au BufRead,BufNewFile *sudoers-* set ft=sudoers
  au BufRead,BufNewFile .vimrc set ft=vim
  au BufRead,BufNewFile */orchestration/*.yml set ft=yaml.ansible
  au BufRead,BufNewFile *.yaml,*.yml set tabstop=2
              \| set shiftwidth=2
              \| set softtabstop=2
  au BufRead,BufNewFile Jenkinsfile set ft=groovy

  " Enable spellchecking and textwrap for Markdown
  au FileType markdown setl spell
    \| setl formatoptions+=t
  au BufRead,BufNewFile *.md setl textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  au FileType gitcommit setl textwidth=72
    \| setlocal colorcolumn=50,72
    \| setl spell
    \| setl filetype=markdown
    \| setl commentstring=#%s
    \| setl formatoptions+=t

  " Set Makefile to ft make and don't expand tabs
  au BufRead,BufNewfile Makefile set ft=make
  au FileType make setl noexpandtab
              \| setl list listchars=tab:\ \ ,trail:·,nbsp:·

  " Auto set nowrap on some files
  au BufRead */environments/000_cross_env_users.yml setl nowrap

  " :set nowrap for some files
  au BufRead, BufNewFile user_list.yml setl nowrap

  " Allow style sheets to auto-complete hyphenated words
  au FileType css,scss,sass setl iskeyword+=-

  " Remove tabs and trailing whitespace on open and insert
  au BufRead,BufEnter,BufLeave,TextChanged *
    \call <SID>StripTrailingWhitespaces()

  " Autosave
  au TextChanged * call <SID>WriteIfModifiable()

  " Autoread
  au CursorHold,CursorHoldI,FocusGained,BufEnter * checktime

  " Auto lint on write
  au BufWritePost * Neomake

  " Configure terminal settings
  au TermOpen * setl nospell | setl nonumber | setl norelativenumber

  " Bind q to close quickfix
  au FileType quickfix nnoremap q :cclose

  " Hide the status line for FZF buffer
  autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" augroup END


""" Custom functions -----------------------------------------------------------
" Remove trailing whitespace and return cursor to starting position
function! s:StripTrailingWhitespaces()
    if &readonly == 0
            \&& &buftype == ''
            \&& &diff == 0
        let cur_line = line('.')
        let cur_col = col('.')
        %s/\s\+$//e
        call cursor(cur_line, cur_col)
        retab
   endif
endfunction

function! s:WriteIfModifiable()
    if buffer_name('%') != ''
                \&& &readonly == 0
                \&& &buftype != 'nofile'
                \&& &buftype != 'terminal'
                \&& &buftype != 'nowrite'
                \&& &diff == 0
        silent w
    endif
endfunction

" Tab completion
" Will insert tab at beginning of line, will use completion if not at beginning
function! s:InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=<SID>InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Open previous buffer, wipe current, quit if only one buffer
function! s:WipeBufOrQuit()
    let num_bufs = len(getbufinfo({'buflisted':1}))
    let prev_buf = bufnr('#')
    if num_bufs <= 1
        silent execute 'qall'
    elseif prev_buf == -1 || &buftype != ''
        silent execute 'quit'
        if &buftype == 'terminal'
            silent execute 'startinsert'
        endif
    else
        silent execute 'buf #'
        if bufnr('#') != -1
            silent execute 'bwipeout! #'
        endif
        if &buftype == 'terminal'
            silent execute 'startinsert'
        endif
    endif
endfunction

" Open NERDTree using ProjectRootExe if buffer isn't a terminal
function! s:NvimNerdTreeToggle()
    if &buftype == 'terminal'
        silent execute 'NERDTreeToggle'
    else
        silent execute 'ProjectRootExe NERDTreeToggle'
    endif
endfunction

" Make the enter key go into insert mode if on a terminal window
function! s:EnterInsertModeInTerminal()
    echo 'ran'
    if &buftype == 'terminal'
        if mode() == 'n'
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
    let full_path = expand("%:p") . ':' . line(".")
    let basename = split(root, "/")
    let basename = basename[-1]
    let path_from_root = join([basename, substitute(full_path, root, "", "")], "")

    return path_from_root
endfunction

" When opening a new split, create a new term if needed
function! s:OpenNewSplit(splitType)
    if a:splitType == '\'
        silent execute 'vsp'
    else
        silent execute 'sp'
    endif

    if &buftype == 'terminal'
        silent execute 'term'
    endif
endfunction

" Convert mac or dos line endings to unix
function! s:ConvertLineEndingsToUnix()
    :update
    :edit ++ff=dos
    :edit ++ff=mac
    :setlocal ff=unix
    :write
endfunction

command! ConvertEndings silent! call <SID>ConvertLineEndingsToUnix()

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Get off my lawn
" nnoremap <Left> :echoe "Use h"<CR>
" nnoremap <Right> :echoe "Use l"<CR>
" nnoremap <Up> :echoe "Use k"<CR>
" nnoremap <Down> :echoe "Use j"<CR>

