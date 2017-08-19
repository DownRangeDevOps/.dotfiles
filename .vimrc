" Setup Vundle plugin manager
so ~/.dotfiles/.vundler

""" Prefrences
filetype plugin indent on                       " Enable file type detection and do language-dependent indenting.
hi ColorColumn ctermbg=8                        " Set the color of right margin marker
set autochdir                                   " Auto change working directory to that of the current file
set autowrite                                   " Automatically :write before running commands
set autoread                                    " Automatically read files when they have changed
set backspace=2                                 " Backspace deletes like most programs in insert mode
set backspace=indent,eol,start                  " Make backspace behave in a sane manner.
set clipboard=unnamed                           " Copy to the system clipboard automatically
set colorcolumn=81                              " Make it obvious where 80 characters is
set complete+=kspell                            " Autocomplete with dictionary words when spell check is on
set diffopt+=vertical                           " Always use vertical diffs
set history=50                                  " store command history across sessions
set hlsearch                                    " hilight search matches
set incsearch                                   " do incremental searching
set list listchars=tab:»·,trail:·,nbsp:·
set noshowmode                                  " hide the mode status line
set nowrap                                      " Don't wrap lines in the display
set ruler                                       " show the cursor position all the time
set showbreak=↳\ \ \>                           " Indicate wraped lines
set showcmd                                     " display incomplete commands
set splitbelow                                  " Open new split panes to the right/bottom
set splitright
set swapfile                                    " use a swap file
set timeoutlen=500                              " set a short leader timeout
set dir=~/tmp                                   " set where swapfile(s) are stored
let NERDTreeShowHidden=1                        " Show NERDTree
let NERDTreeQuitOnOpen=1                        " Close NERDTree after file is opened
set wildmode=list:longest,list:full
set secure                                      " Prevent shell, write, :autocmd unless file is owned by me

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

" Change cursor shape in iTerm2 & tmux in iTerm2
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

""" Key mappings
let mapleader=' '
inoremap <C-@> <C-Space>|                                               " Get to next editing point after autocomplete
inoremap jj <Esc>|                                                      " Easy escape from insert/visual mode
noremap <D-v> :set paste<CR>o<exc>"*]p nopaste<cr>|                     " Paste from external source, copy to external source
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>|                     " Replace selected text
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>|                          " Bind K to grep word under cursor
nnoremap \ :Ag<SPACE>|                                                  " bind \ (backward slash) to grep shortcut
nnoremap <CR> :noh<CR><CR>|                                             " Clear search pattern matches with return

" Leader key remappings
nnoremap <leader>\ :vsp<CR>|                                            " Open vertical split
nnoremap <leader>- :sp<CR>|                                             " Open horizontal split
nnoremap <leader>q :q<CR>|                                              " Close buffer
noremap <leader>1 :NERDTreeToggle<CR>|                                  " Toggle NERDTree
nnoremap <leader>r :so $MYVIMRC<CR>:echom $MYVIMRC " reloaded"<CR>|     " Reload vimrc
nnoremap <leader>n :enew<CR>|                                           " Open new buffer in current split
nnoremap <leader>L :SyntasticToggleMode<CR>|                            " Togle syntastic mode
nnoremap <leader>l :SyntasticCheck<CR>|                                 " Togle syntastic mode

""" Plugin config

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
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|:bo copen|redraw!

" Configure CtrlP (https://github.com/kien/ctrlp.vim)
let g:ctrlp_working_path_mode='ra'     " set root to vim start location (c=current file, r=nearest '.git/.svn/...', a=like c but current file)
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:100,results:20'

" Configure NERDCommenter (https://github.com/scrooloose/nerdcommenter)
let g:NERDSpaceDelims = 1                                               " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1                                           " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'                                         " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1                                            " Set a language to use its alternate delimiters by default
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }   " Add your own custom formats or override the defaults
let g:NERDCommentEmptyLines = 1                                         " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1                                    " Enable trimming of trailing whitespace when uncommenting

" Configure vim-jedi plugin (https://github.com/davidhalter/jedi-vim)
" let g:jedi#use_splits_not_buffers = "left"    " using youcompleteme instead

" Configure Syntastic plugin (https://github.com/vim-syntastic/syntastic)
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_loc_list_height = 5

" Set syntastic checker when there is more than one option
let g:syntastic_markdown_checkers = ['syntastic-markdown-mdl']
let g:syntastic_json_checkers = ['syntastic-json-jsonlint']
let g:syntastic_dockerfile_checkers = ['syntastic-dockerfile-dockerfile_lint']
let g:syntastic_python_checkers = ['syntastic-python-prospector']
let g:syntastic_yaml_checkers = ['syntastic-yaml-yamllint']

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_eruby_ruby_quiet_messages =
    \ {"regex": "possibly useless use of a variable in void context"}

" Configure vim-auto-save plugin (https://github.com/vim-scripts/vim-auto-save)
let g:auto_save = 1
let g:auto_save_silent = 1          " Do not display the auto-save notification
let g:auto_save_no_updatetime = 1   " do not change the 'updatetime' option

" Configure vim-tmux-navigator (https://github.com/christoomey/vim-tmux-navigator)
let g:tmux_navigator_save_on_switch = 2

" Configure ansible-vim
let g:ansible_unindent_after_newline = 1            " Unindent after two newlines
let g:ansible_extra_syntaxes = "sh.vim cfg.vim"     " Syntax highlight with the native language for *.j2 files
let g:ansible_attribute_highlight = "ad"            " Dim all instances of key=
let g:ansible_name_highlight = "b"                  " Brighten name: if at start

" Configure vim-lastplace (https://github.com/farmergreg/vim-lastplace)
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"     " Always put cursor at top when opening these files
let g:lastplace_ignore_buftype = "quickfix,nofile,help"

" Configure vim-diminactive (https://github.com/blueyed/vim-diminactive)
let g:diminactive_use_syntax = 1
let g:diminactive_use_colorcolumn = 0
let g:diminactive_enable_focus = 1


" Enable lifepillar/vim-solarized8 color scheme
syntax enable
set background=dark
colorscheme solarized8_dark_low
"let g:solarized_term_italics = 1

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
    let limit = 4
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
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile *sudoers-* set filetype=sudoers

  " Set syntax highlighting for specific directories
  " autocmd BufRead,BufNewFile ~/dev/measurabl/src/orchestration/* set syntax=ansible   " this is set in the project's `.vimrc`

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

  " Remove trailing whitespace on save
  autocmd InsertEnter,InsertLeave * :call <SID>StripTrailingWhitespaces()
augroup END

" Remove trailing whitespace and return cursor to starting position
function! <SID>StripTrailingWhitespaces()
    let l = line('.')
    let c = col('.')
    %s/\s\+$//e
    call cursor(l, c)
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

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

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
