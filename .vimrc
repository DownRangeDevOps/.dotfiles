" vim: set ft=vim:
" Setup plugin manager
so ~/.config/nvim/autoload/plug.vim
so ~/.config/nvim/autoload/vim-repeat/autoload/repeat.vim
so ~/.dotfiles/.plugins

""" Prefrences
filetype plugin indent on           " Enable file type detection and do language-dependent indenting.
set autochdir                       " Auto change working directory to that of the current file
set autowrite                       " Automatically :write before running commands
set autoread                        " Automatically read files when they have changed
set backspace=2                     " Backspace deletes like most programs in insert mode
set backspace=indent,eol,start      " Make backspace behave in a sane manner.
set clipboard+=unnamedplus          " Always yank to the system clipboard
set colorcolumn=80                  " Make it obvious where 80 characters is
set complete+=kspell                " Autocomplete with dictionary words when spell check is on
set diffopt+=vertical               " Always use vertical diffs
set history=50                      " store command history across sessions
set hlsearch                        " hilight search matches
set incsearch                       " do incremental searching
set list listchars=tab:»·,trail:·,nbsp:·  " Dispay tabs, non-breaking spaces, and trailing whitespace
set noshowmode                      " hide the mode status line
"set nowrap                         " Don't wrap lines in the display
set ruler                           " show the cursor position all the time
set showbreak=↳\ \ \>               " Indicate wraped lines
set showcmd                         " display incomplete commands
set splitbelow                      " Open new split panes to the right/bottom
set splitright
set swapfile                        " use a swap file
set timeoutlen=750                  " set a short leader timeout
set dir=~/tmp                       " set where swapfile(s) are stored
set wildmode=list:longest,list:full       " Configure autocompletion see :help wildmode
set secure                          " Prevent shell, write, :autocmd unless file is owned by me
set scrolloff=2                     " Always show one line above/below the cursor
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
   set guicursor=a:blinkwait1-blinkoff500-blinkon500-Cursor/lCursor,
                \n-c-v-sm:block,
                \i-ci-ve:ver25,
                \r-cr-o:hor20
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

""" Key mappings
map <SPACE> <leader>
let mapleader = ' '
inoremap <C-@> <C-Space>|    " Get to next editing point after autocomplete
inoremap jj <Esc>|           " Easy escape from insert/visual mode
inoremap jk <Esc>|           " Easy escape from insert/visual mode
noremap <D-v> :set paste<CR>o<exc>"*]p nopaste<CR>|         " Paste from external source, copy to external source
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>|         " Replace selected text
nnoremap \ :ProjectRootCD<CR>:Ag -i<SPACE>|                 " bind \ (backward slash) to grep shortcut
nnoremap <CR> :noh<CR><CR>|                                 " Clear search pattern matches with return
nnoremap K                                                  " Keep searching for man entries by accident
vnoremap <C-c> :w !reattach-to-user-namespace pbcopy<CR>|   " Copy to system clipboar
nnoremap <C-h> <C-w>h              " Move left a window
nnoremap <C-j> <C-w>j              " Move down a window
nnoremap <C-k> <C-w>k              " Move up a window
nnoremap <C-l> <C-w>l              " Move right a window
if has('nvim')
    tnoremap <C-h> <C-\><C-n><C-w>h    " Move left a window
    tnoremap <C-j> <C-\><C-n><C-w>j    " Move down a window
    tnoremap <C-k> <C-\><C-n><C-w>k    " Move up a window
    tnoremap <C-l> <C-\><C-n><C-w>l    " Move right a window
endif


" Use magic
nnoremap // /\v
vnoremap // /\v
cnoremap %% %s/\v
" cnoremap \>s/ \>smagic/
" nnoremap :g/ :g/\v
" nnoremap :g// :g//

