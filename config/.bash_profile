# shellcheck disable=SC1090,SC1091  # ignore refusal to follow dynamic paths

# - We should not use unbound variables
# - We should ensure pipelines fail if commands within them fail
set -uo pipefail

if [[ ${DEBUG:-} -eq 1 ]]; then
    source "${HOME}/.dotfiles/lib/log.sh"
else
    function log() {
        true
    }
fi

log debug ""
log debug "[${BASH_SOURCE[0]}]"

# Globals
BREW_PREFIX="$(brew --prefix)" && export BREW_PREFIX
export DOTFILES_PREFIX="${HOME}/.dotfiles"
export BASH_D_PATH="${DOTFILES_PREFIX}/bash.d"

# Use my ncurses and terminfo
export PATH="${BREW_PREFIX}/opt/ncurses/bin:$PATH"
export TERMINFO=~/.local/share/terminfo
export TERMINFO_DIRS=~/.local/share/terminfo

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
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."
source "${BASH_D_PATH}/lib.sh"
source "${BASH_D_PATH}/path.sh"
source "${BASH_D_PATH}/bash.sh"

set +u

log debug "[$(basename "${BASH_SOURCE[0]}")]: Done, .bash_profile loaded."
