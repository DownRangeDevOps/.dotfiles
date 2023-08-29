# shellcheck disable=SC1090,SC1091  # ignore refusal to follow dynamic paths

# - We should not use unbound variables
# - We should ensure pipelines fail if commands within them fail
set -uo pipefail

# Globals
BREW_PREFIX="$(brew --prefix)" && export BREW_PREFIX

# Use my term
PATH="${BREW_PREFIX}/opt/ncurses/bin:$PATH" && export PATH
TERMINFO=~/.local/share/terminfo && export TERMINFO
TERMINFO_DIRS=~/.local/share/terminfo && export TERMINFO_DIRS

# Setup shell
source ~/.dotfiles/bash-helpers/bash_profile.sh