" Leader key remappings
nnoremap <leader>\ :vsp<CR>|                            " Open vertical split
nnoremap <leader>- :sp<CR>|                             " Open horizontal split
nnoremap <leader>q :q<CR>|                              " Close buffer
nnoremap <leader>w :w<CR>|                              " Write buffer
nnoremap <leader>1 :ProjectRootExe NERDTreeToggle<CR>|  " Open/close NERDTree
nnoremap <leader>2 :ProjectRootExe NERDTreeFind<CR>|    " Open NERDTree and hilight the current file
nnoremap <leader>n :enew<CR>|                           " Open new buffer in current split
nnoremap <leader>L :SyntasticToggleMode<CR>|            " Togle syntastic mode
nnoremap <leader>l :SyntasticCheck<CR>|                 " Trigger syntastic check
nnoremap <leader>/ :noh<CR>|                            " Clear search pattern matches with return
nnoremap <leader>f :ProjectRootExe grep! "\b<C-R><C-W>\b"<CR>:bo copen<CR>| " Bind K to grep word under cursor
nnoremap <leader>m :!clear;ansible-lint %<CR>|          " Run ansible-lint on the current file
nnoremap <leader>h <C-w>h                               " Move to left window
nnoremap <leader>j <C-w>j                               " Move down a window
nnoremap <leader>k <C-w>k                               " Move up a window
nnoremap <leader>l <C-w>l                               " Move to right window

if has('nvim')
    nnoremap <leader>r :so ~/.config/nvim/init.vim<CR>| " Reload vimrc
else
    nnoremap <leader>r :so $MYVIMRC<CR>:echom $MYVIMRC " reloaded"<CR>|
endif


" Commands (aliases)
command! Grc Gsdiff :1 | Gvdiff                 " Open vimdiff/fugitive in 4 splits with base shown
command! -nargs=? Gd Gdiff <args>               " Alias for Gdiff
command! Gs Gstatus                             " Alias for Gstatus
command! Gc Gcommit                             " Alias for Gcommit
command! -nargs=* -bar G !clear;git <args>      " Alias for Git
command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor


""" Plugin config
" Configure neovim (https://github.com/neovim/neovim/wiki)
let g:python_host_prog  = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

" Use The Silver Searcher if it is installed
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Define an Ag command to search for the provided text and open results in quickfix
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|:bo copen 5|redraw!

" Configure CtrlP (https://github.com/kien/ctrlp.vim)
let g:ctrlp_working_path_mode='ra'     " set root to vim start location (c=current file, r=nearest '.git/.svn/...', a=like c but current file)
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:100,results:10'
let g:ctrlp_brief_prompt = 1

" Configure vim-markdown (https://github.com/plasticboy/vim-markdown)
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:tex_conceal = ""
let g:vim_markdown_math = 1
let g:vim_markdown_autowrite = 1
let g:vim_markdown_fenced_languages = [
    \ 'viml=vim',
    \ 'bash=sh',
    \ 'java=java',
    \ 'ini=dosini',
    \ 'ansible=ansible',
    \ 'yaml=yaml',
    \ 'md=markdown'
    \ ]

" Configure nerdtree-git-plugin (https://github.com/Xuyuanp/nerdtree-git-plugin)
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

" Configure NERDCommenter (https://github.com/scrooloose/nerdcommenter)
let g:NERDSpaceDelims = 1                                               " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1                                           " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'                                         " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1                                            " Set a language to use its alternate delimiters by default
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }   " Add your own custom formats or override the defaults
let g:NERDCommentEmptyLines = 1                                         " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1                                    " Enable trimming of trailing whitespace when uncommenting

" Configure YouCompleteMe (https://github.com/Valloric/YouCompleteMe)
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go,groovy' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }

" Configure Syntastic plugin (https://github.com/vim-syntastic/syntastic)
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_aggregate_errors = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_enable_highlighting = 1
let g:syntastic_auto_jump = 2
let g:syntastic_echo_current_error = 1
let g:syntastic_cursor_column = 1
let g:syntastic_enable_signs=1

" Set syntastic's default mode
let syntastic_mode_map = { 'mode': 'passive' }

" Set syntastic checker when there is more than one option
let g:syntastic_markdown_checkers = ['syntastic-markdown-mdl']
let g:syntastic_json_checkers = ['syntastic-json-jsonlint']
let g:syntastic_dockerfile_checkers = ['syntastic-dockerfile-dockerfile_lint']
let g:syntastic_python_checkers = ['syntastic-python-prospector']
let g:syntastic_yaml_checkers = ['syntastic-yaml-yamllint']
let g:syntastic_ansible_checkers = ['syntastic-ansible-ansible_lint']

" Syntastic linter specific filters
" let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
" let g:syntastic_eruby_ruby_quiet_messages =
"     \ {"regex": "possibly useless use of a variable in void context"}

" Configure vim-auto-save plugin (https://github.com/vim-scripts/vim-auto-save)
let g:auto_save = 1
let g:auto_save_silent = 1                                                  " Do not display the auto-save notification
let g:auto_save_no_updatetime = 1                                           " do not change the 'updatetime' option

" Configure vim-tmux-navigator (https://github.com/christoomey/vim-tmux-navigator)
let g:tmux_navigator_save_on_switch = 2

" Configure ansible-vim
let g:ansible_unindent_after_newline = 1            " Unindent after two newlines
let g:ansible_extra_syntaxes = "php.vim sh.vim cfg.vim"     " Syntax highlight with the native language for *.j2 files
let g:ansible_attribute_highlight = "ad"            " Dim all instances of key=
let g:ansible_name_highlight = "b"                  " Brighten name: if at start

" Configure vim-lastplace (https://github.com/farmergreg/vim-lastplace)
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"     " Always put cursor at top when opening these files
let g:lastplace_ignore_buftype = "quickfix,nofile,help"

" Configure vim-diminactive (https://github.com/blueyed/vim-diminactive)
" let g:diminactive_use_syntax = 1
" let g:diminactive_use_colorcolumn = 0
" let g:diminactive_enable_focus = 1

" Enable lifepillar/vim-solarized8 color scheme
" NOTE: highlight customizations must be after this
syntax enable
set background=dark
colorscheme solarized8_dark_low
let g:solarized_term_italics = 1

" Configure lightline status bar
set laststatus=2
let g:lightline = {
  \ 'component_function': {
    \  'filename': 'LightLineFilename'
  \ },
  \ 'colorscheme': 'solarized',
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
    let prefix = '...'
    let limit = 3
    let path_components = split(expand('%:p'), '/')

    if len(path_components) > limit
        return join(path_components[-limit:-1], '/')
    else
        return join(path_components,'/')
    endif
endfunction

" Put all autocmd settings here to load them only when vimrc is executed
augroup vimrcEx
  autocmd!

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set ft=ruby
  autocmd BufRead,BufNewFile *.md set ft=markdown | set nofoldenable
  autocmd BufRead,BufNewFile *sudoers-* set ft=sudoers
  autocmd BufRead,BufNewFile .vimrc set ft=vim

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell
  autocmd FileType gitcommit set filetype=markdown

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  " Remove tabs and trailing whitespace on open and insert
  autocmd BufRead,FocusGained,InsertLeave,TextChanged *
    \ :call <SID>StripTrailingWhitespaces()

  " Autosave
  " autocmd FocusLost,InsertLeave,BufLeave,BufWinLeave,TextChanged
  "  \ * :call WriteIfModifiable()
augroup END

" Remove trailing whitespace and return cursor to starting position
function! <SID>StripTrailingWhitespaces()
    if &readonly == 0
                \&& &buftype != 'nofile'
                \&& &buftype != 'terminal'
                \&& &diff == 0
        let l = line('.')
        let c = col('.')
        %s/\s\+$//e
        call cursor(l, c)
        retab
   endif
endfunction

function! WriteIfModifiable()
    if buffer_name('%') != ''
                \&& &readonly == 0
                \&& &buftype != 'nofile'
                \&& &buftype != 'terminal'
                \&& &diff == 0
        silent w
    endif
endfunction

" Auto pastemode
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()      " Automatically set pastemode when pasting from system

" function! NERDTreeOpen()
"     if buffer_name('%') =~ 'NERD_tree_'
"         NERDTreeToggle
"     else
"         ProjectRootExe NERDTreeFind
"     endif
" endfunction

" Tab completion
" Will insert tab at beginning of line, will use completion if not at beginning
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Custom colors that override any theme loaded to this point
hi ColorColumn ctermbg=8
highlight Comment cterm=italic
hi Normal ctermbg=0

" This was all to set bg transparent so tmux active pane hilighting would work
" hi Normal ctermbg=NONE
" hi SignColumn ctermbg=NONE
" hi LineNr ctermbg=NONE
" hi CursorLineNr ctermbg=NONE
" hi NonText ctermbg=NONE
" hi Special ctermbg=NONE
" hi Comment ctermbg=NONE
" hi Conceal ctermbg=NONE
" hi SpecialKey ctermbg=NONE
" hi GitGutterAdd ctermbg=NONE
" hi GitGutterChange ctermbg=NONE
" hi GitGutterDelete ctermbg=NONE
" hi GitGutterChangeDelete ctermbg=NONE

