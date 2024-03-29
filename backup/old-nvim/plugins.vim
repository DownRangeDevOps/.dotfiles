call plug#begin()
" Auto-complete/LSP
" Better to load these first
Plug 'ncm2/ncm2'       " https://github.com/ncm2/ncm2
Plug 'roxma/nvim-yarp' " https://github.com/roxma/nvim-yarp

" Then these
Plug 'ObserverOfTime/ncm2-jc2'                               " https://github.com/ObserverOfTime/ncm2-jc2
Plug 'Shougo/neco-syntax'                                    " https://github.com/Shougo/neco-syntax
Plug 'fgrsnau/ncm2-otherbuf'                                 " https://github.com/fgrsnau/ncm2-otherbuf
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' } " https://github.com/heavenshell/vim-pydocstring
Plug 'jbmorgado/vim-pine-script'                             " https://github.com/jbmorgado/vim-pine-script
Plug 'ncm2/ncm2-bufword'                                     " https://github.com/ncm2/ncm2-bufword
Plug 'ncm2/ncm2-cssomni'                                     " https://github.com/ncm2/ncm2-cssomni
Plug 'ncm2/ncm2-go'                                          " https://github.com/ncm2/ncm2-go
Plug 'ncm2/ncm2-jedi'                                        " https://github.com/ncm2/ncm2-jedi
Plug 'ncm2/ncm2-path'                                        " https://github.com/ncm2/ncm2-path
Plug 'ncm2/ncm2-syntax'                                      " https://github.com/ncm2/ncm2-syntax
Plug 'ncm2/ncm2-tern'                                        " https://github.com/ncm2/ncm2-tern
Plug 'ncm2/ncm2-vim'                                         " https://github.com/ncm2/ncm2-vim
Plug 'neovim/nvim-lspconfig'                                 " https://github.com/neovim/nvim-lspconfig
Plug 'phpactor/ncm2-phpactor'                                " https://github.com/phpactor/ncm2-phpactor
Plug 'jose-elias-alvarez/null-ls.nvim'                       " https://github.com/jose-elias-alvarez/null-ls.nvim
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'                  " https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils

" Snippits integration
Plug 'SirVer/ultisnips'    " https://github.com/SirVer/ultisnips
Plug 'honza/vim-snippets'  " https://github.com/honza/vim-snippets
Plug 'ncm2/ncm2-ultisnips' " Requires utilisnips - https://github.com/ncm2/ncm2-ultisnips

" Taging
Plug 'majutsushi/tagbar' " https://github.com/majutsushi/tagbar

" Linting
Plug 'neomake/neomake'                                     " https://github.com/neomake/neomake
Plug 'Vimjas/vint'                                         " https://github.com/Vimjas/vint
Plug 'psliwka/vim-dirtytalk', { 'do': ':DirtytalkUpdate' } " https://github.com/psliwka/vim-dirtytalk

" Helpers
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': 'python' } " https://github.com/heavenshell/vim-pydocstring
Plug 'github/copilot.vim'                                                     " https://docs.github.com/en/copilot/getting-started-with-github-copilot?tool=vimneovim
Plug 'folke/which-key.nvim'                                                   " https://github.com/folke/which-key.nvim

" Utilities
" Plug 'Xuyuanp/nerdtree-git-plugin'                     " https://github.com/Xuyuanp/nerdtree-git-plugin
" Plug 'tpope/vim-vinegar'                               " https://github.com/tpope/vim-vinegar
" Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " https://github.com/scrooloose/nerdtree
Plug 'juanibiapina/vim-lighttree'         " https://github.com/juanibiapina/vim-lighttree
Plug 'preservim/vim-lexical'              " https://github.com/preservim/vim-lexical
Plug 'preservim/vim-pencil'               " https://github.com/preservim/vim-pencil
Plug 'preservim/vim-wordy'                " https://github.com/preservim/vim-wordy
Plug '/usr/local/opt/fzf'                 " https://github.com//usr/local/opt/
Plug 'airblade/vim-gitgutter'             " https://github.com/airblade/vim-gitgutter
Plug 'arithran/vim-delete-hidden-buffers' " https://github.com/arithran/vim-delete-hidden-buffers
Plug 'dbakker/vim-projectroot'            " https://github.com/dbakker/vim-projectroot
Plug 'drmingdrmer/vim-toggle-quickfix'    " https://github.com/drmingdrmer/vim-toggle-quickfix
" Plug 'easymotion/vim-easymotion'          " https://github.com/easymotion/vim-easymotion
Plug 'junegunn/fzf.vim'                   " https://github.com/junegunn/fzf.vim
Plug 'mzlogin/vim-markdown-toc'           " https://github.com/mzlogin/vim-markdown-toc
Plug 'rizzatti/dash.vim'                  " https://github.com/rizzatti/dash.
Plug 'stefandtw/quickfix-reflector.vim'   " https://github.com/stefandtw/quickfix-reflector.vim
Plug 'svermeulen/vim-easyclip'            " https://github.com/svermeulen/vim-easyclip
Plug 'tpope/vim-abolish'                  " https://github.com/tpope/vim-abolish
Plug 'tpope/vim-fugitive'                 " https://github.com/tpope/vim-fugitive
Plug 'vim-scripts/vim-auto-save'          " https://github.com/vim-scripts/vim-auto-save
Plug 'zhimsel/vim-stay'                   " https://github.com/zhimsel/vim-stay
Plug 'AndrewRadev/linediff.vim'           " https://github.com/AndrewRadev/linediff.vim

