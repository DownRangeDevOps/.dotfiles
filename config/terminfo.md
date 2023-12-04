# How I got undercurl in iTerm2/xterm/Neovim

```sh
brew install ncurses
infocmp -x xterm-256color > xterm256color.terminfo
infocmp -x tmux-256color > tmux-256color.terminfo
infocmp -x iterm2 > iterm2.terminfo
```

Edit files, add: `Smulx=\E[4:%p1%dm,` after `smul` capability

```sh
tic -x xterm256color.terminfo
tic -x tmux-256color.terminfo
tic -x iterm2.terminfo
```

Add to .bash_profile or whatever your login shell sources on start

```sh
# Use my ncurses and terminfo
export PATH="${HOMEBREW_PREFIX}/opt/ncurses/bin:$PATH"
export TERMINFO=~/.local/share/terminfo
export TERMINFO_DIRS=~/.local/share/terminfo
```

Neovim config

```lua
-- Terminal
vim.opt.termguicolors = true -- Use 24-bit colors

-- Terminal app controls cursor
vim.opt.guicursor = ""

-- Neovim controls cusror
vim.opt.guicursor = table.concat({
    "n-c-v-sm:block",
    "i-ci-ve:ver25",
    "r-cr-o:hor20",
    "a:blinkwait0-blinkoff500-blinkon500-Cursor/lCursor",
}, ",")
```

See infocmp --help and tic --help for info
