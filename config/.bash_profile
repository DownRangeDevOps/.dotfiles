# shellcheck disable=SC1090,SC1091  # ignore refusal to follow dynamic paths

# - We should not use unbound variables
# - We should ensure pipelines fail if commands within them fail
set -uo pipefail

# Globals
BREW_PREFIX="$(brew --prefix)" && export BREW_PREFIX

# Use my ncurses and terminfo
PATH="${BREW_PREFIX}/opt/ncurses/bin:$PATH" && export PATH
TERMINFO=~/.local/share/terminfo && export TERMINFO
TERMINFO_DIRS=~/.local/share/terminfo && export TERMINFO_DIRS

# History
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoredups:ignorespace # don't put duplicate lines in the history

shopt -s histappend # append
shopt -s checkwinsize # check the win size after each command and update if necessary
history -a # append
history -n # read new lines and append

# Use vi mode on command line
set -o vi
bind '"jj":vi-movement-mode'

# Disable flow control commands (keeps C-s from freezing everything)
stty -ixon

# Load everything else
source ~/.dotfiles/bash-helpers/bash.sh
