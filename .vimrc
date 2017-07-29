" Setup Vundle plugin manager
so ~/.dotfiles/.vundler

" Configure vim-jedi plugin (https://github.com/davidhalter/jedi-vim)
let g:jedi#use_splits_not_buffers = "left"

" Prefrences
filetype plugin indent on       " Enable file type detection and do language-dependent indenting.
hi ColorColumn ctermbg=10       " Set the color of right margin marker
set autochdir                   " Auto change working directory to that of the current file
set autowrite                   " Automatically :write before running commands
set backspace=2                 " Backspace deletes like most programs in insert mode
set backspace=indent,eol,start  " Make backspace behave in a sane manner.
set colorcolumn=81              " Make it obvious where 80 characters is
set complete+=kspell            " Autocomplete with dictionary words when spell check is on
set diffopt+=vertical           " Always use vertical diffs
set history=50                  " store command history across sessions
set hlsearch                    " hilight search matches
set incsearch                   " do incremental searching
set list listchars=tab:»·,trail:·,nbsp:·
set noshowmode                  " hide the mode status line
set nowrap                      " Don't wrap lines in the display
set ruler                       " show the cursor position all the time
set showbreak=↳\ \ \>           " Indicate wraped lines
set showcmd                     " display incomplete commands
set splitbelow                  " Open new split panes to the right/bottom
set splitright
set swapfile                    " use a swap file
set timeoutlen=500              " set a short leader timeout
set dir=~/tmp                   " set where swapfile(s) are stored
let g:ctrlp_working_path_mode='ra'
let NERDTreeShowHidden=1        " Show NERDTree

" Tabbing prefrences
set tabstop=4
set shiftwidth=4
set softtabstop=4
set shiftround
set expandtab

" Relitive line numbers
set number
set relativenumber
set numberwidth=5

" Key mappings
let mapleader=' '
inoremap <C-@> <C-Space>|                           " Get to next editing point after autocomplete
inoremap jj <Esc>|                                  " Easy escape from insert/visual mode
noremap <D-v> :set paste<CR>o<exc>"*]p nopaste<cr>| " Paste from external source, copy to external source
set pastetoggle=<F2>                                " Toggle paste mode
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>| " Replace selected text
nnoremap <CR> :noh<CR><CR>|                         " Clear search pattern matches with return
noremap <leader>1 :NERDTreeToggle<CR>               " Toggle NERDTree

" Use The Silver Searcher if it is installed
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Configure Syntastic plugin (https://github.com/vim-syntastic/syntastic)
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_eruby_ruby_quiet_messages =
    \ {"regex": "possibly useless use of a variable in void context"}

" Enable lifepillar/vim-solarized8 color scheme
syntax enable
set background=dark
colorscheme solarized8_dark

" Configure lightline status bar
set laststatus=2
let g:lightline = {
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

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  " Remove trailing whitespace on save
  autocmd BufWritePre * %s/\s\+$//e
augroup END

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
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
