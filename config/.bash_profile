# shellcheck disable=SC1090,SC1091  # ignore refusal to follow dynamic paths

# - We should not use unbound variables
# - We should ensure pipelines fail if commands within them fail
set -uo pipefail

# Use my term
export PATH="$(brew --prefix)/opt/ncurses/bin:$PATH"
export TERMINFO=~/.local/share/terminfo
export TERMINFO_DIRS=~/.local/share/terminfo

# Setup shell
source ~/.dotfiles/bash-helpers/bash_profile.sh