" Previewers
Plug 'FuDesign2008/mermaidViewer.vim'                                   " https://github.com/FuDesign2008/mermaidViewer.vim
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' } " https://github.com/iamcco/markdown-preview.nvim

" UI
Plug 'Konfekt/FastFold'                " https://github.com/Konfekt/FastFold
Plug 'digitalrounin/vim-yaml-folds'    " https://github.com/digitalrounin/vim-yaml-folds
Plug 'gcmt/taboo.vim'                  " https://github.com/gcmt/taboo.vim
Plug 'itchyny/lightline.vim'           " https://github.com/itchyny/lightline.vim
Plug 'nathanaelkane/vim-indent-guides' " https://github.com/nathanaelkane/vim-indent-guides
Plug 'tmhedberg/SimpylFold'            " https://github.com/tmhedberg/SimpylFold
Plug 'zk4/vim-iterm2-navigator'        " https://github.com/zk4/vim-iterm2-navigator

" Syntax dependencies (must load before dependent syntax plugins)
Plug 'godlygeek/tabular' " https://github.com/godlygeek/tabular

" Syntax
Plug 'Vimjas/vim-python-pep8-indent'         " https://github.com/Vimjas/vim-python-pep8-indent
Plug 'aliou/bats.vim'                        " https://github.com/aliou/bats.vim
Plug 'burnettk/vim-jenkins'                  " https://github.com/burnettk/vim-jenkins
Plug 'chr4/nginx.vim'                        " https://github.com/chr4/nginx.vim
Plug 'danielb2/vim-pine-script'              " https://github.com/danielb2/vim-pine-script
Plug 'ekalinin/Dockerfile.vim'               " https://github.com/ekalinin/Dockerfile.vim
Plug 'hashivim/vim-terraform'                " https://github.com/hashivim/vim-terraform
Plug 'moderndatainc/vim-snowflakesql-syntax' " https://github.com/moderndatainc/vim-snowflakesql-syntax
Plug 'mpyatishev/vim-sqlformat'              " https://github.com/mpyatishev/vim-sqlformat
Plug 'pboettch/vim-cmake-syntax'             " https://github.com/pboettch/vim-cmake-syntax
Plug 'pearofducks/ansible-vim'               " https://github.com/pearofducks/ansible-vim
Plug 'preservim/vim-markdown'                " https://github.com/preservim/vim-markdown
Plug 'stephpy/vim-yaml'                      " https://github.com/stephpy/vim-yaml
Plug 'powerman/vim-plugin-AnsiEsc'           " https://github.com/powerman/vim-plugin-AnsiEsc

" Formatting
Plug 'dhruvasagar/vim-table-mode'           " https://github.com/dhruvasagar/vim-table-mode
Plug 'editorconfig/editorconfig-vim'        " https://github.com/editorconfig/editorconfig-vim
Plug 'fannheyward/coc-markdownlint'         " https://github.com/fannheyward/coc-markdownlint
Plug 'fisadev/vim-isort', { 'on': 'Isort' } " https://github.com/fisadev/vim-isort
Plug 'jiangmiao/auto-pairs'                 " https://github.com/jiangmiao/auto-pairs
Plug 'junegunn/vim-easy-align'              " https://github.com/junegunn/vim-easy-align
Plug 'machakann/vim-sandwich'               " https://github.com/machakann/vim-sandwich
Plug 'scrooloose/nerdcommenter'             " https://github.com/scrooloose/nerdcommenter
Plug 'tpope/vim-repeat'                     " https://github.com/tpope/vim-repeat
Plug 'dkarter/bullets.vim'                  " https://github.com/dkarter/bullets.vim

" Thememing
Plug 'chriskempson/vim-tomorrow-theme' " https://github.com/chriskempson/vim-tomorrow-theme
call plug#end()
