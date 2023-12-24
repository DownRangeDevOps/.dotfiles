# shellcheck shell=bash disable=SC1090,SC1091  # ignore refusal to follow dynamic paths

# Reset path to always start fresh
export PATH=""

set +ua
source /etc/profile # Set default paths
set -ua

# Set base Homebrew paths
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Globals
export DOTFILES_PREFIX="${HOME}/.dotfiles"
export BASH_D_PATH="${DOTFILES_PREFIX}/bash.d"
export PATH="${DOTFILES_PREFIX}/bin:${PATH}" # my bins

# Load logger or overload with no-op
if [[ ${DEBUG:-} -eq 1 ]]; then
    function basename() {
        "${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin/basename" "$@"
    }

    set +ua
    [[ -f "${HOME}/.dotfiles/lib/log.sh" ]] && "${HOME}/.dotfiles/lib/log.sh"
    set -ua
    log debug ""
    log debug "[${BASH_SOURCE[0]}]"
else
    log_sh_args=("info" "warn" "error" "debug")
    function log() {
        if [[ "${log_sh_args[*]}" =~ ${1:-} ]]; then
            true
        else
            log "$@"
        fi
    }
fi

# -a: Export all functions to make them available in sub-shells
# -u: We should not use unbound variables
# -o pipefile: We should ensure pipelines fail if commands within them fail
#
# WARNING: Unset with +a and +u before sourcing third party libraries or they
# will export functions and throw errors
set -uao pipefail

# Disable flow control commands (keeps C-s from freezing everything)
stty -ixon 2>/dev/null

# Load everything else
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

[[ -f "${BASH_D_PATH}/lib.sh" ]] && source "${BASH_D_PATH}/lib.sh"
safe_source "${BASH_D_PATH}/path.sh"
safe_source "${BASH_D_PATH}/bash.sh"
safe_source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"

# .bashrc
if [[ -f "${HOME}/.bashrc" ]]; then
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading .bashrc..."
    fi

    safe_source "${HOME}/.bashrc"

    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "${BASH_SOURCE[0]}")]: Done."
    fi
fi

# Disable strictness
set +uao pipefail

log debug "[$(basename "${BASH_SOURCE[0]}")]: Done, .bash_profile loaded."

# vi: ft=sh
